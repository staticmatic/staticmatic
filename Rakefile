require "rubygems"
require 'spec/rake/spectask'

require File.expand_path("../lib/staticmatic", __FILE__)

task :default => [:spec]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "staticmatic"
    gem.summary = "Lightweight static site framework"
    gem.description = "StaticMatic is a lightweight framework for building easy to maintain static sites"
    gem.rubyforge_project = "staticmatic"
    gem.authors = ["Stephen Bartholomew"]
    gem.email = "steve@curve21.com"
    gem.homepage = "http://staticmatic.net"

    gem.files.include "{bin,lib}/**/*"
    gem.files.exclude "spec/*", "website/*"
    gem.executables = "staticmatic"

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
