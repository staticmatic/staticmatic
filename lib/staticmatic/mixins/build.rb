module StaticMatic::BuildMixin
    
  def build
    build_css
    build_js
    build_html
    copy_images
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
    Dir["#{@src_dir}/stylesheets/**/*.{sass,scss}"].each do |path|
      file_dir, template = source_template_from_path(path.sub(/^#{@src_dir}\/stylesheets/, ''))
      
      if !template.match(/(^|\/)\_/)
        save_stylesheet(File.join(file_dir, template), generate_css(template, file_dir))
      end
    end
  end
  
  def build_js
    coffee_found = ENV['PATH'].split(':').inject(false) { |found, folder| found |= File.exists?("#{folder}/coffee") }
    if coffee_found
      Dir["#{@src_dir}/javascripts/**/*.coffee"].each do |path|
        file_dir, template = source_template_from_path(path.sub(/^#{@src_dir}\/javascripts/, ''))
        save_javascript(File.join(file_dir, template), generate_js(template, file_dir))
      end
    end
    # copy normal javascript files over
    Dir["#{@src_dir}/javascripts/**/*.js"].each do |path|
      file_dir, template = source_template_from_path(path.sub(/^#{@src_dir}\/javascripts/, ''))
      copy_file(path, File.join(@site_dir, 'javascripts', file_dir, "#{template}.js"))
    end
  end
  
  def copy_images
    img_exts = ['giff,jpg,jpeg,png,tiff'];
    Dir["#{@src_dir}/images/**/*.{#{ img_exts.join(',') }}"].each do |path|
      file_dir, file_name = File.split(path.sub(/^#{@src_dir}\/images/, ''))
      copy_file(path, File.join(@site_dir, 'images', file_dir, file_name))
    end
  end

  def copy_file(from, to)
    FileUtils.mkdir_p(File.dirname(to))
    FileUtils.cp(from, to)
  end

  def save_page(filename, content)
    generate_site_file(filename, 'html', content)
  end

  def save_stylesheet(filename, content)
    generate_site_file(File.join('stylesheets', filename), 'css', content)
  end

  def save_javascript(filename, content)
    generate_site_file(File.join('javascripts', filename), 'js', content)
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