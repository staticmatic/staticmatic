module StaticMatic
  module RenderMixin
    def source_for_layout
      if layout_exists?(@layout)
        File.read(full_layout_path(@layout))
      else
        raise StaticMatic::Error.new("", full_layout_path(@layout), "Layout not found")
      end
    end
  
    # Generate html from source file:
    # generate_html("index.haml")
    def generate_html(source_file, source_dir = '')
      full_file_path = File.join(@src_dir, 'pages', source_dir, "#{source_file}.haml")
  
      begin
        # clear all scope variables except @staticmatic
        @scope.instance_variables.each do |var|
          @scope.instance_variable_set(var, nil) unless var == '@staticmatic' 
        end
        html = generate_html_from_template_source(File.read(full_file_path))
    
        @layout = detirmine_layout(source_dir)
      rescue StaticMatic::Error => staticmatic_error
        # Catch any errors from the actual template - otherwise the error will be assumed to be from the
        # layout
        raise staticmatic_error
      rescue Haml::Error => haml_error
        raise StaticMatic::Error.new(haml_error.line_offset, "#{source_dir}/#{source_file}", haml_error.message)
      end
    
      # 
      # # TODO: DRY this up
      # if @scope.instance_variable_get("@layout")
      #   @layout = @scope.instance_variable_get("@layout")
      # end
      # 
      html
    end
  
    def generate_html_with_layout(source, source_dir = '')
      @current_page = File.join(source_dir, "#{source}.html")
      @current_file_stack.unshift(File.join(source_dir, "#{source}.haml"))
  
      template_content = generate_html(source, source_dir)
      @layout = detirmine_layout(source_dir)
    
      begin
        generate_html_from_template_source(source_for_layout) { template_content }
      rescue StaticMatic::Error => staticmatic_error
        # Catch any errors from the actual template - otherwise the error will be assumed to be from the
        # layout
        raise staticmatic_error
      rescue Haml::Error => haml_error
        raise StaticMatic::Error.new("", "Layout: #{source_dir}/#{@layout}", haml_error.message)
      ensure
        @current_page = nil
        @current_file_stack.shift
      end
    end
  
    def generate_partial(name, options = {})
      partial_dir, partial_name = File.dirname(self.current_file), name  # default relative to current file
      partial_dir, partial_name = File.split(name) if name.index('/') # contains a path so it's absolute from src/pages dir
      partial_name = "_#{partial_name}.haml"
  
      partial_path = File.join(@src_dir, 'pages', partial_dir, partial_name)
      unless File.exists?(partial_path)
        # couldn't find it in the pages subdirectory tree so try old way (ignoring the path)
        partial_dir = 'partials'; partial_name = "#{File.basename(name)}.haml"
        partial_path = File.join(@src_dir, partial_dir, partial_name)
      end
    
      if File.exists?(partial_path)
        partial_rel_path = "/#{partial_dir}/#{partial_name}".gsub(/\/+/, '/')
        @current_file_stack.unshift(partial_rel_path)
        begin
          generate_html_from_template_source(File.read(partial_path), options)
        rescue Haml::Error => haml_error
          raise StaticMatic::Error.new(haml_error.haml_line, "Partial: #{partial_rel_path[0,partial_rel_path.length-5]}", haml_error.message)
        ensure
          @current_file_stack.shift
        end
      else
        raise StaticMatic::Error.new("", name, "Partial not found")
      end
    end
  
    def generate_css(source, source_dir = '')
      full_file_path = File.join(@src_dir, 'stylesheets', source_dir, "#{source}.sass")
      begin
        sass_options = { :load_paths => [ File.join(@src_dir, 'stylesheets') ] }.merge(self.configuration.sass_options)
        stylesheet = Sass::Engine.new(File.read(full_file_path), sass_options)
        stylesheet.to_css
      rescue Sass::SyntaxError => sass_error
        raise StaticMatic::Error.new(sass_error.sass_line, full_file_path, sass_error.message)
      end
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
      html = Haml::Engine.new(source, options)
  
      html.render(@scope) { yield }
    end
  
    def detirmine_layout(dir = '')
      layout_name = "application"
    
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
  end
end