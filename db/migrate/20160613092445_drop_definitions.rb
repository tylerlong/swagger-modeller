class DropDefinitions < ActiveRecord::Migration
  def up
    drop_table :definitions
  end

  def down
    create_table "definitions", force: :cascade do |t|
      t.integer  "specification_id", null: false
      t.string   "name",             null: false
      t.string   "description"
      t.string   "properties_text"
      t.datetime "created_at",       null: false
      t.datetime "updated_at",       null: false
    end

    add_index "definitions", ["specification_id", "name"], name: "index_definitions_on_specification_id_and_name", unique: true
  end
end
