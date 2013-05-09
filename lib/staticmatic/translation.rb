module StaticMatic
  class Translation
    require 'gettext'
    require 'gettext/tools'

    def initialize(base)
      @base = base
    end

    def get_domain
      File.basename(File.expand_path @base.base_dir)
    end

    def prepare
      locale_dir = File.expand_path(File.join @base.base_dir, 'locale')
      GetText.create_mofiles({:po_root => locale_dir, :mo_root => locale_dir })
      GetText.bindtextdomain(get_domain, "locale/")
      @current_locale = ""
    end

    def current_locale=(locale)
      GetText.current_locale = @current_locale = locale
    end

    def current_locale
      @current_locale.to_s
    end

    def available_locales
      locale_dir = File.expand_path File.join(@base.base_dir, 'locale')
      locales = Dir.glob(locale_dir+"/**/#{get_domain}.po").collect do |po_file|
        File.basename(File.dirname po_file)
      end.sort
      locales
    end

    def should_translate?
      locales = available_locales
      !(locales.nil? || locales.empty?)
    end

    def disable_caching
      # disable caching to reload translations dynamically:
      GetText::TextDomainManager.cached = false
    end

    def update_pofiles(files_to_translate)
      locale_dir = File.expand_path(File.join @base.base_dir, 'locale')
      FileUtils.mkdir_p locale_dir

      msgmerge = %w[--sort-output --no-location --no-wrap]
      GetText.update_pofiles(get_domain,
                             files_to_translate,
                             nil,
                             :po_root => locale_dir,
                             :msgmerge => msgmerge)
    end
  end

  Object.send(:include, GetText)
end
