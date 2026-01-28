require 'minitest/autorun'
require_relative '../lib/yruby/parser'
require_relative '../lib/yruby/compiler'
require_relative '../lib/yruby'

class YRubyTest < Minitest::Test
  def setup
    @parser = YRuby::Parser.new
    @compiler = YRuby::Compiler.new
    @vm = MinRuby.new(@parser, @compiler)
  end

  def test_integer_literal
    assert_equal 42, @vm.run("42")
  end

  def test_addition
    assert_equal 3, @vm.run("1 + 2")
  end

  def test_subtraction
    assert_equal 5, @vm.run("10 - 5")
  end

  def test_multiplication
    assert_equal 12, @vm.run("3 * 4")
  end

  def test_complex_expression
    assert_equal 14, @vm.run("2 + 3 * 4")
  end

  def test_left_associative_addition
    assert_equal 6, @vm.run("1 + 2 + 3")
  end

  def test_mixed_operations
    assert_equal 11, @vm.run("1 + 2 * 5")
  end

  def test_multiple_statements
    assert_equal 30, @vm.run("10; 20; 30")
  end

  def test_multiple_statements_with_expressions
    assert_equal 7, @vm.run("1 + 2; 3 + 4")
  end
end
