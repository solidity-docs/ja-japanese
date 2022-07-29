.. index:: ! library, callcode, delegatecall

.. _libraries:

*********
Libraries
*********

.. Libraries are similar to contracts, but their purpose is that they are deployed
.. only once at a specific address and their code is reused using the ``DELEGATECALL``
.. (``CALLCODE`` until Homestead)
.. feature of the EVM. This means that if library functions are called, their code
.. is executed in the context of the calling contract, i.e. ``this`` points to the
.. calling contract, and especially the storage from the calling contract can be
.. accessed. As a library is an isolated piece of source code, it can only access
.. state variables of the calling contract if they are explicitly supplied (it
.. would have no way to name them, otherwise). Library functions can only be
.. called directly (i.e. without the use of ``DELEGATECALL``) if they do not modify
.. the state (i.e. if they are ``view`` or ``pure`` functions),
.. because libraries are assumed to be stateless. In particular, it is
.. not possible to destroy a library.

ライブラリはコントラクトに似ていますが、その目的は、特定のアドレスに一度だけデプロイされ、そのコードはEVMの ``DELEGATECALL`` （ホームステッドまでの ``CALLCODE`` ）機能を使って再利用されることです。つまり、ライブラリ関数が呼び出された場合、そのコードは呼び出したコントラクトのコンテキストで実行され、すなわち ``this`` は呼び出したコントラクトを指し、特に呼び出したコントラクトのストレージにアクセスできます。ライブラリは独立したソースコードの一部なので、呼び出し元のコントラクトの状態変数が明示的に提供されている場合にのみアクセスできます（そうでない場合は名前を付ける方法がありません）。ライブラリはステートレスであると想定されているため、ライブラリ関数は、ステートを変更しない場合（ ``view`` または ``pure`` 関数の場合）にのみ、直接（つまり ``DELEGATECALL`` を使用せずに）呼び出すことができます。特に、ライブラリを破壊できません。

.. .. note::

..     Until version 0.4.20, it was possible to destroy libraries by
..     circumventing Solidity's type system. Starting from that version,
..     libraries contain a :ref:`mechanism<call-protection>` that
..     disallows state-modifying functions
..     to be called directly (i.e. without ``DELEGATECALL``).

.. note::

<<<<<<< HEAD
    バージョン0.4.20までは、Solidityの型システムを回避してライブラリを破壊できました。このバージョンから、ライブラリには状態を変更する関数を直接（つまり ``DELEGATECALL`` なしで）呼び出すことを禁止する :ref:`mechanism<call-protection>` が含まれるようになりました。

.. Libraries can be seen as implicit base contracts of the contracts that use them.
.. They will not be explicitly visible in the inheritance hierarchy, but calls
.. to library functions look just like calls to functions of explicit base
.. contracts (using qualified access like ``L.f()``).
.. Of course, calls to internal functions
.. use the internal calling convention, which means that all internal types
.. can be passed and types :ref:`stored in memory <data-location>` will be passed by reference and not copied.
.. To realize this in the EVM, code of internal library functions
.. and all functions called from therein will at compile time be included in the calling
.. contract, and a regular ``JUMP`` call will be used instead of a ``DELEGATECALL``.

ライブラリは、それを使用するコントラクトの暗黙のベースコントラクトと見なすことができます。継承階層では明示的には見えませんが、ライブラリ関数への呼び出しは、明示的なベースコントラクトの関数への呼び出しと同じように見えます（ ``L.f()`` のような修飾されたアクセスを使用）。もちろん、内部関数への呼び出しは内部呼び出し規約を使用します。つまり、すべての内部型を渡すことができ、 :ref:`stored in memory <data-location>` 型は参照によって渡され、コピーされません。EVMでこれを実現するために、内部ライブラリ関数のコードとそこから呼び出されるすべての関数は、コンパイル時に呼び出しコントラクトに含まれ、 ``DELEGATECALL`` の代わりに通常の ``JUMP`` 呼び出しが使用されます。

.. .. note::

..     The inheritance analogy breaks down when it comes to public functions.
..     Calling a public library function with ``L.f()`` results in an external call (``DELEGATECALL``
..     to be precise).
..     In contrast, ``A.f()`` is an internal call when ``A`` is a base contract of the current contract.
=======
Libraries can be seen as implicit base contracts of the contracts that use them.
They will not be explicitly visible in the inheritance hierarchy, but calls
to library functions look just like calls to functions of explicit base
contracts (using qualified access like ``L.f()``).
Of course, calls to internal functions
use the internal calling convention, which means that all internal types
can be passed and types :ref:`stored in memory <data-location>` will be passed by reference and not copied.
To realize this in the EVM, the code of internal library functions
that are called from a contract
and all functions called from therein will at compile time be included in the calling
contract, and a regular ``JUMP`` call will be used instead of a ``DELEGATECALL``.
>>>>>>> d5a78b18b3fd9e54b2839e9685127c6cdbddf614

.. note::

    継承のアナロジーは、パブリック関数になると破綻します。     パブリックライブラリ関数を ``L.f()`` で呼び出すと、外部呼び出しになります（正確には ``DELEGATECALL`` ）。     対して ``A.f()`` は、 ``A`` が現在のコントラクトのベースコントラクトである場合、内部呼び出しとなります。

.. index:: using for, set

.. The following example illustrates how to use libraries (but using a manual method,
.. be sure to check out :ref:`using for <using-for>` for a
.. more advanced example to implement a set).

次の例では、ライブラリを使用する方法を説明しています（ただし、手動の方法を使用しています。セットを実装するためのより高度な例については、必ず :ref:`using for <using-for>` を参照してください）。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    // We define a new struct datatype that will be used to
    // hold its data in the calling contract.
    struct Data {
        mapping(uint => bool) flags;
    }

    library Set {
        // Note that the first parameter is of type "storage
        // reference" and thus only its storage address and not
        // its contents is passed as part of the call.  This is a
        // special feature of library functions.  It is idiomatic
        // to call the first parameter `self`, if the function can
        // be seen as a method of that object.
        function insert(Data storage self, uint value)
            public
            returns (bool)
        {
            if (self.flags[value])
                return false; // already there
            self.flags[value] = true;
            return true;
        }

        function remove(Data storage self, uint value)
            public
            returns (bool)
        {
            if (!self.flags[value])
                return false; // not there
            self.flags[value] = false;
            return true;
        }

        function contains(Data storage self, uint value)
            public
            view
            returns (bool)
        {
            return self.flags[value];
        }
    }

    contract C {
        Data knownValues;

        function register(uint value) public {
            // The library functions can be called without a
            // specific instance of the library, since the
            // "instance" will be the current contract.
            require(Set.insert(knownValues, value));
        }
        // In this contract, we can also directly access knownValues.flags, if we want.
    }

.. Of course, you do not have to follow this way to use
.. libraries: they can also be used without defining struct
.. data types. Functions also work without any storage
.. reference parameters, and they can have multiple storage reference
.. parameters and in any position.

もちろん、このような方法でライブラリを使用する必要はありません。構造体のデータ型を定義せずにライブラリを使用することもできます。また、関数は記憶参照パラメータなしで動作し、複数の記憶参照パラメータを任意の位置に持つことができます。

.. The calls to ``Set.contains``, ``Set.insert`` and ``Set.remove``
.. are all compiled as calls (``DELEGATECALL``) to an external
.. contract/library. If you use libraries, be aware that an
.. actual external function call is performed.
.. ``msg.sender``, ``msg.value`` and ``this`` will retain their values
.. in this call, though (prior to Homestead, because of the use of ``CALLCODE``, ``msg.sender`` and
.. ``msg.value`` changed, though).

``Set.contains`` 、 ``Set.insert`` 、 ``Set.remove`` の呼び出しは、すべて外部のコントラクト／ライブラリへの呼び出し（ ``DELEGATECALL`` ）としてコンパイルされています。ライブラリを使用している場合は、実際の外部関数の呼び出しが行われることに注意してください。 ``msg.sender`` 、 ``msg.value`` 、 ``this`` は、この呼び出しでも値が保持されますが（ホームステッド以前は、 ``CALLCODE`` を使用していたため、 ``msg.sender`` と ``msg.value`` は変化していましたが）。

.. The following example shows how to use :ref:`types stored in memory <data-location>` and
.. internal functions in libraries in order to implement
.. custom types without the overhead of external function calls:

次の例は、外部関数呼び出しのオーバーヘッドなしにカスタムタイプを実装するために、 :ref:`types stored in memory <data-location>` とライブラリの内部関数を使用する方法を示しています。

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.0;

    struct bigint {
        uint[] limbs;
    }

    library BigInt {
        function fromUint(uint x) internal pure returns (bigint memory r) {
            r.limbs = new uint[](1);
            r.limbs[0] = x;
        }

        function add(bigint memory a, bigint memory b) internal pure returns (bigint memory r) {
            r.limbs = new uint[](max(a.limbs.length, b.limbs.length));
            uint carry = 0;
            for (uint i = 0; i < r.limbs.length; ++i) {
                uint limbA = limb(a, i);
                uint limbB = limb(b, i);
                unchecked {
                    r.limbs[i] = limbA + limbB + carry;

                    if (limbA + limbB < limbA || (limbA + limbB == type(uint).max && carry > 0))
                        carry = 1;
                    else
                        carry = 0;
                }
            }
            if (carry > 0) {
                // too bad, we have to add a limb
                uint[] memory newLimbs = new uint[](r.limbs.length + 1);
                uint i;
                for (i = 0; i < r.limbs.length; ++i)
                    newLimbs[i] = r.limbs[i];
                newLimbs[i] = carry;
                r.limbs = newLimbs;
            }
        }

        function limb(bigint memory a, uint index) internal pure returns (uint) {
            return index < a.limbs.length ? a.limbs[index] : 0;
        }

        function max(uint a, uint b) private pure returns (uint) {
            return a > b ? a : b;
        }
    }

    contract C {
        using BigInt for bigint;

        function f() public pure {
            bigint memory x = BigInt.fromUint(7);
            bigint memory y = BigInt.fromUint(type(uint).max);
            bigint memory z = x.add(y);
            assert(z.limb(1) > 0);
        }
    }

.. It is possible to obtain the address of a library by converting
.. the library type to the ``address`` type, i.e. using ``address(LibraryName)``.

ライブラリタイプを ``address`` タイプに変換して、つまり ``address(LibraryName)`` を使ってライブラリのアドレスを取得することが可能です。

.. As the compiler does not know the address where the library will be deployed, the compiled hex code
.. will contain placeholders of the form ``__$30bbc0abd4d6364515865950d3e0d10953$__``. The placeholder
.. is a 34 character prefix of the hex encoding of the keccak256 hash of the fully qualified library
.. name, which would be for example ``libraries/bigint.sol:BigInt`` if the library was stored in a file
.. called ``bigint.sol`` in a ``libraries/`` directory. Such bytecode is incomplete and should not be
.. deployed. Placeholders need to be replaced with actual addresses. You can do that by either passing
.. them to the compiler when the library is being compiled or by using the linker to update an already
.. compiled binary. See :ref:`library-linking` for information on how to use the commandline compiler
.. for linking.

コンパイラは、ライブラリが配置されるアドレスを知らないため、コンパイルされた16進コードには ``__$30bbc0abd4d6364515865950d3e0d10953$__`` という形式のプレースホルダーが含まれます。このプレースホルダーは、完全修飾されたライブラリ名の keccak256 ハッシュの 16 進エンコーディングの 34 文字のプレフィックスであり、例えば、ライブラリが  ``libraries/``  ディレクトリの  ``bigint.sol``  というファイルに格納されている場合は  ``libraries/bigint.sol:BigInt``  となります。このようなバイトコードは不完全なので、デプロイしてはいけません。プレースホルダーを実際のアドレスに置き換える必要があります。これを行うには、ライブラリのコンパイル時にコンパイラに渡すか、リンカを使用して既にコンパイルされたバイナリを更新する必要があります。リンク用のコマンドライン・コンパイラの使用方法については、 :ref:`library-linking` を参照してください。

.. In comparison to contracts, libraries are restricted in the following ways:

コントラクトと比較して、ライブラリには以下のような制限があります。

.. - they cannot have state variables

- 状態変数を持つことはできません。

.. - they cannot inherit nor be inherited

- 継承することも継承されることもできない

.. - they cannot receive Ether

- を受信できません。

.. - they cannot be destroyed

- 壊すことができない

.. (These might be lifted at a later point.)

(これらは後の段階で解除されるかもしれません）。

.. _library-selectors:
.. index:: ! selector; of a library function

Function Signatures and Selectors in Libraries
==============================================

.. While external calls to public or external library functions are possible, the calling convention for such calls
.. is considered to be internal to Solidity and not the same as specified for the regular :ref:`contract ABI<ABI>`.
.. External library functions support more argument types than external contract functions, for example recursive structs
.. and storage pointers. For that reason, the function signatures used to compute the 4-byte selector are computed
.. following an internal naming schema and arguments of types not supported in the contract ABI use an internal encoding.

パブリック・ライブラリ関数や外部ライブラリ関数の外部呼び出しは可能ですが、そのような呼び出しのための呼び出し規約はSolidity内部のものとみなされ、通常の :ref:`contract ABI<ABI>` に指定されているものとは異なります。外部ライブラリ関数は、再帰的構造体やストレージ・ポインタなど、外部コントラクト関数よりも多くの引数タイプをサポートしています。そのため、4バイトセレクタの計算に使用される関数シグネチャは、内部のネーミングスキーマに従って計算され、コントラクトABIでサポートされていない型の引数は、内部のエンコーディングを使用します。

.. The following identifiers are used for the types in the signatures:

シグネチャーのタイプには、以下の識別子が使われています。

.. - Value types, non-storage ``string`` and non-storage ``bytes`` use the same identifiers as in the contract ABI.

- 値型、非記憶型 ``string`` 、非記憶型 ``bytes`` はコントラクトABIと同じ識別子を使用しています。

.. - Non-storage array types follow the same convention as in the contract ABI, i.e. ``<type>[]`` for dynamic arrays and
..   ``<type>[M]`` for fixed-size arrays of ``M`` elements.

- 非蓄積型の配列タイプはコントラクトABIと同じ規則に従っています。すなわち、動的配列は ``<type>[]`` 、 ``M`` 要素の固定サイズ配列は ``<type>[M]`` です。

.. - Non-storage structs are referred to by their fully qualified name, i.e. ``C.S`` for ``contract C { struct S { ... } }``.

- ストレージを持たない構造体は、完全修飾名で参照されます。

.. - Storage pointer mappings use ``mapping(<keyType> => <valueType>) storage`` where ``<keyType>`` and ``<valueType>`` are
..   the identifiers for the key and value types of the mapping, respectively.

- ストレージポインターマッピングでは、 ``<keyType>`` と ``<valueType>`` がそれぞれマッピングのキータイプとバリュータイプの識別子である ``mapping(<keyType> => <valueType>) storage`` を使用します。

.. - Other storage pointer types use the type identifier of their corresponding non-storage type, but append a single space
..   followed by ``storage`` to it.

- 他のストレージポインタタイプは、対応する非ストレージタイプのタイプ識別子を使用しますが、それに1つのスペースとそれに続く ``storage`` が追加されます。

.. The argument encoding is the same as for the regular contract ABI, except for storage pointers, which are encoded as a
.. ``uint256`` value referring to the storage slot to which they point.

引数のエンコーディングは、通常のコントラクトABIと同じです。ただし、ストレージ・ポインタは、それが指し示すストレージ・スロットを参照する ``uint256`` 値としてエンコーディングされます。

.. Similarly to the contract ABI, the selector consists of the first four bytes of the Keccak256-hash of the signature.
.. Its value can be obtained from Solidity using the ``.selector`` member as follows:

コントラクトABIと同様に、セレクタは署名のKeccak256ハッシュの最初の4バイトで構成されています。その値は、 ``.selector`` メンバーを使ってSolidityから以下のように取得できる。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.5.14 <0.9.0;

    library L {
        function f(uint256) external {}
    }

    contract C {
        function g() public pure returns (bytes4) {
            return L.f.selector;
        }
    }

.. _call-protection:

Call Protection For Libraries
=============================

.. As mentioned in the introduction, if a library's code is executed
.. using a ``CALL`` instead of a ``DELEGATECALL`` or ``CALLCODE``,
.. it will revert unless a ``view`` or ``pure`` function is called.

冒頭で述べたように、 ``DELEGATECALL`` や ``CALLCODE`` ではなく ``CALL`` を使ってライブラリのコードを実行すると、 ``view`` や ``pure`` の関数が呼ばれない限り元に戻ります。

.. The EVM does not provide a direct way for a contract to detect
.. whether it was called using ``CALL`` or not, but a contract
.. can use the ``ADDRESS`` opcode to find out "where" it is
.. currently running. The generated code compares this address
.. to the address used at construction time to determine the mode
.. of calling.

EVMは、コントラクトが ``CALL`` を使用して呼び出されたかどうかを検出する直接的な方法を提供していませんが、コントラクトは ``ADDRESS``  opcodeを使用して、現在「どこで」実行されているかを調べることができます。生成されたコードは、このアドレスをコンストラクション時に使用されたアドレスと比較して、呼び出しのモードを決定します。

.. More specifically, the runtime code of a library always starts
.. with a push instruction, which is a zero of 20 bytes at
.. compilation time. When the deploy code runs, this constant
.. is replaced in memory by the current address and this
.. modified code is stored in the contract. At runtime,
.. this causes the deploy time address to be the first
.. constant to be pushed onto the stack and the dispatcher
.. code compares the current address against this constant
.. for any non-view and non-pure function.

具体的には、ライブラリのランタイムコードは常にプッシュ命令で始まり、コンパイル時には20バイトのゼロになっています。デプロイコードが実行されると、この定数がメモリ上で現在のアドレスに置き換えられ、この変更されたコードがコントラクトに格納されます。実行時には、これによりデプロイ時のアドレスがスタックにプッシュされる最初の定数となり、ディスパッチャコードは、ビューではない、ピュアではない関数の場合、現アドレスとこの定数を比較します。

.. This means that the actual code stored on chain for a library
.. is different from the code reported by the compiler as
.. ``deployedBytecode``.
.. 

つまり、ライブラリのためにチェーンに保存された実際のコードは、コンパイラが ``deployedBytecode`` として報告したコードとは異なるということです。
