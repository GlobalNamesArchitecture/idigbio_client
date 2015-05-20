require "json"
require "logger"
require "rest_client"
require "idigbio_client/version"
require "idigbio_client/helper"
require "idigbio_client/search"

# Ruby wrapper for iDigBio API
module IdigbioClient
  URL = "https://beta-search.idigbio.org/v2/"
  MAX_LIMIT = 100_000
  DEFAULT_LIMIT = 100
  HEADERS = { content_type: :json, accept: :json }
  extend Helper

  class << self
    def search(opts)
      Search.search(opts)
    end

    def logger
      @logger ||= Logger.new($stdout)
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
  end
end
