require_relative '../../lib/offers/base_offer'
require_relative '../../lib/product'

RSpec.describe BaseOffer do
  let(:red_widget) { Product.new('R01', 'Red Widget', 32.95) }
  let(:green_widget) { Product.new('G01', 'Green Widget', 24.95) }

  describe '#calculate_discount' do
    it 'raises NotImplementedError when not overridden' do
      offer = BaseOffer.new
      
      expect { offer.calculate_discount([red_widget]) }.to raise_error(NotImplementedError)
    end
  end

  describe '#applicable?' do
    it 'returns false by default when not overridden' do
      offer = BaseOffer.new
      
      expect(offer.applicable?([red_widget])).to be false
    end
  end
end
