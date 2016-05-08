class CreateResponseModelProperties < ActiveRecord::Migration
  def change
    create_table :response_model_properties do |t|
      t.integer :response_model_id, null: false
      t.integer :position, default: 0
      t.string :name, null: false
      t.string :type, null: false
      t.string :description, null: false
      t.string :format, default: ''
      t.boolean :required, default: false
      t.timestamps null: false
    end
    add_index :response_model_properties, [:response_model_id, :name], unique: true
  end
end
