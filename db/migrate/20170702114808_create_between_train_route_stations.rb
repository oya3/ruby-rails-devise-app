class CreateBetweenTrainRouteStations < ActiveRecord::Migration
  def change
    create_table :between_train_route_stations do |t|
      t.references :train_route_station1, index: true, foreign_key: true
      t.references :train_route_station2, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
