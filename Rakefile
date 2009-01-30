%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/staticmatic'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new('staticmatic', StaticMatic::VERSION) do |p|
  p.developer('Stephen Bartholomew', 'steve@curve21.com')
  p.summary = "Lightweight Static Site Framework"
  p.rubyforge_name       = p.name 
  p.extra_deps         = [
    ['haml','>= 2.0'],
    ['mongrel','>= 1.0']
  ]
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]
  
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'markdown')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }


desc "Run all unit tests"
Rake::TestTask.new(:test) do |t|
  t.test_files = Dir.glob("test/*_test.rb")
  t.verbose = true
end
