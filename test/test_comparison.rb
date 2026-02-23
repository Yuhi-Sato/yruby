require_relative 'test_helper'

class TestComparison < YRubyTestCase
  def test_opt_eq_true
    assert_equal true, exec("1 == 1")
  end

  def test_opt_eq_false
    assert_equal false, exec("1 == 2")
  end

  def test_opt_eq_in_condition
    assert_equal 1, exec("if 1 == 1; 1; else 2; end")
    assert_equal 2, exec("if 1 == 2; 1; else 2; end")
  end

  def test_opt_neq_true
    assert_equal true, exec("1 != 2")
  end

  def test_opt_neq_false
    assert_equal false, exec("1 != 1")
  end

  def test_opt_neq_in_condition
    assert_equal 1, exec("if 1 != 2; 1; else 2; end")
    assert_equal 2, exec("if 1 != 1; 1; else 2; end")
  end

  def test_opt_lt_true
    assert_equal true, exec("1 < 2")
  end

  def test_opt_lt_false
    assert_equal false, exec("2 < 1")
  end

  def test_opt_lt_in_condition
    assert_equal 1, exec("if 1 < 2; 1; else 2; end")
    assert_equal 2, exec("if 2 < 1; 1; else 2; end")
  end

  def test_opt_le_true
    assert_equal true, exec("1 <= 2")
    assert_equal true, exec("2 <= 2")
  end

  def test_opt_le_false
    assert_equal false, exec("3 <= 2")
  end

  def test_opt_le_in_condition
    assert_equal 1, exec("if 1 <= 2; 1; else 2; end")
    assert_equal 1, exec("if 2 <= 2; 1; else 2; end")
    assert_equal 2, exec("if 3 <= 2; 1; else 2; end")
  end

  def test_opt_gt_true
    assert_equal true, exec("2 > 1")
  end

  def test_opt_gt_false
    assert_equal false, exec("1 > 2")
  end

  def test_opt_gt_in_condition
    assert_equal 1, exec("if 2 > 1; 1; else 2; end")
    assert_equal 2, exec("if 1 > 2; 1; else 2; end")
  end

  def test_opt_ge_true
    assert_equal true, exec("2 >= 1")
    assert_equal true, exec("2 >= 2")
  end

  def test_opt_ge_false
    assert_equal false, exec("1 >= 2")
  end

  def test_opt_ge_in_condition
    assert_equal 1, exec("if 2 >= 1; 1; else 2; end")
    assert_equal 1, exec("if 2 >= 2; 1; else 2; end")
    assert_equal 2, exec("if 1 >= 2; 1; else 2; end")
  end

  def test_comparison_with_variables
    assert_equal 1, exec(<<~RUBY)
      a = 10
      b = 5
      if a > b
        1
      else
        2
      end
    RUBY
  end

end
