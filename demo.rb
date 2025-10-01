#!/usr/bin/env ruby

require_relative 'lib/product'
require_relative 'lib/catalogue'
require_relative 'lib/delivery_rules'
require_relative 'lib/offers/buy_one_get_second_half_price'
require_relative 'lib/basket'

# Initialize products
red_widget = Product.new('R01', 'Red Widget', 32.95)
green_widget = Product.new('G01', 'Green Widget', 24.95)
blue_widget = Product.new('B01', 'Blue Widget', 7.95)

# Create catalogue
catalogue = Catalogue.new([red_widget, green_widget, blue_widget])

# Set up delivery rules
delivery_rules = DeliveryRules.new

# Configure offers
offers = [
  BuyOneGetSecondHalfPrice.new('R01')  # Buy one red widget, get second half price
]

puts "=" * 60
puts "ACME WIDGET CO - Sales System Demo"
puts "=" * 60
puts

# Helper method to demo a basket
def demo_basket(catalogue, delivery_rules, offers, products, description)
  basket = Basket.new(catalogue, delivery_rules, offers)
  
  puts "#{description}"
  puts "-" * 60
  
  products.each do |code|
    basket.add(code)
    product = catalogue.find_product(code)
    puts "  Added: #{product.name} (#{product.code}) - $#{'%.2f' % product.price}"
  end
  
  puts
  puts "  Subtotal: $#{'%.2f' % basket.subtotal}"
  puts "  Total:    $#{'%.2f' % basket.total}"
  puts
end

# Demo Example 1: B01, G01
demo_basket(catalogue, delivery_rules, offers, ['B01', 'G01'], 
            "Example 1: Blue + Green Widget")

# Demo Example 2: R01, R01
demo_basket(catalogue, delivery_rules, offers, ['R01', 'R01'], 
            "Example 2: Two Red Widgets (offer applies!)")

# Demo Example 3: R01, G01
demo_basket(catalogue, delivery_rules, offers, ['R01', 'G01'], 
            "Example 3: Red + Green Widget")

# Demo Example 4: B01, B01, R01, R01, R01
demo_basket(catalogue, delivery_rules, offers, ['B01', 'B01', 'R01', 'R01', 'R01'], 
            "Example 4: Mixed basket with offer")

puts "=" * 60
puts "Delivery Rules:"
puts "  - Orders under $50: $4.95 delivery"
puts "  - Orders $50-$89.99: $2.95 delivery"
puts "  - Orders $90+: FREE delivery"
puts
puts "Current Offers:"
puts "  - Red Widgets: Buy one, get second half price!"
puts "=" * 60
