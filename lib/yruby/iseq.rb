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
        lines << format("%04d %s", idx, insn_to_s(insn))
      end
      lines.join("\n")
    end

    private

    def insn_to_s(insn)
      case insn
      when Instructions::PutObject
        "putobject #{insn.object.inspect}"
      when Instructions::SetLocal
        "setlocal #{insn.index}"
      when Instructions::GetLocal
        "getlocal #{insn.index}"
      when Instructions::OptPlus
        "opt_plus"
      when Instructions::OptMinus
        "opt_minus"
      when Instructions::OptMult
        "opt_mult"
      when Instructions::OptDiv
        "opt_div"
      when Instructions::OptEq
        "opt_eq"
      when Instructions::OptNeq
        "opt_neq"
      when Instructions::OptLt
        "opt_lt"
      when Instructions::OptGt
        "opt_gt"
      when Instructions::OptLe
        "opt_le"
      when Instructions::OptGe
        "opt_ge"
      when Instructions::BranchUnless
        "branchunless #{insn.dst}"
      when Instructions::Jump
        "jump #{insn.dst}"
      when Instructions::Pop
        "pop"
      else
        insn.class.name
      end
    end
  end
end
