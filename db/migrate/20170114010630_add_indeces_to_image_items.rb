class AddIndecesToImageItems < ActiveRecord::Migration
  def change
  	add_index :image_items, :tags, using: :gin
		add_index :image_items, :image_url
		add_index :image_items, :image_path
		add_index :image_items, :s3_image_url
		add_index :image_items, :keywords, using: :gin
		add_index :image_items, :sim_hashes, using: :gin
  end
end
