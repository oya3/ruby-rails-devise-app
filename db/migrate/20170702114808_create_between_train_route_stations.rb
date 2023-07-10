class CreateBetweenTrainRouteStations < ActiveRecord::Migration[7.0]
  def change
    create_table :between_train_route_stations do |t|
      # t.references :train_route_station1, index: true, foreign_key: true
      # t.references :train_route_station2, index: true, foreign_key: true
      t.references :train_route_station1, index: true, foreign_key: { to_table: :train_route_stations }
      t.references :train_route_station2, index: true, foreign_key: { to_table: :train_route_stations }
      t.timestamps null: false
    end
  end
end
