class YRuby::Instructions
  class Leave < Base
    def call(vm)
      throw :leave
    end
  end
end
