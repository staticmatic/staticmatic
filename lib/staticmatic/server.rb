module StaticMatic
  class Server < Mongrel::HttpHandler
    @@file_only_methods = ["GET","HEAD"]
 
    def initialize(staticmatic)
      @files = Mongrel::DirHandler.new(staticmatic.site_dir, false)
      @staticmatic = staticmatic
    end
  
    def process(request, response)
      @staticmatic.load_helpers
      path_info = request.params[Mongrel::Const::PATH_INFO]
      get_or_head = @@file_only_methods.include? request.params[Mongrel::Const::REQUEST_METHOD]
      
      file_dir, file_name, file_ext = expand_path(path_info)

      # remove stylesheets/ directory if applicable
      file_dir.gsub!(/^\/stylesheets\/?/, "")
      
      file_dir = CGI::unescape(file_dir)
      file_name = CGI::unescape(file_name)
      
      if file_ext && file_ext.match(/html|css/)
        response.start(200) do |head, out|
          head["Content-Type"] = "text/#{file_ext}"
          output = ""

          if @staticmatic.template_exists?(file_name, file_dir) && !(File.basename(file_name) =~ /^\_/)

            begin
              if file_ext == "css"
                output = @staticmatic.generate_css(file_name, file_dir)
              else
                output = @staticmatic.generate_html_with_layout(file_name, file_dir)
              end
            rescue StaticMatic::Error => e
              output = e.message
            end
          else
            if @files.can_serve(path_info)
              @files.process(request,response)
            else
              output = "File not Found"
            end
          end
          out.write output
        end
      else
        # try to serve static file from site dir
        if @files.can_serve(path_info)
          @files.process(request,response)
        end
      end
    end

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
    
    class << self
      # Starts the StaticMatic preview server
      def start(staticmatic)
        port = staticmatic.configuration.preview_server_port || 3000
        
        host = staticmatic.configuration.preview_server_host || ""
        
        config = Mongrel::Configurator.new :host => host do
          puts "Running Preview of #{staticmatic.base_dir} on #{host}:#{port}"
          listener :port => port do
            uri "/", :handler => Server.new(staticmatic)
          end
          trap("INT") { stop }
          run
        end
        config.join
      end
    end
  end
end
