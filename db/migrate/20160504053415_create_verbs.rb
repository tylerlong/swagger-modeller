class CreateVerbs < ActiveRecord::Migration
  def change
    create_table :verbs do |t|
      t.integer :path_id, null: false
      t.string :method, null: false
      t.string :name, null: false
      t.boolean :batch, default: false
      t.string :visibility, null: false
      t.string :status, null: false, default: ''
      t.timestamps null: false
    end
    add_index :verbs, [:path_id, :name], unique: true
  end
end
