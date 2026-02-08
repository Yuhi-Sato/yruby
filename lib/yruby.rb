# frozen_string_literal: true

require_relative 'core'

class YRuby
  def initialize(parser)
    @parser = parser
  end

  def exec(source)
    init

    ast = @parser.parse(source)

    # TODO: Compile AST to Iseq
    # TODO: Execute Iseq

    # TODO: Return the result of the execution
  end

  private

  def init
    stack = Array.new(STACK_SIZE)
  end
end
