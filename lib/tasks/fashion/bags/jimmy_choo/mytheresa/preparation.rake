require 'nokogiri'
require 'open-uri'

logger = Logger.new("#{Rails.root}/log/mytheresa.log")
logger.level = Logger::WARN

namespace :bags_jimmy_mytheresa do

	desc "Prepare Jimmy Choo bags data"
	task prepare: :environment do

		url = "http://www.mytheresa.com/en-us/designers/jimmy-choo/bags.html"

		full_product_url_arr = []

		begin
			doc = Nokogiri::HTML(open(url))

			doc.css('.product-image').each do |product|
				product_url = product.attributes['href'].value
				full_product_url_arr << product_url
			end
		rescue OpenURI::HTTPError => err
			logger.fatal("#{Time.now} :Error: #{err}")
			next
		end

		File.open("#{Rails.root}/lib/tasks/fashion/bags/jimmy_choo/mytheresa/bags.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end

	end

end
