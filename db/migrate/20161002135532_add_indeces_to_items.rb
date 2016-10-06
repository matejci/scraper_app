class AddIndecesToItems < ActiveRecord::Migration
	def change
		add_index :items, :tags, using: :gin
		add_index :items, :image_urls, using: :gin
		add_index :items, :image_paths, using: :gin
	end
end