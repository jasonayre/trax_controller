
::ActiveRecord::Schema.define do
  create_table "products", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "user_id"
    t.decimal  "price"
    t.integer  "quantity"
    t.boolean  "in_stock"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean "can_destroy_widgets"
    t.boolean "can_create_widgets"
    t.boolean "can_read_widgets"
    t.boolean "can_update_widgets"
    t.boolean "is_admin"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "widgets", :force => true do |t|
    t.string "uuid"
    t.string "name"
    t.string  "subdomain"
    t.string  "website"
    t.integer  "status"
    t.integer  "quantity"
    t.boolean "is_read_only"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "people", :force => true do |t|
    t.string "name"
    t.string "uuid"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "staplers", :force => true do |t|
    t.string "name"
    t.string "type"
    t.integer "attribute_set_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "swingline_stapler_attribute_sets", :force => true do |t|
    t.float "speed"
    t.string "owner"

    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end
end
