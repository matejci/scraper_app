class ImageItem < ActiveRecord::Base

	scope :not_finished, -> { where(is_downloaded: false)}
	scope :bags_not_finished, -> {where(item_type: 'bags', is_downloaded: false)}
	scope :shoes_not_finished, -> {where(item_type: 'shoes', is_downloaded: false)}
	scope :cloth_not_finished, -> {where(item_type: 'cloth', is_downloaded: false)}

end

# == Schema Information
#
# Table name: image_items
#
#  id            :integer          not null, primary key
#  source        :string
#  source_url    :string
#  name          :string
#  description   :text
#  category      :string
#  item_type     :string
#  item_sub_type :string
#  manufacturer  :string
#  is_scraped    :boolean          default(FALSE)
#  is_downloaded :boolean          default(FALSE)
#  tags          :hstore
#  image_url     :string
#  image_path    :string
#  s3_image_url  :string
#  keywords      :hstore
#  sim_hashes    :hstore
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
