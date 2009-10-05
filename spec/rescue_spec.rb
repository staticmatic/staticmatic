require File.dirname(__FILE__) + "/spec_helper"

describe "StaticMatic::Rescue" do
  before do
    setup_staticmatic
  end
  
  it "catch haml template errors" do
    output = @staticmatic.generate_html_with_layout("page_with_error")
    output.should match(/StaticMatic::TemplateError/)
  end
  
  it "catch sass template errors" do
    output = @staticmatic.generate_css("css_with_error")
    output.should match(/StaticMatic::TemplateError/)
  end
  
  it "re-raise and catch partial errors" do
    begin
      @staticmatic.generate_html("page_with_partial_error")
    rescue StaticMatic::TemplateError => template_error
      template_error.filename.should match(/partials\/partial_with_error/)
    end
  end
  
  it "handle non-template errors" do
    begin
      raise Exception.new("This is an exception")
    rescue Exception => e
      output = @staticmatic.render_rescue_from_error(e)
    end
    
    output.should match(/Exception/)
    output.should match(/This is an exception/)
  end
end