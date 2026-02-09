# frozen_string_literal: true

class YRuby
  module Insns
    class Base
      def call(vm)
        raise NotImplementedError
      end
    end
  end
end
