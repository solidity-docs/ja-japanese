.. index:: abi, application binary interface

.. _ABI:

**************************
Contract ABI Specification
**************************

Basic Design
============

.. The Contract Application Binary Interface (ABI) is the standard way to interact with contracts in the Ethereum ecosystem, both
.. from outside the blockchain and for contract-to-contract interaction. Data is encoded according to its type,
.. as described in this specification. The encoding is not self describing and thus requires a schema in order to decode.

コントラクト・アプリケーション・バイナリ・インターフェース（ABI）は、Ethereumエコシステム内のコントラクトと対話するための標準的な方法であり、ブロックチェーンの外側からも、コントラクト間の対話のためにも使用されます。データは、この仕様書に記載されているように、そのタイプに応じてエンコードされます。符号化は自己記述的ではないため、デコードするためにはスキーマが必要です。

.. We assume the interface functions of a contract are strongly typed, known at compilation time and static.
.. We assume that all contracts will have the interface definitions of any contracts they call available at compile-time.

我々は、コントラクトのインタフェース関数が強く型付けされ、コンパイル時に知られており、かつ静的であると仮定する。すべてのコントラクトは、それらが呼び出すコントラクトのインタフェース定義をコンパイル時に利用可能であると仮定します。

.. This specification does not address contracts whose interface is dynamic or otherwise known only at run-time.

この仕様では、インターフェイスが動的であるなど、実行時にしかわからないコントラクトは扱わない。

.. _abi_function_selector:
.. index:: selector

Function Selector
=================

.. The first four bytes of the call data for a function call specifies the function to be called. It is the
.. first (left, high-order in big-endian) four bytes of the Keccak-256 hash of the signature of
.. the function. The signature is defined as the canonical expression of the basic prototype without data
.. location specifier, i.e.
.. the function name with the parenthesised list of parameter types. Parameter types are split by a single
.. comma - no spaces are used.

関数呼び出しのコールデータの最初の4バイトは、呼び出される関数を指定します。これは、関数のシグネチャのKeccak-256ハッシュの最初（左、ビッグエンディアンの高次）の4バイトです。シグネチャは、データ位置指定子のない基本プロトタイプの正規表現として定義されています。つまり、関数名と括弧で囲まれたパラメータタイプのリストです。パラメータタイプは1つのコンマで分割され、スペースは使用されません。

.. .. note::

..     The return type of a function is not part of this signature. In
..     :ref:`Solidity's function overloading <overload-function>` return types are not considered.
..     The reason is to keep function call resolution context-independent.
..     The :ref:`JSON description of the ABI<abi_json>` however contains both inputs and outputs.

.. note::

    関数の戻り値は、この署名の一部ではない。 :ref:`Solidity's function overloading <overload-function>` では戻り値の型は考慮されません。     その理由は、関数呼び出しの解決をコンテキストに依存しないようにするためです。     しかし、 :ref:`JSON description of the ABI<abi_json>` では入力と出力の両方が含まれます。

Argument Encoding
=================

.. Starting from the fifth byte, the encoded arguments follow. This encoding is also used in
.. other places, e.g. the return values and also event arguments are encoded in the same way,
.. without the four bytes specifying the function.

5バイト目からは、エンコードされた引数が続きます。このエンコーディングは他の場所でも使用されています。例えば、戻り値やイベントの引数も同じようにエンコーディングされ、関数を指定する4バイトはありません。

Types
=====

.. The following elementary types exist:

次のような初級タイプがあります。

.. - ``uint<M>``: unsigned integer type of ``M`` bits, ``0 < M <= 256``, ``M % 8 == 0``. e.g. ``uint32``, ``uint8``, ``uint256``.

- ``uint<M>`` :  ``M`` ビット、 ``0 < M <= 256`` 、 ``M % 8 == 0`` の符号なし整数型 例:  ``uint32`` 、 ``uint8`` 、 ``uint256``

.. - ``int<M>``: two's complement signed integer type of ``M`` bits, ``0 < M <= 256``, ``M % 8 == 0``.

- ``int<M>`` :  ``M`` ビットの2の補数符号付き整数型、 ``0 < M <= 256`` 、 ``M % 8 == 0`` 。

.. - ``address``: equivalent to ``uint160``, except for the assumed interpretation and language typing.
..   For computing the function selector, ``address`` is used.

- ``address`` : 想定される解釈と言語の型付けを除き、 ``uint160`` と同等です。   関数セレクタの計算には、 ``address`` を使用します。

.. - ``uint``, ``int``: synonyms for ``uint256``, ``int256`` respectively. For computing the function
..   selector, ``uint256`` and ``int256`` have to be used.

- ``uint`` 、 ``int`` : それぞれ ``uint256`` 、 ``int256`` の同義語です。ファンクションセレクタの計算には、 ``uint256`` と ``int256`` を使用する必要があります。

.. - ``bool``: equivalent to ``uint8`` restricted to the values 0 and 1. For computing the function selector, ``bool`` is used.

- ``bool`` : 0と1に限定された ``uint8`` に相当し、ファンクションセレクターの演算には ``bool`` を使用します。

.. - ``fixed<M>x<N>``: signed fixed-point decimal number of ``M`` bits, ``8 <= M <= 256``,
..   ``M % 8 == 0``, and ``0 < N <= 80``, which denotes the value ``v`` as ``v / (10 ** N)``.

- ``fixed<M>x<N>`` :  ``M`` ビット、 ``8 <= M <= 256`` 、 ``M % 8 == 0`` 、 ``0 < N <= 80`` の符号付き固定小数点10進数で、 ``v`` の値を ``v / (10 ** N)`` と表記します。

.. - ``ufixed<M>x<N>``: unsigned variant of ``fixed<M>x<N>``.

- ``ufixed<M>x<N>`` :  ``fixed<M>x<N>`` の符号なしの変型。

.. - ``fixed``, ``ufixed``: synonyms for ``fixed128x18``, ``ufixed128x18`` respectively. For
..   computing the function selector, ``fixed128x18`` and ``ufixed128x18`` have to be used.

- ``fixed`` 、 ``ufixed`` : それぞれ ``fixed128x18`` 、 ``ufixed128x18`` の同義語です。ファンクションセレクタの計算には、 ``fixed128x18`` と ``ufixed128x18`` を使用する必要があります。

.. - ``bytes<M>``: binary type of ``M`` bytes, ``0 < M <= 32``.

- ``bytes<M>`` :  ``M`` バイトのバイナリタイプ、 ``0 < M <= 32`` 。

.. - ``function``: an address (20 bytes) followed by a function selector (4 bytes). Encoded identical to ``bytes24``.

- ``function`` : アドレス（20バイト）の後に関数セレクター（4バイト）が続く。 ``bytes24`` と同じようにエンコードされます。

.. The following (fixed-size) array type exists:

次のような（固定サイズの）配列タイプが存在します。

.. - ``<type>[M]``: a fixed-length array of ``M`` elements, ``M >= 0``, of the given type.

..   .. note::

..       While this ABI specification can express fixed-length arrays with zero elements, they're not supported by the compiler.

- ``<type>[M]`` : 与えられた型の ``M`` 要素の固定長の配列、 ``M >= 0`` 。

  .. note::

      このABI仕様では、要素数が0の固定長の配列を表現できますが、コンパイラではサポートされていません。

.. The following non-fixed-size types exist:

以下のような非固定サイズのタイプが存在する。

.. - ``bytes``: dynamic sized byte sequence.

- ``bytes`` : ダイナミックサイズのバイトシーケンス。

.. - ``string``: dynamic sized unicode string assumed to be UTF-8 encoded.

- ``string`` : UTF-8でエンコードされていると仮定したダイナミックサイズのユニコード文字列。

.. - ``<type>[]``: a variable-length array of elements of the given type.

- ``<type>[]`` : 指定された型の要素を持つ可変長の配列。

.. Types can be combined to a tuple by enclosing them inside parentheses, separated by commas:

型は、カンマで区切って括弧で囲むことでタプルにまとめることができます。

.. - ``(T1,T2,...,Tn)``: tuple consisting of the types ``T1``, ..., ``Tn``, ``n >= 0``

- ``(T1,T2,...,Tn)`` :  ``T1`` , ...,  ``Tn`` ,  ``n >= 0`` の各タイプからなるタプル

.. It is possible to form tuples of tuples, arrays of tuples and so on. It is also possible to form zero-tuples (where ``n == 0``).

タプルのタプル、タプルのアレーなどを形成することが可能です。また、ゼロタプルを形成することも可能です（ ``n == 0`` の場合）。

Mapping Solidity to ABI types
-----------------------------

.. Solidity supports all the types presented above with the same names with the
.. exception of tuples. On the other hand, some Solidity types are not supported
.. by the ABI. The following table shows on the left column Solidity types that
.. are not part of the ABI, and on the right column the ABI types that represent
.. them.

Solidityでは、タプルを除いて、上記で紹介したすべての型を同じ名前でサポートしています。一方で、Solidityの型の中には、ABIではサポートされていないものもあります。次の表は、左の列にABIに含まれないSolidityの型を、右の列にそれを表すABIの型を示しています。

+-------------------------------+-----------------------------------------------------------------------------+
|      Solidity                 |                                           ABI                               |
+===============================+=============================================================================+
|:ref:`address payable<address>`|``address``                                                                  |
+-------------------------------+-----------------------------------------------------------------------------+
|:ref:`contract<contracts>`     |``address``                                                                  |
+-------------------------------+-----------------------------------------------------------------------------+
|:ref:`enum<enums>`             |``uint8``                                                                    |
+-------------------------------+-----------------------------------------------------------------------------+
|:ref:`user defined value types |its underlying value type                                                    |
|<user-defined-value-types>`    |                                                                             |
+-------------------------------+-----------------------------------------------------------------------------+
|:ref:`struct<structs>`         |``tuple``                                                                    |
+-------------------------------+-----------------------------------------------------------------------------+

.. .. warning::

..     Before version ``0.8.0`` enums could have more than 256 members and were represented by the
..     smallest integer type just big enough to hold the value of any member.

.. warning::

    バージョン ``0.8.0`` 以前のenumは256以上のメンバーを持つことができ、任意のメンバーの値を保持するのに十分な大きさの最小の整数型で表されていました。

Design Criteria for the Encoding
================================

.. The encoding is designed to have the following properties, which are especially useful if some arguments are nested arrays:

このエンコーディングは、以下のような特性を持つように設計されており、いくつかの引数が入れ子になった配列である場合には、特に便利です。

.. 1. The number of reads necessary to access a value is at most the depth of the value
..    inside the argument array structure, i.e. four reads are needed to retrieve ``a_i[k][l][r]``. In a
..    previous version of the ABI, the number of reads scaled linearly with the total number of dynamic
..    parameters in the worst case.

1. 値にアクセスするために必要な読み取り回数は、最大でも引数配列構造内の値の深さ分であり、すなわち ``a_i[k][l][r]`` を取得するためには4回の読み取りが必要です。以前のバージョンのABIでは、最悪の場合、読み取り回数は動的パラメータの総数に比例していました。

.. 2. The data of a variable or array element is not interleaved with other data and it is
..    relocatable, i.e. it only uses relative "addresses".

2. 変数や配列要素のデータは、他のデータとインターリーブされておらず、相対的な「アドレス」のみを使用する、リロケータブルなものです。

Formal Specification of the Encoding
====================================

.. We distinguish static and dynamic types. Static types are encoded in-place and dynamic types are
.. encoded at a separately allocated location after the current block.

ここでは、スタティック型とダイナミック型を区別します。スタティックタイプはその場でエンコードされ、ダイナミックタイプは現在のブロックの後に別個に割り当てられた場所でエンコードされます。

.. **Definition:** The following types are called "dynamic":

**Definition:**  次のようなタイプを「ダイナミック」と呼びます。

.. * ``bytes``

* ``bytes``

.. * ``string``

* ``string``

.. * ``T[]`` for any ``T``

* 任意の ``T`` に対して ``T[]``

.. * ``T[k]`` for any dynamic ``T`` and any ``k >= 0``

* 任意のダイナミック ``T`` と任意の ``k >= 0`` に対する ``T[k]``

.. * ``(T1,...,Tk)`` if ``Ti`` is dynamic for some ``1 <= i <= k``

* ある ``1 <= i <= k`` に対して ``Ti`` がダイナミックな場合、 ``(T1,...,Tk)``

.. All other types are called "static".

それ以外のタイプは「スタティック」と呼ばれます。

.. **Definition:** ``len(a)`` is the number of bytes in a binary string ``a``.
.. The type of ``len(a)`` is assumed to be ``uint256``.

**Definition:**   ``len(a)`` は、2進数の文字列 ``a`` のバイト数です。 ``len(a)`` の型は ``uint256`` とします。

.. We define ``enc``, the actual encoding, as a mapping of values of the ABI types to binary strings such
.. that ``len(enc(X))`` depends on the value of ``X`` if and only if the type of ``X`` is dynamic.

実際のエンコーディングである ``enc`` は、ABI型の値をバイナリ文字列にマッピングしたものと定義し、 ``X`` の型がdynamicである場合に限り、 ``len(enc(X))`` が ``X`` の値に依存するようにします。

.. **Definition:** For any ABI value ``X``, we recursively define ``enc(X)``, depending
.. on the type of ``X`` being

**Definition:**  任意のABI値 ``X`` に対して、 ``X`` の種類に応じて ``enc(X)`` を再帰的に定義します。

.. - ``(T1,...,Tk)`` for ``k >= 0`` and any types ``T1``, ..., ``Tk``

..   ``enc(X) = head(X(1)) ... head(X(k)) tail(X(1)) ... tail(X(k))``

..   where ``X = (X(1), ..., X(k))`` and
..   ``head`` and ``tail`` are defined for ``Ti`` as follows:

..   if ``Ti`` is static:

..     ``head(X(i)) = enc(X(i))`` and ``tail(X(i)) = ""`` (the empty string)

..   otherwise, i.e. if ``Ti`` is dynamic:

..     ``head(X(i)) = enc(len( head(X(1)) ... head(X(k)) tail(X(1)) ... tail(X(i-1)) ))``
..     ``tail(X(i)) = enc(X(i))``

..   Note that in the dynamic case, ``head(X(i))`` is well-defined since the lengths of
..   the head parts only depend on the types and not the values. The value of ``head(X(i))`` is the offset
..   of the beginning of ``tail(X(i))`` relative to the start of ``enc(X)``.

- ``k >= 0`` と任意のタイプ ``T1`` , ...,  ``Tk`` のための ``(T1,...,Tk)``

  ``enc(X) = head(X(1)) ... head(X(k)) tail(X(1)) ... tail(X(k))``

  ここで、 ``X = (X(1), ..., X(k))`` と ``head`` と ``tail`` は、 ``Ti`` に対して次のように定義される。

  ``Ti`` が静止している場合

    ``head(X(i)) = enc(X(i))`` と ``tail(X(i)) = ""`` （空の文字列）

  それ以外の場合、つまり ``Ti`` がダイナミックな場合。

    ``head(X(i)) = enc(len( head(X(1)) ... head(X(k)) tail(X(1)) ... tail(X(i-1)) ))``   ``tail(X(i)) = enc(X(i))``

  なお、動的なケースでは、ヘッドパーツの長さはタイプにのみ依存し、値には依存しないため、 ``head(X(i))`` はよく定義されています。 ``head(X(i))`` の値は、 ``enc(X)`` の開始位置に対する ``tail(X(i))`` の開始位置のオフセットです。

.. - ``T[k]`` for any ``T`` and ``k``:

..   ``enc(X) = enc((X[0], ..., X[k-1]))``

..   i.e. it is encoded as if it were a tuple with ``k`` elements
..   of the same type.

- 任意の ``T`` と ``k`` のための ``T[k]`` 。

  ``enc(X) = enc((X[0], ..., X[k-1]))``

  つまり、同じタイプの ``k`` 要素を持つタプルであるかのようにエンコードされます。

.. - ``T[]`` where ``X`` has ``k`` elements (``k`` is assumed to be of type ``uint256``):

..   ``enc(X) = enc(k) enc([X[0], ..., X[k-1]])``

..   i.e. it is encoded as if it were an array of static size ``k``, prefixed with
..   the number of elements.

- ``X`` が ``k`` の要素を持つ ``T[]`` （ ``k`` は ``uint256`` 型とする）。

  ``enc(X) = enc(k) enc([X[0], ..., X[k-1]])``

  つまり、静的なサイズ ``k`` の配列のようにエンコードされ、その前に要素数が付けられます。

.. - ``bytes``, of length ``k`` (which is assumed to be of type ``uint256``):

..   ``enc(X) = enc(k) pad_right(X)``, i.e. the number of bytes is encoded as a
..   ``uint256`` followed by the actual value of ``X`` as a byte sequence, followed by
..   the minimum number of zero-bytes such that ``len(enc(X))`` is a multiple of 32.

- 長さ ``k`` の ``bytes`` （これはタイプ ``uint256`` であると仮定される）。

  ``enc(X) = enc(k) pad_right(X)`` 、すなわち、バイト数は ``uint256`` に続いて ``X`` の実際の値をバイト列として符号化し、その後に ``len(enc(X))`` が32の倍数になるような最小数のゼロバイトが続く。

.. - ``string``:

..   ``enc(X) = enc(enc_utf8(X))``, i.e. ``X`` is UTF-8 encoded and this value is interpreted
..   as of ``bytes`` type and encoded further. Note that the length used in this subsequent
..   encoding is the number of bytes of the UTF-8 encoded string, not its number of characters.

- ``string`` です。

  ``enc(X) = enc(enc_utf8(X))`` 、つまり ``X`` はUTF-8でエンコードされ、この値は ``bytes`` タイプと解釈され、さらにエンコードされます。なお、この後のエンコードで使用する長さは、文字数ではなく、UTF-8でエンコードされた文字列のバイト数です。

.. - ``uint<M>``: ``enc(X)`` is the big-endian encoding of ``X``, padded on the higher-order
..   (left) side with zero-bytes such that the length is 32 bytes.

- ``uint<M>`` です。 ``enc(X)`` は、 ``X`` のビッグエンディアン・エンコーディングで、高次（左）側に0バイトをパディングし、長さが32バイトになるようにしたものです。

.. - ``address``: as in the ``uint160`` case

- ``address`` :  ``uint160`` の場合と同様

.. - ``int<M>``: ``enc(X)`` is the big-endian two's complement encoding of ``X``, padded on the higher-order (left) side with ``0xff`` bytes for negative ``X`` and with zero-bytes for non-negative ``X`` such that the length is 32 bytes.

- ``int<M>`` です。 ``enc(X)`` は ``X`` のビッグエンディアンの2の補数で、高次（左）側に負の ``X`` には ``0xff`` バイト、非負の ``X`` には0バイトをパディングし、長さが32バイトになるようにしたものです。

.. - ``bool``: as in the ``uint8`` case, where ``1`` is used for ``true`` and ``0`` for ``false``

- ``bool`` :  ``uint8`` の場合と同様に、 ``true`` には ``1`` 、 ``false`` には ``0`` が使われる

.. - ``fixed<M>x<N>``: ``enc(X)`` is ``enc(X * 10**N)`` where ``X * 10**N`` is interpreted as a ``int256``.

- ``fixed<M>x<N>`` です。 ``enc(X)`` は ``enc(X * 10**N)`` で ``X * 10**N`` は ``int256`` と解釈されます。

.. - ``fixed``: as in the ``fixed128x18`` case

- ``fixed`` :  ``fixed128x18`` の場合と同様

.. - ``ufixed<M>x<N>``: ``enc(X)`` is ``enc(X * 10**N)`` where ``X * 10**N`` is interpreted as a ``uint256``.

- ``ufixed<M>x<N>`` です。 ``enc(X)`` は ``enc(X * 10**N)`` で ``X * 10**N`` は ``uint256`` と解釈されます。

.. - ``ufixed``: as in the ``ufixed128x18`` case

- ``ufixed`` :  ``ufixed128x18`` の場合と同様

.. - ``bytes<M>``: ``enc(X)`` is the sequence of bytes in ``X`` padded with trailing zero-bytes to a length of 32 bytes.

- ``bytes<M>`` です。 ``enc(X)`` は、 ``X`` のバイト列に末尾にゼロバイトを追加して32バイトにしたもの。

.. Note that for any ``X``, ``len(enc(X))`` is a multiple of 32.

なお、任意の ``X`` に対して、 ``len(enc(X))`` は32の倍数です。

Function Selector and Argument Encoding
=======================================

.. All in all, a call to the function ``f`` with parameters ``a_1, ..., a_n`` is encoded as

..   ``function_selector(f) enc((a_1, ..., a_n))``

つまり、パラメータ ``a_1, ..., a_n`` を持つ関数 ``f`` の呼び出しは、次のようにエンコードされます。

  ``function_selector(f) enc((a_1, ..., a_n))``

.. and the return values ``v_1, ..., v_k`` of ``f`` are encoded as

..   ``enc((v_1, ..., v_k))``

となり、 ``f`` の戻り値 ``v_1, ..., v_k`` は次のようにエンコードされます。

  ``enc((v_1, ..., v_k))``

.. i.e. the values are combined into a tuple and encoded.

つまり、値がタプルにまとめられ、エンコードされます。

Examples
========

.. Given the contract:

コントラクト考えると:

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract Foo {
        function bar(bytes3[2] memory) public pure {}
        function baz(uint32 x, bool y) public pure returns (bool r) { r = x > 32 || y; }
        function sam(bytes memory, bool, uint[] memory) public pure {}
    }

.. Thus for our ``Foo`` example if we wanted to call ``baz`` with the parameters ``69`` and
.. ``true``, we would pass 68 bytes total, which can be broken down into:

したがって、 ``Foo`` の例では、 ``69`` と ``true`` というパラメータで ``baz`` を呼び出す場合、合計68バイトを渡すことになり、その内訳は次のとおりです。

.. - ``0xcdcd77c0``: the Method ID. This is derived as the first 4 bytes of the Keccak hash of
..   the ASCII form of the signature ``baz(uint32,bool)``.

- ``0xcdcd77c0`` : メソッドID。これは、署名 ``baz(uint32,bool)`` のASCII形式のKeccakハッシュの最初の4バイトとして導出される。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000045``: the first parameter,
..   a uint32 value ``69`` padded to 32 bytes

- ``0x0000000000000000000000000000000000000000000000000000000000000045`` : 第1パラメータ、uint32値  ``69`` : 32バイトにパディングされた値

.. - ``0x0000000000000000000000000000000000000000000000000000000000000001``: the second parameter

- ``0x0000000000000000000000000000000000000000000000000000000000000001`` : 第2パラメータ

.. - boolean
..   ``true``, padded to 32 bytes

- 32バイトにパディングされたブーリアン ``true``

.. In total:

合計で

.. code-block:: none

    0xcdcd77c000000000000000000000000000000000000000000000000000000000000000450000000000000000000000000000000000000000000000000000000000000001

.. It returns a single ``bool``. If, for example, it were to return ``false``, its output would be
.. the single byte array ``0x0000000000000000000000000000000000000000000000000000000000000000``, a single bool.

それは単一の ``bool`` を返す。例えば、 ``false`` を返すとしたら、その出力は1バイトの配列 ``0x0000000000000000000000000000000000000000000000000000000000000000`` 、1つのboolとなります。

.. If we wanted to call ``bar`` with the argument ``["abc", "def"]``, we would pass 68 bytes total, broken down into:

``bar`` を ``["abc", "def"]`` の引数で呼び出す場合、合計68バイトを渡すことになり、その内訳は以下の通りです。

.. - ``0xfce353f6``: the Method ID. This is derived from the signature ``bar(bytes3[2])``.

- ``0xfce353f6`` : メソッドID。これはシグネチャー ``bar(bytes3[2])`` から得られる。

.. - ``0x6162630000000000000000000000000000000000000000000000000000000000``: the first part of the first
..   parameter, a ``bytes3`` value ``"abc"`` (left-aligned).

- ``0x6162630000000000000000000000000000000000000000000000000000000000`` : 第1パラメータの最初の部分で、 ``bytes3`` 値 ``"abc"`` （左寄せ）のこと。

.. - ``0x6465660000000000000000000000000000000000000000000000000000000000``: the second part of the first
..   parameter, a ``bytes3`` value ``"def"`` (left-aligned).

- ``0x6465660000000000000000000000000000000000000000000000000000000000`` : 第1パラメータの2番目の部分で、 ``bytes3`` 値 ``"def"`` （左寄せ）。

.. In total:

合計で

.. code-block:: none

    0xfce353f661626300000000000000000000000000000000000000000000000000000000006465660000000000000000000000000000000000000000000000000000000000

.. If we wanted to call ``sam`` with the arguments ``"dave"``, ``true`` and ``[1,2,3]``, we would
.. pass 292 bytes total, broken down into:

引数 ``"dave"`` 、 ``true`` 、 ``[1,2,3]`` で ``sam`` を呼び出したい場合、合計292バイトを渡すことになり、その内訳は以下の通りです。

.. - ``0xa5643bf2``: the Method ID. This is derived from the signature ``sam(bytes,bool,uint256[])``. Note that ``uint`` is replaced with its canonical representation ``uint256``.

- ``0xa5643bf2`` : メソッドID。これは署名 ``sam(bytes,bool,uint256[])`` から派生したものです。 ``uint`` はその正規表現 ``uint256`` に置き換えられていることに注意してください。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000060``: the location of the data part of the first parameter (dynamic type), measured in bytes from the start of the arguments block. In this case, ``0x60``.

- ``0x0000000000000000000000000000000000000000000000000000000000000060`` : 第1パラメータ（ダイナミックタイプ）のデータ部の位置で、引数ブロックの先頭からのバイト数で表します。この場合は ``0x60`` 。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000001``: the second parameter: boolean true.

- ``0x0000000000000000000000000000000000000000000000000000000000000001`` : 第2パラメータ: 真偽値

.. - ``0x00000000000000000000000000000000000000000000000000000000000000a0``: the location of the data part of the third parameter (dynamic type), measured in bytes. In this case, ``0xa0``.

- ``0x00000000000000000000000000000000000000000000000000000000000000a0`` : 3番目のパラメータ（ダイナミックタイプ）のデータ部分の位置で、単位はバイトです。ここでは ``0xa0`` とします。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000004``: the data part of the first argument, it starts with the length of the byte array in elements, in this case, 4.

- ``0x0000000000000000000000000000000000000000000000000000000000000004`` : 第1引数のデータ部で、バイト配列の長さを要素数で表したものから始まり、ここでは4としています。

.. - ``0x6461766500000000000000000000000000000000000000000000000000000000``: the contents of the first argument: the UTF-8 (equal to ASCII in this case) encoding of ``"dave"``, padded on the right to 32 bytes.

- ``0x6461766500000000000000000000000000000000000000000000000000000000`` : 第1引数の内容:  ``"dave"`` のUTF-8（ここではASCIIに相当）エンコードを右にパディングして32バイトにしたもの。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000003``: the data part of the third argument, it starts with the length of the array in elements, in this case, 3.

- ``0x0000000000000000000000000000000000000000000000000000000000000003`` : 第3引数のデータ部分で、配列の長さを要素数で表したものから始まり、この場合は3となります。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000001``: the first entry of the third parameter.

- ``0x0000000000000000000000000000000000000000000000000000000000000001`` : 第3パラメータの最初のエントリ。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000002``: the second entry of the third parameter.

- ``0x0000000000000000000000000000000000000000000000000000000000000002`` : 第3パラメータの2番目のエントリ。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000003``: the third entry of the third parameter.

- ``0x0000000000000000000000000000000000000000000000000000000000000003`` : 3番目のパラメータのエントリー。

.. In total:

合計で

.. code-block:: none

    0xa5643bf20000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000464617665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003

Use of Dynamic Types
====================

.. A call to a function with the signature ``f(uint,uint32[],bytes10,bytes)`` with values
.. ``(0x123, [0x456, 0x789], "1234567890", "Hello, world!")`` is encoded in the following way:

``f(uint,uint32[],bytes10,bytes)``  with values  ``(0x123, [0x456, 0x789], "1234567890", "Hello, world!")``  というシグネチャを持つ関数の呼び出しは、以下のようにエンコードされます。

.. We take the first four bytes of ``sha3("f(uint256,uint32[],bytes10,bytes)")``, i.e. ``0x8be65246``.
.. Then we encode the head parts of all four arguments. For the static types ``uint256`` and ``bytes10``,
.. these are directly the values we want to pass, whereas for the dynamic types ``uint32[]`` and ``bytes``,
.. we use the offset in bytes to the start of their data area, measured from the start of the value
.. encoding (i.e. not counting the first four bytes containing the hash of the function signature). These are:

``sha3("f(uint256,uint32[],bytes10,bytes)")`` の最初の4バイト、つまり ``0x8be65246`` を取ります。そして、4つの引数すべての先頭部分をエンコードします。静的型の ``uint256`` と ``bytes10`` については、これらが直接渡したい値となりますが、動的型の ``uint32[]`` と ``bytes`` については、値のエンコードの開始（つまり、関数署名のハッシュを含む最初の4バイトを数えない）から測定した、データ領域の開始までのオフセットをバイト単位で使用します。これらは

.. - ``0x0000000000000000000000000000000000000000000000000000000000000123`` (``0x123`` padded to 32 bytes)

- ``0x0000000000000000000000000000000000000000000000000000000000000123`` （ ``0x123`` は32バイトにパディング）

.. - ``0x0000000000000000000000000000000000000000000000000000000000000080`` (offset to start of data part of second parameter, 4*32 bytes, exactly the size of the head part)

- ``0x0000000000000000000000000000000000000000000000000000000000000080`` （第2パラメータのデータ部の開始点へのオフセット、4*32バイト、ちょうどヘッド部のサイズ）

.. - ``0x3132333435363738393000000000000000000000000000000000000000000000`` (``"1234567890"`` padded to 32 bytes on the right)

- ``0x3132333435363738393000000000000000000000000000000000000000000000``  ( ``"1234567890"`` は右の32バイトにパディング)

.. - ``0x00000000000000000000000000000000000000000000000000000000000000e0`` (offset to start of data part of fourth parameter = offset to start of data part of first dynamic parameter + size of data part of first dynamic parameter = 4\*32 + 3\*32 (see below))

- ``0x00000000000000000000000000000000000000000000000000000000000000e0`` （第4パラメータのデータ部の先頭へのオフセット＝第1ダイナミックパラメータのデータ部の先頭へのオフセット＋第1ダイナミックパラメータのデータ部のサイズ＝4×32＋3×32（後述））。

.. After this, the data part of the first dynamic argument, ``[0x456, 0x789]`` follows:

この後、最初の動的引数のデータ部分、 ``[0x456, 0x789]`` は次のようになります。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000002`` (number of elements of the array, 2)

- ``0x0000000000000000000000000000000000000000000000000000000000000002``  (配列の要素数、2)

.. - ``0x0000000000000000000000000000000000000000000000000000000000000456`` (first element)

- ``0x0000000000000000000000000000000000000000000000000000000000000456`` （最初の要素）

.. - ``0x0000000000000000000000000000000000000000000000000000000000000789`` (second element)

- ``0x0000000000000000000000000000000000000000000000000000000000000789`` （セカンドエレメント）

.. Finally, we encode the data part of the second dynamic argument, ``"Hello, world!"``:

最後に、2つ目の動的引数である ``"Hello, world!"`` のデータ部分をエンコードします。

.. - ``0x000000000000000000000000000000000000000000000000000000000000000d`` (number of elements (bytes in this case): 13)

- ``0x000000000000000000000000000000000000000000000000000000000000000d`` （要素数（ここではバイト）: 13)

.. - ``0x48656c6c6f2c20776f726c642100000000000000000000000000000000000000`` (``"Hello, world!"`` padded to 32 bytes on the right)

- ``0x48656c6c6f2c20776f726c642100000000000000000000000000000000000000``  ( ``"Hello, world!"`` は右の32バイトにパディング)

.. All together, the encoding is (newline after function selector and each 32-bytes for clarity):

すべてを合わせると、エンコーディングは次のようになります（わかりやすくするために、関数セレクタと各32バイトの後に改行しています）。

.. code-block:: none

    0x8be65246
      0000000000000000000000000000000000000000000000000000000000000123
      0000000000000000000000000000000000000000000000000000000000000080
      3132333435363738393000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000e0
      0000000000000000000000000000000000000000000000000000000000000002
      0000000000000000000000000000000000000000000000000000000000000456
      0000000000000000000000000000000000000000000000000000000000000789
      000000000000000000000000000000000000000000000000000000000000000d
      48656c6c6f2c20776f726c642100000000000000000000000000000000000000

.. Let us apply the same principle to encode the data for a function with a signature ``g(uint[][],string[])``
.. with values ``([[1, 2], [3]], ["one", "two", "three"])`` but start from the most atomic parts of the encoding:

同じ原理で、シグネチャ ``g(uint[][],string[])`` を持つ関数のデータを値 ``([[1, 2], [3]], ["one", "two", "three"])`` でエンコードしてみましょう。ただし、エンコードの最も基本的な部分から始めます。

.. First we encode the length and data of the first embedded dynamic array ``[1, 2]`` of the first root array ``[[1, 2], [3]]``:

まず最初に、第1のルートアレイ ``[[1, 2], [3]]`` の第1の埋め込みダイナミックアレイ ``[1, 2]`` の長さとデータをエンコードします。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000002`` (number of elements in the first array, 2; the elements themselves are ``1`` and ``2``)

- ``0x0000000000000000000000000000000000000000000000000000000000000002`` （1つ目の配列の要素数2、要素自体は ``1`` と ``2`` )

.. - ``0x0000000000000000000000000000000000000000000000000000000000000001`` (first element)

- ``0x0000000000000000000000000000000000000000000000000000000000000001`` （最初の要素）

.. - ``0x0000000000000000000000000000000000000000000000000000000000000002`` (second element)

- ``0x0000000000000000000000000000000000000000000000000000000000000002`` （セカンドエレメント）

.. Then we encode the length and data of the second embedded dynamic array ``[3]`` of the first root array ``[[1, 2], [3]]``:

そして、第1のルート配列 ``[[1, 2], [3]]`` の第2の埋め込みダイナミック配列 ``[3]`` の長さとデータを符号化する。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000001`` (number of elements in the second array, 1; the element is ``3``)

- ``0x0000000000000000000000000000000000000000000000000000000000000001`` （2番目の配列の要素数、1；要素は ``3`` )

.. - ``0x0000000000000000000000000000000000000000000000000000000000000003`` (first element)

- ``0x0000000000000000000000000000000000000000000000000000000000000003`` （最初の要素）

.. Then we need to find the offsets ``a`` and ``b`` for their respective dynamic arrays ``[1, 2]`` and ``[3]``.
.. To calculate the offsets we can take a look at the encoded data of the first root array ``[[1, 2], [3]]``
.. enumerating each line in the encoding:

次に、それぞれの動的配列 ``[1, 2]`` と ``[3]`` に対するオフセット ``a`` と ``b`` を求める必要があります。このオフセットを計算するために、最初のルート配列 ``[[1, 2], [3]]`` のエンコードデータを見て、エンコードの各行を列挙します。

.. code-block:: none

    0 - a                                                                - offset of [1, 2]
    1 - b                                                                - offset of [3]
    2 - 0000000000000000000000000000000000000000000000000000000000000002 - count for [1, 2]
    3 - 0000000000000000000000000000000000000000000000000000000000000001 - encoding of 1
    4 - 0000000000000000000000000000000000000000000000000000000000000002 - encoding of 2
    5 - 0000000000000000000000000000000000000000000000000000000000000001 - count for [3]
    6 - 0000000000000000000000000000000000000000000000000000000000000003 - encoding of 3

.. Offset ``a`` points to the start of the content of the array ``[1, 2]`` which is line
.. 2 (64 bytes); thus ``a = 0x0000000000000000000000000000000000000000000000000000000000000040``.

オフセット ``a`` は、2行目（64バイト）の配列 ``[1, 2]`` の内容の先頭を指しているので、 ``a = 0x0000000000000000000000000000000000000000000000000000000000000040`` となります。

.. Offset ``b`` points to the start of the content of the array ``[3]`` which is line 5 (160 bytes);
.. thus ``b = 0x00000000000000000000000000000000000000000000000000000000000000a0``.

オフセット ``b`` は、配列 ``[3]`` の内容の先頭である5行目（160バイト）を指しているので、 ``b = 0x00000000000000000000000000000000000000000000000000000000000000a0`` となります。

.. Then we encode the embedded strings of the second root array:

次に、2番目のルート配列の埋め込み文字列をエンコードします。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000003`` (number of characters in word ``"one"``)

- ``0x0000000000000000000000000000000000000000000000000000000000000003`` （ワード ``"one"`` の文字数）

.. - ``0x6f6e650000000000000000000000000000000000000000000000000000000000`` (utf8 representation of word ``"one"``)

- ``0x6f6e650000000000000000000000000000000000000000000000000000000000``  (単語 ``"one"`` のutf8表現)

.. - ``0x0000000000000000000000000000000000000000000000000000000000000003`` (number of characters in word ``"two"``)

- ``0x0000000000000000000000000000000000000000000000000000000000000003`` （ワード ``"two"`` の文字数）

.. - ``0x74776f0000000000000000000000000000000000000000000000000000000000`` (utf8 representation of word ``"two"``)

- ``0x74776f0000000000000000000000000000000000000000000000000000000000``  (単語 ``"two"`` のutf8表現)

.. - ``0x0000000000000000000000000000000000000000000000000000000000000005`` (number of characters in word ``"three"``)

- ``0x0000000000000000000000000000000000000000000000000000000000000005`` （ワード ``"three"`` の文字数）

.. - ``0x7468726565000000000000000000000000000000000000000000000000000000`` (utf8 representation of word ``"three"``)

- ``0x7468726565000000000000000000000000000000000000000000000000000000``  (単語 ``"three"`` のutf8表現)

.. In parallel to the first root array, since strings are dynamic elements we need to find their offsets ``c``, ``d`` and ``e``:

最初のルート配列と並行して、文字列は動的な要素なので、そのオフセット ``c`` 、 ``d`` 、 ``e`` を見つける必要があります。

.. code-block:: none

    0 - c                                                                - offset for "one"
    1 - d                                                                - offset for "two"
    2 - e                                                                - offset for "three"
    3 - 0000000000000000000000000000000000000000000000000000000000000003 - count for "one"
    4 - 6f6e650000000000000000000000000000000000000000000000000000000000 - encoding of "one"
    5 - 0000000000000000000000000000000000000000000000000000000000000003 - count for "two"
    6 - 74776f0000000000000000000000000000000000000000000000000000000000 - encoding of "two"
    7 - 0000000000000000000000000000000000000000000000000000000000000005 - count for "three"
    8 - 7468726565000000000000000000000000000000000000000000000000000000 - encoding of "three"

.. Offset ``c`` points to the start of the content of the string ``"one"`` which is line 3 (96 bytes);
.. thus ``c = 0x0000000000000000000000000000000000000000000000000000000000000060``.

オフセット ``c`` は、3行目（96バイト）である文字列 ``"one"`` の内容の開始点を指しているので、 ``c = 0x0000000000000000000000000000000000000000000000000000000000000060`` となります。

.. Offset ``d`` points to the start of the content of the string ``"two"`` which is line 5 (160 bytes);
.. thus ``d = 0x00000000000000000000000000000000000000000000000000000000000000a0``.

オフセット ``d`` は、5行目（160バイト）の文字列 ``"two"`` の内容の始まりを指しているので、 ``d = 0x00000000000000000000000000000000000000000000000000000000000000a0`` となります。

.. Offset ``e`` points to the start of the content of the string ``"three"`` which is line 7 (224 bytes);
.. thus ``e = 0x00000000000000000000000000000000000000000000000000000000000000e0``.

オフセット ``e`` は、7行目（224バイト）である文字列 ``"three"`` のコンテンツの開始を指しているので、 ``e = 0x00000000000000000000000000000000000000000000000000000000000000e0`` 。

.. Note that the encodings of the embedded elements of the root arrays are not dependent on each other
.. and have the same encodings for a function with a signature ``g(string[],uint[][])``.

なお、ルート配列の埋め込み要素の符号化は互いに依存しておらず、シグネチャ ``g(string[],uint[][])`` を持つ関数では同じ符号化になります。

.. Then we encode the length of the first root array:

そして、最初のルート配列の長さをエンコードします。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000002`` (number of elements in the first root array, 2; the elements themselves are ``[1, 2]``  and ``[3]``)

- ``0x0000000000000000000000000000000000000000000000000000000000000002`` （最初のルート配列の要素数2、要素自体は ``[1, 2]`` と ``[3]`` )

.. Then we encode the length of the second root array:

そして、2番目のルートの配列の長さをエンコードします。

.. - ``0x0000000000000000000000000000000000000000000000000000000000000003`` (number of strings in the second root array, 3; the strings themselves are ``"one"``, ``"two"`` and ``"three"``)

- ``0x0000000000000000000000000000000000000000000000000000000000000003`` （2番目のルート配列に含まれる文字列の数3、文字列自体は ``"one"`` 、 ``"two"`` 、 ``"three"`` ）

.. Finally we find the offsets ``f`` and ``g`` for their respective root dynamic arrays ``[[1, 2], [3]]`` and
.. ``["one", "two", "three"]``, and assemble parts in the correct order:

最後に、それぞれのルートダイナミックアレイ ``[[1, 2], [3]]`` と ``["one", "two", "three"]`` のオフセット ``f`` と ``g`` を見つけ、正しい順序でパーツを組み立てます。

.. code-block:: none

    0x2289b18c                                                            - function signature
     0 - f                                                                - offset of [[1, 2], [3]]
     1 - g                                                                - offset of ["one", "two", "three"]
     2 - 0000000000000000000000000000000000000000000000000000000000000002 - count for [[1, 2], [3]]
     3 - 0000000000000000000000000000000000000000000000000000000000000040 - offset of [1, 2]
     4 - 00000000000000000000000000000000000000000000000000000000000000a0 - offset of [3]
     5 - 0000000000000000000000000000000000000000000000000000000000000002 - count for [1, 2]
     6 - 0000000000000000000000000000000000000000000000000000000000000001 - encoding of 1
     7 - 0000000000000000000000000000000000000000000000000000000000000002 - encoding of 2
     8 - 0000000000000000000000000000000000000000000000000000000000000001 - count for [3]
     9 - 0000000000000000000000000000000000000000000000000000000000000003 - encoding of 3
    10 - 0000000000000000000000000000000000000000000000000000000000000003 - count for ["one", "two", "three"]
    11 - 0000000000000000000000000000000000000000000000000000000000000060 - offset for "one"
    12 - 00000000000000000000000000000000000000000000000000000000000000a0 - offset for "two"
    13 - 00000000000000000000000000000000000000000000000000000000000000e0 - offset for "three"
    14 - 0000000000000000000000000000000000000000000000000000000000000003 - count for "one"
    15 - 6f6e650000000000000000000000000000000000000000000000000000000000 - encoding of "one"
    16 - 0000000000000000000000000000000000000000000000000000000000000003 - count for "two"
    17 - 74776f0000000000000000000000000000000000000000000000000000000000 - encoding of "two"
    18 - 0000000000000000000000000000000000000000000000000000000000000005 - count for "three"
    19 - 7468726565000000000000000000000000000000000000000000000000000000 - encoding of "three"

.. Offset ``f`` points to the start of the content of the array ``[[1, 2], [3]]`` which is line 2 (64 bytes);
.. thus ``f = 0x0000000000000000000000000000000000000000000000000000000000000040``.

オフセット ``f`` は、2行目（64バイト）の配列 ``[[1, 2], [3]]`` の内容の先頭を指しているので、 ``f = 0x0000000000000000000000000000000000000000000000000000000000000040`` となります。

.. Offset ``g`` points to the start of the content of the array ``["one", "two", "three"]`` which is line 10 (320 bytes);
.. thus ``g = 0x0000000000000000000000000000000000000000000000000000000000000140``.

オフセット ``g`` は、配列 ``["one", "two", "three"]`` の内容の先頭である10行目（320バイト）を指しているので、 ``g = 0x0000000000000000000000000000000000000000000000000000000000000140`` 。

.. _abi_events:

Events
======

.. Events are an abstraction of the Ethereum logging/event-watching protocol. Log entries provide the contract's
.. address, a series of up to four topics and some arbitrary length binary data. Events leverage the existing function
.. ABI in order to interpret this (together with an interface spec) as a properly typed structure.

イベントは、Ethereumのログ/イベントウォッチングプロトコルを抽象化したものです。ログエントリは、コントラクトのアドレス、最大4つのトピックのシリーズ、任意の長さのバイナリデータを提供します。Eventsは、既存の関数ABIを活用して、これを（インターフェース仕様とともに）適切に型付けされた構造として解釈します。

.. Given an event name and series of event parameters, we split them into two sub-series: those which are indexed and
.. those which are not.
.. Those which are indexed, which may number up to 3 (for non-anonymous events) or 4 (for anonymous ones), are used
.. alongside the Keccak hash of the event signature to form the topics of the log entry.
.. Those which are not indexed form the byte array of the event.

イベント名と一連のイベント・パラメータが与えられると、それらを2つのサブシリーズに分割する。インデックスが付けられているものは、最大で3つ（非匿名イベントの場合）または4つ（匿名イベントの場合）あり、イベント署名のKeccakハッシュと一緒にログエントリのトピックを形成するために使用される。インデックスが付けられていないものは、イベントのバイト配列を形成する。

.. In effect, a log entry using this ABI is described as:

事実上、このABIを使ったログエントリは次のように記述されます。

.. - ``address``: the address of the contract (intrinsically provided by Ethereum);

- ``address`` : コントラクトのアドレス（Ethereumが本質的に提供するもの）。

.. - ``topics[0]``: ``keccak(EVENT_NAME+"("+EVENT_ARGS.map(canonical_type_of).join(",")+")")`` (``canonical_type_of``
..   is a function that simply returns the canonical type of a given argument, e.g. for ``uint indexed foo``, it would
..   return ``uint256``). This value is only present in ``topics[0]`` if the event is not declared as ``anonymous``;

- ``topics[0]`` です。 ``keccak(EVENT_NAME+"("+EVENT_ARGS.map(canonical_type_of).join(",")+")")`` （ ``canonical_type_of`` は、与えられた引数の正規の型を単純に返す関数であり、例えば ``uint indexed foo`` の場合は ``uint256`` を返す）。この値は、イベントが ``anonymous`` として宣言されていない場合、 ``topics[0]`` にのみ存在する。

.. - ``topics[n]``: ``abi_encode(EVENT_INDEXED_ARGS[n - 1])`` if the event is not declared as ``anonymous``
..   or ``abi_encode(EVENT_INDEXED_ARGS[n])`` if it is (``EVENT_INDEXED_ARGS`` is the series of ``EVENT_ARGS`` that
..   are indexed);

- ``topics[n]`` :  ``abi_encode(EVENT_INDEXED_ARGS[n]) - 1])`` イベントが ``anonymous`` として宣言されていない場合は ``abi_encode(EVENT_INDEXED_ARGS[n])``、宣言されている場合は ``abi_encode(EVENT_INDEXED_ARGS[n])`` となります（ ``EVENT_INDEXED_ARGS`` はインデックス化された ``EVENT_ARGS`` のシリーズです）。

.. - ``data``: ABI encoding of ``EVENT_NON_INDEXED_ARGS`` (``EVENT_NON_INDEXED_ARGS`` is the series of ``EVENT_ARGS``
..   that are not indexed, ``abi_encode`` is the ABI encoding function used for returning a series of typed values
..   from a function, as described above).

- ``data`` です。 ``EVENT_NON_INDEXED_ARGS`` のABIエンコーディング（ ``EVENT_NON_INDEXED_ARGS`` はインデックスが付いていない一連の ``EVENT_ARGS`` 、 ``abi_encode`` は上述のように関数から型付けされた一連の値を返すために使用されるABIエンコーディング関数）。

.. For all types of length at most 32 bytes, the ``EVENT_INDEXED_ARGS`` array contains
.. the value directly, padded or sign-extended (for signed integers) to 32 bytes, just as for regular ABI encoding.
.. However, for all "complex" types or types of dynamic length, including all arrays, ``string``, ``bytes`` and structs,
.. ``EVENT_INDEXED_ARGS`` will contain the *Keccak hash* of a special in-place encoded value
.. (see :ref:`indexed_event_encoding`), rather than the encoded value directly.
.. This allows applications to efficiently query for values of dynamic-length types
.. (by setting the hash of the encoded value as the topic), but leaves applications unable
.. to decode indexed values they have not queried for. For dynamic-length types,
.. application developers face a trade-off between fast search for predetermined values
.. (if the argument is indexed) and legibility of arbitrary values (which requires that
.. the arguments not be indexed). Developers may overcome this tradeoff and achieve both
.. efficient search and arbitrary legibility by defining events with two arguments — one
.. indexed, one not — intended to hold the same value.

長さが最大32バイトのすべての型について、 ``EVENT_INDEXED_ARGS`` 配列には、通常のABIエンコーディングと同様に、32バイトにパディングまたは符号拡張された値が直接格納されます。しかし、すべての "複雑な "型や動的な長さの型（すべての配列、 ``string`` 、 ``bytes`` 、構造体を含む）では、 ``EVENT_INDEXED_ARGS`` には直接エンコードされた値ではなく、特別なインプレースエンコードされた値の*Keccakハッシュ*（ :ref:`indexed_event_encoding` 参照）が格納されます。これにより、アプリケーションは（エンコードされた値のハッシュをトピックとして設定することで）動的長型の値を効率的に問い合わせることができますが、アプリケーションは問い合わせていないインデックス化された値をデコードできなくなります。動的長型の場合、アプリケーション開発者は、（引数がインデックス化されている場合の）所定の値の高速検索と（引数がインデックス化されていないことが必要な）任意の値の可読性との間でトレードオフの関係に直面します。開発者はこのトレードオフを克服し、効率的な検索と任意の可読性の両方を達成するために、同じ値を保持することを意図した2つの引数（1つはインデックス化され、1つはインデックス化されない）を持つイベントを定義できます。

.. _abi_errors:

Errors
======

.. In case of a failure inside a contract, the contract can use a special opcode to abort execution and revert
.. all state changes. In addition to these effects, descriptive data can be returned to the caller.
.. This descriptive data is the encoding of an error and its arguments in the same way as data for a function
.. call.

コントラクト内部で障害が発生した場合、コントラクトは特別なオペコードを使用して実行を中止し、すべての状態変化を元に戻すことができます。これらの効果に加えて、記述的データを呼び出し元に返すことができます。この記述データは、関数呼び出しのデータと同じように、エラーとその引数をエンコードしたものです。

.. As an example, let us consider the following contract whose ``transfer`` function always
.. reverts with a custom error of "insufficient balance":

例として、 ``transfer`` 関数が常に「残高不足」というカスタムエラーで復帰してしまう次のコントラクトを考えてみましょう。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    contract TestToken {
        error InsufficientBalance(uint256 available, uint256 required);
        function transfer(address /*to*/, uint amount) public pure {
            revert InsufficientBalance(0, amount);
        }
    }

.. The return data would be encoded in the same way as the function call
.. ``InsufficientBalance(0, amount)`` to the function ``InsufficientBalance(uint256,uint256)``,
.. i.e. ``0xcf479181``, ``uint256(0)``, ``uint256(amount)``.

戻りデータは、関数 ``InsufficientBalance(uint256,uint256)`` に対する関数呼び出し ``InsufficientBalance(0, amount)`` と同じ方法でエンコードされます。

.. The error selectors ``0x00000000`` and ``0xffffffff`` are reserved for future use.

エラーセレクタ ``0x00000000`` と ``0xffffffff`` は将来のために予約されています。

.. .. warning::

..     Never trust error data.
..     The error data by default bubbles up through the chain of external calls, which
..     means that a contract may receive an error not defined in any of the contracts
..     it calls directly.
..     Furthermore, any contract can fake any error by returning data that matches
..     an error signature, even if the error is not defined anywhere.

.. warning::

    エラーデータを信用してはいけません。     デフォルトでは、エラーデータは外部呼び出しの連鎖を通じてバブリングします。つまり、コントラクトは、直接呼び出すコントラクトのどれにも定義されていないエラーを受け取る可能性があります。     さらに、どのコントラクトも、エラーがどこにも定義されていなくても、エラー署名に一致するデータを返すことで、どんなエラーでも偽装できます。

.. _abi_json:

JSON
====

.. The JSON format for a contract's interface is given by an array of function, event and error descriptions.
.. A function description is a JSON object with the fields:

コントラクトのインターフェースのJSONフォーマットは、関数、イベント、エラーの説明の配列で与えられます。関数の説明は、フィールドを持つJSONオブジェクトです。

.. - ``type``: ``"function"``, ``"constructor"``, ``"receive"`` (the :ref:`"receive Ether" function <receive-ether-function>`) or ``"fallback"`` (the :ref:`"default" function <fallback-function>`);

- ``type`` です。 ``"function"`` 、 ``"constructor"`` 、 ``"receive"`` （ :ref:`"receive Ether" function <receive-ether-function>` ）、 ``"fallback"`` （ :ref:`"default" function <fallback-function>` ）のいずれかです。

.. - ``name``: the name of the function;

- ``name`` : 関数の名前。

.. - ``inputs``: an array of objects, each of which contains:

..   * ``name``: the name of the parameter.

..   * ``type``: the canonical type of the parameter (more below).

..   * ``components``: used for tuple types (more below).

- ``inputs`` : オブジェクトの配列で、それぞれのオブジェクトには

  *  ``name`` : パラメータの名前です。

  *  ``type`` : パラメータの正規の型（詳細は後述）。

  *  ``components`` : タプルタイプに使用されます（詳細は後述）。

.. - ``outputs``: an array of objects similar to ``inputs``.

- ``outputs`` :  ``inputs`` に似たオブジェクトの配列。

.. - ``stateMutability``: a string with one of the following values: ``pure`` (:ref:`specified to not read
..   blockchain state <pure-functions>`), ``view`` (:ref:`specified to not modify the blockchain
..   state <view-functions>`), ``nonpayable`` (function does not accept Ether

- ``stateMutability`` : 以下のいずれかの値を持つ文字列。 ``pure`` （ :ref:`specified to not read   blockchain state <pure-functions>` ）、 ``view`` （ :ref:`specified to not modify the blockchain   state <view-functions>` ）、 ``nonpayable`` （関数はイーサを受け付けません

.. - the default) and ``payable`` (function accepts Ether).

- デフォルト）と ``payable`` （関数はEtherを受け入れる）があります。

.. Constructor and fallback function never have ``name`` or ``outputs``. Fallback function doesn't have ``inputs`` either.

コンストラクタとフォールバック関数は ``name`` や ``outputs`` を持ちません。フォールバック関数には ``inputs`` もありません。

.. .. note::

..     Sending non-zero Ether to non-payable function will revert the transaction.

.. note::

    支払い不可能な関数に0ではないEtherを送ると、トランザクションが元に戻ります。

.. .. note::

..     The state mutability ``nonpayable`` is reflected in Solidity by not specifying
..     a state mutability modifier at all.

.. note::

    State mutability  ``nonpayable`` は、SolidityではState mutability modifierを全く指定しないことで反映されています。

.. An event description is a JSON object with fairly similar fields:

イベントの説明は、よく似たフィールドを持つJSONオブジェクトです。

.. - ``type``: always ``"event"``

- ``type`` : 常に ``"event"``

.. - ``name``: the name of the event.

- ``name`` : イベントの名前です。

.. - ``inputs``: an array of objects, each of which contains:

..   * ``name``: the name of the parameter.

..   * ``type``: the canonical type of the parameter (more below).

..   * ``components``: used for tuple types (more below).

..   * ``indexed``: ``true`` if the field is part of the log's topics, ``false`` if it one of the log's data segment.

- ``inputs`` : オブジェクトの配列で、それぞれのオブジェクトには

  *  ``name`` : パラメータの名前です。

  *  ``type`` : パラメータの正規の型（詳細は後述）。

  *  ``components`` : タプルタイプに使用されます（詳細は後述）。

  *  ``indexed`` : フィールドがログのトピックの一部である場合は ``true`` 、ログのデータセグメントの一つである場合は ``false`` 。

.. - ``anonymous``: ``true`` if the event was declared as ``anonymous``.

- ``anonymous`` です。イベントが ``anonymous`` と宣言された場合は ``true`` 。

.. Errors look as follows:

エラーの内容は以下の通りです。

.. - ``type``: always ``"error"``

- ``type`` : 常に ``"error"``

.. - ``name``: the name of the error.

- ``name`` : エラーの名前です。

.. - ``inputs``: an array of objects, each of which contains:

..   * ``name``: the name of the parameter.

..   * ``type``: the canonical type of the parameter (more below).

..   * ``components``: used for tuple types (more below).

- ``inputs`` : オブジェクトの配列で、それぞれのオブジェクトには

  *  ``name`` : パラメータの名前です。

  *  ``type`` : パラメータの正規の型（詳細は後述）。

  *  ``components`` : タプルタイプに使用されます（詳細は後述）。

.. .. note::

..   There can be multiple errors with the same name and even with identical signature
..   in the JSON array, for example if the errors originate from different
..   files in the smart contract or are referenced from another smart contract.
..   For the ABI, only the name of the error itself is relevant and not where it is
..   defined.

.. note::

  スマートコントラクト内の異なるファイルからエラーが発生した場合や、別のスマートコントラクトから参照されている場合など、JSON 配列内に同じ名前や同一の署名を持つ複数のエラーが存在する可能性があります。   ABIでは、エラー自体の名前だけが重要で、どこで定義されているかは関係ありません。

.. For example,

例えば、以下のように。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    contract Test {
        constructor() { b = hex"12345678901234567890123456789012"; }
        event Event(uint indexed a, bytes32 b);
        event Event2(uint indexed a, bytes32 b);
        error InsufficientBalance(uint256 available, uint256 required);
        function foo(uint a) public { emit Event(a, b); }
        bytes32 b;
    }

.. would result in the JSON:

とすると、JSONになります。

.. code-block:: json

    [{
    "type":"error",
    "inputs": [{"name":"available","type":"uint256"},{"name":"required","type":"uint256"}],
    "name":"InsufficientBalance"
    }, {
    "type":"event",
    "inputs": [{"name":"a","type":"uint256","indexed":true},{"name":"b","type":"bytes32","indexed":false}],
    "name":"Event"
    }, {
    "type":"event",
    "inputs": [{"name":"a","type":"uint256","indexed":true},{"name":"b","type":"bytes32","indexed":false}],
    "name":"Event2"
    }, {
    "type":"function",
    "inputs": [{"name":"a","type":"uint256"}],
    "name":"foo",
    "outputs": []
    }]

Handling tuple types
--------------------

.. Despite that names are intentionally not part of the ABI encoding they do make a lot of sense to be included
.. in the JSON to enable displaying it to the end user. The structure is nested in the following way:

名前は意図的にABIエンコーディングの一部ではありませんが、エンドユーザーに表示するためにJSONに含めることには大きな意味があります。構造は以下のように入れ子になっています。

.. An object with members ``name``, ``type`` and potentially ``components`` describes a typed variable.
.. The canonical type is determined until a tuple type is reached and the string description up
.. to that point is stored in ``type`` prefix with the word ``tuple``, i.e. it will be ``tuple`` followed by
.. a sequence of ``[]`` and ``[k]`` with
.. integers ``k``. The components of the tuple are then stored in the member ``components``,
.. which is of array type and has the same structure as the top-level object except that
.. ``indexed`` is not allowed there.

メンバー ``name`` 、 ``type`` 、そして潜在的に ``components`` を持つオブジェクトは、型付けされた変数を記述します。タプル型に到達するまでは正規の型が決定され、その時点までの文字列記述は ``tuple`` という単語を前置した ``type`` に格納されます。つまり、 ``tuple`` の後に整数 ``k`` を持つ ``[]`` と ``[k]`` のシーケンスが続くことになります。その後、タプルの構成要素はメンバー ``components`` に格納されます。 ``components`` は配列型で、そこに ``indexed`` が許されないことを除いて、トップレベルのオブジェクトと同じ構造を持っています。

.. As an example, the code

一例として、コード

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.5 <0.9.0;
    pragma abicoder v2;

    contract Test {
        struct S { uint a; uint[] b; T[] c; }
        struct T { uint x; uint y; }
        function f(S memory, T memory, uint) public pure {}
        function g() public pure returns (S memory, T memory, uint) {}
    }

.. would result in the JSON:

とすると、JSONになります。

.. code-block:: json

    [
      {
        "name": "f",
        "type": "function",
        "inputs": [
          {
            "name": "s",
            "type": "tuple",
            "components": [
              {
                "name": "a",
                "type": "uint256"
              },
              {
                "name": "b",
                "type": "uint256[]"
              },
              {
                "name": "c",
                "type": "tuple[]",
                "components": [
                  {
                    "name": "x",
                    "type": "uint256"
                  },
                  {
                    "name": "y",
                    "type": "uint256"
                  }
                ]
              }
            ]
          },
          {
            "name": "t",
            "type": "tuple",
            "components": [
              {
                "name": "x",
                "type": "uint256"
              },
              {
                "name": "y",
                "type": "uint256"
              }
            ]
          },
          {
            "name": "a",
            "type": "uint256"
          }
        ],
        "outputs": []
      }
    ]

.. _abi_packed_mode:

Strict Encoding Mode
====================

.. Strict encoding mode is the mode that leads to exactly the same encoding as defined in the formal specification above.
.. This means offsets have to be as small as possible while still not creating overlaps in the data areas and thus no gaps are
.. allowed.

厳密なエンコーディングモードとは、上記の正式な仕様で定義されているのと全く同じエンコーディングになるモードです。つまり、データ領域にオーバーラップを生じさせないようにしながら、オフセットはできるだけ小さくしなければならず、したがってギャップは許されません。

.. Usually, ABI decoders are written in a straightforward way just following offset pointers, but some decoders
.. might enforce strict mode. The Solidity ABI decoder currently does not enforce strict mode, but the encoder
.. always creates data in strict mode.

通常、ABIデコーダはオフセットポインタに従うだけの素直な方法で書かれていますが、デコーダによってはストリクトモードを強制する場合があります。SolidityのABIデコーダは、現在のところストリクトモードを強制していませんが、エンコーダは常にストリクトモードでデータを作成します。

Non-standard Packed Mode
========================

.. Through ``abi.encodePacked()``, Solidity supports a non-standard packed mode where:

Solidityは、 ``abi.encodePacked()`` を通して、非標準のパックモードをサポートしています。

.. - types shorter than 32 bytes are concatenated directly, without padding or sign extension

- 32バイト以下のタイプは、パディングや符号拡張なしに、直接連結されます。

.. - dynamic types are encoded in-place and without the length.

- ダイナミックタイプは、その場で長さを変えずにエンコードされます。

.. - array elements are padded, but still encoded in-place

- 配列の要素はパディングされるが、インプレースでエンコードされる

.. Furthermore, structs as well as nested arrays are not supported.

また、構造体や入れ子になった配列はサポートされていません。

.. As an example, the encoding of ``int16(-1), bytes1(0x42), uint16(0x03), string("Hello, world!")`` results in:

例として、 ``int16(-1), bytes1(0x42), uint16(0x03), string("Hello, world!")`` をエンコードすると次のようになります。

.. code-block:: none

    0xffff42000348656c6c6f2c20776f726c6421
      ^^^^                                 int16(-1)
          ^^                               bytes1(0x42)
            ^^^^                           uint16(0x03)
                ^^^^^^^^^^^^^^^^^^^^^^^^^^ string("Hello, world!") without a length field

.. More specifically:

具体的には

.. - During the encoding, everything is encoded in-place. This means that there is
..   no distinction between head and tail, as in the ABI encoding, and the length
..   of an array is not encoded.

- エンコードの際、すべてがインプレースでエンコードされます。つまり、ABIのエンコーディングのように、先頭と末尾の区別がなく、配列の長さもエンコードされません。

.. - The direct arguments of ``abi.encodePacked`` are encoded without padding,
..   as long as they are not arrays (or ``string`` or ``bytes``).

- ``abi.encodePacked`` の直接引数は、配列（または ``string`` や ``bytes`` ）でない限り、パディングなしでエンコードされます。

.. - The encoding of an array is the concatenation of the
..   encoding of its elements **with** padding.

- 配列のエンコーディングは、その要素のエンコーディングを **with** パディングで連結したものです。

.. - Dynamically-sized types like ``string``, ``bytes`` or ``uint[]`` are encoded
..   without their length field.

- ``string`` 、 ``bytes`` 、 ``uint[]`` のような動的なサイズのタイプは、長さフィールドなしでエンコードされます。

.. - The encoding of ``string`` or ``bytes`` does not apply padding at the end
..   unless it is part of an array or struct (then it is padded to a multiple of
..   32 bytes).

- ``string`` や ``bytes`` のエンコーディングでは、配列や構造体の一部でない限り、末尾にパディングが適用されません（その場合、32バイトの倍数にパディングされます）。

.. In general, the encoding is ambiguous as soon as there are two dynamically-sized elements,
.. because of the missing length field.

一般的には、動的なサイズの要素が2つあると、長さのフィールドがないため、エンコーディングが曖昧になります。

.. If padding is needed, explicit type conversions can be used: ``abi.encodePacked(uint16(0x12)) == hex"0012"``.

パディングが必要な場合は、明示的な型変換を行うことができます。 ``abi.encodePacked(uint16(0x12)) == hex"0012"`` .

.. Since packed encoding is not used when calling functions, there is no special support
.. for prepending a function selector. Since the encoding is ambiguous, there is no decoding function.

関数を呼び出すときにはpackedエンコーディングは使われないので、関数セレクタの前に付ける特別なサポートはありません。また、エンコーディングが曖昧なため、デコード関数もありません。

.. .. warning::

..     If you use ``keccak256(abi.encodePacked(a, b))`` and both ``a`` and ``b`` are dynamic types,
..     it is easy to craft collisions in the hash value by moving parts of ``a`` into ``b`` and
..     vice-versa. More specifically, ``abi.encodePacked("a", "bc") == abi.encodePacked("ab", "c")``.
..     If you use ``abi.encodePacked`` for signatures, authentication or data integrity, make
..     sure to always use the same types and check that at most one of them is dynamic.
..     Unless there is a compelling reason, ``abi.encode`` should be preferred.

.. warning::

    ``keccak256(abi.encodePacked(a, b))`` を使っていて、 ``a`` と ``b`` の両方がダイナミック型の場合、 ``a`` の一部を ``b`` に移動させたり、逆に ``b`` の一部を ``a`` に移動させたりすることで、ハッシュ値の衝突を容易に工作できます。より具体的には ``abi.encodePacked("a", "bc") == abi.encodePacked("ab", "c")`` です。     署名や認証、データの整合性のために ``abi.encodePacked`` を使用する場合は、常に同じ型を使用し、最大でもどちらかが動的型であることを確認してください。     やむを得ない理由がない限り、 ``abi.encode`` を優先すべきです。

.. _indexed_event_encoding:

Encoding of Indexed Event Parameters
====================================

.. Indexed event parameters that are not value types, i.e. arrays and structs are not
.. stored directly but instead a keccak256-hash of an encoding is stored. This encoding
.. is defined as follows:

値型ではないインデックス付きのイベントパラメーター（配列や構造体）は、直接保存されず、エンコーディングの keccak256-hash が保存されます。このエンコーディングは以下のように定義されています。

.. - the encoding of a ``bytes`` and ``string`` value is just the string contents
..   without any padding or length prefix.

- の場合、 ``bytes`` と ``string`` の値のエンコーディングは、パディングや長さのプレフィックスを含まない文字列の内容だけになります。

.. - the encoding of a struct is the concatenation of the encoding of its members,
..   always padded to a multiple of 32 bytes (even ``bytes`` and ``string``).

- 構造体のエンコーディングは、そのメンバーのエンコーディングを連結したもので、常に32バイトの倍数にパディングされています（ ``bytes`` や ``string`` も同様）。

.. - the encoding of an array (both dynamically

- 配列のエンコーディング（動的にも

.. - and statically-sized) is
..   the concatenation of the encoding of its elements, always padded to a multiple
..   of 32 bytes (even ``bytes`` and ``string``) and without any length prefix

- と静的サイズ）は、その要素のエンコーディングを連結したもので、常に32バイトの倍数にパディングされ（ ``bytes`` と ``string`` も）、長さのプレフィックスはありません。

.. In the above, as usual, a negative number is padded by sign extension and not zero padded.
.. ``bytesNN`` types are padded on the right while ``uintNN`` / ``intNN`` are padded on the left.

上記では、いつものように負の数は符号拡張でパディングされ、ゼロパディングされません。 ``bytesNN`` 型は右に、 ``uintNN``  /  ``intNN`` 型は左にパディングされます。

.. .. warning::

..     The encoding of a struct is ambiguous if it contains more than one dynamically-sized
..     array. Because of that, always re-check the event data and do not rely on the search result
..     based on the indexed parameters alone.
.. 

.. warning::

    構造体に複数の動的サイズの配列が含まれていると、エンコーディングが曖昧になります。そのため、常にイベントデータを再確認し、インデックス化されたパラメータだけに基づく検索結果に頼らないようにしてください。
