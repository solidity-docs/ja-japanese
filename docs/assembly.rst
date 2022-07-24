.. _inline-assembly:

########################
インラインアセンブリ
########################

.. index:: ! assembly, ! asm, ! evmasm

Ethereum Virtual Machineの言語に近い言語で、Solidityのステートメントにインラインアセンブリを挟むことができます。
これにより、より細かな制御が可能となり、特にライブラリを書いて言語を強化する場合に有効です。

Solidityのインラインアセンブリに使用される言語は :ref:`Yul <yul>` と呼ばれ、詳細はそのセクションに書かれています。
このセクションでは、インラインアセンブリのコードが周囲のSolidityコードとどのように連携するかについてのみ説明します。

.. .. warning::

..     Inline assembly is a way to access the Ethereum Virtual Machine
..     at a low level. This bypasses several important safety
..     features and checks of Solidity. You should only use it for
..     tasks that need it, and only if you are confident with using it.

.. warning::

    インラインアセンブリは、Ethereum Virtual Machineに低レベルでアクセスする方法です。
    これは、Solidityのいくつかの重要な安全機能とチェックをバイパスします。
    必要なタスクにのみ使用し、使用に自信がある場合のみ使用してください。

.. An inline assembly block is marked by ``assembly { ... }``, where the code inside
.. the curly braces is code in the :ref:`Yul <yul>` language.

インラインアセンブリブロックは ``assembly { ... }`` で示され、中括弧内のコードは :ref:`Yul <yul>` 言語のコードです。

.. The inline assembly code can access local Solidity variables as explained below.

インラインのアセンブリコードは、以下のようにSolidityのローカル変数にアクセスできます。

.. Different inline assembly blocks share no namespace, i.e. it is not possible
.. to call a Yul function or access a Yul variable defined in a different inline assembly block.

異なるインラインアセンブリブロックは、名前空間を共有しません。
つまり、異なるインラインアセンブリブロックで定義されたYul関数を呼び出したり、Yul変数にアクセスしたりできません。

例
-------

.. The following example provides library code to access the code of another contract and
.. load it into a ``bytes`` variable. This is possible with "plain Solidity" too, by using
.. ``<address>.code``. But the point here is that reusable assembly libraries can enhance the
.. Solidity language without a compiler change.

次の例では、他のコントラクトのコードにアクセスし、それを ``bytes`` 変数にロードするライブラリコードを提供しています。
これは「素のSolidity」でも ``<address>.code`` を使えば可能です。
しかし、ここでのポイントは、再利用可能なアセンブリライブラリは、コンパイラを変更することなくSolidity言語を強化できるということです。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    library GetCode {
        function at(address _addr) public view returns (bytes memory o_code) {
            assembly {
                // コードのサイズを取得します。これはアセンブリが必要です。
                let size := extcodesize(_addr)
                // 出力バイト配列を確保します。
                // これは、o_code = new bytes(size) を用いて，アセンブリなしで行うこともできます。
                o_code := mload(0x40)
                // パディングを含む新しい"memory end"です。
                mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
                // メモリにコードサイズを格納します。
                mstore(o_code, size)
                // 実際のコードを取得します。これはアセンブリが必要です。
                extcodecopy(_addr, add(o_code, 0x20), 0, size)
            }
        }
    }

.. Inline assembly is also beneficial in cases where the optimizer fails to produce
.. efficient code, for example:

インラインアセンブリは、オプティマイザが効率的なコードを生成できない場合などにも有効です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    library VectorSum {
        // この関数は、現在、オプティマイザが配列アクセスにおける境界チェックを除去しないため、効率が悪くなっています。
        function sumSolidity(uint[] memory _data) public pure returns (uint sum) {
            for (uint i = 0; i < _data.length; ++i)
                sum += _data[i];
        }

        // 列へのアクセスは境界内だけであることが分かっているので、チェックを回避できます。
        // 最初のスロットに配列の長さが入っているので、0x20を配列に追加する必要があります。
        function sumAsm(uint[] memory _data) public pure returns (uint sum) {
            for (uint i = 0; i < _data.length; ++i) {
                assembly {
                    sum := add(sum, mload(add(add(_data, 0x20), mul(i, 0x20))))
                }
            }
        }

        // 上記と同じですが、コード全体をインラインアセンブリで実現します。
        function sumPureAsm(uint[] memory _data) public pure returns (uint sum) {
            assembly {
                // 長さ（最初の32バイト）を読み込む
                let len := mload(_data)

                // 長さのフィールドをスキップする。
                //
                // in-placeでインクリメントできるように一時的な変数を保持する。
                //
                // 注: _data をインクリメントすると、このアセンブリブロックの後では _data 変数は使用できなくなります。
                let data := add(_data, 0x20)

                // 上限に達するまで反復する。
                for
                    { let end := add(data, mul(len, 0x20)) }
                    lt(data, end)
                    { data := add(data, 0x20) }
                {
                    sum := add(sum, mload(data))
                }
            }
        }
    }

外部変数、外部関数、外部ライブラリへのアクセス
---------------------------------------------------------

.. You can access Solidity variables and other identifiers by using their name.

Solidityの変数やその他の識別子は、その名前を使ってアクセスできます。

.. Local variables of value type are directly usable in inline assembly.
.. They can both be read and assigned to.

値型のローカル変数は、インラインアセンブリで直接使用できます。読み込みと代入の両方が可能です。

.. Local variables that refer to memory evaluate to the address of the variable in memory not the value itself.
.. Such variables can also be assigned to, but note that an assignment will only change the pointer and not the data
.. and that it is your responsibility to respect Solidity's memory management.
.. See :ref:`Conventions in Solidity <conventions-in-solidity>`.

メモリを参照するローカル変数は、値そのものではなく、メモリ内の変数のアドレスを評価します。
このような変数は代入することもできますが、代入はポインタを変更するだけでデータを変更するわけではないので、Solidityのメモリ管理を尊重する責任があることに注意してください。
:ref:`Solidityの慣習 <conventions-in-solidity>` を参照してください。

.. Similarly, local variables that refer to statically-sized calldata arrays or calldata structs
.. evaluate to the address of the variable in calldata, not the value itself.
.. The variable can also be assigned a new offset, but note that no validation to ensure that
.. the variable will not point beyond ``calldatasize()`` is performed.

同様に、静的なサイズのcalldata配列やcalldata構造体を参照するローカル変数は、値そのものではなく、calldata内の変数のアドレスに評価されます。
変数に新しいオフセットを割り当てることもできますが、変数が ``calldatasize()`` を超えてポイントしないことを確認する検証は行われないことに注意してください。

.. For external function pointers the address and the function selector can be
.. accessed using ``x.address`` and ``x.selector``.
.. The selector consists of four right-aligned bytes.
.. Both values are can be assigned to. For example:

外部関数ポインターの場合、アドレスと関数セレクターは ``x.address`` と ``x.selector`` を使ってアクセスできます。
セレクタは右揃えの4バイトで構成されています。
いずれの値も代入可能です。
例えば、以下のようになります。

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.10 <0.9.0;

    contract C {
        // 返り値を格納する変数 @fun に新しいセレクタとアドレスを代入する。
        function combineToFunctionPointer(address newAddress, uint newSelector) public pure returns (function() external fun) {
            assembly {
                fun.selector := newSelector
                fun.address  := newAddress
            }
        }
    }

.. For dynamic calldata arrays, you can access
.. their calldata offset (in bytes) and length (number of elements) using ``x.offset`` and ``x.length``.
.. Both expressions can also be assigned to, but as for the static case, no validation will be performed
.. to ensure that the resulting data area is within the bounds of ``calldatasize()``.

動的なcalldata配列の場合、 ``x.offset`` と ``x.length`` を使ってcalldataのオフセット（バイト単位）と長さ（要素数）にアクセスできます。
両方の式は代入することもできますが、静的の場合と同様に、結果として得られるデータ領域が ``calldatasize()`` の範囲内にあるかどうかの検証は行われません。

.. For local storage variables or state variables, a single Yul identifier
.. is not sufficient, since they do not necessarily occupy a single full storage slot.
.. Therefore, their "address" is composed of a slot and a byte-offset
.. inside that slot. To retrieve the slot pointed to by the variable ``x``, you
.. use ``x.slot``, and to retrieve the byte-offset you use ``x.offset``.
.. Using ``x`` itself will result in an error.

ローカルストレージ変数やステート変数の場合、必ずしも1つのストレージスロットを占有しているわけではないので、単一のYul識別子では不十分です。
そのため、変数の「アドレス」は、スロットとそのスロット内のバイトオフセットで構成されます。
変数 ``x`` が指すスロットを取得するには ``x.slot`` を、バイトオフセットを取得するには ``x.offset`` を使います。
``x`` をそのまま使うとエラーになります。

.. You can also assign to the ``.slot`` part of a local storage variable pointer.
.. For these (structs, arrays or mappings), the ``.offset`` part is always zero.
.. It is not possible to assign to the ``.slot`` or ``.offset`` part of a state variable,
.. though.

また、ローカルストレージの変数ポインタの ``.slot`` 部に代入することもできます。
これら（構造体、配列、マッピング）の場合、 ``.offset`` 部は常にゼロです。
ただし、ステート変数の ``.slot`` または ``.offset`` 部分に代入できません。

.. Local Solidity variables are available for assignments, for example:

ローカルSolidityの変数は代入に利用できます。例:

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;

    contract C {
        uint b;
        function f(uint x) public view returns (uint r) {
            assembly {
                // ストレージスロットのオフセットは無視します。
                // この特別なケースではゼロであることが分かっています。
                r := mul(x, sload(b.slot))
            }
        }
    }

.. .. warning::

..     If you access variables of a type that spans less than 256 bits
..     (for example ``uint64``, ``address``, or ``bytes16``),
..     you cannot make any assumptions about bits not part of the
..     encoding of the type. Especially, do not assume them to be zero.
..     To be safe, always clear the data properly before you use it
..     in a context where this is important:
..     ``uint32 x = f(); assembly { x := and(x, 0xffffffff) /* now use x */ }``
..     To clean signed types, you can use the ``signextend`` opcode:
..     ``assembly { signextend(<num_bytes_of_x_minus_one>, x) }``

.. warning::

    256ビット未満の型（ ``uint64`` 、 ``address`` 、 ``bytes16`` など）の変数にアクセスする場合、その型のエンコーディングに含まれないビットを仮定することはできません。
    特に、それらをゼロと仮定してはいけません。
    安全のために、このことが重要な文脈で使用する前に、必ずデータを適切にクリアしてください。
    ``uint32 x = f(); assembly { x := and(x, 0xffffffff) /* now use x */ }`` 符号付きの型をクリーンにするには、 ``signextend`` オペコードを使用できます。
    オペコード: ``assembly { signextend(<num_bytes_of_x_minus_one>, x) }``

.. Since Solidity 0.6.0 the name of a inline assembly variable may not
.. shadow any declaration visible in the scope of the inline assembly block
.. (including variable, contract and function declarations).

Solidity 0.6.0以降、インラインアセンブリ変数の名前は、インラインアセンブリブロックのスコープ内で見える宣言（変数宣言、コントラクト宣言、関数宣言を含む）をシャドウイングできません。

.. Since Solidity 0.7.0, variables and functions declared inside the
.. inline assembly block may not contain ``.``, but using ``.`` is
.. valid to access Solidity variables from outside the inline assembly block.

Solidity 0.7.0以降、インラインアセンブリブロック内で宣言された変数や関数は ``.`` を含むことができませんが、インラインアセンブリブロックの外からSolidityの変数にアクセスするために ``.`` を使用することは有効です。

避けるべきこと
---------------

.. Inline assembly might have a quite high-level look, but it actually is extremely
.. low-level. Function calls, loops, ifs and switches are converted by simple
.. rewriting rules and after that, the only thing the assembler does for you is re-arranging
.. functional-style opcodes, counting stack height for
.. variable access and removing stack slots for assembly-local variables when the end
.. of their block is reached.

インラインアセンブリは、かなりハイレベルな見た目をしていますが、実際には極めてローレベルです。
関数呼び出し、ループ、if、スイッチは簡単な書き換えルールで変換され、その後、アセンブラがしてくれるのは、関数型オペコードの再配置、変数アクセスのためのスタックの高さのカウント、ブロックの終わりに達したときのアセンブリローカル変数のスタックスロットの削除だけです。

.. _conventions-in-solidity:

Solidityの慣習
-----------------------

.. In contrast to EVM assembly, Solidity has types which are narrower than 256 bits,
.. e.g. ``uint24``. For efficiency, most arithmetic operations ignore the fact that
.. types can be shorter than 256
.. bits, and the higher-order bits are cleaned when necessary,
.. i.e., shortly before they are written to memory or before comparisons are performed.
.. This means that if you access such a variable
.. from within inline assembly, you might have to manually clean the higher-order bits
.. first.

EVMアセンブリとは対照的に、Solidityには、 ``uint24`` などの256ビットよりも小さい型があります。
効率化のため、ほとんどの算術演算では、型が256ビットよりも短い可能性があるという事実は無視され、高次のビットは必要に応じて、つまり、メモリに書き込まれる直前や比較が実行される前に、クリーニングされます。
つまり、インラインアセンブリ内でこのような変数にアクセスする場合、最初に高次ビットを手動でクリーニングする必要があるかもしれません。

.. Solidity manages memory in the following way. There is a "free memory pointer"
.. at position ``0x40`` in memory. If you want to allocate memory, use the memory
.. starting from where this pointer points at and update it.
.. There is no guarantee that the memory has not been used before and thus
.. you cannot assume that its contents are zero bytes.
.. There is no built-in mechanism to release or free allocated memory.
.. Here is an assembly snippet you can use for allocating memory that follows the process outlined above

Solidityは次のような方法でメモリを管理しています。
メモリの位置 ``0x40`` に「フリーメモリポインタ」があります。
メモリを確保したい場合は、このポインタが指す位置から始まるメモリを使用し、更新します。
このメモリが以前に使用されていないという保証はないので、その内容が0バイトであると仮定できません。
割り当てられたメモリを解放するメカニズムは組み込まれていません。
以下は、上記のプロセスに沿ってメモリを割り当てるために使用できるアセンブリスニペットです。

.. code-block:: yul

    function allocate(length) -> pos {
      pos := mload(0x40)
      mstore(0x40, add(pos, length))
    }

.. The first 64 bytes of memory can be used as "scratch space" for short-term
.. allocation. The 32 bytes after the free memory pointer (i.e., starting at ``0x60``)
.. are meant to be zero permanently and is used as the initial value for
.. empty dynamic memory arrays.
.. This means that the allocatable memory starts at ``0x80``, which is the initial value
.. of the free memory pointer.

メモリの最初の64バイトは、短期的に割り当てられる「スクラッチスペース」として使用できます。
フリーメモリポインタの後の32バイト（つまり ``0x60`` から始まる）は、永久にゼロであることを意味し、空の動的メモリ配列の初期値として使用されます。
つまり、割り当て可能なメモリは、フリーメモリポインタの初期値である ``0x80`` から始まります。

.. Elements in memory arrays in Solidity always occupy multiples of 32 bytes (this is
.. even true for ``bytes1[]``, but not for ``bytes`` and ``string``). Multi-dimensional memory
.. arrays are pointers to memory arrays. The length of a dynamic array is stored at the
.. first slot of the array and followed by the array elements.

Solidityのメモリ配列の要素は、常に32バイトの倍数を占めています（これは ``bytes1[]`` でも当てはまりますが、 ``bytes`` と ``string`` では当てはまりません）。
多次元のメモリ配列は、メモリ配列へのポインタです。
動的配列の長さは、配列の最初のスロットに格納され、その後に配列要素が続きます。

.. .. warning::

..     Statically-sized memory arrays do not have a length field, but it might be added later
..     to allow better convertibility between statically- and dynamically-sized arrays, so
..     do not rely on this.
.. 

.. warning::

    静的サイズのメモリ配列にはlengthフィールドがありませんが、静的サイズの配列と動的サイズの配列の間でより良い変換を可能にするために、後に追加されるかもしれませんので、これに頼らないようにしてください。
