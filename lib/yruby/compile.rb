# frozen_string_literal: true

class YRuby
  class Compile
    class << self
      def iseq_compile_node(iseq, node)
        compile_node(iseq, node)
      end

      private

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
        else
          raise "Unknown node: #{node.class}"
        end
      end

      def compile_call_node(iseq, node)
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
  end
end
