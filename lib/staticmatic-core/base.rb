require 'fileutils'

module StaticMatic
  class Base
    
    include StaticMatic::RenderMixin
    
    # Directories generated for a new site setup
    @@base_dirs = %w{
      site/
      site/stylesheets
      site/images
      site/javascripts
      src/
      src/pages/
      src/layouts
      src/stylesheets
      src/partials
      src/helpers
    }
  
    # Templates for setup and their location
    @@templates = {
      'application.haml' => 'layouts',
      'application.sass' => 'stylesheets',
      'index.haml' => 'pages'
    }
    
    attr_accessor :configuration
    attr_reader :current_page, :src_dir, :site_dir

    def current_file
      @current_file_stack[0]
    end
    
    def initialize(base_dir, configuration = Configuration.new)
      @configuration = configuration
      @current_page = nil
      @current_file_stack = []
      @base_dir = base_dir
      @src_dir = "#{@base_dir}/src"
      @site_dir = "#{@base_dir}/site"
      @templates_dir = File.dirname(__FILE__) + '/templates'
      @layout = "application"
      @scope = Object.new
      @scope.instance_variable_set("@staticmatic", self)
      load_helpers
    end
    
    def base_dir
      @base_dir
    end
  
    def run(command)
      if %w(build setup preview).include?(command)
        send(command)
      else
        puts "#{command} is not a valid StaticMatic command"
      end
    end
    
    def build
      build_css
      build_html
    end
  
    def setup
      Dir.mkdir(@base_dir) unless File.exists?(@base_dir)
    
      @@base_dirs.each do |directory|
        directory = "#{@base_dir}/#{directory}"
        if !File.exists?(directory)
          Dir.mkdir(directory)
          puts "created #{directory}"
        end
      end
  
      @@templates.each do |template, destination|
        copy_file("#{@templates_dir}/#{template}", "#{@src_dir}/#{destination}")
      end
  
      puts "Done"
    end
    
    def preview
      puts "StaticMatic Preview Server Starting..."
      StaticMatic::Server.start(self)
    end
  
    def copy_file(from, to)
      FileUtils.cp(from, to)
    end
  
    def save_page(filename, content)
      generate_site_file(filename, 'html', content)
    end
  
    def save_stylesheet(filename, content)
      generate_site_file(File.join('stylesheets', filename), 'css', content)
    end
  
    def generate_site_file(filename, extension, content)
      path = File.join(@site_dir,"#{filename}.#{extension}")
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w+') do |f|
        f << content
      end
      
      puts "created #{path}"
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
      "#{@src_dir}/layouts/#{name}.haml"
    end
    
    # Build HTML from the source files
    def build_html
      Dir["#{@src_dir}/pages/**/*.haml"].each do |path|
        next if File.basename(path) =~ /^\_/  # skip partials
        file_dir, template = source_template_from_path(path.sub(/^#{@src_dir}\/pages/, ''))
        save_page(File.join(file_dir, template), generate_html_with_layout(template, file_dir))
      end
    end
  
    # Build CSS from the source files
    def build_css
      Dir["#{@src_dir}/stylesheets/**/*.sass"].each do |path|
        file_dir, template = source_template_from_path(path.sub(/^#{@src_dir}\/stylesheets/, ''))
        save_stylesheet(File.join(file_dir, template), generate_css(template, file_dir))
      end
    end
    
    # Returns a raw template name from a source file path:
    # source_template_from_path("/path/to/site/src/stylesheets/application.sass")  ->  "application"
    def source_template_from_path(path)
      file_dir, file_name = File.split(path)
      file_name.chomp!(File.extname(file_name))
      [ file_dir, file_name ]
    end
    
    # Loads any helpers present in the helpers dir and mixes them into the template helpers
    def load_helpers

      Dir["#{@src_dir}/helpers/**/*_helper.rb"].each do |helper|
        load_helper(helper)
      end
    end

    def load_helper(helper)
      load helper
      module_name = File.basename(helper, '.rb').gsub(/(^|\_)./) { |c| c.upcase }.gsub(/\_/, '')
      Haml::Helpers.class_eval("include #{module_name}")
    end
    
    class << self
      def base_dirs
        @@base_dirs
      end
    end
  end
end
