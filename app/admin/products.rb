ActiveAdmin.register Product do
  permit_params :created_at, :updated_at, :name, :description, :price, category_ids: [], images_attributes: [:id, :image_url, :_destroy]

  # Index page
  index do
    selectable_column
    id_column
    column :name
    column :price
    column :categories do |product|
      product.categories.any? ? product.categories.map(&:name).join(", ") : "No categories assigned"
    end
    column :created_at
    column :updated_at
    actions
  end

  # Show page
  show do
    attributes_table do
      row :name
      row :price
      row :description
      row :categories do |product|
        product.categories.any? ? product.categories.map(&:name).join(", ") : "No categories assigned"
      end
      row :created_at
      row :updated_at
      row :images do |product|
        product.images.map { |img| image_tag(img.image_url.presence, size: "200x200") }.join.html_safe
      end
    end
  end

  # Form page
  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :categories, as: :select, multiple: true, collection: Category.all
      f.has_many :images, allow_destroy: true, new_record: true do |i|
        i.input :image_url, as: :file
      end
      # Use datetime_select for created_at and updated_at
      f.input :created_at, as: :datetime_select
      f.input :updated_at, as: :datetime_select
    end
    f.actions
  end

  # Filters
  filter :name
  filter :price
  filter :categories, as: :check_boxes, collection: Category.all
  filter :created_at
end
