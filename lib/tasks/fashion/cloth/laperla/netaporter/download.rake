require 'open-uri'
require "#{Rails.root}/lib/helpers/download_helper.rb"
include DownloadHelper

logger = Logger.new("#{Rails.root}/log/netaporter.log")
logger.level = Logger::WARN

namespace :cloth_laperla_netaporter do

	desc "Download La Perla cloth data on local disk"
	task download: :environment do

		main_path = "#{Rails.root}/downloaded_data/fashion/cloth/laperla/"

		items = Item.where("source = ? AND is_downloaded = ? AND item_type = ? AND manufacturer = ?", "net-a-porter", false, "cloth", "LaPerla")

		items.each do |item|

			urls_arr = JSON.parse(item.image_urls['urls'])

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
					file_name = url.split("/").last
					file_path = "#{folder_path}/#{file_name}"
					IO.copy_stream(stream, file_path)
					image_paths << file_path
				rescue OpenURI::HTTPError => err
					logger.fatal("#{Time.now} :Error: #{err} item_id: #{item.id}, url: #{url} ")
					next
				rescue Errno::ENOENT => e
					logger.fatal("#{Time.now} :Error: #{e} item_id: #{item.id}, url: #{url} ")
					next
				rescue TypeError => te
					logger.fatal("#{Time.now} :Error: #{te} item_id: #{item.id}, url: #{url}")
					next
				end
			end

			item.update_attributes(:is_downloaded => true,  :image_paths => {:path => folder_path.to_s, :paths => image_paths.to_s })

		end

	end

end