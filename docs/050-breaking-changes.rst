*****************************
Solidity v0.5.0の破壊的変更点
*****************************

.. This section highlights the main breaking changes introduced in Solidity
.. version 0.5.0, along with the reasoning behind the changes and how to update
.. affected code.
.. For the full list check
.. `the release changelog <https://github.com/ethereum/solidity/releases/tag/v0.5.0>`_.

このセクションでは、Solidityバージョン0.5.0で導入された主な変更点と、変更の理由、影響を受けるコードの更新方法について説明します。
完全なリストは `リリースのチェンジログ <https://github.com/ethereum/solidity/releases/tag/v0.5.0>`_ をご覧ください。

.. note::
   .. Contracts compiled with Solidity v0.5.0 can still interface with contracts
   .. and even libraries compiled with older versions without recompiling or
   .. redeploying them.  Changing the interfaces to include data locations and
   .. visibility and mutability specifiers suffices. See the
   .. :ref:`Interoperability With Older Contracts <interoperability>` section below.

   Solidity v0.5.0でコンパイルされたコントラクトは、古いバージョンでコンパイルされたコントラクトやライブラリを再コンパイルや再配置することなく、それらとインターフェースをとることができます。
   データの場所や可視性・可変型の指定子を含むようにインターフェースを変更すれば十分です。
   以下の :ref:`Interoperability With Older Contracts <interoperability>` セクションを参照してください。

Semantic Only Changes
=====================

.. This section lists the changes that are semantic-only, thus potentially
.. hiding new and different behavior in existing code.

このセクションでは、セマンティックのみの変更点をリストアップしています。そのため、既存のコードの中に新しい、あるいは異なる動作が隠されている可能性があります。

.. * Signed right shift now uses proper arithmetic shift, i.e. rounding towards
  negative infinity, instead of rounding towards zero.  Signed and unsigned
  shift will have dedicated opcodes in Constantinople, and are emulated by
  Solidity for the moment.

* 符号付き右シフトでは、ゼロに丸めるのではなく、負の無限大に丸めるなど、適切な算術的シフトが使用されるようになりました。符号付きと符号なしのシフトは、Constantinopleでは専用のオペコードが用意されていますが、現時点ではSolidityでエミュレートされています。

.. * The ``continue`` statement in a ``do...while`` loop now jumps to the
  condition, which is the common behavior in such cases. It used to jump to the
  loop body. Thus, if the condition is false, the loop terminates.

*  ``do...while`` ループ内の ``continue`` 文は、条件にジャンプするようになりましたが、これはこのような場合の一般的な動作です。以前は、ループ本体にジャンプしていました。したがって、条件が偽の場合、ループは終了します。

.. * The functions ``.call()``, ``.delegatecall()`` and ``.staticcall()`` do not
  pad anymore when given a single ``bytes`` parameter.

* 関数 ``.call()`` 、 ``.delegatecall()`` 、 ``.staticcall()`` は、単一の ``bytes`` パラメータが与えられた場合、パッドがなくなります。

.. * Pure and view functions are now called using the opcode ``STATICCALL``
  instead of ``CALL`` if the EVM version is Byzantium or later. This
  disallows state changes on the EVM level.

* EVMのバージョンがByzantium以降の場合、PureおよびView関数は ``CALL`` ではなく ``STATICCALL`` というオペコードで呼び出されるようになりました。これにより、EVMレベルでの状態変更ができなくなります。

.. * The ABI encoder now properly pads byte arrays and strings from calldata
  (``msg.data`` and external function parameters) when used in external
  function calls and in ``abi.encode``. For unpadded encoding, use
  ``abi.encodePacked``.

* ABI エンコーダーは、外部関数呼び出しや  ``abi.encode``  で使用される calldata ( ``msg.data``  および外部関数パラメーター) からのバイト配列や文字列を適切にパッドするようになりました。パッドされていないエンコーディングには、 ``abi.encodePacked``  を使用してください。

.. * The ABI decoder reverts in the beginning of functions and in
  ``abi.decode()`` if passed calldata is too short or points out of bounds.
  Note that dirty higher order bits are still simply ignored.

* ABIデコーダは、関数の先頭や ``abi.decode()`` で、渡されたcalldataが短すぎたり、境界外を指したりした場合には、元に戻します。なお、ダーティな高次ビットはまだ単純に無視されます。

.. * Forward all available gas with external function calls starting from
  Tangerine Whistle.

* Tangerine Whistleから始まる外部関数呼び出しで、利用可能なすべてのガスを転送します。

Semantic and Syntactic Changes
==============================

.. This section highlights changes that affect syntax and semantics.

このセクションでは、シンタックスとセマンティックに影響する変更点を紹介します。

.. * The functions ``.call()``, ``.delegatecall()``, ``staticcall()``,
  ``keccak256()``, ``sha256()`` and ``ripemd160()`` now accept only a single
  ``bytes`` argument. Moreover, the argument is not padded. This was changed to
  make more explicit and clear how the arguments are concatenated. Change every
  ``.call()`` (and family) to a ``.call("")`` and every ``.call(signature, a,
  b, c)`` to use ``.call(abi.encodeWithSignature(signature, a, b, c))`` (the
  last one only works for value types).  Change every ``keccak256(a, b, c)`` to
  ``keccak256(abi.encodePacked(a, b, c))``. Even though it is not a breaking
  change, it is suggested that developers change
  ``x.call(bytes4(keccak256("f(uint256)")), a, b)`` to
  ``x.call(abi.encodeWithSignature("f(uint256)", a, b))``.

* 関数 ``.call()`` 、 ``.delegatecall()`` 、 ``staticcall()`` 、 ``keccak256()`` 、 ``sha256()`` 、 ``ripemd160()`` は、 ``bytes`` の引数を1つだけ受け付けるようになりました。さらに、この引数はパディングされません。これは、引数がどのように連結されるかをより明示的かつ明確にするために変更されました。すべての ``.call()`` （およびファミリー）を ``.call("")`` に、すべての ``.call(signature, a, b, c)`` を ``.call(abi.encodeWithSignature(signature, a, b, c))`` に変更しました（最後のものはvalue型でのみ機能します）。すべての ``keccak256(a, b, c)`` を ``keccak256(abi.encodePacked(a, b, c))`` に変更しました。壊すような変更ではありませんが、開発者は ``x.call(bytes4(keccak256("f(uint256)")), a, b)`` を ``x.call(abi.encodeWithSignature("f(uint256)", a, b))`` に変更することを提案します。

.. * Functions ``.call()``, ``.delegatecall()`` and ``.staticcall()`` now return
  ``(bool, bytes memory)`` to provide access to the return data.  Change
  ``bool success = otherContract.call("f")`` to ``(bool success, bytes memory
  data) = otherContract.call("f")``.

* 関数 ``.call()`` 、 ``.delegatecall()`` 、 ``.staticcall()`` が ``(bool, bytes memory)`` を返すようになり、戻りデータへのアクセスが可能になりました。 ``bool success = otherContract.call("f")`` を ``(bool success, bytes memory data) = otherContract.call("f")`` に変更します。

.. * Solidity now implements C99-style scoping rules for function local
  variables, that is, variables can only be used after they have been
  declared and only in the same or nested scopes. Variables declared in the
  initialization block of a ``for`` loop are valid at any point inside the
  loop.

* Solidityは、関数のローカル変数にC99スタイルのスコープルールを実装しました。つまり、変数は宣言された後にのみ使用でき、同じスコープまたはネストされたスコープ内でのみ使用できます。 ``for`` ループの初期化ブロックで宣言された変数は、ループ内のどの時点でも有効です。

Explicitness Requirements
=========================

.. This section lists changes where the code now needs to be more explicit.
.. For most of the topics the compiler will provide suggestions.

このセクションでは、コードをより明確にする必要がある変更点を示します。ほとんどの項目では、コンパイラが提案をしてくれます。

.. * Explicit function visibility is now mandatory.  Add ``public`` to every
  function and constructor, and ``external`` to every fallback or interface
  function that does not specify its visibility already.

* 関数の明示的な可視化が必須になりました。すべての関数とコンストラクタに ``public`` を追加し、可視性を指定していないすべてのフォールバック関数やインターフェース関数に ``external`` を追加します。

.. * Explicit data location for all variables of struct, array or mapping types is
  now mandatory. This is also applied to function parameters and return
  variables.  For example, change ``uint[] x = z`` to ``uint[] storage x =
  z``, and ``function f(uint[][] x)`` to ``function f(uint[][] memory x)``
  where ``memory`` is the data location and might be replaced by ``storage`` or
  ``calldata`` accordingly.  Note that ``external`` functions require
  parameters with a data location of ``calldata``.

* 構造体（struct）、配列（array）、マッピング（mapping）型のすべての変数について、明示的なデータ配置が必須となりました。
  これは、関数のパラメータやリターン変数にも適用されます。
  例えば、 ``uint[] x = z`` を ``uint[] storage x = z`` に、 ``function f(uint[][] x)`` を ``function f(uint[][] memory x)`` に変更すると、 ``memory`` がデータロケーションとなり、 ``storage`` や ``calldata`` に適宜置き換えられます。
  なお、 ``external`` 関数ではデータロケーションが ``calldata`` のパラメータが必要です。

.. * Contract types do not include ``address`` members anymore in
  order to separate the namespaces.  Therefore, it is now necessary to
  explicitly convert values of contract type to addresses before using an
  ``address`` member.  Example: if ``c`` is a contract, change
  ``c.transfer(...)`` to ``address(c).transfer(...)``,
  and ``c.balance`` to ``address(c).balance``.

* 名前空間を分離するために、コントラクト型には ``address`` メンバーが含まれなくなりました。そのため、 ``address`` メンバを使用する前に、コントラクト型の値を明示的にアドレスに変換する必要があります。例:  ``c`` がコントラクトの場合、 ``c.transfer(...)`` を ``address(c).transfer(...)`` に、 ``c.balance`` を ``address(c).balance`` に変更します。

.. * Explicit conversions between unrelated contract types are now disallowed. You can only
  convert from a contract type to one of its base or ancestor types. If you are sure that
  a contract is compatible with the contract type you want to convert to, although it does not
  inherit from it, you can work around this by converting to ``address`` first.
  Example: if ``A`` and ``B`` are contract types, ``B`` does not inherit from ``A`` and
  ``b`` is a contract of type ``B``, you can still convert ``b`` to type ``A`` using ``A(address(b))``.
  Note that you still need to watch out for matching payable fallback functions, as explained below.

* 関連性のないコントラクト型間の明示的な変換ができなくなりました。
  あるコントラクト型から、そのベースまたは祖先の型の1つへの変換のみが可能です。
  あるコントラクトが、変換したいコントラクト型を継承していないものの、互換性があると確信している場合、最初に ``address`` に変換することでこれを回避できます。
  例:  ``A`` と ``B`` がコントラクト型で、 ``B`` は ``A`` から継承されず、 ``b`` は ``B`` 型のコントラクトである場合、 ``A(address(b))`` を使って ``b`` を ``A`` 型に変換できます。
  なお、以下に説明するように、マッチング・ペイバック・フォールバック関数にも注意する必要があります。

.. * The ``address`` type  was split into ``address`` and ``address payable``,
  where only ``address payable`` provides the ``transfer`` function.  An
  ``address payable`` can be directly converted to an ``address``, but the
  other way around is not allowed. Converting ``address`` to ``address
  payable`` is possible via conversion through ``uint160``. If ``c`` is a
  contract, ``address(c)`` results in ``address payable`` only if ``c`` has a
  payable fallback function. If you use the :ref:`withdraw pattern<withdrawal_pattern>`,
  you most likely do not have to change your code because ``transfer``
  is only used on ``msg.sender`` instead of stored addresses and ``msg.sender``
  is an ``address payable``.

* ``address`` 型は ``address`` と ``address payable`` に分割され、 ``address payable`` のみが ``transfer`` 関数を提供しています。
  ``address payable`` を直接 ``address`` に変換できますが、その逆はできません。
  ``address`` から ``address payable`` への変換は、 ``uint160`` による変換で可能です。
  ``c`` がコントラクトの場合、 ``address(c)`` は、 ``c`` に支払い可能なフォールバック関数がある場合に限り、 ``address payable`` になります。
  :ref:`withdraw pattern<withdrawal_pattern>` を使用している場合、 ``transfer`` はストアドアドレスではなく ``msg.sender`` でのみ使用され、 ``msg.sender`` は ``address payable`` になるので、コードを変更する必要はほとんどありません。

.. * Conversions between ``bytesX`` and ``uintY`` of different size are now
  disallowed due to ``bytesX`` padding on the right and ``uintY`` padding on
  the left which may cause unexpected conversion results.  The size must now be
  adjusted within the type before the conversion.  For example, you can convert
  a ``bytes4`` (4 bytes) to a ``uint64`` (8 bytes) by first converting the
  ``bytes4`` variable to ``bytes8`` and then to ``uint64``. You get the
  opposite padding when converting through ``uint32``. Before v0.5.0 any
  conversion between ``bytesX`` and ``uintY`` would go through ``uint8X``. For
  example ``uint8(bytes3(0x291807))`` would be converted to ``uint8(uint24(bytes3(0x291807)))``
  (the result is ``0x07``).

* 異なるサイズの ``bytesX`` と ``uintY`` の間の変換は、 ``bytesX`` のパディングが右に、 ``uintY`` のパディングが左にあるため、予期しない変換結果を引き起こす可能性があるため、許可されなくなりました。変換の前に、型内でサイズを調整する必要があるようになりました。例えば、 ``bytes4`` (4バイト)を ``uint64`` (8バイト)に変換するには、まず ``bytes4`` の変数を ``bytes8`` に変換し、次に ``uint64`` に変換します。 ``uint32`` で変換すると逆にパディングされてしまいます。v0.5.0以前のバージョンでは、 ``bytesX`` と ``uintY`` の間の変換は ``uint8X`` を経由します。例えば、 ``uint8(bytes3(0x291807))`` は ``uint8(uint24(bytes3(0x291807)))`` に変換されます（結果は ``0x07`` ）。

.. * Using ``msg.value`` in non-payable functions (or introducing it via a
  modifier) is disallowed as a security feature. Turn the function into
  ``payable`` or create a new internal function for the program logic that
  uses ``msg.value``.

* 払えない関数で ``msg.value`` を使う（または修飾子で導入する）ことは、セキュリティ機能として認められていません。関数を ``payable`` に変えるか、 ``msg.value`` を使用するプログラムロジックのために新しい内部関数を作成してください。

.. * For clarity reasons, the command line interface now requires ``-`` if the
  standard input is used as source.

* わかりやすくするために、コマンドラインインターフェースでは、標準入力をソースとして使用する場合、 ``-`` を要求するようになりました。

Deprecated Elements
===================

.. This section lists changes that deprecate prior features or syntax.  Note that
.. many of these changes were already enabled in the experimental mode
.. ``v0.5.0``.

このセクションでは、以前の機能や構文を廃止する変更点を紹介します。これらの変更点の多くは、実験モードの ``v0.5.0`` ですでに有効になっていることに注意してください。

Command Line and JSON Interfaces
--------------------------------

.. * The command line option ``--formal`` (used to generate Why3 output for
  further formal verification) was deprecated and is now removed.  A new
  formal verification module, the SMTChecker, is enabled via ``pragma
  experimental SMTChecker;``.

* コマンドラインオプションの ``--formal`` （さらなる形式検証のためにWhy3出力を生成するために使用）は非推奨であり、現在は削除されています。新しいフォーマル検証モジュールであるSMTCheckerは、 ``pragma experimental SMTChecker;`` を介して有効になります。

.. * The command line option ``--julia`` was renamed to ``--yul`` due to the
  renaming of the intermediate language ``Julia`` to ``Yul``.

* 中間言語 ``Julia`` が ``Yul`` に名称変更されたことに伴い、コマンドラインオプション ``--julia`` が ``--yul`` に名称変更されました。

.. * The ``--clone-bin`` and ``--combined-json clone-bin`` command line options
  were removed.

*  ``--clone-bin`` および ``--combined-json clone-bin`` コマンドラインオプションが削除されました。

.. * Remappings with empty prefix are disallowed.

* 空のプレフィックスを持つリマッピングは許可されません。

.. * The JSON AST fields ``constant`` and ``payable`` were removed. The
  information is now present in the ``stateMutability`` field.

* JSON ASTフィールドの ``constant`` と ``payable`` が削除されました。情報は ``stateMutability`` フィールドに存在するようになりました。

.. * The JSON AST field ``isConstructor`` of the ``FunctionDefinition``
  node was replaced by a field called ``kind`` which can have the
  value ``"constructor"``, ``"fallback"`` or ``"function"``.

*  ``FunctionDefinition`` ノードのJSON ASTフィールド ``isConstructor`` が、 ``"constructor"`` 、 ``"fallback"`` 、 ``"function"`` の値を持つことができる ``kind`` というフィールドに置き換えられました。

.. * In unlinked binary hex files, library address placeholders are now
  the first 36 hex characters of the keccak256 hash of the fully qualified
  library name, surrounded by ``$...$``. Previously,
  just the fully qualified library name was used.
  This reduces the chances of collisions, especially when long paths are used.
  Binary files now also contain a list of mappings from these placeholders
  to the fully qualified names.

* リンクされていないバイナリ16進数ファイルでは、ライブラリアドレスのプレースホルダーが、完全修飾ライブラリ名のkeccak256ハッシュの最初の3616文字を ``$...$`` で囲んだものになりました。以前は、完全修飾ライブラリ名のみが使用されていました。これにより、特に長いパスを使用している場合に、衝突の可能性が低くなります。バイナリファイルには、これらのプレースホルダーから完全修飾名へのマッピングのリストも含まれるようになりました。

Constructors
------------

.. * Constructors must now be defined using the ``constructor`` keyword.

* コンストラクタは、 ``constructor`` キーワードを使って定義する必要があります。

.. * Calling base constructors without parentheses is now disallowed.

* ベースコンストラクタを括弧なしで呼び出すことができなくなりました。

.. * Specifying base constructor arguments multiple times in the same inheritance
  hierarchy is now disallowed.

* ベースコンストラクタの引数を同じ継承階層で複数回指定できなくなりました。

.. * Calling a constructor with arguments but with wrong argument count is now
  disallowed.  If you only want to specify an inheritance relation without
  giving arguments, do not provide parentheses at all.

* 引数を持つコンストラクタを、間違った引数数で呼び出すことはできなくなりました。引数を与えずに継承関係だけを指定したい場合は、括弧を一切付けないでください。

Functions
---------

.. * Function ``callcode`` is now disallowed (in favor of ``delegatecall``). It
  is still possible to use it via inline assembly.

*  ``callcode`` 関数は、現在では使用できません（ ``delegatecall`` に変更）。ただし、インラインアセンブリで使用することは可能です。

.. * ``suicide`` is now disallowed (in favor of ``selfdestruct``).

*  ``suicide`` は（ ``selfdestruct`` を優先して）不許可になりました。

.. * ``sha3`` is now disallowed (in favor of ``keccak256``).

*  ``sha3`` は（ ``keccak256`` を優先して）不許可になりました。

.. * ``throw`` is now disallowed (in favor of ``revert``, ``require`` and
  ``assert``).

*  ``throw`` は現在、（ ``revert`` 、 ``require`` 、 ``assert`` に代わって）不許可となっています。

Conversions
-----------

.. * Explicit and implicit conversions from decimal literals to ``bytesXX`` types
  is now disallowed.

* 10進数のリテラルから ``bytesXX`` 型への明示的、暗黙的な変換ができなくなりました。

.. * Explicit and implicit conversions from hex literals to ``bytesXX`` types
  of different size is now disallowed.

* 16進数のリテラルから異なるサイズの ``bytesXX`` 型への明示的および暗黙的な変換ができなくなりました。

Literals and Suffixes
---------------------

.. * The unit denomination ``years`` is now disallowed due to complications and
  confusions about leap years.

* 単位表記の ``years`` は、うるう年の複雑さと混乱のため、現在は認められていません。

.. * Trailing dots that are not followed by a number are now disallowed.

* 数字を含まない末尾のドットは使用できません。

.. * Combining hex numbers with unit denominations (e.g. ``0x1e wei``) is now
  disallowed.

* 16進数と単位表記（例:  ``0x1e wei`` ）の組み合わせができなくなりました。

.. * The prefix ``0X`` for hex numbers is disallowed, only ``0x`` is possible.

* 16進数の接頭辞 ``0X`` は使用できず、 ``0x`` のみ使用可能です。

Variables
---------

.. * Declaring empty structs is now disallowed for clarity.

* 空の構造体を宣言することは、わかりやすくするために禁止されました。

.. * The ``var`` keyword is now disallowed to favor explicitness.

*  ``var`` キーワードを使用しないようにしたことで、明示性が確保されました。

.. * Assignments between tuples with different number of components is now
..   disallowed.

* コンポーネントの数が異なるタプル間の割り当てができなくなりました。

.. * Values for constants that are not compile-time constants are disallowed.

* コンパイル時の定数ではない定数の値は許されません。

.. * Multi-variable declarations with mismatching number of values are now
..   disallowed.

* 値の数が不一致の複数変数の宣言ができなくなりました。

.. * Uninitialized storage variables are now disallowed.

* 初期化されていないストレージ変数が禁止されるようになりました。

.. * Empty tuple components are now disallowed.

* 空のタプル構成要素が許されなくなりました。

.. * Detecting cyclic dependencies in variables and structs is limited in
..   recursion to 256.

* 変数や構造体の周期的な依存関係の検出は、再帰的に256に制限されます。

.. * Fixed-size arrays with a length of zero are now disallowed.

* 長さがゼロの固定サイズの配列が禁止されるようになりました。

Syntax
------

.. * Using ``constant`` as function state mutability modifier is now disallowed.

*  ``constant`` を関数状態の変異性修飾子として使用できなくなりました。

.. * Boolean expressions cannot use arithmetic operations.

* ブール式では、算術演算は使えません。

.. * The unary ``+`` operator is now disallowed.

* 単項の ``+`` 演算子が使えなくなりました。

.. * Literals cannot anymore be used with ``abi.encodePacked`` without prior
..   conversion to an explicit type.

* リテラルは、事前に明示的な型に変換することなく、 ``abi.encodePacked`` で使用できなくなりました。

.. * Empty return statements for functions with one or more return values are now
..   disallowed.

* 1つ以上の戻り値を持つ関数の空の戻り文は認められなくなりました。

.. * The "loose assembly" syntax is now disallowed entirely, that is, jump labels,
..   jumps and non-functional instructions cannot be used anymore. Use the new
..   ``while``, ``switch`` and ``if`` constructs instead.

* つまり、ジャンプラベルやジャンプ、機能しない命令はもう使用できません。代わりに新しい ``while`` 、 ``switch`` 、 ``if`` 構文を使ってください。

.. * Functions without implementation cannot use modifiers anymore.

* 実装のない関数では、修飾子が使えなくなりました。

.. * Function types with named return values are now disallowed.

* 名前付きの戻り値を持つ関数型が禁止されるようになりました。

.. * Single statement variable declarations inside if/while/for bodies that are
..   not blocks are now disallowed.

* ブロックではないif/while/forボディ内の単一の文の変数宣言が禁止されました。

.. * New keywords: ``calldata`` and ``constructor``.

* 新しいキーワードです。 ``calldata`` と ``constructor`` です。

.. * New reserved keywords: ``alias``, ``apply``, ``auto``, ``copyof``,
..   ``define``, ``immutable``, ``implements``, ``macro``, ``mutable``,
..   ``override``, ``partial``, ``promise``, ``reference``, ``sealed``,
..   ``sizeof``, ``supports``, ``typedef`` and ``unchecked``.

* 新しい予約キーワードです。 ``alias`` ,  ``apply`` ,  ``auto`` ,  ``copyof`` ,  ``define`` ,  ``immutable`` ,  ``implements`` ,  ``macro`` ,  ``mutable`` ,  ``override`` ,  ``partial`` ,  ``promise`` ,  ``reference`` ,  ``sealed`` ,  ``sizeof`` ,  ``supports`` ,  ``typedef`` ,  ``unchecked`` 。

.. _interoperability:

Interoperability With Older Contracts
=====================================

.. It is still possible to interface with contracts written for Solidity versions prior to
.. v0.5.0 (or the other way around) by defining interfaces for them.
.. Consider you have the following pre-0.5.0 contract already deployed:

0.5.0より前のバージョンのSolidityで書かれたコントラクトにインターフェースを定義することで、コントラクトとインターフェースを結ぶことができます。以下の0.5.0以前のコントラクトがすでにデプロイされているとします。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.4.25;
    // This will report a warning until version 0.4.25 of the compiler
    // This will not compile after 0.5.0
    contract OldContract {
        function someOldFunction(uint8 a) {
            //...
        }
        function anotherOldFunction() constant returns (bool) {
            //...
        }
        // ...
    }
.. This will no longer compile with Solidity v0.5.0. However, you can define a compatible interface for it:

これはSolidity v0.5.0ではコンパイルされなくなります。ただし、互換性のあるインターフェースを定義することは可能です:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.5.0 <0.9.0;
    interface OldContract {
        function someOldFunction(uint8 a) external;
        function anotherOldFunction() external returns (bool);
    }

.. Note that we did not declare ``anotherOldFunction`` to be ``view``, despite it being declared ``constant`` in the original
.. contract. This is due to the fact that starting with Solidity v0.5.0 ``staticcall`` is used to call ``view`` functions.
.. Prior to v0.5.0 the ``constant`` keyword was not enforced, so calling a function declared ``constant`` with ``staticcall``
.. may still revert, since the ``constant`` function may still attempt to modify storage. Consequently, when defining an
.. interface for older contracts, you should only use ``view`` in place of ``constant`` in case you are absolutely sure that
.. the function will work with ``staticcall``.

オリジナルのコントラクトでは ``constant`` と宣言されていたにもかかわらず、 ``anotherOldFunction`` を ``view`` と宣言していないことに注意してください。これは、Solidity v0.5.0から ``view`` 関数の呼び出しに ``staticcall`` が使われるようになったことによります。v0.5.0以前は ``constant`` キーワードが強制されていなかったため、 ``constant`` と宣言された関数を ``staticcall`` で呼び出しても、 ``constant`` 関数がストレージを変更しようとする可能性があるため、元に戻る可能性があります。したがって、古いコントラクトのインターフェースを定義する際には、その関数が ``staticcall`` で動作することが絶対的に確認できる場合にのみ、 ``constant`` の代わりに ``view`` を使用する必要があります。

.. Given the interface defined above, you can now easily use the already deployed pre-0.5.0 contract:

上記で定義されたインターフェースがあれば、すでにデプロイされたpre-0.5.0のコントラクトを簡単に使用できます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.5.0 <0.9.0;

    interface OldContract {
        function someOldFunction(uint8 a) external;
        function anotherOldFunction() external returns (bool);
    }

    contract NewContract {
        function doSomething(OldContract a) public returns (bool) {
            a.someOldFunction(0x42);
            return a.anotherOldFunction();
        }
    }

.. Similarly, pre-0.5.0 libraries can be used by defining the functions of the library without implementation and
.. supplying the address of the pre-0.5.0 library during linking (see :ref:`commandline-compiler` for how to use the
.. commandline compiler for linking):

同様に、0.5.0以前のライブラリも、実装せずにライブラリの関数を定義し、リンク時に0.5.0以前のライブラリのアドレスを指定することで使用できます（リンク時のコマンドラインコンパイラの使用方法については :ref:`commandline-compiler` をご参照ください）。

.. code-block:: solidity

    // This will not compile after 0.6.0
    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.5.0;

    library OldLibrary {
        function someFunction(uint8 a) public returns(bool);
    }

    contract NewContract {
        function f(uint8 a) public returns (bool) {
            return OldLibrary.someFunction(a);
        }
    }


Example
=======

.. The following example shows a contract and its updated version for Solidity
.. v0.5.0 with some of the changes listed in this section.

次の例は、Solidity v0.5.0のコントラクトとそのアップデート版で、このセクションに記載されている変更点があります。

.. Old version:

古いバージョンです:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.4.25;
    // This will not compile after 0.5.0

    contract OtherContract {
        uint x;
        function f(uint y) external {
            x = y;
        }
        function() payable external {}
    }

    contract Old {
        OtherContract other;
        uint myNumber;

        // Function mutability not provided, not an error.
        function someInteger() internal returns (uint) { return 2; }

        // Function visibility not provided, not an error.
        // Function mutability not provided, not an error.
        function f(uint x) returns (bytes) {
            // Var is fine in this version.
            var z = someInteger();
            x += z;
            // Throw is fine in this version.
            if (x > 100)
                throw;
            bytes memory b = new bytes(x);
            y = -3 >> 1;
            // y == -1 (wrong, should be -2)
            do {
                x += 1;
                if (x > 10) continue;
                // 'Continue' causes an infinite loop.
            } while (x < 11);
            // Call returns only a Bool.
            bool success = address(other).call("f");
            if (!success)
                revert();
            else {
                // Local variables could be declared after their use.
                int y;
            }
            return b;
        }

        // No need for an explicit data location for 'arr'
        function g(uint[] arr, bytes8 x, OtherContract otherContract) public {
            otherContract.transfer(1 ether);

            // Since uint32 (4 bytes) is smaller than bytes8 (8 bytes),
            // the first 4 bytes of x will be lost. This might lead to
            // unexpected behavior since bytesX are right padded.
            uint32 y = uint32(x);
            myNumber += y + msg.value;
        }
    }

.. New version:

新バージョンです:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.5.0;
    // This will not compile after 0.6.0

    contract OtherContract {
        uint x;
        function f(uint y) external {
            x = y;
        }
        function() payable external {}
    }

    contract New {
        OtherContract other;
        uint myNumber;

        // Function mutability must be specified.
        function someInteger() internal pure returns (uint) { return 2; }

        // Function visibility must be specified.
        // Function mutability must be specified.
        function f(uint x) public returns (bytes memory) {
            // The type must now be explicitly given.
            uint z = someInteger();
            x += z;
            // Throw is now disallowed.
            require(x <= 100);
            int y = -3 >> 1;
            require(y == -2);
            do {
                x += 1;
                if (x > 10) continue;
                // 'Continue' jumps to the condition below.
            } while (x < 11);

            // Call returns (bool, bytes).
            // Data location must be specified.
            (bool success, bytes memory data) = address(other).call("f");
            if (!success)
                revert();
            return data;
        }

        using AddressMakePayable for address;
        // Data location for 'arr' must be specified
        function g(uint[] memory /* arr */, bytes8 x, OtherContract otherContract, address unknownContract) public payable {
            // 'otherContract.transfer' is not provided.
            // Since the code of 'OtherContract' is known and has the fallback
            // function, address(otherContract) has type 'address payable'.
            address(otherContract).transfer(1 ether);

            // 'unknownContract.transfer' is not provided.
            // 'address(unknownContract).transfer' is not provided
            // since 'address(unknownContract)' is not 'address payable'.
            // If the function takes an 'address' which you want to send
            // funds to, you can convert it to 'address payable' via 'uint160'.
            // Note: This is not recommended and the explicit type
            // 'address payable' should be used whenever possible.
            // To increase clarity, we suggest the use of a library for
            // the conversion (provided after the contract in this example).
            address payable addr = unknownContract.makePayable();
            require(addr.send(1 ether));

            // Since uint32 (4 bytes) is smaller than bytes8 (8 bytes),
            // the conversion is not allowed.
            // We need to convert to a common size first:
            bytes4 x4 = bytes4(x); // Padding happens on the right
            uint32 y = uint32(x4); // Conversion is consistent
            // 'msg.value' cannot be used in a 'non-payable' function.
            // We need to make the function payable
            myNumber += y + msg.value;
        }
    }

    // We can define a library for explicitly converting ``address``
    // to ``address payable`` as a workaround.
    library AddressMakePayable {
        function makePayable(address x) internal pure returns (address payable) {
            return address(uint160(x));
        }
    }
