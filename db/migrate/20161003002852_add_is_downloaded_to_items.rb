class AddIsDownloadedToItems < ActiveRecord::Migration
  def change
    add_column :items, :is_downloaded, :boolean, :default => false
  end
end
