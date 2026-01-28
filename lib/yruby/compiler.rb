require_relative './instructions'

class YRuby
  class Compiler
    def compile(ast)
      iseq = []

      compile_node(ast, iseq)

      iseq
    end

    def compile_node(node, iseq)
      case node
      when Prism::ProgramNode
        compile_node(node.statements, iseq)
      when Prism::StatementsNode
        node.body.each do |stmt|
          compile_node(stmt, iseq)
        end
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
      else
        raise "Unknown node type: #{node.class}"
      end
    end
  end
end
