# frozen_string_literal: true

class YRuby
  class RObject
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end
  end
end
