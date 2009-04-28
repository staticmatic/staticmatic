require "rubygems"
require "rake"
require "rake/testtask"
require File.dirname(__FILE__) + '/lib/staticmatic'

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
    
    gem.files =  FileList["[A-Z]*", "{bin,lib,test}/**/*"]
    
    gem.add_dependency("haml", ">=2.0.0")
    gem.add_dependency("mongrel", ">=1.1.5")
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gemgem.github.com"
end

desc "Run all unit tests"
Rake::TestTask.new(:test) do |t|
  t.test_files = Dir.glob("test/*_test.rb")
  t.verbose = true
end
