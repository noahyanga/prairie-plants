class CartsController < ApplicationController
  def index
    @cart = session[:cart] || {} # Retrieve the cart from the session or initialize as an empty hash
    @products = Product.find(@cart.keys) # Find products by their IDs stored in the cart
    @total_price = @products.sum do |product|
      product.price * @cart[product.id.to_s].to_i
    end
  end

  def add_product
    @product = Product.find(params[:id])
    session[:cart] ||= {}
    if session[:cart][@product.id]
      session[:cart][@product.id] += 1
    else
      session[:cart][@product.id] = 1
    end
    redirect_to carts_path, notice: "#{@product.name} has been added to your cart."
  end

  def update_quantity
    product_id = params[:id].to_i
    new_quantity = params[:quantity].to_i
    if new_quantity >= 1
      session[:cart][product_id] = new_quantity
      redirect_to carts_path,
notice: "Quantity for #{Product.find(product_id).name} has been updated."
    else
      redirect_to carts_path, alert: "Quantity must be 1 or more."
    end
  end


  def remove_from_cart
    product_id = params[:id].to_s
    product = Product.find_by(id: product_id)

    if product && session[:cart].delete(product_id)
      flash[:notice] = "#{product.name} was removed from the cart."
    else
      flash[:alert] =
product ? "Failed to remove #{product.name} from the cart." : "Product not found."
    end
    redirect_to carts_path
  end

  def clear
    session[:cart] = {}
    redirect_to carts_path, notice: "Your cart has been emptied."
  end
end
