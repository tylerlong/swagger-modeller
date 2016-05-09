class CreateCommonModels < ActiveRecord::Migration
  def change
    create_table :common_models do |t|
      t.integer :specification_id, null: false
      t.string :name, null: false
      t.string :properties_text, null: false
      t.timestamps null: false
    end
    add_index :common_models, [:specification_id, :name], unique: true
  end
end
