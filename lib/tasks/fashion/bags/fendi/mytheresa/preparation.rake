require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/preparation_helper.rb"
include PreparationHelper

logger = Logger.new("#{Rails.root}/log/mytheresa.log")
logger.level = Logger::WARN

namespace :bags_fendi_mytheresa do

	desc "Prepare Fendi bags data"
	task prepare: :environment do

		base_url = "http://www.mytheresa.com/en-us/designers/fendi/bags.html?p="
		number_of_pages = 2
		full_product_url_arr = []

		for i in 1..number_of_pages

			parse_url = PreparationHelper.mytheresa_parse_url(base_url, i)

			begin
				doc = Nokogiri::HTML(open(parse_url))

				doc.css('.product-image').each do |product|
					product_url = product.attributes['href'].value
					full_product_url_arr << product_url
				end
			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err}")
				next
			end

		end

		File.open("#{Rails.root}/lib/tasks/fashion/bags/fendi/mytheresa/bags.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end

	end

end
