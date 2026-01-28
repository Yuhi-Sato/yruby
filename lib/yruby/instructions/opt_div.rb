class YRuby::Instructions
  class OptDiv < Base
    def call(vm)
      b = vm.stack_pop
      a = vm.stack_pop
      vm.stack_push(a / b)
    end
  end
end
