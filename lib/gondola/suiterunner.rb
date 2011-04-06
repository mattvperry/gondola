# Gondola v2 - suiterunner.rb:
#   A wrapper for all the tasks required for launching a run
#   of a test suite or test case on several browsers
require 'observer'

module Gondola
  class SuiteRunner
    include Observable
    attr_reader :tests, :results

    def initialize
      @tests = []
      @results = []
    end

    # Function to add a test to the member array of
    # tests for this test run
    def add_test(file)
      @tests.push(file)
    end

    # Function to run all tests that have been added
    #   - opts: hash which can be used to override the
    #           configuration from yml files
    def run(opts = {})
      # Cannot run tests if there are none
      if @tests.empty?
        puts "No tests to run"
      end

      # Iterate over all tests and dispatch each to Sauce Labs
      @tests.each do |test|
        if File.directory? test
          Dir.chdir(test) do
            prepend = ""
            if opts[:recursive] == true
              prepend = "**/"
            end
            files = Dir.glob(prepend + "*.html")
            files.concat(Dir.glob(prepend + "*.rb"))
            files.each do |file|
              converter,global,browsers = aggregate_data(file, opts)
              run_test(converter, global, browsers)
            end
          end
        else
          file = File.basename(test)
          Dir.chdir(File.dirname(test)) do
              converter,global,browsers = aggregate_data(file, opts)
              run_test(converter, global, browsers)
          end
        end
      end
    end

    private
    # Function to collect configuration data from various
    # sources so that the test can run properly
    def aggregate_data(file, opts)
      # Initialize a converter object based on filetype
      converter = nil
      if File.extname(file) == '.html'
        converter = Gondola::HtmlConverter.new(file)
      elsif File.extname(file) == '.rb'
        converter = Gondola::Converter.new(file)
      end

      # Load file config data
      conf = config_from_file(file)
      # Merge in user-supplied data
      conf.merge! opts

      # Set global information
      global = {}
      global[:job_name] = converter.name
      if conf[:project_name]
        global[:job_name] = "#{conf[:project_name]} - #{global[:job_name]}"
      end
      global.merge! conf.reject { |k,v| !([:username, :access_key].include?(k)) }
      global[:browser_url] = conf[:base_url]

      return [converter, global, conf[:browsers]]
    end

    # Function to read any config files which contain data for this
    # test case or suite
    def config_from_file(file, api=true)
      # If the given test is just a file then start your search in
      # its parent directory
      unless File.directory? file
        return config_from_file(File.expand_path(File.dirname(file)))
      end

      # Load any config files in the current directory only if
      # a config hasn't already been found
      conf = {}
      Dir.chdir(file) do
        if api
          if File.exists? "ondemand.yml"
            conf.merge! YAML.load_file("ondemand.yml")
            api = false
          end
        end
        if File.exists? "config.yml"
          conf.merge! YAML.load_file("config.yml")
          data = false
        end
      end

      # Recurse through the parent directories and merge the
      # current configuration
      unless file == File.dirname(file)
        return config_from_file(File.expand_path(File.dirname(file)), api).merge(conf)
      end
      return conf
    end

    # Function to run and parallelize the given test on the given browsers
    def run_test(converter, global, browsers)
      # Spawn n threads
      Parallel.map(browsers, :in_threads => browsers.size) do |browser|
        # Add global information to this request
        request = browser.merge global
        # Initialize the tester object with a request and a converter
        tester = Gondola::Tester.new(request, converter)

        # Initialize test
        tester.setup
        changed   # Notify Observers
        result = { 
          :id => tester.job_id,
          :name => global[:job_name], 
          :browser => browser,
          :status => tester.status, 
          :errors => tester.errors
        }
        # Send information to any observers
        notify_observers(result)

        # Run test
        tester.begin if result[:errors].empty?
        changed   # Notify Observers
        result[:status] = tester.status
        # Record the results of the test
        result[:errors] = tester.errors
        # Send information to any observers
        notify_observers(result)

        # Add result to the suiterunner's list
        @results.push result
      end
    end
  end
end
