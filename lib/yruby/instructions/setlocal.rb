class YRuby::Instructions
  class Setlocal < Base
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
      "#{super} #{index}"
    end
  end
end
