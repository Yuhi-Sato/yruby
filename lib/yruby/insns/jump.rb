# frozen_string_literal: true

class YRuby
  module Insns
    class Jump < Base
      def initialize(dst)
        @dst = dst
      end

      def call(vm)
        vm.set_pc(@dst)
      end
    end
  end
end
