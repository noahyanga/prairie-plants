ActiveAdmin.register Product do
  permit_params :name, :description, :price, :category_ids, images_attributes: [:id, :image_url, :_destroy]

  # Index page - how products are listed
  index do
    selectable_column
    id_column
    column :name
    column :price
    column :categories do |product|
      product.categories.map(&:name).join(", ")
    end
    column :created_at
    column :updated_at
    actions
  end

  # Show page - details of a single product
  show do
    attributes_table do
      row :name
      row :price
      row :description
      row :categories do |product|
        product.categories.map(&:name).join(", ")
      end
      row :created_at
      row :updated_at
      row :images do |product|
  product.images.map { |img| image_tag(img.image_url.presence, size: "200x200") }.join.html_safe
end
    end
  end

  # Form page - how products are edited/created
  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :categories, as: :select, multiple: true, collection: Category.all
      f.has_many :images, allow_destroy: true, new_record: true do |i|
        i.input :image_url, as: :file
      end
    end
    f.actions
  end

  # Filters - to filter products by category and price
  filter :name
  filter :price
  filter :categories, as: :select, collection: Category.all
  filter :created_at
end
