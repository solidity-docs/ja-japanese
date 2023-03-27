*****************************
Solidity v0.6.0の破壊的変更点
*****************************

.. This section highlights the main breaking changes introduced in Solidity
.. version 0.6.0, along with the reasoning behind the changes and how to update
.. affected code.
.. For the full list check
.. `the release changelog <https://github.com/ethereum/solidity/releases/tag/v0.6.0>`_.

このセクションでは、Solidityバージョン0.6.0で導入された主な変更点と、変更の理由、影響を受けるコードの更新方法について説明します。完全なリストは `the release changelog <https://github.com/ethereum/solidity/releases/tag/v0.6.0>`_ をご覧ください。


Changes the Compiler Might not Warn About
=========================================

.. This section lists changes where the behaviour of your code might
.. change without the compiler telling you about it.

このセクションでは、コンパイラーが教えてくれないのにコードの動作が変更される可能性のある変更点を挙げます。

.. * The resulting type of an exponentiation is the type of the base. It used to be the smallest type
..   that can hold both the type of the base and the type of the exponent, as with symmetric
..   operations. Additionally, signed types are allowed for the base of the exponentiation.

* 指数計算の結果として得られる型は、基数の型です。以前は、対称演算のように、基数の型と指数の型の両方を保持できる最小の型でした。さらに、指数の底には符号付きの型が許されています。


Explicitness Requirements
=========================

.. This section lists changes where the code now needs to be more explicit,
.. but the semantics do not change.
.. For most of the topics the compiler will provide suggestions.

このセクションでは、コードをより明確にする必要があるが、セマンティクスは変わらないという変更点を挙げます。ほとんどの項目では、コンパイラが提案をしてくれます。

.. * Functions can now only be overridden when they are either marked with the
..   ``virtual`` keyword or defined in an interface. Functions without
..   implementation outside an interface have to be marked ``virtual``.
..   When overriding a function or modifier, the new keyword ``override``
..   must be used. When overriding a function or modifier defined in multiple
..   parallel bases, all bases must be listed in parentheses after the keyword
..   like so: ``override(Base1, Base2)``.

* 関数は、 ``virtual`` キーワードでマークされているか、インターフェースで定義されている場合にのみオーバーライドできるようになりました。インターフェースの外で実装されていない関数は、 ``virtual`` とマークされなければなりません。関数や修飾子をオーバーライドする際には、新しいキーワード ``override`` を使用しなければなりません。複数の並列ベースで定義された関数や修飾子をオーバーライドする場合、キーワードの後の括弧内にすべてのベースを以下のように記載する必要があります。 ``override(Base1, Base2)`` .

.. * Member-access to ``length`` of arrays is now always read-only, even for storage arrays. It is no
..   longer possible to resize storage arrays by assigning a new value to their length. Use ``push()``,
..   ``push(value)`` or ``pop()`` instead, or assign a full array, which will of course overwrite the existing content.
..   The reason behind this is to prevent storage collisions of gigantic
..   storage arrays.

* アレイの ``length`` へのメンバーアクセスは、ストレージアレイであっても常に読み取り専用になりました。ストレージアレイの長さに新しい値を割り当ててサイズを変更できなくなりました。代わりに ``push()`` 、 ``push(value)`` 、 ``pop()`` を使用するか、完全なアレイを割り当てると、当然ながら既存のコンテンツは上書きされます。この理由は、巨大なストレージアレイのストレージ衝突を防ぐためです。

.. * The new keyword ``abstract`` can be used to mark contracts as abstract. It has to be used
..   if a contract does not implement all its functions. Abstract contracts cannot be created using the ``new`` operator,
..   and it is not possible to generate bytecode for them during compilation.

* 新しいキーワード ``abstract`` は、コントラクトを抽象的にマークするために使用できます。これはコントラクトがそのすべての関数を実装していない場合に使用しなければなりません。抽象コントラクトは ``new`` 演算子を使って作成できませんし、コンパイル時にコントラクト用のバイトコードを生成することもできません。

.. * Libraries have to implement all their functions, not only the internal ones.

* ライブラリは、内部だけでなく、すべての関数を実装しなければなりません。

.. * The names of variables declared in inline assembly may no longer end in ``_slot`` or ``_offset``.

* インラインアセンブリで宣言された変数の名前は、 ``_slot`` や ``_offset`` で終わることはありません。

.. * Variable declarations in inline assembly may no longer shadow any declaration outside the inline assembly block.
..   If the name contains a dot, its prefix up to the dot may not conflict with any declaration outside the inline
..   assembly block.

* インラインアセンブリ内の変数宣言は、インラインアセンブリブロック外の宣言を影で支えることはできません。名前にドットが含まれている場合、ドットまでの接頭辞はインラインアセンブリブロック外の宣言と衝突してはなりません。

.. * State variable shadowing is now disallowed.  A derived contract can only
..   declare a state variable ``x``, if there is no visible state variable with
..   the same name in any of its bases.

* In inline assembly, opcodes that do not take arguments are now represented as "built-in functions" instead of standalone identifiers. So ``gas`` is now ``gas()``.

* 状態変数のシャドーイングが禁止されました。派生コントラクトは、そのベースのいずれかに同名の可視状態変数が存在しない場合にのみ、状態変数 ``x`` を宣言できます。

Semantic and Syntactic Changes
==============================

.. This section lists changes where you have to modify your code
.. and it does something else afterwards.

このセクションでは、コードを修正する必要があり、その後に何か別のことが行われる変更点をリストアップしています。

.. * Conversions from external function types to ``address`` are now disallowed. Instead external
..   function types have a member called ``address``, similar to the existing ``selector`` member.

* 外部関数型から ``address`` への変換は認められなくなりました。その代わりに、外部関数型は既存の ``selector`` メンバと同様に ``address`` というメンバを持ちます。

.. * The function ``push(value)`` for dynamic storage arrays does not return the new length anymore (it returns nothing).

* 動的ストレージアレイ用の関数 ``push(value)`` は、新しい長さを返さなくなりました（何も返しません）。

.. * The unnamed function commonly referred to as "fallback function" was split up into a new
..   fallback function that is defined using the ``fallback`` keyword and a receive ether function
..   defined using the ``receive`` keyword.

* 一般的に「fallback関数」と呼ばれる無名関数は、 ``fallback`` キーワードで定義される新しいfallback関数と、 ``receive`` キーワードで定義されるreceive Ether関数に分割されました。

..   * If present, the receive ether function is called whenever the call data is empty (whether
..     or not ether is received). This function is implicitly ``payable``.

* 存在する場合、コールデータが空になるたびに（Etherを受信したかどうかに関わらず）receive Ether関数が呼び出されます。この関数は暗黙のうちに ``payable`` です。

..   * The new fallback function is called when no other function matches (if the receive ether
..     function does not exist then this includes calls with empty call data).
..     You can make this function ``payable`` or not. If it is not ``payable`` then transactions
..     not matching any other function which send value will revert. You should only need to
..     implement the new fallback function if you are following an upgrade or proxy pattern.

* 新しいフォールバック関数は、他の関数がマッチしない場合に呼び出されます（receive Ether関数が存在しない場合は、コールデータが空のコールも含まれます）。この関数を ``payable`` にするかどうかは自由です。 ``payable`` でない場合は、値を送信する他の関数にマッチしないトランザクションが復帰します。新しいフォールバック関数を実装する必要があるのは、アップグレードやプロキシのパターンに従っている場合だけです。


New Features
============

.. This section lists things that were not possible prior to Solidity 0.6.0
.. or were more difficult to achieve.

このセクションでは、Solidity 0.6.0以前では実現できなかったことや、実現が困難だったことを挙げています。

.. * The :ref:`try/catch statement <try-catch>` allows you to react on failed external calls.
.. * ``struct`` and ``enum`` types can be declared at file level.
.. * Array slices can be used for calldata arrays, for example ``abi.decode(msg.data[4:], (uint, uint))``
..   is a low-level way to decode the function call payload.
.. * Natspec supports multiple return parameters in developer documentation, enforcing the same naming check as ``@param``.
.. * Yul and Inline Assembly have a new statement called ``leave`` that exits the current function.
.. * Conversions from ``address`` to ``address payable`` are now possible via ``payable(x)``, where
..   ``x`` must be of type ``address``.

* :ref:`try/catch statement <try-catch>` では、失敗した外部呼び出しに反応できます。
* ``struct`` および ``enum`` 型は、ファイルレベルで宣言できます。
* 例えば ``abi.decode(msg.data[4:], (uint, uint))`` は関数呼び出しのペイロードをデコードする低レベルな方法です。
* Natspecは開発者向けドキュメントで複数のリターン・パラメータをサポートし、 ``@param`` と同じネーミング・チェックを実施します。
* YulとInline Assemblyには、現在の関数を終了させる ``leave`` という新しいステートメントがあります。
* ``address`` から ``address payable`` への変換は ``payable(x)`` を介して可能になりました。


Interface Changes
=================

.. This section lists changes that are unrelated to the language itself, but that have an effect on the interfaces of
.. the compiler. These may change the way how you use the compiler on the command line, how you use its programmable
.. interface, or how you analyze the output produced by it.

このセクションでは、言語そのものとは関係なく、コンパイラーのインターフェースに影響を与える変更点を紹介します。これらの変更により、コマンドラインでのコンパイラの使用方法、プログラマブル・インターフェースの使用方法、コンパイラが生成した出力の分析方法が変わる可能性があります。

New Error Reporter
~~~~~~~~~~~~~~~~~~

.. A new error reporter was introduced, which aims at producing more accessible error messages on the command line.
.. It is enabled by default, but passing ``--old-reporter`` falls back to the the deprecated old error reporter.

新しいエラーレポーターが導入され、コマンドラインでよりアクセスしやすいエラーメッセージを表示することを目的としています。これは、コマンドライン上でよりアクセスしやすいエラーメッセージを生成することを目的としています。デフォルトでは有効になっていますが、 ``--old-reporter`` を通過すると、非推奨の古いエラーレポーターに戻ります。

Metadata Hash Options
~~~~~~~~~~~~~~~~~~~~~

.. The compiler now appends the `IPFS <https://ipfs.io/>`_ hash of the metadata file to the end of the bytecode by default
.. (for details, see documentation on :doc:`contract metadata <metadata>`). Before 0.6.0, the compiler appended the
.. `Swarm <https://ethersphere.github.io/swarm-home/>`_ hash by default, and in order to still support this behaviour,
.. the new command line option ``--metadata-hash`` was introduced. It allows you to select the hash to be produced and
.. appended, by passing either ``ipfs`` or ``swarm`` as value to the ``--metadata-hash`` command line option.
.. Passing the value ``none`` completely removes the hash.

コンパイラは、メタデータファイルの  `IPFS <https://ipfs.io/>`_  ハッシュをデフォルトでバイトコードの最後に追加するようになりました (詳細については、 :doc:`contract metadata <metadata>` のドキュメントを参照してください)。0.6.0より前のバージョンでは、コンパイラはデフォルトで `Swarm <https://ethersphere.github.io/swarm-home/>`_ ハッシュを付加していましたが、この動作を引き続きサポートするために、新しいコマンドラインオプション ``--metadata-hash`` が導入されました。 ``--metadata-hash`` コマンドラインオプションの値として ``ipfs`` または ``swarm`` を渡すことで、生成および付加されるハッシュを選択できます。 ``none`` という値を渡すと、ハッシュが完全に削除されます。

.. These changes can also be used via the :ref:`Standard JSON Interface<compiler-api>` and effect the metadata JSON generated by the compiler.

これらの変更は、 :ref:`Standard JSON Interface<compiler-api>` を介して使用することもでき、コンパイラによって生成されるメタデータJSONに影響を与えます。

.. The recommended way to read the metadata is to read the last two bytes to determine the length of the CBOR encoding
.. and perform a proper decoding on that data block as explained in the :ref:`metadata section<encoding-of-the-metadata-hash-in-the-bytecode>`.

推奨されるメタデータの読み方は、最後の2バイトを読んでCBORエンコーディングの長さを判断し、 :ref:`metadata section<encoding-of-the-metadata-hash-in-the-bytecode>` で説明されているようにそのデータブロックに対して適切なデコーディングを行うことです。

Yul Optimizer
~~~~~~~~~~~~~

.. Together with the legacy bytecode optimizer, the :doc:`Yul <yul>` optimizer is now enabled by default when you call the compiler
.. with ``--optimize``. It can be disabled by calling the compiler with ``--no-optimize-yul``.
.. This mostly affects code that uses ABI coder v2.

レガシーのバイトコードオプティマイザとともに、 :doc:`Yul <yul>` オプティマイザが  ``--optimize``  でコンパイラーを呼び出したときにデフォルトで有効になりました。これを無効にするには、 ``--no-optimize-yul``  でコンパイラを呼び出します。これは主に ABI coder v2 を使用しているコードに影響します。

C API Changes
~~~~~~~~~~~~~

.. The client code that uses the C API of ``libsolc`` is now in control of the memory used by the compiler. To make
.. this change consistent, ``solidity_free`` was renamed to ``solidity_reset``, the functions ``solidity_alloc`` and
.. ``solidity_free`` were added and ``solidity_compile`` now returns a string that must be explicitly freed via
.. ``solidity_free()``.

``libsolc`` のC APIを使用するクライアントコードは、コンパイラが使用するメモリを制御するようになりました。この変更に一貫性を持たせるために、 ``solidity_free`` は ``solidity_reset`` に改名され、関数 ``solidity_alloc`` と ``solidity_free`` が追加され、 ``solidity_compile`` は ``solidity_free()`` を介して明示的に解放しなければならない文字列を返すようになりました。


How to update your code
=======================

.. This section gives detailed instructions on how to update prior code for every breaking change.

このセクションでは、変更のたびに先行コードを更新する方法を詳しく説明しています。

.. * Change ``address(f)`` to ``f.address`` for ``f`` being of external function type.

*  ``f`` が外部関数型のため、 ``address(f)`` を ``f.address`` に変更。

.. * Replace ``function () external [payable] { ... }`` by either ``receive() external payable { ... }``,
..   ``fallback() external [payable] { ... }`` or both. Prefer
..   using a ``receive`` function only, whenever possible.

*  ``function () external [payable] { ... }`` を ``receive() external payable { ... }`` 、 ``fallback() external [payable] { ... }`` のいずれか、または両方で置き換える。可能な限り、 ``receive`` 関数のみを使用してください。

.. * Change ``uint length = array.push(value)`` to ``array.push(value);``. The new length can be
..   accessed via ``array.length``.

*  ``uint length = array.push(value)`` を ``array.push(value);`` に変更します。新しい長さは ``array.length`` からアクセスできます。

.. * Change ``array.length++`` to ``array.push()`` to increase, and use ``pop()`` to decrease
..   the length of a storage array.

* ストレージアレイの長さを増やすには ``array.length++`` を ``array.push()`` に変更し、減らすには ``pop()`` を使用します。

.. * For every named return parameter in a function's ``@dev`` documentation define a ``@return``
..   entry which contains the parameter's name as the first word. E.g. if you have function ``f()`` defined
..   like ``function f() public returns (uint value)`` and a ``@dev`` annotating it, document its return
..   parameters like so: ``@return value The return value.``. You can mix named and un-named return parameters
..   documentation so long as the notices are in the order they appear in the tuple return type.

* 関数の ``@dev`` ドキュメントでは、名前のついたリターンパラメータごとに、パラメータの名前を最初の単語として含む ``@return`` エントリを定義します。例えば、関数 ``f()`` が ``function f() public returns (uint value)`` のように定義されていて、それに注釈をつけた ``@dev`` がある場合、その戻りパラメータを次のように文書化します。 ``@return value The return value.`` 。タプルの戻り値の型に表示されている順序で通知を行う限り、名前のある戻り値パラメータと名前のない戻り値パラメータの文書を混在させることができます。

.. * Choose unique identifiers for variable declarations in inline assembly that do not conflict
..   with declarations outside the inline assembly block.

* インラインアセンブリ内の変数宣言には、インラインアセンブリブロック外の宣言と衝突しないように、一意の識別子を選択してください。

.. * Add ``virtual`` to every non-interface function you intend to override. Add ``virtual``
..   to all functions without implementation outside interfaces. For single inheritance, add
..   ``override`` to every overriding function. For multiple inheritance, add ``override(A, B, ..)``,
..   where you list all contracts that define the overridden function in the parentheses. When
..   multiple bases define the same function, the inheriting contract must override all conflicting functions.
.. 

* オーバーライドしようとするすべての非インタフェース関数に ``virtual`` を追加します。インターフェースの外にある実装のないすべての関数に ``virtual`` を追加します。単一継承の場合は、オーバーライドするすべての関数に ``override`` を追加します。多重継承の場合は、 ``override(A, B, ..)`` を追加し、オーバーライドする関数を定義するすべてのコントラクトを括弧内に列挙します。複数のベースが同じ関数を定義している場合、継承するコントラクトは、競合するすべての関数をオーバーライドしなければなりません。

* In inline assembly, add ``()`` to all opcodes that do not otherwise accept an argument.
  For example, change ``pc`` to ``pc()``, and ``gas`` to ``gas()``.
