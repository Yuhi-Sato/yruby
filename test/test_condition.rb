require_relative 'test_helper'

class TestCondition < YRubyTestCase
  # === if (true/false literals) ===

  def test_if_true
    assert_equal 1, exec("if true; 1; end")
  end

  def test_if_false
    assert_nil exec("if false; 1; end")
  end

  def test_if_nil
    assert_nil exec("if nil; 1; end")
  end

  # === if-else ===

  def test_if_true_with_else
    assert_equal 1, exec("if true; 1; else; 2; end")
  end

  def test_if_false_with_else
    assert_equal 2, exec("if false; 1; else; 2; end")
  end

  def test_if_nil_with_else
    assert_equal 2, exec("if nil; 1; else; 2; end")
  end

  # === multiple statements in then/else ===

  def test_if_true_multiple_statements_in_then
    assert_equal 3, exec("if true; 1; 2; 3; end")
  end

  def test_if_false_multiple_statements_in_else
    assert_equal 6, exec("if false; 1; 2; 3; else; 4; 5; 6; end")
  end

  # === literal values as condition ===

  def test_if_integer_is_truthy
    assert_equal 1, exec("if 42; 1; else; 2; end")
  end

  def test_if_zero_is_truthy
    assert_equal 1, exec("if 0; 1; else; 2; end")
  end

  # === variable as condition ===

  def test_if_variable_true
    assert_equal 10, exec("a = true; if a; 10; else; 20; end")
  end

  def test_if_variable_false
    assert_equal 20, exec("a = false; if a; 10; else; 20; end")
  end

  def test_if_variable_nil
    assert_equal 20, exec("a = nil; if a; 10; else; 20; end")
  end

  def test_if_variable_integer
    assert_equal 10, exec("a = 1; if a; 10; else; 20; end")
  end

  # === expression as condition ===

  def test_if_expression_truthy
    assert_equal 1, exec("a = 3; b = 2; if a - b; 1; else; 2; end")
  end

  # === assign if result to a variable ===

  def test_assign_if_result_true
    assert_equal 10, exec("x = if true; 10; else; 20; end; x")
  end

  def test_assign_if_result_false
    assert_equal 20, exec("x = if false; 10; else; 20; end; x")
  end

  # === use if result in arithmetic ===

  def test_if_result_in_arithmetic
    assert_equal 11, exec("a = if true; 10; else; 20; end; a + 1")
  end

  # === nested if ===

  def test_nested_if_in_then
    assert_equal 1, exec("if true; if true; 1; else; 2; end; else; 3; end")
  end

  def test_nested_if_in_then_inner_false
    assert_equal 2, exec("if true; if false; 1; else; 2; end; else; 3; end")
  end

  def test_nested_if_in_else
    assert_equal 4, exec("if false; 1; else; if true; 4; else; 5; end; end")
  end

  def test_nested_if_in_else_inner_false
    assert_equal 5, exec("if false; 1; else; if false; 4; else; 5; end; end")
  end

  # === statements following if ===

  def test_statement_after_if_true
    assert_equal 99, exec("if true; 1; end; 99")
  end

  def test_statement_after_if_false
    assert_equal 99, exec("if false; 1; end; 99")
  end

  def test_variable_after_if
    assert_equal 42, exec("a = if true; 10; else; 20; end; b = 32; a + b")
  end

  # === local variable operations inside if ===

  def test_assign_in_then_branch
    assert_equal 5, exec("a = 0; if true; a = 5; end; a")
  end

  def test_assign_in_else_branch
    assert_equal 10, exec("a = 0; if false; a = 5; else; a = 10; end; a")
  end

  def test_arithmetic_in_then_branch
    assert_equal 3, exec("a = 1; b = 2; if true; a + b; else; 0; end")
  end

  def test_arithmetic_in_else_branch
    assert_equal 0, exec("a = 1; b = 2; if false; a + b; else; 0; end")
  end

  # === elsif ===

  def test_elsif_first_branch
    assert_equal 1, exec("if true; 1; elsif true; 2; else; 3; end")
  end

  def test_elsif_second_branch
    assert_equal 2, exec("if false; 1; elsif true; 2; else; 3; end")
  end

  def test_elsif_else_branch
    assert_equal 3, exec("if false; 1; elsif false; 2; else; 3; end")
  end

  def test_elsif_without_else
    assert_equal 2, exec("if false; 1; elsif true; 2; end")
  end

  def test_elsif_without_else_all_false
    assert_nil exec("if false; 1; elsif false; 2; end")
  end

  def test_multiple_elsif_first
    assert_equal 1, exec("if true; 1; elsif true; 2; elsif true; 3; else; 4; end")
  end

  def test_multiple_elsif_second
    assert_equal 2, exec("if false; 1; elsif true; 2; elsif true; 3; else; 4; end")
  end

  def test_multiple_elsif_third
    assert_equal 3, exec("if false; 1; elsif false; 2; elsif true; 3; else; 4; end")
  end

  def test_multiple_elsif_else
    assert_equal 4, exec("if false; 1; elsif false; 2; elsif false; 3; else; 4; end")
  end

  def test_elsif_with_variable_condition
    assert_equal 20, exec("a = false; b = true; if a; 10; elsif b; 20; else; 30; end")
  end

  def test_elsif_with_expression_condition
    assert_equal 1, exec("a = 1; b = 1; if a - b; 1; elsif a; 2; else; 3; end")
  end

  def test_elsif_with_falsy_expression_condition
    assert_equal 2, exec("a = nil; b = 1; if a; 1; elsif b; 2; else; 3; end")
  end

  def test_elsif_result_assigned_to_variable
    assert_equal 2, exec("x = if false; 1; elsif true; 2; else; 3; end; x")
  end

  def test_elsif_assign_in_branch
    assert_equal 20, exec("a = 0; if false; a = 10; elsif true; a = 20; else; a = 30; end; a")
  end
end
