# frozen_string_literal: true

class YRuby
  class RClass
    def initialize
      @m_tbl = {}
    end

    def add_method_iseq(mid, iseq)
      @m_tbl[mid] = iseq
    end

    def search_method(mid)
      @m_tbl[mid]
    end
  end
end
