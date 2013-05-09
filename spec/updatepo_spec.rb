require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe "StaticMatic::Updatepo" do
  module GetText
    def update_pofiles(textdomain, files, app_version, options = {})
      textdomain.should == 'tmp'
      files.should == ['spec/sandbox/tmp/src/pages/index.haml', 'spec/sandbox/tmp/src/layouts/default.haml']
      app_version.should == nil
      options.should == {:po_root => File.expand_path(File.dirname(__FILE__) + '/sandbox/tmp/locale'), :msgmerge => ["--sort-output", "--no-location"]}
    end
  end

  before do
    setup_staticmatic
    @tmp_dir = File.dirname(__FILE__) + '/sandbox/tmp'
    @locale_path = File.join @tmp_dir, 'locale'
  end

  it "should send the correct files to GetText" do
    old_locale_files = File.join @tmp_dir, '../old_locale/**/*'
    FileUtils.cp_r Dir.glob(old_locale_files), @locale_path

    staticmatic = StaticMatic::Base.new @tmp_dir
    supress_stdout do
      staticmatic.run 'updatepo'
    end
  end

  it "should insert translations methods in haml" do
    file_path = File.join @tmp_dir, 'src/pages/index.haml'
    haml = Haml::Engine.new(IO.readlines(file_path).join)
    haml.get_staticmatic_translation_code.should == ["_(\"StaticMatic!\")", "_hamlout.push_text(\"<h1>StaticMatic!</h1>\\n\", 0, false);"]
  end
end
