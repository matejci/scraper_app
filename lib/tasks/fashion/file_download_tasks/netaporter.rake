
require 'open-uri'

logger = Logger.new("#{Rails.root}/log/netaporter.log")
logger.level = Logger::WARN

namespace :netaporter_download_task do

	desc "Download data"
	task download_images: :environment do

		main_path = "#{Rails.root}/downloaded_data/netaporter/"

		items = Item.where("source = ? AND is_downloaded = ?", "net-a-porter", false)

		items.each do |item|

			urls_arr = JSON.parse(item.image_urls['urls'])
			path_arr = []

			urls_arr.each do |url|

				arr = url.split("/")
				file_path = main_path + arr.last

				begin
					stream = open(url)
					IO.copy_stream(stream, file_path)
					path_arr << file_path
				rescue OpenURI::HTTPError => err
					logger.fatal("#{Time.now} :Error: #{err}")
					next
				end
			end

			item.update_attributes(:is_downloaded => true,  :image_paths => {:paths => path_arr.to_s})

		end

	end

end