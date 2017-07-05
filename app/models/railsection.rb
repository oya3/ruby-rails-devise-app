class Railsection < ActiveRecord::Base
  belongs_to :railsectionable, polymorphic: true
  has_many :railsection_railways
  has_many :railways, :through => :railsection_railways
end
