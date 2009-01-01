require File.dirname(__FILE__) + "/test_helper"

class StaticMatic::RescueTest < Test::Unit::TestCase
  def setup
    setup_staticmatic
  end
  
  should "catch haml template errors" do
    output = @staticmatic.generate_html("page_with_error")
    assert_match /StaticMatic::TemplateError/, output 
  end
  
  should "catch sass template errors" do
    output = @staticmatic.generate_css("css_with_error")
    assert_match /StaticMatic::TemplateError/, output 
  end
end