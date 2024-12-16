require 'nokogiri'
require 'httparty'
require 'open-uri' # To download images
require 'fileutils'

# URLs for each category
CATEGORY_URLS = {
  'Indoor Plants'     => 'https://bloomscape.com/shop/plants/indoor-plant/',
  'Plant Decorations' => 'https://bloomscape.com/shop/plant-care-accessories/accessories/',
  'Pots & Planters'   => 'https://bloomscape.com/shop/plant-care-accessories/pots/',
  'Gardening Tools'   => 'https://bloomscape.com/shop/plant-care-accessories/tools/',
  'Supplies'          => 'https://bloomscape.com/shop/plant-care-accessories/supplies/'
}

# Clear existing data
puts "Cleaning database..."
ProductCategory.delete_all
Product.delete_all
Category.delete_all
Province.delete_all

# Method to scrape data for a specific category
def scrape_category(url, category_name)
  response = HTTParty.get(url)
  document = Nokogiri::HTML(response.body)
  products = []

  # Loop through each product element on the page to extract name, price, and image
  document.css('li.product').each do |product|
    name = product.css('h2.woocommerce-loop-product__title.product-info__title').text.strip
    price_text = product.css('bdi').text.strip
    price = price_text.gsub(/[^\d.]/, '').to_f
    image_url = product.at_css('.single-img img')&.[]('src') || '/placeholder.jpg'
    description = "A quality #{category_name.downcase} product."

    products << { name: name, description: description, price: price, category_name: category_name,
image_url: image_url }
  end

  products
end

# Seeding categories and products
puts "Seeding categories and products..."
ActiveRecord::Base.transaction do
  # Create categories
  CATEGORY_URLS.each_key do |category_name|
    Category.find_or_create_by!(name:        category_name,
                                description: "#{category_name} from Bloomscape.")
  end

  # Scrape and seed products
  CATEGORY_URLS.each do |category_name, url|
    puts "Scraping category: #{category_name}"
    plants_data = scrape_category(url, category_name)
    category = Category.find_by(name: category_name)

    plants_data.each do |plant_data|
      # Create product and associate it with the category
      product = Product.create!(
        name:        plant_data[:name],
        description: plant_data[:description],
        price:       plant_data[:price]
      )

# Download and save the image to the local uploads directory
if plant_data[:image_url] && plant_data[:image_url] != '/placeholder.jpg'
  image_url = plant_data[:image_url]

  # Remove the query string from the URL (everything after ?)
  image_url_without_query = image_url.split('?').first

  # Extract file extension from the image URL (after removing the query string)
  image_filename = URI.basename(image_url_without_query)
  extension = URI.extname(image_filename).downcase

  # Check for valid image extensions before downloading
  valid_extensions = [ '.jpg', '.jpeg', '.png', '.gif' ]

  if valid_extensions.include?(extension)
    image_path = Rails.root.join('public', 'uploads', 'products', image_filename)

    # Ensure the directory exists
    FileUtils.mkdir_p(Rails.root.join('public', 'uploads', 'products'))

    # Download and save the image
    URI.open(image_path, 'wb') do |file|
      file.write(URI.open(image_url).read)
    end

    # Attach the image to the product
    product.image = URI.open(image_path)
    product.save!
  else
    puts "Skipping invalid image: #{image_url}"
  end
end



      # Associate product with category
      ProductCategory.create!(product: product, category: category)
    end
  end
end

# Seeding provinces
puts "Seeding provinces..."
provinces_data = [
  { name: 'Alberta', pst_rate: 0.0, gst_rate: 0.05, hst_rate: 0.0 },
  { name: 'British Columbia', pst_rate: 0.07, gst_rate: 0.05, hst_rate: 0.0 },
  { name: 'Manitoba', pst_rate: 0.07, gst_rate: 0.05, hst_rate: 0.0 },
  { name: 'New Brunswick', pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.15 },
  { name: 'Newfoundland and Labrador', pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.15 },
  { name: 'Northwest Territories', pst_rate: 0.0, gst_rate: 0.05, hst_rate: 0.0 },
  { name: 'Nova Scotia', pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.15 },
  { name: 'Nunavut', pst_rate: 0.0, gst_rate: 0.05, hst_rate: 0.0 },
  { name: 'Ontario', pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.13 },
  { name: 'Prince Edward Island', pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.15 },
  { name: 'Quebec', pst_rate: 0.09975, gst_rate: 0.05, hst_rate: 0.0 },
  { name: 'Saskatchewan', pst_rate: 0.06, gst_rate: 0.05, hst_rate: 0.0 },
  { name: 'Yukon', pst_rate: 0.0, gst_rate: 0.05, hst_rate: 0.0 }
]

provinces_data.each do |province_data|
  Province.create!(province_data)
end

# Create admin user
puts "Creating admin user..."
AdminUser.create!(
  email:                 ENV.fetch('ADMIN_EMAIL', 'admin@example.com'),
  password:              ENV.fetch('ADMIN_PASSWORD', 'password'),
  password_confirmation: ENV.fetch('ADMIN_PASSWORD', 'password')
) if Rails.env.development?

puts "Seeding complete!"
