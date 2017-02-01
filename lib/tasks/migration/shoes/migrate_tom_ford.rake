namespace :shoes_migrate_tf do

	desc "Migrate Tom Ford shoes data"
	task start: :environment do

		items = Item.where("item_type = ? AND manufacturer = ?", "shoes", "TomFord")

		items.each do |item|

			s3_urls = JSON.parse(item.s3_image_urls['urls'])

			s3_urls.each do |url|

				image_item = ImageItem.new()
				image_item.source = item.source
				image_item.source_url = item.source_url
				image_item.name = item.name
				image_item.description = item.description
				image_item.category = item.category
				image_item.item_type = item.item_type
				image_item.item_sub_type = item.item_sub_type
				image_item.is_scraped = true
				image_item.is_downloaded = true
				image_item.manufacturer = item.manufacturer

				image_item.keywords = item.keywords
				image_item.sim_hashes = item.sim_hashes
				image_item.s3_image_url = url
				image_item.save
			end

		end

	end

end
