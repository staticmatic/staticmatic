module StaticMatic
  class Server
    def initialize(staticmatic, default = nil)
      @files = default || Rack::File.new(staticmatic.site_dir)
      @staticmatic = staticmatic
      

    end

    def call(env)
      @staticmatic.load_helpers
      path_info = env["PATH_INFO"]

      locale, file_dir, file_name, file_ext = expand_path(path_info)

      # remove stylesheets/ directory if applicable
      file_dir.gsub!(/^\/stylesheets\/?/, "")
      
      file_dir = CGI::unescape(file_dir)
      file_name = CGI::unescape(file_name)

      unless file_ext && ["html", "css"].include?(file_ext) &&
          @staticmatic.template_exists?(file_name, file_dir) &&
          File.basename(file_name) !~ /^\_/
        return @files.call(env)
      end

      res = Rack::Response.new
      res.header["Content-Type"] = "text/#{file_ext}"

      begin
        if file_ext == "css"
          res.write @staticmatic.generate_css(file_name, file_dir)
        else
          if locale != ""
            @staticmatic.translation.prepare
            @staticmatic.translation.disable_caching
            @staticmatic.translation.current_locale = locale
          end

          # Call generator_sitemap through all the pages
          @staticmatic.generate_site_map

          # Write in the stdout the current path
          res.write @staticmatic.generate_html_with_layout(file_name, file_dir)

          # Clear the hash to the next access
          @staticmatic.site_map.clear
        end
      rescue StaticMatic::Error => e
        res.write e.message
      end

      res.finish
    end

    # Starts the StaticMatic preview server
    def self.start(staticmatic)
      [ 'INT', 'TERM' ].each do |signal|
        Signal.trap(signal) do
          puts 
          puts "Exiting"
          exit!(0)
        end
      end
      port = staticmatic.configuration.preview_server_port || 3000

      host = staticmatic.configuration.preview_server_host || ""

      app = Rack::Builder.new do
        use Rack::ShowExceptions
        run StaticMatic::Server.new(staticmatic)
      end 
      
      Rack::Handler::WEBrick.run(app, :Port => port, :Host => host)
    end

    private

    def expand_path(path_info)
      dirname, basename = File.split(path_info)
      if @staticmatic.translation.should_translate?
        locale, dirname = get_locale_from_dirpath(dirname)
      else
        locale = ""
      end

      extname = File.extname(path_info).sub(/^\./, '')
      filename = basename.chomp(".#{extname}")

      if extname.empty?
        dir = File.join(dirname, filename)
        is_dir = path_info[-1, 1] == '/' || (@staticmatic.template_directory?(dir) && !@staticmatic.template_exists?(filename, dirname))
        if is_dir
          dirname = dir
          filename = 'index'
        end
        extname = 'html'
      end

      [ locale, dirname, filename, extname ]
    end

    def get_locale_from_dirpath(path)
      locale, html_file = path[1..-1].split("/", 2)
      if @staticmatic.translation.available_locales.include? locale
        return locale.to_s, "/"+html_file.to_s
      else
        return "", path
      end
    end
  end
end
