require 'helper'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = "test/fixtures/vcr_cassettes"
  c.stub_with :fakeweb
end

class TestFail < Test::Unit::TestCase
  context "A Ruby Failing Test" do
    setup do
      @runner = Gondola::SuiteRunner.new
      @runner.add_test "test/test_projects/example2/gondola_agora_fail.rb"
    end

    should "result in a failing test" do
      VCR.use_cassette('failing_test1', :record => :new_episodes) do
        @runner.run({ :browsers => [{:os => "Windows 2003", :browser => "firefox", :browser_version => "3.6"}] })
      end
      expected = [{
        :cmd_num=>12,
        :command=>{
          :ruby=>"assert @sel.is_text_present(\"Producer FAIL\")\n"
        }, 
        :error=>"returned false, expecting true"
      }]
      assert @runner.results.size == 1
      assert_equal expected, @runner.results[0][:errors]
    end
  end

  context "An HTML Failing Test" do
    setup do
      @runner = Gondola::SuiteRunner.new
      @runner.add_test "test/test_projects/example1/gondola_agora_fail.html"
    end

    should "result in a failing test" do
      VCR.use_cassette('failing_test2', :record => :new_episodes) do
        @runner.run({ :browsers => [{:os => "Windows 2003", :browser => "firefox", :browser_version => "3.6"}] })
      end
      expected = [{
        :cmd_num=>11,
        :command=>{
          :selenese=>"assertTextPresent(\"Producer FAIL\")", 
          :ruby=>"assert @sel.is_text_present(\"Producer FAIL\")"
        }, 
        :error=>"returned false, expecting true"
      }]
      assert @runner.results.size == 1
      assert_equal expected, @runner.results[0][:errors]
    end
  end
end
