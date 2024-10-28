class LineItem < ApplicationRecord
  belongs_to :cart

  validates :name, presence: true
  validates :price, presence: true
  validates :sku, presence: true
end
