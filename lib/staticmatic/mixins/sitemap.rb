module StaticMatic::SitemapMixin

	@@check_parameters = /^\s*-\s*add_to_site_map\(\"([^,]*)\",\s*\"([^,]*)\"(,\s*\"([^,]*)\")?\)/

	# Method for generate the sitemap.
	#
	# Through all the directories containing the pages .haml
	# looking for instances such as:
	#
	# - add_to_site_map("parameter 1", "parameter 2") 	or
	#
	# - add_to_site_map("parameter 1", "parameter 2", "parameter 3")
	#
	def generate_site_map
		Dir["#{@src_dir}/pages/**/*.haml"].each do |path|
			file = File.open(path, "r")
			begin
				while (line = file.readline)
					if line =~ @@check_parameters
						category = $1
						title = $2
						if $3 != nil
							link = $3.gsub(/[\s,\"]/, '')
						else
							link = path.gsub("#{@src_dir}/pages" , "").gsub("/index.haml", "").gsub(".haml", "")
						end
						add_to_sitemap(category, title, link)
					end
				end
			rescue EOFError
		    file.close
			end
		end
	end

	# Method to add elements in the site map
	def add_to_site_map(category, title, link)
		@site_map[category] ||= []
		@site_map[category] << { title => link }
	end
end
