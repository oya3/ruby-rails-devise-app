class CreatePoints < ActiveRecord::Migration[7.0]
  def change
    create_table :points do |t|
      t.references :railway, index: true, foreign_key: true
      t.decimal :lat, precision: 11, scale: 8
      t.decimal :lng, precision: 11, scale: 8

      t.timestamps null: false
    end
  end
end
