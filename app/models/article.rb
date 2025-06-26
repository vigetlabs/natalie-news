class Article < ApplicationRecord
  belongs_to :user
  before_validation :normalize_url
  validates :title, presence: true
  validates :url, presence: true
  private

  def normalize_url
    return if url.blank?

    self.url = url.strip
    unless url[%r{\Ahttps?://}]
      self.url = "https://#{url}"
    end
  end
end
