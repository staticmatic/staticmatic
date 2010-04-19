require File.dirname(__FILE__) + "/spec_helper"

describe "StaticMatic::Setup" do
  before do
    setup_staticmatic
    @tmp_dir = File.dirname(__FILE__) + '/sandbox/tmp'
    staticmatic = StaticMatic::Base.new(@tmp_dir)
    staticmatic.run('setup')
  end
  
  it "should set up project directory in given path" do
    %w(
    site/images
    site/javascripts
    site/stylesheets
    src/layouts/site.haml
    src/pages/index.haml
    src/stylesheets/screen.sass
    config/site.rb
    ).each {|path| File.exists?(File.join(@tmp_dir, path)).should(be_true, "#{path} expected to exist in #{@tmp_dir}") }
  end
end