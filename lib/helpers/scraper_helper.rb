module ScraperHelper

	def parse_description_string(str)
		parsed_desc = str.gsub("\t", "")
		parsed_desc = str.gsub("\n", "")
		parsed_desc.strip!
		return parsed_desc
	end

	def parse_sub_type_string(str)
		parsed_str = str.gsub("\r", "")
		parsed_str.gsub!("\n", "")
		parsed_str.strip!
		return parsed_str
	end

	def process_keywords(name)
		keywords_arr = name.split(" ")
		keywords_arr.map!(&:downcase)
		return keywords_arr
	end

	def process_simhashes(keywords)
		return keywords.map!{|kw| kw.simhash}
	end

	def process_yoox_keywords(name)
		name.gsub!(",", "")
		keywords_arr = name.split(" ")
		keywords_arr.map!(&:downcase)
		return keywords_arr
	end

end