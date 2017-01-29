require 'nokogiri'
require 'open-uri'
require "i18n"
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/burberry.log")
logger.level = Logger::WARN

namespace :cloth_bb_bb do

	desc "Scrap Burberry cloth data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/cloth/burberry/burberry/cloth.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

				images = doc.css('.asset-container.js-asset-container.gallery-asset-item-container')
				images_parsed = []

				images.each do |i|
					images_parsed << i.attributes['data-zoom-src'].value
				end

				images_parsed.each do |img|
					image_item = ImageItem.new()
					image_item.source = 'burberry'
					image_item.source_url = link
					image_item.name = doc.css('.product-title.transaction-title.ta-transaction-title.h2').children().first().text.gsub("\n", "").gsub("\t", "").strip.parameterize(" ")
					image_item.description = doc.css('.cell-paragraph.cell-paragraph_description.ta-cell-paragraph_description.description-cell__details-copy.p2 li').first().children().first().text
					image_item.category = 'fashion'
					image_item.item_type = 'cloth'
					image_item.item_sub_type = 'Cloth'
					image_item.is_scraped = true
					image_item.manufacturer = 'Burberry'

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
