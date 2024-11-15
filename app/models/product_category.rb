class ProductCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category

  def self.ransackable_attributes(_auth_object = nil)
    [ "category_id", "created_at", "id", "id_value", "product_id", "updated_at" ]
  end
end
