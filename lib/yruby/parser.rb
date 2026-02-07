# frozen_string_literal: true

require 'prism'

class YRuby
  class Parser
    def parse(source)
      result = Prism.parse(source)
      result.value
    end
  end
end
