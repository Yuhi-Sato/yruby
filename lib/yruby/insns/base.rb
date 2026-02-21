# frozen_string_literal: true

class YRuby
  module Insns
    class Base
      LEN = 1

      def self.call(vm)
        raise NotImplementedError
      end
    end
  end
end
