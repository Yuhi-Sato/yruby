require_relative 'test_helper'

class TestLocalVariables < YRubyTestCase
  def test_assignment_returns_value
    assert_equal 1, exec("a = 1")
  end

  def test_multiple_assignments
    assert_equal 3, exec("a = 1; b = 2; c = 3")
  end
end
