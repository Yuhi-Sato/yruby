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
        iseq.emit(YRuby::Insns::Putnil.new)
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
        iseq.emit(YRuby::Insns::Putobject.new(node.value))
      when Prism::NilNode
        iseq.emit(YRuby::Insns::Putnil.new)
      when Prism::TrueNode
        iseq.emit(YRuby::Insns::Putobject.new(true))
      when Prism::FalseNode
        iseq.emit(YRuby::Insns::Putobject.new(false))
      when Prism::CallNode
        compile_call_node(iseq, node)
      when Prism::ArgumentsNode
        node.arguments.each { |arg| compile_node(iseq, arg) }
      when Prism::LocalVariableWriteNode
        compile_node(iseq, node.value)
        iseq.emit(YRuby::Insns::Dup.new)
        idx = @index_lookup_table[node.name]
        iseq.emit(YRuby::Insns::Setlocal.new(idx))
      when Prism::LocalVariableReadNode
        idx = @index_lookup_table[node.name]
        iseq.emit(YRuby::Insns::Getlocal.new(idx))
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
        iseq.emit(YRuby::Insns::Putself.new)
        argc = 0
        if node.arguments
          compile_node(iseq, node.arguments)
          argc = node.arguments.arguments.size
        end
        cd = CallData.new(ci: CallInfo.new(mid: node.name, argc:))
        iseq.emit(YRuby::Insns::OptSendWithoutBlock.new(cd))
      else
        compile_node(iseq, node.receiver)
        compile_node(iseq, node.arguments)

        case node.name
        when :+; iseq.emit(YRuby::Insns::OptPlus.new)
        when :-; iseq.emit(YRuby::Insns::OptMinus.new)
        else
          raise "Unknown operator: #{node.name}"
        end
      end
    end

    def compile_def_node(iseq, node)
      method_iseq = YRuby::Iseq.iseq_new_method(node)
      iseq.emit(YRuby::Insns::Definemethod.new(node.name, method_iseq))
      iseq.emit(YRuby::Insns::Putobject.new(node.name))
    end

    def compile_conditional_node(iseq, node)
      compile_node(iseq, node.predicate)
      branchunless_pc = iseq.size
      iseq.emit(nil) # branchunless to else_label

      # then statements
      compile_node(iseq, node.statements)

      then_end_pc = iseq.size
      iseq.emit(nil) # jump to end_label

      else_label = iseq.size
      iseq.set_insn_at!(branchunless_pc, YRuby::Insns::Branchunless.new(else_label))

      # elsif / else statements
      case node.subsequent
      when Prism::IfNode
        compile_conditional_node(iseq, node.subsequent)
      when Prism::ElseNode
        compile_node(iseq, node.subsequent.statements)
      end

      end_label = iseq.size
      iseq.set_insn_at!(then_end_pc, YRuby::Insns::Jump.new(end_label))
    end
  end
end
