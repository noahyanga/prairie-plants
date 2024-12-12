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

    line_items = @products.map do |product|
      {
        price_data: {
          currency:     "cad",
          product_data: {
            name:        product.name,
            description: product.description
          },
          unit_amount:  (product.price * 100).to_i # Stripe expects amount in cents
        },
        quantity:   @cart[product.id.to_s]
      }
    end

    # Establish connection with Stripe
    session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      success_url:          checkout_success_url,
      cancel_url:           checkout_cancel_url,
      mode:                 "payment",
      line_items:           line_items
    )

    # Save the session ID in the session
    session[:stripe_session_id] = session.id # for success and cancel actions

    # Create an order and save the Stripe payment ID
    @order = Order.create(
      user:       current_user,
      total:      @total_price,
      payment_id: session.id
    )

    # Save the order ID in the session for the success action
    session[:order_id] = @order.id

    redirect_to session.url, allow_other_host: true
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
      pst:         pst.round(2),
      gst:         gst.round(2),
      hst:         hst.round(2),
      total_taxes: total_taxes.round(2),
      grand_total: grand_total.round(2)
    }
  end

  def success
    # Handle successful payment
  end

  def cancel
    # Handle canceled payment
  end
end
