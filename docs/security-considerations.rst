.. _security_considerations:

####################
セキュリティへの配慮
####################

想定通りに動作するソフトウェアを作るのは簡単ですが、想定外の使い方をされないようにチェックするのは非常に困難です。

Solidityでは、スマートコントラクトを使ってトークンや、もっと価値のあるものを扱うことができるので、セキュリティはさらに重要です。
加えて、スマートコントラクトの実行はすべて公開されており、ソースコードも公開されることがあります。

もちろん、セキュリティにどれだけの価値があるかは常に考えなければなりません:
スマートコントラクトは、パブリックに公開されていて（つまり悪意のあるアクターにも公開されていて）オープンソースであることがあるWebサービスと比較できます。
そのウェブサービスに食料品のリストを保存するだけであれば、それほど注意を払う必要はないかもしれませんが、そのWebサービスを使って銀行口座を管理する場合には、より注意を払う必要があります。

.. This section will list some pitfalls and general security recommendations but can, of course, never be complete.
.. Also, keep in mind that even if your smart contract code is bug-free, the compiler or the platform itself might have a bug.
.. A list of some publicly known security-relevant bugs of the compiler can be found in the :ref:`list of known bugs<known_bugs>`, which is also machine-readable.
.. Note that there is a bug bounty program that covers the code generator of the Solidity compiler.

このセクションでは、いくつかの落とし穴や一般的なセキュリティ上の推奨事項を挙げていきますが、もちろん完全なものではありません。
また、スマートコントラクトのコードにバグがない場合でも、コンパイラやプラットフォーム自体にバグがある可能性があることも覚えておいてください。
コンパイラのセキュリティ関連の既知のバグのリストは :ref:`既知のバグリスト<known_bugs>` に掲載されており、機械でも読めます。
なお、Solidityコンパイラのコードジェネレータを対象としたバグバウンティプログラムがあります。

.. As always, with open source documentation, please help us extend this section (especially, some examples would not hurt)!

いつものように、オープンソースのドキュメントでは、このセクションの拡張にご協力ください（特に、いくつかの例があれば問題ありません）。

.. NOTE: In addition to the list below, you can find more security recommendations and best practices
.. `in Guy Lando's knowledge list <https://github.com/guylando/KnowledgeLists/blob/master/EthereumSmartContracts.md>`_ and
.. `the Consensys GitHub repo <https://consensys.github.io/smart-contract-best-practices/>`_.

注: 以下のリストの他にも、セキュリティに関する推奨事項やベストプラクティスが `Guy Landoのリスト <https://github.com/guylando/KnowledgeLists/blob/master/EthereumSmartContracts.md>`_ および `ConsensysのGitHubリポジトリ <https://consensys.github.io/smart-contract-best-practices/>`_ に掲載されています。

********
落とし穴
********

プライベートの情報とランダム性
==============================

スマートコントラクト上で利用できるものはすべて公開されており、ローカル変数や ``private`` と書かれた状態変数も公開されています。

スマートコントラクトで乱数を使用することは、ブロックビルダーが不正行為をする可能性があるため、困難です。

Re-Entrancy
===========

.. Any interaction from a contract (A) with another contract (B) and any transfer of Ether hands over control to that contract (B).
.. This makes it possible for B to call back into A before this interaction is completed.
.. To give an example, the following code contains a bug (it is just a snippet and not a complete contract):

コントラクト（A）と別のコントラクト（B）とのインタラクションやEtherの送金は、コントラクト（B）に制御権を渡します。
これにより、このインタラクションが完了する前に、BがAにコールバックすることが可能になります。
例として、以下のコードにはバグが含まれています（これは単なるスニペットであり、完全なコントラクトではありません）。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    // このコントラクトにはバグが含まれています - 使わないでください
    contract Fund {
        /// @dev Etherシェアのマッピング
        mapping(address => uint) shares;
        /// シェアを引き出す
        function withdraw() public {
            if (payable(msg.sender).send(shares[msg.sender]))
                shares[msg.sender] = 0;
        }
    }

この問題は、 ``send`` にガス制限があるため、それほど深刻ではありませんが、それでも脆弱性があります。
Etherの送金には常にコードの実行が含まれるため、受信者は ``withdraw`` にコールバックするコントラクトになる可能性があります。
これにより、複数回の払い戻しが可能となり、基本的にはコントラクト内のすべてのEtherを回収できます。
特に、以下のコントラクトは、デフォルトで残りのガスをすべて送金する ``call`` を使用しているため、攻撃者は複数回返金できます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.2 <0.9.0;

    // このコントラクトにはバグが含まれています - 使わないでください
    contract Fund {
        /// @dev Etherシェアのマッピング
        mapping(address => uint) shares;
        /// シェアを引き出す
        function withdraw() public {
            (bool success,) = msg.sender.call{value: shares[msg.sender]}("");
            if (success)
                shares[msg.sender] = 0;
        }
    }

Re-entrancyを避けるために、以下のようなChecks-Effects-Interactionsパターンを使用できます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    contract Fund {
        /// @dev Etherシェアのマッピング
        mapping(address => uint) shares;
        /// シェアを引き出す
        function withdraw() public {
            uint share = shares[msg.sender];
            shares[msg.sender] = 0;
            payable(msg.sender).transfer(share);
        }
    }

The Checks-Effects-Interactions pattern ensures that all code paths through a contract complete all required checks
of the supplied parameters before modifying the contract's state (Checks); only then it makes any changes to the state (Effects);
it may make calls to functions in other contracts *after* all planned state changes have been written to
storage (Interactions). This is a common foolproof way to prevent *re-entrancy attacks*, where an externally called
malicious contract is able to double-spend an allowance, double-withdraw a balance, among other things, by using logic that calls back into the
original contract before it has finalized its transaction.

.. Note that re-entrancy is not only an effect of Ether transfer but of any function call on another contract. Furthermore, you also have to take multi-contract situations into account.
.. A called contract could modify the state of another contract you depend on.

Re-entrancyは、Ether送金だけでなく、別のコントラクトでのあらゆる関数呼び出しの影響を受けることに注意してください。
さらに、複数のコントラクトを考慮しなければならない状況もあります。
呼び出されたコントラクトが、依存している別のコントラクトの状態を変更する可能性があります。

ガスリミットとループ
====================

.. Loops that do not have a fixed number of iterations, for example, loops that depend on storage values, have to be used carefully:
.. Due to the block gas limit, transactions can only consume a certain amount of gas.
.. Either explicitly or just due to normal operation, the number of iterations in a loop can grow beyond the block gas limit which can cause the complete contract to be stalled at a certain point.
.. This may not apply to ``view`` functions that are only executed to read data from the blockchain.
.. Still, such functions may be called by other contracts as part of on-chain operations and stall those.
.. Please be explicit about such cases in the documentation of your contracts.

例えば、ストレージの値に依存するループなど、反復回数が固定されていないループは、慎重に使用する必要があります。
ブロックガスリミットにより、トランザクションは一定量のガスしか消費できません。
明示的に、または通常の操作によって、ループの反復回数がブロックガスリミットを超えてしまい、コントラクト全体がある時点で停止してしまうことがあります。
これは、ブロックチェーンからデータを読み取るためだけに実行される ``view`` 関数には当てはまらないかもしれません。
それでも、そのような関数はオンチェーン操作の一部として他のコントラクトから呼び出され、それらを引き伸ばすことができます。
このようなケースについては、コントラクトのドキュメントで明示してください。

Etherの送受信
=============

.. - Neither contracts nor "external accounts" are currently able to prevent that someone sends them Ether.
..   Contracts can react on and reject a regular transfer, but there are ways to move Ether without creating a message call.
..   One way is to simply "mine to" the contract address and the second way is using ``selfdestruct(x)``.

- コントラクトも「外部アカウント」も、誰かがEtherを送ってくるのを防ぐことは今のところできません。
  コントラクトは、通常の送金に反応して拒否できますが、メッセージコールを作成せずにEtherを移動する方法があります。
  ひとつはコントラクトのアドレスに単純に「マイニング」する方法で、もうひとつは ``selfdestruct(x)`` を使う方法です。

.. - If a contract receives Ether (without a function being called), either the :ref:`receive Ether <receive-ether-function>` or the :ref:`fallback <fallback-function>` function is executed.
..   If it does not have a receive nor a fallback function, the Ether will be rejected (by throwing an exception).
..   During the execution of one of these functions, the contract can only rely on the "gas stipend" it is passed (2300 gas) being available to it at that time.
..   This stipend is not enough to modify storage (do not take this for granted though, the stipend might change with future hard forks).
..   To be sure that your contract can receive Ether in that way, check the gas requirements of the receive and fallback functions (for example in the "details" section in Remix).

- コントラクトが（関数が呼ばれずに）Etherを受信すると、 :ref:`receive Ether <receive-ether-function>` または :ref:`fallback <fallback-function>` 関数が実行されます。
  receive関数もfallback関数も持たない場合、Etherは（例外を投げて）拒否されます。
  これらの関数が実行されている間、コントラクトは、渡された「gas stipend」（2300ガス）がその時点で利用可能であることにのみ依存できます。
  この供給量は、ストレージを変更するのに十分ではありません（将来のハードフォークで供給量が変更される可能性がありますので、これを鵜呑みにしてはいけません）。
  コントラクトがこの方法でEtherを受け取ることができるかどうかを確認するには、receive関数とfallback関数のガス要件を確認してください（例えばRemixの「詳細」セクションに記載されています）。

.. - There is a way to forward more gas to the receiving contract using
..   ``addr.call{value: x}("")``. This is essentially the same as ``addr.transfer(x)``,
..   only that it forwards all remaining gas and opens up the ability for the
..   recipient to perform more expensive actions (and it returns a failure code
..   instead of automatically propagating the error). This might include calling back
..   into the sending contract or other state changes you might not have thought of.
..   So it allows for great flexibility for honest users but also for malicious actors.

- ``addr.call{value: x}("")`` を使用して、より多くのガスを受信コントラクトに送金する方法があります。
  これは基本的に ``addr.transfer(x)`` と同じですが、残りのガスをすべて送金し、受信側がより高価なアクションを実行できるようにします（また、自動的にエラーを伝播するのではなく、失敗コードを返します）。
  これには、送信側のコントラクトにコールバックすることや、あなたが考えもしなかったような他の状態変化が含まれるかもしれません。
  そのため、誠実なユーザーだけでなく、悪意のあるアクターにも大きな柔軟性を与えることができます。

.. - Use the most precise units to represent the wei amount as possible, as you lose any that is rounded due to a lack of precision.

- weiの量を表す単位は、精度が低いために丸められたものは失われてしまうので、できるだけ正確な単位を使ってください。

.. - If you want to send Ether using ``address.transfer``, there are certain details to be aware of:

..   1. If the recipient is a contract, it causes its receive or fallback function
..      to be executed which can, in turn, call back the sending contract.

..   2. Sending Ether can fail due to the call depth going above 102

..   3. Since the
..      caller is in total control of the call depth, they can force the
..      transfer to fail; take this possibility into account or use ``send`` and
..      make sure to always check its return value. Better yet, write your
..      contract using a pattern where the recipient can withdraw Ether instead.

..   4. Sending Ether can also fail because the execution of the recipient
..      contract requires more than the allotted amount of gas (explicitly by
..      using :ref:`require <assert-and-require>`, :ref:`assert <assert-and-require>`,
..      :ref:`revert <assert-and-require>` or because the
..      operation is too expensive) - it "runs out of gas" (OOG).  If you
..      use ``transfer`` or ``send`` with a return value check, this might
..      provide a means for the recipient to block progress in the sending
..      contract. Again, the best practice here is to use a :ref:`"withdraw"
..      pattern instead of a "send" pattern <withdrawal_pattern>`.

- ``address.transfer`` を使ってEtherを送信する場合、注意すべき点があります。

  1. 受信者がコントラクトの場合、そのreceive関数またはfallback関数を実行させ、その結果、送信側のコントラクトをコールバックできます。

  2. コールの深さが102以上になると、Etherの送信に失敗することがあります。

  3. 呼び出し側はコールの深さを完全にコントロールしているため、強制的に送金を失敗させることができます。
     この可能性を考慮して ``send`` を使用するか、その戻り値を常に確認するようにしてください。
     さらに言えば、受取人が代わりにEtherを引き出せるようなパターンでコントラクトを書いてください。

  4. Etherの送信は、受信者のコントラクトの実行に割り当てられた量以上のガスが必要となるため（ :ref:`require <assert-and-require>` 、 :ref:`assert <assert-and-require>` 、 :ref:`revert <assert-and-require>` を使用して明示的に、または操作が高すぎるため）、「ガス欠」（OOG）となって失敗することもあります。
     ``transfer`` または ``send`` を戻り値のチェックとともに使用すると、受信者が送信側のコントラクトの進行をブロックする手段となる可能性があります。
     ここでも、 :ref:`sendパターンの代わりにwithdrawパターン <withdrawal_pattern>` を使用するのがベストです。

コールスタックの深さ
====================

.. External function calls can fail any time because they exceed the maximum call stack size limit of 1024. In such situations, Solidity throws an exception.
.. Malicious actors might be able to force the call stack to a high value before they interact with your contract.
.. Note that, since `Tangerine Whistle <https://eips.ethereum.org/EIPS/eip-608>`_ hardfork, the `63/64 rule <https://eips.ethereum.org/EIPS/eip-150>`_ makes call stack depth attack impractical.
.. Also note that the call stack and the expression stack are unrelated, even though both have a size limit of 1024 stack slots.

外部関数の呼び出しは、コールスタックの最大サイズ制限である1024を超えるため、いつでも失敗する可能性があります。
このような状況では、Solidityは例外を投げます。
悪意のあるアクターは、コントラクトと対話する前にコールスタックを強制的に高い値にできるかもしれません。
`Tangerine Whistle <https://eips.ethereum.org/EIPS/eip-608>`_ のハードフォーク以来、 `63/64ルール <https://eips.ethereum.org/EIPS/eip-150>`_ はコールスタックの深さの攻撃を実用的ではないものにしていることに注意してください。
また、コールスタックとエクスプレッションスタックは、どちらも1024のスタックスロットというサイズ制限がありますが、無関係であることに注意してください。

``.send()`` はコールスタックが枯渇した場合に例外を発生させず、 ``false`` を返すことに注意してください。
低レベル関数の ``.call()`` 、 ``.delegatecall()`` 、 ``.staticcall()`` も同じように動作します。

Authorized Proxies
==================

.. If your contract can act as a proxy, i.e. if it can call arbitrary contracts with user-supplied data, then the user can essentially assume the identity of the proxy contract.
.. Even if you have other protective measures in place, it is best to build your contract system such that the proxy does not have any permissions (not even for itself).
.. If needed, you can accomplish that using a second proxy:

コントラクトがプロキシとして動作できる場合、つまり、ユーザーが提供したデータで任意のコントラクトを呼び出すことができる場合、ユーザーは基本的にプロキシのコントラクトのアイデンティティを仮定できます。
他の保護手段があったとしても、プロキシが（自分自身のためでさえも）いかなる許可も持たないようにコントラクトシステムを構築することが最善です。
必要であれば、第二のプロキシを使ってそれを達成できます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.0;
    contract ProxyWithMoreFunctionality {
        PermissionlessProxy proxy;

        function callOther(address addr, bytes memory payload) public
                returns (bool, bytes memory) {
            return proxy.callOther(addr, payload);
        }
        // その他の関数や機能
    }

    // これは完全なコントラクトであり、他の機能はなく、動作するために特権を必要としません。
    contract PermissionlessProxy {
        function callOther(address addr, bytes memory payload) public
                returns (bool, bytes memory) {
            return addr.call(payload);
        }
    }

tx.origin
=========

認証に tx.origin を使用しないでください。以下のようなウォレットコントラクトがあるとします。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    // このコントラクトにはバグが含まれています - 使わないでください
    contract TxUserWallet {
        address owner;

        constructor() {
            owner = msg.sender;
        }

        function transferTo(address payable dest, uint amount) public {
            // バグはここにあります。tx.originの代わりにmsg.senderを使用する必要があります。
            require(tx.origin == owner);
            dest.transfer(amount);
        }
    }

.. Now someone tricks you into sending Ether to the address of this attack wallet:

今度は誰かに騙されて、この攻撃用ウォレットのアドレスにEtherを送ってしまうとしましょう。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    interface TxUserWallet {
        function transferTo(address payable dest, uint amount) external;
    }

    contract TxAttackWallet {
        address payable owner;

        constructor() {
            owner = payable(msg.sender);
        }

        receive() external payable {
            TxUserWallet(msg.sender).transferTo(owner, msg.sender.balance);
        }
    }

.. If your wallet had checked ``msg.sender`` for authorization, it would get the address of the attack wallet, instead of the owner address. But by checking ``tx.origin``, it gets the original address that kicked off the transaction, which is still the owner address. The attack wallet instantly drains all your funds.

もしあなたのウォレットが ``msg.sender`` をチェックして承認を得ていたら、所有者のアドレスではなく、攻撃したウォレットのアドレスを得ることになります。
しかし、 ``tx.origin`` をチェックすると、トランザクションを開始した元のアドレスが取得され、それがオーナーのアドレスとなります。
攻撃されたウォレットは即座にあなたの資金をすべて使い果たしてしまいます。

.. _underflow-overflow:

2の補数 / アンダーフロー / オーバーフロー
=========================================

.. As in many programming languages, Solidity's integer types are not actually integers.
.. They resemble integers when the values are small, but cannot represent arbitrarily large numbers.

多くのプログラミング言語と同様に、Solidityの整数型は実際には整数ではありません。
値が小さいときは整数に似ていますが、任意に大きな数値を表すことはできません。

以下のコードでは、加算結果が大きすぎて ``uint8`` 型に格納できないため、オーバーフローが発生します。

.. code-block:: solidity

  uint8 x = 255;
  uint8 y = 1;
  return x + y;

.. Solidity has two modes in which it deals with these overflows: Checked and Unchecked or "wrapping" mode.

Solidityには、これらのオーバーフローを処理する2つのモードがあります。
チェックされたモードとチェックされていないモード、つまり「ラッピング」モードです。

.. The default checked mode will detect overflows and cause a failing assertion. You can disable this check
.. using ``unchecked { ... }``, causing the overflow to be silently ignored. The above code would return
.. ``0`` if wrapped in ``unchecked { ... }``.

デフォルトのチェックモードでは、オーバーフローを検出し、アサーションの失敗を引き起こします。
``unchecked { ... }`` を使ってこのチェックを無効にすることで、オーバーフローを静かに無視できます。
上記のコードは、 ``unchecked { ... }``  でラップすると  ``0``  を返します。

.. Even in checked mode, do not assume you are protected from overflow bugs.
.. In this mode, overflows will always revert. If it is not possible to avoid the overflow, this can lead to a smart contract being stuck in a certain state.

チェックモードであっても、オーバーフローのバグから守られていると思わないでください。
このモードでは、オーバーフローは必ずリバートします。
オーバーフローを回避できない場合、スマートコントラクトが特定の状態で立ち往生してしまう可能性があります。

.. In general, read about the limits of two's complement representation, which even has some more special edge cases for signed numbers.

一般的には、2の補数表現の限界について読んでみてください。2の補数表現には、符号付きの数字に対するより特別なエッジケースもあります。

.. Try to use ``require`` to limit the size of inputs to a reasonable range and use the
.. :ref:`SMT checker<smt_checker>` to find potential overflows.

``require`` を使って入力の大きさを合理的な範囲に制限し、 :ref:`SMTチェッカー<smt_checker>` を使ってオーバーフローの可能性を見つけるようにしましょう。

.. _clearing-mappings:

マッピングのクリア
==================

.. The Solidity type ``mapping`` (see :ref:`mapping-types`) is a storage-only key-value data structure that does not keep track of the keys that were assigned a non-zero value.
.. Because of that, cleaning a mapping without extra information about the written keys is not possible.
.. If a ``mapping`` is used as the base type of a dynamic storage array, deleting or popping the array will have no effect over the ``mapping`` elements.
.. The same happens, for example, if a ``mapping`` is used as the type of a member field of a ``struct`` that is the base type of a dynamic storage array.
.. The ``mapping`` is also ignored in assignments of structs or arrays containing a ``mapping``.

Solidityの型 ``mapping`` （ :ref:`mapping-types` 参照）は、ストレージのみのキーバリューデータ構造で、ゼロ以外の値が割り当てられたキーを追跡しません。
そのため、書き込まれたキーに関する余分な情報を持たないマッピングのクリーニングは不可能です。
``mapping`` が動的ストレージ配列の基本型として使用されている場合、配列を削除したりポップしたりしても ``mapping`` の要素には影響しません。
例えば、動的ストレージ配列のベース型である ``struct`` のメンバーフィールドの型として ``mapping`` が使用されている場合も同様です。
また、 ``mapping`` を含む構造体や配列の代入においても、 ``mapping`` は無視されます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    contract Map {
        mapping(uint => uint)[] array;

        function allocate(uint newMaps) public {
            for (uint i = 0; i < newMaps; i++)
                array.push();
        }

        function writeMap(uint map, uint key, uint value) public {
            array[map][key] = value;
        }

        function readMap(uint map, uint key) public view returns (uint) {
            return array[map][key];
        }

        function eraseMaps() public {
            delete array;
        }
    }

.. Consider the example above and the following sequence of calls: ``allocate(10)``, ``writeMap(4, 128, 256)``.
.. At this point, calling ``readMap(4, 128)`` returns 256.
.. If we call ``eraseMaps``, the length of state variable ``array`` is zeroed, but since its ``mapping`` elements cannot be zeroed, their information stays alive in the contract's storage.
.. After deleting ``array``, calling ``allocate(5)`` allows us to access ``array[4]`` again, and calling ``readMap(4, 128)`` returns 256 even without another call to ``writeMap``.

上の例で、次のような一連のコールを考えてみましょう: ``allocate(10)``, ``writeMap(4, 128, 256)`` 。
この時点で、 ``readMap(4, 128)`` を呼び出すと256を返します。
``eraseMaps`` を呼び出すと、状態変数 ``array`` の長さはゼロになりますが、その ``mapping`` 要素はゼロにできないので、その情報はコントラクトのストレージの中で生き続けます。
``array`` を削除した後、 ``allocate(5)`` を呼び出すと、再び ``array[4]`` にアクセスできるようになり、 ``readMap(4, 128)`` を呼び出すと、 ``writeMap`` を再度呼び出さなくても256を返します。

.. If your ``mapping`` information must be deleted, consider using a library similar to `iterable mapping <https://github.com/ethereum/dapp-bin/blob/master/library/iterable_mapping.sol>`_, allowing you to traverse the keys and delete their values in the appropriate ``mapping``.

``mapping`` の情報を削除する必要がある場合は、 `iterable mapping <https://github.com/ethereum/dapp-bin/blob/master/library/iterable_mapping.sol>`_ と同様のライブラリを使用することを検討し、適切な ``mapping`` でキーをトラバースしてその値を削除できます。

マイナーな内容
==============

.. - Types that do not occupy the full 32 bytes might contain "dirty higher order bits".
..   This is especially important if you access ``msg.data`` - it poses a malleability risk:
..   You can craft transactions that call a function ``f(uint8 x)`` with a raw byte argument of ``0xff000001`` and with ``0x00000001``.
..   Both are fed to the contract and both will look like the number ``1`` as far as ``x`` is concerned, but ``msg.data`` will be different, so if you use ``keccak256(msg.data)`` for anything, you will get different results.

- 32バイトを完全に占有しない型には、「ダーティな高次ビット」が含まれている可能性があります。
  これは ``msg.data`` にアクセスする場合に特に重要で、不正改造の危険性があります:
  関数 ``f(uint8 x)`` を生のバイト引数 ``0xff000001`` で呼び出すトランザクションと、 ``0x00000001`` で呼び出すトランザクションを作ることができます。
  両方ともコントラクトに供給され、 ``x`` に関しては両方とも ``1`` という数字に見えますが、 ``msg.data`` は異なるものになりますので、何かに ``keccak256(msg.data)`` を使うと、異なる結果になります。

********
推奨事項
********

警告を真摯に受け止める
======================

.. If the compiler warns you about something, you should change it.
.. Even if you do not think that this particular warning has security implications, there might be another issue buried beneath it.
.. Any compiler warning we issue can be silenced by slight changes to the code.

コンパイラが何かを警告したら、それを変更すべきです。
その警告がセキュリティに影響するとは思わなくても、その下に別の問題が隠れているかもしれません。
私たちが発するコンパイラの警告は、コードを少し変更するだけで黙らせることができます。

.. Always use the latest version of the compiler to be notified about all recently introduced warnings.

最近導入されたすべての警告について通知を受けるには、常に最新バージョンのコンパイラを使用してください。

.. Messages of type ``info`` issued by the compiler are not dangerous, and simply
.. represent extra suggestions and optional information that the compiler thinks
.. might be useful to the user.

コンパイラが発行する ``info`` 型のメッセージは危険なものではなく、ユーザにとって有用であるとコンパイラが考える追加の提案やオプション情報を表しています。

Etherの量を制限する
===================

.. Restrict the amount of Ether (or other tokens) that can be stored in a smart
.. contract. If your source code, the compiler or the platform has a bug, these
.. funds may be lost. If you want to limit your loss, limit the amount of Ether.

スマートコントラクトに格納できるEther（または他のトークン）の量を制限します。
ソースコードやコンパイラ、プラットフォームにバグがあると、これらの資金が失われる可能性があります。
損失を制限したい場合は、Etherの量を制限してください。

小さくモジュール化する
======================

.. Keep your contracts small and easily understandable.
.. Single out unrelated functionality in other contracts or into libraries.
.. General recommendations about source code quality of course apply:
.. Limit the amount of local variables, the length of functions and so on.
.. Document your functions so that others can see what your intention was and whether it is different than what the code does.

コントラクトは小さく、理解しやすいものにしましょう。
関係のない機能は他のコントラクトやライブラリにまとめてください。
もちろん、ソースコードの品質に関する一般的な推奨事項も適用されます。
ローカル変数の量や関数の長さなどを制限してください。
また、あなたの意図が何であるか、それがコードが行うことと異なるかどうかを他の人が理解できるように、関数を文書化してください。

Checks-Effects-Interactionsパターンを使う
=========================================

.. Most functions will first perform some checks (who called the function, are the arguments in range, did they send enough Ether, does the person have tokens, etc.).
.. These checks should be done first.

ほとんどの関数は、最初にいくつかのチェックを行います（誰が関数を呼び出したか、引数は範囲内か、十分な量のEtherを送ったか、相手はトークンを持っているか、など）。
これらのチェックは最初に行われるべきです。

.. As the second step, if all checks passed, effects to the state variables of the current contract should be made.
.. Interaction with other contracts should be the very last step in any function.

2番目のステップとして、すべてのチェックがパスした場合、現在のコントラクトの状態変数への効果が作られるべきです。
他のコントラクトとのやりとりは、どの関数でも最後のステップにすべきです。

.. Early contracts delayed some effects and waited for external function calls to return in a non-error state.
.. This is often a serious mistake because of the re-entrancy problem explained above.

初期のコントラクトでは、いくつかの効果を遅らせ、外部の関数呼び出しが非エラー状態で戻ってくるのを待っていました。
これは、上で説明したRe-entrancyの問題のため、しばしば重大な誤りとなります。

.. Note that, also, calls to known contracts might in turn cause calls to
.. unknown contracts, so it is probably better to just always apply this pattern.

なお、既知のコントラクトを呼び出すと、未知のコントラクトを呼び出す可能性もあるので、常にこのパターンを適用するのが良いでしょう。

フェイルセーフモードを搭載する
==============================

.. While making your system fully decentralised will remove any intermediary,
.. it might be a good idea, especially for new code, to include some kind
.. of fail-safe mechanism:

システムを完全に非中央集権化することで、仲介者を排除できますが、特に新しいコードには、何らかのフェイルセーフメカニズムを組み込むことが良いかもしれません。

.. You can add a function in your smart contract that performs some
.. self-checks like "Has any Ether leaked?",
.. "Is the sum of the tokens equal to the balance of the contract?" or similar things.
.. Keep in mind that you cannot use too much gas for that, so help through off-chain
.. computations might be needed there.

スマートコントラクトの中に、「Etherが漏れていないか」「トークンの合計がコントラクトの残高と同じか」などの自己チェックを行う関数を追加できます。
そのためには、あまり多くのガスを使うことはできないので、オフチェーンの計算による助けが必要になるかもしれないことを覚えておいてください。

.. If the self-check fails, the contract automatically switches into some kind
.. of "failsafe" mode, which, for example, disables most of the features, hands over
.. control to a fixed and trusted third party or just converts the contract into
.. a simple "give me back my money" contract.

セルフチェックに失敗すると、コントラクトは自動的にある種の「フェイルセーフ」モードに切り替わります。
例えば、ほとんどの機能を無効にしたり、固定された信頼できる第三者にコントロールを委ねたり、あるいは単に「お金を返してください」というコントラクトに変更したりします。

ピアレビューを依頼する
======================

.. Asking people to review your code also helps as a cross-check to find out whether your code is easy to understand - a very important criterion for good smart contracts.

多くの人がコードを検証すればするほど、多くの問題が見つかります。
また、人にコードを見てもらうことで、コードがわかりやすいかどうかのクロスチェックにもなり、これは優れたスマートコントラクトにとって非常に重要な基準です。
