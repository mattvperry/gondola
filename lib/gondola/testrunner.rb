# Gondola v2 - testrunner.rb:
#   A wrapper for all the tasks required for launching a run
#   of a test suite or test case on several browsers

module Gondola
  class TestRunner
    attr_reader :tests

    def initialize
      @tests = []
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
      # TODO: Need to implement a super-parallel ability( dangerous )
      if opts[:super_parallel] == true
        puts "Work in progress, please run again without the super parallel flag"
      else
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
    def config_from_file(file, api=true, data=true)
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
        if data
          if File.exists? "config.yml"
            conf.merge! YAML.load_file("config.yml")
            data = false
          end
        end
      end
      # Recurse through the parent directories and merge the
      # current configuration
      unless file == File.dirname(file)
        return config_from_file(File.expand_path(File.dirname(file)), api, data).merge(conf)
      end
      return conf
    end

    # Function to run and parallelize the given test on the given browsers
    def run_test(converter, global, browsers)
      # Spawn n threads
      Parallel.map(browsers, :in_threads => browsers.size) do |request|
        # Add global information to this request
        request.merge! global
        # Request a new selenium object from Sauce
        selenium = Sauce::Selenium.new(request)
        # Begin test using a tester object
        tester = Gondola::Tester.new(selenium, converter)
        browser_string = "#{request[:os]} #{request[:browser]} #{request[:browser_version]}"
        puts "Starting test case \"#{converter.name}\" with: #{browser_string}"
        tester.begin
        puts "#{converter.name} finished - Sauce Job ID: #{tester.job_id}"
      end
      puts
    end
  end
end
