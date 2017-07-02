# coding: utf-8
class BetweenTrainRouteStation < ActiveRecord::Base
  has_many :railsections, as: :railsectionable # 駅間カーブ情報
  belongs_to :train_route_station1, :class_name => "TrainRouteStation"
  belongs_to :train_route_station2, :class_name => "TrainRouteStation"
end
