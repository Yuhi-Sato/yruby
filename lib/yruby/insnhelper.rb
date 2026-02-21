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
    def push_frame(iseq:, type: FRAME_TYPE_TOP, self_value: nil, sp:)
      sp = sp + iseq.local_table_size
      ep = sp - 1

      cf = ControlFrame.new(iseq:, pc: 0, sp:, ep:, type:, self_value:)
      frames.push(cf)
      self.cfp = cf
    end

    def pop_frame
      frames.pop
      self.cfp = frames.last
    end

    # Environment Pointer
    def env_read(index)
      stack[get_ep + index]
    end

    def env_write(index, value)
      stack[get_ep + index] = value
    end

    def define_method(mid, iseq)
      klass = cfp.self_value.klass

      klass.add_method_iseq(mid, iseq)
    end

    def call_iseq_setup(recv, argc, method_iseq)
      argv_index = cfp.sp - argc
      recv_index = argv_index - 1

      cfp.sp = recv_index

      push_frame(
        iseq: method_iseq,
        type: FRAME_TYPE_METHOD,
        self_value: recv,
        sp: argv_index
      )

      local_only_size = method_iseq.local_table_size - method_iseq.argc
      local_only_size.times do |i|
        env_write(-i, nil)
      end
    end

    def sendish(cd)
      argc = cd.argc
      recv = topn(argc + 1)

      klass = recv.klass
      method_iseq = klass.search_method(cd.mid)

      raise "undefined method #{cd.mid}" if method_iseq.nil?

      call_iseq_setup(recv, argc, method_iseq)
    end
  end
end
