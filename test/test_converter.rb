require 'helper'

class TestConverter < Test::Unit::TestCase
  context "A Ruby Converter" do
    setup do
      @converter = Gondola::Converter.new("test/test_projects/example2/gondola_agora_pass.rb")  
    end

    should "properly convert a ruby file to a gondola ruby file" do
      expected = %q{ @sel.open "/"
        @sel.wait_for_page_to_load "30000"
        @sel.type "q", "agora games"
        @sel.click "btnG"
        @sel.click "link=Careers"
        @sel.wait_for_page_to_load "30000"
        verify_equal "Agora Games", @sel.get_title
        verify @sel.is_text_present("At Agora")
        assert @sel.is_text_present("Platform Engineer")
        @sel.click "link=Application Engineer"
        assert @sel.is_text_present("Application Engineer")
        @sel.click "link=Producer"
        assert @sel.is_text_present("Producer")
        @sel.click "link=work at Agora."
        @sel.wait_for_page_to_load "30000"
        @sel.click "link=Fun at Agora"
        @sel.click "link=Hack-a-thon"
        @sel.click "link=Our Town"
        @sel.click "link=Communication at Agora"
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
        @sel.wait_for_page_to_load "30000"
        @sel.type "q", "agora games"
        @sel.click "btnG"
        @sel.click "link=Careers"; @sel.wait_for_page_to_load "30000"
        verify_equal "Agora Games", @sel.get_title
        verify @sel.is_text_present("At Agora")
        assert @sel.is_text_present("Platform Engineer")
        @sel.click "link=Application Engineer"
        assert @sel.is_text_present("Application Engineer")
        @sel.click "link=Producer"
        assert @sel.is_text_present("Producer")
        @sel.click "link=work at Agora."; @sel.wait_for_page_to_load "30000"
        @sel.click "link=Fun at Agora"
        @sel.click "link=Hack-a-thon"
        @sel.click "link=Our Town"
        @sel.click "link=Communication at Agora"
      }.lines.map { |l| l.strip! }.join("\n")
      assert_equal expected, @converter.ruby
      assert_equal 17, @converter.commands.size
    end

    should "properly extract the name of the test from the given file" do
      assert_equal "gondola_agora_pass", @converter.name
    end
  end
end
