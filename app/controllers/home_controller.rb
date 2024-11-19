class HomeController < ApplicationController
  def index
    @products = Product.includes(:categories, :images).all
  end
end
