# frozen_string_literal: true

class YRuby
  module Insns
    class Leave < Base
      def call(vm)
        val = vm.topn(1)
        vm.pop

        type = vm.cfp.type
        vm.pop_frame

        case type
        when YRuby::FRAME_TYPE_METHOD
          vm.push(val)
        when YRuby::FRAME_TYPE_TOP
          throw :finish, val
        end
      end
    end
  end
end
