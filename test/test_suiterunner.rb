require 'helper'

class MockSuiteRunner < Gondola::SuiteRunner
  attr_accessor :files_ran

  def initialize
    super
    @files_ran = []
  end

  def run_test(converter, global, browser)
    @files_ran.push converter.file
    return [converter, global, browser]
  end
end

class SuiteRunner < Test::Unit::TestCase
  context "Recursive projects" do
    setup do
      @runner = MockSuiteRunner.new
      @runner.add_tests "test/test_projects/"
      @runner.run :recursive => true
    end

    should "run all of the relevant files" do
      expected = []
      Dir.chdir("test/test_projects/") do
        expected = Dir.glob("**/*.html")
        expected.concat(Dir.glob("**/*.rb"))
      end
      assert_equal expected, @runner.files_ran
    end
  end

  context "Configs" do
    setup do
      @runner = MockSuiteRunner.new
      @runner.add_tests "test/test_projects/"
    end

    should "extract data from config files and merge correctly" do
      file_conf = @runner.send :config_from_file, "test/test_projects/example1/gondola_agora_pass.html"
      expected = {
        :browsers=>[
          {:os=>"Windows 2003", :browser=>"firefox", :browser_version=>"3.6"}, 
          {:os=>"Windows 2003", :browser=>"iexplore", :browser_version=>"8"}
        ], 
        :project_name=>"Test Project", 
        :base_url=>"http://www.google.com"
      }
      assert_equal expected, file_conf      

      file_conf = @runner.send :config_from_file, "test/test_projects/example2/gondola_agora_fail.html"
      assert_equal expected, file_conf      
    end

    should "aggregate data correctly from files, options and globally" do
      c,g,b = @runner.send :aggregate_data, "test/test_projects/example1/gondola_agora_pass.html", {}
      expected_g = {:job_name=>"Test Project - gondola_agora_pass", :browser_url=>"http://www.google.com"}
      expected_b = [
        {:os=>"Windows 2003", :browser=>"firefox", :browser_version=>"3.6"},
        {:os=>"Windows 2003", :browser=>"iexplore", :browser_version=>"8"}
      ]
      assert_equal expected_g, g
      assert_equal expected_b, b
    end
  end
end
