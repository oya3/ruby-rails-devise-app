class CreateRailways < ActiveRecord::Migration[7.0]
  def change
    create_table :railways do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
