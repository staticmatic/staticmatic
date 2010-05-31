module Compass
  module AppIntegration
    module Staticmatic
      class Installer < Compass::Installers::ManifestInstaller 
        def completed_configuration
          nil
        end
        
        def finalize(options = {})
          puts manifest.welcome_message if manifest.welcome_message
        end
      end
    end
  end
end