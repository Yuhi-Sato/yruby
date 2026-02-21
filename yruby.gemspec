# frozen_string_literal: true

require_relative "lib/yruby/version"

Gem::Specification.new do |spec|
  spec.name = "yruby"
  spec.version = YRuby::VERSION
  spec.authors = ["Yuhi-Sato"]
  spec.summary = "Yet Another Ruby VM - a YARV-based Ruby virtual machine implementation"
  spec.description = "YRuby is a Ruby virtual machine implementation based on CRuby's YARV (Yet Another Ruby VM) architecture. It parses Ruby source code with the Prism gem and executes it through a stack-based bytecode interpreter."
  spec.homepage = "https://github.com/Yuhi-Sato/yruby"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 3.3.0"

  spec.files = Dir["lib/**/*", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "prism", "~> 1.0"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
