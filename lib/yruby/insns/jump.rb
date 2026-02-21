# frozen_string_literal: true

class YRuby
  module Insns
    class Jump < Base
      LEN = 2

      def self.call(vm, dst)
        vm.add_pc(dst)
      end
    end
  end
end
