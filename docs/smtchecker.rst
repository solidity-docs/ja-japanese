.. _formal_verification:

####################
SMTCheckerと形式検証
####################

.. Using formal verification it is possible to perform an automated mathematical proof that your source code fulfills a certain formal specification.
.. The specification is still formal (just as the source code), but usually much simpler.

形式検証とは、ソースコードがある形式的な仕様を満たしていることを、自動的に数学的に証明することです。
仕様はソースコードと同様に形式的なものですが、通常はよりシンプルなものになります。

.. Note that formal verification itself can only help you understand the difference between what you did (the specification) and how you did it (the actual implementation).
.. You still need to check whether the specification is what you wanted and that you did not miss any unintended effects of it.

形式検証は、「何をしたか（仕様）」と「どのようにしたか（実際の実装）」の違いを理解するためのものでしかないことに注意してください。
仕様が望んだものになっているかどうか、意図しない効果を見逃していないかどうかを確認する必要があります。

.. Solidity implements a formal verification approach based on `SMT (Satisfiability Modulo Theories) <https://en.wikipedia.org/wiki/Satisfiability_modulo_theories>`_ and `Horn <https://en.wikipedia.org/wiki/Horn-satisfiability>`_ solving.
.. The SMTChecker module automatically tries to prove that the code satisfies the specification given by ``require`` and ``assert`` statements.
.. That is, it considers ``require`` statements as assumptions and tries to prove that the conditions inside ``assert`` statements are always true.
.. If an assertion failure is found, a counterexample may be given to the user showing how the assertion can be violated.
.. If no warning is given by the SMTChecker for a property, it means that the property is safe.

Solidityでは、 `SMT (Satisfiability Modulo Theories) <https://en.wikipedia.org/wiki/Satisfiability_modulo_theories>`_ と `Horn <https://en.wikipedia.org/wiki/Horn-satisfiability>`_ の解法に基づいた形式的な検証アプローチを実装しています。
SMTCheckerモジュールは、 ``require`` 文と ``assert`` 文で与えられた仕様をコードが満たしていることを自動的に証明しようとします。
つまり、 ``require`` 文を仮定とみなし、 ``assert`` 文の中の条件が常に真であることを証明しようとします。
アサーションの失敗が発見された場合、アサーションがどのように破られるかを示す反例がユーザーに与えられます。
SMTCheckerがあるプロパティに対して警告を出さない場合、そのプロパティは安全であることを意味します。

.. The other verification targets that the SMTChecker checks at compile time are:

SMTCheckerがコンパイル時にチェックするその他の検証対象は以下の通りです。

.. - Arithmetic underflow and overflow.

- 算術演算のアンダーフローとオーバーフロー。

.. - Division by zero.

- ゼロによる除算。

.. - Trivial conditions and unreachable code.

- トリビアルな条件と到達不可能なコード。

.. - Popping an empty array.

- 空の配列のポップ。

.. - Out of bounds index access.

- 範囲外のインデックスアクセス。

.. - Insufficient funds for a transfer.

- 送金に必要な資金の不足。

.. All the targets above are automatically checked by default if all engines are
.. enabled, except underflow and overflow for Solidity >=0.8.7.

上記のターゲットは、Solidity >=0.8.7のunderflowとoverflowを除き、すべてのエンジンが有効な場合、デフォルトで自動的にチェックされます。

.. The potential warnings that the SMTChecker reports are:

SMTCheckerが報告する潜在的な警告は次のとおりです。

.. - ``<failing  property> happens here.``. This means that the SMTChecker proved that a certain property fails. A counterexample may be given, however in complex situations it may also not show a counterexample. This result may also be a false positive in certain cases, when the SMT encoding adds abstractions for Solidity code that is either hard or impossible to express.

- ``<failing  property> happens here.`` です。
  これは、SMTCheckerがあるプロパティが失敗することを証明したことを意味します。
  反例が示されることもありますが、複雑な状況では反例が示されないこともあります。
  この結果は、SMTエンコーディングが、表現が困難または不可能なSolidityコードの抽象化を追加する場合、特定のケースでは誤検出となることもあります。

.. - ``<failing property> might happen here``. This means that the solver could not prove either case within the given timeout. Since the result is unknown, the SMTChecker reports the potential failure for soundness. This may be solved by increasing the query timeout, but the problem might also simply be too hard for the engine to solve.

- ``<failing property> might happen here`` です。
  これは、ソルバーが与えられたタイムアウト内にどちらのケースも証明できなかったことを意味します。
  結果は不明なので、SMTCheckerは健全性のために潜在的な失敗を報告します。
  これは、クエリのタイムアウトを増やすことで解決できるかもしれませんが、問題が単にエンジンにとって難しすぎるだけかもしれません。

.. To enable the SMTChecker, you must select :ref:`which engine should run<smtchecker_engines>`,
.. where the default is no engine. Selecting the engine enables the SMTChecker on all files.

SMTCheckerを有効にするには、デフォルトではエンジンなしとなっている :ref:`which engine should run<smtchecker_engines>` を選択する必要があります。
エンジンを選択すると、すべてのファイルでSMTCheckerが有効になります。

.. .. note::

..     Prior to Solidity 0.8.4, the default way to enable the SMTChecker was via
..     ``pragma experimental SMTChecker;`` and only the contracts containing the
..     pragma would be analyzed. That pragma has been deprecated, and although it
..     still enables the SMTChecker for backwards compatibility, it will be removed
..     in Solidity 0.9.0. Note also that now using the pragma even in a single file
..     enables the SMTChecker for all files.

.. note::

    Solidity 0.8.4以前では、SMTCheckerを有効にするデフォルトの方法は ``pragma experimental SMTChecker;`` を介したもので、プラグマを含むコントラクトのみが分析されました。
    このプラグマは非推奨となっており、後方互換性のためにSMTCheckerを有効にしていますが、Solidity 0.9.0では削除されます。
    また、1つのファイルでもプラグマを使用すると、すべてのファイルでSMTCheckerが有効になることに注意してください。

.. .. note::

..     The lack of warnings for a verification target represents an undisputed
..     mathematical proof of correctness, assuming no bugs in the SMTChecker and
..     the underlying solver. Keep in mind that these problems are
..     *very hard* and sometimes *impossible* to solve automatically in the
..     general case.  Therefore, several properties might not be solved or might
..     lead to false positives for large contracts. Every proven property should
..     be seen as an important achievement. For advanced users, see :ref:`SMTChecker Tuning <smtchecker_options>`
..     to learn a few options that might help proving more complex
..     properties.

.. note::

    検証対象に対して警告が出ないということは、SMTCheckerや基盤となるソルバーにバグがないことを前提とした、議論の余地のない正しさの数学的証明を意味します。
    これらの問題は、一般的なケースで自動的に解決することは *非常に難しく* 、時には *不可能* であることに留意してください。
    したがって、いくつかの特性は解決できないかもしれませんし、大規模なコントラクトでは誤検出につながるかもしれません。
    すべての証明されたプロパティは重要な成果であると考えるべきです。
    上級者向けには、 :ref:`SMTChecker Tuning <smtchecker_options>` を参照して、より複雑なプロパティを証明するのに役立ついくつかのオプションを学んでください。

**************
チュートリアル
**************

オーバーフロー
==============

.. code-block:: Solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0;

    contract Overflow {
        uint immutable x;
        uint immutable y;

        function add(uint x_, uint y_) internal pure returns (uint) {
            return x_ + y_;
        }

        constructor(uint x_, uint y_) {
            (x, y) = (x_, y_);
        }

        function stateAdd() public view returns (uint) {
            return add(x, y);
        }
    }

.. The contract above shows an overflow check example.
.. The SMTChecker does not check underflow and overflow by default for Solidity >=0.8.7,
.. so we need to use the command line option ``--model-checker-targets "underflow,overflow"``
.. or the JSON option ``settings.modelChecker.targets = ["underflow", "overflow"]``.
.. See :ref:`this section for targets configuration<smtchecker_targets>`.
.. Here, it reports the following:

上のコントラクトではオーバーフローチェックの例を示しています。
SMTCheckerはSolidity >=0.8.7ではデフォルトでアンダーフローとオーバーフローをチェックしないので、コマンドラインオプション ``--model-checker-targets "underflow,overflow"`` またはJSONオプション ``settings.modelChecker.targets = ["underflow", "overflow"]`` を使用する必要があります。
:ref:`this section for targets configuration<smtchecker_targets>` を参照してください。
ここでは、以下のように報告しています。

.. code-block:: text

    Warning: CHC: Overflow (resulting value larger than 2**256 - 1) happens here.
    Counterexample:
    x = 1, y = 115792089237316195423570985008687907853269984665640564039457584007913129639935
     = 0

    Transaction trace:
    Overflow.constructor(1, 115792089237316195423570985008687907853269984665640564039457584007913129639935)
    State: x = 1, y = 115792089237316195423570985008687907853269984665640564039457584007913129639935
    Overflow.stateAdd()
        Overflow.add(1, 115792089237316195423570985008687907853269984665640564039457584007913129639935) -- internal call
     --> o.sol:9:20:
      |
    9 |             return x_ + y_;
      |                    ^^^^^^^

.. If we add ``require`` statements that filter out overflow cases,
.. the SMTChecker proves that no overflow is reachable (by not reporting warnings):

オーバーフローのケースをフィルタリングする ``require`` 文を追加すると、SMTCheckerはオーバーフローに到達しないことを（警告を報告しないことで）証明します。

.. code-block:: Solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0;

    contract Overflow {
        uint immutable x;
        uint immutable y;

        function add(uint x_, uint y_) internal pure returns (uint) {
            return x_ + y_;
        }

        constructor(uint x_, uint y_) {
            (x, y) = (x_, y_);
        }

        function stateAdd() public view returns (uint) {
            require(x < type(uint128).max);
            require(y < type(uint128).max);
            return add(x, y);
        }
    }

.. Assert

アサート
========

.. An assertion represents an invariant in your code: a property that must be true
.. *for all transactions, including all input and storage values*, otherwise there is a bug.

アサーションとは、コードの不変性を表すもので、すべての入力値と保存値を含むすべてのトランザクションに対して*真でなければならないプロパティで、そうでなければバグがあることになります。

.. The code below defines a function ``f`` that guarantees no overflow.
.. Function ``inv`` defines the specification that ``f`` is monotonically increasing:
.. for every possible pair ``(a, b)``, if ``b > a`` then ``f(b) > f(a)``.
.. Since ``f`` is indeed monotonically increasing, the SMTChecker proves that our
.. property is correct. You are encouraged to play with the property and the function
.. definition to see what results come out!

以下のコードでは、オーバーフローしないことを保証する関数 ``f`` を定義しています。
関数 ``inv`` は、 ``f`` が単調増加であるという仕様を定義しています: すべての可能なペア ``(a, b)`` に対して、もし ``b > a`` ならば ``f(b) > f(a)`` です。
``f`` は確かに単調増加なので、SMTCheckerは我々の特性が正しいことを証明します。
この性質と関数の定義を使って、どんな結果が出るか試してみてください。

.. code-block:: Solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0;

    contract Monotonic {
        function f(uint x) internal pure returns (uint) {
            require(x < type(uint128).max);
            return x * 42;
        }

        function inv(uint a, uint b) public pure {
            require(b > a);
            assert(f(b) > f(a));
        }
    }

.. We can also add assertions inside loops to verify more complicated properties.
.. The following code searches for the maximum element of an unrestricted array of
.. numbers, and asserts the property that the found element must be greater or
.. equal every element in the array.

また、ループの中にアサーションを追加して、より複雑なプロパティを検証することもできます。
次のコードでは、制限のない数値の配列の最大要素を検索し、検索された要素は配列のすべての要素と同じかそれ以上でなければならないというプロパティをアサートしています。

.. code-block:: Solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0;

    contract Max {
        function max(uint[] memory a) public pure returns (uint) {
            uint m = 0;
            for (uint i = 0; i < a.length; ++i)
                if (a[i] > m)
                    m = a[i];

            for (uint i = 0; i < a.length; ++i)
                assert(m >= a[i]);

            return m;
        }
    }

.. Note that in this example the SMTChecker will automatically try to prove three properties:

この例では、SMTCheckerは自動的に3つのプロパティを証明しようとすることに注意してください。

.. 1. ``++i`` in the first loop does not overflow.

1. 最初のループの ``++i`` はオーバーフローしません。

.. 2. ``++i`` in the second loop does not overflow.

2. 2つ目のループの ``++i`` はオーバーフローしません。

.. 3. The assertion is always true.

3. アサーションは常に真です。

.. .. note::

..     The properties involve loops, which makes it *much much* harder than the previous
..     examples, so beware of loops!

.. note::

    プロパティにはループが含まれているため、これまでの例よりも*はるかに*難しくなっていますので、ループにご注意ください。

.. All the properties are correctly proven safe. Feel free to change the
.. properties and/or add restrictions on the array to see different results.
.. For example, changing the code to

すべてのプロパティの安全性が正しく証明されています。
プロパティを変更したり、配列に制限を加えることで、異なる結果を得ることができます。
例えば、コードを次のように変更すると

.. code-block:: Solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0;

    contract Max {
        function max(uint[] memory a) public pure returns (uint) {
            require(a.length >= 5);
            uint m = 0;
            for (uint i = 0; i < a.length; ++i)
                if (a[i] > m)
                    m = a[i];

            for (uint i = 0; i < a.length; ++i)
                assert(m > a[i]);

            return m;
        }
    }

.. gives us:

が与えてくれます。

.. code-block:: text

    Warning: CHC: Assertion violation happens here.
    Counterexample:

    a = [0, 0, 0, 0, 0]
     = 0

    Transaction trace:
    Test.constructor()
    Test.max([0, 0, 0, 0, 0])
      --> max.sol:14:4:
       |
    14 |            assert(m > a[i]);

ステートのプロパティ
====================

.. So far the examples only demonstrated the use of the SMTChecker over pure code,
.. proving properties about specific operations or algorithms.
.. A common type of properties in smart contracts are properties that involve the
.. state of the contract. Multiple transactions might be needed to make an assertion
.. fail for such a property.

これまでの例では、特定の操作やアルゴリズムに関するプロパティを証明する、純粋なコードに対するSMTCheckerの使用方法を示しただけでした。
スマートコントラクトにおける一般的なプロパティの種類は、コントラクトの状態に関わるプロパティです。
このようなプロパティについてアサーションを失敗させるには、複数のトランザクションが必要になる場合があります。

.. As an example, consider a 2D grid where both axis have coordinates in the range (-2^128, 2^128 - 1).
.. Let us place a robot at position (0, 0). The robot can only move diagonally, one step at a time,
.. and cannot move outside the grid. The robot's state machine can be represented by the smart contract
.. below.

例として、両軸の座標が(-2^128, 2^128 - 1)の範囲にある2Dグリッドを考えてみましょう。
ここで、ロボットを(0, 0)の位置に置きます。
ロボットは対角線上に1歩ずつしか移動できず、グリッドの外には出られません。
このロボットのステートマシンは、以下のスマートコントラクトで表すことができます。

.. code-block:: Solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0;

    contract Robot {
        int x = 0;
        int y = 0;

        modifier wall {
            require(x > type(int128).min && x < type(int128).max);
            require(y > type(int128).min && y < type(int128).max);
            _;
        }

        function moveLeftUp() wall public {
            --x;
            ++y;
        }

        function moveLeftDown() wall public {
            --x;
            --y;
        }

        function moveRightUp() wall public {
            ++x;
            ++y;
        }

        function moveRightDown() wall public {
            ++x;
            --y;
        }

        function inv() public view {
            assert((x + y) % 2 == 0);
        }
    }

.. Function ``inv`` represents an invariant of the state machine that ``x + y``
.. must be even.
.. The SMTChecker manages to prove that regardless how many commands we give the
.. robot, even if infinitely many, the invariant can *never* fail. The interested
.. reader may want to prove that fact manually as well.  Hint: this invariant is
.. inductive.

関数 ``inv`` は、 ``x + y`` が偶数でなければならないというステートマシンの不変量を表しています。
SMTCheckerは、ロボットにどんなに多くの命令を与えても、たとえ無限に与えても、不変量は*絶対に*失敗しないことを証明できます。
興味のある方は、手動でこの事実を証明することもできます。
ヒント: この不変量は帰納的なものです。

.. We can also trick the SMTChecker into giving us a path to a certain position we
.. think might be reachable.  We can add the property that (2, 4) is *not*
.. reachable, by adding the following function.

また、SMTCheckerを騙して、到達可能と思われるある位置までのパスを教えてもらうこともできます。
次のような関数を追加することで、(2, 4)は*not* reachableであるという性質を追加できます。

.. code-block:: Solidity

    function reach_2_4() public view {
        assert(!(x == 2 && y == 4));
    }

.. This property is false, and while proving that the property is false,
.. the SMTChecker tells us exactly *how* to reach (2, 4):

この性質は偽であり、SMTCheckerはこの性質が偽であることを証明しながら、(2, 4)に到達する方法を正確に*教えてくれます。

.. code-block:: text

    Warning: CHC: Assertion violation happens here.
    Counterexample:
    x = 2, y = 4

    Transaction trace:
    Robot.constructor()
    State: x = 0, y = 0
    Robot.moveLeftUp()
    State: x = (- 1), y = 1
    Robot.moveRightUp()
    State: x = 0, y = 2
    Robot.moveRightUp()
    State: x = 1, y = 3
    Robot.moveRightUp()
    State: x = 2, y = 4
    Robot.reach_2_4()
      --> r.sol:35:4:
       |
    35 |            assert(!(x == 2 && y == 4));
       |            ^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. Note that the path above is not necessarily deterministic, as there are
.. other paths that could reach (2, 4). The choice of which path is shown
.. might change depending on the used solver, its version, or just randomly.

なお、上の経路は必ずしも決定論的ではなく、(2, 4)に到達する経路は他にもあるので注意が必要です。
どの経路を表示するかは、使用するソルバーやそのバージョンによって変わるかもしれませんし、ランダムに表示されるかもしれません。

外部呼び出しとReentrancy
========================

.. Every external call is treated as a call to unknown code by the SMTChecker.
.. The reasoning behind that is that even if the code of the called contract is
.. available at compile time, there is no guarantee that the deployed contract
.. will indeed be the same as the contract where the interface came from at
.. compile time.

すべての外部呼び出しは、SMTCheckerによって未知のコードへの呼び出しとして扱われます。
その理由は、たとえ呼び出されたコントラクトのコードがコンパイル時に利用可能であったとしても、デプロイされたコントラクトが実際にコンパイル時にインターフェースの元となったコントラクトと同じであるという保証はないからです。

.. In some cases, it is possible to automatically infer properties over state
.. variables that are still true even if the externally called code can do
.. anything, including reenter the caller contract.

場合によっては、外部から呼び出されたコードが呼び出し元のコントラクトを再入力するなど、何をしても真である状態変数のプロパティを自動的に推論することも可能です。

.. code-block:: Solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0;

    interface Unknown {
        function run() external;
    }

    contract Mutex {
        uint x;
        bool lock;

        Unknown immutable unknown;

        constructor(Unknown u) {
            require(address(u) != address(0));
            unknown = u;
        }

        modifier mutex {
            require(!lock);
            lock = true;
            _;
            lock = false;
        }

        function set(uint x_) mutex public {
            x = x_;
        }

        function run() mutex public {
            uint xPre = x;
            unknown.run();
            assert(xPre == x);
        }
    }

.. The example above shows a contract that uses a mutex flag to forbid reentrancy.
.. The solver is able to infer that when ``unknown.run()`` is called, the contract
.. is already "locked", so it would not be possible to change the value of ``x``,
.. regardless of what the unknown called code does.

上の例では、ミューテックスフラグを使用して再入を禁止したコントラクトを示しています。
ソルバーは、 ``unknown.run()`` が呼び出されたとき、コントラクトはすでに「ロック」されているので、未知の呼び出されたコードが何をしようと、 ``x`` の値を変更できないだろうと推測できます。

.. If we "forget" to use the ``mutex`` modifier on function ``set``, the
.. SMTChecker is able to synthesize the behaviour of the externally called code so
.. that the assertion fails:

関数 ``set`` に ``mutex`` モディファイアを使うことを「忘れた」場合、SMTCheckerは外部から呼び出されたコードの振る舞いを合成し、アサーションが失敗するようにします。

.. code-block:: text

    Warning: CHC: Assertion violation happens here.
    Counterexample:
    x = 1, lock = true, unknown = 1

    Transaction trace:
    Mutex.constructor(1)
    State: x = 0, lock = false, unknown = 1
    Mutex.run()
        unknown.run() -- untrusted external call, synthesized as:
            Mutex.set(1) -- reentrant call
      --> m.sol:32:3:
       |
    32 | 		assert(xPre == x);
       | 		^^^^^^^^^^^^^^^^^

.. _smtchecker_options:

************************************
SMTCheckerのオプションとチューニング
************************************

タイムアウト
============

.. The SMTChecker uses a hardcoded resource limit (``rlimit``) chosen per solver,
.. which is not precisely related to time. We chose the ``rlimit`` option as the default
.. because it gives more determinism guarantees than time inside the solver.

SMTCheckerでは、ソルバーごとに選択されたハードコードされたリソース制限（ ``rlimit`` ）を使用していますが、これは時間とは正確には関係ありません。
``rlimit`` オプションをデフォルトとして選択したのは、ソルバー内部の時間よりも決定性の保証が得られるからです。

.. This options translates roughly to "a few seconds timeout" per query. Of course many properties
.. are very complex and need a lot of time to be solved, where determinism does not matter.
.. If the SMTChecker does not manage to solve the contract properties with the default ``rlimit``,
.. a timeout can be given in milliseconds via the CLI option ``--model-checker-timeout <time>`` or
.. the JSON option ``settings.modelChecker.timeout=<time>``, where 0 means no timeout.

このオプションを大まかに説明すると、1回のクエリにつき「数秒のタイムアウト」となります。
もちろん、多くのプロパティは非常に複雑で、決定論が問題にならないような解決に多くの時間を必要とします。
SMTCheckerがデフォルトの ``rlimit`` でコントラクトプロパティを解決できない場合、CLIオプション ``--model-checker-timeout <time>`` またはJSONオプション ``settings.modelChecker.timeout=<time>`` を介して、ミリ秒単位でタイムアウトを与えることができます。

.. _smtchecker_targets:

.. Verification Targets

検証ターゲット
==============

.. The types of verification targets created by the SMTChecker can also be
.. customized via the CLI option ``--model-checker-target <targets>`` or the JSON
.. option ``settings.modelChecker.targets=<targets>``.
.. In the CLI case, ``<targets>`` is a no-space-comma-separated list of one or
.. more verification targets, and an array of one or more targets as strings in
.. the JSON input.
.. The keywords that represent the targets are:

SMTCheckerによって作成される検証ターゲットの種類は、CLIオプション ``--model-checker-target <targets>`` またはJSONオプション ``settings.modelChecker.targets=<targets>`` によってカスタマイズすることもできます。
CLIの場合、 ``<targets>`` は1つまたは複数の検証ターゲットのスペースなしコンマ区切りのリストで、JSON入力では1つまたは複数のターゲットを文字列として配列します。
ターゲットを表すキーワードは

.. - Assertions: ``assert``.

- アサーション: ``assert`` 。

.. - Arithmetic underflow: ``underflow``.

- 算術アンダーフロー: ``underflow`` 。

.. - Arithmetic overflow: ``overflow``.

- 算術オーバーフロー: ``overflow`` 。

.. - Division by zero: ``divByZero``.

- ゼロによる除算: ``divByZero`` 。

.. - Trivial conditions and unreachable code: ``constantCondition``.

- トリビアルな条件と到達不可能なコード: ``constantCondition`` 。

.. - Popping an empty array: ``popEmptyArray``.

- 空の配列のポップ: ``popEmptyArray`` 。

.. - Out of bounds array/fixed bytes index access: ``outOfBounds``.

- 境界を越えた配列/固定バイトのインデックスアクセス: ``outOfBounds`` 。

.. - Insufficient funds for a transfer: ``balance``.

- 送金に必要な資金が不足しています: ``balance`` 。

.. - All of the above: ``default`` (CLI only).

- 上記の全てです: ``default`` （CLIのみ）。

.. A common subset of targets might be, for example:
.. ``--model-checker-targets assert,overflow``.

ターゲットの一般的なサブセットは、例えば次のようなものです: ``--model-checker-targets assert,overflow`` 。

.. All targets are checked by default, except underflow and overflow for Solidity >=0.8.7.

デフォルトではすべてのターゲットがチェックされますが、Solidity >=0.8.7ではアンダーフローとオーバーフローがチェックされます。

.. There is no precise heuristic on how and when to split verification targets,
.. but it can be useful especially when dealing with large contracts.

検証対象をいつ、どのように分割するかについての正確なヒューリスティックはありませんが、特に大規模なコントラクトを扱う場合には有効です。

.. Proved Targets

証明されたターゲット
====================

.. If there are any proved targets, the SMTChecker issues one warning per engine stating how many targets were proved.
.. If the user wishes to see all the specific proved targets, the CLI option ``--model-checker-show-proved`` and the JSON option ``settings.modelChecker.showProved = true`` can be used.

証明されたターゲットがある場合、SMTCheckerはエンジンごとに、証明されたターゲットの数を示す警告を1回発行します。
もしユーザーが証明されたターゲットをすべて見たい場合は、CLIオプション ``--model-checker-show-proved`` とJSONオプション ``settings.modelChecker.showProved = true`` を使用できます。

.. Unproved Targets

証明されていないターゲット
==========================

.. If there are any unproved targets, the SMTChecker issues one warning stating how many unproved targets there are.
.. If the user wishes to see all the specific unproved targets, the CLI option ``--model-checker-show-unproved`` and the JSON option ``settings.modelChecker.showUnproved = true`` can be used.

証明されていないターゲットがある場合、SMTCheckerは証明されていないターゲットの数を示す1つの警告を発行します。
ユーザーが特定の未処理のターゲットをすべて表示したい場合は、CLIオプション ``--model-checker-show-unproved`` およびJSONオプション ``settings.modelChecker.showUnproved = true`` を使用できます。

.. Unsupported Language Features

未サポートの言語機能
====================

.. Certain Solidity language features are not completely supported by the SMT encoding that the SMTChecker applies, for example assembly blocks.
.. The unsupported construct is abstracted via overapproximation to preserve soundness, meaning any properties reported safe are safe even though this feature is unsupported.
.. However such abstraction may cause false positives when the target properties depend on the precise behavior of the unsupported feature.
.. If the encoder encounters such cases it will by default report a generic warning stating how many unsupported features it has seen.
.. If the user wishes to see all the specific unsupported features, the CLI option ``--model-checker-show-unsupported`` and the JSON option ``settings.modelChecker.showUnsupported = true`` can be used, where their default value is ``false``.

SMTCheckerが適用するSMTエンコーディングでは、Solidity 言語の一部の機能が完全にサポートされていません（例えば、アセンブリブロック）。
サポートされていない構成は、健全性を保つために過近接によって抽象化されます。
つまり、この機能がサポートされていなくても、安全と報告されたプロパティは安全です。
しかし、このような抽象化は、対象となるプロパティがサポートされていない機能の正確な動作に依存している場合、誤検出を引き起こす可能性があります。
エンコーダがこのようなケースに遭遇した場合、デフォルトでは、サポートされていない機能をいくつ見たかを示す一般的な警告を報告することになります。
もしユーザーがサポートされていない機能をすべて見たい場合は、CLIオプション ``--model-checker-show-unsupported`` とJSONオプション ``settings.modelChecker.showUnsupported = true`` を使用できます（デフォルト値は ``false`` です）。

.. Verified Contracts

検証されたコントラクト
======================

.. By default all the deployable contracts in the given sources are analyzed separately as
.. the one that will be deployed. This means that if a contract has many direct
.. and indirect inheritance parents, all of them will be analyzed on their own,
.. even though only the most derived will be accessed directly on the blockchain.
.. This causes an unnecessary burden on the SMTChecker and the solver.  To aid
.. cases like this, users can specify which contracts should be analyzed as the
.. deployed one. The parent contracts are of course still analyzed, but only in
.. the context of the most derived contract, reducing the complexity of the
.. encoding and generated queries. Note that abstract contracts are by default
.. not analyzed as the most derived by the SMTChecker.

デフォルトでは、指定されたソース内のすべてのデプロイ可能なコントラクトが、デプロイされるものとして個別に分析されます。
これは、コントラクトが多くの直接および間接的な継承親を持つ場合、最も派生したものだけがブロックチェーン上で直接アクセスされるにもかかわらず、それらすべてが単独で分析されることを意味します。
これは、SMTCheckerとソルバーに不必要な負担をかけることになります。
このようなケースを支援するために、ユーザーはどのコントラクトをデプロイされたものとして分析すべきかを指定できます。
親コントラクトはもちろんまだ分析されますが、最も派生したコントラクトのコンテキストでのみ分析され、エンコーディングと生成されたクエリの複雑さが軽減されます。
抽象的なコントラクトはデフォルトではSMTCheckerによって最も派生したものとして分析されないことに注意してください。

.. The chosen contracts can be given via a comma-separated list (whitespace is not
.. allowed) of <source>:<contract> pairs in the CLI:
.. ``--model-checker-contracts "<source1.sol:contract1>,<source2.sol:contract2>,<source2.sol:contract3>"``,
.. and via the object ``settings.modelChecker.contracts`` in the :ref:`JSON input<compiler-api>`,
.. which has the following form:

選択されたコントラクトは、CLI:  ``--model-checker-contracts "<source1.sol:contract1>,<source2.sol:contract2>,<source2.sol:contract3>"`` では<source>: <contract>のペアのコンマ区切りリスト（空白は許されない）を介して、 :ref:`JSON input<compiler-api>` ではオブジェクト ``settings.modelChecker.contracts`` を介して、次のような形式で与えられます。

.. code-block:: json

    "contracts": {
        "source1.sol": ["contract1"],
        "source2.sol": ["contract2", "contract3"]
    }

.. Trusted External Calls

信頼した外部呼び出し
====================

.. By default, the SMTChecker does not assume that compile-time available code is the same as the runtime code for external calls.
.. Take the following contracts as an example:

デフォルトでは、SMTCheckerは、コンパイル時に利用可能なコードと外部呼び出しの実行時コードが同じであることを想定していません。
次のコントラクトを例にとります:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0;

    contract Ext {
        uint public x;
        function setX(uint _x) public { x = _x; }
    }
    contract MyContract {
        function callExt(Ext _e) public {
            _e.setX(42);
            assert(_e.x() == 42);
        }
    }

.. When ``MyContract.callExt`` is called, an address is given as the argument.
.. At deployment time, we cannot know for sure that address ``_e`` actually
.. contains a deployment of contract ``Ext``.
.. Therefore, the SMTChecker will warn that the assertion above can be violated,
.. which is true, if ``_e`` contains another contract than ``Ext``.

``MyContract.callExt`` が呼び出されると、引数としてアドレスが与えられます。
デプロイ時には、アドレス ``_e`` が実際にコントラクト ``Ext`` のデプロイメントを含んでいるかどうかを確実に知ることはできません。
したがって、SMTChecker は、 ``_e`` に ``Ext`` 以外のコントラクトが含まれている場合、上記のアサーションに違反する可能性があることを警告します（これは真です）。

.. However, it can be useful to treat these external calls as trusted, for example, to test that different implementations of an interface conform to the same property.
.. This means assuming that address ``_e`` indeed was deployed as contract ``Ext``.
.. This mode can be enabled via the CLI option ``--model-checker-ext-calls=trusted`` or the JSON field ``settings.modelChecker.extCalls: "trusted"``.

しかし、例えば、あるインターフェースの異なる実装が同じプロパティに適合しているかどうかをテストするために、これらの外部呼び出しを信頼できるものとして扱うことが有用な場合があります。
これは、アドレス ``_e`` が本当にコントラクト ``Ext`` としてデプロイされたと仮定することを意味します。
このモードはCLIオプション ``--model-checker-ext-calls=trusted`` またはJSONフィールド ``settings.modelChecker.extCalls: "trusted"`` で有効にできます。

.. Please be aware that enabling this mode can make the SMTChecker analysis much more computationally costly.

このモードを有効にすると、SMTCheckerの解析に計算コストがかかることに注意してください。

.. An important part of this mode is that it is applied to contract types and high level external calls to contracts, and not low level calls such as ``call`` and ``delegatecall``.
.. The storage of an address is stored per contract type, and the SMTChecker assumes that an externally called contract has the type of the caller expression.
.. Therefore, casting an ``address`` or a contract to different contract types will yield different storage values and can give unsound results if the assumptions are inconsistent, such as the example below:

このモードの重要な点は、コントラクトタイプとコントラクトへの高レベルの外部呼び出しに適用され、 ``call`` や ``delegatecall`` などの低レベルの呼び出しには適用されないという点です。
アドレスの保存はコントラクトタイプごとに行われ、SMTCheckerは外部から呼び出されたコントラクトは呼び出し元の式のタイプを持つと仮定しています。
したがって、 ``address`` やコントラクトを異なるコントラクト型にキャストすると、異なるストレージ値が得られ、以下の例のように仮定が矛盾している場合、健全でない結果を与えることがあります:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0;

    contract D {
        constructor(uint _x) { x = _x; }
        uint public x;
        function setX(uint _x) public { x = _x; }
    }

    contract E {
        constructor() { x = 2; }
        uint public x;
        function setX(uint _x) public { x = _x; }
    }

    contract C {
        function f() public {
            address d = address(new D(42));

            // `d` was deployed as `D`, so its `x` should be 42 now.
            assert(D(d).x() == 42); // should hold
            assert(D(d).x() == 43); // should fail

            // E and D have the same interface, so the following
            // call would also work at runtime.
            // However, the change to `E(d)` is not reflected in `D(d)`.
            E(d).setX(1024);

            // Reading from `D(d)` now will show old values.
            // The assertion below should fail at runtime,
            // but succeeds in this mode's analysis (unsound).
            assert(D(d).x() == 42);
            // The assertion below should succeed at runtime,
            // but fails in this mode's analysis (false positive).
            assert(D(d).x() == 1024);
        }
    }

.. Due to the above, make sure that the trusted external calls to a certain variable of ``address`` or ``contract`` type always have the same caller expression type.

以上のことから、 ``address`` 型や ``contract`` 型の特定の変数に対する信頼できる外部呼び出しは、常に同じ呼び出し元の式の型を持つようにします。

.. It is also helpful to cast the called contract's variable as the type of the most derived type in case of inheritance.

また、継承の場合には、呼び出されたコントラクトの変数を最も派生した型の型としてキャストすることが有効です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0;

    interface Token {
        function balanceOf(address _a) external view returns (uint);
        function transfer(address _to, uint _amt) external;
    }

    contract TokenCorrect is Token {
        mapping (address => uint) balance;
        constructor(address _a, uint _b) {
            balance[_a] = _b;
        }
        function balanceOf(address _a) public view override returns (uint) {
            return balance[_a];
        }
        function transfer(address _to, uint _amt) public override {
            require(balance[msg.sender] >= _amt);
            balance[msg.sender] -= _amt;
            balance[_to] += _amt;
        }
    }

    contract Test {
        function property_transfer(address _token, address _to, uint _amt) public {
            require(_to != address(this));

            TokenCorrect t = TokenCorrect(_token);

            uint xPre = t.balanceOf(address(this));
            require(xPre >= _amt);
            uint yPre = t.balanceOf(_to);

            t.transfer(_to, _amt);
            uint xPost = t.balanceOf(address(this));
            uint yPost = t.balanceOf(_to);

            assert(xPost == xPre - _amt);
            assert(yPost == yPre + _amt);
        }
    }

.. Note that in function ``property_transfer``, the external calls are performed on variable ``t``.

関数 ``property_transfer`` では、外部呼び出しは変数 ``t`` に対して行われることに注意してください。

.. Another caveat of this mode are calls to state variables of contract type outside the analyzed contract.
.. In the code below, even though ``B`` deploys ``A``, it is also possible for the address stored in ``B.a`` to be called by anyone outside of ``B`` in between transactions to ``B`` itself.
.. To reflect the possible changes to ``B.a``, the encoding allows an unbounded number of calls to be made to ``B.a`` externally.
.. The encoding will keep track of ``B.a``'s storage, therefore assertion (2) should hold.
.. However, currently the encoding allows such calls to be made from ``B`` conceptually, therefore assertion (3) fails.
.. Making the encoding stronger logically is an extension of the trusted mode and is under development.
.. Note that the encoding does not keep track of storage for ``address`` variables, therefore if ``B.a`` had type ``address`` the encoding would assume that its storage does not change in between transactions to ``B``.

このモードのもう一つの注意点は、解析されたコントラクト以外のコントラクトタイプの状態変数への呼び出しです。
以下のコードでは、 ``B`` が ``A`` をデプロイしているにもかかわらず、 ``B.a`` に格納されているアドレスが、 ``B`` 自身へのトランザクションの合間に、 ``B`` 以外の誰かによって呼び出される可能性もあります。
``B.a`` に起こりうる変更を反映するために、エンコーディングは外部から ``B.a`` を無制限に呼び出すことができるようにします。
エンコーディングは ``B.a`` のストレージを追跡するので、アサーション(2)が成立するはずです。
しかし、現在のエンコーディングでは、このような呼び出しは概念的に ``B`` から行うことができるので、アサーション(3)は失敗します。
エンコーディングを論理的に強くすることは、トラステッドモードの拡張であり、現在開発中です。
もし ``B.a`` が ``address`` 型を持つ場合、エンコーディングは ``B`` へのトランザクションの間にそのストレージが変更されないと仮定します。

.. code-block:: solidity

    pragma solidity >=0.8.0;

    contract A {
        uint public x;
        address immutable public owner;
        constructor() {
            owner = msg.sender;
        }
        function setX(uint _x) public {
            require(msg.sender == owner);
            x = _x;
        }
    }

    contract B {
        A a;
        constructor() {
            a = new A();
            assert(a.x() == 0); // (1) should hold
        }
        function g() public view {
            assert(a.owner() == address(this)); // (2) should hold
            assert(a.x() == 0); // (3) should hold, but fails due to a false positive
        }
    }

.. Reported Inferred Inductive Invariants

報告された推論された帰納的な不変量
==================================

.. For properties that were proved safe with the CHC engine, the SMTChecker can retrieve inductive invariants that were inferred by the Horn solver as part of the proof.
.. Currently only two types of invariants can be reported to the user:

CHCエンジンで安全性が証明された性質については、SMTCheckerは証明の一部としてHornソルバーによって推論された帰納的不変量を取得できます。
現在、2種類のみの不変量をユーザに報告できます。

.. - Contract Invariants: these are properties over the contract's state variables
..   that are true before and after every possible transaction that the contract may ever run. For example, ``x >= y``, where ``x`` and ``y`` are a contract's state variables.

- コントラクト不変量: コントラクトの状態変数に関するプロパティで、コントラクトが実行する可能性のあるすべてのトランザクションの前後で真となるものです。
  例えば、 ``x`` と ``y`` がコントラクトの状態変数である場合、 ``x >= y`` となります。

.. - Reentrancy Properties: they represent the behavior of the contract
..   in the presence of external calls to unknown code. These properties can express a relation
..   between the value of the state variables before and after the external call, where the external call is free to do anything, including making reentrant calls to the analyzed contract. Primed variables represent the state variables' values after said external call. Example: ``lock -> x = x'``.

- 再帰性プロパティ: 未知のコードへの外部呼び出しがある場合のコントラクトの動作を表します。
  これらのプロパティは、外部呼び出しの前と後の状態変数の値の間の関係を表現できます。
  外部呼び出しは、分析されたコントラクトへのリエントラントな呼び出しを行うことを含め、何でも自由に行うことができます。
  プライム化された変数は、前記外部呼び出し後の状態変数の値を表します。
  例: ``lock -> x = x'`` 。

.. The user can choose the type of invariants to be reported using the CLI option ``--model-checker-invariants "contract,reentrancy"`` or as an array in the field ``settings.modelChecker.invariants`` in the :ref:`JSON input<compiler-api>`.
.. By default the SMTChecker does not report invariants.

ユーザーは、CLIオプション ``--model-checker-invariants "contract,reentrancy"`` を使用して、または :ref:`JSON input<compiler-api>` のフィールド ``settings.modelChecker.invariants`` で配列として報告される不変量の型を選択できます。
デフォルトでは、SMTCheckerはインバリアントを報告しません。

.. Division and Modulo With Slack Variables

スラック変数を使った除算とモジュロ
==================================

.. Spacer, the default Horn solver used by the SMTChecker, often dislikes division
.. and modulo operations inside Horn rules. Because of that, by default the
.. Solidity division and modulo operations are encoded using the constraint
.. ``a = b * d + m`` where ``d = a / b`` and ``m = a % b``.
.. However, other solvers, such as Eldarica, prefer the syntactically precise operations.
.. The command line flag ``--model-checker-div-mod-no-slacks`` and the JSON option
.. ``settings.modelChecker.divModNoSlacks`` can be used to toggle the encoding
.. depending on the used solver preferences.

SMTCheckerで使用されているデフォルトのHornソルバーであるSpacerは、Hornルール内の除算やモジュロ演算を嫌うことがあります。
そのため、デフォルトではSolidityの除算とモジュロ演算は ``a = b * d + m``  where  ``d = a / b``  and  ``m = a % b`` という制約を用いてエンコードされています。
しかし、Eldaricaのような他のソルバーは、構文的に正確な演算を好みます。
コマンドラインフラグ ``--model-checker-div-mod-no-slacks`` とJSONオプション ``settings.modelChecker.divModNoSlacks`` を使って、使用するソルバーの好みに応じてエンコーディングを切り替えることができます。

Natspec Function Abstraction
============================

.. Certain functions including common math methods such as ``pow``
.. and ``sqrt`` may be too complex to be analyzed in a fully automated way.
.. These functions can be annotated with Natspec tags that indicate to the
.. SMTChecker that these functions should be abstracted. This means that the
.. body of the function is not used, and when called, the function will:

``pow`` や ``sqrt`` などの一般的な数学手法を含む特定の関数は、完全に自動化された方法で分析するには複雑すぎる場合があります。
このような関数には、Natspecタグで注釈を付けることができます。
Natspecタグは、SMTCheckerに対して、これらの関数が抽象化されるべきであることを示します。
これは、関数の本体は使用されず、関数が呼び出されたときに

.. - Return a nondeterministic value, and either keep the state variables unchanged if the abstracted function is view/pure, or also set the state variables to nondeterministic values otherwise. This can be used via the annotation ``/// @custom:smtchecker abstract-function-nondet``.

- 非決定論的な値を返し、抽象化された関数がview/pureであれば状態変数を変更せずに、そうでなければ状態変数を非決定論的な値に設定します。
  これは、アノテーション ``/// @custom:smtchecker abstract-function-nondet`` を介して使用できます。

.. - Act as an uninterpreted function. This means that the semantics of the function (given by the body) are ignored, and the only property this function has is that given the same input it guarantees the same output. This is currently under development and will be available via the annotation ``/// @custom:smtchecker abstract-function-uf``.

- 解釈されない関数として動作します。
  これは、（ボディで与えられた）関数のセマンティクスが無視され、この関数が持つ唯一の特性は、同じ入力が与えられれば同じ出力が保証されるということです。
  この関数は現在開発中で、アノテーション ``/// @custom:smtchecker abstract-function-uf`` から利用できるようになる予定です。

.. _smtchecker_engines:

.. Model Checking Engines

モデルチェックエンジン
======================

.. The SMTChecker module implements two different reasoning engines, a Bounded
.. Model Checker (BMC) and a system of Constrained Horn Clauses (CHC).
.. Both engines are currently under development, and have different characteristics.
.. The engines are independent and every property warning states from which engine it came.
.. Note that all the examples above with counterexamples were reported by CHC, the more powerful engine.

SMTCheckerモジュールは、BMC（Bounded Model Checker）とCHC（Constrained Horn Clauses）という2種類の推論エンジンを実装しています。
両エンジンは現在開発中であり、それぞれ異なる特徴を持っています。
これらのエンジンは独立しており、すべてのプロパティの警告は、それがどのエンジンから来たかを示しています。
なお、上記の反例のある例はすべて、より強力なエンジンであるCHCから報告されています。

.. By default both engines are used, where CHC runs first, and every property that was not proven is passed over to BMC.
.. You can choose a specific engine via the CLI option ``--model-checker-engine {all,bmc,chc,none}`` or the JSON option ``settings.modelChecker.engine={all,bmc,chc,none}``.

デフォルトでは、両方のエンジンが使用され、CHCが最初に実行され、証明されなかったすべてのプロパティがBMCに渡されます。
特定のエンジンを選択するには、CLIオプション ``--model-checker-engine {all,bmc,chc,none}`` またはJSONオプション ``settings.modelChecker.engine={all,bmc,chc,none}`` を使用します。

Bounded Model Checker (BMC)
---------------------------

.. The BMC engine analyzes functions in isolation, that is, it does not take the
.. overall behavior of the contract over multiple transactions into account when
.. analyzing each function.  Loops are also ignored in this engine at the moment.
.. Internal function calls are inlined as long as they are not recursive, directly
.. or indirectly. External function calls are inlined if possible. Knowledge
.. that is potentially affected by reentrancy is erased.

BMCエンジンは、関数を単独で解析します。
つまり、各関数を解析する際に、複数のトランザクションにわたるコントラクトの全体的な動作を考慮しません。
ループも現時点ではこのエンジンでは無視されます。
内部の関数呼び出しは、直接的または間接的に再帰的でない限りインライン化されます。
外部関数呼び出しは可能な限りインライン化されます。
再帰性の影響を受ける可能性のある知識は消去されます。

.. The characteristics above make BMC prone to reporting false positives,
.. but it is also lightweight and should be able to quickly find small local bugs.

上記のような特性から、BMCは誤検出を報告する傾向がありますが、軽量であるため、小さなローカルバグを素早く発見できるはずです。

Constrained Horn Clauses (CHC)
------------------------------

.. A contract's Control Flow Graph (CFG) is modelled as a system of
.. Horn clauses, where the life cycle of the contract is represented by a loop
.. that can visit every public/external function non-deterministically. This way,
.. the behavior of the entire contract over an unbounded number of transactions
.. is taken into account when analyzing any function. Loops are fully supported
.. by this engine. Internal function calls are supported, and external function
.. calls assume the called code is unknown and can do anything.

コントラクトのコントロールフローグラフ（CFG）は、Horn節のシステムとしてモデル化されており、コントラクトのライフサイクルは、すべてのpublic/external関数を非決定的に訪れることができるループで表現されています。
このようにして、任意の関数を解析する際には、無制限の数のトランザクションにおけるコントラクト全体の動作が考慮されます。
ループはこのエンジンで完全にサポートされています。
internal関数の呼び出しはサポートされており、external関数の呼び出しは、呼び出されたコードが未知であり、何でもできると仮定します。

.. The CHC engine is much more powerful than BMC in terms of what it can prove,
.. and might require more computing resources.

CHCエンジンは、BMCよりも証明できる内容がはるかに多く、より多くの計算資源を必要とする可能性があります。

SMTソルバーとHornソルバー
=========================

.. The two engines detailed above use automated theorem provers as their logical
.. backends.  BMC uses an SMT solver, whereas CHC uses a Horn solver. Often the
.. same tool can act as both, as seen in `z3 <https://github.com/Z3Prover/z3>`_,
.. which is primarily an SMT solver and makes `Spacer
.. <https://spacer.bitbucket.io/>`_ available as a Horn solver, and `Eldarica
.. <https://github.com/uuverifiers/eldarica>`_ which does both.

上記の2つのエンジンは、自動定理証明器を論理的バックエンドとして使用しています。
BMCはSMTソルバーを使用し、CHCはHornソルバーを使用しています。
SMTソルバーを主とし、 `Spacer <https://spacer.bitbucket.io/>`_ をHornソルバーとして利用可能な `z3 <https://github.com/Z3Prover/z3>`_ や、両方の機能を持つ `Eldarica <https://github.com/uuverifiers/eldarica>`_ のように、同じツールが両方の役割を果たすこともよくあります。

.. The user can choose which solvers should be used, if available, via the CLI
.. option ``--model-checker-solvers {all,cvc4,eld,smtlib2,z3}`` or the JSON option
.. ``settings.modelChecker.solvers=[smtlib2,z3]``, where:

ユーザーは、使用可能な場合、どのソルバーを使用するかを、CLIオプション ``--model-checker-solvers {all,cvc4,eld,smtlib2,z3}`` またはJSONオプション ``settings.modelChecker.solvers=[smtlib2,z3]`` で選択できます。

.. - ``cvc4`` is only available if the ``solc`` binary is compiled with it. Only BMC uses ``cvc4``.

- ``cvc4`` は、 ``solc`` のバイナリがコンパイルされている場合にのみ使用できます。
  ``cvc4`` を使うのはBMCだけです。

.. - ``eld`` is used via its binary which must be installed in the system. Only CHC uses ``eld``, and only if ``z3`` is not enabled.

- ``eld`` は、システムにインストールされている必要があるバイナリを介して使用されます。
  CHCだけが ``eld`` を使用し、 ``z3`` が有効でない場合にのみ使用します。

.. - ``smtlib2`` outputs SMT/Horn queries in the `smtlib2 <http://smtlib.cs.uiowa.edu/>`_ format.
..   These can be used together with the compiler's `callback mechanism <https://github.com/ethereum/solc-js>`_ so that
..   any solver binary from the system can be employed to synchronously return the results of the queries to the compiler.
..   This can be used by both BMC and CHC depending on which solvers are called.

- ``smtlib2`` はSMT/Hornのクエリを `smtlib2 <http://smtlib.cs.uiowa.edu/>`_ 形式で出力します。
  これをコンパイラの `コールバックメカニズム <https://github.com/ethereum/solc-js>`_ と併用することで、システム内の任意のソルバーバイナリを採用して、クエリの結果をコンパイラに同期して返すことができます。
  これは、どのソルバーを呼び出すかによって、BMCとCHCの両方で使用できます。

.. - ``z3`` is available

..   - if ``solc`` is compiled with it;

..   - if a dynamic ``z3`` library of version >=4.8.x is installed in a Linux system (from Solidity 0.7.6);

..   - statically in ``soljson.js`` (from Solidity 0.6.9), that is, the JavaScript binary of the compiler.

- 以下の場合 ``z3`` が使えます。

  -  ``solc`` がz3とともにコンパイルされている場合。

  - Linuxシステムにバージョン>=4.8.xの動的 ``z3`` ライブラリがインストールされている場合（Solidity 0.7.6以降）。

  -  ``soljson.js`` （Solidity 0.6.9 以降）では静的に、つまりコンパイラのJavaScriptバイナリを使用しています。

.. note::

    .. z3 version 4.8.16 broke ABI compatibility with previous versions and cannot be used with solc <=0.8.13.
    .. If you are using z3 >=4.8.16 please use solc>=0.8.14, and conversely, only use older z3 with older solc releases.
    .. We also recommend using the latest z3 release which is what SMTChecker also does.

    z3バージョン4.8.16は、以前のバージョンとのABI互換性を壊し、solc <=0.8.13で使用できません。
    もしz3 >=4.8.16を使用しているならば、solc>=0.8.14を使用してください。
    逆に、古いz3は古いsolcリリースとしか使用できません。
    また、SMTCheckerも最新のz3リリースを使用することをお勧めします。

.. Since both BMC and CHC use ``z3``, and ``z3`` is available in a greater variety
.. of environments, including in the browser, most users will almost never need to be
.. concerned about this option. More advanced users might apply this option to try
.. alternative solvers on more complex problems.

BMCもCHCも ``z3`` を採用しており、 ``z3`` はブラウザを含めてより多様な環境で利用できるため、ほとんどのユーザーはこのオプションを気にする必要はないでしょう。
上級者であれば、より複雑な問題に対して別のソルバーを試すためにこのオプションを適用するかもしれません。

.. Please note that certain combinations of chosen engine and solver will lead to
.. the SMTChecker doing nothing, for example choosing CHC and ``cvc4``.

なお、選択したエンジンとソルバーの組み合わせによっては、SMTCheckerが何もしない場合があります。
例えば、CHCと ``cvc4`` を選択した場合などです。

.. Abstraction and False Positives

**************
抽象化と偽陽性
**************

.. The SMTChecker implements abstractions in an incomplete and sound way: If a bug
.. is reported, it might be a false positive introduced by abstractions (due to
.. erasing knowledge or using a non-precise type). If it determines that a
.. verification target is safe, it is indeed safe, that is, there are no false
.. negatives (unless there is a bug in the SMTChecker).

SMTCheckerは、抽象化を不完全かつ健全な方法で実装しています。
バグが報告された場合、それは抽象化によってもたらされた誤検出である可能性があります（知識を消去したり、正確でない型を使用したため）。
検証対象が安全であると判断された場合、それは確かに安全であり、つまり（SMTCheckerにバグがない限り）偽陰性は存在しないのです。

.. If a target cannot be proven you can try to help the solver by using the tuning
.. options in the previous section.
.. If you are sure of a false positive, adding ``require`` statements in the code
.. with more information may also give some more power to the solver.

ターゲットが証明できない場合は、前のセクションのチューニングオプションを使ってソルバーを助けることができます。
誤検出が確実な場合は、より多くの情報を含む ``require`` 文をコードに追加することで、ソルバーにさらなる力を与えることもできます。

.. SMT Encoding and Types

SMTエンコーディングと型
=======================

.. The SMTChecker encoding tries to be as precise as possible, mapping Solidity types and expressions to their closest `SMT-LIB <http://smtlib.cs.uiowa.edu/>`_ representation, as shown in the table below.

SMTCheckerのエンコーディングは可能な限り正確を期しており、Solidityの型や表現を下の表のように最も近い `SMT-LIB <http://smtlib.cs.uiowa.edu/>`_ 表現にマッピングしています。

+-----------------------+--------------------------------+-----------------------------+
|Solidity type          |SMT sort                        |Theories                     |
+=======================+================================+=============================+
|Boolean                |Bool                            |Bool                         |
+-----------------------+--------------------------------+-----------------------------+
|intN, uintN, address,  |Integer                         |LIA, NIA                     |
|bytesN, enum, contract |                                |                             |
+-----------------------+--------------------------------+-----------------------------+
|array, mapping, bytes, |Tuple                           |Datatypes, Arrays, LIA       |
|string                 |(Array elements, Integer length)|                             |
+-----------------------+--------------------------------+-----------------------------+
|struct                 |Tuple                           |Datatypes                    |
+-----------------------+--------------------------------+-----------------------------+
|other types            |Integer                         |LIA                          |
+-----------------------+--------------------------------+-----------------------------+

.. Types that are not yet supported are abstracted by a single 256-bit unsigned
.. integer, where their unsupported operations are ignored.

まだサポートされていない型は、1つの256ビットの符号なし整数で抽象化され、サポートされていない操作は無視されます。

.. For more details on how the SMT encoding works internally, see the paper
.. `SMT-based Verification of Solidity Smart Contracts <https://github.com/chriseth/solidity_isola/blob/master/main.pdf>`_.

SMTエンコーディングの内部動作の詳細については、論文 `SMT-based Verification of Solidity Smart Contracts <https://github.com/chriseth/solidity_isola/blob/master/main.pdf>`_ を参照してください。

.. Function Calls

関数呼び出し
============

.. In the BMC engine, function calls to the same contract (or base contracts) are
.. inlined when possible, that is, when their implementation is available.  Calls
.. to functions in other contracts are not inlined even if their code is
.. available, since we cannot guarantee that the actual deployed code is the same.

BMCエンジンでは、同じコントラクト（またはベースコントラクト）の関数呼び出しは、可能な場合、つまりその実装が利用可能な場合にインライン化されます。
他のコントラクトの関数の呼び出しは、そのコードが利用可能であってもインライン化されません。
これは、実際にデプロイされたコードが同じであることを保証できないからです。

.. The CHC engine creates nonlinear Horn clauses that use summaries of the called
.. functions to support internal function calls. External function calls are treated
.. as calls to unknown code, including potential reentrant calls.

CHCエンジンは、内部関数の呼び出しをサポートするために、呼び出された関数のサマリーを使用する非線形Horn句を作成します。
外部関数呼び出しは、リエントラント呼び出しの可能性も含め、未知のコードへの呼び出しとして扱われます。

.. Complex pure functions are abstracted by an uninterpreted function (UF) over
.. the arguments.

複雑な純関数は、引数上の解釈されない関数（UF）によって抽象化されます。

+-----------------------------------+--------------------------------------+
|Functions                          |BMC/CHC behavior                      |
+===================================+======================================+
|``assert``                         |Verification target.                  |
+-----------------------------------+--------------------------------------+
|``require``                        |Assumption.                           |
+-----------------------------------+--------------------------------------+
|internal call                      |BMC: Inline function call.            |
|                                   |CHC: Function summaries.              |
+-----------------------------------+--------------------------------------+
|external call to known code        |BMC: Inline function call or          |
|                                   |erase knowledge about state variables |
|                                   |and local storage references.         |
|                                   |CHC: Assume called code is unknown.   |
|                                   |Try to infer invariants that hold     |
|                                   |after the call returns.               |
+-----------------------------------+--------------------------------------+
|Storage array push/pop             |Supported precisely.                  |
|                                   |Checks whether it is popping an       |
|                                   |empty array.                          |
+-----------------------------------+--------------------------------------+
|ABI functions                      |Abstracted with UF.                   |
+-----------------------------------+--------------------------------------+
|``addmod``, ``mulmod``             |Supported precisely.                  |
+-----------------------------------+--------------------------------------+
|``gasleft``, ``blockhash``,        |Abstracted with UF.                   |
|``keccak256``, ``ecrecover``       |                                      |
|``ripemd160``                      |                                      |
+-----------------------------------+--------------------------------------+
|pure functions without             |Abstracted with UF                    |
|implementation (external or        |                                      |
|complex)                           |                                      |
+-----------------------------------+--------------------------------------+
|external functions without         |BMC: Erase state knowledge and assume |
|implementation                     |result is nondeterminisc.             |
|                                   |CHC: Nondeterministic summary.        |
|                                   |Try to infer invariants that hold     |
|                                   |after the call returns.               |
+-----------------------------------+--------------------------------------+
|transfer                           |BMC: Checks whether the contract's    |
|                                   |balance is sufficient.                |
|                                   |CHC: does not yet perform the check.  |
+-----------------------------------+--------------------------------------+
|others                             |Currently unsupported                 |
+-----------------------------------+--------------------------------------+

.. Using abstraction means loss of precise knowledge, but in many cases it does
.. not mean loss of proving power.

抽象化することは、正確な知識を失うことを意味しますが、多くの場合、証明力を失うことを意味しません。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0;

    contract Recover
    {
        function f(
            bytes32 hash,
            uint8 v1, uint8 v2,
            bytes32 r1, bytes32 r2,
            bytes32 s1, bytes32 s2
        ) public pure returns (address) {
            address a1 = ecrecover(hash, v1, r1, s1);
            require(v1 == v2);
            require(r1 == r2);
            require(s1 == s2);
            address a2 = ecrecover(hash, v2, r2, s2);
            assert(a1 == a2);
            return a1;
        }
    }

.. In the example above, the SMTChecker is not expressive enough to actually
.. compute ``ecrecover``, but by modelling the function calls as uninterpreted
.. functions we know that the return value is the same when called on equivalent
.. parameters. This is enough to prove that the assertion above is always true.

上の例では、SMTCheckerは実際に ``ecrecover`` を計算するほどの表現力はありませんが、関数呼び出しを解釈されない関数としてモデル化することで、同等のパラメータで呼び出された場合に戻り値が同じであることがわかります。
このことは、上記の主張が常に真であることを証明するのに十分です。

.. Abstracting a function call with an UF can be done for functions known to be
.. deterministic, and can be easily done for pure functions.  It is however
.. difficult to do this with general external functions, since they might depend
.. on state variables.

関数呼び出しをUFで抽象化することは、決定論的であることが知られている関数に対しては可能であり、純粋な関数に対しても簡単に行うことができます。
しかし、一般の外部関数では、状態変数に依存する可能性があるため、これを行うことは困難です。

.. Reference Types and Aliasing

参照型とエイリアス
==================

.. Solidity implements aliasing for reference types with the same :ref:`data
.. location<data-location>`.
.. That means one variable may be modified through a reference to the same data
.. area.
.. The SMTChecker does not keep track of which references refer to the same data.
.. This implies that whenever a local reference or state variable of reference
.. type is assigned, all knowledge regarding variables of the same type and data
.. location is erased.
.. If the type is nested, the knowledge removal also includes all the prefix base
.. types.

Solidityでは、同じ :ref:`データロケーション<data-location>` を持つ参照型に対してエイリアスを実装しています。
つまり、ある変数が同じデータ領域への参照を通じて変更される可能性があるということです。
SMTCheckerは、どの参照が同じデータを参照しているかを追跡しません。
これは、参照型のローカル参照または状態変数が割り当てられるたびに、同じ型およびデータロケーションの変数に関するすべての知識が消去されることを意味します。
型が入れ子になっている場合、知識の消去には、すべての前置基底型も含まれます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.0;

    contract Aliasing
    {
        uint[] array1;
        uint[][] array2;
        function f(
            uint[] memory a,
            uint[] memory b,
            uint[][] memory c,
            uint[] storage d
        ) internal {
            array1[0] = 42;
            a[0] = 2;
            c[0][0] = 2;
            b[0] = 1;
            // Erasing knowledge about memory references should not
            // erase knowledge about state variables.
            assert(array1[0] == 42);
            // However, an assignment to a storage reference will erase
            // storage knowledge accordingly.
            d[0] = 2;
            // Fails as false positive because of the assignment above.
            assert(array1[0] == 42);
            // Fails because `a == b` is possible.
            assert(a[0] == 2);
            // Fails because `c[i] == b` is possible.
            assert(c[0][0] == 2);
            assert(d[0] == 2);
            assert(b[0] == 1);
        }
        function g(
            uint[] memory a,
            uint[] memory b,
            uint[][] memory c,
            uint x
        ) public {
            f(a, b, c, array2[x]);
        }
    }

.. After the assignment to ``b[0]``, we need to clear knowledge about ``a`` since
.. it has the same type (``uint[]``) and data location (memory).  We also need to
.. clear knowledge about ``c``, since its base type is also a ``uint[]`` located
.. in memory. This implies that some ``c[i]`` could refer to the same data as
.. ``b`` or ``a``.

``b[0]`` に割り当てられた後、 ``a`` については型（ ``uint[]`` ）とデータの場所（メモリ）が同じであるため、知識を消去する必要があります。
また、 ``c`` の基本型もメモリ上の ``uint[]`` であるため、 ``c`` に関する知識も消去する必要があります。
これは、ある ``c[i]`` が ``b`` や ``a`` と同じデータを参照する可能性があることを意味します。

.. Notice that we do not clear knowledge about ``array`` and ``d`` because they
.. are located in storage, even though they also have type ``uint[]``.  However,
.. if ``d`` was assigned, we would need to clear knowledge about ``array`` and
.. vice-versa.

``array`` と ``d`` は、型が ``uint[]`` であっても、ストレージに配置されているため、知識を消去しないことに注意してください。
しかし、もし ``d`` が割り当てられていたら、 ``array`` に関する知識をクリアする必要があり、その逆もまた然りです。

コントラクト残高
================

.. A contract may be deployed with funds sent to it, if ``msg.value`` > 0 in the
.. deployment transaction.
.. However, the contract's address may already have funds before deployment,
.. which are kept by the contract.
.. Therefore, the SMTChecker assumes that ``address(this).balance >= msg.value``
.. in the constructor in order to be consistent with the EVM rules.
.. The contract's balance may also increase without triggering any calls to the
.. contract, if

コントラクトは、デプロイトランザクションにおいて  ``msg.value``  > 0 であれば、資金を送ってデプロイされるかもしれません。
しかし、コントラクトのアドレスは、デプロイ前にすでに資金を持っている可能性があり、それはコントラクトによって保持されます。
そのため、SMTCheckerはEVMルールとの整合性を取るために、コンストラクタで ``address(this).balance >= msg.value`` を想定しています。
また、コントラクトの残高は、以下の場合、コントラクトへの呼び出しをトリガすることなく増加することがあります。

.. - ``selfdestruct`` is executed by another contract with the analyzed contract
..   as the target of the remaining funds,

- ``selfdestruct`` は、分析されたコントラクトを残金の対象として、別のコントラクトで実行されます。

.. - the contract is the coinbase (i.e., ``block.coinbase``) of some block.

- コントラクトは、あるブロックのコインベース（＝ ``block.coinbase`` ）です。

.. To model this properly, the SMTChecker assumes that at every new transaction
.. the contract's balance may grow by at least ``msg.value``.

これを適切にモデル化するために、SMTCheckerは、新しいトランザクションのたびに コントラクトの残高が少なくとも ``msg.value`` だけ増える可能性があると仮定しています。

.. Real World Assumptions

************
実世界の仮定
************

.. Some scenarios can be expressed in Solidity and the EVM, but are expected to
.. never occur in practice.
.. One of such cases is the length of a dynamic storage array overflowing during a
.. push: If the ``push`` operation is applied to an array of length 2^256 - 1, its
.. length silently overflows.
.. However, this is unlikely to happen in practice, since the operations required
.. to grow the array to that point would take billions of years to execute.
.. Another similar assumption taken by the SMTChecker is that an address' balance
.. can never overflow.

SolidityやEVMでは表現できますが、実際には発生しないと思われるシナリオもあります。
そのようなケースの1つが、プッシュ時に動的ストレージの配列の長さがオーバーフローすることです。
``push`` 操作が長さ2^256 - 1の配列に適用された場合、その長さは静かにオーバーフローします。
しかし、実際にはこのようなことは起こり得ません。
なぜなら、配列をそこまで成長させるために必要な演算を実行するには、何十億年もかかるからです。
SMTCheckerのもう一つの類似した仮定は、アドレスの残高がオーバーフローすることはないというものです。

.. A similar idea was presented in `EIP-1985 <https://eips.ethereum.org/EIPS/eip-1985>`_.

同じようなアイデアが `EIP-1985 <https://eips.ethereum.org/EIPS/eip-1985>`_ でも紹介されていました。
