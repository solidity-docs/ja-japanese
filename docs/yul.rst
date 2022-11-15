.. _yul:

###
Yul
###

.. index:: ! assembly, ! asm, ! evmasm, ! yul, julia, iulia

Yul（以前はJULIAやIULIAとも呼ばれていました）は、さまざまなバックエンド用のバイトコードにコンパイルできる中間言語です。

EVM1.0、EVM1.5、Ewasmのサポートが予定されており、3つのプラットフォームの共通項として使えるように設計されています。
YulはすでにスタンドアローンモードやSolidity内の「インラインアセンブリ」で使用でき、中間言語としてYulを使用するSolidityコンパイラの実験的な実装もあります。
Yulは、すべてのターゲットプラットフォームに等しく恩恵を与えられる高レベルの最適化ステージの良いターゲットです。

モチベーションと高レベルの記述
==============================

Yulの設計は、次の目標を達成しようと試みています。

1. Yulで書かれたプログラムは、たとえそれがSolidityや他の高級言語のコンパイラで生成されたコードであっても、可読性がなければいけません。
2. 手動での検査、形式的な検証、最適化に役立つように、制御フローは理解しやすいものでなければなりません。
3. Yulからバイトコードへの変換は、可能な限り簡単に行う必要があります。
4. Yulは、プログラム全体の最適化に適しているべきです。

1つ目と2つ目の目標を達成するために、Yulは ``for`` ループ、 ``if`` 文、 ``switch`` 文、関数呼び出しといった高レベルの要素を提供しています。
アセンブリプログラムの制御フローを適切に表現するためには、これらで十分なはずです。
したがって、 ``SWAP`` 、 ``DUP`` 、 ``JUMPDEST`` 、 ``JUMP`` 、 ``JUMPI`` の明示的なステートメントは用意されていません。
なぜなら、最初の2つはデータフローを難読化し、最後の2つは制御フローを難読化するからです。
さらに、 ``mul(add(x, y), 7)`` 形式の関数ステートメントは ``7 y x add mul`` のような純粋なオペコード文よりも好まれます。
なぜなら、前の形式ではどのオペランドがどのオペコードに使用されているかがわかりやすいからです。

スタックマシン用に設計されているにもかかわらず、Yulはスタック自体の複雑さが現れることがありません。
プログラマーや監査人は、スタックのことを気にする必要はありません。

3つ目の目標は、高レベルの構造体を非常に規則的な方法でバイトコードにコンパイルすることで達成されます。
アセンブラが行う唯一の非ローカルな操作は、ユーザー定義の識別子（関数、変数、...）の名前のルックアップと、スタックからのローカル変数のクリーンアップです。

.. To avoid confusions between concepts like values and references, Yul is statically typed.

値か参照かのような混乱を避けるために、Yulは静的に型付けされています。
また、デフォルトの型（通常はターゲットマシンの整数ワード）があり、可読性のために常に省略できます。

.. To keep the language simple and flexible, Yul does not have any built-in operations, functions or types in its pure form. 
.. These are added together with their semantics when specifying a dialect of Yul, which allows specializing Yul to the requirements of different target platforms and feature sets.

言語をシンプルかつ柔軟に保つために、Yulは純粋な形では組み込みの操作や関数、型を持っていません。
これらはYulの方言を指定する際に、そのセマンティクスとともに追加されます。
これにより、さまざまなターゲットプラットフォームや機能セットの要件に合わせて、Yulを特殊化できます。

.. Currently, there is only one specified dialect of Yul. This dialect uses the EVM opcodes as builtin functions

現在、Yulの方言は1つだけ指定されています。
この方言では、EVMのオペコードを組み込み関数として使用し（下記参照）、EVMのネイティブな256ビット型である ``u256`` 型のみを定義しています。
そのため、以下の例では型を記述していません。

シンプルな例
============

.. The following example program is written in the EVM dialect and computes exponentiation.
.. It can be compiled using ``solc --strict-assembly``. The builtin functions
.. ``mul`` and ``div`` compute product and division, respectively.

以下のサンプルプログラムはEVM方言で書かれており、指数計算を行います。 ``solc --strict-assembly`` を使ってコンパイルできます。組み込み関数 ``mul`` と ``div`` は、それぞれ積と除算を計算します。

.. code-block:: yul

    {
        function power(base, exponent) -> result
        {
            switch exponent
            case 0 { result := 1 }
            case 1 { result := base }
            default
            {
                result := power(mul(base, base), div(exponent, 2))
                switch mod(exponent, 2)
                    case 1 { result := mul(base, result) }
            }
        }
    }

.. It is also possible to implement the same function using a for-loop
.. instead of with recursion. Here, ``lt(a, b)`` computes whether ``a`` is less than ``b``.
.. less-than comparison.

また、同じ関数を再帰ではなく、forループを使って実装することも可能です。ここでは、 ``lt(a, b)`` は ``a`` が ``b`` より小さいかどうかを計算します。 小数点以下の比較。

.. code-block:: yul

    {
        function power(base, exponent) -> result
        {
            result := 1
            for { let i := 0 } lt(i, exponent) { i := add(i, 1) }
            {
                result := mul(result, base)
            }
        }
    }

.. At the :ref:`end of the section <erc20yul>`, a complete implementation of
.. the ERC-20 standard can be found.

:ref:`end of the section <erc20yul>` では、ERC-20規格の完全な実装が見られます。

Stand-Alone Usage
=================

.. You can use Yul in its stand-alone form in the EVM dialect using the Solidity compiler.
.. This will use the :ref:`Yul object notation <yul-object>` so that it is possible to refer
.. to code as data to deploy contracts. This Yul mode is available for the commandline compiler
.. (use ``--strict-assembly``) and for the :ref:`standard-json interface <compiler-api>`:

Yulは、Solidityコンパイラを使用して、EVM方言でスタンドアローンの形で使用できます。
これは :ref:`Yul object notation <yul-object>` を使用するので、コードをデータとして参照してコントラクトをデプロイすることが可能です。
このYulモードは、コマンドラインコンパイラ（ ``--strict-assembly`` を使用）と :ref:`standard-json interface <compiler-api>` で使用できます。

.. code-block:: json

    {
        "language": "Yul",
        "sources": { "input.yul": { "content": "{ sstore(0, 1) }" } },
        "settings": {
            "outputSelection": { "*": { "*": ["*"], "": [ "*" ] } },
            "optimizer": { "enabled": true, "details": { "yul": true } }
        }
    }

.. .. warning::

..     Yul is in active development and bytecode generation is only fully implemented for the EVM dialect of Yul
..     with EVM 1.0 as target.

.. warning::

    Yulは現在開発中で、バイトコード生成はEVM 1.0をターゲットとしたYulのEVM方言に対してのみ完全に実装されています。

Informal Description of Yul
===========================

.. In the following, we will talk about each individual aspect
.. of the Yul language. In examples, we will use the default EVM dialect.

以下では、Yul言語の個々の側面について説明します。例では、デフォルトのEVM方言を使用します。

Syntax
------

.. Yul parses comments, literals and identifiers in the same way as Solidity,
.. so you can e.g. use ``//`` and ``/* */`` to denote comments.
.. There is one exception: Identifiers in Yul can contain dots: ``.``.

YulはSolidityと同じようにコメント、リテラル、識別子を解析しますので、例えば ``//`` や ``/* */`` をコメントの意味で使うことができます。ただし、ひとつだけ例外があります。Yulの識別子はドットを含むことができます。 ``.`` です。

.. Yul can specify "objects" that consist of code, data and sub-objects.
.. Please see :ref:`Yul Objects <yul-object>` below for details on that.
.. In this section, we are only concerned with the code part of such an object.
.. This code part always consists of a curly-braces
.. delimited block. Most tools support specifying just a code block
.. where an object is expected.

Yulは、コード、データ、サブオブジェクトからなる「オブジェクト」を指定できます。その詳細については下記の :ref:`Yul Objects <yul-object>` をご覧ください。このセクションでは、そのようなオブジェクトのコード部分についてのみ説明します。このコード部分は、常に中括弧で区切られたブロックで構成されています。ほとんどのツールは、オブジェクトが期待されるコードブロックだけの指定をサポートしています。

.. Inside a code block, the following elements can be used
.. (see the later sections for more details):

コードブロック内では、以下のような要素が使用できます（詳細は後述します）。

.. - literals, i.e. ``0x123``, ``42`` or ``"abc"`` (strings up to 32 characters)

- ``0x123`` 、 ``42`` 、 ``"abc"`` などのリテラル（最大32文字までの文字列）

.. - calls to builtin functions, e.g. ``add(1, mload(0))``

- 内蔵関数の呼び出し（例:  ``add(1, mload(0))``

.. - variable declarations, e.g. ``let x := 7``, ``let x := add(y, 3)`` or ``let x`` (initial value of 0 is assigned)

- ``let x := 7`` 、 ``let x := add(y, 3)`` 、 ``let x`` などの変数宣言（初期値として0が割り当てられる）

.. - identifiers (variables), e.g. ``add(3, x)``

- 識別子（変数）、例:  ``add(3, x)``

.. - assignments, e.g. ``x := add(y, 3)``

- アサインメント、例:  ``x := add(y, 3)``

.. - blocks where local variables are scoped inside, e.g. ``{ let x := 3 { let y := add(x, 1) } }``

- ブロックで、ローカル変数が内部にスコープされている場合、例えば、 ``{ let x := 3 { let y := add(x, 1) } }``

.. - if statements, e.g. ``if lt(a, b) { sstore(0, 1) }``

- if文、例えば ``if lt(a, b) { sstore(0, 1) }``

.. - switch statements, e.g. ``switch mload(0) case 0 { revert() } default { mstore(0, 1) }``

- スイッチステートメント、例:  ``switch mload(0) case 0 { revert() } default { mstore(0, 1) }``

.. - for loops, e.g. ``for { let i := 0} lt(i, 10) { i := add(i, 1) } { mstore(i, 7) }``

- ループのために、例えば、 ``for { let i := 0} lt(i, 10) { i := add(i, 1) } { mstore(i, 7) }``

.. - function definitions, e.g. ``function f(a, b) -> c { c := add(a, b) }``

- 関数の定義（例:  ``function f(a, b) -> c { c := add(a, b) }`` ）。

.. Multiple syntactical elements can follow each other simply separated by
.. whitespace, i.e. there is no terminating ``;`` or newline required.

複数の構文要素は、空白で区切られているだけで、互いに続くことができます。つまり、終端の ``;`` や改行は必要ありません。

Literals
--------

.. As literals, you can use:

リテラルとしては

.. - Integer constants in decimal or hexadecimal notation.

- 10進数または16進数表記の整数定数。

.. - ASCII strings (e.g. ``"abc"``), which may contain hex escapes ``\xNN`` and Unicode escapes ``\uNNNN`` where ``N`` are hexadecimal digits.

- ASCII文字列（例:  ``"abc"`` ）は、 ``N`` が16進数である場合、16進数エスケープ ``\xNN`` とUnicodeエスケープ ``\uNNNN`` を含むことができます。

.. - Hex strings (e.g. ``hex"616263"``).

- 16進数の文字列（例:  ``hex"616263"`` ）。

.. In the EVM dialect of Yul, literals represent 256-bit words as follows:

EVMの方言であるYulでは、リテラルは以下のように256ビットの単語を表します。

.. - Decimal or hexadecimal constants must be less than ``2**256``.
..   They represent the 256-bit word with that value as an unsigned integer in big endian encoding.

- 10進数または16進数の定数は、 ``2**256`` より小さい値でなければなりません。   これらの定数は、その値を持つ256ビットのワードを、ビッグエンディアンエンコーディングの符号なし整数として表します。

.. - An ASCII string is first viewed as a byte sequence, by viewing
..   a non-escape ASCII character as a single byte whose value is the ASCII code,
..   an escape ``\xNN`` as single byte with that value, and
..   an escape ``\uNNNN`` as the UTF-8 sequence of bytes for that code point.
..   The byte sequence must not exceed 32 bytes.
..   The byte sequence is padded with zeros on the right to reach 32 bytes in length;
..   in other words, the string is stored left-aligned.
..   The padded byte sequence represents a 256-bit word whose most significant 8 bits are the ones from the first byte,
..   i.e. the bytes are interpreted in big endian form.

- ASCII文字列は、まずバイト列として見ることができます。すなわち、エスケープされていないASCII文字はASCIIコードを値とする1バイトと見なし、エスケープ ``\xNN`` はその値を持つ1バイトと見なし、エスケープ ``\uNNNN`` はそのコードポイントに対するUTF-8のバイト列と見なします。   バイト列は32バイトを超えてはなりません。   バイト列は32バイトになるように右に0をパディングして、文字列を左詰めで格納します。   パディングされたバイト列は256ビットの単語を表し、最上位の8ビットは最初のバイトのものになります、つまりバイトはビッグエンディアン形式で解釈されます。

.. - A hex string is first viewed as a byte sequence, by viewing
..   each pair of contiguous hex digits as a byte.
..   The byte sequence must not exceed 32 bytes (i.e. 64 hex digits), and is treated as above.

- 16進文字列は、まず、連続した16進数の各組を1バイトと見なして、バイト列として表示されます。   バイト列は32バイト（つまり64個の16進数）を超えてはならず、上記のように扱われます。

.. When compiling for the EVM, this will be translated into an
.. appropriate ``PUSHi`` instruction. In the following example,
.. ``3`` and ``2`` are added resulting in 5 and then the
.. bitwise ``and`` with the string "abc" is computed.
.. The final value is assigned to a local variable called ``x``.

EVM用にコンパイルした場合、これは適切な ``PUSHi`` 命令に変換されます。次の例では、 ``3`` と ``2`` を足して5とし、文字列 "abc "のビット単位の ``and`` を計算しています。最終的な値は、 ``x`` というローカル変数に割り当てられます。

.. The 32-byte limit above does not apply to string literals passed to builtin functions that require
.. literal arguments (e.g. ``setimmutable`` or ``loadimmutable``). Those strings never end up in the
.. generated bytecode.

上記の32バイトの制限は、リテラル引数を必要とする組み込み関数に渡される文字列リテラルには適用されません（例:  ``setimmutable`` や ``loadimmutable`` ）。これらの文字列は、生成されるバイトコードには含まれません。

.. code-block:: yul

    let x := and("abc", add(3, 2))

.. Unless it is the default type, the type of a literal
.. has to be specified after a colon:

デフォルトの型でない限り、リテラルの型はコロンの後に指定する必要があります。

.. code-block:: yul

    // This will not compile (u32 and u256 type not implemented yet)
    let x := and("abc":u32, add(3:u256, 2:u256))

Function Calls
--------------

.. Both built-in and user-defined functions (see below) can be called
.. in the same way as shown in the previous example.
.. If the function returns a single value, it can be directly used
.. inside an expression again. If it returns multiple values,
.. they have to be assigned to local variables.

組み込み関数もユーザー定義関数（下記参照）も、前の例で示したのと同じ方法で呼び出すことができます。関数が単一の値を返す場合は、再び式の中で直接使用できます。複数の値を返す場合は、ローカル変数に代入する必要があります。

.. code-block:: yul

    function f(x, y) -> a, b { /* ... */ }
    mstore(0x80, add(mload(0x80), 3))
    // Here, the user-defined function `f` returns two values.
    let x, y := f(1, mload(0))

.. For built-in functions of the EVM, functional expressions
.. can be directly translated to a stream of opcodes:
.. You just read the expression from right to left to obtain the
.. opcodes. In the case of the first line in the example, this
.. is ``PUSH1 3 PUSH1 0x80 MLOAD ADD PUSH1 0x80 MSTORE``.

EVMの組み込み関数では、関数式をオペコードのストリームに直接変換できます。式を右から左に読むだけでオペコードが得られます。例題の1行目の場合、これは ``PUSH1 3 PUSH1 0x80 MLOAD ADD PUSH1 0x80 MSTORE`` です。

.. For calls to user-defined functions, the arguments are also
.. put on the stack from right to left and this is the order
.. in which argument lists are evaluated. The return values,
.. though, are expected on the stack from left to right,
.. i.e. in this example, ``y`` is on top of the stack and ``x``
.. is below it.

ユーザー定義関数の呼び出しでは、引数も右から左にスタックに置かれ、これが引数リストが評価される順序となります。一方、戻り値は左から右へとスタックに置かれます。つまり、この例では、 ``y`` がスタックの一番上に、 ``x`` がその下に置かれます。

Variable Declarations
---------------------

.. You can use the ``let`` keyword to declare variables.
.. A variable is only visible inside the
.. ``{...}``-block it was defined in. When compiling to the EVM,
.. a new stack slot is created that is reserved
.. for the variable and automatically removed again when the end of the block
.. is reached. You can provide an initial value for the variable.
.. If you do not provide a value, the variable will be initialized to zero.

``let`` キーワードを使って変数を宣言できます。変数は、それが定義された ``{...}`` ブロックの中でのみ表示されます。EVMへのコンパイル時には、変数のために予約された新しいスタックスロットが作成され、ブロックの終わりに達すると自動的に削除されます。変数の初期値を指定できます。値を指定しない場合は、変数はゼロに初期化されます。

.. Since variables are stored on the stack, they do not directly
.. influence memory or storage, but they can be used as pointers
.. to memory or storage locations in the built-in functions
.. ``mstore``, ``mload``, ``sstore`` and ``sload``.
.. Future dialects might introduce specific types for such pointers.

変数はスタック上に格納されるため、メモリやストレージに直接影響を与えることはありませんが、組み込み関数 ``mstore`` 、 ``mload`` 、 ``sstore`` 、 ``sload`` でメモリやストレージの位置へのポインタとして使用できます。将来の方言では、このようなポインターのための特定の型が導入されるかもしれません。

.. When a variable is referenced, its current value is copied.
.. For the EVM, this translates to a ``DUP`` instruction.

変数を参照すると、その変数の現在の値がコピーされます。EVMでは、これは ``DUP`` 命令に相当します。

.. code-block:: yul

    {
        let zero := 0
        let v := calldataload(zero)
        {
            let y := add(sload(v), 1)
            v := y
        } // y is "deallocated" here
        sstore(v, zero)
    } // v and zero are "deallocated" here

.. If the declared variable should have a type different from the default type,
.. you denote that following a colon. You can also declare multiple
.. variables in one statement when you assign from a function call
.. that returns multiple values.

宣言した変数の型がデフォルトの型と異なる場合は、コロンの後にその旨を記述します。また、複数の値を返す関数呼び出しから代入する場合、1つのステートメントで複数の変数を宣言できます。

.. code-block:: yul

    // This will not compile (u32 and u256 type not implemented yet)
    {
        let zero:u32 := 0:u32
        let v:u256, t:u32 := f()
        let x, y := g()
    }

.. Depending on the optimiser settings, the compiler can free the stack slots
.. already after the variable has been used for
.. the last time, even though it is still in scope.

オプティマイザの設定によっては、変数が最後に使用された後、まだスコープ内にあるにもかかわらず、コンパイラがスタック・スロットを解放することがあります。

Assignments
-----------

.. Variables can be assigned to after their definition using the
.. ``:=`` operator. It is possible to assign multiple
.. variables at the same time. For this, the number and types of the
.. values have to match.
.. If you want to assign the values returned from a function that has
.. multiple return parameters, you have to provide multiple variables.
.. The same variable may not occur multiple times on the left-hand side of
.. an assignment, e.g. ``x, x := f()`` is invalid.

変数は、その定義後に ``:=`` 演算子を使って代入できます。複数の変数を同時に割り当てることも可能です。そのためには、値の数と型が一致している必要があります。複数のリターンパラメーターを持つ関数から返される値を代入する場合は、複数の変数を用意する必要があります。代入の左辺に同じ変数を複数回使用できません（例:  ``x, x := f()`` は無効）。

.. code-block:: yul

    let v := 0
    // re-assign v
    v := 2
    let t := add(v, 2)
    function f() -> a, b { }
    // assign multiple values
    v, t := f()

.. If
.. --

もし--。

.. The if statement can be used for conditionally executing code.
.. No "else" block can be defined. Consider using "switch" instead (see below) if
.. you need multiple alternatives.

if文は、条件付きでコードを実行するために使用できます。else "ブロックは定義できません。複数の選択肢が必要な場合は、代わりに「switch」（後述）の使用を検討してください。

.. code-block:: yul

    if lt(calldatasize(), 4) { revert(0, 0) }

.. The curly braces for the body are required.

本体のカーリーブレスは必須です。

Switch
------

.. You can use a switch statement as an extended version of the if statement.
.. It takes the value of an expression and compares it to several literal constants.
.. The branch corresponding to the matching constant is taken.
.. Contrary to other programming languages, for safety reasons, control flow does
.. not continue from one case to the next. There can be a fallback or default
.. case called ``default`` which is taken if none of the literal constants matches.

switch文は、if文の拡張版として使うことができます。switch文は、式の値を受け取り、それをいくつかのリテラル定数と比較します。一致した定数に対応する分岐が実行されます。他のプログラミング言語とは異なり、安全上の理由から、制御の流れは1つのケースから次のケースへとは続きません。 ``default`` と呼ばれるフォールバックまたはデフォルトのケースがあり、リテラル定数のどれにもマッチしない場合に実行されます。

.. code-block:: yul

    {
        let x := 0
        switch calldataload(4)
        case 0 {
            x := calldataload(0x24)
        }
        default {
            x := calldataload(0x44)
        }
        sstore(0, div(x, 2))
    }

.. The list of cases is not enclosed by curly braces, but the body of a
.. case does require them.

ケースのリストは中括弧で囲まれていませんが、ケースの本文では中括弧が必要です。

Loops
-----

.. Yul supports for-loops which consist of
.. a header containing an initializing part, a condition, a post-iteration
.. part and a body. The condition has to be an expression, while
.. the other three are blocks. If the initializing part
.. declares any variables at the top level, the scope of these variables extends to all other
.. parts of the loop.

Yulは、初期化部分を含むヘッダー、条件、反復後の部分、ボディからなるforループをサポートしています。条件は式でなければならず、他の3つはブロックです。初期化部でトップレベルの変数が宣言されている場合、その変数のスコープはループの他のすべての部分にまで及びます。

.. The ``break`` and ``continue`` statements can be used in the body to exit the loop
.. or skip to the post-part, respectively.

``break`` 文と ``continue`` 文は、それぞれループを終了させたり、後の部分に飛ばしたりするために本体で使用できます。

.. The following example computes the sum of an area in memory.

次の例では、メモリ上のある領域の和を計算します。

.. code-block:: yul

    {
        let x := 0
        for { let i := 0 } lt(i, 0x100) { i := add(i, 0x20) } {
            x := add(x, mload(i))
        }
    }

.. For loops can also be used as a replacement for while loops:
.. Simply leave the initialization and post-iteration parts empty.

Forループはwhileループの代用としても使用できます。初期化部分と反復後の部分を空にするだけです。

.. code-block:: yul

    {
        let x := 0
        let i := 0
        for { } lt(i, 0x100) { } {     // while(i < 0x100)
            x := add(x, mload(i))
            i := add(i, 0x20)
        }
    }

Function Declarations
---------------------

.. Yul allows the definition of functions. These should not be confused with functions
.. in Solidity since they are never part of an external interface of a contract and
.. are part of a namespace separate from the one for Solidity functions.

Yulでは、関数の定義が可能です。これらはコントラクトの外部インターフェースの一部ではなく、Solidityの関数とは別の名前空間に属しているので、Solidityの関数と混同してはいけません。

.. For the EVM, Yul functions take their
.. arguments (and a return PC) from the stack and also put the results onto the
.. stack. User-defined functions and built-in functions are called in exactly the same way.

EVMでは、Yul関数はスタックから引数（およびリターンPC）を取り、また結果をスタックに置きます。ユーザー定義関数や組み込み関数も全く同じように呼び出されます。

.. Functions can be defined anywhere and are visible in the block they are
.. declared in. Inside a function, you cannot access local variables
.. defined outside of that function.

関数はどこでも定義でき、宣言されたブロック内で表示されます。関数の内部では、その関数の外部で定義されたローカル変数にアクセスできません。

.. Functions declare parameters and return variables, similar to Solidity.
.. To return a value, you assign it to the return variable(s).

関数はSolidityと同様に、パラメータとリターン変数を宣言します。値を返すには、その値を戻り値の変数に代入します。

.. If you call a function that returns multiple values, you have to assign
.. them to multiple variables using ``a, b := f(x)`` or ``let a, b := f(x)``.

複数の値を返す関数を呼び出した場合は、 ``a, b := f(x)`` や ``let a, b := f(x)`` を使って複数の変数に割り当てる必要があります。

.. The ``leave`` statement can be used to exit the current function. It
.. works like the ``return`` statement in other languages just that it does
.. not take a value to return, it just exits the functions and the function
.. will return whatever values are currently assigned to the return variable(s).

``leave`` ステートメントは、現在の関数を終了するために使用できます。他の言語の ``return`` ステートメントと同じように動作しますが、戻り値を取らずに関数を終了し、関数は戻り値の変数に現在割り当てられている値を返します。

.. Note that the EVM dialect has a built-in function called ``return`` that
.. quits the full execution context (internal message call) and not just
.. the current yul function.

EVM方言には ``return`` という組み込み関数があり、現在のユルユルの関数だけでなく、完全な実行コンテキスト（内部メッセージコール）を終了させることができることに注意してください。

.. The following example implements the power function by square-and-multiply.

次の例では、2乗と3乗によるパワー関数を実装しています。

.. code-block:: yul

    {
        function power(base, exponent) -> result {
            switch exponent
            case 0 { result := 1 }
            case 1 { result := base }
            default {
                result := power(mul(base, base), div(exponent, 2))
                switch mod(exponent, 2)
                    case 1 { result := mul(base, result) }
            }
        }
    }

Specification of Yul
====================

.. This chapter describes Yul code formally. Yul code is usually placed inside Yul objects,
.. which are explained in their own chapter.

この章では、Yulのコードを正式に説明します。Yulコードは通常、Yulオブジェクトの中に配置されますが、それらについてはそれぞれの章で説明します。

.. code-block:: none

    Block = '{' Statement* '}'
    Statement =
        Block |
        FunctionDefinition |
        VariableDeclaration |
        Assignment |
        If |
        Expression |
        Switch |
        ForLoop |
        BreakContinue |
        Leave
    FunctionDefinition =
        'function' Identifier '(' TypedIdentifierList? ')'
        ( '->' TypedIdentifierList )? Block
    VariableDeclaration =
        'let' TypedIdentifierList ( ':=' Expression )?
    Assignment =
        IdentifierList ':=' Expression
    Expression =
        FunctionCall | Identifier | Literal
    If =
        'if' Expression Block
    Switch =
        'switch' Expression ( Case+ Default? | Default )
    Case =
        'case' Literal Block
    Default =
        'default' Block
    ForLoop =
        'for' Block Expression Block Block
    BreakContinue =
        'break' | 'continue'
    Leave = 'leave'
    FunctionCall =
        Identifier '(' ( Expression ( ',' Expression )* )? ')'
    Identifier = [a-zA-Z_$] [a-zA-Z_$0-9.]*
    IdentifierList = Identifier ( ',' Identifier)*
    TypeName = Identifier
    TypedIdentifierList = Identifier ( ':' TypeName )? ( ',' Identifier ( ':' TypeName )? )*
    Literal =
        (NumberLiteral | StringLiteral | TrueLiteral | FalseLiteral) ( ':' TypeName )?
    NumberLiteral = HexNumber | DecimalNumber
    StringLiteral = '"' ([^"\r\n\\] | '\\' .)* '"'
    TrueLiteral = 'true'
    FalseLiteral = 'false'
    HexNumber = '0x' [0-9a-fA-F]+
    DecimalNumber = [0-9]+

Restrictions on the Grammar
---------------------------

.. Apart from those directly imposed by the grammar, the following
.. restrictions apply:

文法によって直接課せられるものとは別に、以下のような制限があります。

.. Switches must have at least one case (including the default case).
.. All case values need to have the same type and distinct values.
.. If all possible values of the expression type are covered, a default case is
.. not allowed (i.e. a switch with a ``bool`` expression that has both a
.. true and a false case do not allow a default case).

スイッチには、少なくとも1つのケース（デフォルトのケースを含む）が必要です。すべてのケースの値は、同じ型で明確な値を持つ必要があります。式の型のすべての可能な値がカバーされている場合、デフォルトのケースは許可されません（つまり、trueとfalseの両方のケースを持つ ``bool`` 式のスイッチは、デフォルトのケースを許可しません）。

.. Every expression evaluates to zero or more values. Identifiers and Literals
.. evaluate to exactly
.. one value and function calls evaluate to a number of values equal to the
.. number of return variables of the function called.

すべての式は0個以上の値で評価されます。識別子とリテラルは正確に1つの値に評価され、関数呼び出しは呼び出された関数の戻り変数の数に等しい数の値に評価されます。

.. In variable declarations and assignments, the right-hand-side expression
.. (if present) has to evaluate to a number of values equal to the number of
.. variables on the left-hand-side.
.. This is the only situation where an expression evaluating
.. to more than one value is allowed.
.. The same variable name cannot occur more than once in the left-hand-side of
.. an assignment or variable declaration.

変数宣言や代入では、右辺の式（存在する場合）は、左辺の変数の数と同じ数の値に評価されなければなりません。これは、複数の値に評価される式が許される唯一の状況です。代入や変数宣言の左辺には、同じ変数名を複数回使用できません。

.. Expressions that are also statements (i.e. at the block level) have to
.. evaluate to zero values.

ステートメントでもある式（ブロックレベル）は、ゼロ値に評価されなければなりません。

.. In all other situations, expressions have to evaluate to exactly one value.

それ以外の状況では、式は正確に1つの値に評価されなければなりません。

A ``continue`` or ``break`` statement can only be used inside the body of a for-loop, as follows.
Consider the innermost loop that contains the statement.
The loop and the statement must be in the same function, or both must be at the top level.
The statement must be in the loop's body block;
it cannot be in the loop's initialization block or update block.
It is worth emphasizing that this restriction applies just
to the innermost loop that contains the ``continue`` or ``break`` statement:
this innermost loop, and therefore the ``continue`` or ``break`` statement,
may appear anywhere in an outer loop, possibly in an outer loop's initialization block or update block.
For example, the following is legal,
because the ``break`` occurs in the body block of the inner loop,
despite also occurring in the update block of the outer loop:

.. code-block:: yul

    for {} true { for {} true {} { break } }
    {
    }

.. The condition part of the for-loop has to evaluate to exactly one value.

for-loopのcondition部分は、正確に1つの値に評価されなければなりません。

.. The ``leave`` statement can only be used inside a function.

``leave`` ステートメントは、関数内でのみ使用できます。

.. Functions cannot be defined anywhere inside for loop init blocks.

関数はfor loop initブロック内のどこにも定義できません。

.. Literals cannot be larger than their type. The largest type defined is 256-bit wide.

リテラルはその型より大きくできません。定義されている最大の型は256ビット幅です。

.. During assignments and function calls, the types of the respective values have to match.
.. There is no implicit type conversion. Type conversion in general can only be achieved
.. if the dialect provides an appropriate built-in function that takes a value of one
.. type and returns a value of a different type.

代入や関数呼び出しの際には、それぞれの値の型が一致していなければなりません。暗黙の型変換はありません。一般に、型の変換は、ある型の値を受け取り、異なる型の値を返す適切な組み込み関数を方言が提供している場合にのみ実現します。

Scoping Rules
-------------

.. Scopes in Yul are tied to Blocks (exceptions are functions and the for loop
.. as explained below) and all declarations
.. (``FunctionDefinition``, ``VariableDeclaration``)
.. introduce new identifiers into these scopes.

Yulでは、スコープはブロックに関連付けられており（例外として、後述する関数やforループがあります）、すべての宣言（ ``FunctionDefinition`` 、 ``VariableDeclaration`` ）は、これらのスコープに新しい識別子を導入します。

.. Identifiers are visible in
.. the block they are defined in (including all sub-nodes and sub-blocks):
.. Functions are visible in the whole block (even before their definitions) while
.. variables are only visible starting from the statement after the ``VariableDeclaration``.

識別子は、定義されているブロック（すべてのサブノードとサブブロックを含む）で見ることができます。関数はブロック全体（定義前も含む）で見ることができますが、変数は ``VariableDeclaration`` の後のステートメントからしか見ることができません。

.. In particular,
.. variables cannot be referenced in the right hand side of their own variable
.. declaration.
.. Functions can be referenced already before their declaration (if they are visible).

特に、変数は自分の変数宣言の右側では参照できません。関数は、その宣言の前にすでに参照できます（関数が表示されている場合）。

.. As an exception to the general scoping rule, the scope of the "init" part of the for-loop
.. (the first block) extends across all other parts of the for loop.
.. This means that variables (and functions) declared in the init part (but not inside a
.. block inside the init part) are visible in all other parts of the for-loop.

一般的なスコープルールの例外として、forループの「init」部分（最初のブロック）のスコープは、forループの他のすべての部分に及びます。つまり、init部で宣言された変数（および関数）は、forループの他のすべての部分で見ることができます（init部内のブロックには宣言されていません）。

.. Identifiers declared in the other parts of the for loop respect the regular
.. syntactical scoping rules.

forループの他の部分で宣言された識別子は、通常の構文上のスコープルールに従います。

.. This means a for-loop of the form ``for { I... } C { P... } { B... }`` is equivalent
.. to ``{ I... for {} C { P... } { B... } }``.

これは、 ``for { I... } C { P... } { B... }`` という形式のforループが ``{ I... for {} C { P... } { B... } }`` と同等であることを意味しています。

.. The parameters and return parameters of functions are visible in the
.. function body and their names have to be distinct.

関数のパラメータとリターンパラメータは、関数本体に表示され、それらの名前は明確でなければなりません。

.. Inside functions, it is not possible to reference a variable that was declared
.. outside of that function.

関数内では、その関数の外で宣言された変数を参照できません。

.. Shadowing is disallowed, i.e. you cannot declare an identifier at a point
.. where another identifier with the same name is also visible, even if it is
.. not possible to reference it because it was declared outside the current function.

シャドーイングは禁止されています。つまり、現在の関数の外で宣言されたために参照できなくても、同じ名前の別の識別子が見える場所で識別子を宣言できません。

Formal Specification
--------------------

.. We formally specify Yul by providing an evaluation function E overloaded
.. on the various nodes of the AST. As builtin functions can have side effects,
.. E takes two state objects and the AST node and returns two new
.. state objects and a variable number of other values.
.. The two state objects are the global state object
.. (which in the context of the EVM is the memory, storage and state of the
.. blockchain) and the local state object (the state of local variables, i.e. a
.. segment of the stack in the EVM).

ASTの様々なノード上でオーバーロードされた評価関数Eを提供することで、Yulを正式に規定する。組み込み関数には副作用があるため、Eは2つの状態オブジェクトとASTノードを受け取り、2つの新しい状態オブジェクトと可変数の他の値を返します。2つの状態オブジェクトとは、グローバル状態オブジェクト（EVMの文脈では、ブロックチェーンのメモリ、ストレージ、状態）と、ローカル状態オブジェクト（ローカル変数の状態、つまりEVMのスタックのセグメント）です。

.. If the AST node is a statement, E returns the two state objects and a "mode",
.. which is used for the ``break``, ``continue`` and ``leave`` statements.
.. If the AST node is an expression, E returns the two state objects and
.. as many values as the expression evaluates to.

ASTノードがステートメントの場合、Eは2つの状態オブジェクトと ``break`` 、 ``continue`` 、 ``leave`` ステートメントで使用される「モード」を返します。ASTノードが式の場合、Eは2つの状態オブジェクトと式の評価値の数だけの値を返します。

.. The exact nature of the global state is unspecified for this high level
.. description. The local state ``L`` is a mapping of identifiers ``i`` to values ``v``,
.. denoted as ``L[i] = v``.

グローバルな状態の正確な性質は、この高レベルの説明では指定されていません。ローカルステート ``L`` は、識別子 ``i`` から値 ``v`` へのマッピングであり、 ``L[i] = v`` と表記される。

.. For an identifier ``v``, let ``$v`` be the name of the identifier.

識別子 ``v`` に対して、識別子の名前を ``$v`` とする。

.. We will use a destructuring notation for the AST nodes.

ここでは、ASTのノードにデストラクション記法を用います。

.. code-block:: none

    E(G, L, <{St1, ..., Stn}>: Block) =
        let G1, L1, mode = E(G, L, St1, ..., Stn)
        let L2 be a restriction of L1 to the identifiers of L
        G1, L2, mode
    E(G, L, St1, ..., Stn: Statement) =
        if n is zero:
            G, L, regular
        else:
            let G1, L1, mode = E(G, L, St1)
            if mode is regular then
                E(G1, L1, St2, ..., Stn)
            otherwise
                G1, L1, mode
    E(G, L, FunctionDefinition) =
        G, L, regular
    E(G, L, <let var_1, ..., var_n := rhs>: VariableDeclaration) =
        E(G, L, <var_1, ..., var_n := rhs>: Assignment)
    E(G, L, <let var_1, ..., var_n>: VariableDeclaration) =
        let L1 be a copy of L where L1[$var_i] = 0 for i = 1, ..., n
        G, L1, regular
    E(G, L, <var_1, ..., var_n := rhs>: Assignment) =
        let G1, L1, v1, ..., vn = E(G, L, rhs)
        let L2 be a copy of L1 where L2[$var_i] = vi for i = 1, ..., n
        G, L2, regular
    E(G, L, <for { i1, ..., in } condition post body>: ForLoop) =
        if n >= 1:
            let G1, L, mode = E(G, L, i1, ..., in)
            // mode has to be regular or leave due to the syntactic restrictions
            if mode is leave then
                G1, L1 restricted to variables of L, leave
            otherwise
                let G2, L2, mode = E(G1, L1, for {} condition post body)
                G2, L2 restricted to variables of L, mode
        else:
            let G1, L1, v = E(G, L, condition)
            if v is false:
                G1, L1, regular
            else:
                let G2, L2, mode = E(G1, L, body)
                if mode is break:
                    G2, L2, regular
                otherwise if mode is leave:
                    G2, L2, leave
                else:
                    G3, L3, mode = E(G2, L2, post)
                    if mode is leave:
                        G2, L3, leave
                    otherwise
                        E(G3, L3, for {} condition post body)
    E(G, L, break: BreakContinue) =
        G, L, break
    E(G, L, continue: BreakContinue) =
        G, L, continue
    E(G, L, leave: Leave) =
        G, L, leave
    E(G, L, <if condition body>: If) =
        let G0, L0, v = E(G, L, condition)
        if v is true:
            E(G0, L0, body)
        else:
            G0, L0, regular
    E(G, L, <switch condition case l1:t1 st1 ... case ln:tn stn>: Switch) =
        E(G, L, switch condition case l1:t1 st1 ... case ln:tn stn default {})
    E(G, L, <switch condition case l1:t1 st1 ... case ln:tn stn default st'>: Switch) =
        let G0, L0, v = E(G, L, condition)
        // i = 1 .. n
        // Evaluate literals, context doesn't matter
        let _, _, v1 = E(G0, L0, l1)
        ...
        let _, _, vn = E(G0, L0, ln)
        if there exists smallest i such that vi = v:
            E(G0, L0, sti)
        else:
            E(G0, L0, st')

    E(G, L, <name>: Identifier) =
        G, L, L[$name]
    E(G, L, <fname(arg1, ..., argn)>: FunctionCall) =
        G1, L1, vn = E(G, L, argn)
        ...
        G(n-1), L(n-1), v2 = E(G(n-2), L(n-2), arg2)
        Gn, Ln, v1 = E(G(n-1), L(n-1), arg1)
        Let <function fname (param1, ..., paramn) -> ret1, ..., retm block>
        be the function of name $fname visible at the point of the call.
        Let L' be a new local state such that
        L'[$parami] = vi and L'[$reti] = 0 for all i.
        Let G'', L'', mode = E(Gn, L', block)
        G'', Ln, L''[$ret1], ..., L''[$retm]
    E(G, L, l: StringLiteral) = G, L, str(l),
        where str is the string evaluation function,
        which for the EVM dialect is defined in the section 'Literals' above
    E(G, L, n: HexNumber) = G, L, hex(n)
        where hex is the hexadecimal evaluation function,
        which turns a sequence of hexadecimal digits into their big endian value
    E(G, L, n: DecimalNumber) = G, L, dec(n),
        where dec is the decimal evaluation function,
        which turns a sequence of decimal digits into their big endian value

.. _opcodes:

EVM Dialect
-----------

.. The default dialect of Yul currently is the EVM dialect for the currently selected version of the EVM.
.. with a version of the EVM. The only type available in this dialect
.. is ``u256``, the 256-bit native type of the Ethereum Virtual Machine.
.. Since it is the default type of this dialect, it can be omitted.

Yulのデフォルトの方言は、現在選択されているEVMのバージョンのEVMの方言です。この方言で使用できる型は、Ethereum Virtual Machineの256ビットのネイティブ型である ``u256`` のみです。これはこの方言のデフォルト型なので、省略できます。

.. The following table lists all builtin functions
.. (depending on the EVM version) and provides a short description of the
.. semantics of the function / opcode.
.. This document does not want to be a full description of the Ethereum virtual machine.
.. Please refer to a different document if you are interested in the precise semantics.

次の表は、すべての組み込み関数（EVMバージョンによる）をリストアップし、関数/オペコードのセマンティクスの簡単な説明を提供しています。この文書は、Ethereum仮想マシンの完全な説明を目的としていません。正確なセマンティクスに興味がある場合は、別のドキュメントを参照してください。

.. Opcodes marked with ``-`` do not return a result and all others return exactly one value.
.. Opcodes marked with ``F``, ``H``, ``B``, ``C``, ``I`` and ``L`` are present since Frontier, Homestead,
.. Byzantium, Constantinople, Istanbul or London respectively.

``-`` と書かれたオプコードは結果を返さず、その他のオプコードは正確に1つの値を返します。 ``F`` 、 ``H`` 、 ``B`` 、 ``C`` 、 ``I`` 、 ``L`` と書かれたオプコードは、それぞれFrontier、Homestead、Byzantium、Constantinople、Istanbul、Londonから存在しています。

.. In the following, ``mem[a...b)`` signifies the bytes of memory starting at position ``a`` up to
.. but not including position ``b`` and ``storage[p]`` signifies the storage contents at slot ``p``.

以下では、 ``mem[a...b)`` は位置 ``a`` から位置 ``b`` までのメモリのバイトを意味し、 ``storage[p]`` はスロット ``p`` のストレージ内容を意味します。

.. Since Yul manages local variables and control-flow,
.. opcodes that interfere with these features are not available. This includes
.. the ``dup`` and ``swap`` instructions as well as ``jump`` instructions, labels and the ``push`` instructions.

Yulはローカル変数やコントロールフローを管理しているため、これらの機能を阻害するオペコードは使用できません。これには、 ``dup`` 、 ``swap`` 命令のほか、 ``jump`` 命令、ラベル、 ``push`` 命令などが含まれます。

+-------------------------+-----+---+-----------------------------------------------------------------+
| Instruction             |     |   | Explanation                                                     |
+=========================+=====+===+=================================================================+
| stop()                  + `-` | F | stop execution, identical to return(0, 0)                       |
+-------------------------+-----+---+-----------------------------------------------------------------+
| add(x, y)               |     | F | x + y                                                           |
+-------------------------+-----+---+-----------------------------------------------------------------+
| sub(x, y)               |     | F | x - y                                                           |
+-------------------------+-----+---+-----------------------------------------------------------------+
| mul(x, y)               |     | F | x * y                                                           |
+-------------------------+-----+---+-----------------------------------------------------------------+
| div(x, y)               |     | F | x / y or 0 if y == 0                                            |
+-------------------------+-----+---+-----------------------------------------------------------------+
| sdiv(x, y)              |     | F | x / y, for signed numbers in two's complement, 0 if y == 0      |
+-------------------------+-----+---+-----------------------------------------------------------------+
| mod(x, y)               |     | F | x % y, 0 if y == 0                                              |
+-------------------------+-----+---+-----------------------------------------------------------------+
| smod(x, y)              |     | F | x % y, for signed numbers in two's complement, 0 if y == 0      |
+-------------------------+-----+---+-----------------------------------------------------------------+
| exp(x, y)               |     | F | x to the power of y                                             |
+-------------------------+-----+---+-----------------------------------------------------------------+
| not(x)                  |     | F | bitwise "not" of x (every bit of x is negated)                  |
+-------------------------+-----+---+-----------------------------------------------------------------+
| lt(x, y)                |     | F | 1 if x < y, 0 otherwise                                         |
+-------------------------+-----+---+-----------------------------------------------------------------+
| gt(x, y)                |     | F | 1 if x > y, 0 otherwise                                         |
+-------------------------+-----+---+-----------------------------------------------------------------+
| slt(x, y)               |     | F | 1 if x < y, 0 otherwise, for signed numbers in two's complement |
+-------------------------+-----+---+-----------------------------------------------------------------+
| sgt(x, y)               |     | F | 1 if x > y, 0 otherwise, for signed numbers in two's complement |
+-------------------------+-----+---+-----------------------------------------------------------------+
| eq(x, y)                |     | F | 1 if x == y, 0 otherwise                                        |
+-------------------------+-----+---+-----------------------------------------------------------------+
| iszero(x)               |     | F | 1 if x == 0, 0 otherwise                                        |
+-------------------------+-----+---+-----------------------------------------------------------------+
| and(x, y)               |     | F | bitwise "and" of x and y                                        |
+-------------------------+-----+---+-----------------------------------------------------------------+
| or(x, y)                |     | F | bitwise "or" of x and y                                         |
+-------------------------+-----+---+-----------------------------------------------------------------+
| xor(x, y)               |     | F | bitwise "xor" of x and y                                        |
+-------------------------+-----+---+-----------------------------------------------------------------+
| byte(n, x)              |     | F | nth byte of x, where the most significant byte is the 0th byte  |
+-------------------------+-----+---+-----------------------------------------------------------------+
| shl(x, y)               |     | C | logical shift left y by x bits                                  |
+-------------------------+-----+---+-----------------------------------------------------------------+
| shr(x, y)               |     | C | logical shift right y by x bits                                 |
+-------------------------+-----+---+-----------------------------------------------------------------+
| sar(x, y)               |     | C | signed arithmetic shift right y by x bits                       |
+-------------------------+-----+---+-----------------------------------------------------------------+
| addmod(x, y, m)         |     | F | (x + y) % m with arbitrary precision arithmetic, 0 if m == 0    |
+-------------------------+-----+---+-----------------------------------------------------------------+
| mulmod(x, y, m)         |     | F | (x * y) % m with arbitrary precision arithmetic, 0 if m == 0    |
+-------------------------+-----+---+-----------------------------------------------------------------+
| signextend(i, x)        |     | F | sign extend from (i*8+7)th bit counting from least significant  |
+-------------------------+-----+---+-----------------------------------------------------------------+
| keccak256(p, n)         |     | F | keccak(mem[p...(p+n)))                                          |
+-------------------------+-----+---+-----------------------------------------------------------------+
| pc()                    |     | F | current position in code                                        |
+-------------------------+-----+---+-----------------------------------------------------------------+
| pop(x)                  | `-` | F | discard value x                                                 |
+-------------------------+-----+---+-----------------------------------------------------------------+
| mload(p)                |     | F | mem[p...(p+32))                                                 |
+-------------------------+-----+---+-----------------------------------------------------------------+
| mstore(p, v)            | `-` | F | mem[p...(p+32)) := v                                            |
+-------------------------+-----+---+-----------------------------------------------------------------+
| mstore8(p, v)           | `-` | F | mem[p] := v & 0xff (only modifies a single byte)                |
+-------------------------+-----+---+-----------------------------------------------------------------+
| sload(p)                |     | F | storage[p]                                                      |
+-------------------------+-----+---+-----------------------------------------------------------------+
| sstore(p, v)            | `-` | F | storage[p] := v                                                 |
+-------------------------+-----+---+-----------------------------------------------------------------+
| msize()                 |     | F | size of memory, i.e. largest accessed memory index              |
+-------------------------+-----+---+-----------------------------------------------------------------+
| gas()                   |     | F | gas still available to execution                                |
+-------------------------+-----+---+-----------------------------------------------------------------+
| address()               |     | F | address of the current contract / execution context             |
+-------------------------+-----+---+-----------------------------------------------------------------+
| balance(a)              |     | F | wei balance at address a                                        |
+-------------------------+-----+---+-----------------------------------------------------------------+
| selfbalance()           |     | I | equivalent to balance(address()), but cheaper                   |
+-------------------------+-----+---+-----------------------------------------------------------------+
| caller()                |     | F | call sender (excluding ``delegatecall``)                        |
+-------------------------+-----+---+-----------------------------------------------------------------+
| callvalue()             |     | F | wei sent together with the current call                         |
+-------------------------+-----+---+-----------------------------------------------------------------+
| calldataload(p)         |     | F | call data starting from position p (32 bytes)                   |
+-------------------------+-----+---+-----------------------------------------------------------------+
| calldatasize()          |     | F | size of call data in bytes                                      |
+-------------------------+-----+---+-----------------------------------------------------------------+
| calldatacopy(t, f, s)   | `-` | F | copy s bytes from calldata at position f to mem at position t   |
+-------------------------+-----+---+-----------------------------------------------------------------+
| codesize()              |     | F | size of the code of the current contract / execution context    |
+-------------------------+-----+---+-----------------------------------------------------------------+
| codecopy(t, f, s)       | `-` | F | copy s bytes from code at position f to mem at position t       |
+-------------------------+-----+---+-----------------------------------------------------------------+
| extcodesize(a)          |     | F | size of the code at address a                                   |
+-------------------------+-----+---+-----------------------------------------------------------------+
| extcodecopy(a, t, f, s) | `-` | F | like codecopy(t, f, s) but take code at address a               |
+-------------------------+-----+---+-----------------------------------------------------------------+
| returndatasize()        |     | B | size of the last returndata                                     |
+-------------------------+-----+---+-----------------------------------------------------------------+
| returndatacopy(t, f, s) | `-` | B | copy s bytes from returndata at position f to mem at position t |
+-------------------------+-----+---+-----------------------------------------------------------------+
| extcodehash(a)          |     | C | code hash of address a                                          |
+-------------------------+-----+---+-----------------------------------------------------------------+
| create(v, p, n)         |     | F | create new contract with code mem[p...(p+n)) and send v wei     |
|                         |     |   | and return the new address; returns 0 on error                  |
+-------------------------+-----+---+-----------------------------------------------------------------+
| create2(v, p, n, s)     |     | C | create new contract with code mem[p...(p+n)) at address         |
|                         |     |   | keccak256(0xff . this . s . keccak256(mem[p...(p+n)))           |
|                         |     |   | and send v wei and return the new address, where ``0xff`` is a  |
|                         |     |   | 1 byte value, ``this`` is the current contract's address        |
|                         |     |   | as a 20 byte value and ``s`` is a big-endian 256-bit value;     |
|                         |     |   | returns 0 on error                                              |
+-------------------------+-----+---+-----------------------------------------------------------------+
| call(g, a, v, in,       |     | F | call contract at address a with input mem[in...(in+insize))     |
| insize, out, outsize)   |     |   | providing g gas and v wei and output area                       |
|                         |     |   | mem[out...(out+outsize)) returning 0 on error (eg. out of gas)  |
|                         |     |   | and 1 on success                                                |
|                         |     |   | :ref:`See more <yul-call-return-area>`                          |
+-------------------------+-----+---+-----------------------------------------------------------------+
| callcode(g, a, v, in,   |     | F | identical to ``call`` but only use the code from a and stay     |
| insize, out, outsize)   |     |   | in the context of the current contract otherwise                |
|                         |     |   | :ref:`See more <yul-call-return-area>`                          |
+-------------------------+-----+---+-----------------------------------------------------------------+
| delegatecall(g, a, in,  |     | H | identical to ``callcode`` but also keep ``caller``              |
| insize, out, outsize)   |     |   | and ``callvalue``                                               |
|                         |     |   | :ref:`See more <yul-call-return-area>`                          |
+-------------------------+-----+---+-----------------------------------------------------------------+
| staticcall(g, a, in,    |     | B | identical to ``call(g, a, 0, in, insize, out, outsize)`` but do |
| insize, out, outsize)   |     |   | not allow state modifications                                   |
|                         |     |   | :ref:`See more <yul-call-return-area>`                          |
+-------------------------+-----+---+-----------------------------------------------------------------+
| return(p, s)            | `-` | F | end execution, return data mem[p...(p+s))                       |
+-------------------------+-----+---+-----------------------------------------------------------------+
| revert(p, s)            | `-` | B | end execution, revert state changes, return data mem[p...(p+s)) |
+-------------------------+-----+---+-----------------------------------------------------------------+
| selfdestruct(a)         | `-` | F | end execution, destroy current contract and send funds to a     |
+-------------------------+-----+---+-----------------------------------------------------------------+
| invalid()               | `-` | F | end execution with invalid instruction                          |
+-------------------------+-----+---+-----------------------------------------------------------------+
| log0(p, s)              | `-` | F | log without topics and data mem[p...(p+s))                      |
+-------------------------+-----+---+-----------------------------------------------------------------+
| log1(p, s, t1)          | `-` | F | log with topic t1 and data mem[p...(p+s))                       |
+-------------------------+-----+---+-----------------------------------------------------------------+
| log2(p, s, t1, t2)      | `-` | F | log with topics t1, t2 and data mem[p...(p+s))                  |
+-------------------------+-----+---+-----------------------------------------------------------------+
| log3(p, s, t1, t2, t3)  | `-` | F | log with topics t1, t2, t3 and data mem[p...(p+s))              |
+-------------------------+-----+---+-----------------------------------------------------------------+
| log4(p, s, t1, t2, t3,  | `-` | F | log with topics t1, t2, t3, t4 and data mem[p...(p+s))          |
| t4)                     |     |   |                                                                 |
+-------------------------+-----+---+-----------------------------------------------------------------+
| chainid()               |     | I | ID of the executing chain (EIP-1344)                            |
+-------------------------+-----+---+-----------------------------------------------------------------+
| basefee()               |     | L | current block's base fee (EIP-3198 and EIP-1559)                |
+-------------------------+-----+---+-----------------------------------------------------------------+
| origin()                |     | F | transaction sender                                              |
+-------------------------+-----+---+-----------------------------------------------------------------+
| gasprice()              |     | F | gas price of the transaction                                    |
+-------------------------+-----+---+-----------------------------------------------------------------+
| blockhash(b)            |     | F | hash of block nr b - only for last 256 blocks excluding current |
+-------------------------+-----+---+-----------------------------------------------------------------+
| coinbase()              |     | F | current mining beneficiary                                      |
+-------------------------+-----+---+-----------------------------------------------------------------+
| timestamp()             |     | F | timestamp of the current block in seconds since the epoch       |
+-------------------------+-----+---+-----------------------------------------------------------------+
| number()                |     | F | current block number                                            |
+-------------------------+-----+---+-----------------------------------------------------------------+
| difficulty()            |     | F | difficulty of the current block                                 |
+-------------------------+-----+---+-----------------------------------------------------------------+
| gaslimit()              |     | F | block gas limit of the current block                            |
+-------------------------+-----+---+-----------------------------------------------------------------+

.. _yul-call-return-area:

.. .. note::

..   The ``call*`` instructions use the ``out`` and ``outsize`` parameters to define an area in memory where
..   the return or failure data is placed. This area is written to depending on how many bytes the called contract returns.
..   If it returns more data, only the first ``outsize`` bytes are written. You can access the rest of the data
..   using the ``returndatacopy`` opcode. If it returns less data, then the remaining bytes are not touched at all.
..   You need to use the ``returndatasize`` opcode to check which part of this memory area contains the return data.
..   The remaining bytes will retain their values as of before the call.

.. note::

  ``call*`` 命令は、 ``out`` および ``outsize`` のパラメータを使用して、戻り値または失敗値のデータを配置するメモリ内の領域を定義します。この領域は、呼び出されたコントラクトが何バイト返すかによって書き込まれます。   より多くのデータを返してきた場合は、最初の ``outsize`` バイトのみが書き込まれます。残りのデータには ``returndatacopy`` オペコードでアクセスできます。より少ないデータを返した場合は、残りのバイトにはまったく手をつけません。   このメモリ領域のどの部分にリターンデータが含まれているかを確認するには、 ``returndatasize`` オペコードを使用する必要があります。   残りのバイトは、呼び出し前の値を保持します。

.. In some internal dialects, there are additional functions:

内部の方言では、追加関数があるものもあります。

datasize, dataoffset, datacopy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. The functions ``datasize(x)``, ``dataoffset(x)`` and ``datacopy(t, f, l)``
.. are used to access other parts of a Yul object.

関数 ``datasize(x)`` 、 ``dataoffset(x)`` 、 ``datacopy(t, f, l)`` は、Yulオブジェクトの他の部分にアクセスするために使用されます。

.. ``datasize`` and ``dataoffset`` can only take string literals (the names of other objects)
.. as arguments and return the size and offset in the data area, respectively.
.. For the EVM, the ``datacopy`` function is equivalent to ``codecopy``.

``datasize`` と ``dataoffset`` は、文字列リテラル（他のオブジェクトの名前）のみを引数に取り、それぞれデータ領域のサイズとオフセットを返します。EVMでは、 ``datacopy`` 関数は ``codecopy`` と同等です。

setimmutable, loadimmutable
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. The functions ``setimmutable(offset, "name", value)`` and ``loadimmutable("name")`` are
.. used for the immutable mechanism in Solidity and do not nicely map to pure Yul.
.. The call to ``setimmutable(offset, "name", value)`` assumes that the runtime code of the contract
.. containing the given named immutable was copied to memory at offset ``offset`` and will write ``value`` to all
.. positions in memory (relative to ``offset``) that contain the placeholder that was generated for calls
.. to ``loadimmutable("name")`` in the runtime code.

関数 ``setimmutable(offset, "name", value)`` と ``loadimmutable("name")`` はSolidityのimmutable機構に使用されており、純粋なYulにはうまくマッピングされていません。 ``setimmutable(offset, "name", value)`` の呼び出しは、指定されたimmutableという名前のコントラクトを含むランタイムコードがオフセット ``offset`` でメモリにコピーされたと仮定し、ランタイムコード内の ``loadimmutable("name")`` への呼び出しのために生成されたプレースホルダーを含むメモリ内のすべての位置（ ``offset`` に対する相対位置）に ``value`` を書き込みます。

linkersymbol
^^^^^^^^^^^^
The function ``linkersymbol("library_id")`` is a placeholder for an address literal to be substituted
by the linker.
Its first and only argument must be a string literal and uniquely represents the address to be inserted.
Identifiers can be arbitrary but when the compiler produces Yul code from Solidity sources,
it uses a library name qualified with the name of the source unit that defines that library.
To link the code with a particular library address, the same identifier must be provided to the
``--libraries`` option on the command line.

.. For example this code

例えば、このコード

.. code-block:: yul

    let a := linkersymbol("file.sol:Math")

.. is equivalent to

に相当します。

.. code-block:: yul

    let a := 0x1234567890123456789012345678901234567890

.. when the linker is invoked with ``--libraries "file.sol:Math=0x1234567890123456789012345678901234567890``
.. option.

``--libraries "file.sol:Math=0x1234567890123456789012345678901234567890`` オプションを付けてリンカーを起動した場合は

.. See :ref:`Using the Commandline Compiler <commandline-compiler>` for details about the Solidity linker.

Solidityリンカーの詳細は :ref:`Using the Commandline Compiler <commandline-compiler>` を参照してください。

memoryguard
^^^^^^^^^^^

.. This function is available in the EVM dialect with objects. The caller of
.. ``let ptr := memoryguard(size)`` (where ``size`` has to be a literal number)
.. promises that they only use memory in either the range ``[0, size)`` or the
.. unbounded range starting at ``ptr``.

この関数はEVM方言のオブジェクトで使用できます。 ``let ptr := memoryguard(size)`` ( ``size`` はリテラル数)の呼び出し元は、範囲 ``[0, size)`` または ``ptr`` から始まるunbounded範囲のいずれかのメモリのみを使用することを約束します。

.. Since the presence of a ``memoryguard`` call indicates that all memory access
.. adheres to this restriction, it allows the optimizer to perform additional
.. optimization steps, for example the stack limit evader, which attempts to move
.. stack variables that would otherwise be unreachable to memory.

``memoryguard`` コールの存在は、すべてのメモリアクセスがこの制限に従っていることを示すので、オプティマイザは追加の最適化ステップを実行できます。例えば、スタックリミットイベーダーは、他の方法では到達できないスタック変数をメモリに移動させようとします。

.. The Yul optimizer promises to only use the memory range ``[size, ptr)`` for its purposes.
.. If the optimizer does not need to reserve any memory, it holds that ``ptr == size``.

Yulオプティマイザは、目的のためにメモリ範囲 ``[size, ptr)`` のみを使用することを約束します。オプティマイザがメモリを確保する必要がない場合は、その ``ptr == size`` を保持します。

.. ``memoryguard`` can be called multiple times, but needs to have the same literal as argument
.. within one Yul subobject. If at least one ``memoryguard`` call is found in a subobject,
.. the additional optimiser steps will be run on it.

``memoryguard`` は複数回呼び出すことができますが、1つのYulサブオブジェクト内で同じリテラルを引数として持つ必要があります。サブオブジェクトの中に少なくとも1つの ``memoryguard`` の呼び出しが見つかった場合、追加のオプティマイザのステップが実行されます。

.. _yul-verbatim:

verbatim
^^^^^^^^

.. The set of ``verbatim...`` builtin functions lets you create bytecode for opcodes
.. that are not known to the Yul compiler. It also allows you to create
.. bytecode sequences that will not be modified by the optimizer.

``verbatim...`` 組み込み関数のセットでは、Yulコンパイラーが知らないオペコードのバイトコードを作成できます。
また、オプティマイザによって変更されないバイトコードシーケンスを作成することもできます。

.. The functions are ``verbatim_<n>i_<m>o("<data>", ...)``, where

その関数は ``verbatim_<n>i_<m>o("<data>", ...)`` で、ここでは

.. - ``n`` is a decimal between 0 and 99 that specifies the number of input stack slots / variables

- ``n`` は0～99の10進数で、入力スタックのスロット数／変数数を指定する

.. - ``m`` is a decimal between 0 and 99 that specifies the number of output stack slots / variables

- ``m`` は0～99の10進数で、出力スタックのスロット数／変数数を指定します。

.. - ``data`` is a string literal that contains the sequence of bytes

- ``data`` はバイト列を含む文字列リテラルです。

.. If you for example want to define a function that multiplies the input
.. by two, without the optimizer touching the constant two, you can use

例えば、入力を2倍する関数を定義する際に、オプティマイザが定数2に触れないようにするには、次のようにします。

.. code-block:: yul

    let x := calldataload(0)
    let double := verbatim_1i_1o(hex"600202", x)

.. This code will result in a ``dup1`` opcode to retrieve ``x``
.. (the optimizer might directly re-use result of the
.. ``calldataload`` opcode, though)
.. directly followed by ``600202``. The code is assumed to
.. consume the copied value of ``x`` and produce the result
.. on the top of the stack. The compiler then generates code
.. to allocate a stack slot for ``double`` and store the result there.

このコードでは、 ``x`` を取得するための ``dup1`` オペコード（オプティマイザは ``calldataload`` オペコードの結果を直接再利用するかもしれませんが）が、 ``600202`` に続いて表示されます。このコードは、 ``x`` のコピーされた値を消費して、スタックの一番上に結果を生成すると想定されます。その後、コンパイラは  ``double``  用のスタックスロットを割り当て、そこに結果を格納するコードを生成します。

.. As with all opcodes, the arguments are arranged on the stack
.. with the leftmost argument on the top, while the return values
.. are assumed to be laid out such that the rightmost variable is
.. at the top of the stack.

他のオペコードと同様に、引数はスタック上に左端の引数が一番上になるように並べられ、戻り値は右端の変数がスタックの一番上になるように並べられるとされています。

.. Since ``verbatim`` can be used to generate arbitrary opcodes
.. or even opcodes unknown to the Solidity compiler, care has to be taken
.. when using ``verbatim`` together with the optimizer. Even when the
.. optimizer is switched off, the code generator has to determine
.. the stack layout, which means that e.g. using ``verbatim`` to modify
.. the stack height can lead to undefined behaviour.

``verbatim`` は、任意のオペコードや、Solidityコンパイラにとって未知のオペコードを生成するために使用できるため、オプティマイザと ``verbatim`` を併用する際には注意が必要です。オプティマイザがオフになっていても、コードジェネレーターはスタックレイアウトを決定しなければなりません。つまり、 ``verbatim`` を使ってスタックの高さを変更すると、未定義の動作になる可能性があります。

.. The following is a non-exhaustive list of restrictions on
.. verbatim bytecode that are not checked by
.. the compiler. Violations of these restrictions can result in
.. undefined behaviour.

以下は、コンパイラではチェックされない逐語的バイトコードの制限事項の非網羅的なリストです。これらの制限に違反すると、未定義の動作を引き起こす可能性があります。

.. - Control-flow should not jump into or out of verbatim blocks,
..   but it can jump within the same verbatim block.

- Control-flowはverbatimブロックの中に飛び込んだり、外に出たりしてはいけませんが、同じverbatimブロックの中では飛び込むことができます。

.. - Stack contents apart from the input and output parameters
..   should not be accessed.

- 入力・出力パラメータ以外のスタックの内容にアクセスしてはいけません。

.. - The stack height difference should be exactly ``m - n``
..   (output slots minus input slots).

- スタックの高さの違いは、正確には ``m - n`` （出力スロットから入力スロットを引いたもの）です。

.. - Verbatim bytecode cannot make any assumptions about the
..   surrounding bytecode. All required parameters have to be
..   passed in as stack variables.

- Verbatimのバイトコードは、周囲のバイトコードを想定できません。必要なパラメータはすべてスタック変数として渡さなければなりません。

.. The optimizer does not analyze verbatim bytecode and always
.. assumes that it modifies all aspects of state and thus can only
.. do very few optimizations across ``verbatim`` function calls.

オプティマイザはバイトコードを逐語的に分析せず、常に状態のすべての側面を修正することを前提としているため、 ``verbatim`` 関数コール全体ではごくわずかな最適化しかできません。

.. The optimizer treats verbatim bytecode as an opaque block of code.
.. It will not split it but might move, duplicate
.. or combine it with identical verbatim bytecode blocks.
.. If a verbatim bytecode block is unreachable by the control-flow,
.. it can be removed.

オプティマイザは、バーベイタムバイトコードを不透明なコードブロックとして扱います。分割はしませんが、移動、複製、同一のバーベイタムバイトコードブロックとの結合は可能です。逐語的バイトコードブロックが制御フローから到達できない場合、そのブロックは削除されます。

.. .. warning::

..     During discussions about whether or not EVM improvements
..     might break existing smart contracts, features inside ``verbatim``
..     cannot receive the same consideration as those used by the Solidity
..     compiler itself.

.. warning::

    EVMの改善が既存のスマートコントラクトを破壊するかどうかを議論する際、 ``verbatim`` の機能はSolidityのコンパイラ自体が使用する機能と同じように考慮できません。

.. .. note::

..     To avoid confusion, all identifiers starting with the string ``verbatim`` are reserved
..     and cannot be used for user-defined identifiers.

.. note::

    混乱を避けるため、文字列 ``verbatim`` で始まる識別子はすべて予約されており、ユーザー定義の識別子には使用できません。

.. _yul-object:

Specification of Yul Object
===========================

.. Yul objects are used to group named code and data sections.
.. The functions ``datasize``, ``dataoffset`` and ``datacopy``
.. can be used to access these sections from within code.
.. Hex strings can be used to specify data in hex encoding,
.. regular strings in native encoding. For code,
.. ``datacopy`` will access its assembled binary representation.

Yulオブジェクトは、名前の付いたコードおよびデータセクションをグループ化するために使用されます。関数 ``datasize`` 、 ``dataoffset`` 、 ``datacopy`` を使用して、コード内からこれらのセクションにアクセスできます。16進文字列は、データを16進エンコーディングで、通常の文字列をネイティブエンコーディングで指定するために使用できます。コードの場合、 ``datacopy`` はアセンブルされたバイナリ表現にアクセスします。

.. code-block:: none

    Object = 'object' StringLiteral '{' Code ( Object | Data )* '}'
    Code = 'code' Block
    Data = 'data' StringLiteral ( HexLiteral | StringLiteral )
    HexLiteral = 'hex' ('"' ([0-9a-fA-F]{2})* '"' | '\'' ([0-9a-fA-F]{2})* '\'')
    StringLiteral = '"' ([^"\r\n\\] | '\\' .)* '"'

.. Above, ``Block`` refers to ``Block`` in the Yul code grammar explained in the previous chapter.

上記、 ``Block`` は、前章で説明したYulコード文法の ``Block`` を指します。

.. .. note::

..     Data objects or sub-objects whose names contain a ``.`` can be defined
..     but it is not possible to access them through ``datasize``,
..     ``dataoffset`` or ``datacopy`` because ``.`` is used as a separator
..     to access objects inside another object.

.. note::

    ``.`` を含む名前のデータオブジェクトやサブオブジェクトを定義できますが、 ``.`` は他のオブジェクトの内部にあるオブジェクトにアクセスするためのセパレータとして使用されるため、 ``datasize`` 、 ``dataoffset`` 、 ``datacopy`` を介してアクセスできません。

.. .. note::

..     The data object called ``".metadata"`` has a special meaning:
..     It cannot be accessed from code and is always appended to the very end of the
..     bytecode, regardless of its position in the object.

..     Other data objects with special significance might be added in the
..     future, but their names will always start with a ``.``.

.. note::

    ``".metadata"`` というデータオブジェクトには特別な意味があります。     コードからはアクセスできず、オブジェクト内の位置に関わらず、常にバイトコードの最後尾に付加されます。

    今後、特別な意味を持つデータオブジェクトが追加されるかもしれませんが、その名前は常に ``.`` で始まります。

.. An example Yul Object is shown below:

Yulオブジェクトの例を以下に示します。

.. code-block:: yul

    // A contract consists of a single object with sub-objects representing
    // the code to be deployed or other contracts it can create.
    // The single "code" node is the executable code of the object.
    // Every (other) named object or data section is serialized and
    // made accessible to the special built-in functions datacopy / dataoffset / datasize
    // The current object, sub-objects and data items inside the current object
    // are in scope.
    object "Contract1" {
        // This is the constructor code of the contract.
        code {
            function allocate(size) -> ptr {
                ptr := mload(0x40)
                if iszero(ptr) { ptr := 0x60 }
                mstore(0x40, add(ptr, size))
            }

            // first create "Contract2"
            let size := datasize("Contract2")
            let offset := allocate(size)
            // This will turn into codecopy for EVM
            datacopy(offset, dataoffset("Contract2"), size)
            // constructor parameter is a single number 0x1234
            mstore(add(offset, size), 0x1234)
            pop(create(offset, add(size, 32), 0))

            // now return the runtime object (the currently
            // executing code is the constructor code)
            size := datasize("runtime")
            offset := allocate(size)
            // This will turn into a memory->memory copy for Ewasm and
            // a codecopy for EVM
            datacopy(offset, dataoffset("runtime"), size)
            return(offset, size)
        }

        data "Table2" hex"4123"

        object "runtime" {
            code {
                function allocate(size) -> ptr {
                    ptr := mload(0x40)
                    if iszero(ptr) { ptr := 0x60 }
                    mstore(0x40, add(ptr, size))
                }

                // runtime code

                mstore(0, "Hello, World!")
                return(0, 0x20)
            }
        }

        // Embedded object. Use case is that the outside is a factory contract,
        // and Contract2 is the code to be created by the factory
        object "Contract2" {
            code {
                // code here ...
            }

            object "runtime" {
                code {
                    // code here ...
                }
            }

            data "Table1" hex"4123"
        }
    }

Yul Optimizer
=============

.. The Yul optimizer operates on Yul code and uses the same language for input, output and
.. intermediate states. This allows for easy debugging and verification of the optimizer.

Yulオプティマイザは、Yulコード上で動作し、入力、出力、中間状態を同じ言語で表現します。これにより、オプティマイザのデバッグや検証が容易になります。

.. Please refer to the general :ref:`optimizer documentation <optimizer>`
.. for more details about the different optimization stages and how to use the optimizer.

各最適化ステージの詳細やオプティマイザの使用方法については、一般的な :ref:`optimizer documentation <optimizer>` を参照してください。

.. If you want to use Solidity in stand-alone Yul mode, you activate the optimizer using ``--optimize``
.. and optionally specify the :ref:`expected number of contract executions <optimizer-parameter-runs>` with
.. ``--optimize-runs``:

Solidityをスタンドアローンのユルいモードで使いたい場合は、 ``--optimize`` でオプティマイザを起動し、オプションで ``--optimize-runs`` で :ref:`expected number of contract executions <optimizer-parameter-runs>` を指定します。

.. code-block:: sh

    solc --strict-assembly --optimize --optimize-runs 200

.. In Solidity mode, the Yul optimizer is activated together with the regular optimizer.

Solidityモードでは、通常のオプティマイザと一緒にYulオプティマイザが作動します。

Optimization Step Sequence
--------------------------

.. By default the Yul optimizer applies its predefined sequence of optimization steps to the generated assembly.
.. You can override this sequence and supply your own using the ``--yul-optimizations`` option:

デフォルトでは、Yulオプティマイザは、生成されたアセンブリに対して、定義済みの最適化ステップのシーケンスを適用します。 ``--yul-optimizations`` オプションを使用すると、このシーケンスをオーバーライドして、独自のシーケンスを提供できます。

.. code-block:: sh

    solc --optimize --ir-optimized --yul-optimizations 'dhfoD[xarrscLMcCTU]uljmul'

.. The order of steps is significant and affects the quality of the output.
.. Moreover, applying a step may uncover new optimization opportunities for others that were already
.. applied so repeating steps is often beneficial.
.. By enclosing part of the sequence in square brackets (``[]``) you tell the optimizer to repeatedly
.. apply that part until it no longer improves the size of the resulting assembly.
.. You can use brackets multiple times in a single sequence but they cannot be nested.

ステップの順番は重要で、出力の質に影響します。さらに、あるステップを適用すると、既に適用されている他のステップについても新たな最適化の機会が見つかる可能性があるため、ステップを繰り返すことが有益な場合もあります。シーケンスの一部を角括弧（ ``[]`` ）で囲むと、結果として得られるアセンブリのサイズが改善されなくなるまで、その部分を繰り返し適用するようにオプティマイザに指示します。括弧は1つのシーケンスに複数回使用できますが、入れ子にできません。

.. The following optimization steps are available:

以下のような最適化ステップがあります。

============ ===============================
Abbreviation Full name
============ ===============================
``f``        ``BlockFlattener``
``l``        ``CircularReferencesPruner``
``c``        ``CommonSubexpressionEliminator``
``C``        ``ConditionalSimplifier``
``U``        ``ConditionalUnsimplifier``
``n``        ``ControlFlowSimplifier``
``D``        ``DeadCodeEliminator``
``v``        ``EquivalentFunctionCombiner``
``e``        ``ExpressionInliner``
``j``        ``ExpressionJoiner``
``s``        ``ExpressionSimplifier``
``x``        ``ExpressionSplitter``
``I``        ``ForLoopConditionIntoBody``
``O``        ``ForLoopConditionOutOfBody``
``o``        ``ForLoopInitRewriter``
``i``        ``FullInliner``
``g``        ``FunctionGrouper``
``h``        ``FunctionHoister``
``F``        ``FunctionSpecializer``
``T``        ``LiteralRematerialiser``
``L``        ``LoadResolver``
``M``        ``LoopInvariantCodeMotion``
``r``        ``RedundantAssignEliminator``
``R``        ``ReasoningBasedSimplifier`` - highly experimental
``m``        ``Rematerialiser``
``V``        ``SSAReverser``
``a``        ``SSATransform``
``t``        ``StructuralSimplifier``
``u``        ``UnusedPruner``
``p``        ``UnusedFunctionParameterPruner``
``d``        ``VarDeclInitializer``
============ ===============================

.. Some steps depend on properties ensured by ``BlockFlattener``, ``FunctionGrouper``, ``ForLoopInitRewriter``.
.. For this reason the Yul optimizer always applies them before applying any steps supplied by the user.

いくつかのステップは、 ``BlockFlattener`` 、 ``FunctionGrouper`` 、 ``ForLoopInitRewriter`` によって確保される特性に依存します。このため、Yulオプティマイザは、ユーザーから提供されたステップを適用する前に、常にこれらのステップを適用します。

.. The ReasoningBasedSimplifier is an optimizer step that is currently not enabled
.. in the default set of steps. It uses an SMT solver to simplify arithmetic expressions
.. and boolean conditions. It has not received thorough testing or validation yet and can produce
.. non-reproducible results, so please use with care!

ReasoningBasedSimplifierはオプティマイザのステップで、現在はデフォルトのステップセットでは有効になっていません。SMTソルバーを使用して、算術式やブーリアン条件を単純化します。まだ十分なテストや検証が行われておらず、再現性のない結果が出る可能性がありますので、ご使用にはご注意ください。

.. _erc20yul:

Complete ERC20 Example
======================

.. code-block:: yul

    object "Token" {
        code {
            // Store the creator in slot zero.
            sstore(0, caller())

            // Deploy the contract
            datacopy(0, dataoffset("runtime"), datasize("runtime"))
            return(0, datasize("runtime"))
        }
        object "runtime" {
            code {
                // Protection against sending Ether
                require(iszero(callvalue()))

                // Dispatcher
                switch selector()
                case 0x70a08231 /* "balanceOf(address)" */ {
                    returnUint(balanceOf(decodeAsAddress(0)))
                }
                case 0x18160ddd /* "totalSupply()" */ {
                    returnUint(totalSupply())
                }
                case 0xa9059cbb /* "transfer(address,uint256)" */ {
                    transfer(decodeAsAddress(0), decodeAsUint(1))
                    returnTrue()
                }
                case 0x23b872dd /* "transferFrom(address,address,uint256)" */ {
                    transferFrom(decodeAsAddress(0), decodeAsAddress(1), decodeAsUint(2))
                    returnTrue()
                }
                case 0x095ea7b3 /* "approve(address,uint256)" */ {
                    approve(decodeAsAddress(0), decodeAsUint(1))
                    returnTrue()
                }
                case 0xdd62ed3e /* "allowance(address,address)" */ {
                    returnUint(allowance(decodeAsAddress(0), decodeAsAddress(1)))
                }
                case 0x40c10f19 /* "mint(address,uint256)" */ {
                    mint(decodeAsAddress(0), decodeAsUint(1))
                    returnTrue()
                }
                default {
                    revert(0, 0)
                }

                function mint(account, amount) {
                    require(calledByOwner())

                    mintTokens(amount)
                    addToBalance(account, amount)
                    emitTransfer(0, account, amount)
                }
                function transfer(to, amount) {
                    executeTransfer(caller(), to, amount)
                }
                function approve(spender, amount) {
                    revertIfZeroAddress(spender)
                    setAllowance(caller(), spender, amount)
                    emitApproval(caller(), spender, amount)
                }
                function transferFrom(from, to, amount) {
                    decreaseAllowanceBy(from, caller(), amount)
                    executeTransfer(from, to, amount)
                }

                function executeTransfer(from, to, amount) {
                    revertIfZeroAddress(to)
                    deductFromBalance(from, amount)
                    addToBalance(to, amount)
                    emitTransfer(from, to, amount)
                }

                /* ---------- calldata decoding functions ----------- */
                function selector() -> s {
                    s := div(calldataload(0), 0x100000000000000000000000000000000000000000000000000000000)
                }

                function decodeAsAddress(offset) -> v {
                    v := decodeAsUint(offset)
                    if iszero(iszero(and(v, not(0xffffffffffffffffffffffffffffffffffffffff)))) {
                        revert(0, 0)
                    }
                }
                function decodeAsUint(offset) -> v {
                    let pos := add(4, mul(offset, 0x20))
                    if lt(calldatasize(), add(pos, 0x20)) {
                        revert(0, 0)
                    }
                    v := calldataload(pos)
                }
                /* ---------- calldata encoding functions ---------- */
                function returnUint(v) {
                    mstore(0, v)
                    return(0, 0x20)
                }
                function returnTrue() {
                    returnUint(1)
                }

                /* -------- events ---------- */
                function emitTransfer(from, to, amount) {
                    let signatureHash := 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef
                    emitEvent(signatureHash, from, to, amount)
                }
                function emitApproval(from, spender, amount) {
                    let signatureHash := 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925
                    emitEvent(signatureHash, from, spender, amount)
                }
                function emitEvent(signatureHash, indexed1, indexed2, nonIndexed) {
                    mstore(0, nonIndexed)
                    log3(0, 0x20, signatureHash, indexed1, indexed2)
                }

                /* -------- storage layout ---------- */
                function ownerPos() -> p { p := 0 }
                function totalSupplyPos() -> p { p := 1 }
                function accountToStorageOffset(account) -> offset {
                    offset := add(0x1000, account)
                }
                function allowanceStorageOffset(account, spender) -> offset {
                    offset := accountToStorageOffset(account)
                    mstore(0, offset)
                    mstore(0x20, spender)
                    offset := keccak256(0, 0x40)
                }

                /* -------- storage access ---------- */
                function owner() -> o {
                    o := sload(ownerPos())
                }
                function totalSupply() -> supply {
                    supply := sload(totalSupplyPos())
                }
                function mintTokens(amount) {
                    sstore(totalSupplyPos(), safeAdd(totalSupply(), amount))
                }
                function balanceOf(account) -> bal {
                    bal := sload(accountToStorageOffset(account))
                }
                function addToBalance(account, amount) {
                    let offset := accountToStorageOffset(account)
                    sstore(offset, safeAdd(sload(offset), amount))
                }
                function deductFromBalance(account, amount) {
                    let offset := accountToStorageOffset(account)
                    let bal := sload(offset)
                    require(lte(amount, bal))
                    sstore(offset, sub(bal, amount))
                }
                function allowance(account, spender) -> amount {
                    amount := sload(allowanceStorageOffset(account, spender))
                }
                function setAllowance(account, spender, amount) {
                    sstore(allowanceStorageOffset(account, spender), amount)
                }
                function decreaseAllowanceBy(account, spender, amount) {
                    let offset := allowanceStorageOffset(account, spender)
                    let currentAllowance := sload(offset)
                    require(lte(amount, currentAllowance))
                    sstore(offset, sub(currentAllowance, amount))
                }

                /* ---------- utility functions ---------- */
                function lte(a, b) -> r {
                    r := iszero(gt(a, b))
                }
                function gte(a, b) -> r {
                    r := iszero(lt(a, b))
                }
                function safeAdd(a, b) -> r {
                    r := add(a, b)
                    if or(lt(r, a), lt(r, b)) { revert(0, 0) }
                }
                function calledByOwner() -> cbo {
                    cbo := eq(owner(), caller())
                }
                function revertIfZeroAddress(addr) {
                    require(addr)
                }
                function require(condition) {
                    if iszero(condition) { revert(0, 0) }
                }
            }
        }
    }

