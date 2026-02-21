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
    assert_equal 42, exec(<<~RUBY)
      42
      42
      42
    RUBY
  end

  def test_nil
    assert_nil exec("nil")
  end

  def test_nil_statements
    assert_nil exec(<<~RUBY)
      nil
      42
      nil
    RUBY
  end

  def test_true
    assert_equal true, exec("true")
  end

  def test_true_statements
    assert_equal true, exec(<<~RUBY)
      true
      42
      true
    RUBY
  end

  def test_false
    assert_equal false, exec("false")
  end

  def test_false_statements
    assert_equal false, exec(<<~RUBY)
      false
      42
      false
    RUBY
  end
end
