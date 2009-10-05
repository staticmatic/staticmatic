require File.dirname(__FILE__) + "/spec_helper"

describe "StaticMatic::Base" do
  before do
    setup_staticmatic
  end

  it "should set initial configuration settings" do
    @staticmatic.configuration.use_extensions_for_page_links.should == true
    @staticmatic.configuration.preview_server_port.should == 3000
  end

end