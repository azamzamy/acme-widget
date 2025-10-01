require 'bigdecimal'

# Calculates delivery costs based on order total
# Rules:
#   - Under $50: $4.95 delivery
#   - $50 to $89.99: $2.95 delivery
#   - $90 or more: Free delivery
class DeliveryRules
  THRESHOLD_FREE = BigDecimal('90')
  THRESHOLD_REDUCED = BigDecimal('50')
  COST_STANDARD = BigDecimal('4.95')
  COST_REDUCED = BigDecimal('2.95')
  COST_FREE = BigDecimal('0')

  # Calculate delivery cost based on order total
  # @param order_total [BigDecimal] the total order amount after discounts
  # @return [BigDecimal] the delivery cost
  def calculate_delivery_cost(order_total)
    return COST_FREE if order_total >= THRESHOLD_FREE
    return COST_REDUCED if order_total >= THRESHOLD_REDUCED
    
    COST_STANDARD
  end
end
