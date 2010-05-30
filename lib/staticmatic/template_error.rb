class StaticMatic::TemplateError < StandardError
  SOURCE_CODE_RADIUS = 3
  
  attr_reader :original_exception, :backtrace

  def initialize(template, original_exception)
    @template, @original_exception = template, original_exception
    @backtrace = original_exception.backtrace
    
    if template
      @source = File.read(template)
    else 
      @source = ""
    end
  end
  
  # TODO: Replace 'haml|sass' with any registered engines
  def line_number
    @line_number ||= $2 if backtrace.find { |line| line =~ /\((haml|sass|scss)\)\:(\d+)/ }
  end
  
  def filename
    @template
  end
  
  def source_extract(indentation = 0)
    return "" unless num = line_number
    num = num.to_i

    source_code = @source.split("\n")

    start_on_line = [ num - SOURCE_CODE_RADIUS - 1, 0 ].max
    end_on_line   = [ num + SOURCE_CODE_RADIUS - 1, source_code.length].min

    indent = ' ' * indentation
    line_counter = start_on_line
    return unless source_code = source_code[start_on_line..end_on_line]

    source_code.collect do |line|
      line_counter += 1
      "#{indent}#{line_counter}: #{line}\n"
    end.to_s
  end
end