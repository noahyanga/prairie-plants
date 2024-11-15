ActiveAdmin.register Product do
  permit_params :name, :description, :price, :image

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :image do |product|
        image_tag product.image.variant(resize_to_limit: [100, 100]) if product.image.attached? # Display image thumbnail
      end
      row :created_at
    end
  end
end
