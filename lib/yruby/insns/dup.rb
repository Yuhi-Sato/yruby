# frozen_string_literal: true

class YRuby
  module Insns
    class Dup < Base
      def call(vm)
        val = vm.topn(1)
        vm.push(val)
      end
    end
  end
end
