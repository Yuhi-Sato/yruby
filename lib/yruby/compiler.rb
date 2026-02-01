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
      when Prism::StringNode
        iseq.emit(YRuby::Instructions::Putstring.new(node.unescaped))
      when Prism::CallNode
        if node.block
          if node.receiver
            compile_node(node.receiver, iseq)
          else
            iseq.emit(YRuby::Instructions::Putself.new)
          end
          args = node.arguments&.arguments || []
          args.each { |arg| compile_node(arg, iseq) }
          block_iseq = compile_block(node.block)
          iseq.emit(YRuby::Instructions::Send.new(node.name, args.size, block_iseq))
        else
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
            if node.receiver.nil?
              iseq.emit(YRuby::Instructions::Putself.new)
              args = node.arguments&.arguments || []
              args.each { |arg| compile_node(arg, iseq) }
              iseq.emit(YRuby::Instructions::OptSendWithoutBlock.new(node.name, args.size))
            else
              raise "Unknown call: #{node.name}"
            end
          end
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
          iseq.emit(YRuby::Instructions::Putobject.new(nil))
        end
        iseq.set_slot(jump_idx, YRuby::Instructions::Jump.new(iseq.size))
      when Prism::ElseNode
        compile_node(node.statements, iseq)
      else
        raise "Unknown node type: #{node.class}"
      end
    end

    private

    def compile_block(block_node)
      block_iseq = YRuby::Iseq.new(type: :block)
      build_local_table(block_iseq, block_node.locals)

      param_size = 0
      if block_node.parameters&.parameters
        param_size = block_node.parameters.parameters.requireds.size
      end

      block_iseq = YRuby::Iseq.new(
        type: :block,
        param_size: param_size,
        local_table: block_iseq.local_table
      )

      compile_node(block_node.body, block_iseq) if block_node.body

      block_iseq
    end

    def build_local_table(iseq, locals)
      locals.each_with_index do |name, index|
        iseq.local_table[name] = index
      end
    end
  end
end
