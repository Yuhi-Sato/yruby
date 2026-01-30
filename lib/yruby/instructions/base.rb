class YRuby::Instructions
  class Base
    def call(vm)
      raise NotImplementedError
    end

    def to_s
      self.class.name.split("::").last
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .downcase
    end
  end
end
