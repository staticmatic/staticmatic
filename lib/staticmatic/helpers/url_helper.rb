module StaticMatic
  module Helpers
    module UrlHelper
      self.extend self
      
      # Generate an HTML link
      #
      # If only the title is passed, it will automatically
      # create a link from this value:
      #
      # link('Test')  ->  <a href="test.html">Test</a>
      #
      def link(title, href = "", options = {})
        if href.is_a?(Hash)
          options = href
          href = ""
        end

        if href.nil? || href.strip.length < 1
          path_prefix = ''
          if title.match(/^(\.\.?)?\//)
            # starts with relative path so strip it off and prepend it to the urlified title
            path_prefix_match = title.match(/^[^\s]*\//)
            path_prefix = path_prefix_match[0] if path_prefix_match
            title = title[path_prefix.length, title.length]
          end
          href = path_prefix + urlify(title) + ".html"
        end

        options[:href] = "#{current_page_relative_path(href)}#{href}"
        
        local_page = (options[:href].match(/^(\#|.+?\:)/) == nil)
        unless @staticmatic.configuration.use_extensions_for_page_links || !local_page
          options[:href].chomp!(".html")
          options[:href].chomp!("index") if options[:href][-5, 5] == 'index'
        end

        tag(:a, options) { title }
      end
      alias link_to link

      # Generates a URL friendly string from the value passed:
      #
      # "We love Haml"  ->  "we_love_haml"
      # "Elf & Ham"     ->  "elf_and_ham"
      # "Stephen's gem" ->  "stephens_gem"
      #
      def urlify(string)
        string.tr(" ", "_").
               sub("&", "and").
               sub("@", "at").
               tr("^A-Za-z0-9_", "").
               sub(/_{2,}/, "_").
               downcase
      end
    end
  end

end
