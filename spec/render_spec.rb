require File.dirname(__FILE__) + "/spec_helper"

describe "StaticMatic::Render" do
  before do
    setup_staticmatic
  end
  
  it "generate content with a layout" do
    content = @staticmatic.generate_html_with_layout("index")
    content.should match(/StaticMatic/)
    content.should match(/This is some test content/)
  end
  
  it "generate html with layout assigned in template" do
    content = @staticmatic.generate_html_with_layout("layout_test")
    content.should match(/Alternate Layout/)
  end
  
  it "generate css" do
    content = @staticmatic.generate_css("application")
  end
  
  it "find source filename from path" do
    @staticmatic.source_template_from_path("@base_dir/src/stylesheets/application.css")[1].should == "application"
  end
  
  it "find layout from passed path" do
    @staticmatic.determine_layout("test/projects").should == "projects"
  end
  
end