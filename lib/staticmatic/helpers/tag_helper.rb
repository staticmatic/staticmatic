module StaticMatic
  module Helpers
    module TagHelper
      self.extend self
      
      # Generates HTML tags:
      #
      # tag(:br)   ->   <br/>
      # tag(:a, :href => 'test.html') { "Test" }    ->    <a href="test.html">Test</a>
      #
      def tag(name, options = {}, &block)
        options[:id] ||= options[:name] if options[:name]
        output = "<#{name}"
        options.keys.sort { |a, b| a.to_s <=> b.to_s }.each do |key|
          output << " #{key}=\"#{options[key]}\"" if options[key]
        end
        
        if block_given?
          output << ">"
          output << yield
          output << "</#{name}>"
        else
          format = @staticmatic.configuration.haml_options[:format]
          
          if format.nil? || format == :xhtml
            output << "/>"
          else
            output << ">"
          end
        end
        output
      end
    end
  end
end
