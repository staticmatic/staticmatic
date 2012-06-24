require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe "StaticMatic::Build" do
  before do
    @tmp_dir = File.dirname(__FILE__) + '/sandbox/tmp'
    @locale_dir = File.expand_path File.join(@tmp_dir, 'locale')
    site_path = File.join(@tmp_dir, 'site/')
    FileUtils.remove_entry_secure @locale_dir
    FileUtils.remove_entry_secure site_path
    FileUtils.mkdir_p site_path
    FileUtils.mkdir_p @locale_dir
    @staticmatic = StaticMatic::Base.new(@tmp_dir)
  end

  it "should generate translated pages" do
    files = ["en", "pt_BR"].collect do |locale|
      locale_dir = File.join @locale_dir, locale
      FileUtils.mkdir locale_dir
      File.join locale_dir, 'tmp.po'
    end

    FileUtils.touch files

    stringio = supress_stdout do
      @staticmatic.build_html
    end
    stringio.rewind
    stringio.read.should eql("created spec/sandbox/tmp/site/index.html\n" +
                             "created spec/sandbox/tmp/site/en/index.html\n" +
                             "created spec/sandbox/tmp/site/pt_BR/index.html\n")

    %w(
      locale/en/LC_MESSAGES/tmp.mo
      locale/pt_BR/LC_MESSAGES/tmp.mo
      site/index.html
      site/en/index.html
      site/pt_BR/index.html
      ).each {|path| File.exists?(File.join(@tmp_dir, path)).should(be_true, "#{path} expected to exist in #{@tmp_dir}") }
  end

  it "should generate pages without translation" do
    stringio = supress_stdout do
      @staticmatic.build_html
    end
    stringio.rewind
    stringio.read.should eql("created spec/sandbox/tmp/site/index.html\n")

    path = 'site/index.html'
    File.exists?(File.join(@tmp_dir, path)).should(be_true, "#{path} expected to exist in #{@tmp_dir}")
  end

  it "should insert translation methods in haml" do
    haml = Haml::Engine.new("%h1 test string\n%h2 another test string\n%p= _('yet another test string')\nplain test string\n= _('translatable script string')\n%h1\n  Test translatable h1 string\n= \"not translatable\"\ntranslate \"this\", please")
    haml.render
    ["_(\"test string\")", "_(\"another test string\")", "_(\"plain test string\")", "_(\"Test translatable h1 string\")", "_('yet another test string')", " _('translatable script string')", "_(\"translate \\\"this\\\", please\")"].each do |string|
      haml.get_staticmatic_translation_code.should include(string)
    end
    haml.get_staticmatic_translation_code.should_not include("_(\"not translatable\")")
  end
end
