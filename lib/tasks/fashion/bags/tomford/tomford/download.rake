require 's3'
require 'open-uri'
require "#{Rails.root}/lib/helpers/download_helper.rb"
include DownloadHelper

logger = Logger.new("#{Rails.root}/log/tomford.log")
logger.level = Logger::WARN

service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])

namespace :bags_tomford_tomford_old do

	desc "Download Tom Ford bags data on local disk"
	task download: :environment do

		main_path = "#{Rails.root}/downloaded_data/fashion/bags/tomford/"

		items = Item.where("source = ? AND is_downloaded = ? AND item_type = ? AND manufacturer = ?", "tomford", false, "bags", "TomFord")

		items.each do |item|

			parsed_images = item.image_urls['urls'].gsub(", nil",'')
			urls_arr = JSON.parse(parsed_images)

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
					file_path = "#{folder_path}/#{file_name}.jpg"
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

	desc "Download Tom Ford bags data to AWS S3"
	task s3__download: :environment do

		main_bucket = 'fashion-bags-tomford'
		bucket = service.buckets.find(main_bucket)

		if !bucket
			puts "Bucket #{main_bucket} doesn't exists. Please run appropriate rake task to create the bucket, or create it manually."
			return
		end

		items = Item.where("source = ? AND is_downloaded = ? AND item_type = ? AND manufacturer = ?", "tomford", false, "bags", "TomFord")

		items.each do |item|

			s3_image_urls = []

			# urls_arr = JSON.parse(item.image_urls['urls'])
			parsed_images = item.image_urls['urls'].gsub(", nil",'')
			urls_arr = JSON.parse(parsed_images)

		 	item_keywords = JSON.parse(item.keywords['keywords'])

		  	s3_folder = DownloadHelper.prepare_s3object_jaccard_method(item_keywords, bucket.objects)

		  	object_keys = bucket.objects.map(&:key)
		  	folder_exist = object_keys.include?(s3_folder)

			urls_arr.each do |url|
				begin
					stream = open(url)
					file_name = url.split("/").last
					file_content = (File.read(stream))

					if folder_exist
						new_object = bucket.objects.build(s3_folder + file_name + ".jpg")
						new_object.content = file_content
						new_object.acl = :public_read
						new_object.save

						s3_image_urls << new_object.url
					else
						new_folder = bucket.objects.build(s3_folder)
						new_folder.content = ""
						new_folder.acl = :public_read
						new_folder.save

						new_object = bucket.objects.build(s3_folder + file_name + ".jpg")
						new_object.content = file_content
						new_object.acl = :public_read
						new_object.save

						s3_image_urls << new_object.url
					end
				rescue OpenURI::HTTPError => err
					logger.fatal("#{Time.now} :Error: #{err} -> ITEM_ID: #{item.id}, URL: #{url}")
					next
				rescue Errno::ENOENT => e
					logger.fatal("#{Time.now} :Error: #{e} -> ITEM_ID: #{item.id}, URL: #{url}")
					next
				end
			end

			item.update_attributes(:is_downloaded => true,  :s3_image_urls => {:urls => s3_image_urls.to_s })

		end
	end

   desc "Download Tom Ford bags data to AWS S3"
	task s3_download: :environment do

		main_bucket = 'yewnofashion'
		main_folder = 'bags/tomford/'
		bucket = service.buckets.find(main_bucket)

		if !bucket
			puts "Bucket #{main_bucket} doesn't exists. Please run appropriate rake task to create the bucket, or create it manually."
			return
		end

		items = Item.where("source = ? AND is_downloaded = ? AND item_type = ? AND manufacturer = ?", "tomford", false, "bags", "TomFord")

		items.each do |item|

			s3_image_urls = []

			parsed_images = item.image_urls['urls'].gsub(", nil",'')
			urls_arr = JSON.parse(parsed_images)

			item_keywords = JSON.parse(item.keywords['keywords'])

			#parse bucket objects to extract "middle folder" which we need to "compare" using the jaccard coefficient to find if similar folder already exists
			middle_folders = prepare_s3_objects(bucket.objects, main_folder)

			middle_folder = nil

			#if there is no any "middle folder" present, create it from item keywords
			if middle_folders.nil?
				middle_folder = item_keywords.join("_")
				middle_folder << "/"
			else
		 		middle_folder = DownloadHelper.prepare_middlefolder_jaccard_method(item_keywords, middle_folders)
		 	end

		   object_keys = bucket.objects.map(&:key)
		   folder_exist = object_keys.include?(middle_folder)

			urls_arr.each do |url|
				begin
					stream = open(url)
					file_name = url.split("/").last
					file_content = (File.read(stream))

					if folder_exist
						new_object = bucket.objects.build(main_folder + middle_folder + file_name + ".jpg")
						new_object.content = file_content
						new_object.acl = :public_read
						new_object.save

						s3_image_urls << new_object.url
					else
						new_folder = bucket.objects.build(main_folder + middle_folder)
						new_folder.content = ""
						new_folder.acl = :public_read
						new_folder.save

						new_object = bucket.objects.build(main_folder + middle_folder + file_name + ".jpg")
						new_object.content = file_content
						new_object.acl = :public_read
						new_object.save

						s3_image_urls << new_object.url

					end
				rescue OpenURI::HTTPError => err
					logger.fatal("#{Time.now} :Error: #{err} -> ITEM_ID: #{item.id}, URL: #{url}")
					next
				rescue Errno::ENOENT => e
					logger.fatal("#{Time.now} :Error: #{e} -> ITEM_ID: #{item.id}, URL: #{url}")
					next
				end
			end

			item.update_attributes(:is_downloaded => true,  :s3_image_urls => {:urls => s3_image_urls.to_s })

		end
	end

end