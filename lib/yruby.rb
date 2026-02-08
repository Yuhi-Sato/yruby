# frozen_string_literal: true

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

  # TODO: Setup VM
  def init
  end
end
