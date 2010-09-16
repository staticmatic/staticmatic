module StaticMatic
  module Helpers
    module CurrentPathHelper
      self.extend self
      
      def current_page
        @staticmatic.current_page
      end

      private

      def current_page_relative_path(current_path = nil)
        if current_path.nil? || current_path.match(/^((\.\.?)?\/|\#|.+?\:)/) == nil
          current_page_depth = current_page.split('/').length - 2;
          (current_page_depth > 0) ? ([ '..' ] * current_page_depth).join('/') + '/' : ''
        else
          ''
        end
      end
    end
  end
end
