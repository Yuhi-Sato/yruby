require 'minitest/autorun'
require_relative '../lib/yruby'

class YRubyTestCase < Minitest::Test
  def setup
    @parser = YRuby::Parser.new
    @vm = YRuby.new(@parser)
  end

  def exec(source)
    @vm.exec(source)
  end
end
