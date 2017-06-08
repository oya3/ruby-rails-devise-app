class Station < ActiveRecord::Base
  has_and_belongs_to_many :train_routes

  validates :code, uniqueness: true
end
