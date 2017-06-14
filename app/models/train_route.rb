class TrainRoute < ActiveRecord::Base
  has_many :train_route_stations, dependent: :destroy
  accepts_nested_attributes_for :train_route_stations,
                                allow_destroy: true,
                                reject_if: :all_blank

  validates :code, uniqueness: true
  validates :name, presence: true
end
