class CreateDistances < ActiveRecord::Migration
  def change
    create_table :distances do |t|
      t.references :station, index: true, foreign_key: true
      t.references :station, index: true, foreign_key: true
      t.integer :distance

      t.timestamps null: false
    end
  end
end
