class DropRequestModelResponseModel < ActiveRecord::Migration
  def up
    drop_table :request_model_properties
    drop_table :request_models
    drop_table :response_model_properties
    drop_table :response_models
  end

  def down
    create_table "request_model_properties", force: :cascade do |t|
      t.integer  "request_model_id",                 null: false
      t.integer  "position",         default: 0
      t.string   "name",                             null: false
      t.string   "type",                             null: false
      t.string   "description",                      null: false
      t.string   "format",           default: ""
      t.boolean  "required",         default: false
      t.datetime "created_at",                       null: false
      t.datetime "updated_at",                       null: false
    end

    add_index "request_model_properties", ["request_model_id", "name"], name: "index_request_model_properties_on_request_model_id_and_name", unique: true

    create_table "request_models", force: :cascade do |t|
      t.integer  "verb_id",         null: false
      t.string   "name",            null: false
      t.string   "properties_text", null: false
      t.datetime "created_at",      null: false
      t.datetime "updated_at",      null: false
    end

    add_index "request_models", ["verb_id", "name"], name: "index_request_models_on_verb_id_and_name", unique: true

    create_table "response_model_properties", force: :cascade do |t|
      t.integer  "response_model_id",                 null: false
      t.integer  "position",          default: 0
      t.string   "name",                              null: false
      t.string   "type",                              null: false
      t.string   "description",                       null: false
      t.string   "format",            default: ""
      t.boolean  "required",          default: false
      t.datetime "created_at",                        null: false
      t.datetime "updated_at",                        null: false
    end

    add_index "response_model_properties", ["response_model_id", "name"], name: "index_response_model_properties_on_response_model_id_and_name", unique: true

    create_table "response_models", force: :cascade do |t|
      t.integer  "verb_id",         null: false
      t.string   "name",            null: false
      t.string   "properties_text", null: false
      t.datetime "created_at",      null: false
      t.datetime "updated_at",      null: false
    end

    add_index "response_models", ["verb_id", "name"], name: "index_response_models_on_verb_id_and_name", unique: true
  end
end
