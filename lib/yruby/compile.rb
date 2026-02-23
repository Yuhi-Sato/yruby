# frozen_string_literal: true

class YRuby
  class Compile
    def iseq_compile_node(iseq, node)
      @index_lookup_table = {}
      insert_local_index(@index_lookup_table, node.locals)
      iseq_set_local_table(iseq, node.locals)
      compile_node(iseq, node)
    end

    def iseq_compile_method(iseq, def_node)
      @index_lookup_table = {}
      insert_local_index(@index_lookup_table, def_node.locals)
      iseq_set_local_table(iseq, def_node.locals)

      if def_node.body
        compile_node(iseq, def_node.body)
      else
        iseq.emit(YRuby::Insns::Putnil)
      end
    end

    private

    def insert_local_index(index_lookup_table, locals)
      locals.reverse_each.with_index do |local, index|
        index_lookup_table[local] = index
      end
    end

    def iseq_set_local_table(iseq, locals)
      iseq.local_table_size = locals.size
      iseq.local_table = locals.dup
    end

    def compile_node(iseq, node)
      case node
      when Prism::ProgramNode
        compile_node(iseq, node.statements)
      when Prism::StatementsNode
        node.body.each { |stmt| compile_node(iseq, stmt) }
      when Prism::IntegerNode
        iseq.emit(YRuby::Insns::Putobject, node.value)
      when Prism::NilNode
        iseq.emit(YRuby::Insns::Putnil)
      when Prism::TrueNode
        iseq.emit(YRuby::Insns::Putobject, true)
      when Prism::FalseNode
        iseq.emit(YRuby::Insns::Putobject, false)
      when Prism::CallNode
        compile_call_node(iseq, node)
      when Prism::ArgumentsNode
        node.arguments.each { |arg| compile_node(iseq, arg) }
      when Prism::LocalVariableWriteNode
        compile_node(iseq, node.value)
        iseq.emit(YRuby::Insns::Dup)
        idx = @index_lookup_table[node.name]
        iseq.emit(YRuby::Insns::Setlocal, idx)
      when Prism::LocalVariableReadNode
        idx = @index_lookup_table[node.name]
        iseq.emit(YRuby::Insns::Getlocal, idx)
      when Prism::IfNode
        compile_conditional_node(iseq, node)
      when Prism::DefNode
        compile_def_node(iseq, node)
      else
        raise "Unknown node: #{node.class}"
      end
    end

    def compile_call_node(iseq, node)
      if node.receiver.nil?
        iseq.emit(YRuby::Insns::Putself)
      else
        compile_node(iseq, node.receiver)
      end

      argc = 0
      if node.arguments
        compile_node(iseq, node.arguments)
        argc = node.arguments.arguments.size
      end

      case node.name
      when :+; iseq.emit(YRuby::Insns::OptPlus)
      when :-; iseq.emit(YRuby::Insns::OptMinus)
      when :*; iseq.emit(YRuby::Insns::OptMult)
      when :/; iseq.emit(YRuby::Insns::OptDiv)
      when :==; iseq.emit(YRuby::Insns::OptEq)
      when :!=; iseq.emit(YRuby::Insns::OptNeq)
      when :<; iseq.emit(YRuby::Insns::OptLt)
      when :<=; iseq.emit(YRuby::Insns::OptLe)
      when :>; iseq.emit(YRuby::Insns::OptGt)
      when :>=; iseq.emit(YRuby::Insns::OptGe)
      else
        cd = CallData.new(mid: node.name, argc:)
        iseq.emit(YRuby::Insns::OptSendWithoutBlock, cd)
      end
    end

    def compile_def_node(iseq, node)
      method_iseq = YRuby::Iseq.iseq_new_method(node)
      iseq.emit(YRuby::Insns::Definemethod, node.name, method_iseq)
      iseq.emit(YRuby::Insns::Putobject, node.name)
    end

    def compile_conditional_node(iseq, node)
      compile_node(iseq, node.predicate)
      branchunless_pc = iseq.size
      iseq.emit_placeholder(YRuby::Insns::Branchunless::LEN)

      # then statements
      compile_node(iseq, node.statements)

      then_end_pc = iseq.size
      iseq.emit_placeholder(YRuby::Insns::Jump::LEN)

      else_label = iseq.size
      branchunless_offset = else_label - (branchunless_pc + YRuby::Insns::Branchunless::LEN)
      iseq.patch_at!(branchunless_pc, YRuby::Insns::Branchunless, branchunless_offset)

      # elsif / else statements
      case node.subsequent
      when Prism::IfNode
        compile_conditional_node(iseq, node.subsequent)
      when Prism::ElseNode
        compile_node(iseq, node.subsequent.statements)
      end

      end_label = iseq.size
      jump_offset = end_label - (then_end_pc + YRuby::Insns::Jump::LEN)
      iseq.patch_at!(then_end_pc, YRuby::Insns::Jump, jump_offset)
    end
  end
end
