require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/netaporter.log")
logger.level = Logger::WARN

namespace :bags_fendi_netaporter do

	desc "Scrap Fendi bags data"
	task scrap: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/bags/fendi/netaporter/bags.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|

			begin
				doc = Nokogiri::HTML(open(link))

				item = Item.new()
				item.source = "net-a-porter"
				item.source_url = link
				item.name = doc.css(".product-name").first().text
				description = doc.css("#accordion-2").children().css('p').children().first().text
				item.description = ScraperHelper.parse_description_string(description)
				item.category = "fashion"
				item.item_type = "bags"
				item.item_sub_type = doc.css("#main-product").children().css('meta').first().attributes['content'].value
				item.is_scraped = true
				item.manufacturer = 'Fendi'

				image_urls = []
				images = doc.css(".product-image")
				images.each do |img|
					if !img.attributes['src'].nil?
						image_urls << "http:" + img.attributes['src'].value
					end
				end

				image_urls.uniq!
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