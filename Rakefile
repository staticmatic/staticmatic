require "rubygems"
require 'spec/rake/spectask'

require File.expand_path("../lib/staticmatic", __FILE__)

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "staticmatic"
    gem.executables = "staticmatic"
    gem.summary = "Lightweight Static Site Framework"
    gem.email = "steve@curve21.com"
    gem.homepage = "http://staticmatic.net"
    gem.description = "Lightweight Static Site Framework"
    gem.authors = ["Stephen Bartholomew"]
    gem.rubyforge_project = "staticmatic"
    
    gem.files =  FileList["[A-Z]*", "{bin,lib,spec}/**/*"]
    
    gem.add_dependency("haml", ">=2.0.0")
    gem.add_dependency("rack", ">=1.0")
    gem.add_dependency("compass", ">=0.10.0")
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  # spec.spec_opts = ['--options', 'spec/spec.opts']
end
