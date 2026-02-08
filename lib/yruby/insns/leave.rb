# frozen_string_literal: true

class YRuby
  module Insns
    class Leave
      def call(vm)
        val = vm.topn(1)
        vm.pop
        vm.pop_frame
        throw :finish, val
      end
    end
  end
end
