require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
require 'uri'
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/dior.log")
logger.level = Logger::WARN

namespace :bags_dior_dior do

	desc "Scrap Dior bags data"
	task scrap: :environment do
		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/bags/dior/dior/bags.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(URI.parse(link)))

				images = doc.css('.cover-thumbnails.js-cover-thumbs li')
				images_parsed = []

				images.each do |i|
					images_parsed << "http://www.dior.com" + JSON.parse(i.css('img').attr('data-zoom').value)['src']
				end

				images_parsed.each do |img|
					image_item = ImageItem.new()
					image_item.source = 'dior'
					image_item.source_url = link
					image_item.name = doc.css('.quickbuy-title').children().first().text.gsub('"', "")
					image_item.description = doc.css('.column.one-half p').children().first().text.gsub("\n", "").gsub('"',"").strip
					image_item.category = 'fashion'
					image_item.item_type = 'bags'
					image_item.item_sub_type = 'Bags'
					image_item.is_scraped = true
					image_item.manufacturer = 'Dior'

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
