# Gondola - tester.rb:
#   Module which contains all the necessary functions
#   for asserting and verifying various functions without
#   the need for a unit testing framework

module Gondola
  class AssertionError < RuntimeError
  end

  class Tester
    attr_reader :errors, :job_id, :status

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
        @status = :not_started
        add_error e.message
        finish
      end
      @job_id
    end

    # Issue all the test commands, catching any errors
    def begin
      begin
        eval(@converter.ruby)
      rescue AssertionError
      rescue ::Selenium::Client::CommandError => e
        add_error e.message
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

    def get_eval_cmd_num
      ev = caller.keep_if { |c| c =~ /\(eval\)/ }[0]
      ev.match(/:(\d+)/)[1].to_i - 1
    end

    # Add the current command to the error list
    # with the given description
    def add_error(desc)
      cmd_num = get_eval_cmd_num
      @errors.push({ 
        :cmd_num => cmd_num,
        :command => @converter.commands[cmd_num],
        :error => desc 
      })
    end

    # Handle all the assert functions by just making the respective
    # verify call and throwing an exception to end the flow
    def method_missing(method, *args)
      if method.to_s =~ /^assert(.*)/
        raise AssertionError unless send "verify#{$1}".to_sym, *args
      end
    end

    def verify(expr)
      add_error "ERROR: Command returned false, expecting true" unless expr
      return expr
    end

    def verify_not(expr)
      add_error "ERROR: Command returned true, expecting false" if expr
      return !expr
    end

    def verify_equal(eq, expr)
      add_error "ERROR: Command returned '#{expr}', expecting '#{eq}'" unless eq == expr
      return eq == expr
    end

    def verify_not_equal(eq, expr)
      add_error "ERROR: Command returned '#{expr}', expecting anything but" unless eq != expr
      return eq != expr
    end
  end
end
