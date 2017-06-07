require 'bundler'
require 'bundler/version'

require File.expand_path('lib/emaildirect/version')

Gem::Specification.new do |s|
  s.name = "emaildirect"
  s.author = "Jason Rust"
  s.description = %q{Implements the complete functionality of the email direct REST API.}
  s.email = ["rustyparts@gmail.com"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.files = `git ls-files`.split("\n")
  s.homepage = "http://github.com/LessonPlanet/emaildirect-ruby"
  s.require_paths = ["lib"]
  s.summary = %q{A library which implements the complete functionality of of the emaildirect REST API (v5).}
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = EmailDirect::VERSION
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=

  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'hashie', '>= 3.0.0'
  s.add_runtime_dependency 'httparty'
end
