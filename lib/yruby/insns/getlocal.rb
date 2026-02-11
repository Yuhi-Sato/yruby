# frozen_string_literal: true

class YRuby
  module Insns
    class Getlocal < Base
      def initialize(idx)
        @idx = idx
      end

      def call(vm)
        val = vm.env_read(-@idx)
        vm.push(val)
      end
    end
  end
end
