class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.string :city
      t.string :postal_code
      t.string :street_address
      t.references :province, null: false, foreign_key: true

      t.timestamps
    end
  end
end
