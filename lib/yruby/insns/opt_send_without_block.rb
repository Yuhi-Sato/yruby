# frozen_string_literal: true

class YRuby
  module Insns
    class OptSendWithoutBlock < Base
      def initialize(cd)
        @cd = cd
      end

      def call(vm)
        vm.sendish(@cd)
      end
    end
  end
end
