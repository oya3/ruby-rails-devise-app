class Curve < ActiveRecord::Base
  has_many :section_curves
  has_many :sections, :through => :section_curves
  
end
