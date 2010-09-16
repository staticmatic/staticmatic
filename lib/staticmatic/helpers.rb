["assets", "form", "current_path", "render", "tag", "url"].each do |helper|
  require File.join(File.dirname(__FILE__), "helpers", "#{helper}_helper")
end
