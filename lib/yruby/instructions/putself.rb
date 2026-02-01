class YRuby::Instructions
  class Putself < Base
    def call(vm)
      vm.stack_push(:main)
    end
  end
end
