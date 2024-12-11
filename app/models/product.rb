class Product < ApplicationRecord
  has_many :images
  has_many :product_categories
  has_many :categories, through: :product_categories, dependent: :destroy
  has_many :order_products
  has_many :orders, through: :order_products

  accepts_nested_attributes_for :images, allow_destroy: true
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_associations(_auth_object = nil)
    [ "categories", "images", "order_products", "orders", "product_categories" ]
  end

  def self.ransackable_attributes(_auth_object = nil)
    [ "created_at", "description", "id", "name", "price", "updated_at" ]
  end
end
