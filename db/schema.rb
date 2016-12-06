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

ActiveRecord::Schema.define(version: 20161206085951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "examples", force: :cascade do |t|
    t.integer  "verb_id",                         null: false
    t.text     "name",        default: "Example"
    t.text     "description", default: ""
    t.text     "request",     default: ""
    t.text     "response",    default: ""
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "examples", ["verb_id", "name"], name: "index_examples_on_verb_id_and_name", unique: true, using: :btree

  create_table "model_properties", force: :cascade do |t|
    t.integer  "model_id",                    null: false
    t.integer  "position",    default: 0
    t.text     "name",                        null: false
    t.text     "data_type",                   null: false
    t.text     "description",                 null: false
    t.text     "format",      default: ""
    t.boolean  "required",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "model_properties", ["model_id", "name"], name: "index_model_properties_on_model_id_and_name", unique: true, using: :btree

  create_table "models", force: :cascade do |t|
    t.integer  "specification_id", null: false
    t.text     "name",             null: false
    t.text     "properties_text",  null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "models", ["specification_id", "name"], name: "index_models_on_specification_id_and_name", unique: true, using: :btree

  create_table "path_parameters", force: :cascade do |t|
    t.integer  "specification_id",                null: false
    t.text     "name",                            null: false
    t.text     "data_type",                       null: false
    t.text     "description",                     null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "format",           default: ""
    t.boolean  "required",         default: true
    t.integer  "position",         default: 0
  end

  add_index "path_parameters", ["specification_id", "name"], name: "index_path_parameters_on_specification_id_and_name", unique: true, using: :btree

  create_table "paths", force: :cascade do |t|
    t.integer  "specification_id", null: false
    t.text     "uri",              null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "paths", ["specification_id", "uri"], name: "index_paths_on_specification_id_and_uri", unique: true, using: :btree

  create_table "permissions", force: :cascade do |t|
    t.integer  "specification_id", null: false
    t.text     "name",             null: false
    t.text     "description",      null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "permissions", ["specification_id", "name"], name: "index_permissions_on_specification_id_and_name", unique: true, using: :btree

  create_table "query_parameters", force: :cascade do |t|
    t.integer  "verb_id",                     null: false
    t.text     "name",                        null: false
    t.text     "data_type",                   null: false
    t.text     "format",      default: ""
    t.boolean  "required",    default: false
    t.text     "description",                 null: false
    t.integer  "position",    default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "query_parameters", ["verb_id", "name"], name: "index_query_parameters_on_verb_id_and_name", unique: true, using: :btree

  create_table "request_body_properties", force: :cascade do |t|
    t.integer  "verb_id",                     null: false
    t.integer  "position",    default: 0
    t.text     "name",                        null: false
    t.text     "data_type",                   null: false
    t.text     "description",                 null: false
    t.text     "format",      default: ""
    t.boolean  "required",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "request_body_properties", ["verb_id", "name"], name: "index_request_body_properties_on_verb_id_and_name", unique: true, using: :btree

  create_table "response_body_properties", force: :cascade do |t|
    t.integer  "verb_id",                     null: false
    t.integer  "position",    default: 0
    t.text     "name",                        null: false
    t.text     "data_type",                   null: false
    t.text     "description",                 null: false
    t.text     "format",      default: ""
    t.boolean  "required",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "response_body_properties", ["verb_id", "name"], name: "index_response_body_properties_on_verb_id_and_name", unique: true, using: :btree

  create_table "specifications", force: :cascade do |t|
    t.text     "version",                           null: false
    t.text     "title",                             null: false
    t.text     "description"
    t.text     "termsOfService"
    t.text     "host"
    t.text     "basePath"
    t.text     "schemes"
    t.text     "produces"
    t.text     "consumes"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "path_parameters_text", default: ""
    t.text     "permissions_text",     default: ""
  end

  add_index "specifications", ["version", "title"], name: "index_specifications_on_version_and_title", unique: true, using: :btree

  create_table "verbs", force: :cascade do |t|
    t.integer  "path_id",                               null: false
    t.text     "method",                                null: false
    t.text     "name",                                  null: false
    t.boolean  "batch",                 default: false
    t.text     "visibility",                            null: false
    t.text     "status",                default: "",    null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.text     "query_parameters_text", default: ""
    t.text     "request_body_text",     default: ""
    t.text     "response_body_text",    default: ""
    t.text     "since",                 default: ""
    t.text     "description",           default: ""
    t.text     "api_group",             default: ""
    t.text     "permissions",           default: ""
    t.string   "tags",                  default: ""
  end

  add_index "verbs", ["path_id", "name"], name: "index_verbs_on_path_id_and_name", unique: true, using: :btree

end
