class ReceiptService
  class << self
    def create(user_id, items_params)
      user = User.find(user_id)

      # Validar que hay items
      raise ExceptionHandler::ValidationError, 'El recibo debe contener al menos un item' if items_params.blank?

      ActiveRecord::Base.transaction do
        # Crear el recibo
        receipt = Receipt.create!(user: user, total: 0)

        total = BigDecimal('0')

        items_params.each do |item_param|
          product = Product.lock.find(item_param[:product_id])
          quantity = item_param[:quantity].to_i

          # Validar stock
          unless product.sufficient_stock?(quantity)
            raise ExceptionHandler::InsufficientStockError,
                  "Stock insuficiente para '#{product.name}'. Disponible: #{product.stock}, Solicitado: #{quantity}"
          end

          # Calcular precios con BigDecimal para precisión
          unit_price = product.price
          subtotal = unit_price * quantity

          # Crear el item del recibo
          ReceiptItem.create!(
            receipt: receipt,
            product: product,
            quantity: quantity,
            unit_price: unit_price,
            subtotal: subtotal
          )

          # Descontar stock
          product.deduct_stock!(quantity)

          total += subtotal
        end

        # Actualizar el total del recibo
        receipt.update!(total: total)
        receipt.reload
      end
    end

    def find_all
      Receipt.includes(:user, receipt_items: :product).order(created_at: :desc)
    end

    def find_by_id(id)
      Receipt.includes(:user, receipt_items: :product).find(id)
    end

    def find_by_user(user_id)
      User.find(user_id) # Validate user exists
      Receipt.includes(receipt_items: :product)
             .where(user_id: user_id)
             .order(created_at: :desc)
    end

    def delete(id)
      receipt = Receipt.find(id)
      receipt.destroy!
    end
  end
end
