module StaticMatic
  module Helpers
    self.extend self
    
    # Generates links to all stylesheets in the source directory
    # = stylesheets
    # or specific stylesheets in a specific order
    # = stylesheets :reset, :application
    # Can also pass options hash in at the end so you can specify :media => :print
    def stylesheets(*params)
      options = {}
      if params.last.is_a?(Hash)
        options = params.last
        params.slice!(-1, 1)
      end
      options[:media] = 'all' unless options.has_key?(:media)
      options[:rel] = 'stylesheet'; options[:type] = 'text/css'

      relative_path = current_page_relative_path

      output = ""
      if params.length == 0
        # no specific files requested so include all in no particular order
        stylesheet_dir = File.join(@staticmatic.src_dir, 'stylesheets')
        stylesheet_directories = Dir[File.join(stylesheet_dir, '**','*.{sass,scss}')]
        
        # Bit of a hack here - adds any stylesheets that exist in the site/ dir that haven't been generated from source sass
        Dir[File.join(@staticmatic.site_dir, 'stylesheets', '*.css')].each do |filename|
          search_filename = File.basename(filename).chomp(File.extname(filename))

          already_included = false
          stylesheet_directories.each do |path|
            if File.basename(path).include?(search_filename)
              already_included = true
              break
            end
          end
          
          stylesheet_directories << filename unless already_included
        end

        stylesheet_directories.each do |path|
          
          filename_without_extension = File.basename(path).chomp(File.extname(path))
          
          if !filename_without_extension.match(/^\_/)
            path = path.gsub(/#{@staticmatic.base_dir}\/(src|site)\//, "").
                                 gsub(/#{filename_without_extension}\.(sass|scss|css)/, "")
          
            options[:href] = "#{relative_path}#{path}#{filename_without_extension}.css"
            output << tag(:link, options)
          end
        end
      else
        #specific files requested and in a specific order
        params.each do |file|
          if File.exist?(File.join(@staticmatic.src_dir, 'stylesheets', "#{file}.sass")) ||
             File.exist?(File.join(@staticmatic.site_dir, 'stylesheets', "#{file}.css"))
            options[:href] = "#{relative_path}stylesheets/#{file}.css"
            output << tag(:link, options)
          end
        end
      end
      
      output
    end
    
    # Generate javascript source tags for the specified files
    #
    # javascripts('test')   ->   <script language="javascript" src="javascripts/test.js"></script>
    #    
    def javascripts(*files)
      relative_path = current_page_relative_path

      output = ""
      files.each do |file|
        file_str = file.to_s
        src = file_str.match(%r{^((\.\.?)?/|https?://)}) ? file_str : "#{relative_path}javascripts/#{file_str}.js"
        output << tag(:script, :language => 'javascript', :src => src, :type => "text/javascript") { "" }
      end
      output
    end

    # Generates a form text field
    #
    def text_field(name, value, options = {})
      options.merge!(:type => "text", :name => name, :value => value)
      tag(:input, options)
    end
    
    # Generate a form textarea
    #
    def text_area(name, value, options = {})
      options.merge!(:name => name)
      tag(:textarea, options) { value }
    end
    
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

    # Generates an image tag always relative to the current page unless absolute path or http url specified.
    # 
    # img('test_image.gif')   ->   <img src="/images/test_image.gif" alt="Test image"/>
    # img('contact/test_image.gif')   ->   <img src="/images/contact/test_image.gif" alt="Test image"/>
    # img('http://localhost/test_image.gif')   ->   <img src="http://localhost/test_image.gif" alt="Test image"/>
    def img(name, options = {})
      options[:src] = name.match(%r{^((\.\.?)?/|https?://)}) ? name : "#{current_page_relative_path}images/#{name}"
      options[:alt] ||= name.split('/').last.split('.').first.capitalize.gsub(/_|-/, ' ')
      tag :img, options
    end
  
    # Generates HTML tags:
    #
    # tag(:br)   ->   <br/>
    # tag(:a, :href => 'test.html') { "Test" }    ->    <a href="test.html">Test</a>
    #
    def tag(name, options = {}, &block)
      options[:id] ||= options[:name] if options[:name]
      output = "<#{name}"
      options.keys.sort { |a, b| a.to_s <=> b.to_s }.each do |key|
        output << " #{key}=\"#{options[key]}\"" if options[key]
      end
      
      if block_given?
        output << ">"
        output << yield
        output << "</#{name}>"
      else
        format = @staticmatic.configuration.haml_options[:format]
        
        if format.nil? || format == :xhtml
          output << "/>"
        else
          output << ">"
        end
      end
      output
    end
    
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
    
    # Include a partial template
    def partial(name, options = {})
      @staticmatic.generate_partial(name, options)
    end

    def current_page
      @staticmatic.current_page
    end

    private

    def current_page_relative_path(current_path = nil)
      if current_path.nil? || current_path.match(/^((\.\.?)?\/|\#|.+?\:)/) == nil
        current_page_depth = current_page.split('/').length - 2;
        (current_page_depth > 0) ? ([ '..' ] * current_page_depth).join('/') + '/' : ''
      else
        ''
      end
    end

  end
end
