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
  attr_reader :runner

  def initialize
    @runner = Gondola::SuiteRunner.new
    yield @runner if block_given?
  end
end
