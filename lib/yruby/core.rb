# frozen_string_literal: true

class YRuby
  ControlFrame = Struct.new(:iseq, :pc, :sp, :ep, :type, :self_value, keyword_init: true)
  ExecutionContext = Struct.new(keyword_init: true)
end
