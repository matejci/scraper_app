require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/netaporter.log")
logger.level = Logger::WARN

namespace :netaporter_scrap_task do

	desc "Scrap all clothing data"
	task all_clothing: :environment do

		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/data/netaporter/preparation_all_clothing.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|

			begin
				doc = Nokogiri::HTML(open(link))

				item = Item.new()
				item.source = "net-a-porter"
				item.source_url = link
				item.name = doc.css(".product-name").text

				description = doc.css("#accordion-2").children().css('p').children().first().text

				item.description = ScraperHelper.parse_description_string(description)
				item.category = "fashion"
				item.item_type = "clothing"
				item.item_sub_type = doc.css("#main-product").children().css('meta').first().attributes['content'].value
				item.is_scraped = true
				item.manufacturer = doc.css(".designer-name").children().css('span').first().children().first().text

				image_urls = []
				images = doc.css(".product-image")
				images.each do |img|
					if !img.attributes['src'].nil?
						image_urls << "http:" + img.attributes['src'].value
					end
				end

				image_urls.uniq!
				item.image_urls = {:urls => image_urls.to_s}
				item.save

			rescue Errno::ENOENT => e
				logger.fatal("#{Time.now} :Error: #{e}")
				next
			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err}")
				next
			end

		end

	end

	desc "Scrap netaporter data with file param"
	task :netaporter, [:file] => :environment do |t, args|		#call rake task via console with: rake netaporter_scrap_task:netaporter["preparation_all_accessories.csv"]
		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/data/netaporter/#{args[:file]}") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

				item = Item.new()
				item.source = "net-a-porter"
				item.source_url = link
				item.name = doc.css(".product-name").text

				description = doc.css("#accordion-2").children().css('p').children().first().text

				item.description = ScraperHelper.parse_description_string(description)
				item.category = "fashion"
				item.item_type = "clothing"
				item.item_sub_type = doc.css("#main-product").children().css('meta').first().attributes['content'].value
				item.is_scraped = true
				item.manufacturer = doc.css(".designer-name").children().css('span').first().children().first().text

				image_urls = []
				images = doc.css(".product-image")
				images.each do |img|
					if !img.attributes['src'].nil?
						image_urls << "http:" + img.attributes['src'].value
					end
				end

				image_urls.uniq!
				item.image_urls = {:urls => image_urls.to_s}
				item.save

			rescue Errno::ENOENT => e
				logger.fatal("#{Time.now} :Error: #{e}")
				next
			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err}")
				next
			end
		end
	end

end