# spec/models/line_item_spec.rb
require 'rails_helper'

RSpec.describe LineItem, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_presence_of(:sku) }
  it { is_expected.to belong_to(:cart) }
end
