# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_10_05_161418) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "buckets", force: :cascade do |t|
    t.string "name", null: false
    t.integer "expected_enrollment"
    t.integer "bucket_type", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.string "provider"
    t.integer "sort_order", default: 0, null: false
    t.integer "current_balance", default: 0, null: false
    t.string "color"
    t.string "description"
    t.index ["user_id"], name: "index_buckets_on_user_id"
  end

  create_table "expense_categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "expected_spending"
    t.integer "actual_spending", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_expense_categories_on_user_id"
  end

  create_table "income_categories", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.integer "expected_revenue"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "actual_revenue"
    t.index ["user_id"], name: "index_income_categories_on_user_id"
  end

  create_table "savings", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.integer "sort_order", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "goal"
    t.integer "expected_enrollment"
    t.index ["user_id"], name: "index_savings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name"
    t.citext "email", null: false
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "authorization_token"
  end

  add_foreign_key "buckets", "users"
  add_foreign_key "expense_categories", "users"
  add_foreign_key "income_categories", "users"
  add_foreign_key "savings", "users"
end
