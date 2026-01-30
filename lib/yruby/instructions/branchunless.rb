class YRuby::Instructions
  class BranchUnless < Base
    attr_reader :dst

    def initialize(dst)
      @dst = dst
    end

    def call(vm)
      value = vm.stack_pop
      vm.pc = dst - 1 unless value
    end

    def to_s
      "branchunless #{dst}"
    end
  end
end
