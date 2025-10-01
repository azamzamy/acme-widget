require 'bigdecimal'

# Abstract base class for all offers
# Subclasses must implement #calculate_discount
# Follows Strategy pattern for extensible discount rules
class BaseOffer
  # Calculate the discount amount for the given items
  # @param items [Array<Product>] the items in the basket
  # @return [BigDecimal] the discount amount
  def calculate_discount(items)
    raise NotImplementedError, "#{self.class} must implement #calculate_discount"
  end

  # Check if this offer is applicable to the given items
  # @param items [Array<Product>] the items in the basket
  # @return [Boolean] true if the offer applies
  def applicable?(items)
    false
  end
end
