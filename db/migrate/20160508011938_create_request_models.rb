class CreateRequestModels < ActiveRecord::Migration
  def change
    create_table :request_models do |t|
      t.integer :verb_id, null: false
      t.string :name, null: false
      t.string :properties_text, null: false
      t.timestamps null: false
    end
    add_index :request_models, [:verb_id, :name], unique: true
  end
end
