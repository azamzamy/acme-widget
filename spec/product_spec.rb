require_relative '../lib/product'

RSpec.describe Product do
  describe '#initialize' do
    it 'creates a product with code, name, and price' do
      product = Product.new('R01', 'Red Widget', 32.95)
      
      expect(product.code).to eq('R01')
      expect(product.name).to eq('Red Widget')
      expect(product.price).to eq(32.95)
    end

    it 'stores price as BigDecimal for precision' do
      product = Product.new('G01', 'Green Widget', 24.95)
      
      expect(product.price).to be_a(BigDecimal)
      expect(product.price).to eq(BigDecimal('24.95'))
    end
  end

  describe '#to_s' do
    it 'returns a human-readable representation' do
      product = Product.new('B01', 'Blue Widget', 7.95)
      
      expect(product.to_s).to eq('Blue Widget (B01): $7.95')
    end
  end
end
