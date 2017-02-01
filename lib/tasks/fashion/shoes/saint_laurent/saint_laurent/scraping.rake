require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/saintlaurent.log")
logger.level = Logger::WARN

namespace :shoes_sl_sl do

	desc "Scrap Saint Laurent shoes data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/shoes/saint_laurent/saint_laurent/shoes.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

				images = doc.css('.alternativeImages li')
				images_parsed = []

				images.each do |i|
					images_parsed << i.css('img').attr('src').value.gsub("_9_", "_13_")
				end

				images_parsed.each do |img|
					image_item = ImageItem.new()
					image_item.source = 'saint_laurent'
					image_item.source_url = link
					image_item.name = doc.css('.inner.modelName').children().first().text
					image_item.description = doc.css('.editorialDescription').children().first().text.gsub("\r", "").gsub("\n", "").strip
					image_item.category = 'fashion'
					image_item.item_type = 'shoes'
					image_item.item_sub_type = 'Shoes'
					image_item.is_scraped = true
					image_item.manufacturer = 'SaintLaurent'

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
