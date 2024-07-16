class Article < ActiveRecord::Base
  validates_presence_of :text

  scope :by_text, ->(query) { where('LOWER(text) LIKE ?', "%#{query.try(:downcase)}%").order(created_at: :desc) }
end
