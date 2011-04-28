# Gondola - tasks.rb:
#   Some Rake Tasks to run suites of tests
#   from Ruby's Rake system

class Gondola
  class Tasks < ::Rake::TestLib
    def initialize(&setup_block)
    end

    private

    def define_tasks
    end
  end
end
