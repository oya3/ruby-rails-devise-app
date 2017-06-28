class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.text :name
      t.references :sectionable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
