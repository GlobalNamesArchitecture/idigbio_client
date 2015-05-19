# Ruby wrapper for iDigBio API
module IdigbioClient
  class << self
    def show(uuid)
      query(path: "view/#{uuid}", method: :get)
    end
  end
end
