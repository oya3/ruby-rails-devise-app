class Section < ActiveRecord::Base
  belongs_to :sectionable, polymorphic: true
end
