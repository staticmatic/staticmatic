require 'rubygems'
require 'stringio'
require 'test/unit'

require File.dirname(__FILE__) + '/../lib/staticmatic'

TEST_SITE_PATH = File.join(File.dirname(__FILE__), "sandbox", "test_site")

class Test::Unit::TestCase
  def self.should(description, &block)
    test_name = "test_should_#{description.gsub(/[\s]/,'_')}".to_sym
    raise "#{test_name} is already defined in #{self}" if self.instance_methods.include?(test_name.to_s)
    define_method(test_name, &block)
  end
end

def setup_staticmatic
  @staticmatic = StaticMatic::Base.new(TEST_SITE_PATH)
end

