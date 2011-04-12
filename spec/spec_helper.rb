require 'rubygems'
require 'stringio'
require 'spec'

require 'lib/staticmatic'

unless defined? TEST_SITE_PATH
  TEST_SITE_PATH = File.expand_path(File.join(File.dirname(__FILE__), "sandbox", "test_site"))
end

Spec::Runner.configure do |config|
end

def setup_staticmatic
  @staticmatic = StaticMatic::Base.new(TEST_SITE_PATH)
end

# Supresses STDOUT use by methods, to avoid polluting the tests. Returns a
# StringIO object containing the data received during the block execution.
def supress_stdout
  mock_io = StringIO.new
  stdout_real, $stdout = $stdout, mock_io
  if block_given?
    begin
      yield
    ensure
      $stdout = stdout_real
    end
  end
  mock_io
end
