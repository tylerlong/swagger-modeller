class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :specification_id, null: false
      t.string :name, null: false
      t.string :description, null: false
      t.timestamps null: false
    end
    add_index :permissions, [:specification_id, :name], unique: true
  end
end
