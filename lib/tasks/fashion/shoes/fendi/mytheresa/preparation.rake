require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/preparation_helper.rb"
include PreparationHelper

logger = Logger.new("#{Rails.root}/log/mytheresa.log")
logger.level = Logger::WARN

namespace :shoes_fendi_mytheresa do

	desc "Prepare Fendi shoes data"
	task prepare: :environment do


		url = "http://www.mytheresa.com/en-us/designers/fendi/shoes.html"
		full_product_url_arr = []

		doc = Nokogiri::HTML(open(url))

		doc.css('.product-image').each do |product|
			product_url = product.attributes['href'].value
			full_product_url_arr << product_url
		end

		File.open("#{Rails.root}/lib/tasks/fashion/shoes/fendi/mytheresa/shoes.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end

	end

end
