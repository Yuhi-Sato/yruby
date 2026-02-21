# frozen_string_literal: true

class YRuby
  module Insns
    class Setlocal < Base
      LEN = 2

      def self.call(vm, idx)
        val = vm.pop
        vm.env_write(-idx, val)
      end
    end
  end
end
