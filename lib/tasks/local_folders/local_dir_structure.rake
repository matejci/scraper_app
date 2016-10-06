
logger = Logger.new("#{Rails.root}/log/local_folder_creation.log")
logger.level = Logger::WARN

namespace :local do

	desc "Creates local directory structure"
	task create_folders: :environment do

		folders = %w(
							/downloaded_data/fashion/bags/dolcegabbana/
							/downloaded_data/fashion/bags/fendi/
							/downloaded_data/fashion/bags/gucci/
							/downloaded_data/fashion/bags/jimmy_choo/
							/downloaded_data/fashion/bags/laperla/
							/downloaded_data/fashion/bags/prada/
							/downloaded_data/fashion/bags/tomford/
							/downloaded_data/fashion/cloth/dolcegabbana/
							/downloaded_data/fashion/cloth/fendi/
							/downloaded_data/fashion/cloth/gucci/
							/downloaded_data/fashion/cloth/laperla/
							/downloaded_data/fashion/cloth/prada/
							/downloaded_data/fashion/cloth/tomford/
							/downloaded_data/fashion/shoes/dolcegabbana/
							/downloaded_data/fashion/shoes/fendi/
							/downloaded_data/fashion/shoes/gucci/
							/downloaded_data/fashion/shoes/jimmy_choo/
							/downloaded_data/fashion/shoes/laperla/
							/downloaded_data/fashion/shoes/prada/
							/downloaded_data/fashion/shoes/tomford/
		)


		folders.each do |folder|
			if !File.directory?(folder)
				FileUtils.mkdir_p("#{Rails.root}#{folder}")
				puts "Folder #{folder} created."
			end
		end

	end

end