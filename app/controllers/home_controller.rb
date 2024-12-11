class HomeController < ApplicationController
  def index
    @products = Product.includes(:categories, :images).all
    @categories = Category.all

     if params[:keyword].present?
      @products = Product.where("name LIKE ? OR description LIKE ?", "%#{params[:keyword]}%",
"%#{params[:keyword]}%")
     else
      @products = Product.all
     end
  end
end
