module PreparationHelper

	def mytheresa_parse_url(url, page_number)
		return "#{url}#{page_number}"
	end

	def netaporter_parse_url(url_arr, page_number)
		return "#{url_arr[0]}#{page_number}#{url_arr[1]}"
	end

end