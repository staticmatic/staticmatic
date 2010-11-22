module StaticMatic
  class Configuration
    attr_accessor :preview_server_port

    attr_accessor :preview_server_host
    
    attr_accessor :use_extensions_for_page_links
    attr_accessor :sass_options
    attr_accessor :haml_options 
    
    def initialize
      self.preview_server_port = 3000
      self.preview_server_host = "localhost"
      self.use_extensions_for_page_links = true
      self.sass_options = {}
      self.haml_options = {}
    end
  end
end
