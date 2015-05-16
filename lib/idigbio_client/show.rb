# Ruby wrapper for iDigBio API
module IdigbioClient
  class << self
    def show(uuid, type = nil)
      types = %i(record mediarecord recordset publisher)
      unless type.nil? || types.include?(type.to_sym)
        fail "Unknown type '#{type}'. Types: '#{types.join("', '")}'"
      end
      type ? find_uuid(uuid, [type]) : find_uuid(uuid, types)
    end

    def find_uuid(uuid, types)
      types.each do |type|
        path = "view/#{type}s/#{uuid}"
        res = query(path: path, method: :get)
        return res if res
      end
    end
  end
end
