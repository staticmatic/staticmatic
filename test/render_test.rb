require File.dirname(__FILE__) + "/test_helper"

class StaticMatic::RenderTest < Test::Unit::TestCase
  def setup
    setup_staticmatic
  end
  
  should "generate content with a layout" do
    content = @staticmatic.generate_html_with_layout("index")
    assert_match "StaticMatic", content
    assert_match "This is some test content", content
  end
  
  should "generate html with layout assigned in template" do
    content = @staticmatic.generate_html_with_layout("layout_test")
    assert_match "Alternate Layout", content
  end
  
  should "generate css" do
    content = @staticmatic.generate_css("application")
  end
  
  should "find source filename from path" do
    assert_equal "application", @staticmatic.source_template_from_path("@base_dir/src/stylesheets/application.css")[1]
  end
  
  should "find layout from passed path" do
    assert_equal "projects", @staticmatic.detirmine_layout("test/projects")
  end
end