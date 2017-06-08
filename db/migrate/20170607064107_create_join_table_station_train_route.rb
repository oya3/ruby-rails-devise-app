class CreateJoinTableStationTrainRoute < ActiveRecord::Migration
  def change
    create_join_table :stations, :train_routes do |t|
      # t.index [:station_id, :train_route_id]
      # t.index [:train_route_id, :station_id]
    end
  end
end
