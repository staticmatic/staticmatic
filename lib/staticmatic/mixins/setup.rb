module StaticMatic::SetupMixin
  
  def setup
    Dir.mkdir(@base_dir) unless File.exists?(@base_dir)
    
    Dir[File.join(File.dirname(__FILE__), "..", "templates", "project", "*")].each do |template|
      begin
        FileUtils.cp_r(template, @base_dir)
      rescue Errno::EEXIST
        # ignore - template exists
      end
    end

    puts "Done"
  end
end