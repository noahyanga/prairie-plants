class OrdersController < ApplicationController
  def confirmation
    @order = Order.find(params[:id])
  end
end