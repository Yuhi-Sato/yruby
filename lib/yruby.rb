# frozen_string_literal: true

require_relative 'yruby/core'
require_relative 'yruby/rclass'
require_relative 'yruby/robject'

class YRuby
  include InsnHelper
  include InsnHelper::Macros

  attr_reader :ec

  def initialize(parser)
    @parser = parser
  end

  def exec(source)
    init

    ast = @parser.parse(source)

    iseq = Iseq.iseq_new_main(ast)

    exec_core(iseq)
  end

  private

  def init
    stack = Array.new(STACK_SIZE)
    frames = []
    @ec = ExecutionContext.new(stack:, stack_size: STACK_SIZE, frames:)
    @top_self = RObject.new(RClass.new)
  end

  def exec_core(iseq)
    push_frame(iseq:, type: FRAME_TYPE_TOP, self_value: @top_self)

    catch(:finish) do
      loop do
        insn = cfp.iseq.fetch(cfp.pc)
        add_pc(1)
        insn.call(self)
      end
    end
  end
end
