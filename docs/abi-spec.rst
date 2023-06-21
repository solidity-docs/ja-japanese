.. index:: abi, application binary interface

.. _ABI:

*********************
コントラクトABIの仕様
*********************

基本設計
========

コントラクトのApplication Binary Interface (ABI)は、Ethereumエコシステム内のコントラクトと対話するためのスタンダードな方法であり、ブロックチェーンの外側からも、コントラクト間の対話のためにも使用されます。
データは、この仕様に記載されているように、その型に応じてエンコードされます。
エンコーディングは自己記述的ではないため、デコードするためにはスキーマが必要です。

コントラクトのインタフェース関数が強く型付けされ、それがコンパイル時に知られており、かつ静的であるとしています。
また、すべてのコントラクトは、それらが呼び出すコントラクトのインタフェース定義をコンパイル時に利用可能であるとしています。

この仕様では、インターフェースが動的である、あるいは、実行時にしかわからないコントラクトは扱いません。

.. _abi_function_selector:
.. index:: ! selector; of a function

関数セレクタ
============

.. The signature is defined as the canonical expression of the basic prototype without data location specifier, i.e. the function name with the parenthesised list of parameter types.

関数呼び出しのコールデータの最初の4バイトは、呼び出される関数を指定します。
これは、関数のシグネチャのKeccak-256ハッシュの最初（左、ビッグエンディアンの高次）の4バイトです。
シグネチャは、データロケーション指定子のない基本のプロトタイプの正規表現として定義されています。
つまり、関数名と括弧で囲まれたパラメータ型のリストです。
パラメータ型はコンマで分割され、スペースは使用されません。

.. note::

    関数の戻り値の型は、シグネチャには含まれません。
    :ref:`Solidityの関数オーバーロード <overload-function>` では戻り値の型は考慮されません。
    その理由は、関数呼び出しの解決をコンテキストに依存しないようにするためです。
    しかし、 :ref:`ABIのJSONの内容<abi_json>` には入力と出力の両方が含まれます。

引数のエンコーディング
======================

5バイト目からは、エンコードされた引数が続きます。
このエンコーディングは他の場所でも使用されています。
例えば、戻り値やイベントの引数も同じようにエンコーディングされます。
ただし、関数を指定する4バイトのセレクタはありません。

型
==

次のような基本型があります。

.. - ``address``: equivalent to ``uint160``, except for the assumed interpretation and language typing. For computing the function selector, ``address`` is used.
.. - ``fixed<M>x<N>``: signed fixed-point decimal number of ``M`` bits, ``8 <= M <= 256``,
..   ``M % 8 == 0``, and ``0 < N <= 80``, which denotes the value ``v`` as ``v / (10 ** N)``.
.. - ``function``: an address (20 bytes) followed by a function selector (4 bytes). Encoded identical to ``bytes24``.

- ``uint<M>``:  ``M`` ビット、 ``0 < M <= 256`` 、 ``M % 8 == 0`` の符号なし整数型。
  例えば ``uint32`` 、 ``uint8`` 、 ``uint256`` 。
- ``int<M>``:  ``M`` ビット、 ``0 < M <= 256`` 、 ``M % 8 == 0`` の2の補数の符号付き整数型。
- ``address``: 仮定される解釈と言語の型付けを除き、 ``uint160`` と同等。
  関数セレクタの計算には ``address`` を使用。
- ``uint``, ``int``: それぞれ ``uint256`` と ``int256`` の同義語。
  関数セレクタの計算には ``uint256`` と ``int256`` を使用。
- ``bool``: 0と1に限定された ``uint8`` と同等。
  関数セレクタの計算には ``bool`` を使用。
- ``fixed<M>x<N>``:  ``M`` ビット、 ``8 <= M <= 256`` 、 ``M % 8 == 0`` 、 ``0 < N <= 80`` の符号付き固定小数点10進数で、 ``v`` の値を ``v / (10 ** N)`` と表記。
- ``ufixed<M>x<N>``:  ``fixed<M>x<N>`` の符号なしのバリアント。
- ``fixed``, ``ufixed``: それぞれ ``fixed128x18`` と ``ufixed128x18`` の同義語。
  関数セレクタの計算には、 ``fixed128x18`` と ``ufixed128x18`` を使用。
- ``bytes<M>``:  ``M`` バイトのバイナリ型、 ``0 < M <= 32`` 。
- ``function``: アドレス（20バイト）の後に関数セレクタ（4バイト）が続く。
  ``bytes24`` と同じようにエンコード。

次のような（固定サイズの）配列型が存在します。

- ``<type>[M]``: 与えられた型の ``M`` 個の要素の固定長の配列。
  ``M >= 0`` 。

  .. note::

      このABI仕様では、要素数が0の固定長の配列を表現できますが、コンパイラではサポートされていません。

次のような非固定サイズの型が存在します。

- ``bytes``: 動的サイズのバイトシーケンス。
- ``string``: UTF-8でエンコードされていると仮定した動的サイズのユニコード文字列。
- ``<type>[]``: 指定された型の要素を持つ可変長の配列。

型は、カンマで区切って括弧で囲むことでタプルにまとめることができます。

- ``(T1,T2,...,Tn)``:  ``T1`` , ...,  ``Tn`` の各型からなるタプル。
  ``n >= 0`` 。

タプルのタプル、タプルの配列などを作ることが可能です。
また、ゼロタプルを作ることも可能です（ ``n == 0`` ）。

Solidityの型からABIの型へのマッピング
-------------------------------------

Solidityでは、タプルを除いて、上記で紹介したすべての型を同じ名前でサポートしています。
一方で、Solidityの型の中には、ABIではサポートされていないものもあります。
次の表は、左の列にABIがサポートしていないSolidityの型を、右の列にそれに対応するABIの型を示しています。

+-------------------------------+-----------------------------------------------------------------------------+
|      Solidity                 |                                           ABI                               |
+===============================+=============================================================================+
|:ref:`address payable<address>`|``address``                                                                  |
+-------------------------------+-----------------------------------------------------------------------------+
|:ref:`contract<contracts>`     |``address``                                                                  |
+-------------------------------+-----------------------------------------------------------------------------+
|:ref:`enum<enums>`             |``uint8``                                                                    |
+-------------------------------+-----------------------------------------------------------------------------+
|:ref:`user defined value types |元となる値型                                                                 |
|<user-defined-value-types>`    |                                                                             |
+-------------------------------+-----------------------------------------------------------------------------+
|:ref:`struct<structs>`         |``tuple``                                                                    |
+-------------------------------+-----------------------------------------------------------------------------+

.. warning::

    バージョン ``0.8.0`` 以前のenumは256個以上のメンバーを持つことができ、任意のメンバーの値を保持するのに十分な大きさの最小の整数型で表されていました。

エンコーディングの設計基準
==========================

.. The encoding is designed to have the following properties, which are especially useful if some arguments are nested arrays:

このエンコーディングは、以下のような特性を持つように設計されており、いくつかの引数が入れ子になった配列である場合には、特に便利です。

.. 1. The number of reads necessary to access a value is at most the depth of the value
..    inside the argument array structure, i.e. four reads are needed to retrieve ``a_i[k][l][r]``. In a
..    previous version of the ABI, the number of reads scaled linearly with the total number of dynamic
..    parameters in the worst case.
.. 2. The data of a variable or array element is not interleaved with other data and it is
..    relocatable, i.e. it only uses relative "addresses".

1. 値にアクセスするために必要な読み取り回数は、最大でも引数配列構造内の値の深さ分であり、すなわち ``a_i[k][l][r]`` を取得するためには4回の読み取りが必要です。
   以前のバージョンのABIでは、最悪の場合、読み取り回数は動的パラメータの総数に比例していました。
2. 変数や配列要素のデータは、他のデータとインターリーブされておらず、相対的な「アドレス」のみを使用する、リロケータブルなものです。

エンコーディングの形式的な仕様
==============================

.. Static types are encoded in-place and dynamic types are encoded at a separately allocated location after the current block.

静的な型と動的な型を区別します。
静的型はインプレースでエンコードされ、動的型は現在のブロックの後に別個に割り当てられた場所でエンコードされます。

**定義:** 次のような型を「動的」と呼びます。

* ``bytes``
* ``string``
* 任意の ``T`` に対して ``T[]``
* 任意の動的 ``T`` と任意の ``k >= 0`` に対する ``T[k]``
* ある ``1 <= i <= k`` に対して ``Ti`` が動的である場合の ``(T1,...,Tk)``

それ以外の型は「静的」と呼ばれます。

**定義:** ``len(a)`` は、2進数の文字列 ``a`` のバイト数です。
``len(a)`` の型は ``uint256`` とします。

.. We define ``enc``, the actual encoding, as a mapping of values of the ABI types to binary strings such
.. that ``len(enc(X))`` depends on the value of ``X`` if and only if the type of ``X`` is dynamic.

実際のエンコーディングである ``enc`` は、ABI型の値をバイナリ文字列にマッピングしたものと定義し、 ``X`` の型が動的である場合に限り、 ``len(enc(X))`` が ``X`` の値に依存するようにします。

.. **Definition:** For any ABI value ``X``, we recursively define ``enc(X)``, depending
.. on the type of ``X`` being

**定義:** 任意のABI値 ``X`` に対して、 ``X`` の型に応じて ``enc(X)`` を再帰的に定義します。

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

.. - ``T[k]`` for any ``T`` and ``k``:
..   i.e. it is encoded as if it were a tuple with ``k`` elements
..   of the same type.
.. - ``T[]`` where ``X`` has ``k`` elements (``k`` is assumed to be of type ``uint256``):
..   i.e. it is encoded as if it were an array of static size ``k``, prefixed with
..   the number of elements.
.. - ``bytes``, of length ``k`` (which is assumed to be of type ``uint256``):
..   ``enc(X) = enc(k) pad_right(X)``, i.e. the number of bytes is encoded as a
..   ``uint256`` followed by the actual value of ``X`` as a byte sequence, followed by
..   the minimum number of zero-bytes such that ``len(enc(X))`` is a multiple of 32.
..   ``enc(X) = enc(enc_utf8(X))``, i.e. ``X`` is UTF-8 encoded and this value is interpreted
..   as of ``bytes`` type and encoded further. Note that the length used in this subsequent
..   encoding is the number of bytes of the UTF-8 encoded string, not its number of characters.
.. - ``uint<M>``: ``enc(X)`` is the big-endian encoding of ``X``, padded on the higher-order
..   (left) side with zero-bytes such that the length is 32 bytes.
.. - ``int<M>``: ``enc(X)`` is the big-endian two's complement encoding of ``X``, padded on the higher-order (left) side with ``0xff`` bytes for negative ``X`` and with zero-bytes for non-negative ``X`` such that the length is 32 bytes.
.. - ``fixed<M>x<N>``: ``enc(X)`` is ``enc(X * 10**N)`` where ``X * 10**N`` is interpreted as a ``int256``.
.. - ``ufixed<M>x<N>``: ``enc(X)`` is ``enc(X * 10**N)`` where ``X * 10**N`` is interpreted as a ``uint256``.
.. - ``bytes<M>``: ``enc(X)`` is the sequence of bytes in ``X`` padded with trailing zero-bytes to a length of 32 bytes.

- ``k >= 0`` と任意の型 ``T1`` , ...,  ``Tk`` に対する ``(T1,...,Tk)``

  ``enc(X) = head(X(1)) ... head(X(k)) tail(X(1)) ... tail(X(k))``

  ここで、 ``X = (X(1), ..., X(k))`` と ``head`` と ``tail`` は、 ``Ti`` に対して次のように定義されます。

  ``Ti`` が静的である場合:

    ``head(X(i)) = enc(X(i))`` と ``tail(X(i)) = ""`` （空の文字列）

  それ以外の場合、つまり ``Ti`` が動的な場合:

    ``head(X(i)) = enc(len( head(X(1)) ... head(X(k)) tail(X(1)) ... tail(X(i-1)) ))``   ``tail(X(i)) = enc(X(i))``

  なお、動的なケースでは、head部分の長さは型にのみ依存し、値には依存しないため、 ``head(X(i))`` はwell-definedです。
  ``head(X(i))`` の値は、 ``enc(X)`` の開始位置に対する ``tail(X(i))`` の開始位置のオフセットです。

- 任意の ``T`` と ``k`` に対する ``T[k]``:

  ``enc(X) = enc((X[0], ..., X[k-1]))``

  つまり、同じ型の ``k`` 要素を持つタプルであるかのようにエンコードされます。

- ``X`` が ``k`` の要素を持つ ``T[]`` （ ``k`` は ``uint256`` 型とします）。

  ``enc(X) = enc(k) enc((X[0], ..., X[k-1]))``

  つまり、同じ型の ``k`` 個の要素を持つタプル（静的サイズ ``k`` の配列）であるかのようにエンコードされ、その前に要素数が付きます。

- 長さ ``k`` の ``bytes`` （これは型 ``uint256`` であると仮定されます）。

  ``enc(X) = enc(k) pad_right(X)`` 、すなわち、バイト数は ``uint256`` に続いて ``X`` の実際の値をバイト列として符号化し、その後に ``len(enc(X))`` が32の倍数になるような最小数のゼロバイトが続きます。

- ``string``:

  ``enc(X) = enc(enc_utf8(X))`` 、つまり ``X`` はUTF-8でエンコードされ、この値は ``bytes`` 型と解釈され、さらにエンコードされます。
  なお、この後のエンコードで使用する長さは、文字数ではなく、UTF-8でエンコードされた文字列のバイト数です。

- ``uint<M>``: ``enc(X)`` は、 ``X`` のビッグエンディアンのエンコーディングで、高次（左）側に0バイトをパディングし、長さが32バイトになるようにしたものです。

- ``address``: ``uint160`` と同様です。

- ``int<M>``: ``enc(X)`` は ``X`` のビッグエンディアンの2の補数で、高次（左）側に負の ``X`` には ``0xff`` バイト、非負の ``X`` には0バイトをパディングし、長さが32バイトになるようにしたものです。

- ``bool``: ``uint8`` と同様に、 ``true`` には ``1`` 、 ``false`` には ``0`` が使われます。

- ``fixed<M>x<N>``: ``enc(X)`` は ``enc(X * 10**N)`` で ``X * 10**N`` は ``int256`` と解釈されます。

- ``fixed``: ``fixed128x18`` と同様です。

- ``ufixed<M>x<N>``: ``enc(X)`` は ``enc(X * 10**N)`` で ``X * 10**N`` は ``uint256`` と解釈されます。

- ``ufixed``: ``ufixed128x18`` と同様です。

- ``bytes<M>``: ``enc(X)`` は、 ``X`` のバイト列に末尾にゼロバイトを追加して32バイトにしたものです。

なお、任意の ``X`` に対して、 ``len(enc(X))`` は32の倍数です。

関数セレクタと引数エンコーディング
==================================

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

例
==

.. Given the contract:

次のコントラクトを考える:

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract Foo {
        function bar(bytes3[2] memory) public pure {}
        function baz(uint32 x, bool y) public pure returns (bool r) { r = x > 32 || y; }
        function sam(bytes memory, bool, uint[] memory) public pure {}
    }

``Foo`` の例では、 ``69`` と ``true`` というパラメータで ``baz`` を呼び出す場合、合計68バイトを渡すことになり、その内訳は以下の通りです。

- ``0xcdcd77c0``: メソッドID。シグネチャ ``baz(uint32,bool)`` のASCII形式のKeccakハッシュの最初の4バイトです。
- ``0x0000000000000000000000000000000000000000000000000000000000000045``: 第1パラメータ。
  32バイトにパディングされたuint32の値 ``69`` 。
- ``0x0000000000000000000000000000000000000000000000000000000000000001``: 第2パラメータ。
  32バイトにパディングされたboolの値 ``true`` 。

合わせると、

.. code-block:: none

    0xcdcd77c000000000000000000000000000000000000000000000000000000000000000450000000000000000000000000000000000000000000000000000000000000001

この関数は単一の ``bool`` を返します。
例えば、 ``false`` を返すとしたら、その出力は単一のバイト列 ``0x0000000000000000000000000000000000000000000000000000000000000000`` であり、これは単一のboolです。

``bar`` を ``["abc", "def"]`` の引数で呼び出す場合、合計68バイトを渡すことになり、その内訳は以下の通りです。

- ``0xfce353f6``: メソッドID。シグネチャ ``bar(bytes3[2])`` から得られます。
- ``0x6162630000000000000000000000000000000000000000000000000000000000``: 第1パラメータの最初の部分で、 ``bytes3`` の値 ``"abc"`` （左寄せ）。
- ``0x6465660000000000000000000000000000000000000000000000000000000000``: 第1パラメータの2番目の部分で、 ``bytes3`` の値 ``"def"`` （左寄せ）。

合わせると、

.. code-block:: none

    0xfce353f661626300000000000000000000000000000000000000000000000000000000006465660000000000000000000000000000000000000000000000000000000000

引数 ``"dave"`` 、 ``true`` 、 ``[1,2,3]`` で ``sam`` を呼び出したい場合、合計292バイトを渡すことになり、その内訳は以下の通りです。

- ``0xa5643bf2``: メソッドID。シグネチャ ``sam(bytes,bool,uint256[])`` から得られます。 ``uint`` はその正規の表現である ``uint256`` に置き換えられていることに注意してください。
- ``0x0000000000000000000000000000000000000000000000000000000000000060``: 第1引数（動的型）のデータ部の位置で、引数ブロックの先頭からのバイト数で表します。この場合は ``0x60`` 。
- ``0x0000000000000000000000000000000000000000000000000000000000000001``: 第2引数: boolでtrue。
- ``0x00000000000000000000000000000000000000000000000000000000000000a0``: 第3引数（動的型）のデータ部の位置で、単位はバイトです。この場合は ``0xa0`` 。
- ``0x0000000000000000000000000000000000000000000000000000000000000004``: 第1引数のデータ部で、バイト配列の要素数から始まります。この場合は4。
- ``0x6461766500000000000000000000000000000000000000000000000000000000``: 第1引数の内容:  ``"dave"`` のUTF-8（ここではASCIIと同等）エンコードで右をパディングして32バイトにしたもの。
- ``0x0000000000000000000000000000000000000000000000000000000000000003``: 第3引数のデータ部で、配列の要素数から始まります。この場合は3。
- ``0x0000000000000000000000000000000000000000000000000000000000000001``: 第3引数の最初のエントリ。
- ``0x0000000000000000000000000000000000000000000000000000000000000002``: 第3引数の2番目のエントリ。
- ``0x0000000000000000000000000000000000000000000000000000000000000003``: 第3引数の3番目のエントリ。

合わせると、

.. code-block:: none

    0xa5643bf20000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000464617665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003

動的型の使用法
==============

シグネチャが ``f(uint256,uint32[],bytes10,bytes)`` で値が  ``(0x123, [0x456, 0x789], "1234567890", "Hello, world!")`` である関数呼び出しは、以下のようにエンコードされます。

.. We take the first four bytes of ``keccak("f(uint256,uint32[],bytes10,bytes)")``, i.e. ``0x8be65246``.
.. Then we encode the head parts of all four arguments. For the static types ``uint256`` and ``bytes10``,
.. these are directly the values we want to pass, whereas for the dynamic types ``uint32[]`` and ``bytes``,
.. we use the offset in bytes to the start of their data area, measured from the start of the value
.. encoding (i.e. not counting the first four bytes containing the hash of the function signature). These are:

まず ``keccak("f(uint256,uint32[],bytes10,bytes)")`` の最初の4バイト、つまり ``0x8be65246`` を取ります。
そして、4つの引数すべてのヘッド部分をエンコードします。
静的型の ``uint256`` と ``bytes10`` については、これらが直接渡したい値となりますが、動的型の ``uint32[]`` と ``bytes`` については、値のエンコードの開始（つまり、関数シグネチャのハッシュを含む最初の4バイトを数えない）から測定した、データ領域の開始までのオフセットをバイト単位で使用します。

- ``0x0000000000000000000000000000000000000000000000000000000000000123`` （32バイトにパディングした ``0x123`` ）
- ``0x0000000000000000000000000000000000000000000000000000000000000080`` （第2パラメータのデータ部の開始位置へのオフセット。4*32バイトでちょうどヘッド部のサイズ）
- ``0x3132333435363738393000000000000000000000000000000000000000000000`` （32バイトに右をパディングした ``"1234567890"`` ）
- ``0x00000000000000000000000000000000000000000000000000000000000000e0`` （第4パラメータのデータ部の先頭へのオフセット = 第1動的パラメータのデータ部の先頭へのオフセット + 第1動的パラメータのデータ部のサイズ = 4 \* 32 + 3 \* 32（後述））。

これに続いて、最初の動的引数のデータ部、 ``[0x456, 0x789]`` は次のようになります。

- ``0x0000000000000000000000000000000000000000000000000000000000000002`` （配列の要素数が2）
- ``0x0000000000000000000000000000000000000000000000000000000000000456`` （最初の要素）
- ``0x0000000000000000000000000000000000000000000000000000000000000789`` （2番目の要素）

最後に、2番目の動的引数である ``"Hello, world!"`` のデータ部をエンコードします。

- ``0x000000000000000000000000000000000000000000000000000000000000000d`` （要素数（ここではバイト）: 13）
- ``0x48656c6c6f2c20776f726c642100000000000000000000000000000000000000`` （ ``"Hello, world!"`` は32バイトで右をパディング）

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

.. Let us apply the same principle to encode the data for a function with a signature ``g(uint256[][],string[])``
.. with values ``([[1, 2], [3]], ["one", "two", "three"])`` but start from the most atomic parts of the encoding:

同じ原理で、シグネチャ ``g(uint256[][],string[])`` を持つ関数のデータを値 ``([[1, 2], [3]], ["one", "two", "three"])`` でエンコードしてみましょう。
ただし、エンコードの最も基本的な部分から始めます。

.. First we encode the length and data of the first embedded dynamic array ``[1, 2]`` of the first root array ``[[1, 2], [3]]``:

まず最初に、第1のルート配列 ``[[1, 2], [3]]`` の第1の埋め込み動的配列 ``[1, 2]`` の長さとデータをエンコードします。

- ``0x0000000000000000000000000000000000000000000000000000000000000002`` （1番目の配列の要素数は2で、要素は ``1`` と ``2`` ）
- ``0x0000000000000000000000000000000000000000000000000000000000000001`` （最初の要素）
- ``0x0000000000000000000000000000000000000000000000000000000000000002`` （2番目の要素）

.. Then we encode the length and data of the second embedded dynamic array ``[3]`` of the first root array ``[[1, 2], [3]]``:

そして、第1のルート配列 ``[[1, 2], [3]]`` の第2の埋め込み動的配列 ``[3]`` の長さとデータを符号化します。

- ``0x0000000000000000000000000000000000000000000000000000000000000001`` （2番目の配列の要素数は1で、要素は ``3`` ）
- ``0x0000000000000000000000000000000000000000000000000000000000000003`` （最初の要素）

.. Then we need to find the offsets ``a`` and ``b`` for their respective dynamic arrays ``[1, 2]`` and ``[3]``.
.. To calculate the offsets we can take a look at the encoded data of the first root array ``[[1, 2], [3]]``
.. enumerating each line in the encoding:

次に、それぞれの動的配列 ``[1, 2]`` と ``[3]`` に対するオフセット ``a`` と ``b`` を求める必要があります。
このオフセットを計算するために、最初のルート配列 ``[[1, 2], [3]]`` のエンコードデータを見て、エンコードの各行を列挙します。

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

- ``0x0000000000000000000000000000000000000000000000000000000000000003`` （単語 ``"one"`` の文字数）
- ``0x6f6e650000000000000000000000000000000000000000000000000000000000`` （単語 ``"one"`` のutf8表現）
- ``0x0000000000000000000000000000000000000000000000000000000000000003`` （単語 ``"two"`` の文字数）
- ``0x74776f0000000000000000000000000000000000000000000000000000000000`` （単語 ``"two"`` のutf8表現）
- ``0x0000000000000000000000000000000000000000000000000000000000000005`` （単語 ``"three"`` の文字数）
- ``0x7468726565000000000000000000000000000000000000000000000000000000`` （単語 ``"three"`` のutf8表現）

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
.. and have the same encodings for a function with a signature ``g(string[],uint256[][])``.

なお、ルート配列の埋め込み要素の符号化は互いに依存しておらず、シグネチャ ``g(string[],uint256[][])`` を持つ関数では同じ符号化になります。

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

最後に、それぞれのルート動的配列 ``[[1, 2], [3]]`` と ``["one", "two", "three"]`` のオフセット ``f`` と ``g`` を見つけ、正しい順序でパーツを組み立てます。

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

オフセット ``g`` は、配列 ``["one", "two", "three"]`` の内容の先頭である10行目（320バイト）を指しているので、 ``g = 0x0000000000000000000000000000000000000000000000000000000000000140`` となります。

.. _abi_events:

イベント
========

.. Events are an abstraction of the Ethereum logging/event-watching protocol. Log entries provide the contract's
.. address, a series of up to four topics and some arbitrary length binary data. Events leverage the existing function
.. ABI in order to interpret this (together with an interface spec) as a properly typed structure.

イベントは、Ethereumのログ/イベントウォッチングプロトコルを抽象化したものです。
ログエントリは、コントラクトのアドレス、最大4つのトピックのシリーズ、任意の長さのバイナリデータを提供します。
イベントは、既存の関数ABIを活用して、これを（インターフェース仕様とともに）適切に型付けされた構造として解釈します。

.. Given an event name and series of event parameters, we split them into two sub-series: those which are indexed and
.. those which are not.
.. Those which are indexed, which may number up to 3 (for non-anonymous events) or 4 (for anonymous ones), are used
.. alongside the Keccak hash of the event signature to form the topics of the log entry.
.. Those which are not indexed form the byte array of the event.

イベント名と一連のイベントパラメータが与えられると、それらを2つのサブシリーズに分割します。
インデックスが付けられているものは、最大で3つ（非匿名イベントの場合）または4つ（匿名イベントの場合）あり、イベント署名のKeccakハッシュと一緒にログエントリのトピックを形成するために使用されます。
インデックスが付けられていないものは、イベントのバイト配列を形成します。

.. In effect, a log entry using this ABI is described as:

事実上、このABIを使ったログエントリは次のように記述されます。

.. - ``address``: the address of the contract (intrinsically provided by Ethereum);

- ``address``: コントラクトのアドレス（Ethereumが本質的に提供するもの）。

.. - ``topics[0]``: ``keccak(EVENT_NAME+"("+EVENT_ARGS.map(canonical_type_of).join(",")+")")`` (``canonical_type_of``
..   is a function that simply returns the canonical type of a given argument, e.g. for ``uint indexed foo``, it would
..   return ``uint256``). This value is only present in ``topics[0]`` if the event is not declared as ``anonymous``;

- ``topics[0]``: ``keccak(EVENT_NAME+"("+EVENT_ARGS.map(canonical_type_of).join(",")+")")`` （ ``canonical_type_of`` は、与えられた引数の正規の型を単純に返す関数であり、例えば ``uint indexed foo`` の場合は ``uint256`` を返す）。
  この値は、イベントが ``anonymous`` として宣言されていない場合、 ``topics[0]`` にのみ存在します。

.. - ``topics[n]``: ``abi_encode(EVENT_INDEXED_ARGS[n - 1])`` if the event is not declared as ``anonymous``
..   or ``abi_encode(EVENT_INDEXED_ARGS[n])`` if it is (``EVENT_INDEXED_ARGS`` is the series of ``EVENT_ARGS`` that
..   are indexed);

- ``topics[n]``:  ``abi_encode(EVENT_INDEXED_ARGS[n]) - 1])`` イベントが ``anonymous`` として宣言されていない場合は ``abi_encode(EVENT_INDEXED_ARGS[n])``、宣言されている場合は ``abi_encode(EVENT_INDEXED_ARGS[n])`` となります（ ``EVENT_INDEXED_ARGS`` はインデックス化された ``EVENT_ARGS`` のシリーズです）。

.. - ``data``: ABI encoding of ``EVENT_NON_INDEXED_ARGS`` (``EVENT_NON_INDEXED_ARGS`` is the series of ``EVENT_ARGS``
..   that are not indexed, ``abi_encode`` is the ABI encoding function used for returning a series of typed values
..   from a function, as described above).

- ``data``: ``EVENT_NON_INDEXED_ARGS`` のABIエンコーディング（ ``EVENT_NON_INDEXED_ARGS`` はインデックスが付いていない一連の ``EVENT_ARGS`` 、 ``abi_encode`` は上述のように関数から型付けされた一連の値を返すために使用されるABIエンコーディング関数）。

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

長さが最大32バイトのすべての型について、 ``EVENT_INDEXED_ARGS`` 配列には、通常のABIエンコーディングと同様に、32バイトにパディングまたは符号拡張された値が直接格納されます。
しかし、すべての "複雑な"型や動的な長さの型（すべての配列、 ``string`` 、 ``bytes`` 、構造体を含む）では、 ``EVENT_INDEXED_ARGS`` には直接エンコードされた値ではなく、特別なインプレースエンコードされた値の *Keccakハッシュ* （ :ref:`indexed_event_encoding` 参照）が格納されます。
これにより、アプリケーションは（エンコードされた値のハッシュをトピックとして設定することで）動的長型の値を効率的に問い合わせることができますが、アプリケーションは問い合わせていないインデックス化された値をデコードできなくなります。
動的長型の場合、アプリケーション開発者は、（引数がインデックス化されている場合の）所定の値の高速検索と（引数がインデックス化されていないことが必要な）任意の値の可読性との間でトレードオフの関係に直面します。
開発者はこのトレードオフを克服し、効率的な検索と任意の可読性の両方を達成するために、同じ値を保持することを意図した2つの引数（1つはインデックス化され、1つはインデックス化されない）を持つイベントを定義できます。

.. _abi_errors:
.. index:: error, selector; of an error

エラー
======

.. In case of a failure inside a contract, the contract can use a special opcode to abort execution and revert all state changes.
.. In addition to these effects, descriptive data can be returned to the caller.
.. This descriptive data is the encoding of an error and its arguments in the same way as data for a function call.

コントラクト内部で障害が発生した場合、コントラクトは特別なオペコードを使用して実行を中止し、すべての状態変化をリバートできます。
これらの効果に加えて、記述的データを呼び出し元に返すことができます。
この記述データは、関数呼び出しのデータと同じように、エラーとその引数をエンコードしたものです。

.. As an example, let us consider the following contract whose ``transfer`` function always reverts with a custom error of "insufficient balance":

例として、 ``transfer`` 関数が常に「残高不足」というカスタムエラーでリバートしてしまう次のコントラクトを考えてみましょう。

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

    エラーデータを信用してはいけません。
    デフォルトでは、エラーデータは外部呼び出しの連鎖を通じてバブリングします。
    つまり、コントラクトは、直接呼び出すコントラクトのどれにも定義されていないエラーを受け取る可能性があります。
    さらに、どのコントラクトも、エラーがどこにも定義されていなくても、エラー署名に一致するデータを返すことで、どんなエラーでも偽装できます。

.. _abi_json:

JSON
====

.. The JSON format for a contract's interface is given by an array of function, event and error descriptions.
.. A function description is a JSON object with the fields:

コントラクトのインターフェースのJSONフォーマットは、関数、イベント、エラーの記述の配列で与えられます。
関数の記述は、フィールドを持つJSONオブジェクトです。


- ``type``: ``"function"`` 、 ``"constructor"`` 、 ``"receive"`` （ :ref:`「receive Ether」関数 <receive-ether-function>` ）、 ``"fallback"`` （ :ref:`「default」関数 <fallback-function>` ）のいずれかです。
- ``name``: 関数の名前。
- ``inputs``: オブジェクトの配列で、それぞれのオブジェクトは次のものを含みます。

  * ``name``: パラメータの名前。
  * ``type``: パラメータの正規の型（詳細は後述）。
  * ``components``: タプル型に使用（詳細は後述）。

- ``outputs``:  ``inputs`` と同様のオブジェクトの配列。
- ``stateMutability``: 以下のいずれかの値を持つ文字列。
  ``pure`` （ :ref:`ブロックチェーンのステートを読まないように指定 <pure-functions>` ）、
  ``view`` （ :ref:`ブロックチェーンのステートを修正しないように指定 <view-functions>` ）、
  ``nonpayable`` （関数はEtherを受け取らない、デフォルト）と ``payable`` （関数はEtherを受け取る）があります。

コンストラクタ、receive関数、fallback関数は ``name`` や ``outputs`` を持ちません。
receive関数とfallback関数には ``inputs`` もありません。

.. note::

    non-payableな関数にEtherを送ると、トランザクションがrevertします。

.. note::

    ステートミュータビリティ ``nonpayable`` は、Solidityではステートミュータビリティモディファイアを指定しないことで設定されます。

.. An event description is a JSON object with fairly similar fields:

イベントの記述は、同様のフィールドを持つJSONオブジェクトです。

- ``type``: 常に ``"event"`` 。
- ``name``: イベントの名前。
- ``inputs``: オブジェクトの配列で、それぞれのオブジェクトは次のものを含みます。

  * ``name``: パラメータの名前。
  * ``type``: パラメータの正規の型（詳細は後述）。
  * ``components``: タプル型に使用（詳細は後述）。
  * ``indexed``: フィールドがログのトピックの一部である場合は ``true`` 、ログのデータセグメントの一部である場合は ``false`` 。

- ``anonymous``: イベントが ``anonymous`` と宣言された場合は ``true`` 。

エラーの記述は以下の通りです。

- ``type``: 常に ``"error"`` 。
- ``name``: エラーの名前。
- ``inputs``: オブジェクトの配列で、それぞれのオブジェクトは次のものを含みます。

  *  ``name``: パラメータの名前。
  *  ``type``: パラメータの正規の型（詳細は後述）。
  *  ``components``: タプル型に使用（詳細は後述）。

.. .. note::

..   There can be multiple errors with the same name and even with identical signature
..   in the JSON array, for example if the errors originate from different
..   files in the smart contract or are referenced from another smart contract.
..   For the ABI, only the name of the error itself is relevant and not where it is
..   defined.

.. note::

  スマートコントラクト内の異なるファイルからエラーが発生した場合や、別のスマートコントラクトから参照されている場合など、JSON配列内に同じ名前や同一の署名を持つ複数のエラーが存在する可能性があります。
  ABIでは、エラー自体の名前だけが重要で、どこで定義されているかは関係ありません。

例えば、

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

は、次のJSONになります。

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

タプル型のハンドリング
----------------------

.. Despite that names are intentionally not part of the ABI encoding they do make a lot of sense to be included in the JSON to enable displaying it to the end user.
.. The structure is nested in the following way:

名前は意図的にABIエンコーディングの一部ではありませんが、エンドユーザーに表示するためにJSONに含めることには大きな意味があります。
構造は以下のように入れ子になっています。

.. An object with members ``name``, ``type`` and potentially ``components`` describes a typed variable.
.. The canonical type is determined until a tuple type is reached and the string description up
.. to that point is stored in ``type`` prefix with the word ``tuple``, i.e. it will be ``tuple`` followed by
.. a sequence of ``[]`` and ``[k]`` with
.. integers ``k``. The components of the tuple are then stored in the member ``components``,
.. which is of array type and has the same structure as the top-level object except that
.. ``indexed`` is not allowed there.

メンバー ``name`` 、 ``type`` 、そして潜在的に ``components`` を持つオブジェクトは、型付けされた変数を記述します。
タプル型に到達するまでは正規の型が決定され、その時点までの文字列記述は ``tuple`` という単語を前置した ``type`` に格納されます。
つまり、 ``tuple`` の後に整数 ``k`` を持つ ``[]`` と ``[k]`` のシーケンスが続くことになります。
その後、タプルの構成要素はメンバー ``components`` に格納されます。
``components`` は配列型で、そこに ``indexed`` が許されないことを除いて、トップレベルのオブジェクトと同じ構造を持っています。

一例として、次のコード

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

は、次のJSONになります。

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

厳密なエンコーディングモード
============================

.. Strict encoding mode is the mode that leads to exactly the same encoding as defined in the formal specification above.
.. This means offsets have to be as small as possible while still not creating overlaps in the data areas and thus no gaps are allowed.

厳密なエンコーディングモードとは、上記の正式な仕様で定義されているのと全く同じエンコーディングになるモードです。
つまり、データ領域にオーバーラップを生じさせないようにしながら、オフセットはできるだけ小さくしなければならず、したがってギャップは許されません。

.. Usually, ABI decoders are written in a straightforward way by just following offset pointers, but some decoders might enforce strict mode.
.. The Solidity ABI decoder currently does not enforce strict mode, but the encoder always creates data in strict mode.

通常、ABIデコーダはオフセットポインタに従うだけの素直な方法で書かれていますが、デコーダによってはストリクトモードを強制する場合があります。
SolidityのABIデコーダは、現在のところストリクトモードを強制していませんが、エンコーダは常にストリクトモードでデータを作成します。

非標準のパックモード
====================

Solidityは、 ``abi.encodePacked()`` を通して、非標準のパックモードをサポートしています。

.. - dynamic types are encoded in-place and without the length.
.. - array elements are padded, but still encoded in-place

- 32バイトより短い型は、パディングや符号拡張なしに、直接連結されます。
- 動的型は、インプレースで長さの情報無しにエンコードされます。
- 配列の要素はパディングされますが、インプレースでエンコードされます。

また、構造体や入れ子になった配列はサポートされていません。

例として、 ``int16(-1), bytes1(0x42), uint16(0x03), string("Hello, world!")`` をエンコードすると次のようになります。

.. code-block:: none

    0xffff42000348656c6c6f2c20776f726c6421
      ^^^^                                 int16(-1)
          ^^                               bytes1(0x42)
            ^^^^                           uint16(0x03)
                ^^^^^^^^^^^^^^^^^^^^^^^^^^ string("Hello, world!") lengthフィールド無し

より具体的には、

.. - During the encoding, everything is encoded in-place. This means that there is
..   no distinction between head and tail, as in the ABI encoding, and the length
..   of an array is not encoded.

- エンコードの際、すべてがインプレースでエンコードされます。
  つまり、ABIのエンコーディングのように、先頭と末尾の区別がなく、配列の長さもエンコードされません。

.. - The direct arguments of ``abi.encodePacked`` are encoded without padding,
..   as long as they are not arrays (or ``string`` or ``bytes``).

- ``abi.encodePacked`` の直接引数は、配列（または ``string`` や ``bytes`` ）でない限り、パディングなしでエンコードされます。

.. - The encoding of an array is the concatenation of the encoding of its elements **with** padding.

- 配列のエンコーディングは、その要素のエンコーディングとパディングを連結したものです。

.. - Dynamically-sized types like ``string``, ``bytes`` or ``uint[]`` are encoded without their length field.

- ``string`` 、 ``bytes`` 、 ``uint[]`` のような動的なサイズの型は、長さフィールドなしでエンコードされます。

.. - The encoding of ``string`` or ``bytes`` does not apply padding at the end
..   unless it is part of an array or struct (then it is padded to a multiple of
..   32 bytes).

- ``string`` や ``bytes`` のエンコーディングでは、配列や構造体の一部でない限り、末尾にパディングが適用されません（その場合、32バイトの倍数にパディングされます）。

一般的には、動的なサイズの要素が2つあると、長さのフィールドがないため、エンコーディングが曖昧になります。

.. If padding is needed, explicit type conversions can be used: ``abi.encodePacked(uint16(0x12)) == hex"0012"``.

パディングが必要な場合は、明示的な型変換を行うことができます: ``abi.encodePacked(uint16(0x12)) == hex"0012"`` 。

.. Since packed encoding is not used when calling functions, there is no special support for prepending a function selector.

関数を呼び出すときにはpackedエンコーディングは使われないので、関数セレクタの前に付ける特別なサポートはありません。
また、エンコーディングが曖昧なため、デコード関数はありません。

.. .. warning::

..     If you use ``keccak256(abi.encodePacked(a, b))`` and both ``a`` and ``b`` are dynamic types,
..     it is easy to craft collisions in the hash value by moving parts of ``a`` into ``b`` and
..     vice-versa. More specifically, ``abi.encodePacked("a", "bc") == abi.encodePacked("ab", "c")``.
..     If you use ``abi.encodePacked`` for signatures, authentication or data integrity, make
..     sure to always use the same types and check that at most one of them is dynamic.
..     Unless there is a compelling reason, ``abi.encode`` should be preferred.

.. warning::

    ``keccak256(abi.encodePacked(a, b))`` を使っていて、 ``a`` と ``b`` の両方が動的型の場合、 ``a`` の一部を ``b`` に移動させたり、逆に ``b`` の一部を ``a`` に移動させたりすることで、ハッシュ値の衝突を容易に工作できます。
    より具体的には ``abi.encodePacked("a", "bc") == abi.encodePacked("ab", "c")`` です。
    署名や認証、データの整合性のために ``abi.encodePacked`` を使用する場合は、常に同じ型を使用し、最大でもどちらかが動的型であることを確認してください。
    やむを得ない理由がない限り、 ``abi.encode`` を優先すべきです。

.. _indexed_event_encoding:

インデックスされたイベントパラメータのエンコーディング
======================================================

.. Indexed event parameters that are not value types, i.e. arrays and structs are not
.. stored directly but instead a keccak-256 hash of an encoding is stored.

値型ではないインデックスされたイベントパラメータ（配列や構造体）は、直接保存されず、エンコーディングのkeccak256ハッシュが保存されます。
このエンコーディングは以下のように定義されています。

- ``bytes`` と ``string`` の値のエンコーディングは、パディングや長さのプレフィックスを含まない文字列の内容だけになります。
- 構造体のエンコーディングは、そのメンバーのエンコーディングを32バイトの倍数にパディングして連結したものです（ ``bytes`` や ``string`` も同様）。
- 配列のエンコーディング（動的サイズと静的サイズどちらも）は、その要素のエンコーディングを32バイトの倍数にパディングして連結したもので（ ``bytes`` と ``string`` も）、長さのプレフィックスはありません。

上記では、通常と同じく負の数は符号拡張でパディングされ、ゼロパディングされません。
``bytesNN`` 型は右が、 ``uintNN``  /  ``intNN`` 型は左がパディングされます。

.. .. warning::

..     Because of that, always re-check the event data and do not rely on the search result
..     based on the indexed parameters alone.

.. warning::

    構造体に複数の動的サイズの配列が含まれていると、エンコーディングが曖昧になります。
    そのため、常にイベントデータを再確認し、インデックス化されたパラメータだけに基づく検索結果に頼らないようにしてください。
