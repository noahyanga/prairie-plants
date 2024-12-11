class Province < ApplicationRecord
  has_many :addresses

  validates :name, presence: true
  validates :pst_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :gst_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_rate, numericality: { greater_than_or_equal_to: 0 }

    def calculate_taxes(total_price)
    pst = total_price * pst_rate
    gst = total_price * gst_rate
    hst = total_price * hst_rate

    total_taxes = pst + gst + hst
    grand_total = total_price + total_taxes

    {
      pst: pst.round(2),
      gst: gst.round(2),
      hst: hst.round(2),
      total_taxes: total_taxes.round(2),
      grand_total: grand_total.round(2)
    }
  end
end
