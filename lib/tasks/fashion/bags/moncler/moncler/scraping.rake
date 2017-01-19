require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/moncler.log")
logger.level = Logger::WARN

namespace :bags_moncler_moncler do

	desc "Scrap Moncler bags data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/bags/moncler/moncler/bags.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

				images = doc.css('.alternativeImages li')

				images_parsed = []

				images.each do |i|
					images_parsed << i.children().css('img').attr('data-origin').value.gsub!("_8_", "_13_")
				end

				images_parsed.uniq!

				images_parsed.each do |img|
					image_item = ImageItem.new()
					image_item.source = 'moncler'
					image_item.source_url = link
					image_item.name = doc.css('.inner.modelName').children().first().text

					description = doc.css('.attributesUpdater.EditorialDescription')
					image_item.description = description.present? ? description.children().css('p').children().first().text : 'NA'
					image_item.category = 'fashion'
					image_item.item_type = 'bags'
					image_item.item_sub_type = 'Bags'
					image_item.is_scraped = true
					image_item.manufacturer = 'Moncler'

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
