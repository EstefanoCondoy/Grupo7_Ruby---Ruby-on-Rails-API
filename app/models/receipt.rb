class Receipt < ApplicationRecord
  belongs_to :user
  has_many :receipt_items, dependent: :destroy

  # Validaciones
  validates :total, numericality: { greater_than_or_equal_to: 0, message: 'El total debe ser mayor o igual a 0' },
                    allow_nil: true

  # Aceptar atributos anidados para los items del recibo
  accepts_nested_attributes_for :receipt_items

  # Calcular el total basado en los items
  def calculate_total!
    calculated = receipt_items.sum { |item| item.subtotal || BigDecimal('0') }
    update!(total: calculated)
  end
end
