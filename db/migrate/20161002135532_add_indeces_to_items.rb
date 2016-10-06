class AddIndecesToItems < ActiveRecord::Migration
	def change
		add_index :items, :tags, using: :gin
		add_index :items, :image_urls, using: :gin
		add_index :items, :image_paths, using: :gin
		add_index :items, :s3_image_urls, using: :gin
		add_index :items, :keywords, using: :gin
		add_index :items, :sim_hashes, using: :gin
	end
end