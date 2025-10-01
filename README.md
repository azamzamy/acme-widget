# Acme Widget Co - Sales System

A proof of concept for Acme Widget Co's new sales system, built using **Test-Driven Development (TDD)** in Ruby. This system demonstrates clean architecture, dependency injection,## Development Approach

This project was built using **Test-Driven Development (TDD)**:

1. **RED** - Write failing tests first
2. **GREEN** - Implement minimal code to pass tests
3. **REFACTOR** - Clean up code while keeping tests green


## Products

| Product Code | Name | Price |
|--------------|------|-------|
| R01 | Red Widget | $32.95 |
| G01 | Green Widget | $24.95 |
| B01 | Blue Widget | $7.95 |

## Features

- **Product Catalogue Management** - Efficient product lookup by code
- **Shopping Basket** - Add products and calculate totals
- **Tiered Delivery Pricing** - Cost based on order value
- **Extensible Offers System** - Strategy pattern for promotions
- **Precise Money Calculations** - Using BigDecimal for accuracy

## Installation

```bash
# Clone the repository
git clone https://github.com/azamzamy/acme-widget.git
cd acme-widget

# Install dependencies
bundle install
```

## Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/basket_spec.rb

# Run with documentation format
bundle exec rspec --format documentation
```

## Usage

### Quick Demo

```bash
ruby demo.rb
```

### Basic Usage Example

```ruby
require_relative 'lib/product'
require_relative 'lib/catalogue'
require_relative 'lib/delivery_rules'
require_relative 'lib/offers/buy_one_get_second_half_price'
require_relative 'lib/basket'

# 1. Create products
red = Product.new('R01', 'Red Widget', 32.95)
green = Product.new('G01', 'Green Widget', 24.95)
blue = Product.new('B01', 'Blue Widget', 7.95)

# 2. Initialize catalogue
catalogue = Catalogue.new([red, green, blue])

# 3. Set up delivery rules
delivery_rules = DeliveryRules.new

# 4. Configure offers
offers = [BuyOneGetSecondHalfPrice.new('R01')]

# 5. Create basket with dependency injection
basket = Basket.new(catalogue, delivery_rules, offers)

# 6. Add products
basket.add('B01')
basket.add('G01')

# 7. Get total
puts basket.total  # => 37.85
```

## Architecture

### Design Patterns & Principles

#### 1. **Dependency Injection**
All dependencies are injected through constructors, making the system testable and flexible:

```ruby
basket = Basket.new(catalogue, delivery_rules, offers)
```

#### 2. **Strategy Pattern**
Offers use the Strategy pattern for extensible discount logic:

```ruby
class BaseOffer
  def calculate_discount(items)
    raise NotImplementedError
  end
end

class BuyOneGetSecondHalfPrice < BaseOffer
  def calculate_discount(items)
    # Specific discount logic
  end
end
```

#### 3. **Single Responsibility Principle**
Each class has one clear purpose:
- `Product` - Represents a product (immutable value object)
- `Catalogue` - Manages product inventory and lookup
- `DeliveryRules` - Calculates shipping costs
- `BaseOffer` - Abstract offer interface
- `BuyOneGetSecondHalfPrice` - Specific offer implementation
- `Basket` - Orchestrates the shopping experience

#### 4. **Encapsulation**
Internal details are hidden, exposing only necessary interfaces:
- Product prices stored as BigDecimal internally
- Catalogue uses hash lookup for efficiency (hidden from users)
- Basket calculation logic is private

### Class Structure

```
lib/
├── product.rb                 # Product value object
├── catalogue.rb               # Product catalogue
├── delivery_rules.rb          # Delivery cost calculator
├── basket.rb                  # Main basket orchestrator
└── offers/
    ├── base_offer.rb         # Abstract offer base class
    └── buy_one_get_second_half_price.rb  # Specific offer
```

## Delivery Rules

| Order Total | Delivery Cost |
|-------------|---------------|
| Under $50 | $4.95 |
| $50 - $89.99 | $2.95 |
| $90 or more | FREE |

**Note:** Delivery cost is calculated on the order total *after* discounts are applied.

## Current Offers

### Buy One Red Widget, Get Second Half Price
- Applies to Red Widgets (R01) only
- Every second widget in a pair gets 50% off
- Example: Buy 4 red widgets → 2nd and 4th are half price

## Test Results - Requirement Examples

| Products | Expected Total | Actual Total | Status |
|----------|---------------|--------------|--------|
| B01, G01 | $37.85 | $37.85 | ✅ |
| R01, R01 | $54.37 | $54.37 | ✅ |
| R01, G01 | $60.85 | $60.85 | ✅ |
| B01, B01, R01, R01, R01 | $98.27 | $98.27 | ✅ |

**Test Suite:** 53 examples, 0 failures

## Extending the System

### Adding a New Product

```ruby
orange_widget = Product.new('O01', 'Orange Widget', 19.95)
catalogue = Catalogue.new([red, green, blue, orange_widget])
```

### Adding a New Offer

```ruby
class BuyTwoGetOneFree < BaseOffer
  def initialize(product_code)
    @product_code = product_code
  end

  def calculate_discount(items)
    matching = items.select { |item| item.code == @product_code }
    free_items = matching.count / 3
    matching.first.price * free_items
  end
end

# Use it
offers = [
  BuyOneGetSecondHalfPrice.new('R01'),
  BuyTwoGetOneFree.new('B01')
]
```

## Assumptions

1. **Rounding**: Final totals are rounded down (floor) to 2 decimal places to match expected outputs
2. **Product Codes**: Case-sensitive (e.g., 'R01' ≠ 'r01')
3. **Offers**: Applied in the order they're provided in the array
4. **Delivery**: Calculated after all discounts are applied
5. **Currency**: All prices in USD (implicit)
6. **Offer Pairing**: "Buy one get second half price" applies to every pair (2nd, 4th, 6th items discounted)
7. **Empty Basket**: Returns delivery cost only ($4.95)
8. **Invalid Product Code**: Raises ArgumentError when adding unknown product

## Development Approach

This project was built using **Test-Driven Development**:

1. **RED** - Write failing tests first
2. **GREEN** - Implement minimal code to pass tests
3. **REFACTOR** - Clean up code while keeping tests green

## AI Usage

This project utilized AI assistance (GitHub Copilot) in the following areas:

- **Test Case Generation**: AI was used to generate comprehensive test cases covering edge cases, boundary conditions, and integration scenarios
- **Demo Script**: The `demo.rb` file was created with AI assistance to showcase all requirement examples
- **Documentation**: Parts of this README, including code examples, architecture explanations, and usage instructions were generated with AI support

The core business logic, design decisions, and overall architecture was developed by me.

