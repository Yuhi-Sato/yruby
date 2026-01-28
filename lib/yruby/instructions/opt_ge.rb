class YRuby::Instructions
  class OptGe < Base
    def call(vm)
      b = vm.stack_pop
      a = vm.stack_pop
      vm.stack_push(a >= b)
    end
  end
end
