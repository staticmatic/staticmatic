require File.dirname(__FILE__) + "/spec_helper"

describe "Helpers:" do
  include StaticMatic::Helpers
  before do
    setup_staticmatic
    @staticmatic.instance_variable_set("@current_page", "")
  end
  
  it "should include custom helper" do
    content = @staticmatic.generate_html_with_layout("index")
    content.should match(/Hello, Steve!/)
  end
  
  context "When using the stylesheet helper" do
    before do
      @links = stylesheets
    end
    
    it "should set up links for all stylesheets" do
      @links.should match(/stylesheets\/application\.css/)
      @links.should match(/stylesheets\/nested\/a_nested_stylesheet\.css/)
    end
    
    it "should not link to partials" do
      @links.should_not match(/\_forms.css/)
    end
  end
end