###############
Common Patterns
###############

.. index:: withdrawal

.. _withdrawal_pattern:

*************************
Withdrawal from Contracts
*************************

.. The recommended method of sending funds after an effect
.. is using the withdrawal pattern. Although the most intuitive
.. method of sending Ether, as a result of an effect, is a
.. direct ``transfer`` call, this is not recommended as it
.. introduces a potential security risk. You may read
.. more about this on the :ref:`security_considerations` page.

効果後の送金方法としては、出金パターンの使用が推奨されます。エフェクトの結果としてEtherを送信する最も直感的な方法はダイレクト ``transfer`` コールですが、これは潜在的なセキュリティリスクがあるため推奨されません。
これについては、 :ref:`security_considerations` のページで詳しく説明しています。

.. The following is an example of the withdrawal pattern in practice in
.. a contract where the goal is to send the most money to the
.. contract in order to become the "richest", inspired by
.. `King of the Ether <https://www.kingoftheether.com/>`_.

`King of the Ether <https://www.kingoftheether.com/>`_ をヒントに、「一番のお金持ち」になるために一番多くのお金を送ることを目的としたコントラクトにおいて、実際に行われている出金パターンの例を以下に示します。

.. In the following contract, if you are no longer the richest,
.. you receive the funds of the person who is now the richest.

次のコントラクトでは、自分が一番お金持ちでなくなった場合、今一番お金持ちになった人の資金を受け取ります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    contract WithdrawalContract {
        address public richest;
        uint public mostSent;

        mapping (address => uint) pendingWithdrawals;

        /// The amount of Ether sent was not higher than
        /// the currently highest amount.
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

        /// The amount of Ether sent was not higher than
        /// the currently highest amount.
        error NotEnoughEther();

        constructor() payable {
            richest = payable(msg.sender);
            mostSent = msg.value;
        }

        function becomeRichest() public payable {
            if (msg.value <= mostSent) revert NotEnoughEther();
            // This line can cause problems (explained below).
            richest.transfer(msg.value);
            richest = payable(msg.sender);
            mostSent = msg.value;
        }
    }

.. Notice that, in this example, an attacker could trap the
.. contract into an unusable state by causing ``richest`` to be
.. the address of a contract that has a receive or fallback function
.. which fails (e.g. by using ``revert()`` or by just
.. consuming more than the 2300 gas stipend transferred to them). That way,
.. whenever ``transfer`` is called to deliver funds to the
.. "poisoned" contract, it will fail and thus also ``becomeRichest``
.. will fail, with the contract being stuck forever.

この例では、攻撃者は、失敗する受信関数やフォールバック関数を持つコントラクトのアドレスを ``richest`` にすることで、コントラクトを使用不能な状態に陥れることができることに注意してください（例えば、 ``revert()`` を使用したり、送金された2300ガスの俸給を超えて消費したりすることなど）。そうすれば、「毒された」コントラクトに資金を届けるために ``transfer`` が呼び出されるたびに、それは失敗し、したがって ``becomeRichest`` も失敗して、コントラクトは永遠に動けなくなります。

.. In contrast, if you use the "withdraw" pattern from the first example,
.. the attacker can only cause his or her own withdraw to fail and not the
.. rest of the contract's workings.

一方、最初の例の「draw」パターンを使用した場合、攻撃者は自分のdrawが失敗するだけで、コントラクトの残りの部分の働きを引き起こすことはできません。

.. index:: access;restricting

******************
Restricting Access
******************

.. Restricting access is a common pattern for contracts.
.. Note that you can never restrict any human or computer
.. from reading the content of your transactions or
.. your contract's state. You can make it a bit harder
.. by using encryption, but if your contract is supposed
.. to read the data, so will everyone else.

アクセスを制限することはコントラクトの一般的なパターンです。トランザクションの内容やコントラクトの状態を人間やコンピュータに読まれないように制限できないことに注意してください。暗号化することで多少難しくできますが、あなたのコントラクトがデータを読めることになっていれば、他の人も読めてしまいます。

.. You can restrict read access to your contract's state
.. by **other contracts**. That is actually the default
.. unless you declare your state variables ``public``.

コントラクトの状態に対する読み取りアクセスを **other contracts** で制限できます。これは、状態変数を ``public`` で宣言しない限り、実際にはデフォルトです。

.. Furthermore, you can restrict who can make modifications
.. to your contract's state or call your contract's
.. functions and this is what this section is about.

さらに、コントラクトの状態を変更したり、コントラクトの関数を呼び出すことができる人を制限できますが、これがこのセクションの目的です。

.. index:: function;modifier

.. The use of **function modifiers** makes these
.. restrictions highly readable.

**function modifiers** を使用することで、これらの制限を非常に読みやすくしています。

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    contract AccessRestriction {
        // These will be assigned at the construction
        // phase, where `msg.sender` is the account
        // creating this contract.
        address public owner = msg.sender;
        uint public creationTime = block.timestamp;

        // Now follows a list of errors that
        // this contract can generate together
        // with a textual explanation in special
        // comments.

        /// Sender not authorized for this
        /// operation.
        error Unauthorized();

        /// Function called too early.
        error TooEarly();

        /// Not enough Ether sent with function call.
        error NotEnoughEther();

        // Modifiers can be used to change
        // the body of a function.
        // If this modifier is used, it will
        // prepend a check that only passes
        // if the function is called from
        // a certain address.
        modifier onlyBy(address _account)
        {
            if (msg.sender != _account)
                revert Unauthorized();
            // Do not forget the "_;"! It will
            // be replaced by the actual function
            // body when the modifier is used.
            _;
        }

        /// Make `_newOwner` the new owner of this
        /// contract.
        function changeOwner(address _newOwner)
            public
            onlyBy(owner)
        {
            owner = _newOwner;
        }

        modifier onlyAfter(uint _time) {
            if (block.timestamp < _time)
                revert TooEarly();
            _;
        }

        /// Erase ownership information.
        /// May only be called 6 weeks after
        /// the contract has been created.
        function disown()
            public
            onlyBy(owner)
            onlyAfter(creationTime + 6 weeks)
        {
            delete owner;
        }

        // This modifier requires a certain
        // fee being associated with a function call.
        // If the caller sent too much, he or she is
        // refunded, but only after the function body.
        // This was dangerous before Solidity version 0.4.0,
        // where it was possible to skip the part after `_;`.
        modifier costs(uint _amount) {
            if (msg.value < _amount)
                revert NotEnoughEther();

            _;
            if (msg.value > _amount)
                payable(msg.sender).transfer(msg.value - _amount);
        }

        function forceOwnerChange(address _newOwner)
            public
            payable
            costs(200 ether)
        {
            owner = _newOwner;
            // just some example condition
            if (uint160(owner) & 0 == 1)
                // This did not refund for Solidity
                // before version 0.4.0.
                return;
            // refund overpaid fees
        }
    }

.. A more specialised way in which access to function
.. calls can be restricted will be discussed
.. in the next example.

関数呼び出しへのアクセスを制限する、より特殊な方法については、次の例で説明します。

.. index:: state machine

*************
State Machine
*************

.. Contracts often act as a state machine, which means
.. that they have certain **stages** in which they behave
.. differently or in which different functions can
.. be called. A function call often ends a stage
.. and transitions the contract into the next stage
.. (especially if the contract models **interaction**).
.. It is also common that some stages are automatically
.. reached at a certain point in **time**.

コントラクトはしばしばステートマシンとして動作します。つまり、異なる動作をする特定の **stages** を持っていたり、異なる関数を呼び出すことができるということです。関数の呼び出しはしばしばステージを終了し、コントラクトを次のステージに移行させる（特にコントラクトが **interaction** をモデルとしている場合）。また、いくつかのステージが **time** のある時点で自動的に到達することも一般的です。

.. An example for this is a blind auction contract which
.. starts in the stage "accepting blinded bids", then
.. transitions to "revealing bids" which is ended by
.. "determine auction outcome".

例えば、ブラインドオークションのコントラクトでは、「ブラインド入札を受け付ける」という段階から始まり、「入札を公開する」に移行し、「オークションの結果を決定する」で終了します。

.. index:: function;modifier

.. Function modifiers can be used in this situation
.. to model the states and guard against
.. incorrect usage of the contract.

このような場合、関数修飾子を使って状態をモデル化し、コントラクトの間違った使い方を防ぐことができます。

Example
=======

.. In the following example,
.. the modifier ``atStage`` ensures that the function can
.. only be called at a certain stage.

次の例では、修飾子 ``atStage`` によって、ある段階でしかその関数を呼び出すことができないようにしています。

.. Automatic timed transitions
.. are handled by the modifier ``timedTransitions``, which
.. should be used for all functions.

時限式の自動トランジションは修飾子 ``timedTransitions`` で処理されます。

.. .. note::

..     **Modifier Order Matters**.
..     If atStage is combined
..     with timedTransitions, make sure that you mention
..     it after the latter, so that the new stage is
..     taken into account.

.. note::

    **Modifier Order Matters** .     atStageがtimedTransitionsと組み合わされている場合は、新しいステージが考慮されるように、後者の後に言及するようにしてください。

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

    **Modifier May be Skipped** です。
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
        /// Function cannot be called at this time.
        error FunctionInvalidAtThisStage();

        // This is the current stage.
        Stages public stage = Stages.AcceptingBlindedBids;

        uint public creationTime = block.timestamp;

        modifier atStage(Stages _stage) {
            if (stage != _stage)
                revert FunctionInvalidAtThisStage();
            _;
        }

        function nextStage() internal {
            stage = Stages(uint(stage) + 1);
        }

        // Perform timed transitions. Be sure to mention
        // this modifier first, otherwise the guards
        // will not take the new stage into account.
        modifier timedTransitions() {
            if (stage == Stages.AcceptingBlindedBids &&
                        block.timestamp >= creationTime + 10 days)
                nextStage();
            if (stage == Stages.RevealBids &&
                    block.timestamp >= creationTime + 12 days)
                nextStage();
            // The other stages transition by transaction
            _;
        }

        // Order of the modifiers matters here!
        function bid()
            public
            payable
            timedTransitions
            atStage(Stages.AcceptingBlindedBids)
        {
            // We will not implement that here
        }

        function reveal()
            public
            timedTransitions
            atStage(Stages.RevealBids)
        {
        }

        // This modifier goes to the next stage
        // after the function is done.
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

