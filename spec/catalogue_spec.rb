require_relative '../lib/catalogue'
require_relative '../lib/product'

RSpec.describe Catalogue do
  let(:red_widget) { Product.new('R01', 'Red Widget', 32.95) }
  let(:green_widget) { Product.new('G01', 'Green Widget', 24.95) }
  let(:blue_widget) { Product.new('B01', 'Blue Widget', 7.95) }
  let(:products) { [red_widget, green_widget, blue_widget] }
  let(:catalogue) { Catalogue.new(products) }

  describe '#initialize' do
    it 'accepts an array of products' do
      expect { Catalogue.new(products) }.not_to raise_error
    end

    it 'can be initialized with an empty array' do
      empty_catalogue = Catalogue.new([])
      expect(empty_catalogue).to be_a(Catalogue)
    end
  end

  describe '#find_product' do
    it 'finds a product by its code' do
      product = catalogue.find_product('R01')
      
      expect(product).to eq(red_widget)
      expect(product.code).to eq('R01')
    end

    it 'returns nil when product code is not found' do
      product = catalogue.find_product('INVALID')
      
      expect(product).to be_nil
    end

    it 'handles case-sensitive product codes' do
      product = catalogue.find_product('r01')
      
      expect(product).to be_nil
    end
  end

  describe '#all_products' do
    it 'returns all products in the catalogue' do
      expect(catalogue.all_products).to eq(products)
    end

    it 'returns a copy to prevent external modification' do
      all = catalogue.all_products
      all << Product.new('X01', 'Invalid', 0)
      
      expect(catalogue.all_products.size).to eq(3)
    end
  end
end
