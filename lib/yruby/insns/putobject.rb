# frozen_string_literal: true

class YRuby
  module Insns
    class Putobject
      def initialize(value)
        @value = value
      end

      def call(vm)
        vm.push(@value)
      end
    end
  end
end
