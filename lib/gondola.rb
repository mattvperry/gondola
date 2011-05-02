# Gondola - gondola.rb
#   Main include file as well as the top level
#   class definition for gondola

require 'rubygems'
require 'gondola/selenium'
require 'gondola/converters'
require 'gondola/commands'
require 'gondola/results'
require 'gondola/tester'
require 'gondola/suiterunner'
require 'gondola/version'
require 'sauce'
require 'parallel'

class Gondola

  DEFAULT_CONFIG = {
    :project_name => "New Project",
    :base_url => "http://www.google.com/",
    :browsers => [
      {:os => "Windows 2003", :browser => "firefox", :browser_version => "3.6"},
      {:os => "Windows 2003", :browser => "iexplore", :browser_version => "8" },
    ]
  }

  attr_reader :runner

  def initialize
    @runner = Gondola::SuiteRunner.new
    yield @runner if block_given?
  end
end
