# frozen_string_literal: true

class YRuby
  class Iseq
    class << self
      def iseq_new_main(ast)
        node = ast.value

        iseq = new

        Compile.iseq_compile_node(iseq, node)
        iseq.emit(Insns::Leave.new)

        iseq
      end
    end

    def initialize
      @iseq_encoded = []
    end

    def emit(insn)
      @iseq_encoded << insn
    end

    def fetch(pc)
      @iseq_encoded[pc]
    end
  end
end
