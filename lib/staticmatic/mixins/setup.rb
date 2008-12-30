module StaticMatic::SetupMixin
  
  def setup
    Dir.mkdir(@base_dir) unless File.exists?(@base_dir)
  
    StaticMatic::BASE_DIRS.each do |directory|
      directory = "#{@base_dir}/#{directory}"
      if !File.exists?(directory)
        Dir.mkdir(directory)
        puts "created #{directory}"
      end
    end

    StaticMatic::TEMPLATES.each do |template, destination|
      copy_file("#{@templates_dir}/#{template}", "#{@src_dir}/#{destination}")
    end

    puts "Done"
  end
end