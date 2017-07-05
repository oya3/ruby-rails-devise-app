class Railway < ActiveRecord::Base
  has_many :railsection_railways
  has_many :railsections, :through => :railsection_railways
  has_many :points
end
