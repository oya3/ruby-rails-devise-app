# coding: utf-8
class TrainRouteStation < ActiveRecord::Base
  belongs_to :train_route
  belongs_to :station
  include RankedModel
  ranks :row_order,
        :with_same => :train_route_id
  
  # default_scope { group(:train_route) }
  # default_scope { order(:row_order) }
  
  # row_order 順
  scope :ordered_by_row_order, -> { order(:row_order) }
  # belongs_to の train_routes.code 順
  scope :ordered_by_train_route_code, -> { joins(:train_route).order('train_routes.code') }
  # belongs_to の :train_route を joins
  scope :with_train_route, -> { joins(:train_route) }
  # validates :distance, presence: true # nil許可するため
  # validates :row_order, presence: true, numericality: true
  validates :station, presence: true
end
