# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

YRuby is a minimal Ruby interpreter/VM written in Ruby. It implements a three-stage pipeline: parsing (via Prism), compiling to bytecode, and executing on a stack-based virtual machine.

## Commands

```bash
# Run a Ruby file
ruby main.rb <file.rb>

# Run with bytecode disassembly output
ruby main.rb --disasm <file.rb>

# Run tests
ruby test/yruby_test.rb
```

## Architecture

### Pipeline: Parse → Compile → Execute

1. **Parser** (`lib/yruby/parser.rb`): Wraps the Prism gem to produce an AST from Ruby source.
2. **Compiler** (`lib/yruby/compiler.rb`): Walks the AST and emits bytecode instructions into an `Iseq`.
3. **VM** (`lib/yruby.rb`, class `MinRuby`): Stack-based interpreter that executes the instruction sequence. Maintains `pc` (program counter), `sp` (stack pointer), and `ep` (environment pointer for locals).

### Instruction System

All instructions live in `lib/yruby/instructions/` and inherit from `Base`. Each implements `call(vm)` for execution and `to_s` for disassembly. New instructions must be required in `lib/yruby/instructions.rb`.

Categories: stack ops (`PutObject`, `Pop`), arithmetic (`OptPlus`, `OptMinus`, `OptMult`, `OptDiv`), comparison (`OptEq`, `OptNeq`, `OptLt`, `OptGt`, `OptLe`, `OptGe`), variables (`SetLocal`, `GetLocal`), control flow (`Jump`, `BranchUnless`, `BranchIf`).

### Bytecode (`lib/yruby/iseq.rb`)

`Iseq` holds the instruction array and a local variable table. `reserve_slot()` / `set_slot()` enable forward-patching of jump targets for control flow compilation.

## Ruby Version

Requires Ruby 4.0.0 (see `.ruby-version`).

## Testing

Tests use Minitest in `test/yruby_test.rb`. The test helper `assert_yruby(expected, source)` compiles and runs a Ruby source string, then asserts the VM result matches the expected value.

## Plan Mode
プランモードの際はプランのmdファイルを.claude/plans/に保存してください。
