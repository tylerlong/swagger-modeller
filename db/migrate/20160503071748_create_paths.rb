class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.string :uri, null: false
      t.timestamps null: false
    end
    add_index :paths, :uri, unique: true
  end
end
