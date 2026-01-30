require_relative 'lib/yruby/parser'
require_relative 'lib/yruby/compiler'
require_relative 'lib/yruby'

debug = ARGV.delete("--disasm")

file_path = ARGV[0]
abort "Usage: ruby main.rb [--disasm] <file>" unless file_path

parser = YRuby::Parser.new
compiler = YRuby::Compiler.new
vm = MinRuby.new(parser, compiler, debug: debug)

source = File.read(file_path)
result = vm.run(source)
puts "=> #{result.inspect}"
