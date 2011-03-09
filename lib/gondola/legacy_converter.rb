# Gondola - legacy_converter.rb
#   Class definition for turning old selenium-test
#   files into new ruby code for gondola
require 'rubygems'
require 'gondola'

module Gondola
  class LegacyConverter < Converter
    # Function: name
    # Returns the name of this test case
    def name
      unless @name
        @name = @body.match(/class(.*?)</m)[1].strip
      end
      @name
    end

    # Function: ruby
    # This function parses the given legacy
    # test case file and parses it into the
    # new streamlined form
    def ruby
      unless @ruby
        @ruby = ""

        # Only search through relevent portions
        cmd_body = @body.match(/def test_case.*end/m)
        # Define a pattern for commands
        cmd_rxp = Regexp.new(/^.*?@selenium.*?$/)

        # Loop over all lines
        cmd_body[0].scan(cmd_rxp) do |cmd|
          @ruby << cmd.strip.sub(/@selenium/, "@sel")
          @ruby << "\ncmd_inc\n"
        end
      end
      @ruby
    end
  end
end

