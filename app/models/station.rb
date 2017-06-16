class Station < ActiveRecord::Base
  has_many :train_route_stations, dependent: :destroy

  validates :code, uniqueness: true
  validates :name, presence: true
end
