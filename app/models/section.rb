class Section < ActiveRecord::Base
  belongs_to :sectionable, polymorphic: true
  has_many :section_curves
  has_many :curves, :through => :section_curves
end
