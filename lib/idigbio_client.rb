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

    def logger_write(resp, params)
      s = params[:offset] + 1
      e = [params[:offset] + resp[:items].size, params[:limit]].min
      logger.info("Processed items #{s}-#{e} out of #{params[:limit]}")
    end

    def search(opts)
      opts = { path: "records/", method: "post", params: {} }.merge(opts)
      opts[:path] = "search/#{opts[:path]}"
      prepare_params(opts[:params])
      resp = paginate(opts)
      block_given? ? yield(resp) : resp
    end

    private

    def query(opts)
      opts = { method: "post" }.merge(opts)
      url = URL + opts[:path]
      params = opts[:params]
      resp = post?(opts[:method]) ? post(url, params) : get(url, params)
      resp = JSON.parse(resp.body, symbolize_names: true)
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

    def prepare_params(params)
      symbolize(params)
      params[:rq] ||= {}
      params[:limit] ||= DEFAULT_LIMIT
      params[:limit] = MAX_LIMIT if params[:limit] > MAX_LIMIT
      params[:offset] ||= 0
    end

    def adjust_params(resp, params)
      logger_write(resp, params)
      params[:items_to_go] ||= [MAX_LIMIT, resp[:itemCount], params[:limit]].min
      params[:offset] += resp[:items].size
      params[:items_to_go] -= resp[:items].size
    end

    def post?(method)
      method.to_s.match(/post/i)
    end

    def post(url, params)
      RestClient.post(url, HEADERS.merge(params: params.to_json))
    end

    def get(url, params)
      RestClient.get(url, HEADERS.merge(query: params.to_json))
    end

    def symbolize(h)
      h.keys.each do |k|
        sym = k.to_sym
        h[sym] = h.delete(k)
        symbolize(h[sym]) if h[sym].is_a? Hash
      end
    end
  end
end
