class CreateDefinitions < ActiveRecord::Migration
  def change
    create_table :definitions do |t|
      t.integer :specification_id, null: false
      t.string :name, null: false
      t.string :description
      t.timestamps null: false
    end
    add_index :definitions, [:specification_id, :name], unique: true
  end
end
