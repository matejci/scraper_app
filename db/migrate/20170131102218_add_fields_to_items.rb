class AddFieldsToItems < ActiveRecord::Migration
  def change
    add_column :items, :image_url, :string
    add_column :items, :s3_image_url, :string
  end
end
