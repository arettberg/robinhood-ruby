
# frozen_string_literal: true
# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "robinhood-ruby/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.name          = "robinhood-ruby"
  spec.version       = Robinhood::VERSION
  spec.authors       = ["Leonard Bogdonoff"]
  spec.email         = ["rememberlenny@gmail.com"]

  spec.summary       = "A simple library for communicating with the Robinhood API"
  spec.description   = "A simple library for communicating with the Robinhood API"
  spec.homepage      = "https://github.com/rememberlenny/robinhood-ruby"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("multi_json", ">= 1.3.0")
  spec.add_dependency("builder", ">= 2.1.2")
  spec.add_dependency("jwt", ">= 1.0")
  spec.add_dependency("rack")
  spec.add_dependency("httparty")
  spec.add_dependency("jruby-openssl") if RUBY_PLATFORM == "java"
  # Workaround for RBX <= 2.2.1, should be fixed in next version
  spec.add_dependency("rubysl") if defined?(RUBY_ENGINE) && RUBY_ENGINE == "rbx"

  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "fakeweb", ["~> 1.3"]
end
