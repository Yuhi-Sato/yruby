class YRuby
  class Iseq
    attr_reader :instructions, :local_table

    def initialize(instructions: [], local_table: {})
      @instructions = instructions
      @local_table = local_table
    end

    def push(instruction)
      @instructions.push(instruction)
    end

    def size
      @instructions.size
    end

    def [](index)
      @instructions[index]
    end

    def local_size
      @local_table.size
    end
  end
end
