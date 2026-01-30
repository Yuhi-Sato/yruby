class YRuby::Instructions
  class OptGt < Base
    def call(vm)
      b = vm.stack_pop
      a = vm.stack_pop
      vm.stack_push(a > b)
    end

    def to_s
      "opt_gt"
    end
  end
end
