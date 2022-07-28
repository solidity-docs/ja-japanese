
.. index: ir breaking changes

.. _ir-breaking-changes:

*********************************
Solidity IR-based Codegen Changes
*********************************

.. Solidity can generate EVM bytecode in two different ways:
.. Either directly from Solidity to EVM opcodes ("old codegen") or through
.. an intermediate representation ("IR") in Yul ("new codegen" or "IR-based codegen").

Solidityは、2つの異なる方法でEVMバイトコードを生成できます。Solidityから直接EVMのオペコードを生成する方法（"old codegen"）と、Yulの中間表現（"IR"）を介して生成する方法（"new codegen "または "IR-based codegen"）です。

<<<<<<< HEAD
.. The IR-based code generator was introduced with an aim to not only allow
.. code generation to be more transparent and auditable but also
.. to enable more powerful optimization passes that span across functions.

IRベースのコードジェネレーターを導入したのは、コード生成の透明性や監査性を高めるだけでなく、関数をまたいだより強力な最適化パスを可能にすることを目的としています。
=======
You can enable it on the command line using ``--via-ir``
or with the option ``{"viaIR": true}`` in standard-json and we
encourage everyone to try it out!
>>>>>>> 72f1907298f8bd55cd22d16ebb8975de910ba4d3

.. Currently, the IR-based code generator is still marked experimental,
.. but it supports all language features and has received a lot of testing,
.. so we consider it almost ready for production use.

現在、IRベースのコードジェネレータはまだ実験的とされていますが、すべての言語機能をサポートしており、多くのテストを受けているため、製品としての使用はほぼ可能だと考えています。

.. You can enable it on the command line using ``--experimental-via-ir``
.. or with the option ``{"viaIR": true}`` in standard-json and we
.. encourage everyone to try it out!

コマンドラインで ``--experimental-via-ir`` を使って有効にしたり、standard-jsonで ``{"viaIR": true}`` オプションを使って有効にできますので、ぜひ皆さんに試していただきたいと思います。

.. For several reasons, there are tiny semantic differences between the old
.. and the IR-based code generator, mostly in areas where we would not
.. expect people to rely on this behaviour anyway.
.. This section highlights the main differences between the old and the IR-based codegen.

いくつかの理由により、従来のコードジェネレーターとIRベースのコードジェネレーターの間にはわずかな意味上の違いがありますが、そのほとんどは、いずれにしても人々がこの動作に頼ることはないだろうと思われる領域です。このセクションでは、旧来のコードジェネレーターとIRベースのコードジェネレーターの主な違いを紹介します。

Semantic Only Changes
=====================

.. This section lists the changes that are semantic-only, thus potentially
.. hiding new and different behavior in existing code.

<<<<<<< HEAD
このセクションでは、セマンティックのみの変更点をリストアップしています。そのため、既存のコードの中に新しい、あるいは異なる動作が隠されている可能性があります。

.. - When storage structs are deleted, every storage slot that contains
..   a member of the struct is set to zero entirely. Formerly, padding space
..   was left untouched.
..   Consequently, if the padding space within a struct is used to store data
..   (e.g. in the context of a contract upgrade), you have to be aware that
..   ``delete`` will now also clear the added member (while it wouldn't
..   have been cleared in the past).
=======
- The order of state variable initialization has changed in case of inheritance.

  The order used to be:

  - All state variables are zero-initialized at the beginning.
  - Evaluate base constructor arguments from most derived to most base contract.
  - Initialize all state variables in the whole inheritance hierarchy from most base to most derived.
  - Run the constructor, if present, for all contracts in the linearized hierarchy from most base to most derived.

  New order:

  - All state variables are zero-initialized at the beginning.
  - Evaluate base constructor arguments from most derived to most base contract.
  - For every contract in order from most base to most derived in the linearized hierarchy:

      1. Initialize state variables.
      2. Run the constructor (if present).

  This causes differences in contracts where the initial value of a state
  variable relies on the result of the constructor in another contract:

  .. code-block:: solidity

      // SPDX-License-Identifier: GPL-3.0
      pragma solidity >=0.7.1;

      contract A {
          uint x;
          constructor() {
              x = 42;
          }
          function f() public view returns(uint256) {
              return x;
          }
      }
      contract B is A {
          uint public y = f();
      }

  Previously, ``y`` would be set to 0. This is due to the fact that we would first initialize state variables: First, ``x`` is set to 0, and when initializing ``y``, ``f()`` would return 0 causing ``y`` to be 0 as well.
  With the new rules, ``y`` will be set to 42. We first initialize ``x`` to 0, then call A's constructor which sets ``x`` to 42. Finally, when initializing ``y``, ``f()`` returns 42 causing ``y`` to be 42.

- When storage structs are deleted, every storage slot that contains
  a member of the struct is set to zero entirely. Formerly, padding space
  was left untouched.
  Consequently, if the padding space within a struct is used to store data
  (e.g. in the context of a contract upgrade), you have to be aware that
  ``delete`` will now also clear the added member (while it wouldn't
  have been cleared in the past).
>>>>>>> 72f1907298f8bd55cd22d16ebb8975de910ba4d3

  .. code-block:: solidity

      // SPDX-License-Identifier: GPL-3.0
      pragma solidity >=0.7.1;

      contract C {
          struct S {
              uint64 y;
              uint64 z;
          }
          S s;
          function f() public {
              // ...
              delete s;
              // s occupies only first 16 bytes of the 32 bytes slot
              // delete will write zero to the full slot
          }
      }

  We have the same behavior for implicit delete, for example when array of structs is shortened.

.. - Function modifiers are implemented in a slightly different way regarding function parameters and return variables.
..   This especially has an effect if the placeholder ``_;`` is evaluated multiple times in a modifier.
..   In the old code generator, each function parameter and return variable has a fixed slot on the stack.
..   If the function is run multiple times because ``_;`` is used multiple times or used in a loop, then a
..   change to the function parameter's or return variable's value is visible in the next execution of the function.
..   The new code generator implements modifiers using actual functions and passes function parameters on.
..   This means that multiple evaluations of a function's body will get the same values for the parameters,
..   and the effect on return variables is that they are reset to their default (zero) value for each
..   execution.

  .. code-block:: solidity

      // SPDX-License-Identifier: GPL-3.0
      pragma solidity >=0.7.0;
      contract C {
          function f(uint a) public pure mod() returns (uint r) {
              r = a++;
          }
          modifier mod() { _; _; }
      }

  If you execute ``f(0)`` in the old code generator, it will return ``2``, while
  it will return ``1`` when using the new code generator.

  .. code-block:: solidity

      // SPDX-License-Identifier: GPL-3.0
      pragma solidity >=0.7.1 <0.9.0;

      contract C {
          bool active = true;
          modifier mod()
          {
              _;
              active = false;
              _;
          }
          function foo() external mod() returns (uint ret)
          {
              if (active)
                  ret = 1; // Same as ``return 1``
          }
      }

  The function ``C.foo()`` returns the following values:

  - Old code generator: ``1`` as the return variable is initialized to ``0`` only once before the first ``_;``
    evaluation and then overwritten by the ``return 1;``. It is not initialized again for the second ``_;``
    evaluation and ``foo()`` does not explicitly assign it either (due to ``active == false``), thus it keeps
    its first value.

  - New code generator: ``0`` as all parameters, including return parameters, will be re-initialized before
    each ``_;`` evaluation.

<<<<<<< HEAD
.. - The order of contract initialization has changed in case of inheritance.

..   The order used to be:

..   - All state variables are zero-initialized at the beginning.

..   - Evaluate base constructor arguments from most derived to most base contract.

..   - Initialize all state variables in the whole inheritance hierarchy from most base to most derived.

..   - Run the constructor, if present, for all contracts in the linearized hierarchy from most base to most derived.

..   New order:

..   - All state variables are zero-initialized at the beginning.

..   - Evaluate base constructor arguments from most derived to most base contract.

..   - For every contract in order from most base to most derived in the linearized hierarchy execute:

..       1. If present at declaration, initial values are assigned to state variables.

..       2. Constructor, if present.

- ストレージ構造体が削除されると、その構造体のメンバーを含むすべてのストレージスロットが完全にゼロになります。以前は、パディング・スペースはそのまま残されていました。   そのため、構造体内のパディング・スペースがデータの保存に使用されている場合（コントラクトのアップグレードなど）、 ``delete`` では追加されたメンバーもクリアされてしまうことに注意する必要があります（以前はクリアされませんでしたが）。

- 関数修飾子は、関数のパラメータと戻り値の変数に関して、若干異なる方法で実装されています。   これは特に、修飾子の中でプレースホルダー ``_;`` が複数回評価される場合に影響します。   古いコードジェネレータでは、各関数のパラメータとリターン変数は、スタック上に固定のスロットを持っています。    ``_;`` が複数回使用されたり、ループで使用されたりして、関数が複数回実行されると、関数のパラメータやリターン変数の値の変更が、関数の次の実行時に見えてしまいます。   新しいコードジェネレータでは、実際の関数を使って修飾子を実装し、関数パラメータを渡しています。   つまり、関数本体を複数回評価しても、パラメータには同じ値が得られ、リターン変数には、実行ごとにデフォルト（ゼロ）の値にリセットされるという効果があります。

- 継承の場合、コントラクトの初期化の順番が変わりました。

  以前は、このような順番でした。

  - すべての状態変数は最初からゼロ初期化されています。

  - ベースコンストラクタの引数を、最も派生したものから最もベースとなるものまで評価します。

  - 最上位の基底部から最上位の派生部までの全継承階層において、すべての状態変数を初期化します。

  - コンストラクタがある場合は、最も基本的なものから最も派生したものまで、線形化された階層のすべてのコントラクトに対して実行します。

  新規注文です。

  - すべての状態変数は最初からゼロ初期化されています。

  - ベースコンストラクタの引数を、最も派生したものから最もベースとなるものまで評価します。

  - 線形化された階層の中で、最も基本的なものから最も派生したものへと順に、すべてのコントラクトについて実行します。

      1. 宣言時に存在する場合、初期値が状態変数に割り当てられます。

      2. コンストラクタがある場合

.. This causes differences in some contracts, for example:

  .. code-block:: solidity

      // SPDX-License-Identifier: GPL-3.0
      pragma solidity >=0.7.1;

      contract A {
          uint x;
          constructor() {
              x = 42;
          }
          function f() public view returns(uint256) {
              return x;
          }
      }
      contract B is A {
          uint public y = f();
      }

  Previously, ``y`` would be set to 0. This is due to the fact that we would first initialize state variables: First, ``x`` is set to 0, and when initializing ``y``, ``f()`` would return 0 causing ``y`` to be 0 as well.
  With the new rules, ``y`` will be set to 42. We first initialize ``x`` to 0, then call A's constructor which sets ``x`` to 42. Finally, when initializing ``y``, ``f()`` returns 42 causing ``y`` to be 42.

.. - Copying ``bytes`` arrays from memory to storage is implemented in a different way.
..   The old code generator always copies full words, while the new one cuts the byte
..   array after its end. The old behaviour can lead to dirty data being copied after
..   the end of the array (but still in the same storage slot).
..   This causes differences in some contracts, for example:

  .. code-block:: solidity

      // SPDX-License-Identifier: GPL-3.0
      pragma solidity >=0.8.1;

      contract C {
          bytes x;
          function f() public returns (uint _r) {
              bytes memory m = "tmp";
              assembly {
                  mstore(m, 8)
                  mstore(add(m, 32), "deadbeef15dead")
              }
              x = m;
              assembly {
                  _r := sload(x.slot)
              }
          }
      }

  Previously ``f()`` would return ``0x6465616462656566313564656164000000000000000000000000000000000010``
  (it has correct length, and correct first 8 elements, but then it contains dirty data which was set via assembly).
  Now it is returning ``0x6465616462656566000000000000000000000000000000000000000000000010`` (it has
  correct length, and correct elements, but does not contain superfluous data).

=======
>>>>>>> 72f1907298f8bd55cd22d16ebb8975de910ba4d3
  .. index:: ! evaluation order; expression

.. - For the old code generator, the evaluation order of expressions is unspecified.
..   For the new code generator, we try to evaluate in source order (left to right), but do not guarantee it.
..   This can lead to semantic differences.

..   For example:

  .. code-block:: solidity

      // SPDX-License-Identifier: GPL-3.0
      pragma solidity >=0.8.1;
      contract C {
          function preincr_u8(uint8 a) public pure returns (uint8) {
              return ++a + a;
          }
      }

  The function ``preincr_u8(1)`` returns the following values:

  - Old code generator: 3 (``1 + 2``) but the return value is unspecified in general

  - New code generator: 4 (``2 + 2``) but the return value is not guaranteed

  .. index:: ! evaluation order; function arguments

  On the other hand, function argument expressions are evaluated in the same order
  by both code generators with the exception of the global functions ``addmod`` and ``mulmod``.
  For example:

  .. code-block:: solidity

      // SPDX-License-Identifier: GPL-3.0
      pragma solidity >=0.8.1;
      contract C {
          function add(uint8 a, uint8 b) public pure returns (uint8) {
              return a + b;
          }
          function g(uint8 a, uint8 b) public pure returns (uint8) {
              return add(++a + ++b, a + b);
          }
      }

  The function ``g(1, 2)`` returns the following values:

  - Old code generator: ``10`` (``add(2 + 3, 2 + 3)``) but the return value is unspecified in general

  - New code generator: ``10`` but the return value is not guaranteed

  The arguments to the global functions ``addmod`` and ``mulmod`` are evaluated right-to-left by the old code generator
  and left-to-right by the new code generator.
  For example:

  .. code-block:: solidity

      // SPDX-License-Identifier: GPL-3.0
      pragma solidity >=0.8.1;
      contract C {
          function f() public pure returns (uint256 aMod, uint256 mMod) {
              uint256 x = 3;
              // Old code gen: add/mulmod(5, 4, 3)
              // New code gen: add/mulmod(4, 5, 5)
              aMod = addmod(++x, ++x, x);
              mMod = mulmod(++x, ++x, x);
          }
      }

  The function ``f()`` returns the following values:

  - Old code generator: ``aMod = 0`` and ``mMod = 2``

  - New code generator: ``aMod = 4`` and ``mMod = 0``

.. - The new code generator imposes a hard limit of ``type(uint64).max``
..   (``0xffffffffffffffff``) for the free memory pointer. Allocations that would
..   increase its value beyond this limit revert. The old code generator does not
..   have this limit.

..   For example:

  .. code-block:: solidity
      :force:

      // SPDX-License-Identifier: GPL-3.0
      pragma solidity >0.8.0;
      contract C {
          function f() public {
              uint[] memory arr;
              // allocation size: 576460752303423481
              // assumes freeMemPtr points to 0x80 initially
              uint solYulMaxAllocationBeforeMemPtrOverflow = (type(uint64).max - 0x80 - 31) / 32;
              // freeMemPtr overflows UINT64_MAX
              arr = new uint[](solYulMaxAllocationBeforeMemPtrOverflow);
          }
      }

  The function `f()` behaves as follows:

  - Old code generator: runs out of gas while zeroing the array contents after the large memory allocation

  - New code generator: reverts due to free memory pointer overflow (does not run out of gas)

Internals
=========

Internal function pointers
--------------------------

.. index:: function pointers

.. The old code generator uses code offsets or tags for values of internal function pointers. This is especially complicated since
.. these offsets are different at construction time and after deployment and the values can cross this border via storage.
.. Because of that, both offsets are encoded at construction time into the same value (into different bytes).

これにより、例えば、一部のコントラクトに違いが生じます。

- メモリからストレージへの ``bytes`` 配列のコピーは、異なる方法で実装されています。   従来のコードジェネレータは常にワード全体をコピーしていましたが、新しいコードジェネレータではバイト配列の最後をカットしています。以前の動作では、ダーティなデータが配列の終わりの後（ただし、同じストレージスロット内）にコピーされることがありました。   これにより、例えばいくつかのコントラクトに違いが生じます。

- 旧コード・ジェネレータでは、式の評価順序は不定です。   新しいコード・ジェネレータでは、ソース・オーダー（左から右）で評価するようにしていますが、それを保証するものではありません。   このため、意味的な違いが生じることがあります。

  例えば、以下のように。

- 新しいコードジェネレータでは、フリーメモリポインタに ``type(uint64).max`` （ ``0xffffffffffffffff`` ）というハードリミットが設定されています。この制限を超えて値を増やすような割り当ては元に戻ります。古いコード・ジェネレータにはこの制限はありません。

  例えば、以下のように。

古いコードジェネレータでは、内部関数ポインタの値にコードオフセットやタグを使用しています。これらのオフセットはコンストラクション時とデプロイ後で異なり、値はストレージを介してこの境界を越えることができるため、特に複雑になっています。そのため、構築時には両方のオフセットを同じ値に（異なるバイトに）エンコードします。

.. In the new code generator, function pointers use internal IDs that are allocated in sequence. Since calls via jumps are not possible,
.. calls through function pointers always have to use an internal dispatch function that uses the ``switch`` statement to select
.. the right function.

新しいコード・ジェネレータでは、ファンクション・ポインターは、順番に割り当てられる内部IDを使用します。ジャンプによる呼び出しができないため、関数ポインタによる呼び出しは、常に ``switch`` 文を使って正しい関数を選択する内部ディスパッチ関数を使用する必要があります。

.. The ID ``0`` is reserved for uninitialized function pointers which then cause a panic in the dispatch function when called.

ID  ``0`` は、初期化されていない関数ポインタ用に予約されており、このポインタが呼び出されると、ディスパッチ関数でパニックが発生します。

.. In the old code generator, internal function pointers are initialized with a special function that always causes a panic.
.. This causes a storage write at construction time for internal function pointers in storage.

古いコードジェネレータでは、内部関数ポインタは、常にパニックを起こす特別な関数で初期化されます。このため、ストレージ内の内部関数ポインタの構築時にストレージへの書き込みが発生します。

Cleanup
-------

.. index:: cleanup, dirty bits

.. The old code generator only performs cleanup before an operation whose result could be affected by the values of the dirty bits.
.. The new code generator performs cleanup after any operation that can result in dirty bits.
.. The hope is that the optimizer will be powerful enough to eliminate redundant cleanup operations.

古いコード・ジェネレータは、ダーティ・ビットの値によって結果が影響を受ける可能性のある操作の前にのみ、クリーンアップを行います。新しいコードジェネレータでは、ダーティビットが発生する可能性のある操作の後にクリーンアップを行います。オプティマイザーが強力になり、冗長なクリーンアップ処理がなくなることを期待しています。

.. For example:

例えば、以下のように。

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.1;
    contract C {
        function f(uint8 a) public pure returns (uint r1, uint r2)
        {
            a = ~a;
            assembly {
                r1 := a
            }
            r2 = a;
        }
    }

.. The function ``f(1)`` returns the following values:

関数 ``f(1)`` は以下の値を返します。

<<<<<<< HEAD
.. - Old code generator: (``fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe``, ``00000000000000000000000000000000000000000000000000000000000000fe``)

- 古いコードジェネレータ。( ``fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe`` ,  ``00000000000000000000000000000000000000000000000000000000000000fe`` )

.. - New code generator: (``00000000000000000000000000000000000000000000000000000000000000fe``, ``00000000000000000000000000000000000000000000000000000000000000fe``)

- 新しいコードジェネレータです。( ``00000000000000000000000000000000000000000000000000000000000000fe`` ,  ``00000000000000000000000000000000000000000000000000000000000000fe`` )

.. Note that, unlike the new code generator, the old code generator does not perform a cleanup after the bit-not assignment (``_a = ~_a``).
.. This results in different values being assigned (within the inline assembly block) to return value ``_r1`` between the old and new code generators.
.. However, both code generators perform a cleanup before the new value of ``_a`` is assigned to ``_r2``.
.. 

なお、新コード・ジェネレータとは異なり、旧コード・ジェネレータでは、ビット・ノットの割り当て（ ``_a = ~_a`` ）の後にクリーンアップを行わない。このため、新旧のコード・ジェネレータでは、インライン・アセンブリ・ブロック内で戻り値 ``_r1`` に割り当てられる値が異なります。しかし、どちらのコード・ジェネレータも、 ``_a`` の新しい値が ``_r2`` に割り当てられる前に、クリーンアップを実行します。
=======
Note that, unlike the new code generator, the old code generator does not perform a cleanup after the bit-not assignment (``a = ~a``).
This results in different values being assigned (within the inline assembly block) to return value ``r1`` between the old and new code generators.
However, both code generators perform a cleanup before the new value of ``a`` is assigned to ``r2``.
>>>>>>> 72f1907298f8bd55cd22d16ebb8975de910ba4d3
