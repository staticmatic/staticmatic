require File.dirname(__FILE__) + "/spec_helper"

describe "StaticMatic::Server" do
  before do
    @base_dir = File.dirname(__FILE__) + '/sandbox/tmp'
  end

  it "default" do
    true.should_not be_nil
  end
end
