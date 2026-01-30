class YRuby::Instructions
  class BranchIf < Base
    attr_reader :dst

    def initialize(dst)
      @dst = dst
    end

    def call(vm)
      value = vm.stack_pop
      vm.pc = dst - 1 if value
    end

    def to_s
      "branchif #{dst}"
    end
  end
end
