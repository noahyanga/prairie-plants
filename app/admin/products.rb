ActiveAdmin.register Product do
  permit_params :created_at, :updated_at, :name, :description, :price, :image, category_ids: []

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
      row :image do |product|
        if product.image.present?
          image_tag product.image.url(), size: "400x400"
        else
          "No image available"
        end
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
      f.input :image, as: :file # File upload for image
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
