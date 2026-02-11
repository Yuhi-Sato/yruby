require_relative 'test_helper'

class TestLocalVariables < YRubyTestCase
  def test_assignment_returns_value
    assert_equal 1, exec("a = 1")
  end

  def test_multiple_assignments
    assert_equal 3, exec("a = 1; b = 2; c = 3")
  end

  def test_read_after_assignment
    assert_equal 42, exec("a = 42; a")
  end

  def test_multiple_variables
    assert_equal 3, exec("a = 1; b = 2; a + b")
  end

  def test_assignment_with_expression
    assert_equal 3, exec("a = 1 + 2; a")
  end

  def test_reassignment
    assert_equal 10, exec("a = 5; a = 10; a")
  end

  def test_variable_used_in_assignment
    assert_equal 2, exec("a = 1; a = a + 1; a")
  end

  def test_swap_values
    assert_equal 1, exec("a = 1; b = 2; c = a; a = b; b = c; b")
  end

  def test_assignment_nil
    assert_nil exec("a = nil; a")
  end

  def test_assignment_true
    assert_equal true, exec("a = true; a")
  end

  def test_assignment_false
    assert_equal false, exec("a = false; a")
  end

  def test_arithmetic_with_variables
    assert_equal 10, exec("a = 3; b = 7; a + b")
  end

  def test_subtraction_with_variables
    assert_equal 4, exec("a = 10; b = 6; a - b")
  end

  def test_chained_arithmetic_with_variables
    assert_equal 6, exec("a = 1; b = 2; c = 3; a + b + c")
  end
end
