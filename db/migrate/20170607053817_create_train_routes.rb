class CreateTrainRoutes < ActiveRecord::Migration[7.0]
  def change
    create_table :train_routes do |t|
      t.integer :code
      t.string :name

      t.timestamps null: false
    end
    add_index :train_routes, :code, unique: true
  end
end
