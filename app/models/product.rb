class Product < ApplicationRecord
  has_many :receipt_items, dependent: :restrict_with_error

  # Validaciones
  validates :name,  presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Método para verificar disponibilidad de stock
  def sufficient_stock?(quantity)
    stock >= quantity
  end

  # Método para descontar stock
  def deduct_stock!(quantity)
    raise StandardError, "Stock insuficiente para el producto '#{name}'" unless sufficient_stock?(quantity)

    update!(stock: stock - quantity)
  end
end
