require File.dirname(__FILE__) + "/test_helper"

class StaticMatic::HelpersTest < Test::Unit::TestCase
  def setup
    setup_staticmatic
  end
  
  should "include custom helper" do
    content = @staticmatic.generate_html_with_layout("index")
    assert_match "Hello, Steve!", content
  end
end