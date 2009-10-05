require File.dirname(__FILE__) + "/spec_helper"

describe "StaticMatic::Template" do
  before do
    setup_staticmatic
    
    template_file = File.join(TEST_SITE_PATH, "src", "pages", "page_with_error.haml")
    
    begin
      @staticmatic.generate_html_from_template_source(File.read(template_file))
    rescue Exception => e
      @template_error = StaticMatic::TemplateError.new(template_file, e)
    end
  end
  
  it "extract source around line number" do
    @template_error.source_extract.should match(/\- bang\!/)
  end
  
  it "extract line number from backtrace" do
    @template_error.line_number.should == "3"
  end
end