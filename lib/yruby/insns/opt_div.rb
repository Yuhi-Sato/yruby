# frozen_string_literal: true

class YRuby
  module Insns
    class OptDiv < Base
      def call(vm)
        recv = vm.topn(2)
        arg = vm.topn(1)
        vm.pop
        vm.pop
        vm.push(recv / arg)
      end
    end
  end
end
