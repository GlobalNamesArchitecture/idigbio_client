# Ruby wrapper for iDigBio API
module IdigbioClient
  class << self
    def count(opts = {})
      opts = { type: "record", params: {} }.merge(opts)
      res = query(path: "summary/count/#{opts[:type]}s/", params: opts[:params])
      res ? res[:itemCount] : nil
    end
  end
end
