require File.dirname(__FILE__) + "/test_helper"


class StaticMaticServerTest < Test::Unit::TestCase
  def setup
    @base_dir = File.dirname(__FILE__) + '/sandbox/tmp'
  end

  def test_default
    assert true
  end
end
