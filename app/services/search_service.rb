class SearchService
  def self.set_query(ip_address, query)
    return unless ip_address && query

    complement(ip_address, query) || Search.create(ip_address: ip_address, query: query)
  end

  private

  def self.complement(ip_address, query)
    previous = Search.where(ip_address: ip_address).order(:updated_at).last
    return unless previous

    downcased = query.downcase
    existent  = Search.where(ip_address: ip_address, query: downcased).first
    return existent.increment_times if existent
    return previous.update(query: query, times: previous.times, updated_at: Time.now) if downcased.start_with?(previous.query)
  end
end
