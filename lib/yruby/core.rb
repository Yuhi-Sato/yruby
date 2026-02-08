# frozen_string_literal: true

class YRuby
  ControlFrame = Struct.new(:iseq, :pc, :sp, :ep, :type, :self_value, keyword_init: true)
  ExecutionContext = Struct.new(:stack, :stack_size, :cfp, keyword_init: true)
end
