module StaticMatic
  module Helpers
    module SiteMapHelper
			self.extend self


      # Receives an ordered list of categories and calls the
      # methods to sort these categories and items.
      def site_map_order(list)
        @staticmatic.set_site_map_order(list)
      end

      #Returns the list of categories for render the sitemap
      def site_map_order_categories
        return @staticmatic.get_site_map_categories
      end

      #Returns the list of items for render the sitemap
      def site_map_order_items(category)
        return @staticmatic.get_site_map_items(category)
      end

      # Method used only to represent the inclusion of categories
      # and links in the site map.
      def add_to_site_map(category, title, link = "")
        return ""
      end
    end
  end
end
