class PagesController < ApplicationController
  def show
    @page = Page.find_by(title: params[:id]) # Ensure you're using title or id to find the page
  end
end
