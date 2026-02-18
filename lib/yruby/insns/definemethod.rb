# frozen_string_literal: true

class YRuby
  module Insns
    class Definemethod < Base
      def initialize(mid, iseq)
        @mid = mid
        @iseq = iseq
      end

      def call(vm)
        vm.define_method(@mid, @iseq)
      end
    end
  end
end
