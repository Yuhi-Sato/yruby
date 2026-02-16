# frozen_string_literal: true

require 'forwardable'

class YRuby
  module InsnHelper
    extend Forwardable

    def_delegators :ec, :cfp, :cfp=, :stack, :stack=, :frames

    module Macros
      # Value Stack
      def push(x)
        set_sv(x)
        inc_sp(1)
      end

      def topn(x)
        stack[cfp.sp - x]
      end

      def pop
        cfp.sp -= 1
        val = stack[cfp.sp]
        stack[cfp.sp] = nil
        val
      end

      # PC
      def add_pc(x)
        cfp.pc += x
      end

      def set_pc(x)
        cfp.pc = x
      end

      # environment pointer
      def get_ep
        cfp.ep
      end

      # SP
      def set_sv(x)
        stack[cfp.sp] = x
      end

      def inc_sp(x)
        cfp.sp += x
      end
    end

    # Control Frame
    def push_frame(iseq:)
      sp = iseq.local_table.size
      ep = sp - 1

      cf = ControlFrame.new(iseq:, pc: 0, sp:, ep:, type: nil, self_value: nil)
      frames.push(cf)
      self.cfp = cf
    end

    def pop_frame
      frames.pop
      self.cfp = frames.last
    end

    def env_read(index)
      stack[get_ep + index]
    end

    def env_write(index, value)
      stack[get_ep + index] = value
    end
  end
end
