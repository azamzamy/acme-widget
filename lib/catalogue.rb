# Manages the product catalogue
# Provides lookup functionality for products by code
class Catalogue
  def initialize(products)
    @products = products.dup.freeze
    @products_by_code = products.each_with_object({}) do |product, hash|
      hash[product.code] = product
    end.freeze
  end

  # Find a product by its code
  # @param code [String] the product code to search for
  # @return [Product, nil] the product if found, nil otherwise
  def find_product(code)
    @products_by_code[code]
  end

  # Returns all products in the catalogue
  # @return [Array<Product>] a copy of all products
  def all_products
    @products.dup
  end
end
