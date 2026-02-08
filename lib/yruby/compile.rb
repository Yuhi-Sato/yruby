# frozen_string_literal: true

class YRuby
  class Compile
    class << self
      def iseq_compile_node(iseq, node)
        compile_node(iseq, node)
      end

      def compile_node(iseq, node)
      end
    end
  end
end
