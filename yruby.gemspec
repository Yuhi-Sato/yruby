# frozen_string_literal: true

require_relative "lib/yruby/version"

Gem::Specification.new do |spec|
  spec.name = "yruby"
  spec.version = YRuby::VERSION
  spec.authors = ["Yuhi-Sato"]
  spec.summary = "Yet Another Ruby VM - YARV ベースの Ruby 仮想マシン実装"
  spec.description = "YRuby は CRuby の YARV (Yet Another Ruby VM) アーキテクチャに基づく Ruby 仮想マシン実装です。Prism gem で Ruby ソースコードをパースし、スタックベースのバイトコードインタプリタで実行します。"
  spec.homepage = "https://github.com/Yuhi-Sato/yruby"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 3.0.0"

  spec.files = Dir["lib/**/*", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "prism", "~> 0.19"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
