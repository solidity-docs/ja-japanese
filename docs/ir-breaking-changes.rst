
.. index: ir breaking changes

.. _ir-breaking-changes:

.. Solidity IR-based Codegen Changes

**********************************
Solidity IRベースのCodegenの変更点
**********************************

.. Either directly from Solidity to EVM opcodes ("old codegen") or through an intermediate representation ("IR") in Yul ("new codegen" or "IR-based codegen").

Solidityは、2つの異なる方法でEVMバイトコードを生成できます。
Solidityから直接EVMのオペコードを生成する方法「old codegen」と、Yulの中間表現「IR」を介して生成する方法（「new codegen」または「IR-based codegen」）です。

.. The IR-based code generator was introduced with an aim to not only allow code generation to be more transparent and auditable but also to enable more powerful optimization passes that span across functions.

IRベースのコードジェネレーターを導入したのは、コード生成の透明性や監査性を高めるだけでなく、関数を跨いだより強力な最適化パスを可能にすることを目的としています。

.. You can enable it on the command line using ``--via-ir`` or with the option ``{"viaIR": true}`` in standard-json and we encourage everyone to try it out!

コマンドラインで ``--via-ir`` を使って有効にしたり、standard-jsonで ``{"viaIR": true}`` オプションを使って有効にできますので、ぜひ皆さんに試していただきたいと思います。

.. For several reasons, there are tiny semantic differences between the old and the IR-based code generator, mostly in areas where we would not expect people to rely on this behaviour anyway.

いくつかの理由により、従来のコードジェネレーターとIRベースのコードジェネレーターの間にはわずかなセマンティックな違いがありますが、そのほとんどは、いずれにしても人々がこの動作に頼ることはないだろうと思われる領域です。
このセクションでは、旧来のコードジェネレーターとIRベースのコードジェネレーターの主な違いを紹介します。

.. Semantic Only Changes

セマンティックのみの変更
========================

.. This section lists the changes that are semantic-only, thus potentially hiding new and different behavior in existing code.

このセクションでは、セマンティックのみの変更点をリストアップしています。
そのため、既存のコードの中に新しい、あるいは異なる動作が隠されている可能性があります。

.. - The order of state variable initialization has changed in case of inheritance.

..   The order used to be:

..   - All state variables are zero-initialized at the beginning.
..   - Evaluate base constructor arguments from most derived to most base contract.
..   - Initialize all state variables in the whole inheritance hierarchy from most base to most derived.
..   - Run the constructor, if present, for all contracts in the linearized hierarchy from most base to most derived.

..   New order:

..   - All state variables are zero-initialized at the beginning.
..   - Evaluate base constructor arguments from most derived to most base contract.
..   - For every contract in order from most base to most derived in the linearized hierarchy:

..       1. Initialize state variables.
..       2. Run the constructor (if present).

..   This causes differences in contracts where the initial value of a state
..   variable relies on the result of the constructor in another contract:

- 継承した場合の状態変数の初期化の順序が変更されました。

  以前の順序:

  - すべての状態変数は、最初にゼロ初期化されます。
  - ベースコンストラクタの引数を、最も派生したものから最もベースとなるコントラクトまで評価します。
  - 最も基本的なものから最も派生的なものまで、継承階層全体のすべての状態変数を初期化します。
  - 最も基本的なものから最も派生したものまで、線形化された階層内のすべてのコントラクトについて、コンストラクタが存在する場合はそれを実行します。

  新しい順序:

  - すべての状態変数が最初にゼロ初期化されます。
  - ベースコンストラクタの引数を、最も派生したコントラクトから最もベースとなるコントラクトまで評価します。
  - 線形化された階層で、最も基本から最も派生した順に、すべてのコントラクトについて:

      1. 状態変数を初期化します。
      2. コンストラクタを実行します（存在する場合）。

  このため、コントラクトで状態変数の初期値が異なる場合があります。
  変数は、別のコントラクトのコンストラクタの結果に依存しています:

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

  .. Previously, ``y`` would be set to 0. This is due to the fact that we would first initialize state variables: First, ``x`` is set to 0, and when initializing ``y``, ``f()`` would return 0 causing ``y`` to be 0 as well.
  .. With the new rules, ``y`` will be set to 42. We first initialize ``x`` to 0, then call A's constructor which sets ``x`` to 42. Finally, when initializing ``y``, ``f()`` returns 42 causing ``y`` to be 42.

  これは、最初に状態変数を初期化することに起因しています: まず、 ``x`` は0に設定され、 ``y`` を初期化する際に、 ``f()`` は0を返し、 ``y`` も0になります。
  新しいルールでは、 ``y`` は 42 に設定されます。
  まず ``x`` を 0 に初期化し、次に A のコンストラクタをコールして ``x`` を 42 に設定します。
  最後に ``y`` を初期化する際に ``f()`` が 42 を返すので ``y`` は 42 になります。

.. - When storage structs are deleted, every storage slot that contains a member of the struct is set to zero entirely.
     Formerly, padding space was left untouched.
     Consequently, if the padding space within a struct is used to store data (e.g. in the context of a contract upgrade), you have to be aware that ``delete`` will now also clear the added member (while it wouldn't have been cleared in the past).

- ストレージ構造体が削除されると、その構造体のメンバーを含むすべてのストレージスロットが完全にゼロになります。
  以前は、パディングスペースはそのまま残されていました。
  そのため、構造体内のパディングスペースがデータの保存に使用されている場合（コントラクトのアップグレードなど）、 ``delete`` では追加されたメンバーもクリアされてしまうことに注意する必要があります（以前はクリアされませんでしたが）。

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

  .. We have the same behavior for implicit delete, for example when array of structs is shortened.

  暗黙の削除は、例えば構造体の配列が短くなったときにも同じ動作をします。

.. - Function modifiers are implemented in a slightly different way regarding function parameters and return variables.
..   This especially has an effect if the placeholder ``_;`` is evaluated multiple times in a modifier.
..   In the old code generator, each function parameter and return variable has a fixed slot on the stack.
..   If the function is run multiple times because ``_;`` is used multiple times or used in a loop, then a change to the function parameter's or return variable's value is visible in the next execution of the function.
..   The new code generator implements modifiers using actual functions and passes function parameters on.
..   This means that multiple evaluations of a function's body will get the same values for the parameters, and the effect on return variables is that they are reset to their default (zero) value for each execution.

- 関数修飾子は、関数のパラメータとリターン変数に関して、若干異なる方法で実装されています。
  これは特に、プレースホルダー ``_;`` が修飾子の中で複数回評価される場合に影響を及ぼします。
  古いコードジェネレーターでは、各関数パラメータとリターン変数はスタック上に固定されたスロットを持っています。
  もし ``_;`` が複数回使われたり、ループ内で使われたりして関数が複数回実行されると、関数パラメータの値やリターン変数の値の変化は、関数の次の実行で見えるようになります。
  新しいコードジェネレータでは、実際の関数を使用して修飾子を実装し、関数パラメータを渡します。
  つまり、関数本体を複数回評価しても、パラメータは同じ値になり、リターン変数は実行ごとにデフォルト（ゼロ）値にリセットされるという効果があります。

  .. code-block:: solidity

      // SPDX-License-Identifier: GPL-3.0
      pragma solidity >=0.7.0;
      contract C {
          function f(uint a) public pure mod() returns (uint r) {
              r = a++;
          }
          modifier mod() { _; _; }
      }

  .. If you execute ``f(0)`` in the old code generator, it will return ``1``, while it will return ``0`` when using the new code generator.

  古いコードジェネレータで ``f(0)`` を実行すると ``1`` が返され、新しいコードジェネレータを使うと ``0`` が返されます。

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

  .. The function ``C.foo()`` returns the following values:

  .. - Old code generator: ``1`` as the return variable is initialized to ``0`` only once before the first ``_;`` evaluation and then overwritten by the ``return 1;``.
  ..   It is not initialized again for the second ``_;`` evaluation and ``foo()`` does not explicitly assign it either (due to ``active == false``), thus it keeps its first value.

  .. - New code generator: ``0`` as all parameters, including return parameters, will be re-initialized before each ``_;`` evaluation.

  関数 ``C.foo()`` は以下の値を返します:

  - 古いコードジェネレータ: 戻り値の変数である ``1`` は、最初の ``_;`` 評価の前に一度だけ ``0`` に初期化され、その後 ``return 1;`` によって上書きされます。
    2回目の ``_;`` 評価では再び初期化されず、 ``foo()`` も明示的に代入しないので（ ``active == false`` のため）、最初の値を保持します。

  - 新しいコードジェネレータ: ``0`` は、リターンパラメータを含むすべてのパラメータが、各 ``_;`` 評価の前に再初期化されるからです。

  .. index:: ! evaluation order; expression

.. - For the old code generator, the evaluation order of expressions is unspecified.
..   For the new code generator, we try to evaluate in source order (left to right), but do not guarantee it.
..   This can lead to semantic differences.

..   For example:

- 旧コードジェネレータの場合、式の評価順は不定です。
  新しいコードジェネレータでは、ソース順（左から右）に評価するようにしていますが、保証はしません。
  このため、意味上の差異が生じることがあります。

  例えば、以下のようなものです:

  .. code-block:: solidity

      // SPDX-License-Identifier: GPL-3.0
      pragma solidity >=0.8.1;
      contract C {
          function preincr_u8(uint8 a) public pure returns (uint8) {
              return ++a + a;
          }
      }

  .. The function ``preincr_u8(1)`` returns the following values:

  .. - Old code generator: 3 (``1 + 2``) but the return value is unspecified in general

  .. - New code generator: 4 (``2 + 2``) but the return value is not guaranteed

  関数 ``preincr_u8(1)`` は、以下の値を返します:

  - 古いコード生成器です: 3 (``1 + 2``)。ただし、一般に戻り値は不特定です。

  - 新しいコードジェネレーターです: 4 (``2 + 2``)。ただし、戻り値は保証されません。

  .. index:: ! evaluation order; function arguments

  .. On the other hand, function argument expressions are evaluated in the same order by both code generators with the exception of the global functions ``addmod`` and ``mulmod``.
  .. For example:

  一方、関数の引数の式は、グローバル関数 ``addmod`` と ``mulmod`` を除いて、両方のコードジェネレータで同じ順序で評価されます。
  例えば、以下のようになります:

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

  .. The function ``g(1, 2)`` returns the following values:

  .. - Old code generator: ``10`` (``add(2 + 3, 2 + 3)``) but the return value is unspecified in general

  .. - New code generator: ``10`` but the return value is not guaranteed

  .. The arguments to the global functions ``addmod`` and ``mulmod`` are evaluated right-to-left by the old code generator and left-to-right by the new code generator.
  .. For example:

  関数 ``g(1, 2)`` は以下の値を返します:

  - 古いコードジェネレータ: ``10`` (``add(2 + 3, 2 + 3)``)。ただし、一般に戻り値は不特定です。

  - 新しいコードジェネレーター: ``10`` 。ただし、戻り値は保証されません。

  グローバル関数 ``addmod`` と ``mulmod`` の引数は、古いコードジェネレータでは右から左に、新しいコードジェネレータでは左から右に評価されます。
  例えば、以下のようになります:

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

  .. The function ``f()`` returns the following values:

  .. - Old code generator: ``aMod = 0`` and ``mMod = 2``

  .. - New code generator: ``aMod = 4`` and ``mMod = 0``

  関数 ``f()`` は以下の値を返します:

  - 旧コードジェネレーター: ``aMod = 0`` と ``mMod = 2`` です。

  - 新しいコードジェネレーター: ``aMod = 4`` と ``mMod = 0`` です。

.. - The new code generator imposes a hard limit of ``type(uint64).max`` (``0xffffffffffffffff``) for the free memory pointer.
     Allocations that would increase its value beyond this limit revert.
     The old code generator does not have this limit.

..   For example:

- 新しいコードジェネレーターでは、空きメモリポインタの上限が ``type(uint64).max`` (``0xffffffffffff``) に設定されました。
  この制限を越えて値を増やすような割り当ては、リバートされます。
  古いコードジェネレーターには、この制限はありません。

  例えば:

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

  .. The function `f()` behaves as follows:

  .. - Old code generator: runs out of gas while zeroing the array contents after the large memory allocation

  .. - New code generator: reverts due to free memory pointer overflow (does not run out of gas)

  関数 ``f()`` は以下のような挙動をします:

  - 古いコードジェネレータ: 大きなメモリ割り当ての後、配列の内容をゼロにするときにガス欠になります。

  - 新しいコードジェネレータ: フリーメモリポインタのオーバーフローによりリバートします（ガス欠はしない）。

.. Internals

内部構造
========

.. Internal function pointers

内部の関数ポインタ
------------------

.. index:: function pointers

.. The old code generator uses code offsets or tags for values of internal function pointers.
.. This is especially complicated since these offsets are different at construction time and after deployment and the values can cross this border via storage.
.. Because of that, both offsets are encoded at construction time into the same value (into different bytes).

古いコードジェネレータは、内部関数ポインタの値にコードオフセットまたはタグを使用しています。
特に、これらのオフセットは構築時とデプロイ後では異なり、値はストレージを介してこの境界を越えることができるので、これは複雑です。
そのため、構築時には両方のオフセットが同じ値に（異なるバイトに）エンコードされます。

.. In the new code generator, function pointers use internal IDs that are allocated in sequence.
.. Since calls via jumps are not possible, calls through function pointers always have to use an internal dispatch function that uses the ``switch`` statement to select the right function.

新しいコードジェネレータでは、関数ポインタは、順番に割り当てられる内部IDを使用します。
ジャンプによる呼び出しができないため、関数ポインタによる呼び出しは、常に ``switch`` 文を使って正しい関数を選択する内部ディスパッチ関数を使用する必要があります。

.. The ID ``0`` is reserved for uninitialized function pointers which then cause a panic in the dispatch function when called.

ID  ``0`` は、初期化されていない関数ポインタ用に予約されており、このポインタが呼び出されると、ディスパッチ関数でパニックが発生します。

.. In the old code generator, internal function pointers are initialized with a special function that always causes a panic.
.. This causes a storage write at construction time for internal function pointers in storage.

古いコードジェネレータでは、内部関数ポインタは、常にパニックを起こす特別な関数で初期化されます。
このため、ストレージ内の内部関数ポインタの構築時にストレージへの書き込みが発生します。

クリーンアップ
--------------

.. index:: cleanup, dirty bits

.. The old code generator only performs cleanup before an operation whose result could be affected by the values of the dirty bits.
.. The new code generator performs cleanup after any operation that can result in dirty bits.
.. The hope is that the optimizer will be powerful enough to eliminate redundant cleanup operations.

古いコードジェネレータは、ダーティビットの値によって結果が影響を受ける可能性のある操作の前にのみ、クリーンアップを行います。
新しいコードジェネレータでは、ダーティビットが発生する可能性のある操作の後にクリーンアップを行います。
オプティマイザが強力になり、冗長なクリーンアップ処理がなくなることを期待しています。

例えば、以下のようになります。

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

関数 ``f(1)`` は以下の値を返します。

- 古いコードジェネレータ: ( ``fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe`` ,  ``00000000000000000000000000000000000000000000000000000000000000fe`` )
- 新しいコードジェネレータ: ( ``00000000000000000000000000000000000000000000000000000000000000fe`` ,  ``00000000000000000000000000000000000000000000000000000000000000fe`` )

.. Note that, unlike the new code generator, the old code generator does not perform a cleanup after the bit-not assignment (``a = ~a``).
.. This results in different values being assigned (within the inline assembly block) to return value ``r1`` between the old and new code generators.
.. However, both code generators perform a cleanup before the new value of ``a`` is assigned to ``r2``.

なお、新コードジェネレータとは異なり、旧コードジェネレータでは、ビットの否定（not）の割り当て（ ``a = ~a`` ）の後にクリーンアップを行いません。
このため、新旧のコードジェネレータでは、インラインアセンブリブロック内で戻り値 ``r1`` に割り当てられる値が異なります。
しかし、どちらのコードジェネレータも、 ``a`` の新しい値が ``r2`` に割り当てられる前に、クリーンアップを実行します。
