## Overview

YRuby is a Ruby virtual machine implementation based on CRuby's YARV (Yet Another Ruby VM) architecture. It parses Ruby source code with the Prism gem and executes it through a stack-based bytecode interpreter.

## Architecture

### Execution Flow
```
Source Code → Parser (Prism) → AST → Compile → Iseq → VM Execution → Result
```

### Directory Structure (YRuby ↔ CRuby mapping)

```
lib/
├── yruby.rb                    #   vm.c, vm_exec.c (VM core, execution loop)
└── yruby/
    ├── core.rb                 #   vm_core.h (data structure definitions, dependency root)
    │   ├── ExecutionContext    #    └─ rb_execution_context_struct
    │   └── ControlFrame        #    └─ rb_control_frame_struct
    ├── insnhelper.rb           #   vm_insnhelper.c (stack operations, frame operations)
    ├── parser.rb               #   parse.y (Prism wrapper)
    ├── compile.rb              #   compile.c (AST to bytecode)
    ├── iseq.rb                 #   iseq.c, iseq.h (instruction sequence)
    ├── insns.rb                #   insns.def (instruction definition aggregation)
    └── insns/                  #   insns.def (individual instruction implementations)
        ├── putobject.rb        #   push a value onto the stack
        ├── putnil.rb           #   push nil onto the stack
        └── leave.rb            #   exit the frame and return a value
```
