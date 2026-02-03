class YRuby
  class RClass
    attr_reader :name, :method_table, :superclass

    def initialize(name, superclass: nil)
      @name = name
      @method_table = {}
      @superclass = superclass
    end

    def define_method(method_name, iseq)
      @method_table[method_name] = iseq
    end

    def lookup_method(method_name)
      current = self
      while current
        iseq = current.method_table[method_name]
        return iseq if iseq
        current = current.superclass
      end
      nil
    end
  end
end
