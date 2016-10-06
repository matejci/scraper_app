require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/gucci.log")
logger.level = Logger::WARN

namespace :shoes_gucci_gucci do

	desc "Scrap Gucci bags data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/shoes/gucci/gucci/shoes.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|

			begin
				doc = Nokogiri::HTML(open(link))

				item = Item.new()
				item.source = "gucci"
				item.source_url = link
				item.name = doc.css('.product-detail-purchase').children().css('h1').children().text

				description = doc.css('.product-detail,.columnize-by-2').children().css('p').children().text
				item.description = ScraperHelper.parse_description_string(description)

				item.category = "fashion"
				item.item_type = "shoes"
				item.item_sub_type = doc.css('.content-select,.basic-content-select,.breadcrumb-item').children().css('a').children().last().text
				item.is_scraped = true
				item.manufacturer = 'Gucci'

				image_urls = []
				images =  doc.css(".item product-detail-image-slide, .zoom-in, ._item-loaded, .active")
				images.each do |img|
					image_urls << "http:" + img.children().css('img').first().attributes['data-src_medium_retina'].value
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