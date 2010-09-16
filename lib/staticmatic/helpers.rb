["assets", "form", "current_path", "render", "tag", "url"].each do |helper|
  require File.join(File.dirname(__FILE__), "helpers", "#{helper}_helper")
end

module StaticMatic::Helpers
  include TagHelper
  include UrlHelper  
  include AssetsHelper
  include FormHelper
  include RenderHelper
  include CurrentPathHelper  
end
