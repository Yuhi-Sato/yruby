# frozen_string_literal: true

require_relative 'yruby/core'

class YRuby
  include InsnHelper

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
    @ec = ExecutionContext.new(stack:, stack_size: STACK_SIZE, cfp: STACK_SIZE)
    push_frame
  end

  def exec_core(iseq)
    self.iseq = iseq

    catch(:finish) do
      loop do
        insn = iseq.fetch(pc)
        add_pc(1)
        insn.call(self)
      end
    end
  end
end
