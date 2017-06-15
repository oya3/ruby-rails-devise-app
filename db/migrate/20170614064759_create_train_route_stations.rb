class CreateTrainRouteStations < ActiveRecord::Migration
  def change
    create_table :train_route_stations do |t|
      t.references :train_route, index: true, foreign_key: true
      t.references :station, index: true, foreign_key: true
      t.integer :row_order
      t.integer :distance

      t.timestamps null: false
    end
  end
end
