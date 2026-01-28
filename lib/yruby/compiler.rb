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
          iseq.push(YRuby::Instructions::Pop.new)
        end
        compile_node(body.last, iseq) if body.last
      when Prism::IntegerNode
        iseq.push(YRuby::Instructions::PutObject.new(node.value))
      when Prism::CallNode
        case node.name
        when :+
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.push(YRuby::Instructions::OptPlus.new)
        when :-
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.push(YRuby::Instructions::OptMinus.new)
        when :*
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.push(YRuby::Instructions::OptMult.new)
        when :/
          compile_node(node.receiver, iseq)
          compile_node(node.arguments.arguments[0], iseq)
          iseq.push(YRuby::Instructions::OptDiv.new)
        else
          raise "Unknown call: #{node.name}"
        end
      when Prism::LocalVariableWriteNode
        compile_node(node.value, iseq)
        index = iseq.local_table[node.name]
        iseq.push(YRuby::Instructions::SetLocal.new(index))
      when Prism::LocalVariableReadNode
        index = iseq.local_table[node.name]
        iseq.push(YRuby::Instructions::GetLocal.new(index))
      else
        raise "Unknown node type: #{node.class}"
      end
    end

    def build_local_table(iseq, locals)
      locals.each_with_index do |name, index|
        iseq.local_table[name] = index
      end
    end
  end
end
