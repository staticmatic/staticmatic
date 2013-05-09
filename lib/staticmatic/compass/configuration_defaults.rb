module Compass
  module AppIntegration
    module Staticmatic
      module ConfigurationDefaults
        def project_type_without_default
          :staticmatic
        end

        def http_path
          "/"
        end

        def sass_dir_without_default
          "src/stylesheets"
        end

        def javascripts_dir_without_default
          "site/javascripts"
        end

        def css_dir_without_default
          "site/stylesheets"
        end

        def images_dir_without_default
          "site/images"
        end

        def default_http_images_path
          "images"
        end

        def default_http_javascripts_path
          "javascripts"
        end

        def default_cache_dir
          ".sass-cache"
        end
      end
    end
  end
end
