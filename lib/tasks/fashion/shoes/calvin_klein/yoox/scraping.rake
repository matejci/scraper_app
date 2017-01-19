require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/yoox.log")
logger.level = Logger::WARN

namespace :shoes_ck_yoox do

	desc "Scrap Calvin Klein shoes data"
	task scrap: :environment do
		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/shoes/calvin_klein/yoox/shoes.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

				images = doc.css('#itemThumbs').css('li')
				images_parsed = []

				if !images.present?
					images_parsed << doc.css('#openZoom').css('img').attr('src').value
				else
					images.each do |i|
						images_parsed << i.children().css("img").attr("src").value.gsub!("_9_", "_14_")
					end
				end

				images_parsed.each do |img|
					image_item = ImageItem.new()
					image_item.source = 'yoox'
					image_item.source_url = link
					image_item.name = doc.css("#ItemDescription").children().css("span").last().children().text
					image_item.description = "#{doc.css("#Composition").children().css("span").last().children().first().text} | #{image_item.name}"
					image_item.category = 'fashion'
					image_item.item_type = 'shoes'
					image_item.item_sub_type = ScraperHelper.parse_sub_type_string(doc.css("#itemTitle").children().css("span").children().last().text)
					image_item.is_scraped = true
					image_item.manufacturer = 'Calvin Klein'

					keywords = ScraperHelper.process_yoox_keywords(image_item.name)
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
