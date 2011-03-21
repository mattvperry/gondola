# Gondola

Gondola is a ruby gem which aims to bridge the gap between two very prominent, open source, quality assurance tools, Selenium IDE and Sauce Labs.
Many quality assurance professionals who don't have the necessary technical skills to write Selenium webdriver-based unit tests prefer to do their
web regression testing using solely the Selenium IDE and then exporting those test cases by some means to Sauce Labs' system.

Gondola offers an easier and more convenient system for dispatching tests written in Selenium IDE to a Sauce Labs account. Gondola transforms the html
that Selenium IDE produces by default and ships it to Sauce Labs across a number of browsers in parallel. Test suites and projects can be easily organized
with simple file directory structures.

Beyond the console application that comes with the gem, Gondola offers a small API for integrating Gondola's features into custom web apps. This allows
a user to bring Gondola's simplicity into an existing testing suite or a new web application. Specifically, we have a plan to write a sample Gondola web
app to demonstrate its power.  

## Installation

    $ gem install gondola

NOTE: You may run into problems if rubygems' executable path is not in your `$PATH` environment variable. See rubygems' documentation
for more details.

## Usage

Gondola offers a simplistic command line application for quickly debugging tests written in the Selenium IDE. Gondola also offers a short and sweet API for
integrating Gondola's features into any other application.

NOTE: Make sure that you configure your Sauce Labs username and access key by doing one of two things:

* Issue a command to the Sauce Labs gem:

    sauce configure [username] [access-key]

* or create an ondemand.yml file in the directory structure of your tests:

    code

before using Gondola in any capacity.

### Getting started

    $ gondola help

Will get you started with the basic commands available. The most used and main function of gondola is the `run` command.

    $ gondola run [options] [tests]

The available `[options]` are:

* `-s` or `--super_parallel`: This activates "super\_parallel" mode which will not only execute all browsers in parallel but also all the
  test cases. This mode is experimental and may slow down Sauce Labs considerably. Use at your own risk.
* `-r` or `--recursive`: This activates recursive search mode. When you supply Gondola with a directory containing tests, using this option will
  enable sub directory searching.

The `[tests]` attribute refers to a list of test cases or test suites:

* Test cases can either be in HTML format (Selenium IDE saves) or in ruby format which is just a bunch of commands that you would like to execute. 
  * NOTE: The ruby test case feature is under construction and should not be used at the moment.
* Test suites are directories that contain many test cases.

### Integrating with an existing product

    require 'rubygems'
    require 'gondola'

    browsers = [
        {:os => "Windows 2003", :browser => "firefox", :browser_version => "3.6"},
        {:os => "Windows 2003", :browser => "iexplore", :browser_version => "8" },
    ]

    runner = Gondola::TestRunner.new
    runner.add_test "example.html"
    runner.run({:base_url => "http://www.google.com", :browsers => browsers})

The above code does several things:

* `runner.add_test "example.html"` adds the test case "example.html" to the list of tests that this runner will execute when you tell it to
* `runner.run(opts={})` runs all the tests that you've added with the options specified. The list of available options is long and a work in progress
  with the rest of the documentation.

The end result here is that the test case that you have written with Selenium IDE, "example.html", is converted to ruby on the fly and then sent
to Sauce Labs with two browser settings in parallel.

## Contributing to gondola
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Agora Games. See LICENSE.txt for
further details.

