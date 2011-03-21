# Gondola - converter.rb:
#   Class definition for turning one format into
#   another

module Gondola
  class Converter
    attr_writer :name
    attr_reader :file

    # Constructor that opens a file
    def initialize(filename, sel="@sel")
      File.open(filename, "r") do |f|
        @body = f.read
      end
      @s_obj = sel
      @file = filename
      ruby()
    end

    def name
      unless @name
        @name = @file
      end
      @name
    end

    # Function: ruby
    # This function parses the given file
    # and returns valid selenium ruby code
    def ruby
      unless @ruby
        @ruby = @body.gsub(/.*/, "\\&\ncmd_inc\n")
      end  
      @ruby
    end
  end
end
