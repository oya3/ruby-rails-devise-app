class CreateRailsections < ActiveRecord::Migration[7.0]
  def change
    create_table :railsections do |t|
      t.text :name
      # t.references :railsectionable, polymorphic: true, index: true
      t.integer :railsectionable_id
      t.string :railsectionable_type

      t.timestamps null: false
    end
    add_index :railsections, [:railsectionable_type, :railsectionable_id], :name=>'index_railsections_00'
  end
end
