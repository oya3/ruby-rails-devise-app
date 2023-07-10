class CreateStations < ActiveRecord::Migration[7.0]
  def change
    create_table :stations do |t|
      t.integer :code
      t.string :name

      t.timestamps null: false
    end
    add_index :stations, :code, unique: true
  end
end
