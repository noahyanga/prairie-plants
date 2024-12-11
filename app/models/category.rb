class Category < ApplicationRecord
  has_many :product_categories
  has_many :products, through: :product_categories, dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: "parent_id"
  validates :name, presence: true
  validates :description, presence: true

  def ancestors
    parent ? parent.ancestors + [ parent ] : []
  end
end
