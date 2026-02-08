# frozen_string_literal: true

class YRuby
  module Insns
    class Putnil
      def call(vm)
        vm.push(nil)
      end
    end
  end
end
