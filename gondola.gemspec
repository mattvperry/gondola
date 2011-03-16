# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gondola}
  s.version = "1.1.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Perry"]
  s.date = %q{2011-03-16}
  s.default_executable = %q{gondola}
  s.description = %q{
    Gondola is Ruby command line utility and as well as a library  which helps
    for integrate the Selenium IDE more tightly with Sauce Labs' Ondemand services and
    provide greater ease for those who would like to use both tools but do not have
    enough technical knowledge
  }
  s.email = %q{mperry@agoragames.com}
  s.executables = ["gondola"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.markdown"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.markdown",
    "Rakefile",
    "bin/gondola",
    "examples/config.yml",
    "examples/gondola_agora_fail.html",
    "examples/gondola_agora_pass.html",
    "gondola.gemspec",
    "lib/gondola.rb",
    "lib/gondola/converter.rb",
    "lib/gondola/html_converter.rb",
    "lib/gondola/legacy_converter.rb",
    "lib/gondola/tester.rb",
    "lib/gondola/testrunner.rb",
    "lib/gondola/version.rb",
    "test/helper.rb",
    "test/test_gondola.rb"
  ]
  s.homepage = %q{http://github.com/perrym5/gondola}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{Ruby command line utility and library for integrating the Selenium IDE more tightly with Sauce Labs' Ondemand services}
  s.test_files = [
    "test/helper.rb",
    "test/test_gondola.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sauce>, [">= 0.17.5"])
      s.add_runtime_dependency(%q<parallel>, [">= 0.5.2"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
    else
      s.add_dependency(%q<sauce>, [">= 0.17.5"])
      s.add_dependency(%q<parallel>, [">= 0.5.2"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    end
  else
    s.add_dependency(%q<sauce>, [">= 0.17.5"])
    s.add_dependency(%q<parallel>, [">= 0.5.2"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
  end
end

