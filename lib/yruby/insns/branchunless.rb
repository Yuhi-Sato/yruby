# frozen_string_literal: true

class YRuby
  module Insns
    class Branchunless < Base
      def initialize(dst)
        @dst = dst
      end

      def call(vm)
        val = vm.topn(1)
        vm.pop

        if !val
          vm.set_pc(@dst)
        end
      end
    end
  end
end
