class TrainRouteStation < ActiveRecord::Base
  belongs_to :train_route
  belongs_to :station
end
