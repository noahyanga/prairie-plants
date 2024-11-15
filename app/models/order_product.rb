class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price_at_purchase, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(_auth_object = nil)
    [ "created_at", "id", "order_id", "price_at_purchase", "product_id", "quantity", "updated_at" ]
  end
end
