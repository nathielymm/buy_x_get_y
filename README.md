# Cereal Shop Discount API
This Ruby on Rails API provides a "Buy X Get Y" discount feature for a cereal shop's shopping cart. This feature is designed to offer customers a special holiday promotion. Customers who purchase a qualifying product from a designated list receive a discount on an additional product from a separate list of eligible items.

## 📝 Features
  - Customizable Discounts: Customers purchasing items from the "X" list qualify to receive a discount on an item from the "Y" list.
  - Intelligent Discount Application: The API applies the discount to the least expensive item within the eligible list, ensuring the best possible offer.
  - JSON Response: Returns the discounted price for each item in the cart and the final total cost after discounts.
    
## 🔧 Technology Used
  - Ruby on Rails: MVC framework for building a scalable and robust API.
  - RSpec: Testing framework to ensure the reliability and quality of the API

## 📊 Project Structure
  - app/models - Models for Cart and Line Item.
  - app/services - The DiscountCalculator service, encapsulates the discount calculation logic.
  - app/controllers - Controller for handling the API endpoint.
  - spec - Automated tests to ensure API accuracy.

## 🚀 Getting Started
  1. Clone the repository:
     ```bash
     git clone git@github.com:nathielymm/buy_x_get_y.git
     ```

  2. Install dependencies:
     ```bash
     cd buy_x_get_y
     bundle install
     ```
  3. Migrate the database
     ```bash
     rails db:migrate
     ```
  4. Run tests:
      ```bash
     rspec
     ```
  5. Start the Rails server:
     ```bash
     rails s
     ```
     
## 📌 Usage Example
**Request Parameters**:
- `cart`: JSON object with the following properties:
  - `reference`: A unique identifier for the cart.
  - `lineItems`: Array of item objects, where each item has:
    - `name`: Name of the item.
    - `price`: Price of the item.
    - `sku`: SKU (Stock Keeping Unit) identifier for the item.

**Example Request**:
To calculate the total cost of a shopping cart with applied discounts, make a POST request to:
```json
POST /api/v1/carts/calculate_total
{
  "cart": {
    "reference": "2d832fe0-6c96-4515-9be7-4c00983539c1",
    "lineItems": [
      { "name": "Peanut Butter", "price": "39.0", "sku": "PEANUT-BUTTER" },
      { "name": "Fruity", "price": "34.99", "sku": "FRUITY" },
      { "name": "Chocolate", "price": "32", "sku": "CHOCOLATE" }
    ]
  }
}
```
##  🧪 Testing
The repository includes RSpec tests for API endpoints and discount calculation services to ensure full test coverage. After configuring, use the following command to run tests:
```bash
rspec
```
