.. index:: optimizer, optimiser, common subexpression elimination, constant propagation
.. _optimizer:

**************
オプティマイザ
**************

Solidityコンパイラは、2つの異なるオプティマイザモジュールを使用しています。
オペコードレベルで動作する「旧」オプティマイザと、Yul IRコードで動作する「新」オプティマイザです。

オペコードベースのオプティマイザは、オペコードに `簡略化ルール <https://github.com/ethereum/solidity/blob/develop/libevmasm/RuleList.h>`_ を適用します。
また、同じコードセットを組み合わせたり、使われていないコードを削除したりします。

Yulベースのオプティマイザは、関数呼び出しをまたいで動作できるのでより強力です。
例えば、Yulでは任意のジャンプができないため、各関数の副作用を計算できます。
2つの関数呼び出しを考えてみましょう。
1つ目はストレージを変更せず、2つ目はストレージを変更します。
それらの引数と戻り値がお互いに依存しない場合、関数呼び出しを並べ替えることができます。
同様に、ある関数に副作用がなく、その実行結果にゼロをかける場合は、その関数呼び出しを完全に削除できます。

現在、パラメータ ``--optimize`` は、生成されたバイトコードにはオペコードベースのオプティマイザを、ABI coder v2などで内部的に生成されたYulコードにはYulオプティマイザを適用します。
``solc --ir-optimized --optimize`` は、Solidityのソースに対して最適化されたYul IRを生成するために使用できます。
同様に、 ``solc --strict-assembly --optimize`` はスタンドアローンのYulモードに使用できます。

.. note::
    .. The `peephole optimizer <https://en.wikipedia.org/wiki/Peephole_optimization>`_ and the inliner are always enabled by default and can only be turned off via the :ref:`Standard JSON <compiler-api>`.

    `peepholeオプティマイザ <https://en.wikipedia.org/wiki/Peephole_optimization>`_ とインライナーはデフォルトで常に有効になっており、 :ref:`Standard JSON <compiler-api>` によってのみオフにできます。

両オプティマイザモジュールとその最適化ステップの詳細は以下の通りです。

Solidityコードを最適化するメリット
==================================

全体的に、オプティマイザは複雑な式を単純化しようとします。
これにより、コードサイズと実行コストの両方が削減されます。
つまり、コントラクトのデプロイやコントラクトへの外部呼び出しに必要なガスを削減できます。
また、関数の特殊化やインライン化も行います。
特に関数のインライン化は、コードサイズが大きくなる可能性がある操作ですが、より単純化できる機会があるため、よく行われます。

最適化コードと非最適化コードの違い
==================================

一般的に最も目に見える違いは、定数式がコンパイル時に評価されることです。
ASMの出力に関しても、同じあるいは重複するコードブロックが減っていることがわかります（フラグ ``--asm`` と ``--asm --optimize`` の出力を比較してみてください）。
しかし、Yul/中間表現になると大きな差が出ることがあります。
例えば、冗長性をなくすために、関数がインライン化されたり、結合されたり、書き換えられたりすることがあります（フラグ ``--ir`` と ``--optimize --ir-optimized`` の出力を比較してみてください）。

.. _optimizer-parameter-runs:

.. Optimizer Parameter Runs

実行回数パラメータ
==================

.. The number of runs (``--optimize-runs``) specifies roughly how often each opcode of the
.. deployed code will be executed across the life-time of the contract. This means it is a
.. trade-off parameter between code size (deploy cost) and code execution cost (cost after deployment).
.. A "runs" parameter of "1" will produce short but expensive code. In contrast, a larger "runs"
.. parameter will produce longer but more gas efficient code. The maximum value of the parameter
.. is ``2**32-1``.

実行回数（ ``--optimize-runs`` ）は、デプロイされたコードの各オペコードがコントラクトのライフタイム中にどのくらいの頻度で実行されるかを大まかに指定します。
つまり、コードサイズ（デプロイコスト）とコード実行コスト（デプロイ後のコスト）のトレードオフパラメータとなります。
runsパラメータが1の場合、短いがコストのかかるコードが生成されます。
一方、runsパラメータを大きくすると、コードは長くなるがガス効率の良いコードが生成されます。
パラメータの最大値は ``2**32-1`` です。

.. note::

    よくこのパラメータがオプティマイザの反復回数を指定すると誤解されますが、これは違います。
    オプティマイザは、コードが改善される限り、常に何度でも実行されます。

オペコードベースのオプティマイザモジュール
==========================================

.. The opcode-based optimizer module operates on assembly code. It splits the
.. sequence of instructions into basic blocks at ``JUMPs`` and ``JUMPDESTs``.
.. Inside these blocks, the optimizer analyzes the instructions and records every modification to the stack,
.. memory, or storage as an expression which consists of an instruction and
.. a list of arguments which are pointers to other expressions.

オペコードベースのオプティマイザモジュールは、アセンブリコード上で動作します。
このモジュールは、一連の命令を ``JUMPs`` と ``JUMPDESTs`` の基本ブロックに分割します。
これらのブロックの中で、オプティマイザは命令を解析し、スタックやメモリ、ストレージに対するすべての変更を、命令と他の式へのポインタである引数のリストからなる式として記録します。

.. Additionally, the opcode-based optimizer uses a component called "CommonSubexpressionEliminator" that, amongst other tasks, finds expressions that are always equal (on every input) and combines them into an expression class.
.. It first tries to find each new expression in a list of already known expressions.
.. If no such matches are found, it simplifies the expression according to rules like ``constant + constant = sum_of_constants`` or ``X * 1 = X``.
.. Since this is
.. a recursive process, we can also apply the latter rule if the second factor
.. is a more complex expression which we know always evaluates to one.

さらに、オペコードベースのオプティマイザでは、「CommonSubexpressionEliminator」というコンポーネントを使用しています。
他のタスクの中で、（すべての入力に対して）常に等しい式を見つけ出し、それらを式クラスにまとめるというものです。
まず、既知の式のリストから新しい式を見つけようとします。
もしそのような式が見つからなければ、 ``constant + constant = sum_of_constants`` や ``X * 1 = X`` のようなルールに従って式を簡略化します。
これは再帰的なプロセスであるため、第2因子が常に1と評価されることがわかっているより複雑な式の場合、後者のルールを適用することもできます。

.. Certain optimizer steps symbolically track the storage and memory locations. For example, this
.. information is used to compute Keccak-256 hashes that can be evaluated during compile time. Consider
.. the sequence:

オプティマイザの一部のステップでは、ストレージやメモリの位置をシンボリックに追跡します。
例えば、この情報は、コンパイル時に評価できるKeccak-256ハッシュの計算に使用されます。
シーケンスを考えてみましょう。

.. code-block:: none

    PUSH 32
    PUSH 0
    CALLDATALOAD
    PUSH 100
    DUP2
    MSTORE
    KECCAK256

または、同等のYulとして、

.. code-block:: yul

    let x := calldataload(0)
    mstore(x, 100)
    let value := keccak256(x, 32)

.. In this case, the optimizer tracks the value at a memory location ``calldataload(0)`` and then
.. realizes that the Keccak-256 hash can be evaluated at compile time. This only works if there is no
.. other instruction that modifies memory between the ``mstore`` and ``keccak256``. So if there is an
.. instruction that writes to memory (or storage), then we need to erase the knowledge of the current
.. memory (or storage). There is, however, an exception to this erasing, when we can easily see that
.. the instruction doesn't write to a certain location.

この場合、オプティマイザはメモリ位置 ``calldataload(0)`` の値を追跡し、コンパイル時にKeccak-256ハッシュを評価できることを認識します。
これがうまくいくのは、 ``mstore`` と ``keccak256`` の間にメモリを変更する他の命令がない場合です。
つまり、メモリ（またはストレージ）に書き込む命令があれば、現在のメモリ（またはストレージ）の知識を消去する必要があるのです。
しかし、この消去には例外があり、その命令がある場所に書き込まれていないことが容易にわかる場合です。

例えば、

.. code-block:: yul

    let x := calldataload(0)
    mstore(x, 100)
    // Current knowledge memory location x -> 100
    let y := add(x, 32)
    // Does not clear the knowledge that x -> 100, since y does not write to [x, x + 32)
    mstore(y, 200)
    // This Keccak-256 can now be evaluated
    let value := keccak256(x, 32)

.. Therefore, modifications to storage and memory locations, of say location ``l``, must erase
.. knowledge about storage or memory locations which may be equal to ``l``. More specifically, for
.. storage, the optimizer has to erase all knowledge of symbolic locations, that may be equal to ``l``
.. and for memory, the optimizer has to erase all knowledge of symbolic locations that may not be at
.. least 32 bytes away. If ``m`` denotes an arbitrary location, then this decision on erasure is done
.. by computing the value ``sub(l, m)``. For storage, if this value evaluates to a literal that is
.. non-zero, then the knowledge about ``m`` will be kept. For memory, if the value evaluates to a
.. literal that is between ``32`` and ``2**256 - 32``, then the knowledge about ``m`` will be kept. In
.. all other cases, the knowledge about ``m`` will be erased.

そのため、ストレージやメモリの位置（例えば位置 ``l`` ）を変更する場合、 ``l`` に等しい可能性のあるストレージやメモリの位置に関する知識を消去しなければなりません。
具体的には、ストレージについては、 ``l`` に等しい可能性のあるシンボリックロケーションの知識をすべて消去し、メモリについては、少なくとも32バイト離れていない可能性のあるシンボリックロケーションの知識をすべて消去しなければなりません。
``m`` が任意の位置を示す場合、この消去の判断は値 ``sub(l, m)`` を計算することで行われます。
ストレージの場合、この値がゼロではないリテラルと評価されれば、 ``m`` に関する知識は維持されます。
メモリの場合、この値が ``32`` と ``2**256 - 32`` の間のリテラルと評価されるならば、 ``m`` に関する知識が保持されます。
それ以外の場合は、 ``m`` に関する知識は消去されます。

.. After this process, we know which expressions have to be on the stack at
.. the end, and have a list of modifications to memory and storage. This information
.. is stored together with the basic blocks and is used to link them. Furthermore,
.. knowledge about the stack, storage and memory configuration is forwarded to
.. the next block(s).

このプロセスを経て、最後にどの式がスタック上になければならないかがわかり、メモリとストレージの修正リストができました。
これらの情報は基本ブロックと一緒に保存され、ブロックの連結に使用されます。
さらに、スタック、ストレージ、メモリの構成に関する知識は、次のブロック（複数可）に転送されます。

.. If we know the targets of all ``JUMP`` and ``JUMPI`` instructions,
.. we can build a complete control flow graph of the program. If there is only
.. one target we do not know (this can happen as in principle, jump targets can
.. be computed from inputs), we have to erase all knowledge about the input state
.. of a block as it can be the target of the unknown ``JUMP``. If the opcode-based
.. optimizer module finds a ``JUMPI`` whose condition evaluates to a constant, it transforms it
.. to an unconditional jump.

すべての ``JUMP`` 命令と ``JUMPI`` 命令のターゲットがわかっていれば、プログラムの完全なコントロールフローグラフを作成できます。
一つだけわからないターゲットがある場合（ジャンプターゲットは原理的に入力から計算できるため、このようなことが起こりうる）、ブロックの入力状態に関する知識をすべて消去しなければなりません。
なぜなら、そのブロックは未知の ``JUMP`` のターゲットになりうるからです。
opcode-based optimizerモジュールは、条件が定数で評価される ``JUMPI`` を見つけた場合、それを無条件ジャンプに変換します。

.. As the last step, the code in each block is re-generated. The optimizer creates
.. a dependency graph from the expressions on the stack at the end of the block,
.. and it drops every operation that is not part of this graph. It generates code
.. that applies the modifications to memory and storage in the order they were
.. made in the original code (dropping modifications which were found not to be
.. needed). Finally, it generates all values that are required to be on the
.. stack in the correct place.

最後のステップとして、各ブロックのコードが再生成されます。
オプティマイザは、ブロックの最後のスタック上の式から依存関係のグラフを作成し、このグラフに含まれないすべての操作を削除します。
メモリやストレージの変更を元のコードの順番通りに適用するコードを生成します（必要ないと判断された変更は削除します）。
最後に、スタック上に必要なすべての値を正しい位置に生成します。

.. These steps are applied to each basic block and the newly generated code
.. is used as replacement if it is smaller. If a basic block is split at a
.. ``JUMPI`` and during the analysis, the condition evaluates to a constant,
.. the ``JUMPI`` is replaced based on the value of the constant. Thus code like

これらのステップは各基本ブロックに適用され、新しく生成されたコードの方が小さい場合には置き換えとして使用されます。
基本ブロックが ``JUMPI`` で分割され、解析中にその条件が定数と評価された場合、 ``JUMPI`` は定数の値に基づいて置換されます。
したがって、以下のようなコードは

.. code-block:: solidity

    uint x = 7;
    data[7] = 9;
    if (data[x] != x + 2) // this condition is never true
      return 2;
    else
      return 1;

.. simplifies to this:

は次のように簡略化されます。

.. code-block:: solidity

    data[7] = 9;
    return 1;

単純なインライン化
------------------

.. Since Solidity version 0.8.2, there is another optimizer step that replaces certain
.. jumps to blocks containing "simple" instructions ending with a "jump" by a copy of these instructions.
.. This corresponds to inlining of simple, small Solidity or Yul functions. In particular, the sequence
.. ``PUSHTAG(tag) JUMP`` may be replaced, whenever the ``JUMP`` is marked as jump "into" a
.. function and behind ``tag`` there is a basic block (as described above for the
.. "CommonSubexpressionEliminator") that ends in another ``JUMP`` which is marked as a jump
.. "out of" a function.

Solidityのバージョン0.8.2以降、オプティマイザのステップとして、「ジャンプ」で終わる「単純な」命令を含むブロックへの特定のジャンプを、これらの命令のコピーに置き換えるものがあります。
これは、単純で小さなSolidityやYulの関数のインライン化に相当します。
特に、シーケンス ``PUSHTAG(tag) JUMP`` は、 ``JUMP`` が関数への「ジャンプ」としてマークされ、 ``tag`` の後ろに、関数からの「ジャンプ」としてマークされた別の ``JUMP`` で終わる基本ブロック（「CommonSubexpressionEliminator」で前述したように）がある場合には、置き換えられる可能性があります。

.. In particular, consider the following prototypical example of assembly generated for a
.. call to an internal Solidity function:

具体的には、Solidityの内部関数をコールした際に生成されるアセンブリの典型的な例を以下に示します。

.. code-block:: text

      tag_return
      tag_f
      jump      // in
    tag_return:
      ...opcodes after call to f...

    tag_f:
      ...body of function f...
      jump      // out

.. As long as the body of the function is a continuous basic block, the "Inliner" can replace ``tag_f jump`` by
.. the block at ``tag_f`` resulting in:

関数のボディが連続した基本ブロックである限り、「Inliner」は ``tag_f jump`` を ``tag_f`` のブロックで置き換えることができ、結果として以下のようになります。

.. code-block:: text

      tag_return
      ...body of function f...
      jump
    tag_return:
      ...opcodes after call to f...

    tag_f:
      ...body of function f...
      jump      // out

.. Now ideally, the other optimizer steps described above will result in the return tag push being moved
.. towards the remaining jump resulting in:

ここで理想的なのは、上述の他のオプティマイザのステップにより、リターンタグのプッシュが残りのジャンプの方に移動し、結果として、

.. code-block:: text

      ...body of function f...
      tag_return
      jump
    tag_return:
      ...opcodes after call to f...

    tag_f:
      ...body of function f...
      jump      // out

.. In this situation the "PeepholeOptimizer" will remove the return jump.
.. Ideally, all of this can be done
.. for all references to ``tag_f`` leaving it unused, s.t. it can be removed, yielding:

この場合、「PeepholeOptimizer」はリターンジャンプを削除します。
理想的には、すべての ``tag_f`` への参照に対してこれを行い、未使用のまま、削除できるようにできます。

.. code-block:: text

    ...body of function f...
    ...opcodes after call to f...

.. So the call to function ``f`` is inlined and the original definition of ``f`` can be removed.

そのため、関数 ``f`` の呼び出しはインライン化され、 ``f`` の元の定義は削除できます。

.. Inlining like this is attempted, whenever a heuristics suggests that inlining is cheaper over the lifetime of a
.. contract than not inlining. This heuristics depends on the size of the function body, the
.. number of other references to its tag (approximating the number of calls to the function) and
.. the expected number of executions of the contract (the global optimizer parameter "runs").

このようなインライン化は、インライン化しないよりもインライン化した方がコントラクトのライフタイムの中で安くなるというヒューリスティックな提案がある場合に試みられます。
このヒューリスティックは、関数本体のサイズ、そのタグへの他の参照の数（関数のコール回数に近似）、コントラクトの予想実行回数（グローバルオプティマイザのパラメータ「runs」）に依存します。

Yulベースのオプティマイザモジュール
===================================

.. The Yul-based optimizer consists of several stages and components that all transform
.. the AST in a semantically equivalent way. The goal is to end up either with code
.. that is shorter or at least only marginally longer but will allow further
.. optimization steps.

Yulベースのオプティマイザは、いくつかのステージとコンポーネントで構成されており、これらがすべて意味的に同等の方法でASTを変換します。
最終的には、コードを短くするか、少なくともわずかに長くするだけで、さらなる最適化を可能にすることが目標です。

.. warning::

    オプティマイザは現在鋭意開発中のため、ここに掲載されている情報は古いものになっている可能性があります。

    .. If you rely on a certain functionality, please reach out to the team directly.

    特定の機能に依存している場合は、チームに直接お問い合わせください。

現在、オプティマイザは純粋に貪欲な戦略をとり、バックトラックは一切行いません。

Yulベースのオプティマイザモジュールの全構成要素を以下に説明します。
以下の変換ステップが主な構成要素です。

- SSA Transform

- Common Subexpression Eliminator

- Expression Simplifier

- Redundant Assign Eliminator

- Full Inliner

.. _optimizer-steps:

オプティマイザのステップ
------------------------

これは、Yulベースのオプティマイザの全ステップをアルファベット順に並べたリストです。
個々のステップとそのシーケンスについては、以下で詳しく説明しています。

============ ===============================
Abbreviation Full name
============ ===============================
``f``        :ref:`block-flattener`
``l``        :ref:`circular-reference-pruner`
``c``        :ref:`common-subexpression-eliminator`
``C``        :ref:`conditional-simplifier`
``U``        :ref:`conditional-unsimplifier`
``n``        :ref:`control-flow-simplifier`
``D``        :ref:`dead-code-eliminator`
``E``        :ref:`equal-store-eliminator`
``v``        :ref:`equivalent-function-combiner`
``e``        :ref:`expression-inliner`
``j``        :ref:`expression-joiner`
``s``        :ref:`expression-simplifier`
``x``        :ref:`expression-splitter`
``I``        :ref:`for-loop-condition-into-body`
``O``        :ref:`for-loop-condition-out-of-body`
``o``        :ref:`for-loop-init-rewriter`
``i``        :ref:`full-inliner`
``g``        :ref:`function-grouper`
``h``        :ref:`function-hoister`
``F``        :ref:`function-specializer`
``T``        :ref:`literal-rematerialiser`
``L``        :ref:`load-resolver`
``M``        :ref:`loop-invariant-code-motion`
``r``        :ref:`redundant-assign-eliminator`
``R``        :ref:`reasoning-based-simplifier` - highly experimental
``m``        :ref:`rematerialiser`
``V``        :ref:`SSA-reverser`
``a``        :ref:`SSA-transform`
``t``        :ref:`structural-simplifier`
``p``        :ref:`unused-function-parameter-pruner`
``S``        :ref:`unused-store-eliminator`
``u``        :ref:`unused-pruner`
``d``        :ref:`var-decl-initializer`
============ ===============================

.. Some steps depend on properties ensured by ``BlockFlattener``, ``FunctionGrouper``, ``ForLoopInitRewriter``.
.. For this reason the Yul optimizer always applies them before applying any steps supplied by the user.

いくつかのステップは ``BlockFlattener``, ``FunctionGrouper``, ``ForLoopInitRewriter`` によって確保されるプロパティに依存しています。
このため、Yulオプティマイザーは、ユーザーが提供したステップを適用する前に、常にそれらを適用します。

.. The ReasoningBasedSimplifier is an optimizer step that is currently not enabled in the default set of steps.
.. It uses an SMT solver to simplify arithmetic expressions and boolean conditions.
.. It has not received thorough testing or validation yet and can produce non-reproducible results, so please use with care!

ReasoningBasedSimplifierは、現在、デフォルトのステップセットでは有効になっていないオプティマイザーのステップです。
SMTソルバーを使用して、算術式とブーリアン条件を簡略化します。
まだ十分なテストや検証を受けておらず、再現性のない結果が出る可能性があるため、使用には注意が必要です！

最適化の選択
------------

デフォルトでは、オプティマイザは、生成されたアセンブリに対して、事前に定義された最適化ステップのシーケンスを適用します。
``--yul-optimizations`` オプションを使用すると、このシーケンスを上書きして、独自のシーケンスを指定できます。

.. code-block:: bash

    solc --optimize --ir-optimized --yul-optimizations 'dhfoD[xarrscLMcCTU]uljmul:fDnTOc'

.. The order of steps is significant and affects the quality of the output.
.. Moreover, applying a step may uncover new optimization opportunities for others that were already applied, so repeating steps is often beneficial.

ステップの順番は重要で、アウトプットの品質に影響します。
さらに、あるステップを適用することで、すでに適用した他のステップの新たな最適化の機会が発見されることもあり、ステップを繰り返すことが有益なことも多い。

.. The sequence inside ``[...]`` will be applied multiple times in a loop until the Yul code remains unchanged or until the maximum number of rounds (currently 12) has been reached.
.. Brackets (``[]``) may be used multiple times in a sequence, but can not be nested.

``[...]`` 内のシーケンスは、Yulコードが変化しないか、最大ラウンド数（現在は12ラウンド）に達するまで、ループで複数回適用されます。
括弧（ ``[]`` ）は連続して複数回使用することができますが、入れ子にすることはできません。

.. An important thing to note, is that there are some hardcoded steps that are always run before and after the user-supplied sequence, or the default sequence if one was not supplied by the user.

注意すべき重要な点は、ユーザーから提供されたシーケンス（ユーザーから提供されなかった場合はデフォルトのシーケンス）の前後に常に実行されるハードコードされたステップがいくつかあることです。

.. The cleanup sequence delimiter ``:`` is optional, and is used to supply a custom cleanup sequence in order to replace the default one.
.. If omitted, the optimizer will simply apply the default cleanup sequence.
.. In addition, the delimiter may be placed at the beginning of the user-supplied sequence, which will result in the optimization sequence being empty, whereas conversely, if placed at the end of the sequence, will be treated as an empty cleanup sequence.

クリーンアップシーケンスの区切り文字 ``:`` はオプションで、デフォルトのクリーンアップシーケンスを置き換えるために、カスタムクリーンアップシーケンスを指定するために使用します。
省略された場合、オプティマイザはデフォルトのクリーンアップシーケンスを適用します。
また、デリミターをユーザーが指定したシーケンスの先頭に置くと、最適化シーケンスは空になり、逆にシーケンスの末尾に置くと、空のクリーンアップシーケンスとして扱われます。


前処理
------

前処理コンポーネントは、プログラムを作業しやすい特定の正規形に変換します。

この正規形は、最適化プロセスの残りの部分でも保たれます。

.. _disambiguator:

Disambiguator
^^^^^^^^^^^^^

.. The disambiguator takes an AST and returns a fresh copy where all identifiers have
.. unique names in the input AST. This is a prerequisite for all other optimizer stages.
.. One of the benefits is that identifier lookup does not need to take scopes into account
.. which simplifies the analysis needed for other steps.

DisambiguatorはASTを受け取り、すべての識別子が入力ASTの中でユニークな名前を持つ新鮮なコピーを返します。
これは、他のすべてのオプティマイザのステージの前提条件となります。
利点としては、識別子の検索にスコープを考慮する必要がないため、他のステップで必要な分析が簡単になることです。

.. All subsequent stages have the property that all names stay unique. This means if
.. a new identifier needs to be introduced, a new unique name is generated.

それ以降のステージでは、すべての名前が一意に保たれるという特性があります。
つまり、新しい識別子を導入する必要がある場合は、新しい一意の名前が生成されます。

.. _function-hoister:

FunctionHoister
^^^^^^^^^^^^^^^

.. The function hoister moves all function definitions to the end of the topmost block. This is
.. a semantically equivalent transformation as long as it is performed after the
.. disambiguation stage. The reason is that moving a definition to a higher-level block cannot decrease
.. its visibility and it is impossible to reference variables defined in a different function.

FunctionHoisterは、すべての関数定義を最上位のブロックの最後に移動させます。
これは、曖昧さを解消するステージの後に実行される限り、意味的に同等の変換です。
その理由は、定義を上位のブロックに移動しても、そのビジビリティを低下させることはできず、また、別の関数で定義された変数を参照することもできないからです。

.. The benefit of this stage is that function definitions can be looked up more easily
.. and functions can be optimized in isolation without having to traverse the AST completely.

このステージの利点は、関数の定義をより簡単に調べることができ、ASTを完全にトラバースすることなく関数を単独で最適化できることです。

.. _function-grouper:

FunctionGrouper
^^^^^^^^^^^^^^^

.. The function grouper has to be applied after the disambiguator and the function hoister.
.. Its effect is that all topmost elements that are not function definitions are moved
.. into a single block which is the first statement of the root block.

FunctionGrouperは、DisambiguatorとFunctionHoisterの後に適用しなければなりません。
その効果は、関数定義ではないすべての最上位要素が、ルートブロックの最初の文である1つのブロックに移動されることです。

このステップを経て、プログラムは次のような正規形になります。

.. code-block:: text

    { I F... }

.. Where ``I`` is a (potentially empty) block that does not contain any function definitions (not even recursively)
.. and ``F`` is a list of function definitions such that no function contains a function definition.

``I`` は関数定義を（再帰的にも）含まない（空になる可能性のある）ブロックで、 ``F`` は関数定義のリストで、どの関数も関数定義を含まないようになっています。

.. The benefit of this stage is that we always know where the list of function begins.

このステージの利点は、関数のリストがどこから始まるかを常に把握できることです。

.. _for-loop-condition-into-body:

ForLoopConditionIntoBody
^^^^^^^^^^^^^^^^^^^^^^^^

.. This transformation moves the loop-iteration condition of a for-loop into loop body.
.. We need this transformation because :ref:`expression-splitter` will not
.. apply to iteration condition expressions (the ``C`` in the following example).

この変換は、forループのループ反復条件をループ本体に移動させるものです。
:ref:`expression-splitter` は反復条件式（以下の例では ``C`` ）には適用されないため、この変換が必要です。

.. code-block:: text

    for { Init... } C { Post... } {
        Body...
    }

は、次の処理に変換されます:

.. code-block:: text

    for { Init... } 1 { Post... } {
        if iszero(C) { break }
        Body...
    }

.. This transformation can also be useful when paired with ``LoopInvariantCodeMotion``, since
.. invariants in the loop-invariant conditions can then be taken outside the loop.

ループ不変条件の不変量をループの外に出すことができるため、この変換は ``LoopInvariantCodeMotion`` と組み合わせても有効です。

.. _for-loop-init-rewriter:

ForLoopInitRewriter
^^^^^^^^^^^^^^^^^^^

.. This transformation moves the initialization part of a for-loop to before
.. the loop:

この変換により、for-loopの初期化部分がループの前に移動します。

.. code-block:: text

    for { Init... } C { Post... } {
        Body...
    }

は、次の処理に変換されます:

.. code-block:: text

    Init...
    for {} C { Post... } {
        Body...
    }

.. This eases the rest of the optimization process because we can ignore
.. the complicated scoping rules of the for loop initialisation block.

これにより、forループ初期化ブロックの複雑なスコープルールを無視できるため、残りの最適化プロセスが容易になります。

.. _var-decl-initializer:

VarDeclInitializer
^^^^^^^^^^^^^^^^^^

このステップでは、変数の宣言を書き換えて、すべての変数が初期化されるようにします。
``let x, y`` のような宣言は、複数の宣言文に分割されます。

今のところ、ゼロリテラルでの初期化のみをサポートしています。

疑似SSAトランスフォーム
-----------------------

.. The purpose of this components is to get the program into a longer form,
.. so that other components can more easily work with it. The final representation
.. will be similar to a static-single-assignment (SSA) form, with the difference
.. that it does not make use of explicit "phi" functions which combines the values
.. from different branches of control flow because such a feature does not exist
.. in the Yul language. Instead, when control flow merges, if a variable is re-assigned
.. in one of the branches, a new SSA variable is declared to hold its current value,
.. so that the following expressions still only need to reference SSA variables.

このコンポーネントの目的は、プログラムをより長い形式にして、他のコンポーネントがより簡単に作業できるようにすることです。
最終的な表現は、Static-Single-Assignment (SSA)形式に似ていますが、コントロールフローの異なるブランチからの値を結合する明示的な「ファイ」関数を使用しないという違いがあります（そのような機能はYul言語には存在しません）。
代わりに、コントロールフローがマージされる際に、いずれかのブランチで変数が再代入されると、その現在の値を保持する新しいSSA変数が宣言されるため、以下の式では依然としてSSA変数を参照するだけでよい。

変換例は以下の通りです。

.. code-block:: yul

    {
        let a := calldataload(0)
        let b := calldataload(0x20)
        if gt(a, 0) {
            b := mul(b, 0x20)
        }
        a := add(a, 1)
        sstore(a, add(b, 0x20))
    }

.. When all the following transformation steps are applied, the program will look
.. as follows:

以下の変換ステップをすべて適用すると、プログラムは以下のようになります。

.. code-block:: yul

    {
        let _1 := 0
        let a_9 := calldataload(_1)
        let a := a_9
        let _2 := 0x20
        let b_10 := calldataload(_2)
        let b := b_10
        let _3 := 0
        let _4 := gt(a_9, _3)
        if _4
        {
            let _5 := 0x20
            let b_11 := mul(b_10, _5)
            b := b_11
        }
        let b_12 := b
        let _6 := 1
        let a_13 := add(a_9, _6)
        let _7 := 0x20
        let _8 := add(b_12, _7)
        sstore(a_13, _8)
    }

.. Note that the only variable that is re-assigned in this snippet is ``b``.
.. This re-assignment cannot be avoided because ``b`` has different values
.. depending on the control flow. All other variables never change their
.. value once they are defined. The advantage of this property is that
.. variables can be freely moved around and references to them
.. can be exchanged by their initial value (and vice-versa),
.. as long as these values are still valid in the new context.

このスニペットで再代入されている変数は ``b`` のみであることに注意してください。
``b`` はコントロールフローに応じて異なる値を持つため、この再代入を避けることはできません。
他のすべての変数は、一度定義されるとその値が変わることはありません。
この特性の利点は、新しいコンテキストでこれらの値が有効である限り、変数を自由に移動させたり、変数への参照を初期値で交換したりできることです（その逆も同様）。

.. Of course, the code here is far from being optimized. To the contrary, it is much
.. longer. The hope is that this code will be easier to work with and furthermore,
.. there are optimizer steps that undo these changes and make the code more
.. compact again at the end.

もちろん、ここでのコードは最適化とは程遠いものです。
それどころか、ずっと長くなっています。
希望としては、このコードが作業しやすくなり、さらに、これらの変更をリバートし、最後に再びコードをコンパクトにするオプティマイザのステップがあることです。

.. _expression-splitter:

ExpressionSplitter
^^^^^^^^^^^^^^^^^^

.. The expression splitter turns expressions like ``add(mload(0x123), mul(mload(0x456), 0x20))``
.. into a sequence of declarations of unique variables that are assigned sub-expressions
.. of that expression so that each function call has only variables
.. as arguments.

ExpressionSplitterは、 ``add(mload(0x123), mul(mload(0x456), 0x20))`` のような式を、その式のサブ式に代入られた一意の変数の宣言の列に変え、各関数呼び出しが引数として変数のみを持つようにします。

.. The above would be transformed into

上記は次のように変換されます。

.. code-block:: yul

    {
        let _1 := 0x20
        let _2 := 0x456
        let _3 := mload(_2)
        let _4 := mul(_3, _1)
        let _5 := 0x123
        let _6 := mload(_5)
        let z := add(_6, _4)
    }

なお、この変換はオペコードや関数のコールの順番を変えるものではありません。

.. It is not applied to loop iteration-condition, because the loop control flow does not allow
.. this "outlining" of the inner expressions in all cases. We can sidestep this limitation by applying
.. :ref:`for-loop-condition-into-body` to move the iteration condition into loop body.

これは、ループのコントロールフローが、すべてのケースで内部式の「アウトライン化」を許可していないため、ループの反復条件には適用されません。
:ref:`for-loop-condition-into-body` を適用して反復条件をループ本体に移動させることで、この制限を回避できます。

.. The final program should be in a form such that (with the exception of loop conditions)
.. function calls cannot appear nested inside expressions
.. and all function call arguments have to be variables.

最終的なプログラムは、（ループ条件を除いて）関数呼び出しを式の中に入れ子にすることはできず、関数呼び出しの引数はすべて変数でなければならないという形にしなければなりません。

この形式の利点は、オペコードの順序を変更するのがかなり容易であることと、関数呼び出しのインライン化を実行するのも容易であることです。
さらに、式の個々の部分を置き換えたり、「式ツリー」を再編成したりするのも簡単です。
難点は、人間にとって読みにくいコードであることです。

.. _SSA-transform:

SSATransform
^^^^^^^^^^^^

このステージでは、既存の変数への繰り返しの代入を、新しい変数の宣言で可能な限り置き換えようとします。
再代入は残っていますが、再代入された変数へのすべての参照は、新しく宣言された変数に置き換えられます。

例:

.. code-block:: yul

    {
        let a := 1
        mstore(a, 2)
        a := 3
    }

は、次のコードに変換されます。

.. code-block:: yul

    {
        let a_1 := 1
        let a := a_1
        mstore(a_1, 2)
        let a_3 := 3
        a := a_3
    }

厳密なセマンティクス:

.. For any variable ``a`` that is assigned to somewhere in the code
.. (variables that are declared with value and never re-assigned
.. are not modified) perform the following transforms:

コードのどこかに代入されている変数 ``a`` （値が宣言されていて再代入されない変数は変更されない）について、以下の変換を行います。

- ``let a := v`` を ``let a_i := v   let a := a_i`` で置き換えます。

- ``a := v`` を ``let a_i := v   a := a_i`` に置き換えます。
  ここで ``i`` は ``a_i`` にまだ使われていない数です。

.. Furthermore, always record the current value of ``i`` used for ``a`` and replace each
.. reference to ``a`` by ``a_i``.
.. The current value mapping is cleared for a variable ``a`` at the end of each block
.. in which it was assigned to and at the end of the for loop init block if it is assigned
.. inside the for loop body or post block.
.. If a variable's value is cleared according to the rule above and the variable is declared outside
.. the block, a new SSA variable will be created at the location where control flow joins,
.. this includes the beginning of loop post/body block and the location right after
.. If/Switch/ForLoop/Block statement.

さらに、 ``a`` に使われている ``i`` の現在の値を常に記録し、 ``a`` への各参照を ``a_i`` に置き換えます。
変数 ``a`` の現在値のマッピングは、それが代入された各ブロックの終了時、およびforループ本体やポストブロック内で代入された場合はforループのinitブロックの終了時にクリアされます。
上記のルールで変数の値がクリアされ、その変数がブロック外で宣言された場合、ループのポスト/ボディブロックの先頭や、If/Switch/ForLoop/Block文の直後など、コントロールフローが合流する位置に新たなSSA変数が作成されます。

このステージの後、不要な中間代入を削除するために、Redundant Assign Eliminatorを使用することをお勧めします。

.. This stage provides best results if the Expression Splitter and the Common Subexpression Eliminator
.. are run right before it, because then it does not generate excessive amounts of variables.
.. On the other hand, the Common Subexpression Eliminator could be more efficient if run after the
.. SSA transform.

このステージでは、Expression SplitterとCommon Subexpression Eliminatorが直前に実行されると、過剰な量の変数が生成されないため、最良の結果が得られます。
一方、Common Subexpression EliminatorはSSAトランスフォームの後に実行した方がより効率的です。

.. _redundant-assign-eliminator:

RedundantAssignEliminator
^^^^^^^^^^^^^^^^^^^^^^^^^

.. The SSA transform always generates an assignment of the form ``a := a_i``, even though
.. these might be unnecessary in many cases, like the following example:

SSAトランスフォームでは、次の例のように多くのケースで不要な場合があっても、常に ``a := a_i`` 形式の割り当てが生成されます。

.. code-block:: yul

    {
        let a := 1
        a := mload(a)
        a := sload(a)
        sstore(a, 1)
    }

.. The SSA transform converts this snippet to the following:

SSAトランスフォームでは、このスニペットを次のように変換します。

.. code-block:: yul

    {
        let a_1 := 1
        let a := a_1
        let a_2 := mload(a_1)
        a := a_2
        let a_3 := sload(a_2)
        a := a_3
        sstore(a_3, 1)
    }

.. The Redundant Assign Eliminator removes all the three assignments to ``a``, because
.. the value of ``a`` is not used and thus turn this
.. snippet into strict SSA form:

Redundant Assign Eliminatorは、 ``a`` の値が使用されていないため、 ``a`` への3つの割り当てをすべて削除し、このスニペットを厳密なSSAフォームにします。

.. code-block:: yul

    {
        let a_1 := 1
        let a_2 := mload(a_1)
        let a_3 := sload(a_2)
        sstore(a_3, 1)
    }

.. Of course the intricate parts of determining whether an assignment is redundant or not
.. are connected to joining control flow.

もちろん、代入が冗長であるかどうかを判断する複雑な部分は、コントロールフローの結合につながっています。

.. The component works as follows in detail:

このコンポーネントは、詳しくは以下のように動作します。

.. The AST is traversed twice: in an information gathering step and in the
.. actual removal step. During information gathering, we maintain a
.. mapping from assignment statements to the three states
.. "unused", "undecided" and "used" which signifies whether the assigned
.. value will be used later by a reference to the variable.

ASTは、情報収集のステップと実際の削除のステップの2回にわたって走査されます。
情報収集のステップでは、代入文から「unused」「undecided」「used」の3つの状態へのマッピングを保持しています。
これは、代入された値が後でその変数への参照によって使われるかどうかを示すものです。

.. When an assignment is visited, it is added to the mapping in the "undecided" state
.. (see remark about for loops below) and every other assignment to the same variable
.. that is still in the "undecided" state is changed to "unused".
.. When a variable is referenced, the state of any assignment to that variable still
.. in the "undecided" state is changed to "used".

代入が訪問されると、「undecided」状態のマッピングに追加され（後述のforループに関する記述を参照）、「undecided」状態のままの同じ変数への他のすべての代入は「unused」に変更されます。
ある変数が参照されると、「undecided」状態にあるその変数へのすべての割り当ての状態は "used"に変更されます。

.. At points where control flow splits, a copy
.. of the mapping is handed over to each branch. At points where control flow
.. joins, the two mappings coming from the two branches are combined in the following way:
.. Statements that are only in one mapping or have the same state are used unchanged.
.. Conflicting values are resolved in the following way:

コントロールフローが分岐するポイントでは、マッピングのコピーが各ブランチに引き渡されます。
コントロールフローが合流するポイントでは、2つのブランチから送られてきた2つのマッピングが次のようにして結合されます。
1つのマッピングにしかない文や同じ状態の文は、変更されずに使用されます。
相反する値は次のようにして解決されます。

- 「unused」「undecided」 -> 「undecided」

- 「unused」「used」 -> 「used」

- 「undecided」「used」 -> 「used」

.. For for-loops, the condition, body and post-part are visited twice, taking
.. the joining control-flow at the condition into account.
.. In other words, we create three control flow paths: Zero runs of the loop,
.. one run and two runs and then combine them at the end.

for-loopでは、condition、body、post-partを2回訪れ、conditionでのコントロールフローの結合を考慮します。
つまり、3つのコントロールフローの経路を作ります。
つまり、0回のループ、1回のループ、2回のループの3つのコントロールフローを作成し、最後にそれらを結合します。

.. Simulating a third run or even more is unnecessary, which can be seen as follows:

3回目以降のシミュレーションは不要であることは、次のように考えられます。

.. A state of an assignment at the beginning of the iteration will deterministically
.. result in a state of that assignment at the end of the iteration. Let this
.. state mapping function be called ``f``. The combination of the three different
.. states ``unused``, ``undecided`` and ``used`` as explained above is the ``max``
.. operation where ``unused = 0``, ``undecided = 1`` and ``used = 2``.

反復開始時の割り当ての状態は、反復終了時のその割り当ての状態を決定論的にもたらします。
この状態マッピング関数を ``f`` とします。
上記で説明した3つの異なる状態 ``unused`` 、 ``undecided`` 、 ``used`` の組み合わせは、 ``unused = 0`` 、 ``undecided = 1`` 、 ``used = 2`` の ``max`` 演算です。

.. The proper way would be to compute

適切な方法は、次のように計算します。

.. code-block:: none

    max(s, f(s), f(f(s)), f(f(f(s))), ...)

.. as state after the loop. Since ``f`` just has a range of three different values,
.. iterating it has to reach a cycle after at most three iterations,
.. and thus ``f(f(f(s)))`` has to equal one of ``s``, ``f(s)``, or ``f(f(s))``
.. and thus

をループ後の状態とします。
``f`` は3つの異なる値の範囲を持っているだけなので、これを反復すると、最大で3回の反復後にサイクルに到達しなければならず、したがって ``f(f(f(s)))`` は ``s`` 、 ``f(s)`` 、 ``f(f(s))`` のいずれかと等しくなければならず、したがって

.. code-block:: none

    max(s, f(s), f(f(s))) = max(s, f(s), f(f(s)), f(f(f(s))), ...).

.. In summary, running the loop at most twice is enough because there are only three
.. different states.

要するに、3つの異なる状態があるだけなので、ループを最大2回実行すれば十分です。

.. For switch statements that have a "default"-case, there is no control-flow
.. part that skips the switch.

defaultのケースを持つswitch文では、スイッチをスキップするコントロールフローの部分はありません。

.. When a variable goes out of scope, all statements still in the "undecided"
.. state are changed to "unused", unless the variable is the return
.. parameter of a function - there, the state changes to "used".

変数がスコープ外に出ると、まだ「undecided」の状態にあるすべての文が「unused」に変更されます。
ただし、その変数が関数のリターンパラメータである場合は、「used」に変更されます。

.. In the second traversal, all assignments that are in the "unused" state are removed.

2回目のトラバーサルでは、「unused」の状態にあるすべての代入が削除されます。

.. This step is usually run right after the SSA transform to complete
.. the generation of the pseudo-SSA.

このステップは通常、SSAトランスフォームの直後に実行され、疑似SSAの生成を完了します。

ツール
------

Movability
^^^^^^^^^^

.. Movability is a property of an expression. It roughly means that the expression
.. is side-effect free and its evaluation only depends on the values of variables
.. and the call-constant state of the environment. Most expressions are movable.
.. The following parts make an expression non-movable:

movabilityは、式の特性の一つです。
大まかに言うと、その式は副作用がなく、その評価は変数の値と環境のコールコンスタントな状態にのみ依存するということです。
ほとんどの式はmovableです。
以下の部分が式をnon-movableにしています。

.. - function calls (might be relaxed in the future if all statements in the function are movable)
.. - opcodes that (can) have side-effects (like ``call`` or ``selfdestruct``)
.. - opcodes that read or write memory, storage or external state information
.. - opcodes that depend on the current PC, memory size or returndata size

- 関数の呼び出し（関数内のすべての文がmovableであれば、将来緩和される可能性あり）
- 副作用のある（可能性のある）オペコード（ ``call`` や ``selfdestruct`` など）
- メモリ、ストレージ、外部の状態情報を読み書きするオペコード
- 現在のPC、メモリサイズ、リターンデータのサイズに依存するオペコード

DataflowAnalyzer
^^^^^^^^^^^^^^^^

.. The Dataflow Analyzer is not an optimizer step itself but is used as a tool
.. by other components. While traversing the AST, it tracks the current value of
.. each variable, as long as that value is a movable expression.
.. It records the variables that are part of the expression
.. that is currently assigned to each other variable. Upon each assignment to
.. a variable ``a``, the current stored value of ``a`` is updated and
.. all stored values of all variables ``b`` are cleared whenever ``a`` is part
.. of the currently stored expression for ``b``.

Dataflow Analyzerは、それ自体はオプティマイザではありませんが、他のコンポーネントのツールとして使用されます。
ASTをトラバースしながら、各変数の現在の値を追跡します（その値がmovableな式である限り）。
各変数に現在割り当てられている式の一部である変数を記録します。
変数 ``a`` に代入されるたびに、 ``a`` の現在の格納値が更新され、 ``a`` が ``b`` の現在格納されている式の一部であるときは、すべての変数 ``b`` のすべての格納値がクリアされます。

.. At control-flow joins, knowledge about variables is cleared if they have or would be assigned
.. in any of the control-flow paths. For instance, upon entering a
.. for loop, all variables are cleared that will be assigned during the
.. body or the post block.

コントロールフローの分岐点では、コントロールフローのいずれかの経路で代入された、または代入される可能性のある変数についての知識がクリアされます。
たとえば、forループに入ると、bodyまたはpostブロックで代入される予定のすべての変数がクリアされます。

式スケールの単純化
------------------

.. These simplification passes change expressions and replace them by equivalent
.. and hopefully simpler expressions.

これらの簡略化パスは、表現を変更し、同等の、できればより単純な表現に置き換えます。

.. _common-subexpression-eliminator:

CommonSubexpressionEliminator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. This step uses the Dataflow Analyzer and replaces subexpressions that
.. syntactically match the current value of a variable by a reference to
.. that variable. This is an equivalence transform because such subexpressions have
.. to be movable.

このステップでは、Dataflow Analyzer を使用して、構文的に変数の現在の値と一致する部分式を、その変数への参照に置き換えます。
このような部分式はmovableでなければならないため、これは等価変換です。

.. All subexpressions that are identifiers themselves are replaced by their
.. current value if the value is an identifier.

識別子であるすべての部分式は、その値が識別子である場合、現在の値で置き換えられます。

.. The combination of the two rules above allow to compute a local value
.. numbering, which means that if two variables have the same
.. value, one of them will always be unused. The Unused Pruner or the
.. Redundant Assign Eliminator will then be able to fully eliminate such
.. variables.

上記の2つのルールの組み合わせにより、ローカルな値のナンバリングを計算できます。
これは、2つの変数が同じ値を持つ場合、そのうちの1つは常に使用されないことを意味します。
Unused PrunerやRedundant Assign Eliminatorは、このような変数を完全に排除できます。

.. This step is especially efficient if the expression splitter is run
.. before. If the code is in pseudo-SSA form,
.. the values of variables are available for a longer time and thus we
.. have a higher chance of expressions to be replaceable.

このステップは、式分割機が前に実行されている場合、特に効率的です。
コードが疑似SSA形式であれば、変数の値はより長い時間利用可能であるため、式が置換可能になる可能性が高くなります。

.. The expression simplifier will be able to perform better replacements
.. if the common subexpression eliminator was run right before it.

式単純化装置は、その直前に共通部分式除去装置が実行されていれば、より良い置換を行うことができます。

.. _expression-simplifier:

ExpressionSimplifier
^^^^^^^^^^^^^^^^^^^^

.. The Expression Simplifier uses the Dataflow Analyzer and makes use
.. of a list of equivalence transforms on expressions like ``X + 0 -> X``
.. to simplify the code.

Expression Simplifierは、Dataflow Analyzerを使用し、 ``X + 0 -> X`` のような式に対する等価変換のリストを利用してコードを単純化します。

.. It tries to match patterns like ``X + 0`` on each subexpression.
.. During the matching procedure, it resolves variables to their currently
.. assigned expressions to be able to match more deeply nested patterns
.. even when the code is in pseudo-SSA form.

``X + 0``  のようなパターンを各部分式でマッチさせようとします。
また、コードが疑似SSA形式であっても、より深い入れ子のパターンにマッチできるように、マッチング処理中に変数を現在割り当てられている式に解決します。

.. Some of the patterns like ``X - X -> 0`` can only be applied as long
.. as the expression ``X`` is movable, because otherwise it would remove its potential side-effects.
.. Since variable references are always movable, even if their current
.. value might not be, the Expression Simplifier is again more powerful
.. in split or pseudo-SSA form.

``X - X -> 0`` のようないくつかのパターンは、式 ``X`` がmovableである限り適用できます。
そうでなければ、その潜在的な副作用を取り除くことになるからです。
変数参照は、現在の値がそうでないかもしれないとしても、常にmovableであるため、式の簡略化は、分割または疑似SSAの形で再び強力になります。

.. _literal-rematerialiser:

LiteralRematerialiser
^^^^^^^^^^^^^^^^^^^^^

.. To be documented.

ドキュメント化予定。

.. _load-resolver:

LoadResolver
^^^^^^^^^^^^

.. Optimisation stage that replaces expressions of type ``sload(x)`` and ``mload(x)`` by the value
.. currently stored in storage resp. memory, if known.

``sload(x)`` 型と ``mload(x)`` 型の式を、現在ストレージやメモリに格納されている値で置き換える最適化ステージ。

コードがSSA形式の場合に最適です。

前提条件: Disambiguator、ForLoopInitRewriter。

.. _reasoning-based-simplifier:

ReasoningBasedSimplifier
^^^^^^^^^^^^^^^^^^^^^^^^

.. This optimizer uses SMT solvers to check whether ``if`` conditions are constant.

このオプティマイザはSMTソルバーを用いて、 ``if`` 条件が一定であるかどうかをチェックします。

.. - If ``constraints AND condition`` is UNSAT, the condition is never true and the whole body can be removed.
.. - If ``constraints AND NOT condition`` is UNSAT, the condition is always true and can be replaced by ``1``.

- ``constraints AND condition`` がUNSATの場合、その条件は決して真ではなく、本体ごと取り外すことができます。

- ``constraints AND NOT condition`` がUNSATの場合、条件は常に真であり、 ``1`` で置き換えることができます。

.. The simplifications above can only be applied if the condition is movable.

上記の簡略化は、条件が可動式の場合にのみ適用できます。

.. It is only effective on the EVM dialect, but safe to use on other dialects.

EVMの方言にのみ効果がありますが、他の方言には安全に使用できます。

前提条件: Disambiguator、SSATransform。

文スケールの単純化
------------------

.. _circular-reference-pruner:

CircularReferencesPruner
^^^^^^^^^^^^^^^^^^^^^^^^

.. This stage removes functions that call each other but are
.. neither externally referenced nor referenced from the outermost context.

このステージでは、相互に呼び出しているが、外部から参照されておらず、一番外側のコンテキストからも参照されていない関数を削除します。

.. _conditional-simplifier:

ConditionalSimplifier
^^^^^^^^^^^^^^^^^^^^^

.. The Conditional Simplifier inserts assignments to condition variables if the value can be determined
.. from the control-flow.

条件付きシンプリファイアは、コントロールフローから値が決定できる場合、条件変数への割り当てを挿入します。

.. Destroys SSA form.

SSAフォームを破棄します。

.. Currently, this tool is very limited, mostly because we do not yet have support for boolean types.
.. Since conditions only check for expressions being nonzero, we cannot assign a specific value.

現在のところ、このツールは非常に限定されています。
主な理由は、ブーリアン型をまだサポートしていないからです。
条件は式がゼロでないことをチェックするだけなので、特定の値を割り当てることはできません。

現在の機能:

.. - switch cases: insert "<condition> := <caseLabel>"
.. - after if statement with terminating control-flow, insert "<condition> := 0"

- スイッチケースで「<condition> := <caseLabel>」を挿入します。
- 終了コントロールフローのif文の後に、「<条件> := 0」を挿入します。

今後の機能:

.. - allow replacements by "1"
.. - take termination of user-defined functions into account

- 「1」による置き換えを可能にします。
- ユーザー定義関数の終了を考慮に入れます。

.. Works best with SSA form and if dead code removal has run before.

SSA形式で、かつデッドコード除去を実行したことがある場合に最適です。

前提条件: Disambiguator。

.. _conditional-unsimplifier:

ConditionalUnsimplifier
^^^^^^^^^^^^^^^^^^^^^^^

.. Reverse of Conditional Simplifier.

Conditional Simplifierの逆。

.. _control-flow-simplifier:

ControlFlowSimplifier
^^^^^^^^^^^^^^^^^^^^^

いくつかのコントロールフロー構造を簡素化をします:

.. - replace switch with only default case with pop(expression) and body
.. - replace switch with const expr with matching case body
.. - replace ``for`` with terminating control flow and without other break/continue by ``if``

- pop(condition)でifを空のボディに置き換える
- 空のデフォルトのスイッチケースを削除する
- デフォルトのケースが存在しない場合、空のスイッチケースを削除する
- ケースのないswitchをpop(expression)で置き換える
- シングルケースのスイッチをifに変える
- pop(expression)とbodyでデフォルトケースのみのswitchに変更する
- スイッチを、ケースボディが一致するconst exprに置き換える
- ``for`` を終端コントロールフローに置き換える、 ``if`` による他のブレーク/コンティニューなしで
- 関数の最後にある ``leave`` を削除する

.. None of these operations depend on the data flow. The StructuralSimplifier
.. performs similar tasks that do depend on data flow.

これらの操作はいずれもデータフローには依存しません。
StructuralSimplifierは、データフローに依存する同様のタスクを実行します。

.. The ControlFlowSimplifier does record the presence or absence of ``break``
.. and ``continue`` statements during its traversal.

ControlFlowSimplifierは、トラバーサル中に ``break`` 文と ``continue`` 文の有無を記録します。

前提条件: Disambiguator、FunctionHoister、ForLoopInitRewriter。

重要: EVMオペコードを導入しているため、現在はEVMコードにのみ使用可能です。

.. _dead-code-eliminator:

DeadCodeEliminator
^^^^^^^^^^^^^^^^^^

この最適化ステージでは、到達できないコードを削除します。

.. Unreachable code is any code within a block which is preceded by a leave, return, invalid, break, continue, selfdestruct, revert or by a call to a user-defined function that recurses infinitely.

到達不可能なコードとは、ブロック内のコードのうち、leave、return、invalid、break、continue、selfdestruct、revert、または無限に再帰するユーザー定義関数の呼び出しが先行するものを指します。

.. Function definitions are retained as they might be called by earlier
.. code and thus are considered reachable.

関数定義は、以前のコードから呼び出される可能性があるため、到達可能とみなされて保持されます。

.. Because variables declared in a for loop's init block have their scope extended to the loop body,
.. we require ForLoopInitRewriter to run before this step.

forループのinitブロックで宣言された変数は、そのスコープがループ本体にまで及ぶため、このステップの前にForLoopInitRewriterを実行する必要があります。

前提条件: ForLoopInitRewriter、Function Hoister、Function Grouper。

.. _equal-store-eliminator:

EqualStoreEliminator
^^^^^^^^^^^^^^^^^^^^

.. This steps removes ``mstore(k, v)`` and ``sstore(k, v)`` calls if there was a previous call to ``mstore(k, v)`` / ``sstore(k, v)``, no other store in between and the values of ``k`` and ``v`` did not change.

このステップは、 ``mstore(k, v)`` / ``sstore(k, v)`` の呼び出しが過去にあり、その間に他のストアがなく、 ``k`` と ``v`` の値が変更されていない場合に、 ``mstore(k, v)`` と ``sstore(k, v)`` の呼び出しを削除します。

.. This simple step is effective if run after the SSA transform and the Common Subexpression Eliminator, because SSA will make sure that the variables will not change and the Common Subexpression Eliminator re-uses exactly the same variable if the value is known to be the same.

この単純なステップは、SSA変換とCommon Subexpression Eliminatorの後に実行すると効果的です。
SSAは変数が変更されないことを確認し、Common Subexpression Eliminatorは値が同じであることが分かっている場合、まったく同じ変数を再利用するからです。

前提条件: Disambiguator、ForLoopInitRewriter。

.. _unused-pruner:

UnusedPruner
^^^^^^^^^^^^

このステップでは、参照されることのないすべての関数の定義を削除します。

.. It also removes the declaration of variables that are never referenced.
.. If the declaration assigns a value that is not movable, the expression is retained,
.. but its value is discarded.

また、決して参照されない変数の宣言も削除されます。
宣言が移動不可能な値を割り当てている場合、式は保持されますが、その値は破棄されます。

.. All movable expression statements (expressions that are not assigned) are removed.

movableな式の文（割り当てられていない式）はすべて削除されます。

.. _structural-simplifier:

StructuralSimplifier
^^^^^^^^^^^^^^^^^^^^

.. This is a general step that performs various kinds of simplifications on
.. a structural level:

これは、構造的なレベルで様々な種類の単純化を行う一般的なステップです。

.. - replace switch with only default case by ``pop(expression)`` and body
.. - replace switch with literal expression by matching case body
.. - replace for loop with false condition by its initialization part

- if文を ``pop(condition)`` による空のボディに置き換える
- 真の条件を持つif文をそのボディで置き換える
- 偽の条件を持つif文は削除する
- シングルケースのスイッチをifに変える
- スイッチを ``pop(expression)`` とボディのデフォルトケースのみに置き換える
- 大文字小文字を一致させてスイッチをリテラル表現に置き換える
- 偽条件のforループを初期化部分で置き換える

.. This component uses the Dataflow Analyzer.

このコンポーネントは、Dataflow Analyzerを使用します。

.. _block-flattener:

BlockFlattener
^^^^^^^^^^^^^^

.. This stage eliminates nested blocks by inserting the statement in the
.. inner block at the appropriate place in the outer block. It depends on the
.. FunctionGrouper and does not flatten the outermost block to keep the form
.. produced by the FunctionGrouper.

このステージでは、内側のブロックの文を外側のブロックの適切な場所に挿入することで、入れ子になったブロックを解消します。
このステージはFunctionGrouperに依存しており、FunctionGrouperによって生成されたフォームを維持するために、一番外側のブロックをフラットにしません。

.. code-block:: yul

    {
        {
            let x := 2
            {
                let y := 3
                mstore(x, y)
            }
        }
    }

は、次の処理に変換されます。

.. code-block:: yul

    {
        {
            let x := 2
            let y := 3
            mstore(x, y)
        }
    }

.. As long as the code is disambiguated, this does not cause a problem because
.. the scopes of variables can only grow.

曖昧さを排除したコードであれば、変数のスコープは大きくなる一方なので、問題はありません。

.. _loop-invariant-code-motion:

LoopInvariantCodeMotion
^^^^^^^^^^^^^^^^^^^^^^^
.. This optimization moves movable SSA variable declarations outside the loop.

この最適化により、移動可能なSSA変数の宣言はループの外側に移動します。

.. Only statements at the top level in a loop's body or post block are considered, i.e variable
.. declarations inside conditional branches will not be moved out of the loop.

考慮されるのは、ループの本体またはポストブロック内のトップレベルの文のみです。
つまり、条件分岐内の変数宣言はループの外に移動されません。

要件:

- Disambiguator、ForLoopInitRewriter、FunctionHoisterは前もって実行する必要があります。
- より良い結果を得るためには、ExpressionSplitterとSSAトランスフォームを前もって実行する必要があります。

関数レベルの最適化
------------------

.. _function-specializer:

FunctionSpecializer
^^^^^^^^^^^^^^^^^^^

.. This step specializes the function with its literal arguments.

このステップでは、関数をリテラルの引数で特殊化します。

.. If a function, say, ``function f(a, b) { sstore (a, b) }``, is called with literal arguments, for
.. example, ``f(x, 5)``, where ``x`` is an identifier, it could be specialized by creating a new
.. function ``f_1`` that takes only one argument, i.e.,

例えば ``function f(a, b) { sstore (a, b) }`` という関数が、例えば ``f(x, 5)`` というリテラルの引数で呼ばれ、 ``x`` が識別子である場合、1つの引数しか取らない ``f_1`` という新しい関数を作ることで、特化できます。

.. code-block:: yul

    function f_1(a_1) {
        let b_1 := 5
        sstore(a_1, b_1)
    }

.. Other optimization steps will be able to make more simplifications to the function. The
.. optimization step is mainly useful for functions that would not be inlined.

他の最適化ステップでは、関数をより単純化できます。
最適化ステップは、主にインライン化されないような関数に有効です。

前提条件: Disambiguator、FunctionHoister。

.. LiteralRematerialiser is recommended as a prerequisite, even though it's not required for
.. correctness.

LiteralRematerialiserは、正しさのために必要ではないにもかかわらず、前提条件として推奨されています。

.. _unused-function-parameter-pruner:

UnusedFunctionParameterPruner
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

このステップでは、関数内の未使用のパラメータを削除します。

.. If a parameter is unused, like ``c`` and ``y`` in, ``function f(a,b,c) -> x, y { x := div(a,b) }``, we
.. remove the parameter and create a new "linking" function as follows:

``c`` と ``y`` が ``function f(a,b,c) -> x, y { x := div(a,b) }`` になっているように、パラメータが使われていない場合は、パラメータを削除して、次のように新しい「リンク」関数を作成します。

.. code-block:: yul

    function f(a,b) -> x { x := div(a,b) }
    function f2(a,b,c) -> x, y { x := f(a,b) }

.. and replace all references to ``f`` by ``f2``.
.. The inliner should be run afterwards to make sure that all references to ``f2`` are replaced by
.. ``f``.

そして、 ``f`` へのすべての参照を ``f2`` に置き換えます。
インライナーは、その後に実行して、 ``f2`` へのすべての参照が ``f`` に置き換えられていることを確認する必要があります。

前提条件: Disambiguator、FunctionHoister、LiteralRematerialiser。

.. The step LiteralRematerialiser is not required for correctness. It helps deal with cases such as:
.. ``function f(x) -> y { revert(y, y} }`` where the literal ``y`` will be replaced by its value ``0``,
.. allowing us to rewrite the function.

LiteralRematerialiserというステップは正しさのために必要ではありません。
以下のようなケースに対処するのに役立ちます。
``function f(x) -> y { revert(y, y} }`` はリテラル ``y`` がその値 ``0`` に置き換えられるので、関数を書き換えることができます。

.. index:: ! unused store eliminator
.. _unused-store-eliminator:

UnusedStoreEliminator
^^^^^^^^^^^^^^^^^^^^^

.. Optimizer component that removes redundant ``sstore`` and memory store statements.
.. In case of an ``sstore``, if all outgoing code paths revert (due to an explicit ``revert()``, ``invalid()``, or infinite recursion) or lead to another ``sstore`` for which the optimizer can tell that it will overwrite the first store, the statement will be removed.
.. However, if there is a read operation between the initial ``sstore`` and the revert, or the overwriting ``sstore``, the statement will not be removed.
.. Such read operations include: external calls, user-defined functions with any storage access, and ``sload`` of a slot that cannot be proven to differ from the slot written by the initial ``sstore``.

冗長な ``sstore`` ステートメントやメモリストアステートメントを削除するオプティマイザーコンポーネントです。
ストア ``sstore`` の場合、（明示的な ``revert()`` 、 ``invalid()`` 、または無限再帰によって）すべての出力コードパスがリバートするか、オプティマイザが最初のストアを上書きすると判断できる別の ``sstore`` につながる場合、ステートメントは削除されます。
しかし、最初の ``sstore`` とリバート、または上書きされる ``sstore`` の間に読み取り操作がある場合、ステートメントは削除されません。
このような読み取り操作には、外部呼び出し、ストレージにアクセスするユーザー定義関数、最初の ``sstore`` が書き込んだスロットと異なることを証明できないスロットの ``sload`` が含まれます。

例えば、次のコードは、

.. code-block:: yul

    {
        let c := calldataload(0)
        sstore(c, 1)
        if c {
            sstore(c, 2)
        }
        sstore(c, 3)
    }

.. will be transformed into the code below after the Unused Store Eliminator step is run

Unused Store Eliminatorステップが実行されると、以下のコードに変換されます。

.. code-block:: yul

    {
        let c := calldataload(0)
        if c { }
        sstore(c, 3)
    }

.. For memory store operations, things are generally simpler, at least in the outermost yul block as all such statements will be removed if they are never read from in any code path.
.. At function analysis level, however, the approach is similar to ``sstore``, as we do not know whether the memory location will be read once we leave the function's scope, so the statement will be removed only if all code paths lead to a memory overwrite.

メモリストア操作の場合、一般的には、少なくとも一番外側のYulブロックでは、そのようなステートメントは、どのコードパスでも読み込まれることがなければ、すべて削除されるので単純です。
しかし、関数解析レベルでは、関数のスコープを離れるとメモリロケーションが読み込まれるかどうかわからないので、ステートメントはすべてのコードパスがメモリの上書きにつながる場合にのみ削除されます。

.. Best run in SSA form.

SSA形式で最も効果があります。

前提条件: Disambiguator、ForLoopInitRewriter。

.. _equivalent-function-combiner:

EquivalentFunctionCombiner
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. If two functions are syntactically equivalent, while allowing variable
.. renaming but not any re-ordering, then any reference to one of the
.. functions is replaced by the other.

2つの関数が構文的に同等で、変数名の変更は可能だが順序変更はできない場合、一方の関数への参照は他方の関数で置き換えられます。

実際に関数を取り除くのは、Unused Prunerが行います。

関数のインライン化
------------------

.. _expression-inliner:

ExpressionInliner
^^^^^^^^^^^^^^^^^

オプティマイザのこのコンポーネントは、関数式の中にあるインライン化できる関数、つまり以下のような関数をインライン化することで、制限付きの関数のインライン化を行います。

- 単一の値を返す
- ``r := <functional expression>`` のようなボディを持つ
- 自分自身も ``r`` も右辺で参照しない

さらに、すべてのパラメータについて、以下のすべてが真である必要があります。

- 引数がmovableである
- パラメータの参照回数が関数ボディ内で2回以下であるか、または引数のコストがかなり低い（"コスト"は最大でも1で、0xffまでの定数のようなもの）

.. Example: The function to be inlined has the form of ``function f(...) -> r { r := E }`` where
.. ``E`` is an expression that does not reference ``r`` and all arguments in the function call are movable expressions.

例: インライン化される関数は ``function f(...) -> r { r := E }`` という形式で、 ``E`` は ``r`` を参照していない式で、関数呼び出しのすべての引数はmovableな式です。

.. The result of this inlining is always a single expression.

このインライン化の結果は、常に単一の式となります。

.. This component can only be used on sources with unique names.

このコンポーネントは、固有の名前を持つソースにのみ使用できます。

.. _full-inliner:

FullInliner
^^^^^^^^^^^

.. The Full Inliner replaces certain calls of certain functions
.. by the function's body. This is not very helpful in most cases, because
.. it just increases the code size but does not have a benefit. Furthermore,
.. code is usually very expensive and we would often rather have shorter
.. code than more efficient code. In same cases, though, inlining a function
.. can have positive effects on subsequent optimizer steps. This is the case
.. if one of the function arguments is a constant, for example.

Full Inlinerでは、特定の関数の特定の呼び出しを関数の本体に置き換えています。
これはコードサイズが大きくなるだけでメリットがないため、ほとんどの場合あまり役に立ちません。
さらに、コードは通常非常に高価なものであり、効率の良いコードよりも短いコードの方が良い場合が多いのです。
しかし、同じようなケースでは、関数のインライン化が後続のオプティマイザのステップにプラスの効果をもたらすことがあります。
例えば、関数の引数の1つが定数の場合がそうです。

.. During inlining, a heuristic is used to tell if the function call
.. should be inlined or not.
.. The current heuristic does not inline into "large" functions unless
.. the called function is tiny. Functions that are only used once
.. are inlined, as well as medium-sized functions, while function
.. calls with constant arguments allow slightly larger functions.

インライン化の際には、関数呼び出しをインライン化すべきかどうかを判断するヒューリスティックな手法が用いられます。
現在のヒューリスティックでは、呼び出される関数が小さなものでない限り、「大きな」関数にはインライン化されません。
一度しか使用されない関数はインライン化され、中規模の関数もインライン化されますが、定数の引数を持つ関数呼び出しでは少し大きな関数が使用できます。

.. In the future, we may include a backtracking component
.. that, instead of inlining a function right away, only specializes it,
.. which means that a copy of the function is generated where
.. a certain parameter is always replaced by a constant. After that,
.. we can run the optimizer on this specialized function. If it
.. results in heavy gains, the specialized function is kept,
.. otherwise the original function is used instead.

将来は、関数をすぐにインライン化するのではなく、関数を特殊化するバックトラックコンポーネントを組み込むことも考えています。
その後、この特殊化された関数に対してオプティマイザを実行します。
その結果、大きな利益が得られた場合は、特化された関数を残し、そうでない場合は元の関数を代わりに使用します。

クリーンアップ
--------------

.. The cleanup is performed at the end of the optimizer run. It tries
.. to combine split expressions into deeply nested ones again and also
.. improves the "compilability" for stack machines by eliminating
.. variables as much as possible.

クリーンアップは、オプティマイザの実行の最後に行われます。
分割された式を再び深く入れ子にして結合しようとしたり、変数を極力排除してスタックマシンでの「コンパイル性」を向上させたりします。

.. _expression-joiner:

ExpressionJoiner
^^^^^^^^^^^^^^^^

.. This is the opposite operation of the expression splitter. It turns a sequence of
.. variable declarations that have exactly one reference into a complex expression.
.. This stage fully preserves the order of function calls and opcode executions.
.. It does not make use of any information concerning the commutativity of the opcodes;
.. if moving the value of a variable to its place of use would change the order
.. of any function call or opcode execution, the transformation is not performed.

これは、式分割器とは逆の動作です。
正確に1つの参照を持つ変数宣言のシーケンスを複雑な式に変えます。
このステージでは、関数の呼び出しとオペコードの実行の順序が完全に保持されます。
オペコードの可換性に関する情報は利用しません。
変数の値を使用する場所に移動することで、関数呼び出しやオペコードの実行順序が変わる場合は、変換を行いません。

.. Note that the component will not move the assigned value of a variable assignment
.. or a variable that is referenced more than once.

ただし、変数の代入や複数回参照されている変数の代入値は、コンポーネントでは移動しません。

.. The snippet ``let x := add(0, 2) let y := mul(x, mload(2))`` is not transformed,
.. because it would cause the order of the call to the opcodes ``add`` and
.. ``mload`` to be swapped - even though this would not make a difference
.. because ``add`` is movable.

スニペット ``let x := add(0, 2) let y := mul(x, mload(2))`` は変換されません。
オペコード ``add`` と ``mload`` の呼び出し順序が入れ替わってしまうからです。
ただし、 ``add`` はmovableなので違いはありません。

.. When reordering opcodes like that, variable references and literals are ignored.
.. Because of that, the snippet ``let x := add(0, 2) let y := mul(x, 3)`` is
.. transformed to ``let y := mul(add(0, 2), 3)``, even though the ``add`` opcode
.. would be executed after the evaluation of the literal ``3``.

このようにオペコードを並び替える場合、変数参照やリテラルは無視されます。
そのため、リテラル ``3`` の評価後に ``add`` のオペコードが実行されるにもかかわらず、スニペット ``let x := add(0, 2) let y := mul(x, 3)`` は ``let y := mul(add(0, 2), 3)`` に変換されてしまいます。

.. _SSA-reverser:

SSAReverser
^^^^^^^^^^^

.. This is a tiny step that helps in reversing the effects of the SSA transform if it is combined with the Common Subexpression Eliminator and the Unused Pruner.

これは、Common Subexpression EliminatorやUnused Prunerと組み合わせることで、SSAトランスフォームの効果を元に戻すのに役立つ小さな一歩です。

.. The SSA form we generate is detrimental to code generation on the EVM and
.. WebAssembly alike because it generates many local variables. It would
.. be better to just re-use existing variables with assignments instead of
.. fresh variable declarations.

私たちが生成するSSAフォームは、多くのローカル変数を生成するため、EVMやWebAssemblyでのコード生成に悪影響を及ぼします。
新しい変数を宣言する代わりに、既存の変数を代入して再利用する方が良いでしょう。

SSAトランスフォームは、

.. code-block:: yul

    let a := calldataload(0)
    mstore(a, 1)

を、次の処理に書き換えます。

.. code-block:: yul

    let a_1 := calldataload(0)
    let a := a_1
    mstore(a_1, 1)
    let a_2 := calldataload(0x20)
    a := a_2

.. The problem is that instead of ``a``, the variable ``a_1`` is used
.. whenever ``a`` was referenced. The SSA transform changes statements
.. of this form by just swapping out the declaration and the assignment. The above
.. snippet is turned into

問題は、 ``a`` が参照されるたびに、 ``a`` の代わりに ``a_1`` という変数が使われることです。
SSAトランスフォームでは、このような形式の文を、宣言と代入を入れ替えるだけで変更します。
上のスニペットは次のように変わります。

.. code-block:: yul

    let a := calldataload(0)
    let a_1 := a
    mstore(a_1, 1)
    a := calldataload(0x20)
    let a_2 := a

.. This is a very simple equivalence transform, but when we now run the
.. Common Subexpression Eliminator, it will replace all occurrences of ``a_1``
.. by ``a`` (until ``a`` is re-assigned). The Unused Pruner will then
.. eliminate the variable ``a_1`` altogether and thus fully reverse the
.. SSA transform.

これは非常に単純な同値変換ですが、次にCommon Subexpression Eliminatorを実行すると、 ``a_1`` のすべての出現箇所が ``a`` に置き換えられます（ ``a`` が再割り当てされるまで）。
その後、Unused Prunerが変数 ``a_1`` を完全に除去し、SSAトランスフォームを完全に逆にします。

.. _stack-compressor:

StackCompressor
^^^^^^^^^^^^^^^

.. One problem that makes code generation for the Ethereum Virtual Machine
.. hard is the fact that there is a hard limit of 16 slots for reaching
.. down the expression stack. This more or less translates to a limit
.. of 16 local variables. The stack compressor takes Yul code and
.. compiles it to EVM bytecode. Whenever the stack difference is too
.. large, it records the function this happened in.

Ethereum Virtual Machineのコード生成を難しくしている問題の1つは、式スタックを下にたどり着くためのスロットが16個という厳しい制限があることです。
これは多かれ少なかれ、16個のローカル変数に制限があることに通じます。
スタックコンプレッサは、YulのコードをEVMバイトコードにコンパイルします。
スタックの差が大きくなると、この現象がどの関数で起きたかを記録します。

.. For each function that caused such a problem, the Rematerialiser
.. is called with a special request to aggressively eliminate specific
.. variables sorted by the cost of their values.

このような問題を起こした関数ごとに、Rematerialiserに特別な依頼をして、値のコスト順にソートされた特定の変数を積極的に排除してもらいます。

失敗した場合は、この手続きを複数回繰り返します。

.. _rematerialiser:

Rematerialiser
^^^^^^^^^^^^^^

.. The rematerialisation stage tries to replace variable references by the expression that
.. was last assigned to the variable. This is of course only beneficial if this expression
.. is comparatively cheap to evaluate. Furthermore, it is only semantically equivalent if
.. the value of the expression did not change between the point of assignment and the
.. point of use. The main benefit of this stage is that it can save stack slots if it
.. leads to a variable being eliminated completely (see below), but it can also
.. save a DUP opcode on the EVM if the expression is very cheap.

再物質化ステージでは、変数の参照を、その変数に最後に割り当てられた式で置き換えようとします。
これはもちろん、この式が比較的安価に評価できる場合にのみ有益です。
さらに、代入時点と使用時点の間で式の値が変化していない場合にのみ、意味的に等価となります。
このステージの主な利点は、変数を完全に排除することにつながる場合、スタックスロットを節約できることですが（後述）、式が非常に安価な場合、EVM上のDUPオペコードを節約することもできます。

.. The Rematerialiser uses the Dataflow Analyzer to track the current values of variables,
.. which are always movable.
.. If the value is very cheap or the variable was explicitly requested to be eliminated,
.. the variable reference is replaced by its current value.

Rematerialiserは、Dataflow Analyzerを使用して、常にmovableな変数の現在の値を追跡します。
値が非常に安い場合や、変数の削除が明示的に要求された場合、変数の参照はその現在の値で置き換えられます。

.. _for-loop-condition-out-of-body:

ForLoopConditionOutOfBody
^^^^^^^^^^^^^^^^^^^^^^^^^

ForLoopConditionIntoBodyの変換の逆です。

.. For any movable ``c``, it turns

どのようなmovableな ``c`` に対しても、

.. code-block:: none

    for { ... } 1 { ... } {
    if iszero(c) { break }
    ...
    }


を、

.. code-block:: none

    for { ... } c { ... } {
    ...
    }

にし、また、

.. code-block:: none

    for { ... } 1 { ... } {
    if c { break }
    ...
    }

を、

.. code-block:: none

    for { ... } iszero(c) { ... } {
    ...
    }

にします。

LiteralRematerialiserは、このステップの前に実行する必要があります。

WebAssembly特有
---------------

MainFunction
^^^^^^^^^^^^

一番上のブロックを、入力も出力も持たない特定の名前（"main"）を持つ関数に変更します。

Function Grouperに依存します。
