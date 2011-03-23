# Gondola - tester.rb:
#   Module which contains all the necessary functions
#   for asserting and verifying various functions without
#   the need for a unit testing framework

module Gondola
  class Tester
    attr_reader :cmd_num, :errors, :job_id
    attr_accessor :sel

    def initialize(sel, converter)
      @sel = sel
      @converter = converter
      @cmd_num = 0
      @errors = []
    end

    def begin
      begin
        @sel.start()
        @job_id = @sel.session_id
        eval(@converter.ruby)
      rescue RuntimeError => e
        $stderr.puts e.message
      ensure
        begin
          @sel.stop()
        rescue Selenium::Client::CommandError => e
          $stderr.puts e.message + "(Most likely, the test was closed on Sauce Labs' end)"
        end
      end
    end

    private

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
        @errors.push({ :command => @converter.commands[@cmd_num],
                       :error => "returned false, expecting true" })
        return false
      end
      return true
    end

    def verify_not(expr)
      if expr
        @errors.push({ :command => @converter.commands[@cmd_num],
                       :error => "returned true, expecting false" })
        return false
      end
      return true
    end

    def verify_equal(eq, expr)
      unless eq == expr
        @errors.push({ :command => @converter.commands[@cmd_num],
                       :error => "returned '#{expr}', expecting '#{eq}'" })
        return false
      end
      return true
    end

    def verify_not_equal(eq, expr)
      if eq == expr
        @errors.push({ :command => @converter.commands[@cmd_num],
                       :error => "returned '#{expr}', expecting anything but" })
        return false
      end
      return true
    end
  end
end
