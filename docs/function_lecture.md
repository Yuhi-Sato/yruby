# 関数の定義と実行 — YRuby で学ぶ Ruby VM の仕組み

## 概要

```
ソースコード → パース → AST → コンパイル → 命令列(Iseq) → VM 実行
```

YRuby はこのパイプラインで Ruby を実行します。
本資料では **関数（メソッド）の定義** と **関数の実行** に絞って、各ステップで何が起きるかを追います。

---

## 1. 関数の定義 (`def`)

### Ruby コード

```ruby
def add(a, b)
  a + b
end
add(1, 2)
```

### Step 1 — パース（AST の生成）

Prism パーサーが上記コードを解析し、以下のような AST を生成します。

```
ProgramNode
└── StatementsNode
    ├── DefNode              ← def add(a, b)
    │   ├── name: :add
    │   ├── parameters: (a, b)
    │   └── body: StatementsNode
    │       └── CallNode(:+)  ← a + b
    └── CallNode(:add)       ← add(1, 2)
        └── arguments: (1, 2)
```

### Step 2 — コンパイル（Iseq の生成）

コンパイラ (`compile.rb`) は AST を走査し、`DefNode` に対して `compile_def_node` を呼びます。

```ruby
# compile.rb
def compile_def_node(iseq, node)
  method_iseq = YRuby::Iseq.iseq_new_method(node)          # メソッド用の Iseq を別途生成
  iseq.emit(YRuby::Insns::Definemethod, node.name, method_iseq)  # definemethod 命令を出力
  iseq.emit(YRuby::Insns::Putobject, node.name)             # 戻り値 :add をスタックに積む
end
```

**トップレベルの Iseq（メインスクリプト用）:**

```
0000 definemethod  :add, <ISeq:add>   ← メソッドを登録
0003 putobject     :add               ← def 式の戻り値
0005 opt_send_without_block  <cd: add, argc:2>   ← add(1, 2)
0007 leave
```

**メソッド用の Iseq（`add` メソッド内）:**

```ruby
# iseq.rb
def self.iseq_new_method(def_node)
  iseq = new
  Compile.new.iseq_compile_method(iseq, def_node)  # メソッド本体をコンパイル
  iseq.emit(Insns::Leave)
  iseq.argc = params ? params.requireds.size : 0   # 引数の数を記録
  iseq
end
```

```
== disasm: add ==
0000 getlocal  0    ← a を読み出す
0002 getlocal  1    ← b を読み出す
0004 opt_plus       ← a + b
0005 leave          ← 結果を返す
```

### disasm で確認する

```ruby
vm = YRuby.new
parser = YRuby::Parser.new
iseq = YRuby::Iseq.iseq_new_main(parser.parse(<<~RUBY))
  def add(a, b)
    a + b
  end
  add(1, 2)
RUBY
puts iseq.disasm
```

---

## 2. 関数の実行

### Step 3 — `definemethod` 命令の実行

VM のメインループが `definemethod` 命令を読むと、メソッドをクラスに登録します。

```ruby
# insns/definemethod.rb
def self.call(vm, mid, iseq)
  vm.define_method(mid, iseq)
end

# insnhelper.rb
def define_method(mid, iseq)
  klass = cfp.self_value.klass   # 現在の self のクラスを取得
  klass.add_method_iseq(mid, iseq)  # メソッドテーブルに登録
end
```

### Step 4 — `opt_send_without_block` 命令の実行（メソッド呼び出し）

`add(1, 2)` が呼ばれると `opt_send_without_block` 命令が実行されます。

```ruby
# insns/opt_send_without_block.rb
def self.call(vm, cd)
  vm.sendish(cd)
end

# insnhelper.rb
def sendish(cd)
  argc = cd.argc
  recv = topn(argc + 1)              # レシーバーをスタックから取得

  klass = recv.klass
  method_iseq = klass.search_method(cd.mid)  # メソッドテーブルを検索

  raise "undefined method #{cd.mid}" if method_iseq.nil?

  call_iseq_setup(recv, argc, method_iseq)   # 新しいフレームを積む
end
```

### Step 5 — フレームの切り替え

`call_iseq_setup` が新しい **コントロールフレーム (ControlFrame)** を積み、VM がメソッドの Iseq を実行します。

```ruby
def call_iseq_setup(recv, argc, method_iseq)
  argv_index = cfp.sp - argc    # 引数の先頭位置
  recv_index = argv_index - 1   # レシーバーの位置

  cfp.sp = recv_index           # 呼び出し元 SP を巻き戻す

  push_frame(
    iseq:       method_iseq,
    type:       FRAME_TYPE_METHOD,
    self_value: recv,
    sp:         argv_index,
    local_size: method_iseq.local_table_size - method_iseq.argc
  )
end
```

### スタックのイメージ（`add(1, 2)` 呼び出し時）

```
呼び出し前のスタック:
┌──────────────────────────────────────┐
│ ... │ self │  1  │  2  │            │
│      ↑recv  ↑arg1  ↑arg2             │
│                    ↑ SP             │
└──────────────────────────────────────┘

call_iseq_setup 実行後（メソッドフレーム作成）:
┌──────────────────────────────────────┐
│ ... │  a  │  b  │                   │  ← ローカル変数領域
│      ↑ep         ↑ SP（新フレーム）   │
└──────────────────────────────────────┘
  a = 1, b = 2 が ep を基準に格納される
```

### Step 6 — `leave` 命令で戻る

メソッドの Iseq 末尾の `leave` 命令が実行されると、フレームをポップして呼び出し元に戻ります。

```ruby
# insns/leave.rb → pop_frame を呼ぶ
def pop_frame
  frames.pop
  self.cfp = frames.last    # 呼び出し元のフレームに戻る
end
```

---

## 3. フローまとめ

```
def add(a, b)        →  compile_def_node
  a + b              →    iseq_new_method  →  [getlocal, getlocal, opt_plus, leave]
end                  →  definemethod 命令 → klass.method_table[:add] = <ISeq>

add(1, 2)            →  opt_send_without_block
                     →    sendish → search_method(:add)
                     →    call_iseq_setup → push_frame (FRAME_TYPE_METHOD)
                     →    VM ループがメソッド Iseq を実行
                     →    leave → pop_frame → 戻り値をスタックに残す
```

---

## 4. 関連ファイル早見表

| ファイル | 役割 |
|---|---|
| `lib/yruby/compile.rb` | `DefNode` → `definemethod` 命令への変換 |
| `lib/yruby/iseq.rb` | 命令列の生成・`iseq_new_method` |
| `lib/yruby/insnhelper.rb` | `define_method` / `sendish` / `call_iseq_setup` |
| `lib/yruby/insns/definemethod.rb` | `definemethod` 命令の実装 |
| `lib/yruby/insns/opt_send_without_block.rb` | メソッド呼び出し命令の実装 |
| `lib/yruby/insns/leave.rb` | フレームからの返却 |
| `lib/yruby/rclass.rb` | メソッドテーブルの管理 |
