class YRuby
  class RClass
    attr_reader :name, :method_table

    def initialize(name)
      @name = name
      @method_table = {}
    end

    def define_method(method_name, iseq)
      @method_table[method_name] = iseq
    end

    def lookup_method(method_name)
      @method_table[method_name]
    end
  end
end
