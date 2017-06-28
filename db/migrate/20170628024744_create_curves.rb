class CreateCurves < ActiveRecord::Migration
  def change
    create_table :curves do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
