
module StaticMatic
  module Helpers
    module RenderHelper
      self.extend self
      
      # Include a partial template
      def partial(name, options = {})
        @staticmatic.generate_partial(name, options)
      end
    end
  end
end
