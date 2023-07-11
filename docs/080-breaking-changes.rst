*****************************
Solidity v0.8.0の破壊的変更点
*****************************

.. This section highlights the main breaking changes introduced in Solidity version 0.8.0.
.. For the full list check `the release changelog <https://github.com/ethereum/solidity/releases/tag/v0.8.0>`_.

このセクションでは、Solidityのバージョン0.8.0で導入された主な変更点を紹介します。
完全なリストは `リリースチェンジログ <https://github.com/ethereum/solidity/releases/tag/v0.8.0>`_ を参照してください。

<<<<<<< HEAD
.. Silent Changes of the Semantics

セマンティクスのサイレントな変更点
==================================
=======
This section lists changes where existing code changes its behavior without
the compiler notifying you about it.

* Arithmetic operations revert on underflow and overflow. You can use ``unchecked { ... }`` to use
  the previous wrapping behavior.
>>>>>>> english/develop

.. This section lists changes where existing code changes its behaviour without the compiler notifying you about it.

このセクションでは、既存のコードがコンパイラーに通知されることなく動作を変更する変更点を示します。

<<<<<<< HEAD
.. * Arithmetic operations revert on underflow and overflow.
..   You can use ``unchecked { ... }`` to use the previous wrapping behaviour.
=======
  You can choose to use the old behavior using ``pragma abicoder v1;``.
  The pragma ``pragma experimental ABIEncoderV2;`` is still valid, but it is deprecated and has no effect.
  If you want to be explicit, please use ``pragma abicoder v2;`` instead.
>>>>>>> english/develop

..   Checks for overflow are very common, so we made them the default to increase readability of code, even if it comes at a slight increase of gas costs.

* 算術演算は、アンダーフローとオーバーフローでリバートします。
  ``unchecked { ... }`` を使えば、以前の折り返し動作を使うことができます。

  オーバーフローのチェックは非常に一般的なものなので、多少ガス代が高くなってもコードの可読性を高めるためにデフォルトにしました。

.. * ABI coder v2 is activated by default.

..   You can choose to use the old behaviour using ``pragma abicoder v1;``.
..   The pragma ``pragma experimental ABIEncoderV2;`` is still valid, but it is deprecated and has no effect.
..   If you want to be explicit, please use ``pragma abicoder v2;`` instead.

..   Note that ABI coder v2 supports more types than v1 and performs more sanity checks on the inputs.
..   ABI coder v2 makes some function calls more expensive and it can also make contract calls
..   revert that did not revert with ABI coder v1 when they contain data that does not conform to the
..   parameter types.

* ABI coder v2はデフォルトで起動しています。

  ``pragma abicoder v1;`` を使って古い動作を選択できます。
  プラグマ ``pragma experimental ABIEncoderV2;`` はまだ有効ですが、非推奨であり、効果はありません。
  明示的にしたい場合は、代わりに ``pragma abicoder v2;`` を使用してください。

  ABI coder v2は、v1よりも多くの型をサポートし、入力に対してより多くのサニティチェックを行うことに注意してください。
  ABI coder v2では、一部の関数呼び出しがより高価になり、また、パラメータの型に適合しないデータが含まれている場合、ABI coder v1ではリバートしなかったコントラクトコールがリバートすることがあります。

.. * Exponentiation is right associative, i.e., the expression ``a**b**c`` is parsed as ``a**(b**c)``.
..   Before 0.8.0, it was parsed as ``(a**b)**c``.

<<<<<<< HEAD
..   This is the common way to parse the exponentiation operator.
=======
* There are new restrictions related to explicit conversions of literals. The previous behavior in
  the following cases was likely ambiguous:
>>>>>>> english/develop

* つまり、 ``a**b**c`` という式は ``a**(b**c)`` として解析されます。
  0.8.0以前は ``(a**b)**c`` と解析されていました。

  これは、指数演算子を解析する一般的な方法です。

.. * Failing assertions and other internal checks like division by zero or arithmetic overflow do
..   not use the invalid opcode but instead the revert opcode.
..   More specifically, they will use error data equal to a function call to ``Panic(uint256)`` with an error code specific
..   to the circumstances.

..   This will save gas on errors while it still allows static analysis tools to distinguish
..   these situations from a revert on invalid input, like a failing ``require``.

* ゼロ除算や算術オーバーフローなどの失敗したアサーションやその他の内部チェックは、invalid opcodeではなくrevert opcodeを使用します。
  より具体的には、状況に応じたエラーコードを持つ ``Panic(uint256)`` への関数呼び出しと等しいエラーデータを使用します。

  これにより、エラー時のガスを節約できますが、静的解析ツールでは、このような状況を、 ``require`` の失敗のような無効な入力に対するリバートと区別できます。

.. * If a byte array in storage is accessed whose length is encoded incorrectly, a panic is caused.
..   A contract cannot get into this situation unless inline assembly is used to modify the raw representation of storage byte arrays.

* ストレージのバイト配列の長さが正しくエンコードされていないものにアクセスすると、パニックが発生します。
  コントラクトは、ストレージのバイト配列の生の表現を変更するためにインラインアセンブリを使用しない限り、このような状況に陥ることはありません。

<<<<<<< HEAD
.. * If constants are used in array length expressions, previous versions of Solidity would use arbitrary precision
..   in all branches of the evaluation tree. Now, if constant variables are used as intermediate expressions,
..   their values will be properly rounded in the same way as when they are used in run-time expressions.
=======
  These are low-level functions that were largely unused. Their behavior can be accessed from inline assembly.
>>>>>>> english/develop

* 定数を配列の長さの式で使用する場合、以前のバージョンのSolidityでは、評価ツリーのすべての分岐で任意の精度を使用していました。
  現在では、定数変数が中間式として使用されている場合、その値はランタイム式で使用されている場合と同様に適切に丸められます。

* ``byte`` 型は削除されました。
  これは ``bytes1`` の別名でした。

.. New Restrictions

新しい制約
==========

.. This section lists changes that might cause existing contracts to not compile anymore.

このセクションでは、既存のコントラクトのコンパイルができなくなる可能性のある変更点を示します。

.. * There are new restrictions related to explicit conversions of literals. The previous behaviour in
..   the following cases was likely ambiguous:

..   1. Explicit conversions from negative literals and literals larger than ``type(uint160).max`` to
..      ``address`` are disallowed.

..   2. Explicit conversions between literals and an integer type ``T`` are only allowed if the literal
..      lies between ``type(T).min`` and ``type(T).max``. In particular, replace usages of ``uint(-1)``
..      with ``type(uint).max``.

..   3. Explicit conversions between literals and enums are only allowed if the literal can
..      represent a value in the enum.

..   4. Explicit conversions between literals and ``address`` type (e.g. ``address(literal)``) have the
..      type ``address`` instead of ``address payable``. One can get a payable address type by using an
..      explicit conversion, i.e., ``payable(literal)``.

* リテラルの明示的な変換に関連する新しい制限があります。
  以下のようなケースでの従来の動作は、曖昧であったと思われます。

  1. 負のリテラルや ``type(uint160).max`` より大きいリテラルから ``address`` への明示的な変換は禁止されています。
  2. リテラルと整数型 ``T`` の間の明示的な変換は、リテラルが ``type(T).min`` と ``type(T).max`` の間にある場合にのみ許されます。
     特に、 ``uint(-1)`` の使用を ``type(uint).max`` に置き換えてください。
  3. リテラルと列挙型の間の明示的な変換は、リテラルが列挙型の値を表すことができる場合にのみ許可されます。
  4. リテラルと ``address`` 型の間の明示的な変換（例:  ``address(literal)`` ）は、 ``address payable`` の代わりに ``address`` 型を持ちます。
     明示的な変換を使用することで、payableなアドレス型を得ることができます。
     すなわち、 ``payable(literal)`` です。

.. * :ref:`Address literals<address_literals>` have the type ``address`` instead of ``address
..   payable``. They can be converted to ``address payable`` by using an explicit conversion, e.g.
..   ``payable(0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF)``.

* :ref:`アドレスリテラル<address_literals>` は、 ``address payable`` の代わりに ``address`` という型を持っています。
  これらは、 ``payable(0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF)`` のような明示的な変換を用いることで、 ``address payable`` に変換できます。

.. * There are new restrictions on explicit type conversions. The conversion is only allowed when there
..   is at most one change in sign, width or type-category (``int``, ``address``, ``bytesNN``, etc.).
..   To perform multiple changes, use multiple conversions.

<<<<<<< HEAD
..   Let us use the notation ``T(S)`` to denote the explicit conversion ``T(x)``, where, ``T`` and
..   ``S`` are types, and ``x`` is any arbitrary variable of type ``S``. An example of such a
..   disallowed conversion would be ``uint16(int8)`` since it changes both width (8 bits to 16 bits)
..   and sign (signed integer to unsigned integer). In order to do the conversion, one has to go
..   through an intermediate type. In the previous example, this would be ``uint16(uint8(int8))`` or
..   ``uint16(int16(int8))``. Note that the two ways to convert will produce different results e.g.,
..   for ``-1``. The following are some examples of conversions that are disallowed by this rule.

..   - ``address(uint)`` and ``uint(address)``: converting both type-category and width. Replace this by
..     ``address(uint160(uint))`` and ``uint(uint160(address))`` respectively.

..   - ``payable(uint160)``, ``payable(bytes20)`` and ``payable(integer-literal)``: converting both
..     type-category and state-mutability. Replace this by ``payable(address(uint160))``,
..     ``payable(address(bytes20))`` and ``payable(address(integer-literal))`` respectively. Note that
..     ``payable(0)`` is valid and is an exception to the rule.

..   - ``int80(bytes10)`` and ``bytes10(int80)``: converting both type-category and sign. Replace this by
..     ``int80(uint80(bytes10))`` and ``bytes10(uint80(int80)`` respectively.

..   - ``Contract(uint)``: converting both type-category and width. Replace this by
..     ``Contract(address(uint160(uint)))``.

..   These conversions were disallowed to avoid ambiguity. For example, in the expression ``uint16 x =
..   uint16(int8(-1))``, the value of ``x`` would depend on whether the sign or the width conversion
..   was applied first.

* 明示的な型変換には新しい制限があります。
  変換は、符号、幅、または型カテゴリ（ ``int`` 、 ``address`` 、 ``bytesNN`` など）に最大1つの変更がある場合にのみ許可されます。
  複数の変更を行うには、複数の変換を使用します。

  ここで、 ``T`` と ``S`` は型であり、 ``x`` は ``S`` 型の任意の変数である、明示的な変換 ``T(x)`` を表すために ``T(S)`` という表記を使用してみましょう。
  このような許されない変換の例としては、 ``uint16(int8)`` があります。
  ``uint16(int8)`` は幅（8ビットから16ビット）と符号（符号付き整数から符号なし整数）の両方を変更するからです。
  変換を行うためには、中間型を経由しなければなりません。
  先ほどの例では、 ``uint16(uint8(int8))`` または ``uint16(int16(int8))`` となります。
  この2つの変換方法では、例えば ``-1`` の場合、異なる結果が得られることに注意してください。
  以下は、この規則によって許されない変換の例です。

  - ``address(uint)`` と ``uint(address)``: 型カテゴリーと幅の両方を変換します。
    これはそれぞれ ``address(uint160(uint))`` と ``uint(uint160(address))`` に置き換えてください。

  - ``payable(uint160)`` , ``payable(bytes20)``, ``payable(integer-literal)``: 型カテゴリとステートミュータビリティの両方を変換します。
    これはそれぞれ ``payable(address(uint160))`` , ``payable(address(bytes20))`` , ``payable(address(integer-literal))`` に置き換えるてください。
    なお、 ``payable(0)`` は有効であり、例外です。

  - ``int80(bytes10)`` と ``bytes10(int80)``: 型カテゴリーと符号の両方を変換します。
    これはそれぞれ ``int80(uint80(bytes10))`` と ``bytes10(uint80(int80)`` に置き換えてください。

  - ``Contract(uint)``: 型カテゴリと幅の両方を変換しています。
    これは ``Contract(address(uint160(uint)))`` に置き換えてください。

  これらの変換は、曖昧さを避けるために認められませんでした。
  例えば、 ``uint16 x =   uint16(int8(-1))`` という表現では、 ``x`` の値は、符号と幅のどちらの変換が最初に適用されるかに依存します。

.. * Function call options can only be given once, i.e. ``c.f{gas: 10000}{value: 1}()`` is invalid and has to be changed to ``c.f{gas: 10000, value: 1}()``.

* 関数呼び出しのオプションは一度しか与えることができません。
  つまり、 ``c.f{gas: 10000}{value: 1}()`` は無効で、 ``c.f{gas: 10000, value: 1}()`` に変更しなければなりません。

.. * The global functions ``log0``, ``log1``, ``log2``, ``log3`` and ``log4`` have been removed.

..   These are low-level functions that were largely unused. Their behaviour can be accessed from inline assembly.

* グローバル関数の ``log0`` 、 ``log1`` 、 ``log2`` 、 ``log3`` 、 ``log4`` が削除されました。

  これらは、ほとんど使われていない低レベルの関数です。
  これらの動作はインラインアセンブリからアクセスできます。

.. * ``enum`` definitions cannot contain more than 256 members.

..   This will make it safe to assume that the underlying type in the ABI is always ``uint8``.

* ``enum`` 定義は256個以上のメンバーを含むことはできません。

  これにより、ABIの基礎となる型が常に ``uint8`` であると仮定しても安全になります。

.. * Declarations with the name ``this``, ``super`` and ``_`` are disallowed, with the exception of
..   public functions and events. The exception is to make it possible to declare interfaces of contracts
..   implemented in languages other than Solidity that do permit such function names.

* ``this`` 、 ``super`` 、 ``_`` という名前の宣言は、パブリック関数とイベントを除いて禁止されています。
  この例外は、Solidity以外の言語で実装されたコントラクトのインターフェースを宣言できるようにするためのもので、このような関数名を許可しています。

.. * Remove support for the ``\b``, ``\f``, and ``\v`` escape sequences in code.
..   They can still be inserted via hexadecimal escapes, e.g. ``\x08``, ``\x0c``, and ``\x0b``, respectively.

* コード内の ``\b`` 、 ``\f`` 、 ``\v`` のエスケープシーケンスのサポートを削除しました。
  これらは、それぞれ ``\x08`` 、 ``\x0c`` 、 ``\x0b`` などの16進数のエスケープで挿入できます。

.. * The global variables ``tx.origin`` and ``msg.sender`` have the type ``address`` instead of
..   ``address payable``. One can convert them into ``address payable`` by using an explicit
..   conversion, i.e., ``payable(tx.origin)`` or ``payable(msg.sender)``.

..   This change was done since the compiler cannot determine whether or not these addresses
..   are payable or not, so it now requires an explicit conversion to make this requirement visible.

* グローバル変数 ``tx.origin`` と ``msg.sender`` の型は、 ``address payable`` ではなく ``address`` です。
  これらを ``address payable`` に変換するには、明示的な変換を、すなわち ``payable(tx.origin)`` または ``payable(msg.sender)`` を用いてください。

  この変更は、これらのアドレスがpayableかどうかをコンパイラが判断できないため、この要件を可視化するために明示的な変換を必要とするようになりました。

.. * Explicit conversion into ``address`` type always returns a non-payable ``address`` type. In
..   particular, the following explicit conversions have the type ``address`` instead of ``address
..   payable``:

..   - ``address(u)`` where ``u`` is a variable of type ``uint160``. One can convert ``u``
..     into the type ``address payable`` by using two explicit conversions, i.e.,
..     ``payable(address(u))``.

..   - ``address(b)`` where ``b`` is a variable of type ``bytes20``. One can convert ``b``
..     into the type ``address payable`` by using two explicit conversions, i.e.,
..     ``payable(address(b))``.

..   - ``address(c)`` where ``c`` is a contract. Previously, the return type of this
..     conversion depended on whether the contract can receive Ether (either by having a receive
..     function or a payable fallback function). The conversion ``payable(c)`` has the type ``address
..     payable`` and is only allowed when the contract ``c`` can receive Ether. In general, one can
..     always convert ``c`` into the type ``address payable`` by using the following explicit
..     conversion: ``payable(address(c))``. Note that ``address(this)`` falls under the same category
..     as ``address(c)`` and the same rules apply for it.

* ``address`` 型への明示的な変換は、常に支払い不可能な ``address`` 型を返します。
  特に、以下の明示的な変換は、 ``address payable`` 型ではなく ``address`` 型になります。

  - ``address(u)`` ここで、 ``u`` は ``uint160`` 型の変数です。
    ``u`` を ``address payable`` 型に変換するには、2つの明示的な変換、すなわち ``payable(address(u))`` を用いてください。
  - ``address(b)`` ここで、 ``b`` は ``bytes20`` 型の変数です。
    ``b`` を ``address payable`` 型に変換するには、2つの明示的な変換、すなわち ``payable(address(b))`` を用いてください。
  - ``address(c)`` （ ``c`` はコントラクト）。
    以前は、この変換のリターン型は、コントラクトがEtherを受信できるかどうかに依存していました（受信関数または支払可能なフォールバック関数を持つことにより）。
    ``payable(c)`` 変換は ``address payable`` 型で、コントラクト ``c`` がEtherを受け取ることができる場合にのみ許可されます。
    一般的には、次の明示的な変換を用いることで、常に ``c`` を ``address payable`` 型に変換できます: ``payable(address(c))`` 。
    ``address(this)`` は、 ``address(c)`` と同じカテゴリーに属し、同じルールが適用されることに注意してください。

* インラインアセンブリの ``chainid`` ビルトインは、 ``pure`` ではなく ``view`` とみなされるようになりました。

.. * Unary negation cannot be used on unsigned integers anymore, only on signed integers.

* 単項否定は符号なし整数では使用できなくなり、符号付き整数でのみ使用できるようになりました。

インターフェースの変更
======================

.. * The output of ``--combined-json`` has changed: JSON fields ``abi``, ``devdoc``, ``userdoc`` and
..   ``storage-layout`` are sub-objects now. Before 0.8.0 they used to be serialised as strings.

* ``--combined-json`` の出力が変わりました。
  JSONのフィールド ``abi`` 、 ``devdoc`` 、 ``userdoc`` 、 ``storage-layout`` がサブオブジェクトになりました。
  0.8.0以前では、これらは文字列としてシリアライズされていました。

.. * The "legacy AST" has been removed (``--ast-json`` on the commandline interface and ``legacyAST`` for standard JSON).
..   Use the "compact AST" (``--ast-compact--json`` resp. ``AST``) as replacement.

* 「レガシーAST」が削除されました（コマンドラインインターフェースでは ``--ast-json`` 、標準JSONでは ``legacyAST`` ）。
  代わりに「コンパクトAST」（ ``--ast-compact--json`` 、標準JSONでは ``AST`` ）を使用してください。

.. * The old error reporter (``--old-reporter``) has been removed.

* 旧エラーレポーター（ ``--old-reporter`` ）は削除されました。

コードのアップデート方法
========================

.. - If you rely on wrapping arithmetic, surround each operation with ``unchecked { ... }``.
.. - Optional: If you use SafeMath or a similar library, change ``x.add(y)`` to ``x + y``, ``x.mul(y)`` to ``x * y`` etc.
.. - Add ``pragma abicoder v1;`` if you want to stay with the old ABI coder.
.. - Optionally remove ``pragma experimental ABIEncoderV2`` or ``pragma abicoder v2`` since it is redundant.
.. - Add intermediate explicit type conversions if required.
.. - Combine ``c.f{gas: 10000}{value: 1}()`` to ``c.f{gas: 10000, value: 1}()``.
.. - Change ``msg.sender.transfer(x)`` to ``payable(msg.sender).transfer(x)`` or use a stored variable of ``address payable`` type.
.. - Negate unsigned integers by subtracting them from the maximum value of the type and adding 1 (e.g. ``type(uint256).max - x + 1``, while ensuring that `x` is not zero)

- ラッピング算術（オーバーフローを許容する算術）に頼っている場合は、各演算を ``unchecked { ... }`` で囲んでください。
- オプション: SafeMathまたは同様のライブラリを使用している場合は、 ``x.add(y)`` を ``x + y`` 、 ``x.mul(y)`` を ``x * y`` などに変更してください。
- 古いABIコーダーを使用したい場合は、 ``pragma abicoder v1;`` を追加してください。
- 冗長なので、オプションで ``pragma experimental ABIEncoderV2`` または ``pragma abicoder v2`` を削除してください。
- ``byte`` を ``bytes1`` に変更してください。
- 必要に応じて、中間の明示的な型変換を追加してください。
- ``c.f{gas: 10000}{value: 1}()`` を ``c.f{gas: 10000, value: 1}()`` に結合してください。
- ``msg.sender.transfer(x)`` を ``payable(msg.sender).transfer(x)`` に変更するか、 ``address payable`` 型のstored変数を使用してください。
- ``x**y**z`` を ``(x**y)**z`` に変更してください。
- ``log0`` 、...、 ``log4`` の代わりにインラインアセンブリを使用してください。
- 符号なし整数を、その型の最大値から引いて1を加えて否定してください（例: ``type(uint256).max - x + 1`` 、ただし ``x`` はゼロではないことを確認してください）。
=======
- If you rely on wrapping arithmetic, surround each operation with ``unchecked { ... }``.
- Optional: If you use SafeMath or a similar library, change ``x.add(y)`` to ``x + y``, ``x.mul(y)`` to ``x * y`` etc.
- Add ``pragma abicoder v1;`` if you want to stay with the old ABI coder.
- Optionally remove ``pragma experimental ABIEncoderV2`` or ``pragma abicoder v2`` since it is redundant.
- Change ``byte`` to ``bytes1``.
- Add intermediate explicit type conversions if required.
- Combine ``c.f{gas: 10000}{value: 1}()`` to ``c.f{gas: 10000, value: 1}()``.
- Change ``msg.sender.transfer(x)`` to ``payable(msg.sender).transfer(x)`` or use a stored variable of ``address payable`` type.
- Change ``x**y**z`` to ``(x**y)**z``.
- Use inline assembly as a replacement for ``log0``, ..., ``log4``.
- Negate unsigned integers by subtracting them from the maximum value of the type and adding 1 (e.g. ``type(uint256).max - x + 1``, while ensuring that ``x`` is not zero)
>>>>>>> english/develop
