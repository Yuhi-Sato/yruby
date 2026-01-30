class MinRuby
  attr_accessor :parser, :compiler, :stack, :pc, :sp, :ep

  def initialize(parser, compiler, debug: false)
    @parser = parser
    @compiler = compiler
    @debug = debug
    @stack = []

    @pc = 0
    @sp = 0
    @ep = 0
  end

  def parse(source)
    parser.parse(source)
  end

  def compile(ast)
    compiler.compile(ast)
  end

  def run(source)
    ast = parse(source)

    iseq = compile(ast)

    puts iseq.disasm if @debug

    self.pc = 0
    self.sp = iseq.local_size
    self.ep = sp - 1

    loop do
      break if pc >= iseq.size
      iseq[pc].call(self)
      self.pc += 1
    end

    stack_pop
  end

  def stack_push(value)
    stack[sp] = value
    self.sp += 1
  end

  def stack_pop
    self.sp -= 1
    stack[sp]
  end
end
