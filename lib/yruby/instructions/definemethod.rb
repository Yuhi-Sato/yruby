class YRuby::Instructions
  class Definemethod < Base
    attr_reader :method_name, :method_iseq

    def initialize(method_name, method_iseq)
      @method_name = method_name
      @method_iseq = method_iseq
    end

    def call(vm)
      vm.object_class.define_method(method_name, method_iseq)
      vm.stack_push(method_name)
    end

    def to_s
      "#{super} :#{method_name}"
    end
  end
end
