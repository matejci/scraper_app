require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/armani.log")
logger.level = Logger::WARN

namespace :bags_armani_armani do

	desc "Scrap Armani bags data"
	task scrap: :environment do
		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/bags/armani/armani/bags.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

				images = doc.css('.thumbElement')
				images_parsed = []

				images.each do |i|
					images_parsed << i.css('img').attr('src').value
				end

				description = doc.css('.descriptionList li')
				desc_parsed = ""

				description.each do |i|
					desc_parsed << i.children().text.gsub(/[\t\r\n]/, '')
					desc_parsed << ". "
				end

				images_parsed.each do |img|
					image_item = ImageItem.new()
					image_item.source = 'armani'
					image_item.source_url = link
					image_item.name = doc.css('.productName').children().first().text
					image_item.description = desc_parsed
					image_item.category = 'fashion'
					image_item.item_type = 'bags'
					image_item.item_sub_type = 'Bags'
					image_item.is_scraped = true
					image_item.manufacturer = 'Armani'

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
