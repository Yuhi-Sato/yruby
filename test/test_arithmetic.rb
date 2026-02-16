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

  def test_multiplication
    assert_equal 6, exec("2 * 3")
  end

  def test_multiplication_with_zero
    assert_equal 0, exec("5 * 0")
  end

  def test_multiplication_with_one
    assert_equal 7, exec("7 * 1")
  end

  def test_multiplication_negative
    assert_equal(-6, exec("2 * -3"))
  end

  def test_multiplication_chained
    assert_equal 24, exec("2 * 3 * 4")
  end

  def test_division
    assert_equal 3, exec("6 / 2")
  end

  def test_division_with_one
    assert_equal 5, exec("5 / 1")
  end

  def test_division_integer_truncation
    assert_equal 3, exec("10 / 3")
  end

  def test_division_negative
    assert_equal(-2, exec("6 / -3"))
  end

  def test_division_chained
    assert_equal 5, exec("100 / 4 / 5")
  end
end
