logger = Logger.new("#{Rails.root}/log/dolcegabbana.log")
logger.level = Logger::WARN

namespace :bags_dg_dg do

	desc "Prepare DolceGabbana bags data"
	task prepare: :environment do

		base_url = "http://store.dolcegabbana.com"
		full_product_url_arr = []

		json_data = File.read("#{Rails.root}/lib/tasks/fashion/bags/dolcegabbana/dolcegabbana/dg_bags_json_data.txt")
		bags_data = JSON.parse(json_data)

		bags_data['items'].each do |item|
			full_product_url_arr << base_url + item
		end

		File.open("#{Rails.root}/lib/tasks/fashion/bags/dolcegabbana/dolcegabbana/bags.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end


	end

end