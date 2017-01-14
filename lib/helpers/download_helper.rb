module DownloadHelper

	def prepare_path(item_keywords, directory_to_list)
		directory = Pathname.new(directory_to_list)
		paths_arr = directory.children
		result_path = ""

		paths_arr.each do |path|

			folder_name = path.to_s.split("/")
			folder_keywords = folder_name.last.split("_")

			not_common_keywords = Set.new(folder_keywords) ^ item_keywords
			common_keywords = item_keywords & folder_keywords

			if not_common_keywords.length < common_keywords.length
				result_path = path.to_s
				break
			end

		end

		if result_path != ""
			return result_path
		else
			result_path = directory_to_list + item_keywords.join("_")
			return result_path
		end
	end


	def prepare_path_jaccard_method(item_keywords, directory_to_list)
		directory = Pathname.new(directory_to_list)
		paths_arr = directory.children
		result_path = ""

		paths_arr.each do |path|

			folder_name = path.to_s.split("/")
			folder_keywords = folder_name.last.split("_")

			coef = Jaccard.coefficient(folder_keywords, item_keywords)

			if coef >= ENV['JACCARD_TRESHOLD'].to_f
				result_path = path.to_s
				break
			end

		end

		if result_path != ""
			return result_path
		else
			result_path = directory_to_list + item_keywords.join("_")
			return result_path
		end
	end


	def prepare_s3object_jaccard_method(item_keywords, s3_objects)
		result = ''

		s3_objects.each do |obj|

			folder_keywords = prepare_s3_folder_keywords(obj.key.split("/"))

			if folder_keywords != nil
				coef = Jaccard.coefficient(folder_keywords, item_keywords)

				if coef >= ENV['JACCARD_TRESHOLD'].to_f
					result = obj.key.split("/")[0] + "/"
					break
				end
			end
		end

		if result != ''
			return result
		else
			result = item_keywords.join("_")
			return result + "/"
		end
	end

	def prepare_middlefolder_jaccard_method(item_keywords, middle_folders)
		result = ''

		middle_folders.each do |mf|

			folder_keywords = mf.split("_")

			if folder_keywords != nil
				coef = Jaccard.coefficient(folder_keywords, item_keywords)

				if coef >= ENV['JACCARD_TRESHOLD'].to_f
					result = "#{mf}/"
					break
				end
			end
		end

		if result != ''
			return result
		else
			result = item_keywords.join("_")
			return result + "/"
		end
	end

	def prepare_s3_folder_keywords(arr)
		if arr.length > 1
			keywords = arr[0].split("_")
			return keywords
		else
			nil
		end
	end


	def prepare_s3_objects(objects, main_folder)
		result = []

		objects.each do |o|
			if o.key.include?(main_folder)
				o.key.gsub!("#{main_folder}", "")
				arr = o.key.split("/")
				result << arr[0]
			end
		end

		result.length > 0 ? result : nil
	end
end
