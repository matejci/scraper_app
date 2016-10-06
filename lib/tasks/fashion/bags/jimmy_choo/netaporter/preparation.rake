require 'nokogiri'
require 'open-uri'

logger = Logger.new("#{Rails.root}/log/netaporter.log")
logger.level = Logger::WARN

namespace :bags_jimmy_netaporter do

	desc "Prepare Jimmy Choo bags data"
	task prepare: :environment do

		host = "https://www.net-a-porter.com"
		url = "https://www.net-a-porter.com/us/en/Shop/Designers/Jimmy_Choo/Bags?pn=1&npp=60&image_view=product&dScroll=0"

		doc = Nokogiri::HTML(`curl #{url}`)

		full_product_url_arr = []

		doc.css('.product-image').each do |product|
			product_url = product.children().css('a').attr('href').value
			full_product_url_arr << (host + product_url)
		end

		File.open("#{Rails.root}/lib/tasks/fashion/bags/jimmy_choo/netaporter/bags.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end

	end

end
