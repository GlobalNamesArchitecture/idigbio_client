module IdigbioClient
  # Private internal methods
  module Helper
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
      return type if IdigbioClient.types.include?(type)
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
