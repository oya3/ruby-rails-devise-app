class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.references :railway, index: true, foreign_key: true
      t.decimal :lat, precision: 11, scale: 8
      t.decimal :lng, precision: 11, scale: 8

      t.timestamps null: false
    end
  end
end
