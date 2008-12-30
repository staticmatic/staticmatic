require File.dirname(__FILE__) + "/test_helper"

class StaticMatic::BaseTest < Test::Unit::TestCase
  def setup
    setup_staticmatic
  end

  should "set initial configuration settings" do
    assert_equal true, @staticmatic.configuration.use_extensions_for_page_links
    assert_equal 3000, @staticmatic.configuration.preview_server_port
  end

end