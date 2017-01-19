require 's3'
require 'open-uri'
require "#{Rails.root}/lib/helpers/download_helper.rb"
include DownloadHelper

logger = Logger.new("#{Rails.root}/log/yoox.log")
logger.level = Logger::WARN

service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])

namespace :bags_moschino_yoox do

	desc "Download Moschino bags data to AWS S3"
	task s3_download: :environment do

		main_bucket = ENV['AWS_TEST_BUCKET']
		main_folder = 'bags/moschino/'
		bucket = service.buckets.find(main_bucket)

		if !bucket
			puts "Bucket #{main_bucket} doesn't exists. Please run appropriate rake task to create the bucket, or create it manually."
			return
		end

		items = ImageItem.where("source = ? AND is_downloaded = ? AND item_type = ? AND manufacturer = ?", "yoox", false, "bags", "Moschino")

		temp_bucket_objects = bucket.objects

		items.each do |item|

			item_keywords = JSON.parse(item.keywords['keywords'])

			middle_folders = prepare_s3_objects(temp_bucket_objects, main_folder)
			middle_folder = nil

			if middle_folders.nil?
				middle_folder = item_keywords.join("_")
				middle_folder << "/"
			else
				middle_folders.compact!
				middle_folders.uniq!
				middle_folder = DownloadHelper.prepare_middlefolder_jaccard_method(item_keywords, middle_folders)
			end

			object_keys = temp_bucket_objects.map(&:key)
			folder_exist = object_keys.include?(middle_folder)

			s3_image_url = ''

			begin
				file_name = item.image_url.split("/").last

				if folder_exist
					new_object = temp_bucket_objects.build(main_folder + middle_folder + file_name)
					new_object.content = open(item.image_url)
					new_object.acl = :public_read
					new_object.save

					temp_bucket_objects << new_object
					s3_image_url = new_object.url
				else
					new_folder = temp_bucket_objects.build(main_folder + middle_folder)
					new_folder.content = ""
					new_folder.acl = :public_read
					new_folder.save

					temp_bucket_objects << new_folder

					new_object = temp_bucket_objects.build(main_folder + middle_folder + file_name)
					new_object.content = open(item.image_url)
					new_object.acl = :public_read
					new_object.save

					temp_bucket_objects << new_object
					s3_image_url = new_object.url
				end
			rescue OpenURI::HTTPError => err
				logger.fatal("#{Time.now} :Error: #{err} -> Image_ITEM_ID: #{item.id}, URL: #{item.image_url}")
				next
			rescue Errno::ENOENT => e
				logger.fatal("#{Time.now} :Error: #{e} -> Image_ITEM_ID: #{item.id}, URL: #{item.image_url}")
				next
			rescue TypeError => te
				logger.fatal("#{Time.now} :Error: #{te} -> Image_ITEM_ID: #{item.id}, url: #{item.image_url}")
				next
			end

			item.update_attributes(:is_downloaded => true,  :s3_image_url => s3_image_url)
		end

	end

end
