class CreatePathParameters < ActiveRecord::Migration
  def change
    create_table :path_parameters do |t|
      t.integer :specification_id, null: false
      t.string :name, null: false
      t.string :type, null: false
      t.string :description, null: false
      t.timestamps null: false
    end
    add_index :path_parameters, [:specification_id, :name], unique: true
  end
end
