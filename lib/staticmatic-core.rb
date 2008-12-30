require 'rubygems'
require 'haml'
require 'sass'
require 'mongrel'

["mixins/render", "base", "configuration", "error", "server", "helpers"].each do |lib|
  require File.dirname(__FILE__) + "/staticmatic-core/" + lib
end

Haml::Helpers.class_eval("include StaticMatic::Helpers")

module Staticmatic
  VERSION = '0.9.5'
end