class YRuby::Instructions
  class GetLocal < Base
    attr_reader :index

    def initialize(index)
      @index = index
    end

    def call(vm)
      vm.stack_push(vm.stack[vm.ep - index])
    end
  end
end
