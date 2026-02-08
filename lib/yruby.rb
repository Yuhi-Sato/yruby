# frozen_string_literal: true

require_relative 'core'

class YRuby
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
end
