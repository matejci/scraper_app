require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/miumiu.log")
logger.level = Logger::WARN

namespace :cloth_miumiu_miumiu do

	desc "Scrap Miu Miu cloth data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/cloth/miumiu/miumiu/cloth.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

				images = doc.css('#views li')
				images_parsed = []

				images.each do |i|
					images_parsed << i.css('a').attr('data-zoom').value
				end

				name = doc.css('#product').attr('data-stylegroup').value.split("_")
				name = name.take(2).join(" ")

				images_parsed.each do |img|
					image_item = ImageItem.new()
					image_item.source = 'miumiu'
					image_item.source_url = link
					image_item.name = name
					image_item.description = doc.css('.desc').children().first().text
					image_item.category = 'fashion'
					image_item.item_type = 'cloth'
					image_item.item_sub_type = 'Cloth'
					image_item.is_scraped = true
					image_item.manufacturer = 'MiuMiu'

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
