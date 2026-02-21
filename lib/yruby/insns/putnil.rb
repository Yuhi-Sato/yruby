# frozen_string_literal: true

class YRuby
  module Insns
    class Putnil < Base
      def self.call(vm)
        vm.push(nil)
      end
    end
  end
end
