# coding: utf-8
class TrainRoute < ActiveRecord::Base
  has_many :train_route_stations, dependent: :destroy
  accepts_nested_attributes_for :train_route_stations,
                                allow_destroy: true,
                                reject_if: :all_blank # オールブランクなら無視（バリデーションも働かない）

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
