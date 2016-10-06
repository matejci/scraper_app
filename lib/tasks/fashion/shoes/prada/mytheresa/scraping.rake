require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/mytheresa.log")
logger.level = Logger::WARN

namespace :shoes_prada_mytheresa do

	desc "Scrap Prada shoes data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/shoes/prada/mytheresa/shoes.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|

			begin
				doc = Nokogiri::HTML(open(link))

				item = Item.new()
				item.source = "mytheresa"
				item.source_url = link
				item.name = doc.css('.product-img-box').children().css('h1').children().text
				item.description = doc.css('p.pal, p.product-description').children().first().text
				item.category = "fashion"
				item.item_type = "shoes"
				item.item_sub_type = "Shoes"
				item.is_scraped = true
				item.manufacturer = 'Prada'

				image_urls = []
				images =  doc.css(".gallery-image")
				images.each do |img|
					image_urls << "http:" + img.attributes['src'].value
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