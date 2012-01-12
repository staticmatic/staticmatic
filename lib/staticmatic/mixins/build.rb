module StaticMatic::BuildMixin
    
  def build
    # Generate the sitemap
    generate_site_map

    build_css
    build_html
  end
    
  # Build HTML from the source files
  def build_html
    # the first one should not use a locale, for the default:
    generate_all_html_pages

    # now translate, if necessary:
    if translation.should_translate?
      translation.prepare
      translation.available_locales.each do |locale|
        translation.current_locale = locale
        generate_all_html_pages
      end
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
  
  def copy_file(from, to)
    FileUtils.cp(from, to)
  end

  def save_page(filename, content)
    if translation.should_translate?
      locale = translation.current_locale
      filename = File.join(locale, filename)
    end
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

  private
  def generate_all_html_pages
    Dir["#{@src_dir}/pages/**/*.haml"].each do |path|
      next if File.basename(path) =~ /^\_/  # skip partials
      file_dir, template = source_template_from_path(path.sub(/^#{@src_dir}\/pages/, ''))
      save_page(File.join(file_dir, template), generate_html_with_layout(template, file_dir))
    end
  end

  # Haml gettext module providing gettext translation for all Haml plain text
  # calls. Modified from:
  # http://www.nanoant.com/programming/haml-gettext-automagic-translation

  module HamlGettext
    # Inject _ gettext into plain text and tag plain text calls
    def push_plain(text)
      super _(text)
    end

    def parse_tag(line)
      tag_name, attributes, attributes_hash, object_ref, nuke_outer_whitespace,
      nuke_inner_whitespace, action, value = super(line)
      value = _(value) unless action || value.empty?
      [tag_name, attributes, attributes_hash, object_ref, nuke_outer_whitespace,
       nuke_inner_whitespace, action, value]
    end

    # Patch the Haml Engine for automatic translations:
    Haml::Engine.send(:include, HamlGettext)
  end
end
