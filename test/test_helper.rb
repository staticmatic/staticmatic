require 'rubygems'
require 'stringio'
require 'test/unit'
require 'active_support' 
require 'shoulda'

require File.dirname(__FILE__) + '/../lib/staticmatic-core'

TEST_SITE_PATH = File.join(File.dirname(__FILE__), "sandbox", "test_site")

def setup_staticmatic
  @base_dir = File.dirname(__FILE__) + '/sandbox/test_site'
  @staticmatic = StaticMatic::Base.new(@base_dir)
end