module StaticMatic
  class Server
    def initialize(staticmatic, default = nil)
      @files = default || Rack::File.new(staticmatic.site_dir)
      @staticmatic = staticmatic
    end

    def call(env)
      @staticmatic.load_helpers
      path_info = env["PATH_INFO"]

      file_dir, file_name, file_ext = expand_path(path_info)

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
          res.write @staticmatic.generate_html_with_layout(file_name, file_dir)
        end
      rescue StaticMatic::Error => e
        res.write e.message
      end

      res.finish
    end

    # Starts the StaticMatic preview server
    def self.start(staticmatic)
      port = staticmatic.configuration.preview_server_port || 3000

      host = staticmatic.configuration.preview_server_host || ""

      app = Rack::Builder.new do
        use Rack::ShowExceptions
        run StaticMatic::Server.new(staticmatic)
      end
      Rack::Handler::Mongrel.run(app, :Port => port, :Host => host)
    end

    private

    def expand_path(path_info)
      dirname, basename = File.split(path_info)

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

      [ dirname, filename, extname ]
    end
  end
end
