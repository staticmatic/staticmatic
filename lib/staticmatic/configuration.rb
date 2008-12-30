module StaticMatic
  class Configuration
    attr_accessor :preview_server_port

    attr_accessor :preview_server_host
    
    attr_accessor :use_extensions_for_page_links
    attr_accessor :sass_options

    def initialize
      self.preview_server_port = 3000
      self.use_extensions_for_page_links = true
      self.sass_options = {}
    end
  end
end