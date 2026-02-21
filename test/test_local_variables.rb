require_relative 'test_helper'

class TestLocalVariables < YRubyTestCase
  def test_assignment_returns_value
    assert_equal 1, exec("a = 1")
  end

  def test_multiple_assignments
    assert_equal 3, exec(<<~RUBY)
      a = 1
      b = 2
      c = 3
    RUBY
  end

  def test_read_after_assignment
    assert_equal 42, exec(<<~RUBY)
      a = 42
      a
    RUBY
  end

  def test_multiple_variables
    assert_equal 3, exec(<<~RUBY)
      a = 1
      b = 2
      a + b
    RUBY
  end

  def test_assignment_with_expression
    assert_equal 3, exec(<<~RUBY)
      a = 1 + 2
      a
    RUBY
  end

  def test_reassignment
    assert_equal 10, exec(<<~RUBY)
      a = 5
      a = 10
      a
    RUBY
  end

  def test_variable_used_in_assignment
    assert_equal 2, exec(<<~RUBY)
      a = 1
      a = a + 1
      a
    RUBY
  end

  def test_swap_values
    assert_equal 1, exec(<<~RUBY)
      a = 1
      b = 2
      c = a
      a = b
      b = c
      b
    RUBY
  end

  def test_assignment_nil
    assert_nil exec(<<~RUBY)
      a = nil
      a
    RUBY
  end

  def test_assignment_true
    assert_equal true, exec(<<~RUBY)
      a = true
      a
    RUBY
  end

  def test_assignment_false
    assert_equal false, exec(<<~RUBY)
      a = false
      a
    RUBY
  end

  def test_arithmetic_with_variables
    assert_equal 10, exec(<<~RUBY)
      a = 3
      b = 7
      a + b
    RUBY
  end

  def test_subtraction_with_variables
    assert_equal 4, exec(<<~RUBY)
      a = 10
      b = 6
      a - b
    RUBY
  end

  def test_chained_arithmetic_with_variables
    assert_equal 6, exec(<<~RUBY)
      a = 1
      b = 2
      c = 3
      a + b + c
    RUBY
  end
end
