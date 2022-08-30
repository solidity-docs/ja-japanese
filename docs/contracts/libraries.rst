.. index:: ! library, callcode, delegatecall

.. _libraries:

*************
ライブラリ
*************

ライブラリはコントラクトに似ていますが、その目的は、特定のアドレスに一度だけデプロイされ、そのコードはEVMの ``DELEGATECALL`` （Homesteadまでの ``CALLCODE`` ）機能を使って再利用されることです。
ライブラリ関数が呼び出された場合、そのコードは呼び出したコントラクトのコンテキストで実行されます。
つまり ``this`` は呼び出したコントラクトを指し、呼び出したコントラクトのストレージにアクセスできます。
ライブラリは独立したソースコードの一部なので、呼び出し元のコントラクトの状態変数が明示的に提供されている場合にのみアクセスできます（そうでない場合は名前を付ける方法がありません）。
ライブラリはステートレスであると想定されているため、ライブラリ関数は、ステートを変更しない場合（ ``view`` または ``pure`` 関数の場合）にのみ、直接（つまり ``DELEGATECALL`` を使用せずに）呼び出すことができます。
ライブラリを破壊することはできません。

.. note::

    バージョン0.4.20までは、Solidityの型システムを回避してライブラリを破壊できました。
    このバージョンから、ライブラリには状態を変更する関数を直接（つまり ``DELEGATECALL`` なしで）呼び出すことを禁止する :ref:`メカニズム<call-protection>` が含まれるようになりました。

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

ライブラリは、それを使用するコントラクトの暗黙のベースコントラクトと見なすことができます。
継承階層では明示的には見えませんが、ライブラリ関数への呼び出しは、明示的なベースコントラクトの関数への呼び出しと同じように見えます（ ``L.f()`` のような修飾されたアクセスを使用）。
もちろん、内部関数への呼び出しは内部呼び出し規約を使用します。
つまり、すべての内部型を渡すことができ、 :ref:`メモリに保存された <data-location>` 型は参照によって渡され、コピーされません。
EVMでこれを実現するために、内部ライブラリ関数のコードとそこから呼び出されるすべての関数は、コンパイル時に呼び出しコントラクトに含まれ、 ``DELEGATECALL`` の代わりに通常の ``JUMP`` 呼び出しが使用されます。

.. .. note::

..     The inheritance analogy breaks down when it comes to public functions.
..     Calling a public library function with ``L.f()`` results in an external call (``DELEGATECALL``
..     to be precise).
..     In contrast, ``A.f()`` is an internal call when ``A`` is a base contract of the current contract.

.. note::

    継承のアナロジーは、パブリック関数になると破綻します。
    パブリックライブラリ関数を ``L.f()`` で呼び出すと、外部呼び出しになります（正確には ``DELEGATECALL`` ）。
    対して ``A.f()`` は、 ``A`` が現在のコントラクトのベースコントラクトである場合、内部呼び出しとなります。

.. index:: using for, set

.. The following example illustrates how to use libraries (but using a manual method,
.. be sure to check out :ref:`using for <using-for>` for a
.. more advanced example to implement a set).

次の例では、ライブラリを使用する方法を説明しています（ただし、手動の方法を使用しています。集合を実装するためのより高度な例については、必ず :ref:`using for <using-for>` を参照してください）。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    // 呼び出し側のコントラクトでそのデータを保持するために使用される新しい構造体のデータ型を定義します。
    struct Data {
        mapping(uint => bool) flags;
    }

    library Set {
        // 最初のパラメータは「ストレージ参照」型であるため、呼び出しの一部として、そのストレージアドレスのみが渡され、その内容は渡されないことに注意してください。 
        // これはライブラリ関数の特別な機能です。
        // もし関数がそのオブジェクトのメソッドとみなすことができるならば、最初のパラメータを `self` と呼ぶのが慣例となっています。
        function insert(Data storage self, uint value)
            public
            returns (bool)
        {
            if (self.flags[value])
                return false; // 既に存在する
            self.flags[value] = true;
            return true;
        }

        function remove(Data storage self, uint value)
            public
            returns (bool)
        {
            if (!self.flags[value])
                return false; // 存在しない
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
            // 「インスタンス」は現在のコントラクトになるため、ライブラリの関数は特定のインスタンスなしで呼び出すことができます。
            require(Set.insert(knownValues, value));
        }
        // このコントラクトでは、必要であれば、knownValues.flagsに直接アクセスすることもできます。
    }

.. Functions also work without any storage
.. reference parameters, and they can have multiple storage reference
.. parameters and in any position.

もちろん、このような方法でライブラリを使用する必要はありません。
構造体のデータ型を定義せずにライブラリを使用することもできます。
また、関数はストレージの参照パラメータなしで動作し、複数のストレージの参照パラメータを任意の位置に持つことができます。

.. The calls to ``Set.contains``, ``Set.insert`` and ``Set.remove``
.. are all compiled as calls (``DELEGATECALL``) to an external
.. contract/library. If you use libraries, be aware that an
.. actual external function call is performed.
.. ``msg.sender``, ``msg.value`` and ``this`` will retain their values
.. in this call, though (prior to Homestead, because of the use of ``CALLCODE``, ``msg.sender`` and
.. ``msg.value`` changed, though).

``Set.contains`` 、 ``Set.insert`` 、 ``Set.remove`` の呼び出しは、すべて外部のコントラクト／ライブラリへの呼び出し（ ``DELEGATECALL`` ）としてコンパイルされています。
ライブラリを使用している場合は、実際の外部関数の呼び出しが行われることに注意してください。 ``msg.sender`` 、 ``msg.value`` 、 ``this`` は、この呼び出しでも値が保持されますが（ホームステッド以前は、 ``CALLCODE`` を使用していたため、 ``msg.sender`` と ``msg.value`` は変化していましたが）。

.. The following example shows how to use :ref:`types stored in memory <data-location>` and
.. internal functions in libraries in order to implement
.. custom types without the overhead of external function calls:

次の例は、外部関数呼び出しのオーバーヘッドなしにカスタム型を実装するために、 :ref:`メモリに保存された型 <data-location>` とライブラリの内部関数を使用する方法を示しています。

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

        function add(bigint memory _a, bigint memory _b) internal pure returns (bigint memory r) {
            r.limbs = new uint[](max(_a.limbs.length, _b.limbs.length));
            uint carry = 0;
            for (uint i = 0; i < r.limbs.length; ++i) {
                uint a = limb(_a, i);
                uint b = limb(_b, i);
                unchecked {
                    r.limbs[i] = a + b + carry;

                    if (a + b < a || (a + b == type(uint).max && carry > 0))
                        carry = 1;
                    else
                        carry = 0;
                }
            }
            if (carry > 0) {
                // 残念、limbを追加しなくてはいけません
                uint[] memory newLimbs = new uint[](r.limbs.length + 1);
                uint i;
                for (i = 0; i < r.limbs.length; ++i)
                    newLimbs[i] = r.limbs[i];
                newLimbs[i] = carry;
                r.limbs = newLimbs;
            }
        }

        function limb(bigint memory _a, uint _limb) internal pure returns (uint) {
            return _limb < _a.limbs.length ? _a.limbs[_limb] : 0;
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

ライブラリ型を ``address`` 型に変換して、つまり ``address(LibraryName)`` を使ってライブラリのアドレスを取得することが可能です。

.. As the compiler does not know the address where the library will be deployed, the compiled hex code
.. will contain placeholders of the form ``__$30bbc0abd4d6364515865950d3e0d10953$__``. The placeholder
.. is a 34 character prefix of the hex encoding of the keccak256 hash of the fully qualified library
.. name, which would be for example ``libraries/bigint.sol:BigInt`` if the library was stored in a file
.. called ``bigint.sol`` in a ``libraries/`` directory. Such bytecode is incomplete and should not be
.. deployed. Placeholders need to be replaced with actual addresses. You can do that by either passing
.. them to the compiler when the library is being compiled or by using the linker to update an already
.. compiled binary. See :ref:`library-linking` for information on how to use the commandline compiler
.. for linking.

コンパイラは、ライブラリが配置されるアドレスを知らないため、コンパイルされた16進コードには ``__$30bbc0abd4d6364515865950d3e0d10953$__`` という形式のプレースホルダーが含まれます。
このプレースホルダーは、完全修飾されたライブラリ名のkeccak256ハッシュの16進エンコーディングの34文字のプレフィックスであり、例えば、ライブラリが ``libraries/`` ディレクトリの ``bigint.sol`` というファイルに格納されている場合は ``libraries/bigint.sol:BigInt`` となります。
このようなバイトコードは不完全なので、デプロイしてはいけません。
プレースホルダーを実際のアドレスに置き換える必要があります。
これを行うには、ライブラリのコンパイル時にコンパイラに渡すか、リンカを使用して既にコンパイルされたバイナリを更新する必要があります。
リンク用のコマンドラインコンパイラの使用方法については、 :ref:`library-linking` を参照してください。

コントラクトと比較して、ライブラリには以下のような制限があります。

- 状態変数を持つことはできません。

- 継承することも継承されることもできません。

- Etherを受け取れません。

- 壊すことができません。

（これらは後の段階で解除されるかもしれません）

.. _library-selectors:
.. index:: selector

ライブラリの関数シグネチャと関数セレクター
===============================================

.. While external calls to public or external library functions are possible, the calling convention for such calls
.. is considered to be internal to Solidity and not the same as specified for the regular :ref:`contract ABI<ABI>`.
.. External library functions support more argument types than external contract functions, for example recursive structs
.. and storage pointers. For that reason, the function signatures used to compute the 4-byte selector are computed
.. following an internal naming schema and arguments of types not supported in the contract ABI use an internal encoding.

パブリックライブラリ関数や外部ライブラリ関数の外部呼び出しは可能ですが、そのような呼び出しのための呼び出し規約はSolidity内部のものとみなされ、通常の :ref:`コントラクトABI<ABI>` に指定されているものとは異なります。
外部ライブラリ関数は、再帰的構造体やストレージポインタなど、外部コントラクト関数よりも多くの引数型をサポートしています。
そのため、4バイトセレクタの計算に使用される関数シグネチャは、内部のネーミングスキーマに従って計算され、コントラクトABIでサポートされていない型の引数は、内部のエンコーディングを使用します。

シグネチャの型には、以下の識別子が使われています。

.. - Value types, non-storage ``string`` and non-storage ``bytes`` use the same identifiers as in the contract ABI.
.. - Non-storage array types follow the same convention as in the contract ABI, i.e. ``<type>[]`` for dynamic arrays and
..   ``<type>[M]`` for fixed-size arrays of ``M`` elements.
.. - Non-storage structs are referred to by their fully qualified name, i.e. ``C.S`` for ``contract C { struct S { ... } }``.
.. - Storage pointer mappings use ``mapping(<keyType> => <valueType>) storage`` where ``<keyType>`` and ``<valueType>`` are
..   the identifiers for the key and value types of the mapping, respectively.
.. - Other storage pointer types use the type identifier of their corresponding non-storage type, but append a single space
..   followed by ``storage`` to it.

- 値型、非ストレージ ``string`` 、非ストレージ ``bytes`` はコントラクトABIと同じ識別子を使用しています。

- 非ストレージ型の配列型はコントラクトABIと同じ規則に従っています。すなわち、動的配列は ``<type>[]`` 、 ``M`` 要素の固定サイズ配列は ``<type>[M]`` です。

- ストレージを持たない構造体は、完全修飾名で参照されます。

- ストレージポインターマッピングでは、 ``<keyType>`` と ``<valueType>`` がそれぞれマッピングのキー型とバリュー型の識別子である ``mapping(<keyType> => <valueType>) storage`` を使用します。

- 他のストレージポインタ型は、対応する非ストレージ型の型識別子を使用しますが、それに1つのスペースとそれに続く ``storage`` が追加されます。

.. The argument encoding is the same as for the regular contract ABI, except for storage pointers, which are encoded as a
.. ``uint256`` value referring to the storage slot to which they point.

引数のエンコーディングは、通常のコントラクトABIと同じです。
ただし、ストレージポインタは、それが指し示すストレージスロットを参照する ``uint256`` 値としてエンコーディングされます。

.. Similarly to the contract ABI, the selector consists of the first four bytes of the Keccak256-hash of the signature.
.. Its value can be obtained from Solidity using the ``.selector`` member as follows:

コントラクトABIと同様に、セレクタは署名のKeccak256ハッシュの最初の4バイトで構成されています。
その値は、 ``.selector`` メンバーを使ってSolidityから以下のように取得できます。

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

ライブラリのためのコールプロテクション
=======================================

.. As mentioned in the introduction, if a library's code is executed
.. using a ``CALL`` instead of a ``DELEGATECALL`` or ``CALLCODE``,
.. it will revert unless a ``view`` or ``pure`` function is called.

冒頭で述べたように、 ``DELEGATECALL`` や ``CALLCODE`` ではなく ``CALL`` を使ってライブラリのコードを実行すると、 ``view`` や ``pure`` の関数が呼ばれない限りリバートします。

.. The EVM does not provide a direct way for a contract to detect
.. whether it was called using ``CALL`` or not, but a contract
.. can use the ``ADDRESS`` opcode to find out "where" it is
.. currently running. The generated code compares this address
.. to the address used at construction time to determine the mode
.. of calling.

EVMは、コントラクトが ``CALL`` を使用して呼び出されたかどうかを検出する直接的な方法を提供していませんが、コントラクトは ``ADDRESS`` オペコードを使用して、現在「どこで」実行されているかを調べることができます。
生成されたコードは、このアドレスをコンストラクション時に使用されたアドレスと比較して、呼び出しのモードを決定します。

.. More specifically, the runtime code of a library always starts
.. with a push instruction, which is a zero of 20 bytes at
.. compilation time. When the deploy code runs, this constant
.. is replaced in memory by the current address and this
.. modified code is stored in the contract. At runtime,
.. this causes the deploy time address to be the first
.. constant to be pushed onto the stack and the dispatcher
.. code compares the current address against this constant
.. for any non-view and non-pure function.

具体的には、ライブラリのランタイムコードは常にプッシュ命令で始まり、コンパイル時には20バイトのゼロになっています。
デプロイコードが実行されると、この定数がメモリ上で現在のアドレスに置き換えられ、この変更されたコードがコントラクトに格納されます。
実行時には、これによりデプロイ時のアドレスがスタックにプッシュされる最初の定数となり、ディスパッチャコードは、ビューではない、ピュアではない関数の場合、現アドレスとこの定数を比較します。

.. This means that the actual code stored on chain for a library
.. is different from the code reported by the compiler as
.. ``deployedBytecode``.
.. 

つまり、ライブラリのためにチェーンに保存された実際のコードは、コンパイラが ``deployedBytecode`` として報告したコードとは異なるということです。
