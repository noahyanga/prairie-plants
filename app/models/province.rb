class Province < ApplicationRecord
  has_many :addresses

  validates :name, presence: true
  validates :pst_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :gst_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_rate, numericality: { greater_than_or_equal_to: 0 }
end
