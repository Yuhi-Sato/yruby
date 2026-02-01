class YRuby::Instructions
  class Putobject < Base
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def call(vm)
      vm.stack_push(object)
    end

    def to_s
      "#{super} #{object.inspect}"
    end
  end
end
