# Gondola - selenium.rb:
#   Subclass for overwriting some of the selenium
#   gem's default error reporting behaviors.
require 'sauce/selenium'

class Gondola
  class Selenium < ::Sauce::Selenium

    # Same function definition as the selenium gem but without
    # writing to standard out
    def http_post(data)
      start = Time.now
      called_from = caller.detect{|line| line !~ /(selenium-client|vendor|usr\/lib\/ruby|\(eval\))/i}
      http = Net::HTTP.new(@host, @port)
      http.open_timeout = default_timeout_in_seconds
      http.read_timeout = default_timeout_in_seconds
      response = http.post('/selenium-server/driver/', data, ::Selenium::Client::HTTP_HEADERS)
      [ response.body[0..1], response.body ]
    end
  end
end
