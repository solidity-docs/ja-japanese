############
共通パターン
############

.. index:: withdrawal

.. _withdrawal_pattern:

**********************
コントラクトからの出金
**********************

.. The recommended method of sending funds after an effect is using the withdrawal pattern.
.. Although the most intuitive method of sending Ether, as a result of an effect, is a direct ``transfer`` call, this is not recommended as it introduces a potential security risk. 
.. You may read more about this on the :ref:`security_considerations` page.

エフェクト後の送金方法としては、出金パターンの使用が推奨されます。
エフェクトの結果としてEtherを送信する最も直感的な方法はダイレクト ``transfer`` コールですが、これは潜在的なセキュリティリスクがあるため推奨されません。
これについては、 :ref:`security_considerations` のページで詳しく説明しています。

.. The following is an example of the withdrawal pattern in practice in a contract where the goal is to send the most money to the contract in order to become the "richest", inspired by `King of the Ether <https://www.kingoftheether.com/>`_.

`King of the Ether <https://www.kingoftheether.com/>`_ をヒントに、「一番のお金持ち」になるために一番多くのお金を送ることを目的としたコントラクトにおいて、実際に行われている出金パターンの例を以下に示します。

.. In the following contract, if you are no longer the richest, you receive the funds of the person who is now the richest.

次のコントラクトでは、自分が一番お金持ちでなくなった場合、今一番お金持ちになった人の資金を受け取ります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    contract WithdrawalContract {
        address public richest;
        uint public mostSent;

        mapping(address => uint) pendingWithdrawals;

        /// Etherの送信量が現在最も多い量より多くなかった
        error NotEnoughEther();

        constructor() payable {
            richest = msg.sender;
            mostSent = msg.value;
        }

        function becomeRichest() public payable {
            if (msg.value <= mostSent) revert NotEnoughEther();
            pendingWithdrawals[richest] += msg.value;
            richest = msg.sender;
            mostSent = msg.value;
        }

        function withdraw() public {
            uint amount = pendingWithdrawals[msg.sender];
            // Remember to zero the pending refund before
            // sending to prevent re-entrancy attacks
            pendingWithdrawals[msg.sender] = 0;
            payable(msg.sender).transfer(amount);
        }
    }

.. This is as opposed to the more intuitive sending pattern:

これは、より直感的な送信パターンとは対照的です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    contract SendContract {
        address payable public richest;
        uint public mostSent;

        /// Etherの送信量が現在最も多い量より多くなかった
        error NotEnoughEther();

        constructor() payable {
            richest = payable(msg.sender);
            mostSent = msg.value;
        }

        function becomeRichest() public payable {
            if (msg.value <= mostSent) revert NotEnoughEther();
            // この行は問題を引き起こす可能性があります（以下で説明します）。
            richest.transfer(msg.value);
            richest = payable(msg.sender);
            mostSent = msg.value;
        }
    }

.. Notice that, in this example, an attacker could trap the contract into an unusable state by causing ``richest`` to be
.. the address of a contract that has a receive or fallback function
.. which fails (e.g. by using ``revert()`` or by just
.. consuming more than the 2300 gas stipend transferred to them). That way,
.. whenever ``transfer`` is called to deliver funds to the
.. "poisoned" contract, it will fail and thus also ``becomeRichest``
.. will fail, with the contract being stuck forever.

この例では、攻撃者は、失敗する受信関数やフォールバック関数を持つコントラクトのアドレスを ``richest`` にすることで、コントラクトを使用不能な状態に陥れることができることに注意してください（例えば、 ``revert()`` を使用したり、送金された2300ガス制限を超えて消費したりすることなど）。
そうすれば、「毒された」コントラクトに資金を届けるために ``transfer`` が呼び出されるたびに、それは失敗し、したがって ``becomeRichest`` も失敗して、コントラクトは永遠に動けなくなります。

.. In contrast, if you use the "withdraw" pattern from the first example, the attacker can only cause his or her own withdraw to fail and not the rest of the contract's workings.

一方、最初の例のwithdrawパターンを使用した場合、攻撃者は自分の出金が失敗するだけで、コントラクトの残りの部分の働きを引き起こすことはできません。

.. index:: access;restricting

************
アクセス制限
************

.. Restricting access is a common pattern for contracts.
.. Note that you can never restrict any human or computer
.. from reading the content of your transactions or
.. your contract's state. You can make it a bit harder
.. by using encryption, but if your contract is supposed
.. to read the data, so will everyone else.

アクセスを制限することはコントラクトの一般的なパターンです。
トランザクションの内容やコントラクトの状態を人間やコンピュータに読まれないように制限できないことに注意してください。
暗号化することで多少難しくできますが、あなたのコントラクトがデータを読めることになっていれば、他の人も読めてしまいます。

.. You can restrict read access to your contract's state
.. by **other contracts**. That is actually the default
.. unless you declare your state variables ``public``.

コントラクトの状態に対する読み取りアクセスを **other contracts** で制限できます。
これは、状態変数を ``public`` で宣言しない限り、実際にはデフォルトです。

.. Furthermore, you can restrict who can make modifications to your contract's state or call your contract's functions and this is what this section is about.

さらに、コントラクトの状態を変更したり、コントラクトの関数を呼び出すことができる人を制限できますが、これがこのセクションの目的です。

.. index:: function;modifier

.. The use of **function modifiers** makes these restrictions highly readable.

**関数修飾子** を使用することで、これらの制限を非常に読みやすくしています。

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    contract AccessRestriction {
        // これらはコンストラクション段階で代入され、`msg.sender`はこのコントラクトを作成するアカウントです
        address public owner = msg.sender;
        uint public creationTime = block.timestamp;

        // 次に、このコントラクトで発生しうるエラーの一覧とテキストによる説明を特殊なコメントで示します

        /// この操作を実行する権限が送信者にありません
        error Unauthorized();

        /// 関数の呼び出しが早すぎます
        error TooEarly();

        /// 関数コールで送信されるEtherが不足しています
        error NotEnoughEther();

        // 修飾子は、関数のボディを変更するために使用できます
        // この修飾子を使用すると、特定のアドレスから関数が呼び出された場合にのみ実行されるチェックが前置されます
        modifier onlyBy(address account)
        {
            if (msg.sender != account)
                revert Unauthorized();
            // "_;" を忘れないでください！
            // 修飾子が使用されると、実際の関数ボディに置き換えられます
            _;
        }

        /// `newOwner` をこのコントラクトの新しいオーナーにします
        function changeOwner(address newOwner)
            public
            onlyBy(owner)
        {
            owner = newOwner;
        }

        modifier onlyAfter(uint time) {
            if (block.timestamp < time)
                revert TooEarly();
            _;
        }

        /// 所有者情報を消去します
        /// コントラクトが作成されてから6週間後にのみ呼び出すことができます
        function disown()
            public
            onlyBy(owner)
            onlyAfter(creationTime + 6 weeks)
        {
            delete owner;
        }

        // この修飾子は、関数呼び出しに関連する一定の料金を要求します
        // 呼び出し側が過剰に送金した場合、払い戻されますが、関数ボディの後にのみ払い戻されます
        // これは Solidity バージョン 0.4.0 以前では危険で、`_;` の後の部分をスキップすることが可能でした
        modifier costs(uint amount) {
            if (msg.value < amount)
                revert NotEnoughEther();

            _;
            if (msg.value > amount)
                payable(msg.sender).transfer(msg.value - amount);
        }

        function forceOwnerChange(address newOwner)
            public
            payable
            costs(200 ether)
        {
            owner = newOwner;
            // これは条件の一例です
            if (uint160(owner) & 0 == 1)
                // バージョン0.4.0以前のSolidityでは、返金されませんでした
                return;
            // 過払い金を返還します
        }
    }

.. A more specialised way in which access to function
.. calls can be restricted will be discussed
.. in the next example.

関数呼び出しへのアクセスを制限する、より特殊な方法については、次の例で説明します。

.. index:: state machine

**************
ステートマシン
**************

.. Contracts often act as a state machine, which means that they have certain **stages** in which they behave differently or in which different functions can be called.
.. A function call often ends a stage and transitions the contract into the next stage (especially if the contract models **interaction**).
.. It is also common that some stages are automatically reached at a certain point in **time**.

コントラクトはしばしばステートマシンとして動作します。
つまり、異なる動作をする特定の **ステージ** を持っていたり、異なる関数を呼び出すことができるということです。
関数の呼び出しはしばしばステージを終了し、コントラクトを次のステージに移行させる（特にコントラクトが **インタラクション** をモデルとしている場合）。
また、 **ある時点** で自動的に到達するステージもあるのが一般的です。

.. An example for this is a blind auction contract which starts in the stage "accepting blinded bids", then transitions to "revealing bids" which is ended by "determine auction outcome".

例えば、ブラインドオークションのコントラクトでは、「ブラインド入札を受け付ける」というステージから始まり、「入札を公開する」に移行し、「オークションの結果を決定する」で終了します。

.. index:: function;modifier

このような場合、関数修飾子を使って状態をモデル化し、コントラクトの間違った使い方を防ぐことができます。

例
==

次の例では、修飾子 ``atStage`` によって、あるステージでしかその関数を呼び出すことができないようにしています。

時限式の自動トランジションは修飾子 ``timedTransitions`` で処理されます。

.. .. note::

..     **Modifier Order Matters**.
..     If atStage is combined
..     with timedTransitions, make sure that you mention
..     it after the latter, so that the new stage is
..     taken into account.

.. note::

    **修飾子の順序に関して**: 
    atStageがtimedTransitionsと組み合わされている場合は、新しいステージが考慮されるように、後者の後に言及するようにしてください。

.. Finally, the modifier ``transitionNext`` can be used
.. to automatically go to the next stage when the
.. function finishes.

最後に、修飾子 ``transitionNext`` を使うと、関数が終了したときに自動的に次のステージに進むことができます。

.. .. note::

..     **Modifier May be Skipped**.
..     This only applies to Solidity before version 0.4.0:
..     Since modifiers are applied by simply replacing
..     code and not by using a function call,
..     the code in the transitionNext modifier
..     can be skipped if the function itself uses
..     return. If you want to do that, make sure
..     to call nextStage manually from those functions.
..     Starting with version 0.4.0, modifier code
..     will run even if the function explicitly returns.

.. note::

    **修飾子は省略可能**: 
    これは、バージョン0.4.0以前のSolidityにのみ適用されます。
    修飾子は、関数呼び出しを使用せず、単にコードを置き換えることで適用されるため、関数自体がreturnを使用している場合、transitionNext修飾子のコードをスキップできます。
    その場合は、それらの関数から手動でnextStageを呼び出すようにしてください。
    バージョン0.4.0からは、修飾子のコードは、関数が明示的にreturnしても実行されます。

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    contract StateMachine {
        enum Stages {
            AcceptingBlindedBids,
            RevealBids,
            AnotherStage,
            AreWeDoneYet,
            Finished
        }
        /// 現時点では関数を呼び出せません
        error FunctionInvalidAtThisStage();

        // これが現在のステージです
        Stages public stage = Stages.AcceptingBlindedBids;

        uint public creationTime = block.timestamp;

        modifier atStage(Stages stage_) {
            if (stage != stage_)
                revert FunctionInvalidAtThisStage();
            _;
        }

        function nextStage() internal {
            stage = Stages(uint(stage) + 1);
        }

        // 時間指定でトランジションを行います
        // 必ずこの修飾子を最初に指定してください、そうしないとガードは新しいステージを考慮しません
        modifier timedTransitions() {
            if (stage == Stages.AcceptingBlindedBids &&
                        block.timestamp >= creationTime + 10 days)
                nextStage();
            if (stage == Stages.RevealBids &&
                    block.timestamp >= creationTime + 12 days)
                nextStage();
            // トランザクションによる他のステージへの推移
            _;
        }

        // 修飾子の順序が重要です！
        function bid()
            public
            payable
            timedTransitions
            atStage(Stages.AcceptingBlindedBids)
        {
            // 実装は省略します
        }

        function reveal()
            public
            timedTransitions
            atStage(Stages.RevealBids)
        {
        }

        // この修飾子は、関数が終わった後、次のステージに移行します
        modifier transitionNext()
        {
            _;
            nextStage();
        }

        function g()
            public
            timedTransitions
            atStage(Stages.AnotherStage)
            transitionNext
        {
        }

        function h()
            public
            timedTransitions
            atStage(Stages.AreWeDoneYet)
            transitionNext
        {
        }

        function i()
            public
            timedTransitions
            atStage(Stages.Finished)
        {
        }
    }

