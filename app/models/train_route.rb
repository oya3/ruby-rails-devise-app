class TrainRoute < ActiveRecord::Base
  has_and_belongs_to_many :stations

  validates :code, uniqueness: true
end
