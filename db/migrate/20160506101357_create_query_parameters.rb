class CreateQueryParameters < ActiveRecord::Migration
  def change
    create_table :query_parameters do |t|
      t.integer :verb_id, null: false
      t.string :name, null: false
      t.string :type, null: false
      t.string :format, default: ''
      t.boolean :required, default: false
      t.string :description, null: false
      t.integer :position, default: 0
      t.timestamps null: false
    end
    add_index :query_parameters, [:verb_id, :name], unique: true
  end
end
