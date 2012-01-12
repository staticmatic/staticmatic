module StaticMatic
  module Helpers
    module SiteMapHelper
			self.extend self

			# Method return the variable "site_map" for rendering the
			# sitemap.
			def sitemap
				@staticmatic.site_map
      end

			# Method used only to represent the inclusion of categories
			# and links in the site map.
			def add_to_site_map(category, title, link = "")
				return ""
			end
		end
	end
end
