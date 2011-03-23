# Gondola - tester.rb:
#   Module which contains all the necessary functions
#   for asserting and verifying various functions without
#   the need for a unit testing framework

module Gondola
  class Tester
    attr_reader :cmd_num, :sel, :converter, :job_id

    def initialize(sel, converter)
      @sel = sel
      @converter = converter
      @cmd_num = 1
    end

    def begin
      @sel.start()
      @job_id = @sel.session_id
      begin
        eval(@converter.ruby)
      rescue => e
        $stderr.puts e.message + " - stopping test."
      rescue Selenium::Client::CommandError
      ensure
        @sel.stop()
      end
    end

    def cmd_inc
      @cmd_num+=1
    end

    def assert(expr)
      unless verify(expr)
        raise "Assertion Failed"
      end
    end

    def assert_not(expr)
      unless verify_not(expr)
        raise "Assertion Failed"
      end
    end

    def assert_equal(eq, expr)
      unless verify_equal(eq, expr)
        raise "Assertion Failed"
      end
    end

    def assert_not_equal(eq, expr)
      unless verify_not_equal(eq, expr)
        raise "Assertion Failed"
      end
    end

    def verify(expr)
      unless expr
        $stderr.puts "Command #{@cmd_num} returned false, expecting true"
        return false
      end
      return true
    end

    def verify_not(expr)
      if expr
        $stderr.puts "Command #{@cmd_num} returned true, expecting false"
        return false
      end
      return true
    end

    def verify_equal(eq, expr)
      unless eq == expr
        @stderr.puts "Command #{@cmd_num} returned '#{expr}', expecting '#{eq}'"
        return false
      end
      return true
    end

    def verify_not_equal(eq, expr)
      if eq == expr
        @stderr.puts "Command #{@cmd_num} returned '#{expr}', expecting '#{eq}'"
        return false
      end
      return true
    end
  end
end
