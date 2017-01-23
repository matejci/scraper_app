require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/chanel.log")
logger.level = Logger::WARN

namespace :bags_chanel_chanel do

	desc "Scrap Chanel bags data"
	task scrap: :environment do
		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/bags/chanel/chanel/bags.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

				images_parsed = []
				images_parsed << "http://www.chanel.com" + doc.css('.product-image-foreground.no-select img').attr('data-src').value

				images = doc.css('.img-module')

				images.each do |i|
					images_parsed << "http://www.chanel.com" + i.attributes['data-src'].value
				end

				images_parsed.each do |img|
					image_item = ImageItem.new()
					image_item.source = 'chanel'
					image_item.source_url = link
					image_item.name = doc.css('.cat.info').children().first().text
					image_item.description = 'NA'
					image_item.category = 'fashion'
					image_item.item_type = 'bags'
					image_item.item_sub_type = 'Bags'
					image_item.is_scraped = true
					image_item.manufacturer = 'Chanel'

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
