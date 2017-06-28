class CreateSectionCurves < ActiveRecord::Migration
  def change
    create_table :section_curves do |t|
      t.references :section, index: true, foreign_key: true
      t.references :curve, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
