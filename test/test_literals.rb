require_relative 'test_helper'

class TestLiterals < YRubyTestCase
  def test_integer_zero
    assert_equal 0, exec("0")
  end

  def test_integer_positive
    assert_equal 42, exec("42")
  end

  def test_integer_negative
    assert_equal(-42, exec("-42"))
  end

  def test_integer_large
    assert_equal 1000000, exec("1000000")
  end

  def test_statements
    assert_equal 42, exec("42; 42; 42")
  end
end
