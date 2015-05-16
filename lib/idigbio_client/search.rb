# Ruby wrapper for iDigBio API
module IdigbioClient
  class << self
    def search(opts)
      opts = prepare_opts(opts)
      resp = paginate(opts)
      block_given? ? yield(resp) : resp
    end

    private

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

    def prepare_opts(opts)
      symbolize(opts)
      opts = { type: :records, method: :post, params: {} }.merge(opts)
      opts[:params] = { rq: {}, limit: DEFAULT_LIMIT, offset: 0, fields: [],
                        fields_exclude: [], sort: [] }.merge(opts[:params])
      opts[:path] = prepare_path(opts[:type])
      opts
    end

    def prepare_path(type)
      types = [:records, :media]
      unless types.include?(type.to_sym)
        fail "Unknown search type '#{type}'. Types: '#{types.join(', ')}'"
      end
      "search/#{type}/"
    end

    def adjust_params(resp, params)
      logger_write(resp, params)
      params[:items_to_go] ||= [MAX_LIMIT, resp[:itemCount], params[:limit]].min
      params[:offset] += resp[:items].size
      params[:items_to_go] -= resp[:items].size
    end

    def logger_write(resp, params)
      s = params[:offset] + 1
      e = [params[:offset] + resp[:items].size, params[:limit]].min
      logger.info("Processed items #{s}-#{e} out of #{params[:limit]}")
    end
  end
end
