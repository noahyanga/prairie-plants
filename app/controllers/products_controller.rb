class ProductsController < ApplicationController
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
end
