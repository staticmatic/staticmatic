require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe "StaticMatic::Setup" do
  it "should set up project directory in given path" do
    setup_staticmatic
    @tmp_dir = File.dirname(__FILE__) + '/sandbox/tmp'
    staticmatic = StaticMatic::Base.new(@tmp_dir)
    stringio = supress_stdout do
      staticmatic.run('setup')
    end
    stringio.rewind
    stringio.read.should eql("Site root is: spec/sandbox/tmp\nDone\n")
    %w(
    site/images
    site/javascripts
    site/stylesheets
    src/layouts/default.haml
    src/pages/index.haml
    src/stylesheets/screen.sass
    config/site.rb
    ).each {|path| File.exists?(File.join(@tmp_dir, path)).should(be_true, "#{path} expected to exist in #{@tmp_dir}") }
  end
end
