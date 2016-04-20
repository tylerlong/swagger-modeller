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

ActiveRecord::Schema.define(version: 20160420095546) do

  create_table "definitions", force: :cascade do |t|
    t.integer  "specification_id", null: false
    t.string   "name",             null: false
    t.string   "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "definitions", ["specification_id", "name"], name: "index_definitions_on_specification_id_and_name", unique: true

  create_table "properties", force: :cascade do |t|
    t.integer  "definition_id", null: false
    t.string   "name",          null: false
    t.string   "type",          null: false
    t.string   "extra"
    t.string   "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "properties", ["definition_id", "name"], name: "index_properties_on_definition_id_and_name", unique: true

  create_table "specifications", force: :cascade do |t|
    t.string   "version",        null: false
    t.string   "title",          null: false
    t.string   "description"
    t.string   "termsOfService"
    t.string   "host"
    t.string   "basePath"
    t.string   "schemes"
    t.string   "produces"
    t.string   "consumes"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "specifications", ["version", "title"], name: "index_specifications_on_version_and_title", unique: true

end
