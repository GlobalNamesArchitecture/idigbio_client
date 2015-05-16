require "json"
require "logger"
require "rest_client"
require "idigbio_client/version"

# Ruby wrapper for iDigBio API
module IdigbioClient
  URL = "https://beta-search.idigbio.org/v2/"
  MAX_LIMIT = 100_000
  DEFAULT_LIMIT = 100
  HEADERS = { content_type: :json, accept: :json }

  class << self
    def logger
      @logger ||= Logger.new($stdout)
    end

    def search(opts)
      opts = prepare_opts(opts)
      resp = paginate(opts)
      block_given? ? yield(resp) : resp
    end

    def uuid(uuid, type = nil)
      types = %i(record mediarecord recordset publisher)
      unless type.nil? || types.include?(type.to_sym)
        fail "Unknown type '#{type}'. Types: '#{types.join("', '")}'"
      end
      type ? find_uuid(uuid, [type]) : find_uuid(uuid, types)
    end

    def fields(type = "records")
      types = %w(records mediarecords recordsets publishers)
      unless types.include?(type)
        fail "Unknown type #{type}. Types: '#{types.join(', ')}'"
      end
      query(path: "meta/fields/#{type}", method: :get)
    end

    private

    def query(opts)
      opts = { method: "post" }.merge(opts)
      url = URL + opts[:path]
      params = opts[:params]
      resp = post?(opts[:method]) ? post(url, params) : get(url, params)
      resp = JSON.parse(resp.body, symbolize_names: true) if resp
      sleep(0.3)
      block_given? ? yield(resp) : resp
    end

    def paginate(opts)
      items = []
      params = opts[:params]
      while params[:items_to_go].nil? || params[:items_to_go] > 0
        resp = query(opts)
        items += resp[:items] if resp[:itemCount] > 0
        adjust_params(resp, params)
      end
      resp[:items] = items[0...params[:limit]]
      resp
    end

    def prepare_opts(opts)
      symbolize(opts)
      opts = { type: :records, method: :post, params: {} }.merge(opts)
      opts[:params] = { rq: {}, limit: DEFAULT_LIMIT, offset: 0, fields: [],
                        fields_exclude: [], sort: [] }.merge(opts[:params])
      opts[:path] = prepare_path(opts[:type])
      opts
    end

    def prepare_path(type)
      types = %i(records media)
      unless types.include?(type.to_sym)
        fail "Unknown search type '#{type}'. Types: '#{types.join(', ')}'"
      end
      "search/#{type}/"
    end

    def adjust_params(resp, params)
      logger_write(resp, params)
      params[:items_to_go] ||= [MAX_LIMIT, resp[:itemCount], params[:limit]].min
      params[:offset] += resp[:items].size
      params[:items_to_go] -= resp[:items].size
    end

    def post?(method)
      !method.to_s.match(/get/i)
    end

    def post(url, params)
      params = HEADERS.merge(params: params.to_json)
      RestClient.post(url, params) do |resp, _req, _res|
        resp.code == 200 ? resp : nil
      end
    end

    def get(url, params)
      params = HEADERS.merge(query: params.to_json)
      RestClient.get(url, params) do |resp, _req, _res|
        resp.code == 200 ? resp : nil
      end
    end

    def symbolize(h)
      h.keys.each do |k|
        sym = k.to_sym
        h[sym] = h.delete(k)
        symbolize(h[sym]) if h[sym].is_a? Hash
      end
    end

    def find_uuid(uuid, types)
      types.each do |type|
        path = "view/#{type}s/#{uuid}"
        res = query(path: path, method: :get)
        return res if res
      end
    end

    def logger_write(resp, params)
      s = params[:offset] + 1
      e = [params[:offset] + resp[:items].size, params[:limit]].min
      logger.info("Processed items #{s}-#{e} out of #{params[:limit]}")
    end
  end
end
