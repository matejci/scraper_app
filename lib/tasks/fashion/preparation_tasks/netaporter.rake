require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/preparation_helper.rb"
include PreparationHelper

logger = Logger.new("#{Rails.root}/log/netaporter.log")
logger.level = Logger::WARN

namespace :netaporter_prepare_task do

	desc "Prepare all clothing data"
	task all_clothing: :environment do
		host = "https://www.net-a-porter.com"
		url_arr = ["https://www.net-a-porter.com/us/en/d/Shop/Clothing/All?cm_sp=topnav-_-clothing-_-allclothing&pn=", "&npp=60&image_view=product&dScroll=0"]
		number_of_pages = 135
		full_product_url_arr = []

		for i in 1..number_of_pages

			parse_url = url_to_parse(url_arr, i)

			begin
				doc = Nokogiri::HTML(open(parse_url))

				doc.css('.product-image').each do |product|
					product_url = product.children().css('a').attr('href').value
					full_product_url_arr << (host + product_url)
				end

			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err}")
				next
			end

		end

		File.open("#{Rails.root}/lib/tasks/fashion/data/netaporter/preparation_all_clothing.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end
	end

	desc "Prepare all shoes data"
	task all_shoes: :environment do
		host = "https://www.net-a-porter.com"
		url_arr = ["https://www.net-a-porter.com/us/en/d/Shop/Shoes/All?cm_sp=topnav-_-shoes-_-allshoes&pn=", "&npp=60&image_view=product&dScroll=0"]
		number_of_pages = 39
		full_product_url_arr = []

		for i in 1..number_of_pages

			parse_url = url_to_parse(url_arr, i)

			begin
				doc = Nokogiri::HTML(open(parse_url))

				doc.css('.product-image').each do |product|
					product_url = product.children().css('a').attr('href').value
					full_product_url_arr << (host + product_url)
				end
			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err}")
				next
			end

		end

		File.open("#{Rails.root}/lib/tasks/fashion/data/netaporter/preparation_all_shoes.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end
	end

	desc "Prepare all bags data"
	task all_bags: :environment do
		host = "https://www.net-a-porter.com"
		url_arr = ["https://www.net-a-porter.com/us/en/d/Shop/Bags/All?cm_sp=topnav-_-bags-_-allbags&pn=", "&npp=60&image_view=product&dScroll=0"]
		number_of_pages = 30
		full_product_url_arr = []

		for i in 1..number_of_pages

			parse_url = url_to_parse(url_arr, i)

			begin
				doc = Nokogiri::HTML(open(parse_url))

				doc.css('.product-image').each do |product|
					product_url = product.children().css('a').attr('href').value
					full_product_url_arr << (host + product_url)
				end

			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err}")
				next
			end

		end

		File.open("#{Rails.root}/lib/tasks/fashion/data/netaporter/preparation_all_bags.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end
	end

	desc "Prepare all accessories data"
	task all_accessories: :environment do
		host = "https://www.net-a-porter.com"
		url_arr = ["https://www.net-a-porter.com/us/en/d/Shop/Accessories/All?cm_sp=topnav-_-accessories-_-allaccessories&pn=", "&npp=60&image_view=product&dScroll=0"]
		number_of_pages = 48
		full_product_url_arr = []

		for i in 1..number_of_pages

			parse_url = url_to_parse(url_arr, i)

			begin
				doc = Nokogiri::HTML(open(parse_url))

				doc.css('.product-image').each do |product|
					product_url = product.children().css('a').attr('href').value
					full_product_url_arr << (host + product_url)
				end
			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err}")
				next
			end

		end

		File.open("#{Rails.root}/lib/tasks/fashion/data/netaporter/preparation_all_accessories.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end
	end

	desc "Prepare all jewelry data"
	task all_jewelry: :environment do
		host = "https://www.net-a-porter.com"
		url_arr = ["https://www.net-a-porter.com/us/en/d/Shop/Accessories/Jewelry?cm_sp=topnav-_-jewelry-_-alljewelry&pn=", "&npp=60&image_view=product&dScroll=0"]
		number_of_pages = 15
		full_product_url_arr = []

		for i in 1..number_of_pages

			parse_url = url_to_parse(url_arr, i)

			begin
				doc = Nokogiri::HTML(open(parse_url))

				doc.css('.product-image').each do |product|
					product_url = product.children().css('a').attr('href').value
					full_product_url_arr << (host + product_url)
				end
			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err}")
				next
			end

		end

		File.open("#{Rails.root}/lib/tasks/fashion/data/netaporter/preparation_all_jewelry.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end
	end

	desc "Prepare all lingerie data"
	task all_lingerie: :environment do
		host = "https://www.net-a-porter.com"
		url_arr = ["https://www.net-a-porter.com/us/en/d/Shop/Lingerie/All?cm_sp=topnav-_-lingerie-_-alllingerie&pn=", "&npp=60&image_view=product&dScroll=0"]
		number_of_pages = 16
		full_product_url_arr = []

		for i in 1..number_of_pages

			parse_url = url_to_parse(url_arr, i)

			begin
				doc = Nokogiri::HTML(open(parse_url))

				doc.css('.product-image').each do |product|
					product_url = product.children().css('a').attr('href').value
					full_product_url_arr << (host + product_url)
				end
			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err}")
				next
			end

		end

		File.open("#{Rails.root}/lib/tasks/fashion/data/netaporter/preparation_all_lingerie.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end
	end

	desc "Prepare all sportswear data"
	task all_sportswear: :environment do
		host = "https://www.net-a-porter.com"
		url_arr = ["https://www.net-a-porter.com/us/en/d/Shop/Sport/All_Sportswear?cm_sp=topnav-_-sport-_-allsportswear&pn=", "&npp=60&image_view=product&dScroll=0"]
		number_of_pages = 10
		full_product_url_arr = []

		for i in 1..number_of_pages

			parse_url = url_to_parse(url_arr, i)

			begin
				doc = Nokogiri::HTML(open(parse_url))

				doc.css('.product-image').each do |product|
					product_url = product.children().css('a').attr('href').value
					full_product_url_arr << (host + product_url)
				end
			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err}")
				next
			end

		end

		File.open("#{Rails.root}/lib/tasks/fashion/data/netaporter/preparation_all_sportswear.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end
	end

	desc "Prepare all beauty data"
	task all_beauty: :environment do
		host = "https://www.net-a-porter.com"
		url_arr = ["https://www.net-a-porter.com/us/en/d/Shop/Beauty/All?cm_sp=topnav-_-beauty-_-allbeauty&pn=", "&npp=60&image_view=product&dScroll=0"]
		number_of_pages = 92
		full_product_url_arr = []

		for i in 1..number_of_pages

			parse_url = url_to_parse(url_arr, i)

			begin
				doc = Nokogiri::HTML(open(parse_url))

				doc.css('.product-image').each do |product|
					product_url = product.children().css('a').attr('href').value
					full_product_url_arr << (host + product_url)
				end
			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err}")
				next
			end

		end

		File.open("#{Rails.root}/lib/tasks/fashion/data/netaporter/preparation_all_beauty.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end
	end

end

