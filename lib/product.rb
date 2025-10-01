require 'bigdecimal'

# Represents a product in the catalogue
# Immutable value object with code, name, and price
class Product
  attr_reader :code, :name, :price

  def initialize(code, name, price)
    @code = code
    @name = name
    @price = BigDecimal(price.to_s)
  end

  def to_s
    "#{name} (#{code}): $#{format('%.2f', price)}"
  end

  def ==(other)
    other.is_a?(Product) &&
      code == other.code &&
      name == other.name &&
      price == other.price
  end

  alias eql? ==

  def hash
    [code, name, price].hash
  end
end
