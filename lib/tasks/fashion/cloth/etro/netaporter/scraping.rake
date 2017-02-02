require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/netaporter.log")
logger.level = Logger::WARN

namespace :cloth_etro_netaporter do

	desc "Scrap Etro cloth data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/cloth/etro/netaporter/cloth.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

				images = doc.css('.product-image')
				images_parsed = []

				images.each do |i|
					images_parsed << "http:" + i.attributes['src'].value
				end

				images_parsed.each do |img|
					image_item = ImageItem.new()
					image_item.source = 'net-a-porter'
					image_item.source_url = link
					image_item.name = doc.css(".product-name").first().text
					image_item.description = doc.css("#accordion-2").children().css('p').children().first().text.gsub('\t','').gsub('\n','').strip!
					image_item.category = 'fashion'
					image_item.item_type = 'cloth'
					image_item.item_sub_type = doc.css("#main-product").children().css('meta').first().attributes['content'].value
					image_item.is_scraped = true
					image_item.manufacturer = 'Etro'

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
