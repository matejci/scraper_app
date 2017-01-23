require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/versace.log")
logger.level = Logger::WARN

namespace :cloth_versace_versace do

	desc "Scrap Versace cloth data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/cloth/versace/versace/cloth.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

				images = doc.css('.productthumbnail')
				images_parsed = []

				images.each do |i|
					images_parsed << JSON.parse(i.attr('data-lgimg'))['url']
				end

				images_parsed.uniq!

				images_parsed.each do |img|
					image_item = ImageItem.new()
					image_item.source = 'versace'
					image_item.source_url = link
					image_item.name = doc.css('.product-name,h1').children().first().text.gsub("\n","")
					image_item.description = doc.css('.product-short-description.hide').children().first().text
					image_item.category = 'fashion'
					image_item.item_type = 'cloth'
					image_item.item_sub_type = 'Cloth'
					image_item.is_scraped = true
					image_item.manufacturer = 'Versace'

					keywords = ScraperHelper.process_keywords(image_item.name)
					image_item.keywords = {:keywords => keywords.to_s}

					sim_hashes = ScraperHelper.process_simhashes(keywords)
					image_item.sim_hashes = {:sim_hashes => sim_hashes}

					image_item.image_url = img
					image_item.save
				end

			rescue JSON::ParserError => je
				logger.fatal("#{Time.now} :Error: #{je} -> link: #{link}")
				next
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
