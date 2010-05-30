require File.dirname(__FILE__) + "/spec_helper"

describe "Compass integration" do
  context "with the default staticmatic configuraiton" do 
    before do
      setup_staticmatic
    end
  
    it "should configure compass" do
      Compass.configuration.project_path.should == TEST_SITE_PATH
      Compass.configuration.sass_dir.should == File.join("src", "stylesheets")
      Compass.configuration.css_dir.should == File.join("site", "stylesheets")
      Compass.configuration.images_dir.should == File.join("site", "images")
      Compass.configuration.http_images_path.should == "site/images"
    end
  end
  
  context "with a custom configuration" do
    before do
      setup_staticmatic
    end
    
    it "should allow site config to override defaults" do
      Compass.configuration.http_path.should == "http://a.test.host"
    end
  end
end