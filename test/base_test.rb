require File.dirname(__FILE__) + "/test_helper"

class StaticMatic::BaseTest < Test::Unit::TestCase
  def setup
    setup_staticmatic
  end

  def test_initial_configuration_settings
    assert_equal true, @staticmatic.configuration.use_extensions_for_page_links
    assert_equal 3000, @staticmatic.configuration.preview_server_port
  end
  
  def test_should_setup_directories
    tmp_dir = File.dirname(__FILE__) + '/sandbox/tmp'
    staticmatic = StaticMatic::Base.new(tmp_dir)
    staticmatic.run('setup')
    
    StaticMatic::Base.base_dirs.each do |dir|
      assert File.exists?("#{tmp_dir}/#{dir}"), "Should create #{dir}"
    end
    
    StaticMatic::Base.base_dirs.reverse.each do |dir|
      Dir.entries("#{tmp_dir}/#{dir}").each do |file|
        next if file.match(/^\./)
        File.delete("#{tmp_dir}/#{dir}/#{file}")
      end
      Dir.delete("#{tmp_dir}/#{dir}") if File.exists?("#{tmp_dir}/#{dir}")
    end
  end
    
  def test_should_include_custom_helper
    content = @staticmatic.generate_html_with_layout("index")
    assert_match "Hello, Steve!", content
  end
end