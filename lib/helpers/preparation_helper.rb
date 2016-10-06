module PreparationHelper

	def url_to_parse(url_arr, page_number)
		return "#{url_arr[0]}#{page_number}#{url_arr[1]}"
	end

end