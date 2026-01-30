class YRuby::Instructions
  class SetLocal < Base
    attr_reader :index

    def initialize(index)
      @index = index
    end

    def call(vm)
      value = vm.stack_pop
      vm.stack[vm.ep - index] = value
      vm.stack_push(value)
    end

    def to_s
      "setlocal #{index}"
    end
  end
end
