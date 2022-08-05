.. index:: storage, state variable, mapping

************************************
ストレージ内の状態変数のレイアウト
************************************

.. _storage-inplace-encoding:

コントラクトの状態変数はストレージにコンパクトに格納され、複数の値が同じストレージスロットを使用することがあります。
動的なサイズの配列やマッピング（後述）を除き、データはスロット ``0`` に格納された最初の状態変数から順に連続して格納されます。
各変数には、その型に応じてバイト単位のサイズが決定されます。
32バイトに満たない複数の連続したアイテムは、以下のルールに従って、可能な限り1つのストレージスロットにまとめられます。

- ストレージスロットの最初のアイテムは、下位にアラインされ格納されます。
- 値型はそれを格納するのに必要な数のバイトしか使用しません。
- 値型がストレージスロットの残りの部分に収まらない場合は、次のストレージスロットに格納されます。
- 構造体や配列データは、常に新しいスロットで開始し、そのアイテムはこれらのルールに従って密にパッキングされます。
- 構造体や配列データに続くアイテムは、常に新しいストレージスロットで開始します。

.. For contracts that use inheritance, the ordering of state variables is determined by the
.. C3-linearized order of contracts starting with the most base-ward contract. If allowed
.. by the above rules, state variables from different contracts do share the same storage slot.

継承を使用しているコントラクトでは、状態変数の順序は、最も下位のコントラクトから始まるコントラクトのC3線形化された順序によって決定されます。
上記のルールで許可されていれば、異なるコントラクトの状態変数が同じストレージスロットを共有することができます。

.. The elements of structs and arrays are stored after each other, just as if they were given
.. as individual values.

構造体や配列の要素は、あたかも個々の値が与えられたかのように、それぞれの要素の後に格納されます。

.. .. warning::

..     When using elements that are smaller than 32 bytes, your contract's gas usage may be higher.
..     This is because the EVM operates on 32 bytes at a time. Therefore, if the element is smaller
..     than that, the EVM must use more operations in order to reduce the size of the element from 32
..     bytes to the desired size.

..     It might be beneficial to use reduced-size types if you are dealing with storage values
..     because the compiler will pack multiple elements into one storage slot, and thus, combine
..     multiple reads or writes into a single operation.
..     If you are not reading or writing all the values in a slot at the same time, this can
..     have the opposite effect, though: When one value is written to a multi-value storage
..     slot, the storage slot has to be read first and then
..     combined with the new value such that other data in the same slot is not destroyed.

..     When dealing with function arguments or memory
..     values, there is no inherent benefit because the compiler does not pack these values.

..     Finally, in order to allow the EVM to optimize for this, ensure that you try to order your
..     storage variables and ``struct`` members such that they can be packed tightly. For example,
..     declaring your storage variables in the order of ``uint128, uint128, uint256`` instead of
..     ``uint128, uint256, uint128``, as the former will only take up two slots of storage whereas the
..     latter will take up three.

.. warning::

    32バイト以下の要素を使用する場合、コントラクトのガス使用量が多くなる場合があります。
    これは、EVMが一度に32バイトで動作するためです。
    そのため、要素がそれよりも小さい場合、EVMは要素のサイズを32バイトから希望のサイズに縮小するために、より多くの操作を行う必要があります。

    コンパイラは複数の要素を1つのストレージスロットにまとめ、複数の読み書きを1つの操作にまとめるため、ストレージの値を扱う場合はサイズの小さい型を使用することが有益な場合があります。
    しかし、スロット内のすべての値を同時に読み書きしない場合、これは逆効果になります。
    複数の値を持つストレージスロットに1つの値が書き込まれた場合、ストレージスロットを最初に読み込んで、同じスロットの他のデータが破壊されないように新しい値と結合する必要があります。

    関数の引数やメモリの値を扱う場合は、コンパイラがこれらの値をパックしないので、本質的なメリットはありません。

    最後に、EVMに最適化させるために、ストレージ変数と ``struct`` メンバーの順番を工夫して、しっかりと詰め込むようにしてください。
    例えば、ストレージ変数を ``uint128, uint256, uint128`` ではなく ``uint128, uint128, uint256`` の順に宣言すると、前者はストレージのスロットを2つしか使用しないのに対し、後者は3つ使用することになります。

.. .. note::

..      The layout of state variables in storage is considered to be part of the external interface
..      of Solidity due to the fact that storage pointers can be passed to libraries. This means that
..      any change to the rules outlined in this section is considered a breaking change
..      of the language and due to its critical nature should be considered very carefully before
..      being executed.

.. note::

    ストレージの状態変数のレイアウトは、ストレージへのポインタをライブラリに渡すことができるため、Solidityの外部インターフェースの一部とみなされます。
    つまり、このセクションで説明されているルールを変更することは、言語の破壊的な変更とみなされ、その重大な性質のため、実行する前に非常に慎重に検討する必要があります。

マッピングと動的配列
===========================

.. _storage-hashed-encoding:

.. Due to their unpredictable size, mappings and dynamically-sized array types cannot be stored
.. "in between" the state variables preceding and following them.
.. Instead, they are considered to occupy only 32 bytes with regards to the
.. :ref:`rules above <storage-inplace-encoding>` and the elements they contain are stored starting at a different
.. storage slot that is computed using a Keccak-256 hash.

マッピングや動的なサイズの配列型は、そのサイズが予測できないため、前後の状態変数の間に格納することはできません。
その代わりに、それらは :ref:`上記のルール<storage-inplace-encoding>` に対して32バイトしか占有しないとみなされ、含まれる要素はKeccak-256ハッシュを使用して計算された別のストレージスロットから開始して格納されます。

.. Assume the storage location of the mapping or array ends up being a slot ``p``
.. after applying :ref:`the storage layout rules <storage-inplace-encoding>`.
.. For dynamic arrays,
.. this slot stores the number of elements in the array (byte arrays and
.. strings are an exception, see :ref:`below <bytes-and-string>`).
.. For mappings, the slot stays empty, but it is still needed to ensure that even if there are
.. two mappings next to each other, their content ends up at different storage locations.

マッピングや配列の格納場所が、 :ref:`ストレージのレイアウトルール<storage-inplace-encoding>` を適用した後にスロット ``p`` になったとします。
動的配列の場合、このスロットには、配列の要素数が格納されます（バイト配列と文字列は例外で、 :ref:`ここ<bytes-and-string>` を参照してください）。
マッピングの場合、このスロットは空のままですが、2つのマッピングが隣り合っていても、その内容が異なる保存場所になることを保証するために必要です。

.. Array data is located starting at ``keccak256(p)`` and it is laid out in the same way as
.. statically-sized array data would: One element after the other, potentially sharing
.. storage slots if the elements are not longer than 16 bytes. Dynamic arrays of dynamic arrays apply this
.. rule recursively. The location of element ``x[i][j]``, where the type of ``x`` is ``uint24[][]``, is
.. computed as follows (again, assuming ``x`` itself is stored at slot ``p``):
.. The slot is ``keccak256(keccak256(p) + i) + floor(j / floor(256 / 24))`` and
.. the element can be obtained from the slot data ``v`` using ``(v >> ((j % floor(256 / 24)) * 24)) & type(uint24).max``.

配列データは ``keccak256(p)`` から始まり、静的なサイズの配列データと同じように配置されています。
要素の長さが16バイト以下であれば、ストレージスロットを共有できる可能性があります。
動的配列の動的配列は、このルールを再帰的に適用します。
``x`` の型が ``uint24[][]`` である要素 ``x[i][j]`` の位置は、次のように計算されます（ここでも、 ``x`` 自身がスロット ``p`` に格納されていると仮定します）。
スロットは ``keccak256(keccak256(p) + i) + floor(j / floor(256 / 24))`` であり、要素は ``(v >> ((j % floor(256 / 24)) * 24)) & type(uint24).max`` を用いてスロットデータ ``v`` から得ることができます。

.. The value corresponding to a mapping key ``k`` is located at ``keccak256(h(k) . p)``
.. where ``.`` is concatenation and ``h`` is a function that is applied to the key depending on its type:
.. - for value types, ``h`` pads the value to 32 bytes in the same way as when storing the value in memory.
.. - for strings and byte arrays, ``h`` computes the ``keccak256`` hash of the unpadded data.

マッピングキー ``k`` に対応する値は ``keccak256(h(k) . p)`` に位置し、 ``.`` は連結、 ``h`` はキーの型に応じて適用される関数である。

- 値型の場合、 ``h`` はメモリに値を格納するときと同じように、値を32バイトにパディングします。

- 文字列やバイト配列の場合、 ``h`` はパディングされていないデータの ``keccak256`` ハッシュを計算します。

.. If the mapping value is a
.. non-value type, the computed slot marks the start of the data. If the value is of struct type,
.. for example, you have to add an offset corresponding to the struct member to reach the member.

マッピング値が非値型の場合、計算されたスロットがデータの開始を示します。
例えば、値が構造体型の場合は、構造体のメンバーに到達するために、構造体のメンバーに対応するオフセットを追加する必要があります。

.. As an example, consider the following contract:

一例として、次のようなコントラクトを考えてみましょう。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract C {
        struct S { uint16 a; uint16 b; uint256 c; }
        uint x;
        mapping(uint => mapping(uint => S)) data;
    }

.. Let us compute the storage location of ``data[4][9].c``.
.. The position of the mapping itself is ``1`` (the variable ``x`` with 32 bytes precedes it).
.. This means ``data[4]`` is stored at ``keccak256(uint256(4) . uint256(1))``. The type of ``data[4]`` is
.. again a mapping and the data for ``data[4][9]`` starts at slot
.. ``keccak256(uint256(9) . keccak256(uint256(4) . uint256(1)))``.
.. The slot offset of the member ``c`` inside the struct ``S`` is ``1`` because ``a`` and ``b`` are packed
.. in a single slot. This means the slot for
.. ``data[4][9].c`` is ``keccak256(uint256(9) . keccak256(uint256(4) . uint256(1))) + 1``.
.. The type of the value is ``uint256``, so it uses a single slot.

``data[4][9].c`` の格納位置を計算してみましょう。
マッピング自体の位置は ``1`` です（32バイトの変数 ``x`` が先に存在しています）。
つまり、 ``data[4]`` は ``keccak256(uint256(4) . uint256(1))`` に格納されます。
``data[4]`` の型は再びマッピングで、 ``data[4][9]`` のデータはスロット ``keccak256(uint256(9) . keccak256(uint256(4) . uint256(1)))`` から始まります。
``a`` と ``b`` は1つのスロットにパックされているので、構造体 ``S`` 内のメンバー ``c`` のスロットオフセットは ``1`` です。
つまり、 ``data[4][9].c`` のスロットは ``keccak256(uint256(9) . keccak256(uint256(4) . uint256(1))) + 1`` です。
値型は ``uint256`` なので、1つのスロットを使用します。

.. _bytes-and-string:

``bytes`` と ``string``
------------------------

.. ``bytes`` and ``string`` are encoded identically.
.. In general, the encoding is similar to ``bytes1[]``, in the sense that there is a slot for the array itself and
.. a data area that is computed using a ``keccak256`` hash of that slot's position.
.. However, for short values (shorter than 32 bytes) the array elements are stored together with the length in the same slot.

``bytes`` と ``string`` は同じようにエンコードされます。
一般的には、配列自体を格納するスロットと、そのスロットの位置の ``keccak256`` ハッシュを使って計算されるデータ領域があるという意味で、 ``bytes1[]`` と同様のエンコーディングになっています。
ただし、短い値（32バイトよりも）の場合は、配列の要素が長さとともに同じスロットに格納されます。

.. In particular: if the data is at most ``31`` bytes long, the elements are stored
.. in the higher-order bytes (left aligned) and the lowest-order byte stores the value ``length * 2``.
.. For byte arrays that store data which is ``32`` or more bytes long, the main slot ``p`` stores ``length * 2 + 1`` and the data is
.. stored as usual in ``keccak256(p)``. This means that you can distinguish a short array from a long array
.. by checking if the lowest bit is set: short (not set) and long (set).

具体的には、データが最大で ``31`` バイトの場合、上位バイトに要素が格納され（左詰め）、下位バイトには値 ``length * 2`` が格納されます。
``32`` バイト以上のデータを格納するバイト配列では、メインスロット ``p`` に ``length * 2 + 1`` が格納され、データは通常通り ``keccak256(p)`` に格納されます。
つまり、最下位ビットがセットされているかどうかで、short（セットされていない）、long（セットされている）と、短い配列と長い配列を見分けることができるのです。

.. .. note::

..   Handling invalidly encoded slots is currently not supported but may be added in the future.
..   If you are compiling via the experimental IR-based compiler pipeline, reading an invalidly encoded
..   slot results in a ``Panic(0x22)`` error.

.. note::

  無効にエンコードされたスロットの処理は現在サポートされていませんが、将来的に追加される可能性があります。
  実験的なIRベースのコンパイラパイプラインでコンパイルしている場合、無効にエンコードされたスロットを読み込むと ``Panic(0x22)`` エラーが発生します。

JSON出力
===========

.. _storage-layout-top-level:

.. The storage layout of a contract can be requested via
.. the :ref:`standard JSON interface <compiler-api>`.  The output is a JSON object containing two keys,
.. ``storage`` and ``types``.  The ``storage`` object is an array where each
.. element has the following form:

コントラクトのストレージレイアウトは、 :ref:`標準JSONインターフェース<compiler-api>` を介して要求できます。
出力されるのは、 ``storage`` と ``types`` の2つのキーを含むJSONオブジェクトです。
``storage`` オブジェクトは配列で、各要素は次のような形をしています。

.. code::

    {
        "astId": 2,
        "contract": "fileA:A",
        "label": "x",
        "offset": 0,
        "slot": "0",
        "type": "t_uint256"
    }

.. The example above is the storage layout of ``contract A { uint x; }`` from source unit ``fileA``
.. and
.. - ``astId`` is the id of the AST node of the state variable's declaration
.. - ``contract`` is the name of the contract including its path as prefix
.. - ``label`` is the name of the state variable
.. - ``offset`` is the offset in bytes within the storage slot according to the encoding
.. - ``slot`` is the storage slot where the state variable resides or starts. This
..   number may be very large and therefore its JSON value is represented as a
..   string.
.. - ``type`` is an identifier used as key to the variable's type information (described in the following)

上記の例は、ソースユニット ``fileA`` から ``contract A { uint x; }`` のストレージレイアウトと

- ``astId`` は状態変数の宣言のASTノードのIDです。

- ``contract`` はコントラクトの名前で、プレフィックスとしてパスを含みます。

- ``label`` は状態変数の名前です。

- ``offset`` はエンコーディングに応じたストレージスロット内のバイト単位のオフセットです。

- ``slot`` は、状態変数が存在する、あるいは、開始するストレージスロットです。この数値は非常に大きくなる可能性があるため、JSONの値は文字列として表されます。

- ``type`` は、変数の型情報のキーとなる識別子です（以下に記載）。

.. The given ``type``, in this case ``t_uint256`` represents an element in
.. ``types``, which has the form:

与えられた ``type`` 、この場合 ``t_uint256`` は、 ``types`` の中の要素を表しており、その形は

.. code::

    {
        "encoding": "inplace",
        "label": "uint256",
        "numberOfBytes": "32",
    }

.. where

.. - ``encoding`` how the data is encoded in storage, where the possible values are:

..   - ``inplace``: data is laid out contiguously in storage (see :ref:`above <storage-inplace-encoding>`).

..   - ``mapping``: Keccak-256 hash-based method (see :ref:`above <storage-hashed-encoding>`).

..   - ``dynamic_array``: Keccak-256 hash-based method (see :ref:`above <storage-hashed-encoding>`).

..   - ``bytes``: single slot or Keccak-256 hash-based depending on the data size (see :ref:`above <bytes-and-string>`).

.. - ``label`` is the canonical type name.
.. - ``numberOfBytes`` is the number of used bytes (as a decimal string).
..   Note that if ``numberOfBytes > 32`` this means that more than one slot is used.

ここで

- ``encoding`` は、データがストレージでどのようにエンコードされているかを示すもので、可能な値は以下の通りです。

  -  ``inplace`` : データがストレージに連続してレイアウトされている（ :ref:`上記<storage-inplace-encoding>` 参照）。

  -  ``mapping`` : Keccak-256ハッシュベースの方式（ :ref:`上記<storage-hashed-encoding>` 参照）。

  -  ``dynamic_array`` : Keccak-256ハッシュベースの方式（ :ref:`上記<storage-hashed-encoding>` 参照）。

  -  ``bytes`` : シングルスロット、あるいは、データサイズに応じたKeccak-256ハッシュベース（ :ref:`上記<bytes-and-string>` 参照）。

- ``label`` は正規化された型名です。

- ``numberOfBytes`` は使用されたバイト数（10進数の文字列）です。 ``numberOfBytes > 32`` の場合は、複数のスロットが使用されていることを意味することに注意してください。

.. Some types have extra information besides the four above. Mappings contain
.. its ``key`` and ``value`` types (again referencing an entry in this mapping
.. of types), arrays have its ``base`` type, and structs list their ``members`` in
.. the same format as the top-level ``storage`` (see :ref:`above
.. <storage-layout-top-level>`).

いくつかの型は、上記の4つの情報以外にも追加の情報を持っています。
マッピングには ``key`` 型と ``value`` 型があり（ここでも型のマッピングのエントリを参照しています）、配列には ``base`` 型があり、構造体には ``members`` 型がトップレベルの ``storage`` 型と同じ形式で記載されています（ :ref:`上記<storage-layout-top-level>` 参照）。

.. note ::
  コントラクトのストレージレイアウトのJSON出力フォーマットはまだ実験的なものと考えられており、Solidityの非破壊的なリリースで変更される可能性があります。

.. The following example shows a contract and its storage layout, containing
.. value and reference types, types that are encoded packed, and nested types.

次の例では、値型と参照型、エンコードされたパック型、ネストされた型を含むコントラクトとそのストレージのレイアウトを示しています。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;
    contract A {
        struct S {
            uint128 a;
            uint128 b;
            uint[2] staticArray;
            uint[] dynArray;
        }

        uint x;
        uint y;
        S s;
        address addr;
        mapping (uint => mapping (address => bool)) map;
        uint[] array;
        string s1;
        bytes b1;
    }

.. code:: json

    {
      "storage": [
        {
          "astId": 15,
          "contract": "fileA:A",
          "label": "x",
          "offset": 0,
          "slot": "0",
          "type": "t_uint256"
        },
        {
          "astId": 17,
          "contract": "fileA:A",
          "label": "y",
          "offset": 0,
          "slot": "1",
          "type": "t_uint256"
        },
        {
          "astId": 20,
          "contract": "fileA:A",
          "label": "s",
          "offset": 0,
          "slot": "2",
          "type": "t_struct(S)13_storage"
        },
        {
          "astId": 22,
          "contract": "fileA:A",
          "label": "addr",
          "offset": 0,
          "slot": "6",
          "type": "t_address"
        },
        {
          "astId": 28,
          "contract": "fileA:A",
          "label": "map",
          "offset": 0,
          "slot": "7",
          "type": "t_mapping(t_uint256,t_mapping(t_address,t_bool))"
        },
        {
          "astId": 31,
          "contract": "fileA:A",
          "label": "array",
          "offset": 0,
          "slot": "8",
          "type": "t_array(t_uint256)dyn_storage"
        },
        {
          "astId": 33,
          "contract": "fileA:A",
          "label": "s1",
          "offset": 0,
          "slot": "9",
          "type": "t_string_storage"
        },
        {
          "astId": 35,
          "contract": "fileA:A",
          "label": "b1",
          "offset": 0,
          "slot": "10",
          "type": "t_bytes_storage"
        }
      ],
      "types": {
        "t_address": {
          "encoding": "inplace",
          "label": "address",
          "numberOfBytes": "20"
        },
        "t_array(t_uint256)2_storage": {
          "base": "t_uint256",
          "encoding": "inplace",
          "label": "uint256[2]",
          "numberOfBytes": "64"
        },
        "t_array(t_uint256)dyn_storage": {
          "base": "t_uint256",
          "encoding": "dynamic_array",
          "label": "uint256[]",
          "numberOfBytes": "32"
        },
        "t_bool": {
          "encoding": "inplace",
          "label": "bool",
          "numberOfBytes": "1"
        },
        "t_bytes_storage": {
          "encoding": "bytes",
          "label": "bytes",
          "numberOfBytes": "32"
        },
        "t_mapping(t_address,t_bool)": {
          "encoding": "mapping",
          "key": "t_address",
          "label": "mapping(address => bool)",
          "numberOfBytes": "32",
          "value": "t_bool"
        },
        "t_mapping(t_uint256,t_mapping(t_address,t_bool))": {
          "encoding": "mapping",
          "key": "t_uint256",
          "label": "mapping(uint256 => mapping(address => bool))",
          "numberOfBytes": "32",
          "value": "t_mapping(t_address,t_bool)"
        },
        "t_string_storage": {
          "encoding": "bytes",
          "label": "string",
          "numberOfBytes": "32"
        },
        "t_struct(S)13_storage": {
          "encoding": "inplace",
          "label": "struct A.S",
          "members": [
            {
              "astId": 3,
              "contract": "fileA:A",
              "label": "a",
              "offset": 0,
              "slot": "0",
              "type": "t_uint128"
            },
            {
              "astId": 5,
              "contract": "fileA:A",
              "label": "b",
              "offset": 16,
              "slot": "0",
              "type": "t_uint128"
            },
            {
              "astId": 9,
              "contract": "fileA:A",
              "label": "staticArray",
              "offset": 0,
              "slot": "1",
              "type": "t_array(t_uint256)2_storage"
            },
            {
              "astId": 12,
              "contract": "fileA:A",
              "label": "dynArray",
              "offset": 0,
              "slot": "3",
              "type": "t_array(t_uint256)dyn_storage"
            }
          ],
          "numberOfBytes": "128"
        },
        "t_uint128": {
          "encoding": "inplace",
          "label": "uint128",
          "numberOfBytes": "16"
        },
        "t_uint256": {
          "encoding": "inplace",
          "label": "uint256",
          "numberOfBytes": "32"
        }
      }
    }

