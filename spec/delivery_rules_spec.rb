require_relative '../lib/delivery_rules'
require 'bigdecimal'

RSpec.describe DeliveryRules do
  let(:delivery_rules) { DeliveryRules.new }

  describe '#calculate_delivery_cost' do
    context 'when order total is under $50' do
      it 'charges $4.95 for delivery' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('49.99'))
        expect(cost).to eq(BigDecimal('4.95'))
      end

      it 'charges $4.95 for $0 order' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('0'))
        expect(cost).to eq(BigDecimal('4.95'))
      end

      it 'charges $4.95 for $25 order' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('25.00'))
        expect(cost).to eq(BigDecimal('4.95'))
      end
    end

    context 'when order total is between $50 and $89.99' do
      it 'charges $2.95 for delivery at $50' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('50.00'))
        expect(cost).to eq(BigDecimal('2.95'))
      end

      it 'charges $2.95 for delivery at $75' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('75.00'))
        expect(cost).to eq(BigDecimal('2.95'))
      end

      it 'charges $2.95 for delivery at $89.99' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('89.99'))
        expect(cost).to eq(BigDecimal('2.95'))
      end
    end

    context 'when order total is $90 or more' do
      it 'offers free delivery at $90' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('90.00'))
        expect(cost).to eq(BigDecimal('0'))
      end

      it 'offers free delivery at $100' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('100.00'))
        expect(cost).to eq(BigDecimal('0'))
      end

      it 'offers free delivery at $150' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('150.00'))
        expect(cost).to eq(BigDecimal('0'))
      end
    end

    context 'boundary testing' do
      it 'charges $4.95 at $49.99' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('49.99'))
        expect(cost).to eq(BigDecimal('4.95'))
      end

      it 'charges $2.95 at exactly $50.00' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('50.00'))
        expect(cost).to eq(BigDecimal('2.95'))
      end

      it 'charges $2.95 at $89.99' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('89.99'))
        expect(cost).to eq(BigDecimal('2.95'))
      end

      it 'is free at exactly $90.00' do
        cost = delivery_rules.calculate_delivery_cost(BigDecimal('90.00'))
        expect(cost).to eq(BigDecimal('0'))
      end
    end
  end
end
