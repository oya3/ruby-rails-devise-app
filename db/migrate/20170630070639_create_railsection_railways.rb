class CreateRailsectionRailways < ActiveRecord::Migration
  def change
    create_table :railsection_railways do |t|
      t.references :railsection, index: true, foreign_key: true
      t.references :railway, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
