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

ActiveRecord::Schema[8.0].define(version: 2025_08_13_052338) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "billable_type", null: false
    t.bigint "billable_id", null: false
    t.bigint "invoice_id", null: false
    t.date "due_date"
    t.decimal "value", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billable_type", "billable_id"], name: "index_accounts_on_billable"
    t.index ["invoice_id"], name: "index_accounts_on_invoice_id"
  end

  create_table "additional_services", force: :cascade do |t|
    t.string "name"
    t.decimal "value", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "additional_services_packages", id: false, force: :cascade do |t|
    t.bigint "additional_service_id", null: false
    t.bigint "package_id", null: false
  end

  create_table "booklets", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_booklets_on_subscription_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "booklet_id", null: false
    t.date "due_date"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booklet_id"], name: "index_invoices_on_booklet_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.bigint "plan_id", null: false
    t.decimal "value", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "manual_value", default: false
    t.index ["plan_id"], name: "index_packages_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.decimal "value", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscription_additional_services", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.bigint "additional_service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["additional_service_id"], name: "idx_on_additional_service_id_305e585373"
    t.index ["subscription_id"], name: "index_subscription_additional_services_on_subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "plan_id"
    t.bigint "package_id"
    t.decimal "value", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
    t.index ["package_id"], name: "index_subscriptions_on_package_id"
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
  end

  add_foreign_key "accounts", "invoices"
  add_foreign_key "booklets", "subscriptions"
  add_foreign_key "invoices", "booklets"
  add_foreign_key "packages", "plans"
  add_foreign_key "subscription_additional_services", "additional_services"
  add_foreign_key "subscription_additional_services", "subscriptions"
  add_foreign_key "subscriptions", "customers"
  add_foreign_key "subscriptions", "packages"
  add_foreign_key "subscriptions", "plans"
end
