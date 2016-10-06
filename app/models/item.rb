class Item < ActiveRecord::Base
	store_accessor :tags
	store_accessor :image_urls
	store_accessor :image_paths

	scope :not_finished, -> { where(is_downloaded: false)}
	scope :bags_not_finished, -> {where(item_type: 'bags', is_downloaded: false)}
	scope :shoes_not_finished, -> {where(item_type: 'shoes', is_downloaded: false)}
	scope :cloth_not_finished, -> {where(item_type: 'cloth', is_downloaded: false)}
end

# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  source       :string
#  source_url   :string
#  name         :string
#  description  :text
#  category     :string
#  type         :string
#  sub_type     :string
#  manufacturer :string
#  is_scraped   :boolean          default(FALSE)
#  tags         :hstore
#  image_urls   :hstore
#  image_paths  :hstore
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
