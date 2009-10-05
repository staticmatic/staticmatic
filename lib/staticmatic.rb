require 'rubygems'
require 'haml'
require 'sass'
require 'sass/plugin'
require 'mongrel'
require 'fileutils'

module StaticMatic
  VERSION = '0.10.2'
end

["render", "build", "setup", "server", "helpers", "rescue"].each do |mixin|
  require File.join(File.dirname(__FILE__), "staticmatic", "mixins", mixin)
end

["base", "configuration", "error", "server", "helpers", "template_error"].each do |lib|
  require File.join(File.dirname(__FILE__), "staticmatic", lib)
end

Haml::Helpers.class_eval("include StaticMatic::Helpers")

