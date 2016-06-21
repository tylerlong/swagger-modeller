# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160621081634) do

  create_table "model_properties", force: :cascade do |t|
    t.integer  "model_id",                    null: false
    t.integer  "position",    default: 0
    t.string   "name",                        null: false
    t.string   "data_type",                   null: false
    t.string   "description",                 null: false
    t.string   "format",      default: ""
    t.boolean  "required",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "model_properties", ["model_id", "name"], name: "index_model_properties_on_model_id_and_name", unique: true

  create_table "models", force: :cascade do |t|
    t.integer  "specification_id", null: false
    t.string   "name",             null: false
    t.string   "properties_text",  null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "models", ["specification_id", "name"], name: "index_models_on_specification_id_and_name", unique: true

  create_table "path_parameters", force: :cascade do |t|
    t.integer  "specification_id",                null: false
    t.string   "name",                            null: false
    t.string   "data_type",                       null: false
    t.string   "description",                     null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "format",           default: ""
    t.boolean  "required",         default: true
    t.integer  "position",         default: 0
  end

  add_index "path_parameters", ["specification_id", "name"], name: "index_path_parameters_on_specification_id_and_name", unique: true

  create_table "paths", force: :cascade do |t|
    t.integer  "specification_id", null: false
    t.string   "uri",              null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "paths", ["specification_id", "uri"], name: "index_paths_on_specification_id_and_uri", unique: true

  create_table "permissions", force: :cascade do |t|
    t.integer  "specification_id", null: false
    t.string   "name",             null: false
    t.string   "description",      null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "permissions", ["specification_id", "name"], name: "index_permissions_on_specification_id_and_name", unique: true

  create_table "query_parameters", force: :cascade do |t|
    t.integer  "verb_id",                     null: false
    t.string   "name",                        null: false
    t.string   "data_type",                   null: false
    t.string   "format",      default: ""
    t.boolean  "required",    default: false
    t.string   "description",                 null: false
    t.integer  "position",    default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "query_parameters", ["verb_id", "name"], name: "index_query_parameters_on_verb_id_and_name", unique: true

  create_table "request_body_properties", force: :cascade do |t|
    t.integer  "verb_id",                     null: false
    t.integer  "position",    default: 0
    t.string   "name",                        null: false
    t.string   "data_type",                   null: false
    t.string   "description",                 null: false
    t.string   "format",      default: ""
    t.boolean  "required",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "request_body_properties", ["verb_id", "name"], name: "index_request_body_properties_on_verb_id_and_name", unique: true

  create_table "response_body_properties", force: :cascade do |t|
    t.integer  "verb_id",                     null: false
    t.integer  "position",    default: 0
    t.string   "name",                        null: false
    t.string   "data_type",                   null: false
    t.string   "description",                 null: false
    t.string   "format",      default: ""
    t.boolean  "required",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "response_body_properties", ["verb_id", "name"], name: "index_response_body_properties_on_verb_id_and_name", unique: true

  create_table "specifications", force: :cascade do |t|
    t.string   "version",                           null: false
    t.string   "title",                             null: false
    t.string   "description"
    t.string   "termsOfService"
    t.string   "host"
    t.string   "basePath"
    t.string   "schemes"
    t.string   "produces"
    t.string   "consumes"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "path_parameters_text", default: ""
    t.string   "permissions_text",     default: ""
  end

  add_index "specifications", ["version", "title"], name: "index_specifications_on_version_and_title", unique: true

  create_table "verbs", force: :cascade do |t|
    t.integer  "path_id",                               null: false
    t.string   "method",                                null: false
    t.string   "name",                                  null: false
    t.boolean  "batch",                 default: false
    t.string   "visibility",                            null: false
    t.string   "status",                default: "",    null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "query_parameters_text", default: ""
    t.string   "request_body_text",     default: ""
    t.string   "response_body_text",    default: ""
    t.string   "since",                 default: ""
    t.string   "description",           default: ""
    t.string   "api_group",             default: ""
    t.string   "permissions",           default: ""
  end

  add_index "verbs", ["path_id", "name"], name: "index_verbs_on_path_id_and_name", unique: true

end
