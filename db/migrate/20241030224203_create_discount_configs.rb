class CreateDiscountConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :discount_configs do |t|
      t.text :prerequisite_skus
      t.text :eligible_skus
      t.string :discount_unit
      t.decimal :discount_value, precision: 5, scale: 2

      t.timestamps
    end
  end
end
