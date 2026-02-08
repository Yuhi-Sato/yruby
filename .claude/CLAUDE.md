# CLAUDE.md

このファイルはClaude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## プロジェクト概要

YRubyはCRubyのYARV (Yet Another Ruby VM) アーキテクチャに基づくRuby仮想マシン実装です。Prism gemでパースし、スタックベースのバイトコードインタプリタを実装しています。

## アーキテクチャ

### 実行フロー
```
ソースコード → Parser (Prism) → AST → Compile → Iseq → VM実行 → 結果
```

### ディレクトリ構造 (YRuby ↔ CRuby 対応)

```
lib/
├── yruby.rb                    #   vm.c, vm_exec.c (VM本体、実行ループ)
└── yruby/
    ├── core.rb                 #   vm_core.h (データ構造定義、依存関係の起点)
    │   ├── ExecutionContext    #    └─ rb_execution_context_struct
    │   └── ControlFrame        #    └─ rb_control_frame_struct
    ├── parser.rb               #   parse.y (Prismラッパー)
    ├── compile.rb              #   compile.c (ASTからバイトコードへ)
    ├── iseq.rb                 #   iseq.c, iseq.h (命令シーケンス)
    ├── insns.rb                #   insns.def (命令定義の集約)
    └── insns/                  #   insns.def (個別命令の実装)
```
