# frozen_string_literal: true

class YRuby
  class Compile
    class << self
      def iseq_compile_node(iseq, node)
        compile_node(iseq, node)
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
        end
      end
    end
  end
end
