class Show < ActiveRecord::Base
  has_many :episodes, dependent: :destroy
  accepts_nested_attributes_for :episodes, allow_destroy: true
  
  validates :scrape_url, uniqueness: true, presence: true
  validates :name, presence: true
  
end
