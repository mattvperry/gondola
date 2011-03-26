require 'helper'

class TestConverter < Test::Unit::TestCase
  context "A Ruby Converter" do
    setup do
      @converter = Gondola::Converter.new("test/test_projects/example2/gondola_agora_pass.rb")  
    end

    should "properly convert a ruby file to a gondola ruby file" do
      expected = %q{ @sel.open "/"
        cmd_inc
        @sel.wait_for_page_to_load "30000"
        cmd_inc
        @sel.type "q", "agora games"
        cmd_inc
        @sel.click "btnG"
        cmd_inc
        @sel.click "link=Careers"
        cmd_inc
        @sel.wait_for_page_to_load "30000"
        cmd_inc
        verify_equal "Agora Games", @sel.get_title
        cmd_inc
        verify @sel.is_text_present("At Agora")
        cmd_inc
        assert @sel.is_text_present("Platform Engineer")
        cmd_inc
        @sel.click "link=Application Engineer"
        cmd_inc
        assert @sel.is_text_present("Application Engineer")
        cmd_inc
        @sel.click "link=Producer"
        cmd_inc
        assert @sel.is_text_present("Producer")
        cmd_inc
        @sel.click "link=work at Agora."
        cmd_inc
        @sel.wait_for_page_to_load "30000"
        cmd_inc
        @sel.click "link=Fun at Agora"
        cmd_inc
        @sel.click "link=Hack-a-thon"
        cmd_inc
        @sel.click "link=Our Town"
        cmd_inc
        @sel.click "link=Communication at Agora"
        cmd_inc
      }.lines.map { |l| l.strip! }.join("\n")
      assert_equal expected, @converter.ruby
      assert_equal 19, @converter.commands.size
    end

    should "properly extract the name of the test from the given file" do
      assert_equal "gondola_agora_pass", @converter.name
    end
  end

  context "An HTML Converter" do
    setup do
      @converter = Gondola::HtmlConverter.new("test/test_projects/example1/gondola_agora_pass.html")
    end

    should "properly convert a selenese HTML file to a gondola ruby file" do
      expected = %q{ @sel.open "/"
        cmd_inc
        @sel.wait_for_page_to_load "30000"
        cmd_inc
        @sel.type "q", "agora games"
        cmd_inc
        @sel.click "btnG"
        cmd_inc
        @sel.click "link=Careers"
        @sel.wait_for_page_to_load "30000"
        cmd_inc
        verify_equal "Agora Games", @sel.get_title
        cmd_inc
        verify @sel.is_text_present("At Agora")
        cmd_inc
        assert @sel.is_text_present("Platform Engineer")
        cmd_inc
        @sel.click "link=Application Engineer"
        cmd_inc
        assert @sel.is_text_present("Application Engineer")
        cmd_inc
        @sel.click "link=Producer"
        cmd_inc
        assert @sel.is_text_present("Producer")
        cmd_inc
        @sel.click "link=work at Agora."
        @sel.wait_for_page_to_load "30000"
        cmd_inc
        @sel.click "link=Fun at Agora"
        cmd_inc
        @sel.click "link=Hack-a-thon"
        cmd_inc
        @sel.click "link=Our Town"
        cmd_inc
        @sel.click "link=Communication at Agora"
        cmd_inc
      }.lines.map { |l| l.strip! }.join("\n")
      assert_equal expected, @converter.ruby
      assert_equal 17, @converter.commands.size
    end

    should "properly extract the name of the test from the given file" do
      assert_equal "gondola_agora_pass", @converter.name
    end
  end
end
