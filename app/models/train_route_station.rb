# coding: utf-8
class TrainRouteStation < ActiveRecord::Base
  belongs_to :train_route
  belongs_to :station

  # validates :distance, presence: true # nil許可するため
  validates :row_oder, presence: true, numericality: true
  validates :station, presence: true
end
