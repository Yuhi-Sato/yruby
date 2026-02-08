# frozen_string_literal: true

require 'forwardable'

class YRuby
  module InsnHelper
    extend Forwardable

    def push(x)
      set_sv(x)
      inc_sp(1)
    end

    def topn(x)
      stack[sp - x]
    end

    def pop
      stack[sp] = nil
      self.sp = sp - 1
    end

    def push_frame
      cf = ControlFrame.new(iseq: nil, pc: 0, sp: 0, ep: 0, type: nil, self_value: nil)
      self.cfp = cfp - 1
      stack[cfp] = cf
    end

    def pop_frame
      stack[cfp] = nil
      self.cfp = cfp + 1
    end

    def_delegators :@ec, :cfp, :cfp=, :stack, :stack=

    def current_cf
      stack[cfp]
    end

    def_delegators :current_cf, :iseq, :iseq=, :pc, :pc=, :sp, :sp=

    # PC
    def add_pc(x)
      self.pc += x
    end

    # SP
    def set_sv(x)
      stack[sp] = x
    end

    def inc_sp(x)
      self.sp += x
    end
  end
end
