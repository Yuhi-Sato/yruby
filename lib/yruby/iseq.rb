# frozen_string_literal: true

class YRuby
  class Iseq
    class << self
      def iseq_new_main(ast)
        node = ast.value

        iseq = new

        Compile.new.iseq_compile_node(iseq, node)

        iseq.emit(Insns::Leave)

        iseq
      end

      def iseq_new_method(def_node)
        iseq = new

        Compile.new.iseq_compile_method(iseq, def_node)

        iseq.emit(Insns::Leave)

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

    def emit(insn_class, *operands)
      @iseq_encoded << insn_class
      operands.each { |op| @iseq_encoded << op }
    end

    def emit_placeholder(len)
      len.times { @iseq_encoded << nil }
    end

    def patch_at!(pc, insn_class, *operands)
      @iseq_encoded[pc] = insn_class
      operands.each_with_index do |op, i|
        @iseq_encoded[pc + 1 + i] = op
      end
    end

    def fetch(pc)
      @iseq_encoded[pc]
    end

    def size
      @iseq_encoded.size
    end

    def disasm
      lines = []
      lines << "== disasm: #<ISeq:<main>@<compiled>:1> =="

      pc = 0
      while pc < @iseq_encoded.size
        insn_class = @iseq_encoded[pc]
        len = insn_class::LEN
        operands = @iseq_encoded[pc + 1, len - 1]
        name = insn_class.name.split('::').last.downcase
        if operands.empty?
          lines << format("%04d %s", pc, name)
        else
          lines << format("%04d %s %s", pc, name, operands.map(&:inspect).join(', '))
        end
        pc += len
      end

      lines.join("\n")
    end
  end
end
