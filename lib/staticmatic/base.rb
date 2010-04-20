module StaticMatic  
  class Base
    
    include StaticMatic::RenderMixin
    include StaticMatic::BuildMixin
    include StaticMatic::SetupMixin
    include StaticMatic::HelpersMixin    
    include StaticMatic::ServerMixin    
    include StaticMatic::RescueMixin    
  
    attr_accessor :configuration
    attr_reader :current_page, :src_dir, :site_dir

    def current_file
      @current_file_stack[0] || ""
    end
    
    def initialize(base_dir, configuration = Configuration.new)
      @configuration = configuration
      @current_page = nil
      @current_file_stack = []
      @base_dir = base_dir
      @src_dir = File.join(@base_dir, "src")
      @site_dir = File.join(@base_dir, "site")
      
      if File.exists?(File.join(@src_dir, "layouts", "application.haml"))
        puts "DEPRECATION: layouts/application.haml will be renamed to layouts/default.haml in the 0.12.0"
        @layout = "application"
      else
        @layout = "default"
      end
      
      @scope = Object.new
      @scope.instance_variable_set("@staticmatic", self)
      
      configure_compass
      load_helpers
    end
    
    def base_dir
      @base_dir
    end
  
    def run(command)
      puts "Site root is: #{@base_dir}"
      
      if %w(build setup preview).include?(command)
        send(command)
      else
        puts "#{command} is not a valid StaticMatic command"
      end
    end
      
    # TODO: DRY this _exists? section up
    def template_exists?(name, dir = '')
      File.exists?(File.join(@src_dir, 'pages', dir, "#{name}.haml")) || File.exists?(File.join(@src_dir, 'stylesheets', "#{name}.sass"))
    end
    
    def layout_exists?(name)
      File.exists? full_layout_path(name)
    end
    
    def template_directory?(path)
      File.directory?(File.join(@src_dir, 'pages', path))
    end
    
    def full_layout_path(name)
      File.join(@src_dir, "layouts", "#{name}.haml")
    end
    
    def configure_compass
      Compass.configuration do |config|
        config.output_style = :expanded
        config.project_path = @base_dir 
        config.sass_dir = File.join(@base_dir, "src", "stylesheets")
        config.css_dir = File.join(@base_dir, "site", "stylesheets")
        config.images_dir = File.join(@base_dir, "site", "images")
        config.http_path = "/"
        config.http_images_path = "/images"
      end
      
      configuration.sass_options.merge!(Compass.sass_engine_options)
    end
  end
end
