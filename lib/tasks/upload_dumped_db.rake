require 's3'
include DownloadHelper

logger = Logger.new("#{Rails.root}/log/dumpupload.log")
logger.level = Logger::WARN

service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])

namespace :upload do

	desc "Upload DB dump to S3"
	task dump_db: :environment do

		main_bucket = 'postgresdumpyewno'
		bucket = service.buckets.find(main_bucket)

		file = File.open("#{Rails.root}/scrap_db_with_schema_dump")

		new_object = bucket.objects.build("scrap_db_with_schema_dump")
		new_object.content = file
		new_object.acl = :public_read
		if new_object.save
			puts "Object uploaded"
		else
			puts "Error: #{new_object}"
		end

	end

end