class HomeController < ApplicationController
  def index
    @products = Product.includes(:categories, :images).all
    @categories = Category.all
  end
end
