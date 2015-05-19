# Ruby wrapper for iDigBio API
module IdigbioClient
  class << self
    def types
      %w(records mediarecords recordsets publishers)
    end

    def fields(type = "records")
      type = normalize_type(type)
      query(path: "meta/fields/#{type}", method: :get)
    end
  end
end
