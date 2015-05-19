require "json"
require "logger"
require "rest_client"
require "idigbio_client/version"
require "idigbio_client/search"
require "idigbio_client/show"
require "idigbio_client/inspect"
require "idigbio_client/stats"

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
  end
end
