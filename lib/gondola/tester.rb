# Gondola - tester.rb:
#   Module which contains all the necessary functions
#   for asserting and verifying various functions without
#   the need for a unit testing framework

module Gondola
  class AssertionError < RuntimeError
  end

  class Tester
    attr_reader :cmd_num, :errors, :job_id, :status
    attr_accessor :sel

    def initialize(req, converter)
      @sel = Gondola::Selenium.new req
      @converter = converter
      @cmd_num = 0
      @errors = []
    end

    # Start a new Sauce Labs' job and return the session_id
    def setup
      begin
        @sel.start()
        @job_id = @sel.session_id
        @status = :in_progress
      rescue ::Selenium::Client::CommandError => e
        @errors.push({ :command => @converter.commands[@cmd_num],
                       :error => e.message })
        finish
      end
      @job_id
    end

    # Issue all the test commands, catching any errors
    def begin
      begin
        eval(@converter.ruby)
      rescue AssertionError => e
      rescue ::Selenium::Client::CommandError => e
        @errors.push({ :command => @converter.commands[@cmd_num],
                       :error => e.message })
      ensure
        finish
      end
    end

    private

    # Shutdown the Sauce Labs' job and report the status
    # of the test
    def finish
      begin
        if @errors.empty?
          @status = :passed
          @sel.passed!
        else
          @status = :failed
          @sel.failed!
        end
        @sel.stop()
      rescue ::Selenium::Client::CommandError
      end
    end

    def cmd_inc
      @cmd_num+=1
    end

    def assert(expr)
      raise AssertionError, "Assertion Failed" unless verify(expr)
    end

    def assert_not(expr)
      raise AssertionError, "Assertion Failed" unless verify_not(expr)
    end

    def assert_equal(eq, expr)
      raise AssertionError, "Assertion Failed" unless verify_equal(eq, expr)
    end

    def assert_not_equal(eq, expr)
      raise AssertionError, "Assertion Failed" unless verify_not_equal(eq, expr)
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
