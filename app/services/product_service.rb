class ProductService
  class << self
    def create(params)
      product = Product.new(params)
      product.save!
      product
    end

    def find_all(page: 1, per_page: 10, name: nil)
      products = Product.all
      products = products.where('name ILIKE ?', "%#{name}%") if name.present?
      products.order(created_at: :desc).page(page).per(per_page)
    end

    def find_by_id(id)
      Product.find(id)
    end

    def update(id, params)
      product = Product.find(id)
      product.update!(params)
      product
    end

    def delete(id)
      product = Product.find(id)
      product.destroy!
    end
  end
end
