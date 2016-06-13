class DropProperties < ActiveRecord::Migration
  def up
    drop_table :properties
  end

  def down
    create_table "properties", force: :cascade do |t|
      t.integer  "definition_id",                null: false
      t.string   "name",                         null: false
      t.string   "type",                         null: false
      t.string   "format"
      t.boolean  "required",      default: true
      t.string   "description"
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
      t.integer  "position",      default: 0
    end

    add_index "properties", ["definition_id", "name"], name: "index_properties_on_definition_id_and_name", unique: true
  end
end
