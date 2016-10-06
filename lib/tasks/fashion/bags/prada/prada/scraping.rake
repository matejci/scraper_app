require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/prada.log")
logger.level = Logger::WARN

namespace :bags_prada_prada do

	desc "Scrap Prada bags data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/bags/prada/prada/bags.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|

			begin
				doc = Nokogiri::HTML(open(link))

				item = Item.new()
				item.source = "prada"
				item.source_url = link
				item.name = doc.css('.nameProduct').first().children().first().text

				desc = ""
				doc.css('#descriptionPrintTab').css('p').children().each do |c|
					if c.name != 'br'
						desc << c.text
						desc << ". "
					end
				end

				item.description = desc
				item.category = "fashion"
				item.item_type = "bags"
				item.item_sub_type = "Bags"
				item.is_scraped = true
				item.manufacturer = "Prada"

				image_urls = []
				images = doc.css(".other-view-image")
				images.each do |img|
					image_urls << "http://prada.com" + img.attr('src')
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