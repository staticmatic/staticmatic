require File.dirname(__FILE__) + "/spec_helper"

describe "StaticMatic::Setup" do
  before do
    setup_staticmatic
  end
  
  it "setup directories" do
    tmp_dir = File.dirname(__FILE__) + '/sandbox/tmp'
    staticmatic = StaticMatic::Base.new(tmp_dir)
    staticmatic.run('setup')
    
    StaticMatic::Base.base_dirs.each do |dir|
      File.exists?("#{tmp_dir}/#{dir}").should_not be_nil, "Should create #{dir}"
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