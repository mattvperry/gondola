# Gondola - console.rb
#   Definitions of functions for printing
#   results to the console in a readable format

class Gondola
  module Results
    class Console
      def self.change(result)
        browser_string = result[:browser].values.join(" ")
        print "#{result[:id]}: \"#{result[:name]}\" "

        case result[:status]
        when :in_progress
          puts "started with #{browser_string}"
        when :not_started
          puts "failed to start on #{browser_string}"
        when :passed, :failed
          puts "has completed with #{result[:errors].size} error(s) on #{browser_string}"
        else
          puts "Unknown status code"
        end
      end

      def self.completion(results)
        puts
        results.each do |result|
          puts "Sauce Labs ID : #{result[:id]}"
          puts "Test Name     : #{result[:name]}"
          puts "Browser       : #{result[:browser].values.join(" ")}"
          puts "Status        : Test #{result[:status].to_s.capitalize} - #{result[:errors].size} error(s)"
          if result[:status] == :failed
            result[:errors].each_with_index do |error,i|
              puts "- Error #{i+1}, Command number #{error[:cmd_num]}:"

              max_key = -1 * (error[:command].keys.map { |k| k.to_s.size }.max + 8)
              error[:command].each_pair do |k,v| 
                puts "    %1$*2$s : #{v}" % [ "#{k.to_s.capitalize} command", max_key ]
              end

              puts "    #{error[:error]}"
            end
          else
            puts
          end
          puts
        end
      end

      def self.error(error)
        puts error
      end
    end
  end
end
