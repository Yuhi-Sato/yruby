require_relative 'test_helper'

class TestArithmetic < YRubyTestCase
  def test_addition
    assert_equal 3, exec("1 + 2")
  end

  def test_addition_with_zero
    assert_equal 5, exec("5 + 0")
  end

  def test_addition_negative
    assert_equal(-1, exec("1 + -2"))
  end

  def test_subtraction
    assert_equal 1, exec("3 - 2")
  end

  def test_subtraction_with_zero
    assert_equal 5, exec("5 - 0")
  end

  def test_subtraction_negative_result
    assert_equal(-1, exec("2 - 3"))
  end

  def test_subtraction_from_zero
    assert_equal(-5, exec("0 - 5"))
  end

  def test_subtraction_negative_numbers
    assert_equal 5, exec("3 - -2")
  end

  def test_subtraction_chained
    assert_equal 5, exec("10 - 3 - 2")
  end
end
