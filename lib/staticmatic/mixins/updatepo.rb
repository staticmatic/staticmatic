module StaticMatic::UpdatepoMixin
  def updatepo
    files_to_translate = Dir[File.join(@src_dir, "{pages,layouts,partials}", "**/*.haml")]
    translation.update_pofiles(files_to_translate)
  end

  private
  # Haml gettext module providing gettext translation for all Haml plain text
  # calls. Modified from:
  # http://www.nanoant.com/programming/haml-gettext-automagic-translation

  module HamlParser
    module HamlEnginePatch
      # Overriden function that parses Haml tags
      def parse_tag(line)
        tag_name, attributes, attributes_hash, object_ref, nuke_outer_whitespace,
        nuke_inner_whitespace, action, value = super(line)

        unless value.empty?
          if action
            add_script_to_parseable_text(value)
          else
            add_text_to_staticmatic_translation(value)
          end
        end

        [tag_name, attributes, attributes_hash, object_ref, nuke_outer_whitespace,
         nuke_inner_whitespace, action, value]
      end

      # Overriden function that producted Haml plain text
      def plain(text)
        add_text_to_staticmatic_translation(text)
        super(text)
      end

      # Injects _ gettext call for translatable text
      def get_staticmatic_translation_code
        (@staticmatic_translation or []).collect do |text|
          "_(\"#{text}\")"
        end + (@staticmatic_parseable_text or []) +
          self.precompiled.split(/$/)
      end

      def script(text, escape_html = nil, preserve = false)
        script_node = super(text, escape_html = nil, preserve = false)
        add_script_to_parseable_text(script_node.value[:text])
        return script_node
      end

      private
      def add_text_to_staticmatic_translation(text)
        @staticmatic_translation ||= []
        @staticmatic_translation << text
      end

      def add_script_to_parseable_text(text)
        @staticmatic_parseable_text ||= []
        @staticmatic_parseable_text << text
      end
    end

    Haml::Engine.send(:include, HamlEnginePatch)

    module_function

    def target?(file)
      File.extname(file).to_s.downcase == ".haml"
    end

    def parse(file, ary = [])
      haml = Haml::Engine.new(IO.readlines(file).join)
      code = haml.get_staticmatic_translation_code
      GetText::RubyParser.parse_lines(file, code, ary)
    end

    GetText::RGetText.add_parser(HamlParser)
  end
end
