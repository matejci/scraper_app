require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/preparation_helper.rb"
include PreparationHelper

logger = Logger.new("#{Rails.root}/log/netaporter.log")
logger.level = Logger::WARN

namespace :bags_fendi_netaporter do

	desc "Prepare Fendi bags data"
	task prepare: :environment do

		host = "https://www.net-a-porter.com"

		url_arr = ["https://www.net-a-porter.com/us/en/Shop/Designers/Fendi/Bags?pn=", "&npp=60&image_view=product&dScroll=0"]
		number_of_pages = 2
		full_product_url_arr = []

		for i in 1..number_of_pages

			url = PreparationHelper.netaporter_parse_url(url_arr, i)

			doc = Nokogiri::HTML(`curl #{url}`)

			doc.css('.product-image').each do |product|
				product_url = product.children().css('a').attr('href').value
				full_product_url_arr << (host + product_url)
			end

		end

		File.open("#{Rails.root}/lib/tasks/fashion/bags/fendi/netaporter/bags.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end

	end

end
