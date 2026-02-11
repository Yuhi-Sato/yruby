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

    attr_reader :local_table, :local_table_size

    def initialize
      @iseq_encoded = []
      @local_table = []
      @local_table_size = 0
    end

    def emit(insn)
      @iseq_encoded << insn
    end

    def fetch(pc)
      @iseq_encoded[pc]
    end
  end
end
