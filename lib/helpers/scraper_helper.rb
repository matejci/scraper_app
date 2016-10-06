module ScraperHelper

	def parse_description_string(str)
		parsed_desc = str.gsub("\t", "")
		parsed_desc = str.gsub("\n", "")
		parsed_desc.strip!
		return parsed_desc
	end

end