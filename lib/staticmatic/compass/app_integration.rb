
module Compass
  module AppIntegration
    module Staticmatic

      extend self
      


      def installer(*args)
        Installer.new(*args)
      end

      def configuration
        Compass::Configuration::Data.new('staticmatic').
          extend(ConfigurationDefaults)
      end

    end
  end
end
