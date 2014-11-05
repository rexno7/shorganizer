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

ActiveRecord::Schema.define(version: 20141021003826) do

  create_table "episodes", force: true do |t|
    t.string   "title"
    t.float    "no",         limit: 24
    t.date     "air_date"
    t.time     "air_time"
    t.string   "season"
    t.string   "channel"
    t.boolean  "watched"
    t.integer  "show_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "episodes", ["show_id"], name: "index_episodes_on_show_id", using: :btree

  create_table "shows", force: true do |t|
    t.string   "name"
    t.string   "watch_url"
    t.string   "scrape_url"
    t.string   "genre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
