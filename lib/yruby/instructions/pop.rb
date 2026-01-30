class YRuby::Instructions
  class Pop < Base
    def call(vm)
      vm.stack_pop
    end

    def to_s
      "pop"
    end
  end
end
