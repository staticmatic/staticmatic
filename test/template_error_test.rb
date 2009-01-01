require File.dirname(__FILE__) + "/test_helper"

class StaticMatic::TemplateTest < Test::Unit::TestCase
  def setup
    setup_staticmatic
    
    template_file = File.join(TEST_SITE_PATH, "src", "pages", "page_with_error.haml")
    
    begin
      @staticmatic.generate_html_from_template_source(File.read(template_file))
    rescue Exception => e
      @template_error = StaticMatic::TemplateError.new(template_file, e)
    end
  end
  
  should "extract source around line number" do
    assert_match /\- bang\!/, @template_error.source_extract
  end
  
  should "extract line number from backtrace" do
    assert_equal "3", @template_error.line_number
  end
end