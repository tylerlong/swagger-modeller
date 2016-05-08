class CreateRequestModelProperties < ActiveRecord::Migration
  def change
    create_table :request_model_properties do |t|
      t.integer :request_model_id, null: false
      t.integer :position, default: 0
      t.string :name, null: false
      t.string :type, null: false
      t.string :description, null: false
      t.string :format, default: ''
      t.boolean :required, default: false
      t.timestamps null: false
    end
    add_index :request_model_properties, [:request_model_id, :name], unique: true
  end
end
