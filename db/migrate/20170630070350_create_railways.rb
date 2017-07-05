class CreateRailways < ActiveRecord::Migration
  def change
    create_table :railways do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
