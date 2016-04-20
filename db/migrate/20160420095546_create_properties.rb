class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :definition_id, null: false
      t.string :name, null: false
      t.string :type, null: false
      t.string :extra
      t.string :description
      t.timestamps null: false
    end
    add_index :properties, [:definition_id, :name], unique: true
  end
end
