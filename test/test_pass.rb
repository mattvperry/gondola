require 'helper'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = "test/fixtures/vcr_cassettes"
  c.stub_with :fakeweb
end

class TestPass < Test::Unit::TestCase
  context "A Ruby Passing Test" do
    setup do
      @runner = Gondola::SuiteRunner.new
      @runner.add_test "test/test_projects/example2/gondola_agora_pass.rb"
    end

    should "result in a passing test" do
      VCR.use_cassette('passing_test1', :record => :new_episodes) do
        @runner.run({ :browsers => [{:os => "Windows 2003", :browser => "firefox", :browser_version => "3.6"}] })
        assert @runner.results.size == 1
        assert_equal :passed, @runner.results[0][:status]
      end
    end
  end

  context "An HTML Passing Test" do
    setup do
      @runner = Gondola::SuiteRunner.new
      @runner.add_test "test/test_projects/example1/gondola_agora_pass.html"
    end

    should "result in a passing test" do
      VCR.use_cassette('passing_test2', :record => :new_episodes) do
        @runner.run({ :browsers => [{:os => "Windows 2003", :browser => "firefox", :browser_version => "3.6"}] })
        assert @runner.results.size == 1
        assert_equal :passed, @runner.results[0][:status]
      end
    end
  end
end
