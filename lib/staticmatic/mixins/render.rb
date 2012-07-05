module StaticMatic::RenderMixin
  
  # clear all scope variables except @staticmatic
  def clear_template_variables!
    
    @scope.instance_variables.each do |var|
      @scope.instance_variable_set(var, nil) unless var == '@staticmatic' || var == :@staticmatic
    end
  end
  
  def source_for_layout
    if layout_exists?(determine_layout)
      File.read(full_layout_path(determine_layout))
    else
      raise StaticMatic::Error.new("", full_layout_path(determine_layout), "Layout not found")
    end
  end

  # Generate html from source file:
  # generate_html("index")
  def generate_html(source_file, source_dir = '')
    full_file_path = File.join(@src_dir, 'pages', source_dir, "#{source_file}.haml")

    begin

      html = generate_html_from_template_source(File.read(full_file_path))
    rescue StaticMatic::TemplateError => e
      raise e # re-raise inline errors
    rescue Exception => e
      raise StaticMatic::TemplateError.new(full_file_path, e)
    end

    html
  end

  def generate_html_with_layout(source, source_dir = '')
    @current_page = File.join(source_dir, "#{source}.html")
    @current_file_stack.unshift(File.join(source_dir, "#{source}.haml"))
    begin 
      template_content = generate_html(source, source_dir)
      generate_html_from_template_source(source_for_layout) { template_content }
    rescue Exception => e
      render_rescue_from_error(e)
    ensure
      clear_template_variables!
      @current_page = nil
      @current_file_stack.shift
    end
  end

  def generate_partial(name, options = {})
    partial_dir, partial_name = File.dirname(self.current_file), name  # default relative to current file
    partial_dir, partial_name = File.split(name) if name.index('/') # contains a path so it's absolute from src/pages dir
    partial_type = partial_name[/(\.haml|\.html)$/]
    
    partial_name = "_#{partial_name}"
    partial_name += ".haml" unless partial_type

    partial_path = File.join(@src_dir, 'pages', partial_dir, partial_name)
    unless File.exists?(partial_path)
      # couldn't find it in the pages subdirectory tree so try old way (ignoring the path)
      partial_dir = 'partials'
      partial_name = "#{File.basename(name)}"
      partial_name += ".haml" unless partial_type
      partial_path = File.join(@src_dir, partial_dir, partial_name)
    end
  
    if File.exists?(partial_path)
      partial_rel_path = "/#{partial_dir}/#{partial_name}".gsub(/\/+/, '/')
      @current_file_stack.unshift(partial_rel_path)
      begin
        if partial_type == '.html'
          File.read(partial_path)
        else
          generate_html_from_template_source(File.read(partial_path), options)
        end
      rescue Exception => e
        raise StaticMatic::TemplateError.new(partial_path, e)
      ensure
        @current_file_stack.shift
      end
    else
      raise StaticMatic::Error.new("", name, "Partial not found")
    end
  end

  def generate_css(source, source_dir = '')
    # full_file_path = File.join(@src_dir, 'stylesheets', source_dir, "#{source}.sass")
    full_file_path = Dir[File.join(@src_dir, 'stylesheets', source_dir, "#{source}.{sass,scss}")].first

    if full_file_path && File.exist?(full_file_path)
      begin
        sass_options = { :load_paths => [ File.join(@src_dir, 'stylesheets') ] }.merge(self.configuration.sass_options)
      
        if File.extname(full_file_path) == ".scss"
          sass_options[:syntax] = :scss
        end
      
        stylesheet = Sass::Engine.new(File.read(full_file_path), sass_options)
        stylesheet.to_css
      rescue Exception => e
        render_rescue_from_error(StaticMatic::TemplateError.new(full_file_path, e))
      end
    else
      raise StaticMatic::Error.new("", source, "Stylesheet not found")
    end
  end

  def generate_js(source, source_dir = '')
    full_file_path = File.join(@src_dir, 'javascripts', source_dir, "#{source}.coffee")

    coffee_options = "#{self.configuration.coffee_options} -p"
    javascript = `coffee #{coffee_options} #{full_file_path}`
  end

  # Generates html from the passed source string
  #
  # generate_html_from_template_source("%h1 Welcome to My Site") -> "<h1>Welcome to My Site</h1>"
  #
  # Pass a block containing a string to yield within in the passed source:
  #
  # generate_html_from_template_source("content:\n= yield") { "blah" } -> "content: blah"
  #
  def generate_html_from_template_source(source, options = {})
    html = Haml::Engine.new(source, self.configuration.haml_options.merge(options))
    locals = options[:locals] || {}
    html.render(@scope, locals) { yield }
  end

  def determine_layout(dir = '')
    layout_name ||= @default_layout
  
    if @scope.instance_variable_get("@layout")
      layout_name = @scope.instance_variable_get("@layout")
    elsif dir
      dirs = dir.split("/")
      dir_layout_name = dirs[1]
    
      if layout_exists?(dir_layout_name)
        layout_name = dir_layout_name
      end
    end

    layout_name 
  end
    
  # Returns a raw template name from a source file path:
  # source_template_from_path("/path/to/site/src/stylesheets/application.sass")  ->  "application"
  def source_template_from_path(path)
    file_dir, file_name = File.split(path)
    file_name.chomp!(File.extname(file_name))
    [ file_dir, file_name ]
  end
end