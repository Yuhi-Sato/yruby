# frozen_string_literal: true

class YRuby
  module Insns
    class Putobject < Base
      LEN = 2

      def self.call(vm, value)
        vm.push(value)
      end
    end
  end
end
