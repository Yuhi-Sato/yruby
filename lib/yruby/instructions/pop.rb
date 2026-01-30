class YRuby::Instructions
  class Pop < Base
    def call(vm)
      vm.stack_pop
    end
  end
end
