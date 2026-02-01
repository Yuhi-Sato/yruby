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

  def test_local_variable_assignment
    assert_equal 10, @vm.run("a = 10")
  end

  def test_local_variable_read
    assert_equal 10, @vm.run("a = 10; a")
  end

  def test_local_variable_with_expression
    assert_equal 15, @vm.run("a = 10; a + 5")
  end

  def test_multiple_local_variables
    assert_equal 30, @vm.run("a = 10; b = 20; a + b")
  end

  def test_equal
    assert_equal true, @vm.run("1 == 1")
    assert_equal false, @vm.run("1 == 2")
  end

  def test_not_equal
    assert_equal true, @vm.run("1 != 2")
    assert_equal false, @vm.run("1 != 1")
  end

  def test_less_than
    assert_equal true, @vm.run("1 < 2")
    assert_equal false, @vm.run("2 < 1")
  end

  def test_greater_than
    assert_equal true, @vm.run("2 > 1")
    assert_equal false, @vm.run("1 > 2")
  end

  def test_less_than_or_equal
    assert_equal true, @vm.run("1 <= 2")
    assert_equal true, @vm.run("1 <= 1")
    assert_equal false, @vm.run("2 <= 1")
  end

  def test_greater_than_or_equal
    assert_equal true, @vm.run("2 >= 1")
    assert_equal true, @vm.run("1 >= 1")
    assert_equal false, @vm.run("1 >= 2")
  end

  def test_if_true
    assert_equal 10, @vm.run("if 1 == 1; 10; end")
  end

  def test_if_false
    assert_nil @vm.run("if 1 == 2; 10; end")
  end

  def test_if_with_variable
    assert_equal 20, @vm.run("a = 5; if a == 5; 20; end")
  end

  def test_if_without_else_returns_nil_when_condition_is_false
    assert_nil @vm.run("if 1 > 2; 100; end")
  end

  def test_if_else_true_branch
    assert_equal 10, @vm.run("if 1 == 1; 10; else; 20; end")
  end

  def test_if_else_false_branch
    assert_equal 20, @vm.run("if 1 == 2; 10; else; 20; end")
  end

  def test_if_else_with_variable
    assert_equal 99, @vm.run("a = 3; if a > 5; 1; else; 99; end")
  end

  def test_string_literal
    assert_equal "hello", @vm.run('"hello"')
  end

  def test_puts_string
    assert_output("hello\n") { @vm.run('puts("hello")') }
  end

  def test_puts_integer
    assert_output("123\n") { @vm.run('puts(123)') }
  end

  def test_puts_returns_nil
    assert_nil @vm.run('puts("hello")')
  end

  def test_puts_variable
    assert_output("42\n") { @vm.run('a = 42; puts(a)') }
  end

  def test_times_with_puts
    assert_output("0\n1\n2\n") { @vm.run('3.times { |i| puts(i) }') }
  end

  def test_times_returns_receiver
    assert_equal 3, @vm.run('3.times { |i| i }')
  end

  def test_times_zero
    assert_equal 0, @vm.run('0.times { |i| i }')
  end
end
