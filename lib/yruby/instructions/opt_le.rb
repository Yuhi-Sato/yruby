class YRuby::Instructions
  class OptLe < Base
    def call(vm)
      b = vm.stack_pop
      a = vm.stack_pop
      vm.stack_push(a <= b)
    end

    def to_s
      "opt_le"
    end
  end
end
