# frozen_string_literal: true

class YRuby
  class Iseq
    class << self
      def iseq_new_main(ast)
        node = ast.value

        iseq = new

        Compile.new.iseq_compile_node(iseq, node)

        iseq.emit(Insns::Leave.new)

        iseq
      end

      def iseq_new_method(def_node)
        iseq = new

        Compile.new.iseq_compile_method(iseq, def_node)

        iseq.emit(Insns::Leave.new)

        params = def_node.parameters
        iseq.argc = params ? params.requireds.size : 0

        iseq
      end
    end

    attr_accessor :local_table, :local_table_size, :argc

    def initialize
      @iseq_encoded = []
      @local_table = []
      @local_table_size = 0
      @argc = 0
    end

    def emit(insn)
      @iseq_encoded << insn
    end

    def fetch(pc)
      @iseq_encoded[pc]
    end

    def size
      @iseq_encoded.size
    end

    def set_insn_at!(pc, insn)
      @iseq_encoded[pc] = insn
    end

    def disasm
      lines = []
      lines << "== disasm: #<ISeq:<main>@<compiled>:1> =="

      @iseq_encoded.each_with_index do |insn, idx|
        lines << format("%04d %s", idx, insn.disasm)
      end

      lines.join("\n")
    end
  end
end
