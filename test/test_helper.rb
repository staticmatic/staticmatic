require 'rubygems'
require 'stringio'
require 'test/unit'
require 'active_support' 
require 'shoulda'

require File.dirname(__FILE__) + '/../lib/staticmatic'

TEST_SITE_PATH = File.join(File.dirname(__FILE__), "sandbox", "test_site")

def setup_staticmatic
  @staticmatic = StaticMatic::Base.new(TEST_SITE_PATH)
end