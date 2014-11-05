class Episode < ActiveRecord::Base
  belongs_to :show
  validates :no, presence: true
  validates :show_id, presence: true
  
  def self.view_start
    Date.today-3
  end
  def self.view_end
    Date.today+5
  end
  scope :upcoming, -> (time) { where("air_date >= ?", time) }
  scope :week_view, -> (r_start, r_end) { where("air_date >= ? and air_date <= ?", r_start, r_end) }
end
