class YRuby::Instructions
  class Base
    def call(vm)
      raise NotImplementedError
    end

    def to_s
      raise NotImplementedError
    end
  end
end
