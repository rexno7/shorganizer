class Show < ActiveRecord::Base
  has_many :episodes, dependent: :destroy
  validates :scrape_url, uniqueness:true
  
end
