.. index:: ! type;reference, ! reference type, storage, memory, location, array, struct

.. _reference-types:

Reference Types
===============

.. Values of reference type can be modified through multiple different names.
.. Contrast this with value types where you get an independent copy whenever
.. a variable of value type is used. Because of that, reference types have to be handled
.. more carefully than value types. Currently, reference types comprise structs,
.. arrays and mappings. If you use a reference type, you always have to explicitly
.. provide the data area where the type is stored: ``memory`` (whose lifetime is limited
.. to an external function call), ``storage`` (the location where the state variables
.. are stored, where the lifetime is limited to the lifetime of a contract)
.. or ``calldata`` (special data location that contains the function arguments).

参照型の値は、複数の異なる名前で変更できます。値型の変数が使われるたびに独立したコピーを得ることができる値型とは対照的です。そのため、参照型は値型よりも慎重に扱う必要があります。現在、参照型は構造体、配列、マッピングで構成されています。参照型を使用する場合は、その型が格納されているデータ領域を常に明示的に提供する必要があります。 ``memory`` （ライフタイムが外部の関数呼び出しに限定される）、 ``storage`` （状態変数が格納されている場所で、ライフタイムがコントラクトのライフタイムに限定される）、 ``calldata`` （関数の引数が格納されている特別なデータの場所）のいずれかになります。

.. An assignment or type conversion that changes the data location will always incur an automatic copy operation,
.. while assignments inside the same data location only copy in some cases for storage types.

データロケーションを変更する割り当てやタイプ変換は、常に自動コピー操作が発生しますが、同じデータロケーション内の割り当ては、ストレージタイプの場合、一部のケースでしかコピーされません。

.. _data-location:

Data location
-------------

.. Every reference type has an additional
.. annotation, the "data location", about where it is stored. There are three data locations:
.. ``memory``, ``storage`` and ``calldata``. Calldata is a non-modifiable,
.. non-persistent area where function arguments are stored, and behaves mostly like memory.

すべての参照タイプには、それがどこに保存されているかについて、「データロケーション」という追加の注釈があります。データロケーションは3つあります。 ``memory`` 、 ``storage`` 、 ``calldata`` です。Calldataは、関数の引数が格納される、変更不可能で永続性のない領域で、ほとんどメモリのように動作します。

.. .. note::

..     If you can, try to use ``calldata`` as data location because it will avoid copies and
..     also makes sure that the data cannot be modified. Arrays and structs with ``calldata``
..     data location can also be returned from functions, but it is not possible to
..     allocate such types.

.. note::

    できれば、データの場所として ``calldata`` を使うようにしましょう。コピーを避けることができますし、データが変更されないようにすることもできます。 ``calldata`` 型のデータを持つ配列や構造体は、関数から返すことができますが、そのような型を割り当てることはできません。

.. .. note::

..     Prior to version 0.6.9 data location for reference-type arguments was limited to
..     ``calldata`` in external functions, ``memory`` in public functions and either
..     ``memory`` or ``storage`` in internal and private ones.
..     Now ``memory`` and ``calldata`` are allowed in all functions regardless of their visibility.

.. note::

    バージョン0.6.9以前では、参照型引数のデータロケーションは、外部関数では ``calldata`` 、パブリック関数では ``memory`` 、内部およびプライベート関数では ``memory`` または ``storage`` に制限されていました。     現在では、 ``memory`` と ``calldata`` は、その可視性に関わらず、すべての関数で許可されています。

.. .. note::

..     Prior to version 0.5.0 the data location could be omitted, and would default to different locations
..     depending on the kind of variable, function type, etc., but all complex types must now give an explicit
..     data location.

.. note::

    バージョン0.5.0までは、データの位置を省略でき、変数の種類や関数の種類などに応じて異なる位置をデフォルトとしていましたが、現在ではすべての複合型でデータの位置を明示的に指定しなければなりません。

.. _data-location-assignment:

Data location and assignment behaviour
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. Data locations are not only relevant for persistency of data, but also for the semantics of assignments:

データの位置は、データの永続性だけでなく、割り当てのセマンティクスにも関係します。

.. * Assignments between ``storage`` and ``memory`` (or from ``calldata``)
..   always create an independent copy.

* ``storage`` と ``memory`` の間（または ``calldata`` から）のアサインでは、常に独立したコピーが作成されます。

.. * Assignments from ``memory`` to ``memory`` only create references. This means
..   that changes to one memory variable are also visible in all other memory
..   variables that refer to the same data.

* ``memory`` から ``memory`` への割り当てでは、参照のみが作成されます。つまり、あるメモリ変数の変更は、同じデータを参照している他のすべてのメモリ変数にも反映されるということです。

.. * Assignments from ``storage`` to a **local*

* ``storage`` から **ローカル** へのアサインメント

.. * storage variable also only
..   assign a reference.

* ストレージ変数も参照を割り当てるだけです。

.. * All other assignments to ``storage`` always copy. Examples for this
..   case are assignments to state variables or to members of local
..   variables of storage struct type, even if the local variable
..   itself is just a reference.

* その他の ``storage`` への割り当ては、常にコピーされます。このケースの例としては、ステート変数やstorage struct型のローカル変数のメンバへの割り当てがありますが、ローカル変数自体が単なる参照であっても同様です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.5.0 <0.9.0;

    contract C {
        // The data location of x is storage.
        // This is the only place where the
        // data location can be omitted.
        uint[] x;

        // The data location of memoryArray is memory.
        function f(uint[] memory memoryArray) public {
            x = memoryArray; // works, copies the whole array to storage
            uint[] storage y = x; // works, assigns a pointer, data location of y is storage
            y[7]; // fine, returns the 8th element
            y.pop(); // fine, modifies x through y
            delete x; // fine, clears the array, also modifies y
            // The following does not work; it would need to create a new temporary /
            // unnamed array in storage, but storage is "statically" allocated:
            // y = memoryArray;
            // This does not work either, since it would "reset" the pointer, but there
            // is no sensible location it could point to.
            // delete y;
            g(x); // calls g, handing over a reference to x
            h(x); // calls h and creates an independent, temporary copy in memory
        }

        function g(uint[] storage) internal pure {}
        function h(uint[] memory) public pure {}
    }

.. index:: ! array

.. _arrays:

Arrays
------

.. Arrays can have a compile-time fixed size, or they can have a dynamic size.

配列は、コンパイル時に固定されたサイズを持つこともあれば、動的なサイズを持つこともあります。

.. The type of an array of fixed size ``k`` and element type ``T`` is written as ``T[k]``,
.. and an array of dynamic size as ``T[]``.

固定サイズ ``k`` 、要素タイプ ``T`` の配列の型は ``T[k]`` 、動的サイズの配列は ``T[]`` と書かれています。

.. For example, an array of 5 dynamic arrays of ``uint`` is written as
.. ``uint[][5]``. The notation is reversed compared to some other languages. In
.. Solidity, ``X[3]`` is always an array containing three elements of type ``X``,
.. even if ``X`` is itself an array. This is not the case in other languages such
.. as C.

例えば、 ``uint`` の動的配列を5個並べた配列は ``uint[][5]`` と書きます。この表記法は、他のいくつかの言語とは逆になっています。Solidityでは、たとえ ``X`` がそれ自体配列であっても、 ``X[3]`` は常に ``X`` 型の3つの要素を含む配列です。これは、Cなどの他の言語ではそうではありません。

.. Indices are zero-based, and access is in the opposite direction of the
.. declaration.

インデックスはゼロベースで、アクセスは宣言とは逆方向になります。

.. For example, if you have a variable ``uint[][5] memory x``, you access the
.. seventh ``uint`` in the third dynamic array using ``x[2][6]``, and to access the
.. third dynamic array, use ``x[2]``. Again,
.. if you have an array ``T[5] a`` for a type ``T`` that can also be an array,
.. then ``a[2]`` always has type ``T``.

例えば、変数 ``uint[][5] memory x`` がある場合、3番目の動的配列の7番目の ``uint`` にアクセスするには ``x[2][6]`` を使い、3番目の動的配列にアクセスするには ``x[2]`` を使います。繰り返しになりますが、配列にもなる ``T`` 型に対して配列 ``T[5] a`` がある場合、 ``a[2]`` は常に ``T`` 型を持ちます。

.. Array elements can be of any type, including mapping or struct. The general
.. restrictions for types apply, in that mappings can only be stored in the
.. ``storage`` data location and publicly-visible functions need parameters that are :ref:`ABI types <ABI>`.

配列の要素は、マッピングや構造体など、どのような型でもよい。一般的な型の制限が適用され、マッピングは ``storage`` データの場所にしか保存できず、一般に公開されている関数には :ref:`ABI types <ABI>` のパラメータが必要となります。

.. It is possible to mark state variable arrays ``public`` and have Solidity create a :ref:`getter <visibility-and-getters>`.
.. The numeric index becomes a required parameter for the getter.

ステート変数の配列に ``public`` をマークして、Solidityに :ref:`getter <visibility-and-getters>` を作成させることが可能です。数値インデックスは、ゲッターの必須パラメータとなります。

.. Accessing an array past its end causes a failing assertion. Methods ``.push()`` and ``.push(value)`` can be used
.. to append a new element at the end of the array, where ``.push()`` appends a zero-initialized element and returns
.. a reference to it.

配列の終端を超えてアクセスすると、アサーションが失敗します。メソッド ``.push()`` と ``.push(value)`` は、配列の最後に新しい要素を追加するために使用でき、 ``.push()`` はゼロ初期化された要素を追加し、その要素への参照を返します。

.. index:: ! string, ! bytes

.. _strings:

.. _bytes:

``bytes`` and ``string`` as Arrays
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. Variables of type ``bytes`` and ``string`` are special arrays. The ``bytes`` type is similar to ``bytes1[]``,
.. but it is packed tightly in calldata and memory. ``string`` is equal to ``bytes`` but does not allow
.. length or index access.

<<<<<<< HEAD
``bytes`` 型と ``string`` 型の変数は、特殊な配列です。 ``bytes`` 型は ``bytes1[]`` と似ていますが、calldataとメモリにしっかりと詰め込まれています。 ``string`` は ``bytes`` と同じですが、長さやインデックスのアクセスはできません。

.. Solidity does not have string manipulation functions, but there are
.. third-party string libraries. You can also compare two strings by their keccak256-hash using
.. ``keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2))`` and
.. concatenate two strings using ``bytes.concat(bytes(s1), bytes(s2))``.

Solidityには文字列操作関数はありませんが、サードパーティ製の文字列ライブラリがあります。また、 ``keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2))`` を使って2つの文字列をそのkeccak256-hashで比較したり、 ``bytes.concat(bytes(s1), bytes(s2))`` を使って2つの文字列を連結できます。

.. You should use ``bytes`` over ``bytes1[]`` because it is cheaper,
.. since ``bytes1[]`` adds 31 padding bytes between the elements. As a general rule,
.. use ``bytes`` for arbitrary-length raw byte data and ``string`` for arbitrary-length
.. string (UTF-8) data. If you can limit the length to a certain number of bytes,
.. always use one of the value types ``bytes1`` to ``bytes32`` because they are much cheaper.

``bytes1[]`` は要素間に31個のパディングバイトを追加するので、 ``bytes1[]`` よりも ``bytes`` を使用した方が安価です。原則として、任意の長さの生バイトデータには ``bytes`` を、任意の長さの文字列(UTF-8)データには ``string`` を使用してください。長さを一定のバイト数に制限できる場合は、値のタイプ ``bytes1`` 〜 ``bytes32`` のいずれかを必ず使用してください（ ``bytes1`` 〜 ``bytes32`` の方がはるかに安価です）。

.. .. note::

..     If you want to access the byte-representation of a string ``s``, use
..     ``bytes(s).length`` / ``bytes(s)[7] = 'x';``. Keep in mind
..     that you are accessing the low-level bytes of the UTF-8 representation,
..     and not the individual characters.
=======
Solidity does not have string manipulation functions, but there are
third-party string libraries. You can also compare two strings by their keccak256-hash using
``keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2))`` and
concatenate two strings using ``string.concat(s1, s2)``.

You should use ``bytes`` over ``bytes1[]`` because it is cheaper,
since using ``bytes1[]`` in ``memory`` adds 31 padding bytes between the elements. Note that in ``storage``, the
padding is absent due to tight packing, see :ref:`bytes and string <bytes-and-string>`. As a general rule,
use ``bytes`` for arbitrary-length raw byte data and ``string`` for arbitrary-length
string (UTF-8) data. If you can limit the length to a certain number of bytes,
always use one of the value types ``bytes1`` to ``bytes32`` because they are much cheaper.
>>>>>>> 800088e38b5835ebdc71e9ba5299a70a5accd7c2

.. note::

    ``s`` という文字列のバイト表現にアクセスしたい場合は、 ``bytes(s).length``  /  ``bytes(s)[7] = 'x';`` を使います。UTF-8表現の低レベルバイトにアクセスしているのであって、個々の文字にアクセスしているわけではないことに注意してください。

.. index:: ! bytes-concat, ! string-concat

.. _bytes-concat:
.. _string-concat:

The functions ``bytes.concat`` and ``string.concat``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

<<<<<<< HEAD
.. You can concatenate a variable number of ``bytes`` or ``bytes1 ... bytes32`` using ``bytes.concat``.
.. The function returns a single ``bytes memory`` array that contains the contents of the arguments without padding.
.. If you want to use string parameters or other types, you need to convert them to ``bytes`` or ``bytes1``/.../``bytes32`` first.

``bytes.concat`` を使って可変数の ``bytes`` や ``bytes1 ... bytes32`` を連結できます。この関数は、パディングされていない引数の内容を含む単一の ``bytes memory`` 配列を返します。文字列のパラメータや他の型を使いたい場合は、まず ``bytes`` や ``bytes1`` /.../ ``bytes32`` に変換する必要があります。
=======
You can concatenate an arbitrary number of ``string`` values using ``string.concat``.
The function returns a single ``string memory`` array that contains the contents of the arguments without padding.
If you want to use parameters of other types that are not implicitly convertible to ``string``, you need to convert them to ``string`` first.

Analogously, the ``bytes.concat`` function can concatenate an arbitrary number of ``bytes`` or ``bytes1 ... bytes32`` values.
The function returns a single ``bytes memory`` array that contains the contents of the arguments without padding.
If you want to use string parameters or other types that are not implicitly convertible to ``bytes``, you need to convert them to ``bytes`` or ``bytes1``/.../``bytes32`` first.

>>>>>>> 800088e38b5835ebdc71e9ba5299a70a5accd7c2

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.12;

    contract C {
        string s = "Storage";
        function f(bytes calldata bc, string memory sm, bytes16 b) public view {
            string memory concatString = string.concat(s, string(bc), "Literal", sm);
            assert((bytes(s).length + bc.length + 7 + bytes(sm).length) == bytes(concatString).length);

            bytes memory concatBytes = bytes.concat(bytes(s), bc, bc[:2], "Literal", bytes(sm), b);
            assert((bytes(s).length + bc.length + 2 + 7 + bytes(sm).length + b.length) == concatBytes.length);
        }
    }

<<<<<<< HEAD
.. If you call ``bytes.concat`` without arguments it will return an empty ``bytes`` array.

引数なしで ``bytes.concat`` を呼び出すと、空の ``bytes`` 配列が返されます。
=======
If you call ``string.concat`` or ``bytes.concat`` without arguments they return an empty array.
>>>>>>> 800088e38b5835ebdc71e9ba5299a70a5accd7c2

.. index:: ! array;allocating, new

Allocating Memory Arrays
^^^^^^^^^^^^^^^^^^^^^^^^

.. Memory arrays with dynamic length can be created using the ``new`` operator.
.. As opposed to storage arrays, it is **not** possible to resize memory arrays (e.g.
.. the ``.push`` member functions are not available).
.. You either have to calculate the required size in advance
.. or create a new memory array and copy every element.

動的な長さを持つメモリアレイは、 ``new`` 演算子を使って作成できます。ストレージアレイとは対照的に、メモリアレイのサイズを変更できません（例えば、 ``.push`` メンバ関数は使用できません）。必要なサイズを事前に計算するか、新しいメモリ配列を作成してすべての要素をコピーする必要があります。

.. As all variables in Solidity, the elements of newly allocated arrays are always initialized
.. with the :ref:`default value<default-value>`.

Solidityのすべての変数と同様に、新しく割り当てられた配列の要素は、常に :ref:`default value<default-value>` で初期化されます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract C {
        function f(uint len) public pure {
            uint[] memory a = new uint[](7);
            bytes memory b = new bytes(len);
            assert(a.length == 7);
            assert(b.length == len);
            a[6] = 8;
        }
    }

.. index:: ! array;literals, ! inline;arrays

Array Literals
^^^^^^^^^^^^^^

.. An array literal is a comma-separated list of one or more expressions, enclosed
.. in square brackets (``[...]``). For example ``[1, a, f(3)]``. The type of the
.. array literal is determined as follows:

配列リテラルは、1つまたは複数の式を角括弧（ ``[...]`` ）で囲んだコンマ区切りのリストです。例えば、 ``[1, a, f(3)]`` です。配列リテラルの型は以下のように決定されます。

.. It is always a statically-sized memory array whose length is the
.. number of expressions.

これは、常に静的なサイズのメモリ配列で、その長さは式の数です。

.. The base type of the array is the type of the first expression on the list such that all
.. other expressions can be implicitly converted to it. It is a type error
.. if this is not possible.

配列の基本型は、リストの最初の式の型で、他のすべての式が暗黙的に変換できるようになっています。これができない場合は型エラーとなります。

.. It is not enough that there is a type all the elements can be converted to. One of the elements
.. has to be of that type.

すべての要素に変換できる型があるだけでは不十分です。要素の一つがその型でなければならない。

.. In the example below, the type of ``[1, 2, 3]`` is
.. ``uint8[3] memory``, because the type of each of these constants is ``uint8``. If
.. you want the result to be a ``uint[3] memory`` type, you need to convert
.. the first element to ``uint``.

下の例では、それぞれの定数の型が ``uint8`` であることから、 ``[1, 2, 3]`` の型は ``uint8[3] memory`` となります。結果を ``uint[3] memory`` 型にしたい場合は、最初の要素を ``uint`` に変換する必要があります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract C {
        function f() public pure {
            g([uint(1), 2, 3]);
        }
        function g(uint[3] memory) public pure {
            // ...
        }
    }

.. The array literal ``[1, -1]`` is invalid because the type of the first expression
.. is ``uint8`` while the type of the second is ``int8`` and they cannot be implicitly
.. converted to each other. To make it work, you can use ``[int8(1), -1]``, for example.

配列リテラル ``[1, -1]`` が無効なのは、最初の式の型が ``uint8`` であるのに対し、2番目の式の型が ``int8`` であり、両者を暗黙的に変換できないからです。これを動作させるには、例えば ``[int8(1), -1]`` を使用します。

.. Since fixed-size memory arrays of different type cannot be converted into each other
.. (even if the base types can), you always have to specify a common base type explicitly
.. if you want to use two-dimensional array literals:

異なる型の固定サイズのメモリ配列は、（基底型が変換できても）相互に変換できないため、二次元配列リテラルを使用する場合は、常に共通の基底型を明示的に指定する必要があります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract C {
        function f() public pure returns (uint24[2][4] memory) {
            uint24[2][4] memory x = [[uint24(0x1), 1], [0xffffff, 2], [uint24(0xff), 3], [uint24(0xffff), 4]];
            // The following does not work, because some of the inner arrays are not of the right type.
            // uint[2][4] memory x = [[0x1, 1], [0xffffff, 2], [0xff, 3], [0xffff, 4]];
            return x;
        }
    }

.. Fixed size memory arrays cannot be assigned to dynamically-sized
.. memory arrays, i.e. the following is not possible:

固定サイズのメモリアレイを、動的サイズのメモリアレイに割り当てることはできません。つまり、以下のことはできません。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    // This will not compile.
    contract C {
        function f() public {
            // The next line creates a type error because uint[3] memory
            // cannot be converted to uint[] memory.
            uint[] memory x = [uint(1), 3, 4];
        }
    }

.. It is planned to remove this restriction in the future, but it creates some
.. complications because of how arrays are passed in the ABI.

将来的にはこの制限を撤廃する予定ですが、ABIでの配列の受け渡し方法が複雑になってしまいました。

.. If you want to initialize dynamically-sized arrays, you have to assign the
.. individual elements:

動的なサイズの配列を初期化したい場合は、個々の要素を割り当てる必要があります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract C {
        function f() public pure {
            uint[] memory x = new uint[](3);
            x[0] = 1;
            x[1] = 3;
            x[2] = 4;
        }
    }

.. index:: ! array;length, length, push, pop, !array;push, !array;pop

.. _array-members:

Array Members
^^^^^^^^^^^^^

<<<<<<< HEAD
.. **length**:
..     Arrays have a ``length`` member that contains their number of elements.
..     The length of memory arrays is fixed (but dynamic, i.e. it can depend on
..     runtime parameters) once they are created.
.. **push()**:
..      Dynamic storage arrays and ``bytes`` (not ``string``) have a member function
..      called ``push()`` that you can use to append a zero-initialised element at the end of the array.
..      It returns a reference to the element, so that it can be used like
..      ``x.push().t = 2`` or ``x.push() = b``.
.. **push(x)**:
..      Dynamic storage arrays and ``bytes`` (not ``string``) have a member function
..      called ``push(x)`` that you can use to append a given element at the end of the array.
..      The function returns nothing.
.. **pop**:
..      Dynamic storage arrays and ``bytes`` (not ``string``) have a member
..      function called ``pop`` that you can use to remove an element from the
..      end of the array. This also implicitly calls :ref:`delete<delete>` on the removed element.

**length** : 配列には、要素数を表す ``length`` メンバがあります。     記憶配列の長さは、作成されると固定されます（ただし、動的、つまり実行時のパラメータに依存することがあります）。 **push()** : 動的記憶配列と ``bytes`` （ ``string`` ではありません）には、 ``push()`` というメンバ関数があり、配列の最後にゼロ初期化された要素を追加するのに使用できます。      この関数は、要素への参照を返すので、 ``x.push().t = 2`` や ``x.push() = b`` のように使用できます。 **push(x)** : 動的記憶配列と ``bytes`` （ ``string`` ではない）には、 ``push(x)`` というメンバ関数があり、配列の最後に与えられた要素を追加するのに使用できます。      この関数は何も返しません。 **pop** : 動的記憶配列と  ``bytes`` （ ``string``  ではありません）には  ``pop``  というメンバ関数があり、配列の最後から要素を削除するのに使用できます。この関数は、削除された要素に対して  :ref:`delete<delete>`  を暗黙的に呼び出します。

.. .. note::

..     Increasing the length of a storage array by calling ``push()``
..     has constant gas costs because storage is zero-initialised,
..     while decreasing the length by calling ``pop()`` has a
..     cost that depends on the "size" of the element being removed.
..     If that element is an array, it can be very costly, because
..     it includes explicitly clearing the removed
..     elements similar to calling :ref:`delete<delete>` on them.
=======
**length**:
    Arrays have a ``length`` member that contains their number of elements.
    The length of memory arrays is fixed (but dynamic, i.e. it can depend on
    runtime parameters) once they are created.
**push()**:
     Dynamic storage arrays and ``bytes`` (not ``string``) have a member function
     called ``push()`` that you can use to append a zero-initialised element at the end of the array.
     It returns a reference to the element, so that it can be used like
     ``x.push().t = 2`` or ``x.push() = b``.
**push(x)**:
     Dynamic storage arrays and ``bytes`` (not ``string``) have a member function
     called ``push(x)`` that you can use to append a given element at the end of the array.
     The function returns nothing.
**pop()**:
     Dynamic storage arrays and ``bytes`` (not ``string``) have a member
     function called ``pop()`` that you can use to remove an element from the
     end of the array. This also implicitly calls :ref:`delete<delete>` on the removed element. The function returns nothing.
>>>>>>> 800088e38b5835ebdc71e9ba5299a70a5accd7c2

.. note::

    ``push()`` を呼び出してストレージ配列の長さを増加させると、ストレージがゼロ初期化されるため、ガスコストが一定になります。一方、 ``pop()`` を呼び出して長さを減少させると、削除される要素の「サイズ」に依存するコストが発生します。     その要素が配列の場合は、 :ref:`delete<delete>` を呼び出すのと同様に、削除された要素を明示的にクリアすることが含まれるため、非常にコストがかかります。

.. .. note::

..     To use arrays of arrays in external (instead of public) functions, you need to
..     activate ABI coder v2.

.. note::

    配列の配列を（publicではなく）外部関数で使用するには、ABI coder v2を有効にする必要があります。

.. .. note::

..     In EVM versions before Byzantium, it was not possible to access
..     dynamic arrays return from function calls. If you call functions
..     that return dynamic arrays, make sure to use an EVM that is set to
..     Byzantium mode.

.. note::

    Byzantium以前のEVMバージョンでは、関数呼び出しから返される動的配列にアクセスできませんでした。動的配列を返す関数を呼び出す場合は、必ずByzantiumモードに設定されたEVMを使用してください。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    contract ArrayContract {
        uint[2**20] aLotOfIntegers;
        // Note that the following is not a pair of dynamic arrays but a
        // dynamic array of pairs (i.e. of fixed size arrays of length two).
        // Because of that, T[] is always a dynamic array of T, even if T
        // itself is an array.
        // Data location for all state variables is storage.
        bool[2][] pairsOfFlags;

        // newPairs is stored in memory - the only possibility
        // for public contract function arguments
        function setAllFlagPairs(bool[2][] memory newPairs) public {
            // assignment to a storage array performs a copy of ``newPairs`` and
            // replaces the complete array ``pairsOfFlags``.
            pairsOfFlags = newPairs;
        }

        struct StructType {
            uint[] contents;
            uint moreInfo;
        }
        StructType s;

        function f(uint[] memory c) public {
            // stores a reference to ``s`` in ``g``
            StructType storage g = s;
            // also changes ``s.moreInfo``.
            g.moreInfo = 2;
            // assigns a copy because ``g.contents``
            // is not a local variable, but a member of
            // a local variable.
            g.contents = c;
        }

        function setFlagPair(uint index, bool flagA, bool flagB) public {
            // access to a non-existing index will throw an exception
            pairsOfFlags[index][0] = flagA;
            pairsOfFlags[index][1] = flagB;
        }

        function changeFlagArraySize(uint newSize) public {
            // using push and pop is the only way to change the
            // length of an array
            if (newSize < pairsOfFlags.length) {
                while (pairsOfFlags.length > newSize)
                    pairsOfFlags.pop();
            } else if (newSize > pairsOfFlags.length) {
                while (pairsOfFlags.length < newSize)
                    pairsOfFlags.push();
            }
        }

        function clear() public {
            // these clear the arrays completely
            delete pairsOfFlags;
            delete aLotOfIntegers;
            // identical effect here
            pairsOfFlags = new bool[2][](0);
        }

        bytes byteData;

        function byteArrays(bytes memory data) public {
            // byte arrays ("bytes") are different as they are stored without padding,
            // but can be treated identical to "uint8[]"
            byteData = data;
            for (uint i = 0; i < 7; i++)
                byteData.push();
            byteData[3] = 0x08;
            delete byteData[2];
        }

        function addFlag(bool[2] memory flag) public returns (uint) {
            pairsOfFlags.push(flag);
            return pairsOfFlags.length;
        }

        function createMemoryArray(uint size) public pure returns (bytes memory) {
            // Dynamic memory arrays are created using `new`:
            uint[2][] memory arrayOfPairs = new uint[2][](size);

            // Inline arrays are always statically-sized and if you only
            // use literals, you have to provide at least one type.
            arrayOfPairs[0] = [uint(1), 2];

            // Create a dynamic byte array:
            bytes memory b = new bytes(200);
            for (uint i = 0; i < b.length; i++)
                b[i] = bytes1(uint8(i));
            return b;
        }
    }

.. index:: ! array;dangling storage references

Dangling References to Storage Array Elements
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When working with storage arrays, you need to take care to avoid dangling references.
A dangling reference is a reference that points to something that no longer exists or has been
moved without updating the reference. A dangling reference can for example occur, if you store a
reference to an array element in a local variable and then ``.pop()`` from the containing array:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0 <0.9.0;

    contract C {
        uint[][] s;

        function f() public {
            // Stores a pointer to the last array element of s.
            uint[] storage ptr = s[s.length - 1];
            // Removes the last array element of s.
            s.pop();
            // Writes to the array element that is no longer within the array.
            ptr.push(0x42);
            // Adding a new element to ``s`` now will not add an empty array, but
            // will result in an array of length 1 with ``0x42`` as element.
            s.push();
            assert(s[s.length - 1][0] == 0x42);
        }
    }

The write in ``ptr.push(0x42)`` will **not** revert, despite the fact that ``ptr`` no
longer refers to a valid element of ``s``. Since the compiler assumes that unused storage
is always zeroed, a subsequent ``s.push()`` will not explicitly write zeroes to storage,
so the last element of ``s`` after that ``push()`` will have length ``1`` and contain
``0x42`` as its first element.

Note that Solidity does not allow to declare references to value types in storage. These kinds
of explicit dangling references are restricted to nested reference types. However, dangling references
can also occur temporarily when using complex expressions in tuple assignments:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0 <0.9.0;

    contract C {
        uint[] s;
        uint[] t;
        constructor() {
            // Push some initial values to the storage arrays.
            s.push(0x07);
            t.push(0x03);
        }

        function g() internal returns (uint[] storage) {
            s.pop();
            return t;
        }

        function f() public returns (uint[] memory) {
            // The following will first evaluate ``s.push()`` to a reference to a new element
            // at index 1. Afterwards, the call to ``g`` pops this new element, resulting in
            // the left-most tuple element to become a dangling reference. The assignment still
            // takes place and will write outside the data area of ``s``.
            (s.push(), g()[0]) = (0x42, 0x17);
            // A subsequent push to ``s`` will reveal the value written by the previous
            // statement, i.e. the last element of ``s`` at the end of this function will have
            // the value ``0x42``.
            s.push();
            return s;
        }
    }

It is always safer to only assign to storage once per statement and to avoid
complex expressions on the left-hand-side of an assignment.

You need to take particular care when dealing with references to elements of
``bytes`` arrays, since a ``.push()`` on a bytes array may switch :ref:`from short
to long layout in storage<bytes-and-string>`.

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0 <0.9.0;

    // This will report a warning
    contract C {
        bytes x = "012345678901234567890123456789";

        function test() external returns(uint) {
            (x.push(), x.push()) = (0x01, 0x02);
            return x.length;
        }
    }

Here, when the first ``x.push()`` is evaluated, ``x`` is still stored in short
layout, thereby ``x.push()`` returns a reference to an element in the first storage slot of
``x``. However, the second ``x.push()`` switches the bytes array to large layout.
Now the element that ``x.push()`` referred to is in the data area of the array while
the reference still points at its original location, which is now a part of the length field
and the assignment will effectively garble the length of ``x``.
To be safe, only enlarge bytes arrays by at most one element during a single
assignment and do not simultaneously index-access the array in the same statement.

While the above describes the behaviour of dangling storage references in the
current version of the compiler, any code with dangling references should be
considered to have *undefined behaviour*. In particular, this means that
any future version of the compiler may change the behaviour of code that
involves dangling references.

Be sure to avoid dangling references in your code!

.. index:: ! array;slice

.. _array-slices:

Array Slices
------------

.. Array slices are a view on a contiguous portion of an array.
.. They are written as ``x[start:end]``, where ``start`` and
.. ``end`` are expressions resulting in a uint256 type (or
.. implicitly convertible to it). The first element of the
.. slice is ``x[start]`` and the last element is ``x[end - 1]``.

配列のスライスは、配列の連続した部分の表示です。スライスは ``x[start:end]`` と書き、 ``start`` と ``end`` はuint256型になる（または暗黙のうちに変換できる）式です。スライスの最初の要素は  ``x[start]``  で、最後の要素は  ``x[end - 1]``  です。

.. If ``start`` is greater than ``end`` or if ``end`` is greater
.. than the length of the array, an exception is thrown.

``start`` が ``end`` より大きい場合や、 ``end`` が配列の長さより大きい場合は、例外が発生します。

.. Both ``start`` and ``end`` are optional: ``start`` defaults
.. to ``0`` and ``end`` defaults to the length of the array.

``start`` と ``end`` はどちらもオプションです。 ``start`` はデフォルトで ``0`` 、 ``end`` はデフォルトで配列の長さになります。

.. Array slices do not have any members. They are implicitly
.. convertible to arrays of their underlying type
.. and support index access. Index access is not absolute
.. in the underlying array, but relative to the start of
.. the slice.

配列スライスは、メンバーを持ちません。スライスは、基礎となる型の配列に暗黙的に変換可能で、インデックスアクセスをサポートします。インデックスアクセスは、基礎となる配列では絶対的なものではなく、スライスの開始点からの相対的なものです。

.. Array slices do not have a type name which means
.. no variable can have an array slices as type,
.. they only exist in intermediate expressions.

配列スライスには型名がありません。つまり、どの変数も配列スライスを型として持つことはできず、中間式にのみ存在することになります。

.. .. note::

..     As of now, array slices are only implemented for calldata arrays.

.. note::

    現在のところ、配列スライスはcalldata配列に対してのみ実装されています。

.. Array slices are useful to ABI-decode secondary data passed in function parameters:

配列スライスは、関数のパラメータで渡された二次データをABIデコードするのに便利です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.5 <0.9.0;
    contract Proxy {
        /// @dev Address of the client contract managed by proxy i.e., this contract
        address client;

        constructor(address client_) {
            client = client_;
        }

        /// Forward call to "setOwner(address)" that is implemented by client
        /// after doing basic validation on the address argument.
        function forward(bytes calldata payload) external {
            bytes4 sig = bytes4(payload[:4]);
            // Due to truncating behaviour, bytes4(payload) performs identically.
            // bytes4 sig = bytes4(payload);
            if (sig == bytes4(keccak256("setOwner(address)"))) {
                address owner = abi.decode(payload[4:], (address));
                require(owner != address(0), "Address of owner cannot be zero.");
            }
            (bool status,) = client.delegatecall(payload);
            require(status, "Forwarded call failed.");
        }
    }

.. index:: ! struct, ! type;struct

.. _structs:

Structs
-------

.. Solidity provides a way to define new types in the form of structs, which is
.. shown in the following example:

Solidityでは、構造体の形で新しい型を定義する方法を提供しており、次の例のようになります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    // Defines a new type with two fields.
    // Declaring a struct outside of a contract allows
    // it to be shared by multiple contracts.
    // Here, this is not really needed.
    struct Funder {
        address addr;
        uint amount;
    }

    contract CrowdFunding {
        // Structs can also be defined inside contracts, which makes them
        // visible only there and in derived contracts.
        struct Campaign {
            address payable beneficiary;
            uint fundingGoal;
            uint numFunders;
            uint amount;
            mapping (uint => Funder) funders;
        }

        uint numCampaigns;
        mapping (uint => Campaign) campaigns;

        function newCampaign(address payable beneficiary, uint goal) public returns (uint campaignID) {
            campaignID = numCampaigns++; // campaignID is return variable
            // We cannot use "campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0)"
            // because the right hand side creates a memory-struct "Campaign" that contains a mapping.
            Campaign storage c = campaigns[campaignID];
            c.beneficiary = beneficiary;
            c.fundingGoal = goal;
        }

        function contribute(uint campaignID) public payable {
            Campaign storage c = campaigns[campaignID];
            // Creates a new temporary memory struct, initialised with the given values
            // and copies it over to storage.
            // Note that you can also use Funder(msg.sender, msg.value) to initialise.
            c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value});
            c.amount += msg.value;
        }

        function checkGoalReached(uint campaignID) public returns (bool reached) {
            Campaign storage c = campaigns[campaignID];
            if (c.amount < c.fundingGoal)
                return false;
            uint amount = c.amount;
            c.amount = 0;
            c.beneficiary.transfer(amount);
            return true;
        }
    }

.. The contract does not provide the full functionality of a crowdfunding
.. contract, but it contains the basic concepts necessary to understand structs.
.. Struct types can be used inside mappings and arrays and they can themselves
.. contain mappings and arrays.

この コントラクトは、クラウドファンディングの コントラクトの機能をすべて提供するものではありませんが、構造体を理解するために必要な基本的な概念が含まれています。構造体はマッピングや配列の内部で使用でき、構造体自身もマッピングや配列を含むことができます。

.. It is not possible for a struct to contain a member of its own type,
.. although the struct itself can be the value type of a mapping member
.. or it can contain a dynamically-sized array of its type.
.. This restriction is necessary, as the size of the struct has to be finite.

構造体に自身の型のメンバーを含めることはできませんが、構造体自体をマッピング・メンバーの値の型にしたり、構造体にその型の動的サイズの配列を含めることはできます。構造体のサイズは有限である必要があるため、この制限は必要です。

.. Note how in all the functions, a struct type is assigned to a local variable
.. with data location ``storage``.
.. This does not copy the struct but only stores a reference so that assignments to
.. members of the local variable actually write to the state.

すべての関数で、構造体タイプがデータロケーション ``storage`` のローカル変数に割り当てられていることに注目してください。これは構造体をコピーするのではなく、参照を保存するだけなので、ローカル変数のメンバーへの割り当ては実際にステートに書き込まれます。

.. Of course, you can also directly access the members of the struct without
.. assigning it to a local variable, as in
.. ``campaigns[campaignID].amount = 0``.

もちろん、 ``campaigns[campaignID].amount = 0`` のようにローカル変数に代入せずに、構造体のメンバーに直接アクセスすることもできます。

.. .. note::

..     Until Solidity 0.7.0, memory-structs containing members of storage-only types (e.g. mappings)
..     were allowed and assignments like ``campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0)``
..     in the example above would work and just silently skip those members.
.. 

.. note::

    Solidity 0.7.0までは、ストレージのみの型（マッピングなど）のメンバーを含むメモリ構造が許可されており、上の例の ``campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0)`` のような割り当てが機能し、それらのメンバーを静かにスキップしていました。
