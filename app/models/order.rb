class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products
  has_many :products, through: :order_products

  validates :user_id, numericality: { only_integer: true }
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :payment_id, presence: true
end
