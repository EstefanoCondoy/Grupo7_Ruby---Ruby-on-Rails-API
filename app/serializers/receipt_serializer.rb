class ReceiptSerializer
  def self.serialize(receipt)
    {
      id: receipt.id,
      userId: receipt.user_id,
      user: {
        id: receipt.user.id,
        firstName: receipt.user.first_name,
        lastName: receipt.user.last_name,
        email: receipt.user.email
      },
      items: receipt.receipt_items.map { |item| ReceiptItemSerializer.serialize(item) },
      total: receipt.total.to_f,
      createdAt: receipt.created_at&.iso8601,
      updatedAt: receipt.updated_at&.iso8601
    }
  end

  def self.serialize_collection(receipts)
    receipts.map { |receipt| serialize(receipt) }
  end
end
