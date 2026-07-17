class CreateReceiptItems < ActiveRecord::Migration[7.1]
  def change
    create_table :receipt_items do |t|
      t.references :receipt, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity,   null: false
      t.decimal :unit_price, null: false, precision: 10, scale: 2
      t.decimal :subtotal,   null: false, precision: 10, scale: 2

      t.timestamps
    end
  end
end
