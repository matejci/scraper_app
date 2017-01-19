class CreateImageItems < ActiveRecord::Migration
	def change
		create_table :image_items do |t|
			t.string :source
			t.string :source_url
			t.string :name
			t.text :description
			t.string :category
			t.string :item_type
			t.string :item_sub_type
			t.string :manufacturer
			t.boolean :is_scraped, :default => false
			t.boolean :is_downloaded, :default => false
			t.hstore :tags
			t.string :image_url
			t.string :image_path
			t.string :s3_image_url
			t.hstore :keywords
			t.hstore :sim_hashes

			t.timestamps null: false
		end
	end
end
