puts '🌱 Seeding database...'

# Crear usuarios de ejemplo
puts 'Creating users...'
users = [
  { first_name: 'Estéfano', last_name: 'Condoy',   email: 'estefano@example.com', password: 'password123' },
  { first_name: 'Eddy',     last_name: 'Sangucho',  email: 'eddy@example.com',     password: 'password123' },
  { first_name: 'César',    last_name: 'Zapata',    email: 'cesar@example.com',    password: 'password123' },
  { first_name: 'Admin',    last_name: 'Sistema',   email: 'admin@example.com',    password: 'admin12345' }
]

created_users = users.map do |user_attrs|
  User.find_or_create_by!(email: user_attrs[:email]) do |u|
    u.first_name = user_attrs[:first_name]
    u.last_name  = user_attrs[:last_name]
    u.password   = user_attrs[:password]
  end
end
puts "  ✅ #{User.count} users created"

# Crear productos de ejemplo
puts 'Creating products...'
products_data = [
  { name: 'Laptop HP Pavilion',         description: 'Laptop HP Pavilion 15.6" Intel Core i5 16GB RAM 512GB SSD',    price: 899.99,  stock: 25 },
  { name: 'Mouse Logitech MX Master 3', description: 'Mouse inalámbrico ergonómico con desplazamiento ultrarrápido', price: 79.99,   stock: 100 },
  { name: 'Teclado Mecánico Corsair',    description: 'Teclado mecánico RGB Cherry MX Red',                          price: 129.99,  stock: 50 },
  { name: 'Monitor Samsung 27"',         description: 'Monitor IPS 4K UHD 27 pulgadas HDR10',                        price: 449.99,  stock: 30 },
  { name: 'Auriculares Sony WH-1000XM5', description: 'Auriculares inalámbricos con cancelación de ruido',            price: 349.99,  stock: 40 },
  { name: 'Webcam Logitech C920',        description: 'Webcam Full HD 1080p con micrófono estéreo',                   price: 69.99,   stock: 75 },
  { name: 'SSD Samsung 1TB',             description: 'Disco de estado sólido NVMe M.2 1TB',                         price: 109.99,  stock: 60 },
  { name: 'Cable USB-C 2m',              description: 'Cable USB-C a USB-C 2 metros trenzado',                       price: 14.99,   stock: 200 },
  { name: 'Hub USB-C 7 en 1',            description: 'Hub multipuerto USB-C con HDMI, USB 3.0, SD y ethernet',      price: 49.99,   stock: 80 },
  { name: 'Soporte para Laptop',         description: 'Soporte ajustable de aluminio para laptop',                   price: 39.99,   stock: 90 }
]

products = products_data.map do |prod_attrs|
  Product.find_or_create_by!(name: prod_attrs[:name]) do |p|
    p.description = prod_attrs[:description]
    p.price       = prod_attrs[:price]
    p.stock       = prod_attrs[:stock]
  end
end
puts "  ✅ #{Product.count} products created"

# Crear un recibo de ejemplo
puts 'Creating sample receipt...'
user = created_users.first
product1 = products[0]
product2 = products[1]

receipt = Receipt.create!(user: user, total: 0)

item1 = ReceiptItem.create!(
  receipt: receipt,
  product: product1,
  quantity: 1,
  unit_price: product1.price,
  subtotal: product1.price * 1
)

item2 = ReceiptItem.create!(
  receipt: receipt,
  product: product2,
  quantity: 2,
  unit_price: product2.price,
  subtotal: product2.price * 2
)

receipt.calculate_total!

puts "  ✅ #{Receipt.count} receipt created with #{ReceiptItem.count} items"
puts "  📦 Receipt total: $#{receipt.reload.total}"

puts "\n🎉 Seed completed successfully!"
