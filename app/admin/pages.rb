ActiveAdmin.register Page do
  permit_params :title, :content

  # Index page - how pages are listed
  index do
    selectable_column
    id_column
    column :title
    column :created_at
    column :updated_at
    actions
  end

  # Show page - details of a single page
  show do
    attributes_table do
      row :title
      row :content do |page|
        raw page.content # render HTML content if needed
      end
      row :created_at
      row :updated_at
    end
  end

  # Form page - how pages are edited/created
  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :text, input_html: { rows: 10, cols: 50 }
    end
    f.actions
  end
end
