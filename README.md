# YRuby

YRuby is a Ruby virtual machine implementation based on CRuby's YARV (Yet Another Ruby VM) architecture. It parses Ruby source code with the [Prism](https://github.com/ruby/prism) gem and executes it through a stack-based bytecode interpreter.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yruby'
```

Or install it directly:

```
$ gem install yruby
```

## Requirements

- Ruby >= 3.3.0
- [prism](https://rubygems.org/gems/prism) ~> 1.0

## Usage

### Basic Usage

```ruby
require 'yruby'

vm = YRuby.new

vm.exec("1 + 2")           # => 3
vm.exec("if true; 42; end") # => 42
```

Each call to `exec` is independent — the VM state is reinitialized on every call.

### API

#### `YRuby.new(parser = YRuby::Parser.new) -> YRuby`

Creates a new VM instance. Uses the default Prism-based parser if none is provided.

| Parameter | Type           | Description                                  |
|-----------|----------------|----------------------------------------------|
| `parser`  | `YRuby::Parser` | Parser instance to use for parsing (optional) |

#### `YRuby#exec(source) -> Object`

Parses and executes the given Ruby source string, returning the result of the last evaluated expression.

| Parameter | Type     | Description                  |
|-----------|----------|------------------------------|
| `source`  | `String` | Ruby source code to execute  |

```ruby
vm = YRuby.new

# Literals
vm.exec("42")           # => 42
vm.exec("nil")          # => nil
vm.exec("true")         # => true

# Arithmetic
vm.exec("1 + 2")        # => 3
vm.exec("10 - 3")       # => 7
vm.exec("4 * 5")        # => 20
vm.exec("10 / 2")       # => 5

# Local variables
vm.exec(<<~RUBY)        # => 11
  a = 10
  a + 1
RUBY

# Conditionals
vm.exec(<<~RUBY)        # => 1
  if true
    1
  else
    2
  end
RUBY

vm.exec(<<~RUBY)        # => 2
  if false
    1
  elsif true
    2
  end
RUBY

# Method definition and call
vm.exec(<<~RUBY)        # => 3
  def add(a, b)
    a + b
  end
  add(1, 2)
RUBY
```

#### `YRuby::Parser#parse(source) -> Prism::ParseResult`

Parses Ruby source code and returns a Prism AST result. This is used internally by `YRuby#exec` and is rarely needed directly.

#### `YRuby::Iseq.iseq_new_main(ast) -> YRuby::Iseq`

Compiles a Prism AST into an instruction sequence for the top-level scope.

#### `YRuby::Iseq.iseq_new_method(def_node) -> YRuby::Iseq`

Compiles a method definition node into an instruction sequence.

#### `YRuby::Iseq#disasm -> String`

Returns a human-readable disassembly of the instruction sequence. Useful for debugging and learning.

```ruby
parser = YRuby::Parser.new
iseq = YRuby::Iseq.iseq_new_main(parser.parse("1 + 2"))
puts iseq.disasm
# 0000 putobject          1
# 0002 putobject          2
# 0004 opt_plus
# 0005 leave
```

## Supported Ruby Features

| Feature                        | Example                                      |
|-------------------------------|----------------------------------------------|
| Integer literals              | `42`, `0`, `-1`                              |
| Boolean / nil literals        | `true`, `false`, `nil`                       |
| Arithmetic operators          | `a + b`, `a - b`, `a * b`, `a / b`          |
| Comparison operators          | `a == b`, `a != b`, `a < b`, `a <= b`, `a > b`, `a >= b` |
| Local variable read/write     | `a = 1; a`                                   |
| `if` / `else` / `elsif`       | `if cond; ...; elsif ...; else; ...; end`    |
| `if` as expression            | `x = if true; 1; else; 2; end`              |
| Method definition             | `def add(a, b); a + b; end`                  |
| Method call                   | `add(1, 2)`                                  |
| Multiple statements           | `1; 2; 3`                                    |

## Instruction Set

YRuby implements the following YARV-like instructions:

| Instruction              | Operands    | Description                                   |
|--------------------------|-------------|-----------------------------------------------|
| `putobject`              | `value`     | Push a constant value onto the stack          |
| `putnil`                 | —           | Push `nil` onto the stack                     |
| `putself`                | —           | Push the current receiver onto the stack      |
| `dup`                    | —           | Duplicate the top of the stack                |
| `getlocal`               | `idx`       | Push a local variable value onto the stack    |
| `setlocal`               | `idx`       | Pop and store a value into a local variable   |
| `opt_plus`               | —           | Pop two values and push their sum             |
| `opt_minus`              | —           | Pop two values and push their difference      |
| `opt_mult`               | —           | Pop two values and push their product         |
| `opt_div`                | —           | Pop two values and push their quotient        |
| `opt_eq`                 | —           | Pop two values and push equality result       |
| `opt_neq`                | —           | Pop two values and push inequality result     |
| `opt_lt`                 | —           | Pop two values and push less-than result      |
| `opt_le`                 | —           | Pop two values and push less-than-or-equal result |
| `opt_gt`                 | —           | Pop two values and push greater-than result   |
| `opt_ge`                 | —           | Pop two values and push greater-than-or-equal result |
| `branchunless`           | `offset`    | Jump if the popped value is falsy             |
| `jump`                   | `offset`    | Unconditional jump                            |
| `definemethod`           | `mid, iseq` | Register a method on the current object       |
| `opt_send_without_block` | `cd`        | Dispatch a method call                        |
| `leave`                  | —           | Exit the current frame and return a value     |

## Architecture

```
Source Code → Parser (Prism) → AST → Compile → Iseq → VM Execution → Result
```

### CRuby Mapping

The internal structure mirrors CRuby's implementation:

```
lib/
├── yruby.rb              # vm.c, vm_exec.c   — VM core and execution loop
└── yruby/
    ├── core.rb           # vm_core.h         — ExecutionContext, ControlFrame
    ├── insnhelper.rb     # vm_insnhelper.c   — stack/frame/env operations
    ├── parser.rb         # parse.y           — Prism wrapper
    ├── compile.rb        # compile.c         — AST → bytecode compiler
    ├── iseq.rb           # iseq.c / iseq.h   — instruction sequence
    ├── rclass.rb         #                   — class and method table
    ├── robject.rb        #                   — object instances
    ├── insns.rb          # insns.def         — instruction aggregation
    └── insns/            # insns.def         — individual instruction classes
```

## Development

```
$ bundle install
$ bundle exec rake test
```

## License

[MIT](LICENSE)
