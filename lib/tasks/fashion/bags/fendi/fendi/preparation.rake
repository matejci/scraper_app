logger = Logger.new("#{Rails.root}/log/fendi.log")
logger.level = Logger::WARN

namespace :bags_fendi_fendi do

	desc "Prepare Fendi bags data"
	task prepare: :environment do

		base_url = "https://www.fendi.com/us"
		full_product_url_arr = []

		json_data = File.read("#{Rails.root}/lib/tasks/fashion/bags/fendi/fendi/fendi_bags_json_data.txt")
		bags_data = JSON.parse(json_data)

		bags_data['items'].each do |item|
			full_product_url_arr << base_url + item
		end

		File.open("#{Rails.root}/lib/tasks/fashion/bags/fendi/fendi/bags.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end


	end

end