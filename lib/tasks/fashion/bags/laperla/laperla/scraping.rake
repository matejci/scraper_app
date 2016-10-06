require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/laperla.log")
logger.level = Logger::WARN

namespace :bags_lp_lp do

	desc "Scrap La Perla bags data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/bags/laperla/laperla/bags.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

				item = Item.new()
				item.source = "laperla"
				item.source_url = link
				item.name = doc.css('.product-main-info').css('h1').children().first().text
				item.description = doc.css('.description-box').children().css('div').children().text
				item.category = "fashion"
				item.item_type = "bags"
				item.item_sub_type = "Bags"
				item.is_scraped = true
				item.manufacturer = 'LaPerla'

				image_urls = []
				images = doc.css('.onload-moreviews')
				images.each do |img|
					image_urls << img.css("a").attr('href').value
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