class Address < ApplicationRecord
  belongs_to :province
  has_one :user

  validates :city, presence: true
  validates :postal_code, presence: true, format: {
    with:    /\A[A-Za-z0-9\s\-]+\z/,
    message: "must be a valid postal code"
  }
  validates :street_address, presence: true
  validates :province_id, numericality: { only_integer: true }
end
