module StaticMatic::BuildMixin
    
  def build
    build_css
    build_html
  end
    
  # Build HTML from the source files
  def build_html
    Dir["#{@src_dir}/pages/**/*.haml"].each do |path|
      next if File.basename(path) =~ /^\_/  # skip partials
      file_dir, template = source_template_from_path(path.sub(/^#{@src_dir}\/pages/, ''))
      save_page(File.join(file_dir, template), generate_html_with_layout(template, file_dir))
    end
  end

  # Build CSS from the source files
  def build_css
    Dir["#{@src_dir}/stylesheets/**/*.sass"].each do |path|
      file_dir, template = source_template_from_path(path.sub(/^#{@src_dir}\/stylesheets/, ''))
      
      if !template.match(/(^|\/)\_/)
        save_stylesheet(File.join(file_dir, template), generate_css(template, file_dir))
      end
    end
  end
  
  def copy_file(from, to)
    FileUtils.cp(from, to)
  end

  def save_page(filename, content)
    generate_site_file(filename, 'html', content)
  end

  def save_stylesheet(filename, content)
    generate_site_file(File.join('stylesheets', filename), 'css', content)
  end

  def generate_site_file(filename, extension, content)
    path = File.join(@site_dir,"#{filename}.#{extension}")
    FileUtils.mkdir_p(File.dirname(path))
    File.open(path, 'w+') do |f|
      f << content
    end
    
    puts "created #{path}"
  end
end