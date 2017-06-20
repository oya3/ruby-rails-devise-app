# coding: utf-8
class TrainRouteStation < ActiveRecord::Base
  belongs_to :train_route
  belongs_to :station
  include RankedModel
  ranks :row_order,
        :with_same => :train_route_id
  
  default_scope { order(:row_order) }
  # validates :distance, presence: true # nil許可するため
  # validates :row_order, presence: true, numericality: true
  validates :station, presence: true
end
