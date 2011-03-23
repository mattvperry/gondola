# Gondola - html_converter.rb:
#   Class definition for turning Selenium HTML into
#   webdriver ruby code

module Gondola
  class HtmlConverter < Gondola::Converter
    # Function: name
    # Returns the name of this test case
    def name
      unless @name
        @name = @body.match(/<title>(.*)<\/title>/m)[1]
      end
      @name
    end

    # Function: ruby
    # This function parses the selenium
    # HTML file and sends commands to the
    # html_to_ruby helper function
    def ruby
      unless @ruby
        @ruby = ""
        # Get body of commands from flattened html
        cmd_body = @body.match(/<tbody>(.*)<\/tbody>/m)[1]

        # Define some patterns for the individual commands
        block_rxp = Regexp.new(/<tr>(.*?)<\/tr>/m)
        cmd_rxp = Regexp.new(/<td>(.*?)<\/td>\s*<td>(.*?)<\/td>\s*<td>(.*?)<\/td>/m)

        # Loop over all commands
        cmd_body.scan(block_rxp) do |cmd_block|
          cmd_block[0].scan(cmd_rxp) do |cmd|
            # Need to make sure arguements are represented
            # correctly
            if cmd[1] =~ /\$\{(.*)\}/
              cmd[1] = $1
            elsif cmd[1] != ""
              cmd[1] = cmd[1].inspect
            end
            if cmd[2] =~ /\$\{(.*)\}/
              cmd[2] = $1
            elsif cmd[2] != ""
              cmd[2] = cmd[2].inspect
            end

            # Append commands to a result string and to
            # the internal list of commands
            args = [ cmd[1], cmd[2] ]
            selenese = "#{cmd[0]}(#{cmd[1]}"
            selenese = selenese + ", #{cmd[2]}" if cmd[2] != ""
            selenese = selenese + ")"
            ruby = html_to_ruby(cmd[0], args)
            @commands.push({ :original => selenese, :ruby => ruby })
            @ruby << ruby
            @ruby << "\ncmd_inc\n"
          end
        end         
      end  
      @ruby
    end

    private
    # Function: html_to_ruby
    #   cmd - the name of the command
    #   args - array of arguements to cmd
    # This function turns a command that has been
    # extracted from a selenium HTML file into
    # one that can be used by the ruby-driver for
    # selenium
    def html_to_ruby(cmd, args)
      # Select over various command types
      case cmd
        # Assert command
      when /^(assert|verify)(.*)$/ then
        # Check to see if this is a negated assertion
        tester = $1
        string = $2
        if $1 =~ /(.*)Not(.*)$/
          string = $1 + $2
          tester = tester + "_not"
        end

        # Check the semantics of the command
        if semantic_is?(string)
          retval = "#{tester} #{@s_obj}.is_#{underscore(string)}"
          if args[0] != ""
            retval += "(#{args[0]}"
          end
          if args[1] != ""
            retval += ", #{args[1]}"
          end
          retval += ")"
        else
          var = args[0]
          extra = ''
          if args[1] != ""
            var = args[1]
            extra = "(#{args[0]})"
          end
          retval = "#{tester}_equal #{var}, #{@s_obj}.get_#{underscore(string)}" + extra
        end

        # All commands return arrays that need to be joined
        if string =~ /^All/
          retval += ".join(\",\")"
        end
        return retval

        # Wait For command
      when /^waitFor(.*)$/ then
        # Special case
        if $1 == "PageToLoad"
          return "#{@s_obj}.wait_for_page_to_load \"30000\""
        end
        # The expression that is checked against depends on whether
        # or not the command uses the "is" or the "get" semantic
        if semantic_is?($1)
          expression = "#{@s_obj}.is_#{underscore($1)}(#{args[0]}"
          if args[1] != ""
            expression += ", #{args[1]}"
          end
          expression += ")"
        else
          expression = "#{args[1]} == #{@s_obj}.get_#{underscore($1)}(#{args[1]})"
        end
        # The waitFor commands loop until something is satisfied
        return "assert !60.times{ break if(#{expression} rescue false); sleep 1 }"

        # AndWait command POSTFIX
      when /^(.*)AndWait$/ then
        # A command with a postfix of AndWait simply adds
        # a second command which waits a certain time
        firstPart = html_to_ruby($1, args)
        secondPart = "\n#{@s_obj}.wait_for_page_to_load \"30000\""
        return firstPart + secondPart

        # store command
      when /^store(.*)$/ then
        string = $1
        # Store by itself doesnt use any selenium functions
        # its the same as a regular assignment
        if $1 == ""
          # Arguements have quotes by default
          # they need to be stripped for LHS assignments
          args[1] = args[1].match(/"(.*)"/)[1]
          return "#{args[1]} = #{args[0]}"
        end

        # Otherwise, a store command takes the result of the
        # cmd and stores it somewhere
        var = args[0]
        extra = ""
        if args[1] != ""
          var = args[1]
          extra = "(#{args[0]})"
        end
        # Arguements have quotes by default
        # they need to be stripped for LHS assignments
        var = var.match(/"(.*)"/)[1]
        if semantic_is?(string)
          return "#{var} = #{@s_obj}.is_#{underscore(string)}" + extra
        else 
          return "#{var} = #{@s_obj}.get_#{underscore(string)}" + extra
        end

        # Pause is directly translated
      when /^pause$/ then
        convert = args[0].to_f * 0.001
        return "sleep #{convert}"

        # Default case
      else
        # Most commands just need to be converted to
        # underscore_case and have their arguements
        # appeneded
        cmd_new = underscore(cmd)
        add = ""
        if args[1] != ""
          add = ", #{args[1]}"
        end
        return "#{@s_obj}.#{cmd_new} #{args[0]}" + add
      end
    end

    # Function to turn CamelCase into underscore_case
    def underscore(str)
      str.gsub(/(.)([A-Z])/,'\1_\2').downcase
    end

    # Function to weed out 11 special functions that
    # use an "is" semantic
    def semantic_is?(str)
      case str
      when /Present$/
        return true
      when /Checked$/
        return true
      when /Editable$/
        return true
      when /Ordered$/
        return true
      when /Selected$/
        return true
      when /Visible$/
        return true
      else
        return false
      end
    end
  end
end
