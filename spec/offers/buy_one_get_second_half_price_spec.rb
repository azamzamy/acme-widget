require_relative '../../lib/offers/buy_one_get_second_half_price'
require_relative '../../lib/product'
require 'bigdecimal'

RSpec.describe BuyOneGetSecondHalfPrice do
  let(:red_widget) { Product.new('R01', 'Red Widget', 32.95) }
  let(:green_widget) { Product.new('G01', 'Green Widget', 24.95) }
  let(:blue_widget) { Product.new('B01', 'Blue Widget', 7.95) }

  describe '#initialize' do
    it 'accepts a product code to apply the offer to' do
      offer = BuyOneGetSecondHalfPrice.new('R01')
      expect(offer).to be_a(BuyOneGetSecondHalfPrice)
    end
  end

  describe '#applicable?' do
    it 'returns true when at least 2 matching products exist' do
      offer = BuyOneGetSecondHalfPrice.new('R01')
      items = [red_widget, red_widget]
      
      expect(offer.applicable?(items)).to be true
    end

    it 'returns false when only 1 matching product exists' do
      offer = BuyOneGetSecondHalfPrice.new('R01')
      items = [red_widget]
      
      expect(offer.applicable?(items)).to be false
    end

    it 'returns false when no matching products exist' do
      offer = BuyOneGetSecondHalfPrice.new('R01')
      items = [green_widget, blue_widget]
      
      expect(offer.applicable?(items)).to be false
    end
  end

  describe '#calculate_discount' do
    context 'with two red widgets' do
      it 'applies half price to the second widget' do
        offer = BuyOneGetSecondHalfPrice.new('R01')
        items = [red_widget, red_widget]
        
        # Second widget half price: 32.95 / 2 = 16.475
        discount = offer.calculate_discount(items)
        expect(discount).to eq(BigDecimal('16.475'))
      end
    end

    context 'with three red widgets' do
      it 'applies half price to one widget only' do
        offer = BuyOneGetSecondHalfPrice.new('R01')
        items = [red_widget, red_widget, red_widget]
        
        # Only second widget gets discount: 32.95 / 2 = 16.475
        discount = offer.calculate_discount(items)
        expect(discount).to eq(BigDecimal('16.475'))
      end
    end

    context 'with four red widgets' do
      it 'applies half price to two widgets (2nd and 4th)' do
        offer = BuyOneGetSecondHalfPrice.new('R01')
        items = [red_widget, red_widget, red_widget, red_widget]
        
        # 2nd and 4th widgets get discount: 32.95 / 2 * 2 = 32.95
        discount = offer.calculate_discount(items)
        expect(discount).to eq(BigDecimal('32.95'))
      end
    end

    context 'with mixed products' do
      it 'only applies discount to the specified product code' do
        offer = BuyOneGetSecondHalfPrice.new('R01')
        items = [red_widget, green_widget, red_widget, blue_widget]
        
        # Only 2 red widgets, so discount on 2nd: 32.95 / 2 = 16.475
        discount = offer.calculate_discount(items)
        expect(discount).to eq(BigDecimal('16.475'))
      end
    end

    context 'with only one matching product' do
      it 'returns zero discount' do
        offer = BuyOneGetSecondHalfPrice.new('R01')
        items = [red_widget, green_widget]
        
        discount = offer.calculate_discount(items)
        expect(discount).to eq(BigDecimal('0'))
      end
    end

    context 'with no matching products' do
      it 'returns zero discount' do
        offer = BuyOneGetSecondHalfPrice.new('R01')
        items = [green_widget, blue_widget]
        
        discount = offer.calculate_discount(items)
        expect(discount).to eq(BigDecimal('0'))
      end
    end
  end
end
