require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/dolcegabbana.log")
logger.level = Logger::WARN

namespace :cloth_dg_dg do

	desc "Scrap Dolce Gabbana cloth data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/cloth/dolcegabbana/dolcegabbana/cloth.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

					item = Item.new()
					item.source = "dolcegabbana"
					item.source_url = link
					item.name = doc.css('.b-product_name').children().first().text
					item.description = doc.css('.b-product_long_description').children().css('i').children().first().text
					item.category = "fashion"
					item.item_type = "cloth"
					item.item_sub_type = "Cloth"
					item.is_scraped = true
					item.manufacturer = 'DolceGabbana'

					image_urls = []
					images = doc.css('.js-img_product_thumbnail.b-product_thumbnail-image')
					images.each do |img|
						hashed = JSON.parse(img.attr('data-zoomimg'))
						image_urls << hashed['url']
					end

					item.image_urls = {:urls => image_urls.to_s}

					keywords = ScraperHelper.process_keywords(item.name)
					item.keywords = {:keywords => keywords.to_s}

					sim_hashes = ScraperHelper.process_simhashes(keywords)
					item.sim_hashes = {:sim_hashes => sim_hashes}

					item.save
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