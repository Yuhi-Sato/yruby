require 'forwardable'
require_relative 'yruby/rbasic'
require_relative 'yruby/rclass'

class MinRuby
  STACK_SIZE = 256.freeze
  ControlFrame = Struct.new(:iseq, :pc, :sp, :ep, :type, :self_value, keyword_init: true)

  attr_accessor :stack, :cfp
  attr_reader :parser, :compiler, :debug, :main

  def initialize(parser, compiler, debug: false)
    @parser = parser
    @compiler = compiler
    @debug = debug
    @stack = Array.new(STACK_SIZE)
    @cfp = STACK_SIZE
    @main = YRuby::RBasic.new(YRuby::RClass.new("Object"))
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

    puts iseq.disasm if debug

    push_frame(iseq: iseq, type: :top, sp: 0, self_value: @main)
    execute
    result = stack_pop
    pop_frame
    result
  end

  def invoke_method(method_iseq:, args:, receiver: main)
    push_frame(iseq: method_iseq, type: :method, args: args, self_value: receiver)
    execute
    result = stack_pop
    pop_frame
    result
  end

  def invoke_block(block_iseq:, args:)
    push_frame(iseq: block_iseq, type: :block, args: args, self_value: current_cf.self_value)
    execute
    result = stack_pop
    pop_frame
    result
  end

  def stack_push(value)
    stack[sp] = value
    self.sp += 1
  end

  def stack_pop
    self.sp -= 1
    stack[sp]
  end

  def current_cf
    stack[cfp]
  end

  extend Forwardable
  def_delegators :current_cf, :pc, :pc=, :sp, :sp=, :ep, :ep=, :iseq, :self_value

  private

  def push_frame(iseq:, type:, sp: nil, args: [], self_value: nil)
    frame_sp = sp || self.sp
    frame_ep = frame_sp + iseq.local_size - 1
    new_sp = frame_sp + iseq.local_size

    args.each_with_index do |arg, idx|
      @stack[frame_ep - idx] = arg
    end

    cf = ControlFrame.new(
      iseq: iseq,
      pc: 0,
      sp: new_sp,
      ep: frame_ep,
      type: type,
      self_value: self_value
    )
    self.cfp -= 1
    self.stack[cfp] = cf
  end

  def pop_frame
    self.cfp += 1
  end

  def execute
    catch(:leave) do
      loop do
        iseq[pc].call(self)
        self.pc += 1
      end
    end
  end
end
