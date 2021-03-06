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

ActiveRecord::Schema.define(version: 20181020055244) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alt_characters", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.integer "character_id"
    t.string "token"
    t.string "refresh_token"
    t.integer "token_expiry"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_sync"
    t.integer "label_id", default: 0
    t.string "label_name", default: "None"
    t.string "char_contact_hash"
    t.string "corp_contact_hash"
    t.string "ally_contact_hash"
  end

  create_table "premium_payments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "amount"
    t.datetime "paid_at"
    t.string "payment_identifier"
    t.integer "seconds_credited"
    t.datetime "start_at"
    t.integer "monthly_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.boolean "sync_char_contacts", default: true
    t.boolean "sync_corp_contacts", default: true
    t.boolean "sync_ally_contacts", default: true
    t.integer "user_id"
    t.boolean "auto_sync_contacts", default: false
  end

  create_table "sync_jobs", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sync_stats", force: :cascade do |t|
    t.datetime "job_started"
    t.datetime "job_finished"
    t.integer "contact_count"
    t.boolean "success", default: false
    t.string "job_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.integer "character_id"
    t.string "token"
    t.string "refresh_token"
    t.integer "token_expiry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "settings_id"
    t.string "corp_name"
    t.string "corp_id"
    t.string "ally_name"
    t.string "ally_id"
    t.string "role"
    t.boolean "viewed_manual", default: false
  end

end
