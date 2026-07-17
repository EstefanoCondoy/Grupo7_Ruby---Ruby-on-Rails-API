ActiveRecord::Schema[7.1].define(version: 2026_07_17_000004) do
  enable_extension 'plpgsql'

  create_table 'users', force: :cascade do |t|
    t.string 'first_name', limit: 50, null: false
    t.string 'last_name', limit: 50, null: false
    t.string 'email', null: false
    t.string 'password_digest', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
  end

  create_table 'products', force: :cascade do |t|
    t.string 'name', limit: 100, null: false
    t.text 'description'
    t.decimal 'price', precision: 10, scale: 2, null: false
    t.integer 'stock', default: 0, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'receipts', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.decimal 'total', precision: 10, scale: 2, default: '0.0'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_receipts_on_user_id'
  end

  create_table 'receipt_items', force: :cascade do |t|
    t.bigint 'receipt_id', null: false
    t.bigint 'product_id', null: false
    t.integer 'quantity', null: false
    t.decimal 'unit_price', precision: 10, scale: 2, null: false
    t.decimal 'subtotal', precision: 10, scale: 2, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['product_id'], name: 'index_receipt_items_on_product_id'
    t.index ['receipt_id'], name: 'index_receipt_items_on_receipt_id'
  end

  add_foreign_key 'receipts', 'users'
  add_foreign_key 'receipt_items', 'receipts'
  add_foreign_key 'receipt_items', 'products'
end
