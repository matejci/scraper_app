class AddIndecesToNewFields < ActiveRecord::Migration
  def change
		add_index :items, :image_url
		add_index :items, :s3_image_url
  end
end
