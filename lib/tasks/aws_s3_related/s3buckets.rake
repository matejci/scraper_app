require 's3'

logger = Logger.new("#{Rails.root}/log/aws_s3.log")
logger.level = Logger::WARN

service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])

namespace :s3 do

	desc "Create buckets"
	task create_buckets: :environment do
		new_bucket = 'yewnofashion'
		bucket = service.buckets.find(new_bucket)

		begin
			if bucket.nil?
				bucket = service.buckets.build(new_bucket)
				bucket.save
				puts "Bucket #{bucket.name} successfully created."
			else
				puts "Bucket #{new_bucket} already exists."
			end
		rescue S3::Error => error
			logger.fatal("#{Time.current} - Error: #{error}")
		end
	end

end