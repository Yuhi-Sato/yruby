# frozen_string_literal: true

class YRuby
  module Insns
    class Putself < Base
      def call(vm)
        vm.push(vm.cfp.self_value)
      end
    end
  end
end
