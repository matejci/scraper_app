require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/mytheresa.log")
logger.level = Logger::WARN

namespace :shoes_versace_mytheresa do

	desc "Scrap Versace shoes data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/shoes/versace/mytheresa/shoes.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin

				doc = Nokogiri::HTML(open(link))

				images = doc.css(".gallery-image")
				images_parsed = []

				images.each do |i|
					images_parsed << "http:" + i.attributes['src'].value
				end

				images_parsed.each do |img|
					image_item = ImageItem.new()
					image_item.source = 'mytheresa'
					image_item.source_url = link
					image_item.name = doc.css('.product-img-box').children().css('h1').children().text
					image_item.description = doc.css('p.pal, p.product-description').children().first().text
					image_item.category = 'fashion'
					image_item.item_type = 'shoes'
					image_item.item_sub_type = 'Shoes'
					image_item.is_scraped = true
					image_item.manufacturer = 'Versace'

					keywords = ScraperHelper.process_keywords(image_item.name)
					image_item.keywords = {:keywords => keywords.to_s}

					sim_hashes = ScraperHelper.process_simhashes(keywords)
					image_item.sim_hashes = {:sim_hashes => sim_hashes}

					image_item.image_url = img
					image_item.save
				end
			rescue Errno::ENOENT => e
				logger.fatal("#{Time.now} :Error: #{e} -> link: #{link}")
				next
			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err} -> link: #{link}")
				next
			rescue NoMethodError => nme
				logger.fatal("#{Time.now} :Error: #{nme} -> link: #{link}")
				next
			end

		end

	end

end
