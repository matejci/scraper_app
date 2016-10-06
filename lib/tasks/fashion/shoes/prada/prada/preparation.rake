logger = Logger.new("#{Rails.root}/log/gucci.log")
logger.level = Logger::WARN

namespace :shoes_prada_prada do

	desc "Prepare Prada shoes data"
	task prepare: :environment do


		full_product_url_arr = []

		base_url = "http://www.prada.com/en/US/"


		json_data = File.read("#{Rails.root}/lib/tasks/fashion/shoes/prada/prada/prada_shoes_json_data.txt")
		data = JSON.parse(json_data)
		bags = {}

		data.each_with_index do |v,i|
			bags[i.to_s] = v
		end


		bags['0']['products'].each do |i|
			path = i['path']
			arr = path.split("/")
			suffix = "e-store/#{arr[7]}/#{arr[8]}/#{arr[9]}/product/#{arr.last}.html"
			full_product_url_arr << base_url + suffix
		end


		bags['1']['products'].each do |i|
			path = i['path']
			arr = path.split("/")
			suffix = "e-store/#{arr[7]}/#{arr[8]}/#{arr[9]}/product/#{arr.last}.html"
			full_product_url_arr << base_url + suffix
		end


		bags['2']['products'].each do |i|
			path = i['path']
			arr = path.split("/")
			suffix = "e-store/#{arr[7]}/#{arr[8]}/#{arr[9]}/product/#{arr.last}.html"
			full_product_url_arr << base_url + suffix
		end


		bags['3']['products'].each do |i|
			path = i['path']
			arr = path.split("/")
			suffix = "e-store/#{arr[7]}/#{arr[8]}/#{arr[9]}/product/#{arr.last}.html"
			full_product_url_arr << base_url + suffix
		end


		bags['4']['products'].each do |i|
			path = i['path']
			arr = path.split("/")
			suffix = "e-store/#{arr[7]}/#{arr[8]}/#{arr[9]}/product/#{arr.last}.html"
			full_product_url_arr << base_url + suffix
		end


		bags['5']['products'].each do |i|
			path = i['path']
			arr = path.split("/")
			suffix = "e-store/#{arr[7]}/#{arr[8]}/#{arr[9]}/product/#{arr.last}.html"
			full_product_url_arr << base_url + suffix
		end


		bags['6']['products'].each do |i|
			path = i['path']
			arr = path.split("/")
			suffix = "e-store/#{arr[7]}/#{arr[8]}/#{arr[9]}/product/#{arr.last}.html"
			full_product_url_arr << base_url + suffix
		end


		bags['7']['products'].each do |i|
			path = i['path']
			arr = path.split("/")
			suffix = "e-store/#{arr[7]}/#{arr[8]}/#{arr[9]}/product/#{arr.last}.html"
			full_product_url_arr << base_url + suffix
		end

		bags['8']['products'].each do |i|
			path = i['path']
			arr = path.split("/")
			suffix = "e-store/#{arr[7]}/#{arr[8]}/#{arr[9]}/product/#{arr.last}.html"
			full_product_url_arr << base_url + suffix
		end


		File.open("#{Rails.root}/lib/tasks/fashion/shoes/prada/prada/shoes.csv", "wb") do |file|
			full_product_url_arr.each do |item|
				file.puts item
			end
		end


	end

end