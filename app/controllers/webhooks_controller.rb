class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV["STRIPE_ENDPOINT_SECRET"]
      )
    rescue JSON::ParserError => e
      render json: { error: "Invalid payload" }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: "Invalid signature" }, status: 400
      return
    end

    case event["type"]
    when "checkout.session.completed"
      session = event["data"]["object"]
      handle_checkout_session(session)
    end

    render json: { message: "success" }
  end

  private

  def handle_checkout_session(session)
    order = Order.find_by(payment_id: session.id)
    if order
      order.update(status: "paid")
    end
  end
end
