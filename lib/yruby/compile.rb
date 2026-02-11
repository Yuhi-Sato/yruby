# frozen_string_literal: true

class YRuby
  class Compile
    def iseq_compile_node(iseq, node)
      @index_lookup_table = {}
      insert_local_index(@index_lookup_table, node.locals)
      iseq_set_local_table(iseq, node.locals)
      compile_node(iseq, node)
    end

    private

    def insert_local_index(index_lookup_table, locals)
      locals.reverse_each.with_index do |local, index|
        index_lookup_table[local] = index
      end

      private

      def insert_local_index(index_lookup_table, locals)
        locals.each_with_index do |local, index|
          index_lookup_table[local.name] = index
        end
      end

      def iseq_set_local_table(iseq, node)
        iseq.local_table_size = node.locals.size
        iseq.local_table = node.locals.dup
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
