# Gondola v2 - testrunner.rb:
#   A wrapper for all the tasks required for launching a run
#   of a test suite or test case on several browsers

require 'rubygems'
require 'gondola'

module Gondola
  class TestRunner
    attr_accessor :tests

    def initialize
      @tests = []
    end

    def add_test(file)
      @tests.push(file)
    end

    def run(opts = {})
      if @tests.empty?
        puts "No tests to run"
      end
      if opts[:super_parallel] == true
        puts "Work in progress, please run again without the super parallel flag"
      else
        @tests.each do |test|
          if File.directory? test
            Dir.chdir(test)
            prepend = ""
            if opts[:recursive] == true
              prepend = "**/"
            end
            files = Dir.glob(prepend + "*.html")
            files.concat(Dir.glob(prepend + "*.rb"))
            files.each do |file|
              conf = configure(File.expand_path(File.dirname(file)))
              run_test(file, conf)
            end
          else
            conf = configure(File.expand_path(File.dirname(test)))
            run_test(test, conf)
          end
        end
      end
    end

    private
    # Function to configure sauce labs' gem with proper api information
    # as well as populate the configuration for the specific test being run
    def configure(file)
      # Load possible paths for the api information (Sauce already does this to some extent
      # but more paths were required for this gem)
      conf = {}
      apiPaths = [
        File.expand_path(File.join(file, "ondemand.yml")),
        File.expand_path(File.join(file, "../ondemand.yml")),
      ]
      apiPaths.each do |path|
        if File.exists?(path)
          conf = YAML.load_file(path)
          break
        end
      end          

      # Load possible paths for the configuration information
      configPaths = [
        File.expand_path(File.join(file, "../config.yml")),
        File.expand_path(File.join(file, "config.yml")),
      ]
      configPaths.each do |path|
        if File.exists?(path)
          conf.merge! YAML.load_file(path)
        end
      end          
      conf = conf.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      conf[:browsers].map! do |browser|
        browser.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      end
      return conf
    end

    # Function to run and parallelize the given test on the given browsers
    def run_test(file, conf)
      # Initialize a converter object based on filetype
      converter = nil
      if File.extname(file) == '.html'
        converter = Gondola::HtmlConverter.new(file)
      elsif File.extname(file) == '.rb'
        converter = Gondola::LegacyConverter.new(file)
      end
      # Set global information
      global = {}
      global[:job_name] = converter.name
      if conf[:project_name]
        global[:job_name] = "#{conf[:project_name]} - #{global[:job_name]}"
      end
      global[:browser_url] = conf[:base_url]
      # Spawn n threads
      Parallel.map(conf[:browsers], :in_threads => conf[:browsers].size)do |browser|
        # Add global information to this configuration
        browser.merge! global
        # Request a new selenium object from Sauce
        selenium = Sauce::Selenium.new(browser)
        # Begin test using a tester object
        tester = Gondola::Tester.new(selenium, converter)
        browser_string = "#{browser[:os]} #{browser[:browser]} #{browser[:browser_version]}"
        puts "Starting test case \"#{file}\" with: #{browser_string}"
        tester.begin
        puts "#{file} finished - Sauce Job ID: #{tester.job_id}"
      end
      puts
    end
  end
end
