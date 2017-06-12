class CreateDistances < ActiveRecord::Migration
  def change
    create_table :distances do |t|
      t.references :departure_station, null: false
      t.references :destination_station, null: false
      t.integer :distance

      t.timestamps null: false
    end
    add_foreign_key :distances, :stations, column: :departure_station_id
    add_foreign_key :distances, :stations, column: :destination_station_id
  end
end
