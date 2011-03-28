# Gondola - converter.rb:
#   Class definition for turning one format into
#   another

module Gondola
  class Converter
    attr_writer :name
    attr_reader :file, :commands

    # Constructor that opens a file
    def initialize(filename, sel="@sel")
      File.open(filename, "r") do |f|
        @body = f.read
      end
      @commands = []
      @s_obj = sel
      @file = filename
      ruby()
    end

    def name
      unless @name
        @name = File.basename(@file, ".rb")
      end
      @name
    end

    # Function: ruby
    # This function parses the given file
    # and returns valid selenium ruby code
    def ruby
      unless @ruby
        @ruby = ""
        @body.each_line do |l|
          @commands.push({ :ruby => l })
          @ruby << l
        end
      end  
      @ruby
    end
  end
end
