require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/yoox.log")
logger.level = Logger::WARN

namespace :cloth_gucci_yoox do

	desc "Scrap Gucci cloth data"
	task scrap: :environment do
		file_content_array = []

		File.foreach("#{Rails.root}/lib/tasks/fashion/cloth/gucci/yoox/cloth.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|

			begin
				doc = Nokogiri::HTML(open(link))

				item = Item.new()
				item.source = "yoox"
				item.source_url = link
				item.name = doc.css("#ItemDescription").children().css("span").last().children().text
				item.description = "#{doc.css("#Composition").children().css("span").last().children().first().text} | #{item.name}"
				item.category = "fashion"
				item.item_type = "cloth"
				item.item_sub_type = ScraperHelper.parse_sub_type_string(doc.css("#itemTitle").children().css("span").children().last().text)
				item.is_scraped = true
				item.manufacturer = 'Gucci'

				image_urls = []
				images = doc.css("#itemThumbs").css("li")

				if images.present?
					images.each do |img|
						image_urls << img.children().css("img").attr("src").value.gsub!("_9_", "_14_")
					end
				else
					image_urls << doc.css("#openZoom").children().css("img").attr("src").value
				end

				image_urls.uniq!
				item.image_urls = {:urls => image_urls.to_s}

				keywords = ScraperHelper.process_yoox_keywords(item.name)
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