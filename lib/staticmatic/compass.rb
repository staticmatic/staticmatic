["installer", "configuration_defaults", "app_integration"].each do |file|
  require File.join(File.dirname(__FILE__), "compass", file)
end

Compass.add_configuration(:staticmatic)
