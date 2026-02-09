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
end
