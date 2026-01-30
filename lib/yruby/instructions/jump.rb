class YRuby::Instructions
  class Jump < Base
    attr_reader :dst

    def initialize(dst)
      @dst = dst
    end

    def call(vm)
      vm.pc = dst - 1
    end

    def to_s
      "jump #{dst}"
    end
  end
end
