require 'rubygems'
require 'bundler'
require './lib/gondola/version'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "gondola"
  gem.homepage = "http://github.com/perrym5/gondola"
  gem.license = "MIT"
  gem.summary = %Q{Ruby command line utility and library for integrating the Selenium IDE more tightly with Sauce Labs' Ondemand services}
  gem.description = %Q{
    Gondola is Ruby command line utility and as well as a library  which helps
    for integrate the Selenium IDE more tightly with Sauce Labs' Ondemand services and
    provide greater ease for those who would like to use both tools but do not have
    enough technical knowledge
  }
  gem.email = "mperry@agoragames.com"
  gem.authors = ["Matthew Perry"]
  gem.version = Gondola::VERSION
  # Dependencies in GemFile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : Gondola::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gondola #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
