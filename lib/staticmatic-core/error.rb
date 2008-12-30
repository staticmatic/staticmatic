module StaticMatic
  class Error < StandardError
    attr_reader :line

    attr_reader :filename
    
    def initialize(lineno, filename, message)
      @line = lineno
      @filename = filename
      @message = message
    end
    
    def message
      "#{@filename}, line #{@line}: #{@message}"
    end
  end
end