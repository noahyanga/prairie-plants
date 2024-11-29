class ProductsController < ApplicationController
  before_action :initialize_cart

  def index
    @categories = Category.all
    wildcard_search = "%#{params[:keyword]}%"

    if params[:keyword].present? || params[:category_id].present?
      @products = Product.where("name LIKE ? OR description LIKE ?", "%#{params[:keyword]}%",
"%#{params[:keyword]}%")
                          .where(category_id: params[:category_id])
    else
      # Search all products by name or description
      @products = Product.where("name LIKE ? OR description LIKE ?", wildcard_search,
wildcard_search)
    end
  end


  def show
    @categories = Category.all
    @product = Product.find(params[:id])
  end

  def search
    @categories = Category.all
    wildcard_search = "%#{params[:keyword]}%"

    if params[:category_id].present?
      @category = Category.find_by(id: params[:category_id])
      # Search products by name or description and also by category_id (through the join)
      @products = Product.joins(:categories)
        .where("products.name LIKE ? OR products.description LIKE ?",
        wildcard_search, wildcard_search)
        .where(categories: { id: params[:category_id] })
    else
      # Search all products by name or description
      @products = Product.where("name LIKE ? OR description LIKE ?",
      wildcard_search, wildcard_search)
    end

    render :search
  end

  def add_to_cart
    product_id = params[:id].to_i
    session[:cart] ||= []  # Initialize as empty array if nil

    unless session[:cart].include?(product_id)
      session[:cart] << product_id  # Add product to cart
      flash[:notice] = "Product added to cart."
    else
      flash[:alert] = "Product is already in cart."
    end

    redirect_to cart_path
  end



  def remove_from_cart
  product_id = params[:id].to_i # Ensure product_id is an integer
  session[:cart] ||= []         # Initialize cart as an array if it is nil

  if session[:cart].include?(product_id)
    session[:cart].delete(product_id)  # Remove the product by its ID
    flash[:notice] = "Product removed from cart."
  else
    flash[:alert] = "Product not in cart."
  end

  redirect_to carts_path
end

  def cart
    @cart_items = session[:cart].map do |product_id, quantity|
      product = Product.find(product_id)
      { product: product, quantity: quantity }
    end
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end

end
