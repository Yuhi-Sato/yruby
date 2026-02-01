class YRuby::Instructions
  class Send < Base
    attr_reader :method_name, :argc, :block_iseq

    def initialize(method_name, argc, block_iseq)
      @method_name = method_name
      @argc = argc
      @block_iseq = block_iseq
    end

    def call(vm)
      args = argc.times.map { vm.stack_pop }.reverse
      receiver = vm.stack_pop

      case method_name
      when :times
        receiver.times do |i|
          vm.invoke_block(block_iseq, [i])
        end
        vm.stack_push(receiver)
      else
        raise "Unknown method with block: #{method_name}"
      end
    end

    def to_s
      "#{super} :#{method_name}, #{argc}"
    end
  end
end
