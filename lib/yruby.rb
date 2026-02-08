# frozen_string_literal: true

require 'forwardable'

require_relative 'yruby/core'

class YRuby
  extend Forwardable

  def initialize(parser)
    @parser = parser
  end

  def exec(source)
    init

    ast = @parser.parse(source)

    iseq = Iseq.iseq_new_main(@ec, ast)

    # TODO: Execute Iseq

    # TODO: Return the result of the execution
  end

  def push(x)
    set_sv(x)
    inc_sp(1)
  end

  private

  def init
    stack = Array.new(STACK_SIZE)
    @ec = ExecutionContext.new(stack:, stack_size: STACK_SIZE, cfp: STACK_SIZE)
    push_frame(@ec)
  end

  def push_frame(ec)
    cf = ControlFrame.new(iseq: nil, pc: 0, sp: 0, ep: 0, type: nil, self_value: nil)
    ec.cfp = ec.cfp - 1
    ec.stack[ec.cfp] = cf
  end

  def_delegators :@ec, :cfp, :stack

  def current_cf
    stack[cfp]
  end

  def_delegators :current_cf, :sp

  def set_sv(x)
    stack[sp] = x
  end

  def inc_sp(x)
    sp += x
  end
end
