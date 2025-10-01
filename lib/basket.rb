require 'bigdecimal'

# Main shopping basket class
# Orchestrates product catalogue, offers, and delivery rules
# Implements dependency injection for extensibility
class Basket
  attr_reader :items

  # Initialize basket with injected dependencies
  # @param catalogue [Catalogue] product catalogue for lookups
  # @param delivery_rules [DeliveryRules] delivery cost calculator
  # @param offers [Array<BaseOffer>] array of applicable offers
  def initialize(catalogue, delivery_rules, offers = [])
    @catalogue = catalogue
    @delivery_rules = delivery_rules
    @offers = offers
    @items = []
  end

  # Add a product to the basket by product code
  # @param product_code [String] the product code to add
  # @raise [ArgumentError] if product code not found
  def add(product_code)
    product = @catalogue.find_product(product_code)
    raise ArgumentError, "Product with code '#{product_code}' not found in catalogue" if product.nil?

    @items << product
  end

  # Calculate subtotal before discounts and delivery
  # @return [BigDecimal] sum of all product prices
  def subtotal
    @items.sum(&:price)
  end

  # Calculate total including discounts and delivery
  # @return [BigDecimal] final total amount rounded to 2 decimal places
  def total
    # Calculate subtotal
    order_subtotal = subtotal

    # Apply all offers
    total_discount = calculate_total_discount

    # Calculate amount after discounts
    amount_after_discount = order_subtotal - total_discount

    # Calculate delivery based on discounted amount
    delivery_cost = @delivery_rules.calculate_delivery_cost(amount_after_discount)

    # Final total rounded down to 2 decimal places (floor)
    final_total = amount_after_discount + delivery_cost
    final_total.round(2, :down)
  end

  private

  # Calculate total discount from all applicable offers
  # @return [BigDecimal] total discount amount
  def calculate_total_discount
    @offers.sum { |offer| offer.calculate_discount(@items) }
  end
end
