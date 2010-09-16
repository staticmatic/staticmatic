
module StaticMatic
  module Helpers
    module FormHelper
      self.extend self

      # Generates a form text field
      #
      def text_field(name, value, options = {})
        options.merge!(:type => "text", :name => name, :value => value)
        tag(:input, options)
      end
        
        
      # Generate a form textarea
      #
      def text_area(name, value, options = {})
        options.merge!(:name => name)
        tag(:textarea, options) { value }
      end
    end
  end
end
