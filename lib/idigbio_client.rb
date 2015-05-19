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
      orig_offset = opts[:params][:offset]
      resp = paginate(opts)
      resp[:items] = resp[:items][0...(opts[:params][:limit] - orig_offset)]
      block_given? ? yield(resp) : resp
    end

    def show(uuid)
      query(path: "view/#{uuid}", method: :get)
    end

    def types
      %w(records mediarecords recordsets publishers)
    end

    def count(opts = {})
      opts = { type: "record", params: {} }.merge(opts)
      res = query(path: "summary/count/#{opts[:type]}s/", params: opts[:params])
      res ? res[:itemCount] : nil
    end

    def fields(type = "records")
      type = normalize_type(type)
      query(path: "meta/fields/#{type}", method: :get)
    end

    private

    def query(opts)
      url, params = url_params(opts)
      resp = post?(opts[:method]) ? post(url, params) : get(url, params)
      resp = JSON.parse(resp.body, symbolize_names: true) if resp
      sleep(0.3)
      block_given? ? yield(resp) : resp
    end

    def url_params(opts)
      opts = { method: "post" }.merge(opts)
      url = URL + opts[:path]
      params = HEADERS.merge(params: opts[:params].to_json)
      [url, params]
    end

    def post?(method)
      !method.to_s.match(/get/i)
    end

    def post(url, params)
      request(:post, url, params)
    end

    def get(url, params)
      params[:query] = params.delete(:params)
      request(:get, url, params)
    end

    def request(method, url, params)
      RestClient.send(method, url, params) do |resp, _req, _res|
        resp.code == 200 ? resp : nil
      end
    end

    def normalize_type(type)
      type = type.to_s
      return type if types.include?(type)
      sym_types = types.map { |t| ":#{t}" }.join(", ")
      fail "Unknown type :#{type}. Types: #{sym_types}"
    end

    def symbolize(h)
      h.keys.each do |k|
        sym = k.to_sym
        h[sym] = h.delete(k)
        symbolize(h[sym]) if h[sym].is_a? Hash
      end
    end

    def paginate(opts)
      items = []
      params = opts[:params]
      while params[:items_to_go].nil? || params[:items_to_go] > 0
        resp = query(opts)
        items += resp[:items] if resp[:itemCount] > 0
        adjust_params(resp, params)
      end
      resp[:items] = items
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
      type = normalize_type(type)
      type.gsub!("mediarecords", "media")
      "search/#{type}/"
    end

    def adjust_params(resp, params)
      logger_write(resp, params)
      params[:items_to_go] ||=
        [MAX_LIMIT, resp[:itemCount], params[:limit]].min - params[:offset]
      params[:offset] += resp[:items].size
      params[:items_to_go] -= resp[:items].size
    end

    def logger_write(resp, params)
      s = params[:offset] + 1
      e = [params[:offset] + resp[:items].size, params[:limit]].min
      logger.info("Processed items #{s}-#{e} out of #{params[:limit]}")
    end
  end
end
