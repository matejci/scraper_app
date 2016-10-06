require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/lib/helpers/scraper_helper.rb"
include ScraperHelper

logger = Logger.new("#{Rails.root}/log/fendi.log")
logger.level = Logger::WARN

namespace :cloth_fendi_fendi do

	desc "Scrap Fendi cloth data"
	task scrap: :environment do

		file_content_array = []
		base_url = "https://www.fendi.com"

		File.foreach("#{Rails.root}/lib/tasks/fashion/cloth/fendi/fendi/cloth.csv") do |line|
			file_content_array << line.chomp
		end

		file_content_array.each do |link|
			begin
				doc = Nokogiri::HTML(open(link))

					item = Item.new()
					item.source = "fendi"
					item.source_url = link
					item.name = doc.css(".fd-pp-info-wrp").css("h1").children().first().text
					item.description = doc.css(".fd-pp-intro.infoPnlHiddenIfOtherSelected").children().first().text
					item.category = "fashion"
					item.item_type = "cloth"
					item.item_sub_type = "Cloth"
					item.is_scraped = true
					item.manufacturer = 'Fendi'

					image_urls = []
					images = doc.css('.fd-pp-thumbnails').children().css('li')
					images.first(5).each do |img|
						image_urls << base_url + img.css('a').attr('href').value
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