# frozen_string_literal: true

class YRuby
  module Insns
    class Definemethod < Base
      LEN = 3

      def self.call(vm, mid, iseq)
        vm.define_method(mid, iseq)
      end
    end
  end
end
