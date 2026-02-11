# frozen_string_literal: true

class YRuby
  module Insns
    class Setlocal < Base
      def initialize(idx)
        @idx = idx
      end

      def call(vm)
        val = vm.pop
        vm.env_write(-@idx, val)
      end
    end
  end
end
