class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.integer :specification_id, null: false
      t.string :uri, null: false
      t.timestamps null: false
    end
    add_index :paths, [:specification_id, :uri], unique: true
  end
end
