# frozen_string_literal: true

class YRuby
  module Insns
    class Branchunless < Base
      LEN = 2

      def self.call(vm, dst)
        val = vm.topn(1)
        vm.pop

        vm.add_pc(dst) unless val
      end
    end
  end
end
