class Search < ActiveRecord::Base
  RECENT_TIME = 5.minutes

  validates_presence_of :query, :ip_address, :times

  validates :times, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_save :downcase_query
  after_save  :remove_exceeding_searches

  scope :recent_global, -> { order(updated_at: :desc).limit(100) }
  scope :recent_local,  ->(ip_address) { where(ip_address: ip_address).order(updated_at: :desc).limit(100) }
  scope :trending, -> { where('updated_at > ?', RECENT_TIME.ago).group(:query).order('SUM(times) DESC').limit(100).sum(:times) }

  def increment_times
    recent? ? update(times: times + 1, updated_at: Time.now) : update(times: 1, updated_at: Time.now)
  end

  def recent?
    updated_at > RECENT_TIME.ago
  end

  private

  def downcase_query
    self.query = query.downcase
  end

  def remove_exceeding_searches
    return unless Search.where(ip_address: ip_address).count > 250

    Search.where(ip_address: ip_address).order(updated_at: :desc).offset(250).last.destroy
  end
end
