class ProductSerializer
  def self.serialize(product)
    {
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price.to_f,
      stock: product.stock,
      createdAt: product.created_at&.iso8601,
      updatedAt: product.updated_at&.iso8601
    }
  end

  def self.serialize_collection(products)
    products.map { |product| serialize(product) }
  end

  def self.serialize_paginated(products)
    {
      data: serialize_collection(products),
      pagination: {
        currentPage: products.current_page,
        totalPages: products.total_pages,
        totalCount: products.total_count,
        perPage: products.limit_value
      }
    }
  end
end
