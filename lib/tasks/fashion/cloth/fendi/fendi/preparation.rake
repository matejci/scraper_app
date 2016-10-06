logger = Logger.new("#{Rails.root}/log/fendi.log")
logger.level = Logger::WARN

namespace :cloth_fendi_fendi do

	desc "Prepare Fendi cloth data"
	task prepare: :environment do

		base_url = "https://www.fendi.com/us"
		full_product_url_arr = []

		json_data = File.read("#{Rails.root}/lib/tasks/fashion/cloth/fendi/fendi/fendi_cloth_json_data.txt")
		bags_data = JSON.parse(json_data)

		bags_data['items'].each do |item|
			full_product_url_arr << base_url + item
		end

		File.open("#{Rails.root}/lib/tasks/fashion/cloth/fendi/fendi/cloth.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end


	end

end