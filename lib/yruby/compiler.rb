require_relative './instructions'
require_relative './iseq'

class YRuby
  class Compiler
    def compile(ast)
      iseq = YRuby::Iseq.new

      compile_node(ast, iseq)

      iseq
    end

    def compile_node(node, iseq)
      case node
      when Prism::ProgramNode
        build_local_table(iseq, node.locals)
        compile_node(node.statements, iseq)
      when Prism::StatementsNode
        body = node.body
        body[0...-1].each do |stmt|
          compile_node(stmt, iseq)
          iseq.emit(YRuby::Instructions::Pop.new)
        end
        compile_node(body.last, iseq) if body.last
      when Prism::IntegerNode
        iseq.emit(YRuby::Instructions::Putobject.new(node.value))
      when Prism::CallNode
        case node.name
        when :+
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.emit(YRuby::Instructions::OptPlus.new)
        when :-
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.emit(YRuby::Instructions::OptMinus.new)
        when :*
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.emit(YRuby::Instructions::OptMult.new)
        when :/
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.emit(YRuby::Instructions::OptDiv.new)
        when :==
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.emit(YRuby::Instructions::OptEq.new)
        when :!=
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.emit(YRuby::Instructions::OptNeq.new)
        when :<
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.emit(YRuby::Instructions::OptLt.new)
        when :>
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.emit(YRuby::Instructions::OptGt.new)
        when :<=
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.emit(YRuby::Instructions::OptLe.new)
        when :>=
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.emit(YRuby::Instructions::OptGe.new)
        else
          raise "Unknown call: #{node.name}"
        end
      when Prism::LocalVariableWriteNode
        compile_node(node.value, iseq)
        index = iseq.local_table[node.name]
        iseq.emit(YRuby::Instructions::Setlocal.new(index))
      when Prism::LocalVariableReadNode
        index = iseq.local_table[node.name]
        iseq.emit(YRuby::Instructions::Getlocal.new(index))
      when Prism::IfNode
        compile_node(node.predicate, iseq)
        branchunless_idx = iseq.size
        iseq.reserve_slot(branchunless_idx)
        compile_node(node.statements, iseq)
        jump_idx = iseq.size
        iseq.reserve_slot(jump_idx)
        else_idx = iseq.size
        iseq.set_slot(branchunless_idx, YRuby::Instructions::Branchunless.new(else_idx))
        if node.subsequent
          compile_node(node.subsequent, iseq)
        else
          iseq.emit(YRuby::Instructions::PutObject.new(nil))
        end
        iseq.set_slot(jump_idx, YRuby::Instructions::Jump.new(iseq.size))
      when Prism::ElseNode
        compile_node(node.statements, iseq)
      else
        raise "Unknown node type: #{node.class}"
      end
    end

    private

    def build_local_table(iseq, locals)
      locals.each_with_index do |name, index|
        iseq.local_table[name] = index
      end
    end
  end
end
