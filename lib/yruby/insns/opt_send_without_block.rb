# frozen_string_literal: true

class YRuby
  module Insns
    class OptSendWithoutBlock < Base
      LEN = 2

      def self.call(vm, cd)
        vm.sendish(cd)
      end
    end
  end
end
