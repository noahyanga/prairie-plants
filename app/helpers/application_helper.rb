module ApplicationHelper
  def breadcrumbs
    breadcrumb_parts = []
    
    # Home link
    breadcrumb_parts << link_to("Home", root_path)
    
    # Category breadcrumbs (if present)
    if @category
      # Breadcrumb for each parent category
      category_hierarchy = @category.ancestors + [@category]
      category_hierarchy.each do |category|
        breadcrumb_parts << link_to(category.name, category_path(category))
      end
    end
    
    # Product breadcrumb (if present)
    if @product
      if @product.categories.any?
        breadcrumb_parts << link_to(@product.categories.first.name, category_path(@product.categories.first))
      end
      breadcrumb_parts << @product.name
    end
    
    # Join all breadcrumb parts with " > " separator
    breadcrumb_parts.join("&gt;&nbsp; ").html_safe
  end
end
