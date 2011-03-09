# Gondola - converter.rb:
#   Class definition for turning one format into
#   another

module Gondola
  class Converter
    # Constructor that opens a file
    def initialize(filename, sel="@sel")
      File.open(filename, "r") do |f|
        @body = f.read
      end
      @s_obj = sel
      ruby()
    end

    # Function: name
    # Returns the name of this test case
    def name
      unless @name
        @name = "Abstract Converter"
      end
      @name
    end

    # Function: ruby
    # This function parses the given file
    # and returns valid selenium ruby code
    def ruby
      unless @ruby
        @ruby = "puts 'This is an abstract converter, do not use this.'"
      end  
      @ruby
    end
  end
end
