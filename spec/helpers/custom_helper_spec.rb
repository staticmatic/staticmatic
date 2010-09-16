
require File.dirname(__FILE__) + "/../spec_helper"

describe "Helpers:" do
  include StaticMatic::Helpers::AssetsHelper
  include StaticMatic::Helpers::CurrentPathHelper
  include StaticMatic::Helpers::TagHelper
  before do
    setup_staticmatic
    @staticmatic.instance_variable_set("@current_page", "")
  end
  
  it "should include custom helper" do
    content = @staticmatic.generate_html_with_layout("index")
    content.should match(/Hello, Steve!/)
  end
  
end
