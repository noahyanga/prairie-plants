class AddFileToImages < ActiveRecord::Migration[7.2]
  def change
    add_column :images, :file, :string
  end
end
