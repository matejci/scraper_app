require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/preparation_helper.rb"
include PreparationHelper

logger = Logger.new("#{Rails.root}/log/mytheresa.log")
logger.level = Logger::WARN

namespace :cloth_fendi_mytheresa do

	desc "Prepare Fendi cloth data"
	task prepare: :environment do

		url = "http://www.mytheresa.com/en-us/designers/fendi/clothing.html"

		full_product_url_arr = []

		begin
			doc = Nokogiri::HTML(open(url))

			doc.css('.product-image').each do |product|
				product_url = product.attributes['href'].value
				full_product_url_arr << product_url
			end
		rescue OpenURI::HTTPError => err
			logger.fatal("#{Time.now} :Error: #{err}")
		end


		File.open("#{Rails.root}/lib/tasks/fashion/cloth/fendi/mytheresa/cloth.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end

	end

end
