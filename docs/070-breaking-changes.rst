*****************************
Solidity v0.7.0の破壊的変更点
*****************************

.. This section highlights the main breaking changes introduced in Solidity
.. version 0.7.0, along with the reasoning behind the changes and how to update
.. affected code.
.. For the full list check
.. `the release changelog <https://github.com/ethereum/solidity/releases/tag/v0.7.0>`_.

このセクションでは、Solidityバージョン0.7.0で導入された主な変更点と、変更の理由、影響を受けるコードの更新方法について説明します。完全なリストは `the release changelog <https://github.com/ethereum/solidity/releases/tag/v0.7.0>`_ を参照してください。


.. Silent Changes of the Semantics

セマンティクスのサイレントな変更点
==================================

.. * Exponentiation and shifts of literals by non-literals (e.g. ``1 << x`` or ``2 ** x``)
..   will always use either the type ``uint256`` (for non-negative literals) or
..   ``int256`` (for negative literals) to perform the operation.
..   Previously, the operation was performed in the type of the shift amount / the
..   exponent which can be misleading.

* リテラルの非リテラル（ ``1 << x`` や ``2 ** x`` など）による指数化やシフトは、常に ``uint256`` 型（非負のリテラル用）または ``int256`` 型（負のリテラル用）を使用して演算を行います。
  これまでは、シフト量／指数の型で演算を行っていたため、誤解を招く恐れがありました。


.. Changes to the Syntax

シンタックスの変更点
====================

.. * In external function and contract creation calls, Ether and gas is now specified using a new syntax:
..   ``x.f{gas: 10000, value: 2 ether}(arg1, arg2)``.
..   The old syntax -- ``x.f.gas(10000).value(2 ether)(arg1, arg2)`` -- will cause an error.

* 外部関数やコントラクト作成コールで、イーサやガスが新しい構文で指定されるようになりました。 ``x.f{gas: 10000, value: 2 ether}(arg1, arg2)`` です。従来の構文（ ``x.f.gas(10000).value(2 ether)(arg1, arg2)`` ）ではエラーになります。

.. * The global variable ``now`` is deprecated, ``block.timestamp`` should be used instead.
..   The single identifier ``now`` is too generic for a global variable and could give the impression
..   that it changes during transaction processing, whereas ``block.timestamp`` correctly
..   reflects the fact that it is just a property of the block.

* グローバル変数 ``now`` は非推奨であり、代わりに ``block.timestamp`` を使用すべきです。 ``now`` という単一の識別子は、グローバル変数としては一般的すぎて、トランザクション処理中に変化するような印象を与える可能性がありますが、 ``block.timestamp`` は単なるブロックのプロパティであるという事実を正しく反映しています。

.. * NatSpec comments on variables are only allowed for public state variables and not
..   for local or internal variables.

* 変数に関するNatSpecコメントは、パブリックな状態の変数に対してのみ許可され、ローカルまたは内部の変数に対しては許可されません。

.. * The token ``gwei`` is a keyword now (used to specify, e.g. ``2 gwei`` as a number)
..   and cannot be used as an identifier.

* トークン ``gwei`` は、現在のキーワード（例えば ``2 gwei`` を数字で指定するために使用）であり、識別子としては使用できません。

.. * String literals now can only contain printable ASCII characters and this also includes a variety of
..   escape sequences, such as hexadecimal (``\xff``) and unicode escapes (``\u20ac``).

* 文字列リテラルには、印刷可能なASCII文字のみを含めることができるようになり、16進数（ ``\xff`` ）やユニコードエスケープ（ ``\u20ac`` ）などの様々なエスケープシーケンスも含まれています。

.. * Unicode string literals are supported now to accommodate valid UTF-8 sequences. They are identified
..   with the ``unicode`` prefix: ``unicode"Hello 😃"``.

* Unicode文字列リテラルがサポートされ、有効なUTF-8シーケンスに対応できるようになりました。これらは ``unicode`` という接頭語で識別されます。 ``unicode"Hello 😃"`` です。

.. * State Mutability: The state mutability of functions can now be restricted during inheritance:
..   Functions with default state mutability can be overridden by ``pure`` and ``view`` functions
..   while ``view`` functions can be overridden by ``pure`` functions.
..   At the same time, public state variables are considered ``view`` and even ``pure``
..   if they are constants.

* 状態の変更可能性継承の際に、関数の状態変更性を制限できるようになりました。デフォルトの状態変更可能性を持つ関数は、 ``pure`` および ``view`` 関数でオーバーライドでき、 ``view`` 関数は ``pure`` 関数でオーバーライドできます。同時に、パブリックな状態変数は ``view`` とみなされ、定数であれば ``pure`` ともみなされます。


Inline Assembly
---------------

.. * Disallow ``.`` in user-defined function and variable names in inline assembly.
..   It is still valid if you use Solidity in Yul-only mode.

* インラインアセンブリのユーザー定義関数および変数名に ``.`` を使用できないようにしました。SolidityをYul-onlyモードで使用している場合も有効です。

.. * Slot and offset of storage pointer variable ``x`` are accessed via ``x.slot``
..   and ``x.offset`` instead of ``x_slot`` and ``x_offset``.

* ストレージポインタ変数 ``x`` のスロットとオフセットは、 ``x_slot`` と ``x_offset`` ではなく ``x.slot`` と ``x.offset`` でアクセスされます。

未使用または安全でない機能の削除
================================

Mappings outside Storage
------------------------

.. * If a struct or array contains a mapping, it can only be used in storage.
..   Previously, mapping members were silently skipped in memory, which
..   is confusing and error-prone.

* 構造体や配列にマッピングが含まれている場合、そのマッピングはストレージでのみ使用できます。これまでは、マッピングのメンバーはメモリ内で静かにスキップされていたため、混乱してエラーが発生しやすくなっていました。

.. * Assignments to structs or arrays in storage does not work if they contain
..   mappings.
..   Previously, mappings were silently skipped during the copy operation, which
..   is misleading and error-prone.

* ストレージ内の構造体や配列への代入にマッピングが含まれていると動作しません。これまでは、マッピングはコピー操作中に自動的にスキップされていましたが、これは誤解を招きやすく、エラーが発生しやすいものでした。

Functions and Events
--------------------

.. * Visibility (``public`` / ``internal``) is not needed for constructors anymore:
..   To prevent a contract from being created, it can be marked ``abstract``.
..   This makes the visibility concept for constructors obsolete.

* コンストラクタには可視性（ ``public``  /  ``internal`` ）は必要なくなりました。コントラクトが作成されないようにするには、 ``abstract`` マークを付けることができます。これにより、コンストラクタの可視性の概念は廃止されました。

.. * Type Checker: Disallow ``virtual`` for library functions:
..   Since libraries cannot be inherited from, library functions should not be virtual.

* 型チェッカー。ライブラリ関数の ``virtual`` を禁止する。ライブラリは継承できないので、ライブラリ関数は仮想関数であってはならない。

.. * Multiple events with the same name and parameter types in the same
..   inheritance hierarchy are disallowed.

* 同一の継承階層に同一名称、同一パラメータ型のイベントが複数存在することは認められません。

.. * ``using A for B`` only affects the contract it is mentioned in.
..   Previously, the effect was inherited. Now, you have to repeat the ``using``
..   statement in all derived contracts that make use of the feature.

*  ``using A for B`` は、記載されているコントラクトにのみ影響を与えます。以前は、この効果は継承されていました。現在では、この関数を利用するすべての派生コントラクトで ``using`` 文を繰り返さなければなりません。

Expressions
-----------

.. * Shifts by signed types are disallowed.
..   Previously, shifts by negative amounts were allowed, but reverted at runtime.

* 符号付きの型によるシフトは禁止されています。以前は、負の金額によるシフトは許可されていましたが、実行時に元に戻されました。

.. * The ``finney`` and ``szabo`` denominations are removed.
..   They are rarely used and do not make the actual amount readily visible. Instead, explicit
..   values like ``1e20`` or the very common ``gwei`` can be used.

*  ``finney`` と ``szabo`` のデノミネーションは削除されています。これらはほとんど使用されず、実際の金額を容易に確認できません。代わりに、 ``1e20`` や非常に一般的な ``gwei`` のような明確な値を使用できます。

Declarations
------------

.. * The keyword ``var`` cannot be used anymore.
..   Previously, this keyword would parse but result in a type error and
..   a suggestion about which type to use. Now, it results in a parser error.

* キーワード「 ``var`` 」が使用できなくなりました。以前は、このキーワードは解析されますが、型エラーが発生し、どの型を使用すべきかの提案がありました。現在は、パーサーエラーとなります。

インターフェースの変更点
========================

.. * JSON AST: Mark hex string literals with ``kind: "hexString"``.
.. * JSON AST: Members with value ``null`` are removed from JSON output.
.. * NatSpec: Constructors and functions have consistent userdoc output.

* JSON AST: 16進文字列リテラルを ``kind: "hexString"`` でマークするようになりました。
* JSON AST: 値が ``null`` のメンバーをJSON出力から削除しました。
* NatSpec: コンストラクタと関数に一貫したユーザードキュメントを出力するようにしました。

コードのアップデート方法
========================

.. This section gives detailed instructions on how to update prior code for every breaking change.

このセクションでは、変更のたびに先行コードを更新する方法を詳しく説明しています。

.. * Change ``x.f.value(...)()`` to ``x.f{value: ...}()``. Similarly ``(new C).value(...)()`` to
..   ``new C{value: ...}()`` and ``x.f.gas(...).value(...)()`` to ``x.f{gas: ..., value: ...}()``.
.. * Change ``now`` to ``block.timestamp``.
.. * Change types of right operand in shift operators to unsigned types. For example change ``x >> (256 - y)`` to
..   ``x >> uint(256 - y)``.
.. * Repeat the ``using A for B`` statements in all derived contracts if needed.
.. * Remove the ``public`` keyword from every constructor.
.. * Remove the ``internal`` keyword from every constructor and add ``abstract`` to the contract (if not already present).
.. * Change ``_slot`` and ``_offset`` suffixes in inline assembly to ``.slot`` and ``.offset``, respectively.
.. 

* ``x.f.value(...)()`` を ``x.f{value: ...}()`` に変更。同様に ``(new C).value(...)()`` を ``new C{value: ...}()`` に、 ``x.f.gas(...).value(...)()`` を ``x.f{gas: ..., value: ...}()`` に。
* ``now``  を  ``block.timestamp``  に変更。
* シフト演算子の右オペランドの型を符号なしに変更。例えば、 ``x >> (256 - y)`` を ``x >> uint(256 - y)`` に変更します。
* 必要に応じて、すべての派生コントラクトで ``using A for B`` 文を繰り返します。
* すべてのコンストラクタから  ``public``  キーワードを削除します。
* すべてのコンストラクタから  ``internal``  キーワードを削除し、コントラクトに  ``abstract``  を追加します（まだ存在しない場合）。
* インライン アセンブリの  ``_slot``  と  ``_offset``  の接尾辞をそれぞれ  ``.slot``  と  ``.offset``  に変更します。