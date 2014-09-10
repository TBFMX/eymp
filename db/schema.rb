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

ActiveRecord::Schema.define(version: 20140829173845) do

  create_table "brands", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "brands", ["slug"], name: "index_brands_on_slug"

  create_table "categories", force: true do |t|
    t.string   "title"
    t.integer  "father_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug"

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "equipment_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mensaje"
  end

  create_table "control_panels", force: true do |t|
    t.string   "admin"
    t.string   "system"
    t.integer  "newadv"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currencies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_files", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discounts", force: true do |t|
    t.string   "titulo"
    t.decimal  "precio"
    t.date     "vencimiento"
    t.decimal  "precio_anterior"
    t.integer  "equipment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discounts", ["equipment_id"], name: "index_discounts_on_equipment_id"

  create_table "equipment", force: true do |t|
    t.string   "name"
    t.integer  "year"
    t.string   "color"
    t.integer  "brand_id"
    t.integer  "package_id"
    t.text     "description"
    t.integer  "publication_type"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "image_id"
    t.integer  "user_id"
    t.string   "ciudad"
    t.decimal  "precio"
    t.integer  "rank"
    t.integer  "priority"
    t.string   "modelo"
    t.string   "etiquetas"
    t.string   "slug"
    t.string   "currency_id"
    t.string   "country_id"
    t.string   "state_id"
    t.string   "pagado"
    t.integer  "status"
    t.integer  "subcategory_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "equipment", ["slug"], name: "index_equipment_on_slug"

  create_table "favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "equipment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "galleries", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "equipment_id"
    t.string   "slug"
  end

  add_index "galleries", ["slug"], name: "index_galleries_on_slug"

  create_table "images", force: true do |t|
    t.integer  "gallery_id"
    t.string   "image_url"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "images", ["slug"], name: "index_images_on_slug"

  create_table "ind_equipments", force: true do |t|
    t.integer  "industry_id"
    t.integer  "equipment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "industries", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "module1s", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "module2s", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "module3s", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "module4s", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "module5s", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "packages", force: true do |t|
    t.string   "name"
    t.decimal  "price"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "botton_one"
    t.text     "botton_suscription"
  end

  create_table "rols", force: true do |t|
    t.string   "rol_name"
    t.boolean  "admin"
    t.boolean  "module_1"
    t.boolean  "module_2"
    t.boolean  "module_3"
    t.boolean  "module_4"
    t.boolean  "module_5"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcategories", force: true do |t|
    t.string   "category_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "name"
    t.string   "lastname"
    t.string   "email"
    t.date     "login_date"
    t.date     "password_date"
    t.integer  "rol_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "package_id"
    t.string   "uid"
    t.string   "provider"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.integer  "active"
  end

  create_table "videos", force: true do |t|
    t.integer  "gallery_id"
    t.string   "video_url"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "videos", ["slug"], name: "index_videos_on_slug"

end
