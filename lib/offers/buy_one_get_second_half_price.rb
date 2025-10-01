require_relative 'base_offer'
require 'bigdecimal'

# Offer: Buy one product, get the second at half price
# Applies to every pair of the specified product
# Example: Buy 4 red widgets, get 2nd and 4th at half price
class BuyOneGetSecondHalfPrice < BaseOffer
  def initialize(product_code)
    @product_code = product_code
  end

  # Check if offer is applicable (need at least 2 matching products)
  def applicable?(items)
    matching_items(items).count >= 2
  end

  # Calculate discount for matching product pairs
  # Every even-numbered item (2nd, 4th, 6th, etc.) gets 50% off
  def calculate_discount(items)
    matching = matching_items(items)
    return BigDecimal('0') if matching.count < 2

    # Calculate number of discounted items (every 2nd item in pairs)
    discounted_count = matching.count / 2
    price_per_item = matching.first.price
    
    # Discount is 50% off for each discounted item
    discount_per_item = price_per_item / 2
    discount_per_item * discounted_count
  end

  private

  def matching_items(items)
    items.select { |item| item.code == @product_code }
  end
end
