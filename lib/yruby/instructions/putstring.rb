class YRuby::Instructions
  class Putstring < Base
    attr_reader :string

    def initialize(string)
      @string = string
    end

    def call(vm)
      vm.stack_push(string)
    end

    def to_s
      "#{super} #{string.inspect}"
    end
  end
end
