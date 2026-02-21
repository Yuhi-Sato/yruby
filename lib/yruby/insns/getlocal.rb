# frozen_string_literal: true

class YRuby
  module Insns
    class Getlocal < Base
      LEN = 2

      def self.call(vm, idx)
        val = vm.env_read(-idx)
        vm.push(val)
      end
    end
  end
end
