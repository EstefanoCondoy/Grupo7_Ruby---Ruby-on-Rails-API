class ReceiptItem < ApplicationRecord
  belongs_to :receipt
  belongs_to :product

  # Validaciones
  validates :quantity, presence: { message: 'La cantidad es obligatoria' },
                       numericality: { only_integer: true, greater_than: 0,
                                       message: 'La cantidad debe ser un número entero mayor a 0' }

  validates :unit_price, numericality: { greater_than: 0, message: 'El precio unitario debe ser mayor a 0' },
                         allow_nil: true

  validates :subtotal, numericality: { greater_than_or_equal_to: 0, message: 'El subtotal debe ser mayor o igual a 0' },
                       allow_nil: true

  # Calcular subtotal antes de guardar
  before_validation :set_price_and_subtotal

  private

  def set_price_and_subtotal
    return unless product.present?

    self.unit_price = product.price
    self.subtotal = unit_price * quantity if unit_price && quantity
  end
end
