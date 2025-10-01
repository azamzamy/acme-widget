require_relative '../lib/basket'
require_relative '../lib/catalogue'
require_relative '../lib/product'
require_relative '../lib/delivery_rules'
require_relative '../lib/offers/buy_one_get_second_half_price'
require 'bigdecimal'

RSpec.describe Basket do
  let(:red_widget) { Product.new('R01', 'Red Widget', 32.95) }
  let(:green_widget) { Product.new('G01', 'Green Widget', 24.95) }
  let(:blue_widget) { Product.new('B01', 'Blue Widget', 7.95) }
  let(:catalogue) { Catalogue.new([red_widget, green_widget, blue_widget]) }
  let(:delivery_rules) { DeliveryRules.new }
  let(:red_offer) { BuyOneGetSecondHalfPrice.new('R01') }
  let(:offers) { [red_offer] }
  let(:basket) { Basket.new(catalogue, delivery_rules, offers) }

  describe '#initialize' do
    it 'accepts catalogue, delivery_rules, and offers via dependency injection' do
      expect { Basket.new(catalogue, delivery_rules, offers) }.not_to raise_error
    end

    it 'can be initialized with empty offers array' do
      expect { Basket.new(catalogue, delivery_rules, []) }.not_to raise_error
    end
  end

  describe '#add' do
    it 'adds a product by code to the basket' do
      expect { basket.add('R01') }.not_to raise_error
    end

    it 'allows adding multiple products' do
      basket.add('R01')
      basket.add('G01')
      basket.add('B01')
      
      expect(basket.items.size).to eq(3)
    end

    it 'raises error when product code is not found' do
      expect { basket.add('INVALID') }.to raise_error(ArgumentError, /Product with code 'INVALID' not found/)
    end

    it 'allows adding the same product multiple times' do
      basket.add('R01')
      basket.add('R01')
      
      expect(basket.items.size).to eq(2)
    end
  end

  describe '#items' do
    it 'returns empty array for new basket' do
      expect(basket.items).to eq([])
    end

    it 'returns all added items' do
      basket.add('R01')
      basket.add('G01')
      
      expect(basket.items).to eq([red_widget, green_widget])
    end
  end

  describe '#subtotal' do
    it 'returns 0 for empty basket' do
      expect(basket.subtotal).to eq(BigDecimal('0'))
    end

    it 'calculates sum of product prices' do
      basket.add('R01')
      basket.add('G01')
      
      # 32.95 + 24.95 = 57.90
      expect(basket.subtotal).to eq(BigDecimal('57.90'))
    end
  end

  describe '#total' do
    context 'with empty basket' do
      it 'returns only delivery cost' do
        # Empty basket = $0, delivery = $4.95
        expect(basket.total).to eq(BigDecimal('4.95'))
      end
    end

    context 'with no applicable offers' do
      it 'calculates subtotal + delivery' do
        basket.add('B01')
        basket.add('G01')
        
        # Subtotal: 7.95 + 24.95 = 32.90
        # Delivery: under $50 = 4.95
        # Total: 37.85
        expect(basket.total).to eq(BigDecimal('37.85'))
      end
    end

    context 'with applicable offers' do
      it 'applies discount before calculating delivery' do
        basket.add('R01')
        basket.add('R01')
        
        # Subtotal: 32.95 + 32.95 = 65.90
        # Offer: second R01 half price = -16.475
        # After discount: 49.425
        # Delivery: under $50 = 4.95
        # Total: 54.375 -> 54.37 (rounded)
        expect(basket.total).to eq(BigDecimal('54.37'))
      end
    end

    context 'when discounted total triggers free delivery' do
      it 'calculates delivery based on discounted amount' do
        basket.add('B01')
        basket.add('B01')
        basket.add('R01')
        basket.add('R01')
        basket.add('R01')
        
        # Subtotal: 7.95 + 7.95 + 32.95 + 32.95 + 32.95 = 114.75
        # Offer: 2nd R01 half price = -16.475
        # After discount: 98.275
        # Delivery: >= $90 = 0
        # Total: 98.275 -> 98.27 (rounded)
        expect(basket.total).to eq(BigDecimal('98.27'))
      end
    end
  end

  describe 'integration with requirement examples' do
    context 'Example 1: B01, G01' do
      it 'calculates total as $37.85' do
        basket.add('B01')
        basket.add('G01')
        
        expect(basket.total).to eq(BigDecimal('37.85'))
      end
    end

    context 'Example 2: R01, R01' do
      it 'calculates total as $54.37' do
        basket.add('R01')
        basket.add('R01')
        
        expect(basket.total).to eq(BigDecimal('54.37'))
      end
    end

    context 'Example 3: R01, G01' do
      it 'calculates total as $60.85' do
        basket.add('R01')
        basket.add('G01')
        
        expect(basket.total).to eq(BigDecimal('60.85'))
      end
    end

    context 'Example 4: B01, B01, R01, R01, R01' do
      it 'calculates total as $98.27' do
        basket.add('B01')
        basket.add('B01')
        basket.add('R01')
        basket.add('R01')
        basket.add('R01')
        
        expect(basket.total).to eq(BigDecimal('98.27'))
      end
    end
  end
end
