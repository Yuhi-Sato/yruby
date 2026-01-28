class YRuby::Instructions
  class Base
    def call(vm)
      raise NotImplementedError
    end
  end
end
