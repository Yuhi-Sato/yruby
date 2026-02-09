# frozen_string_literal: true

require_relative 'iseq'
require_relative 'compile'
require_relative 'insns'
require_relative 'parser'
require_relative 'insnhelper'

class YRuby
  STACK_SIZE = 128.freeze

  ControlFrame = Struct.new(:iseq, :pc, :sp, :ep, :type, :self_value, keyword_init: true)
  ExecutionContext = Struct.new(:stack, :stack_size, :cfp, :frames, keyword_init: true)
end
