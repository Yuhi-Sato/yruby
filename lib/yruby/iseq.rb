class YRuby
  class Iseq
    attr_reader :insns, :local_table

    def initialize(insns: [], local_table: {})
      @insns = insns
      @local_table = local_table
    end

    def emit(instruction)
      @insns.push(instruction)
    end

    def size
      @insns.size
    end

    def [](index)
      @insns[index]
    end

    def reserve_slot(index)
      @insns[index] = nil
    end

    def set_slot(index, insn)
      @insns[index] = insn
    end

    def local_size
      @local_table.size
    end

    def disasm
      lines = []
      lines << "== disasm: <YRuby::Iseq> =="
      lines << "local table: #{@local_table.keys.join(', ')}" unless @local_table.empty?
      @insns.each_with_index do |insn, idx|
        lines << format("%04d %s", idx, insn.to_s)
      end
      lines.join("\n")
    end
  end
end
