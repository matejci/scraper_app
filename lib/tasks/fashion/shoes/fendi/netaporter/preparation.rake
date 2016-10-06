require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/preparation_helper.rb"
include PreparationHelper

logger = Logger.new("#{Rails.root}/log/netaporter.log")
logger.level = Logger::WARN

namespace :shoes_fendi_netaporter do

	desc "Prepare Fendi shoes data"
	task prepare: :environment do

		host = "https://www.net-a-porter.com"

		url = "https://www.net-a-porter.com/us/en/Shop/Designers/Fendi/Shoes?pn=1&npp=60&image_view=product&dScroll=0"
		full_product_url_arr = []

		doc = Nokogiri::HTML(`curl #{url}`)

		doc.css('.product-image').each do |product|
			product_url = product.children().css('a').attr('href').value
			full_product_url_arr << (host + product_url)
		end

		File.open("#{Rails.root}/lib/tasks/fashion/shoes/fendi/netaporter/shoes.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end

	end

end
