logger = Logger.new("#{Rails.root}/log/gucci.log")
logger.level = Logger::WARN

namespace :cloth_gucci_gucci do

	desc "Prepare Gucci cloth data"
	task prepare: :environment do

		base_url = "https://www.gucci.com"
		full_product_url_arr = []

		dresses_url = "https://www.gucci.com/us/en/ca/women/womens-ready-to-wear/womens-dresses-c-women-readytowear-dresses?filter=%3ANewest"
		doc = Nokogiri::HTML(`curl #{dresses_url}`)
		doc.css('.product-tiles-grid-item-link').each do |product|
			product_url = product.attr('href')
			full_product_url_arr << (base_url + product_url)
		end

		sweaters_url = "https://www.gucci.com/us/en/ca/women/womens-ready-to-wear/womens-sweaters-cardigans-c-women-readytowear-sweaters-and-cardigans"
		doc = Nokogiri::HTML(`curl #{sweaters_url}`)
		doc.css('.product-tiles-grid-item-link').each do |product|
			product_url = product.attr('href')
			full_product_url_arr << (base_url + product_url)
		end

		skirts_url = "https://www.gucci.com/us/en/ca/women/womens-ready-to-wear/womens-skirts-c-women-readytowear-skirts"
		doc = Nokogiri::HTML(`curl #{skirts_url}`)
		doc.css('.product-tiles-grid-item-link').each do |product|
			product_url = product.attr('href')
			full_product_url_arr << (base_url + product_url)
		end

		pants_url = "https://www.gucci.com/us/en/ca/women/womens-ready-to-wear/womens-pants-shorts-c-women-readytowear-pants-and-shorts"
		doc = Nokogiri::HTML(`curl #{pants_url}`)
		doc.css('.product-tiles-grid-item-link').each do |product|
			product_url = product.attr('href')
			full_product_url_arr << (base_url + product_url)
		end

		coats_url = "https://www.gucci.com/us/en/ca/women/womens-ready-to-wear/womens-coats-furs-c-women-readytowear-coats-and-furs"
		doc = Nokogiri::HTML(`curl #{coats_url}`)
		doc.css('.product-tiles-grid-item-link').each do |product|
			product_url = product.attr('href')
			full_product_url_arr << (base_url + product_url)
		end

		shirts_url = "https://www.gucci.com/us/en/ca/women/womens-ready-to-wear/womens-sweatshirts-t-shirts-c-women-readytowear-sweatshirts-and-tshirts"
		doc = Nokogiri::HTML(`curl #{shirts_url}`)
		doc.css('.product-tiles-grid-item-link').each do |product|
			product_url = product.attr('href')
			full_product_url_arr << (base_url + product_url)
		end

		jeans_url = "https://www.gucci.com/us/en/ca/women/womens-ready-to-wear/womens-denim-c-women-readytowear-denim"
		doc = Nokogiri::HTML(`curl #{jeans_url}`)
		doc.css('.product-tiles-grid-item-link').each do |product|
			product_url = product.attr('href')
			full_product_url_arr << (base_url + product_url)
		end

		File.open("#{Rails.root}/lib/tasks/fashion/cloth/gucci/gucci/cloth.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end



	end

end

