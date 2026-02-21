require_relative 'test_helper'

class TestMethodDefinition < YRubyTestCase
  def test_define_and_call_with_two_args
    assert_equal 3, exec("def add(a, b); a + b; end; add(1, 2)")
  end

  def test_define_and_call_with_one_arg
    assert_equal 42, exec("def double(x); x + x; end; double(21)")
  end

  def test_define_and_call_with_no_args
    assert_equal 1, exec("def one; 1; end; one")
  end

  def test_method_returns_last_expression
    assert_equal 10, exec("def ten; 5 + 5; end; ten")
  end

  def test_multiple_definitions_and_calls
    assert_equal 7, exec("def add(a, b); a + b; end; def sub(a, b); a - b; end; add(5, 2)")
    assert_equal 3, exec("def add(a, b); a + b; end; def sub(a, b); a - b; end; sub(5, 2)")
  end

  def test_same_method_called_twice
    assert_equal 3, exec("def add(a, b); a + b; end; add(1, 2)")
    assert_equal 7, exec("def add(a, b); a + b; end; add(3, 4)")
  end

  def test_method_definition_returns_method_name_as_symbol
    # return value of def add(a,b); end is :add (pushed via Putobject)
    assert_equal :add, exec("def add(a, b); a + b; end")
  end

  def test_method_using_parameters_in_expression
    assert_equal 6, exec("def mul(a, b); a + a + b + b; end; mul(1, 2)")
  end

  def test_method_with_local_variable
    assert_equal 30, exec("def foo(a, b); c = a + b; c + c; end; foo(10, 5)")
  end
end
