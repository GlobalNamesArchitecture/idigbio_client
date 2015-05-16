# Ruby wrapper for iDigBio API
module IdigbioClient
  class << self
    def count_records(params = {})
      res = query(path: "summary/count/records/", params: params)
      res ? res[:itemCount] : nil
    end
  end
end
