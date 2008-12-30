require File.dirname(__FILE__) + "/test_helper"

class StaticMatic::SetupTest < Test::Unit::TestCase
  def setup
    setup_staticmatic
  end
  
  should "setup directories" do
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
end