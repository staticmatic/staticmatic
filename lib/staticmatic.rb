# HACK
require File.join(File.dirname(__FILE__), "staticmatic", "backward_compatibility")

require 'rubygems'
require 'compass'
require 'haml'
require 'sass'
require 'sass/plugin'
require 'rack'
require 'rack/handler/webrick'
require 'cgi'
require 'fileutils'
require 'gettext'
require 'gettext/tools'
require 'gettext/tools/rgettext'
require 'gettext/tools/parser/ruby'

load 'staticmatic/version.rb'

["render", "build", "setup", "server", "helpers", "sitemap", "rescue", "updatepo"].each do |mixin|
  require File.join(File.dirname(__FILE__), "staticmatic", "mixins", mixin)
end

["base", "configuration", "error", "server", "helpers", "template_error", "compass", "translation"].each do |lib|
  require File.join(File.dirname(__FILE__), "staticmatic", lib)
end

Haml::Helpers.class_eval("include StaticMatic::Helpers")
