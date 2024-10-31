class DiscountConfig < ApplicationRecord
  serialize :prerequisite_skus, Array
  serialize :eligible_skus, Array
end
