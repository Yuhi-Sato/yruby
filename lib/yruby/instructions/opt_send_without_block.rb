class YRuby::Instructions
  class OptSendWithoutBlock < Base
    attr_reader :method_name, :argc

    def initialize(method_name, argc)
      @method_name = method_name
      @argc = argc
    end

    def call(vm)
      args = argc.times.map { vm.stack_pop }.reverse
      _receiver = vm.stack_pop

      result = case method_name
               when :puts
                 args.each { |arg| Kernel.puts(arg) }
                 nil
               else
                 raise "Unknown method: #{method_name}"
               end

      vm.stack_push(result)
    end

    def to_s
      "#{super} :#{method_name}, #{argc}"
    end
  end
end
