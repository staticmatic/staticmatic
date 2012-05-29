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
						add_to_site_map(category, title, link)
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

  # Method to sort the categories sitemap.
  def set_site_map_order(list)
    @site_map_categories = list + @site_map.keys
    @site_map_categories.uniq!

    @site_map_categories.each do |category|
      if !@site_map.keys.include?(category)
        puts "ERROR: Category doesn't include in this site!"
      end
    end

    @site_map.each_value { |v| v.sort! { |a, b| a.keys <=> b.keys } }
  end

  # Method that returns the categories sitemap
  def get_site_map_categories
    return @site_map_categories
  end

  # Method that returns the items sitemap
  def get_site_map_items(category)
    return @site_map[category]
  end
end
