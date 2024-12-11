class CheckoutController < ApplicationController
  def new
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)
    @total_price = @products.sum { |product| product.price * @cart[product.id.to_s] }

    # Retrieve the province and calculate taxes if provided
    if params[:province].present?
      @province = Province.find(params[:province])
      @taxes = calculate_taxes(@province, @total_price)
    else
      @taxes = { pst: 0, gst: 0, hst: 0, total_taxes: 0, grand_total: @total_price }
    end
  end

  def create
    @cart = session[:cart] || {}
    @products = Product.where(id: @cart.keys)
    @total_price = @products.sum { |product| product.price * @cart[product.id.to_s] }

    # Retrieve the province for tax calculation
    @province = Province.find(params[:province])
    @taxes = calculate_taxes(@province, @total_price)

    # Create a customer record
    @customer = Customer.create(address: params[:address], province: @province)

    # Calculate grand total with taxes
    grand_total = @taxes[:grand_total]

    # Create an order for the customer
    @order = @customer.orders.create(total_price: grand_total)

    # Associate each product with the order
    @products.each do |product|
      quantity = @cart[product.id.to_s]
      @order.order_items.create(product: product, quantity: quantity, price: product.price)
    end

    # Clear the cart after order creation
    session[:cart] = {}

    # Redirect to a confirmation or success page
    redirect_to order_confirmation_path(@order)
  end

  private

  # Tax calculation method
  def calculate_taxes(province, total_price)
    pst = total_price * province.pst_rate
    gst = total_price * province.gst_rate
    hst = total_price * province.hst_rate

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
