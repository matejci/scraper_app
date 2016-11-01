require 'open-uri'
require "#{Rails.root}/lib/helpers/download_helper.rb"
include DownloadHelper

logger = Logger.new("#{Rails.root}/log/dolcegabbana.log")
logger.level = Logger::WARN

namespace :bags_dg_dg do

	desc "Download DolceGabbana bags data on local disk"
	task download: :environment do

		main_path = "#{Rails.root}/downloaded_data/fashion/bags/dolcegabbana/"

		items = Item.where("source = ? AND is_downloaded = ? AND item_type = ? AND manufacturer = ?", "dolcegabbana", false, "bags", "DolceGabbana")

		items.each do |item|

			parsed_urls = ""
			if item.image_urls['urls'].include?('null')
				parsed_urls = item.image_urls['urls'].gsub('"null", ', '')
			end

			if parsed_urls != ""
				urls_arr = JSON.parse(parsed_urls)
			else
				urls_arr = JSON.parse(item.image_urls['urls'])
			end

			item_keywords = JSON.parse(item.keywords['keywords'])

			path = DownloadHelper.prepare_path_jaccard_method(item_keywords, main_path)
			folder_path = path
			image_paths = []

			if !File.directory?(folder_path) #if dir doesn't exists, create it!
				FileUtils.mkdir_p(folder_path)
			end

			urls_arr.each do |url|
				begin
					stream = open(url)
					# stream = `curl #{url}`
					file_name = url.split("/").last
					file_path = "#{folder_path}/#{file_name}"
					# File.binwrite file_path, stream
					IO.copy_stream(stream, file_path)
					image_paths << file_path
				rescue OpenURI::HTTPError => err
					logger.fatal("#{Time.now} :Error: #{err} -> ITEM_ID: #{item.id}, URL: #{url}")
					next
				rescue Errno::ENOENT => e
					logger.fatal("#{Time.now} :Error: #{e} -> ITEM_ID: #{item.id}, URL: #{url}")
					next
				end
			end

			item.update_attributes(:is_downloaded => true,  :image_paths => {:path => folder_path.to_s, :paths => image_paths.to_s })

		end

	end

end