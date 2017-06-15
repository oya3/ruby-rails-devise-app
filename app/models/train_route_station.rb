# coding: utf-8
class TrainRouteStation < ActiveRecord::Base
  include RankedModel
  ranks :row_order
  belongs_to :train_route
  belongs_to :station

  # validates :distance, presence: true # nil許可するため
  # validates :row_order, presence: true, numericality: true
  validates :station, presence: true
end
