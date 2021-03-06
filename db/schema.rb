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

ActiveRecord::Schema.define(version: 20140113092844) do

  create_table "jobs", force: true do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "path"
    t.boolean  "hbase"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs_params", force: true do |t|
    t.integer "job_id"
    t.integer "param_id"
    t.boolean "output"
  end

  create_table "params", force: true do |t|
    t.string   "name"
    t.string   "desc"
    t.string   "default_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "field_type"
  end

  create_table "pig_tasks", force: true do |t|
    t.text     "command"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "status",     default: 1
    t.string   "base_path"
  end

  create_table "task_jobs", force: true do |t|
    t.integer  "pig_task_id"
    t.integer  "job_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
