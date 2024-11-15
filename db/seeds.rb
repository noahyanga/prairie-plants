require 'nokogiri'
require 'httparty'

# Define URLs for each category
CATEGORY_URLS = {
  'Indoor Plants'     => 'https://bloomscape.com/shop/plants/indoor-plant/',
  'Plant Decorations' => 'https://bloomscape.com/shop/plant-care-accessories/accessories/',
  'Pots & Planters'   => 'https://bloomscape.com/shop/plant-care-accessories/pots/',
  'Gardening Tools'   => 'https://bloomscape.com/shop/plant-care-accessories/tools/',
  'Supplies'          => 'https://bloomscape.com/shop/plant-care-accessories/supplies/'
}

ProductCategory.delete_all
Product.delete_all
Category.delete_all


# Method to scrape data for a specific category
def scrape_category(url, category_name)
  response = HTTParty.get(url)
  document = Nokogiri::HTML(response.body)
  products = []

  # Loop through each product element on the page to extract name and price
  document.css('li.product').each do |product|
    name = product.css('h2.woocommerce-loop-product__title.product-info__title').text.strip
    price_text = product.css('bdi').text.strip
    price = price_text.gsub(/[^\d.]/, '').to_f
    image_url = product.at_css('.single-img img')&.[]('src') || 'http://example.com/placeholder.jpg'
    description = "A quality #{category_name.downcase} product."

    products << { name: name, description: description, price: price, category_name: category_name }
  end

  products
end

# Categories
CATEGORY_URLS.each_key do |category_name|
  Category.find_or_create_by(name: category_name, description: "#{category_name} from Bloomscape.")
end

# Products and assign to categories
CATEGORY_URLS.each do |category_name, url|
  plants_data = scrape_category(url, category_name)
  category = Category.find_by(name: category_name)

  plants_data.each do |plant_data|
    # Create a product entry in the database
    product = Product.create(name: plant_data[:name], description: plant_data[:description],
price: plant_data[:price])
    ProductCategory.create(product: product, category: category)

    Image.create(product: product, image_url: plant_data[:image_url])
  end
end

puts "Seeding complete"

AdminUser.create!(
  email:                 'admin@example.com',
  password:              'password',
  password_confirmation: 'password'
) if Rails.env.development?
