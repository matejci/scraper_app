require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/louis_vuitton.log")
logger.level = Logger::WARN

namespace :bags_lv_lv do

	desc "Scrap Louis Vuitton bags data"
	task scrap: :environment do
		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/bags/louis_vuitton/louis_vuitton/bags.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|

			begin
				doc = Nokogiri::HTML(open(link))

				image = doc.css('#productMainImage').attr('data-src').value.gsub!("{IMG_PRESET}", "PP_VP_M").gsub!("{IMG_WIDTH}", "639").gsub!("{IMG_HEIGHT}", "639")

				image_item = ImageItem.new()
				image_item.source = 'louis_vuitton'
				image_item.source_url = link
				image_item.name = doc.css('#productName').children().css('h1').children().first().text
				image_item.description = doc.css('.productDescription').children().first().text.gsub!("\r\n", "").strip!
				image_item.category = 'fashion'
				image_item.item_type = 'bags'
				image_item.item_sub_type = 'Bags'
				image_item.is_scraped = true
				image_item.manufacturer = 'Louis Vuitton'

				keywords = ScraperHelper.process_keywords(image_item.name)
				image_item.keywords = {:keywords => keywords.to_s}

				sim_hashes = ScraperHelper.process_simhashes(keywords)
				image_item.sim_hashes = {:sim_hashes => sim_hashes}

				image_item.image_url = URI.encode(image)
				image_item.save

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
