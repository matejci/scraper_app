logger = Logger.new("#{Rails.root}/log/gucci.log")
logger.level = Logger::WARN

namespace :shoes_gucci_gucci do

	desc "Prepare Gucci shoes data"
	task prepare: :environment do

		base_url = "https://www.gucci.com/us/en/"
		full_product_url_arr = []

		json_data = File.read("#{Rails.root}/lib/tasks/fashion/shoes/gucci/gucci/gucci_shoes_json_data.txt")
		data = JSON.parse(json_data)

		shoes = data['products']['items']

		shoes.each do |shoe|
			full_product_url_arr << base_url + shoe['productLink']
		end

		File.open("#{Rails.root}/lib/tasks/fashion/shoes/gucci/gucci/shoes.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end


	end

end

