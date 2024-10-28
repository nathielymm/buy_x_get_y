class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.string :name
      t.decimal :price
      t.string :sku
      t.references :cart, null: false, foreign_key: true

      t.timestamps
    end
  end
end
