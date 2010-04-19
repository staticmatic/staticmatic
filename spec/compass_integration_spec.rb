require File.dirname(__FILE__) + "/spec_helper"

describe "Compass integration" do
  before do
    setup_staticmatic
  end
  
  it "should configure compass" do
    Compass.configuration.project_path.should == TEST_SITE_PATH
    Compass.configuration.sass_dir.should == File.join(TEST_SITE_PATH, "src", "stylesheets")
    Compass.configuration.css_dir.should == File.join(TEST_SITE_PATH, "site", "stylesheets")
    Compass.configuration.images_dir.should == File.join(TEST_SITE_PATH, "site", "images")
    Compass.configuration.http_path.should == "/"
    Compass.configuration.http_images_path.should == "/images"
  end
end