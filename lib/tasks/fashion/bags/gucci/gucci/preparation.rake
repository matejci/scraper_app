logger = Logger.new("#{Rails.root}/log/gucci.log")
logger.level = Logger::WARN

namespace :bags_gucci_gucci do

	desc "Prepare Gucci bags data"
	task prepare: :environment do

		base_url = "https://www.gucci.com/us/en/"
		full_product_url_arr = []

		json_data = File.read("#{Rails.root}/lib/tasks/fashion/bags/gucci/gucci/gucci_bags_json_data.txt")
		data = JSON.parse(json_data)

		bags = data['products']['items']

		bags.each do |bag|
			full_product_url_arr << base_url + bag['productLink']
		end

		File.open("#{Rails.root}/lib/tasks/fashion/bags/gucci/gucci/bags.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end


	end

end

