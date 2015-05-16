# Ruby wrapper for iDigBio API
module IdigbioClient
  class << self
    def fields(type = "records")
      types = %w(records mediarecords recordsets publishers)
      unless types.include?(type)
        fail "Unknown type #{type}. Types: '#{types.join(', ')}'"
      end
      query(path: "meta/fields/#{type}", method: :get)
    end
  end
end
