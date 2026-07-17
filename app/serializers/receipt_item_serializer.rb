class ReceiptItemSerializer
  def self.serialize(item)
    {
      id: item.id,
      productId: item.product_id,
      productName: item.product.name,
      quantity: item.quantity,
      unitPrice: item.unit_price.to_f,
      subtotal: item.subtotal.to_f
    }
  end
end
