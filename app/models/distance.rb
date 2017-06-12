class Distance < ActiveRecord::Base
  belongs_to :departure_station, class_name: :Station
  belongs_to :destination_station, class_name: :Station

  validates :departure_station, presence: true, :uniqueness => { :scope => :destination_station_id }
  validates :destination_station, presence: true, :uniqueness => { :scope => :departure_station_id }
  validates :distance, presence: true
end
