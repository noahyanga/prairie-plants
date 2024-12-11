class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    @products = @category.products.page(params[:page]).per(9)

    # Apply Keyword Search
    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      @products = @products.where("products.name LIKE ? OR products.description LIKE ?", keyword,
keyword)
    end

    # Apply Additional Filters
    case params[:filter]
    when "new"
      @products = @products.where("products.created_at >= ?", 3.days.ago)
    when "recently_updated"
      @products = @products.where("products.updated_at >= ?", 3.days.ago)
                           .where.not("products.created_at >= ?", 3.days.ago) # Exclude new products
    end

    # Prioritize recently updated products (within 3 days) in the result
    @products = @products.where("products.updated_at >= ?", 3.days.ago).order(updated_at: :desc)
  end
end
