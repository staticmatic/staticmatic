
require File.dirname(__FILE__) + "/../spec_helper"

describe "Helpers:" do
  include StaticMatic::Helpers::AssetsHelper
  include StaticMatic::Helpers::CurrentPathHelper
  include StaticMatic::Helpers::TagHelper
  before do
    setup_staticmatic
    @staticmatic.instance_variable_set("@current_page", "")
  end
  
  context "When using the stylesheet helper" do
    before do
      @links = stylesheets
    end
    
    it "should set up links for all stylesheets" do
      @links.should match(/stylesheets\/application\.css/)
      @links.should match(/stylesheets\/nested\/a_nested_stylesheet\.css/)
      @links.should match(/stylesheets\/sassy\.css/)
    end
    
    it "should not link to partials" do
      @links.should_not match(/\_forms.css/)
    end
    
    it "should setup links for specified stylesheets" do
      stylesheets(:sassy).should match(/stylesheets\/sassy\.css/)
    end
  end
  
  context "When using the stylesheet helper from a sub page" do
    before do
      @staticmatic.instance_variable_set("@current_page", "/sub/index.html")
      @links = stylesheets
    end
    
    it "should link relative to current page" do
      @links.should match(/\.\.\/stylesheets/)
    end
  end
end
