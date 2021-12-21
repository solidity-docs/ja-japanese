********************
Micropayment Channel
********************

.. In this section we will learn how to build an example implementation
.. of a payment channel. It uses cryptographic signatures to make
.. repeated transfers of Ether between the same parties secure, instantaneous, and
.. without transaction fees. For the example, we need to understand how to
.. sign and verify signatures, and setup the payment channel.

このセクションでは、ペイメントチャネルの実装例を構築する方法を学びます。これは、暗号化された署名を使用して、同一の当事者間で繰り返されるEtherの送金を、安全かつ瞬時に、トランザクション手数料なしで行うものです。この例では、署名と検証の方法を理解し、ペイメントチャネルを設定する必要があります。

Creating and verifying signatures
=================================

.. Imagine Alice wants to send some Ether to Bob, i.e.
.. Alice is the sender and Bob is the recipient.

アリスがボブにイーサを送りたいと思っているとします。

.. Alice only needs to send cryptographically signed messages off-chain
.. (e.g. via email) to Bob and it is similar to writing checks.

アリスは暗号化されたメッセージをオフチェーンで（例えばメールで）ボブに送るだけでよく、小切手を書くのと同じようなものです。

.. Alice and Bob use signatures to authorise transactions, which is possible with smart contracts on Ethereum.
.. Alice will build a simple smart contract that lets her transmit Ether, but instead of calling a function herself
.. to initiate a payment, she will let Bob do that, and therefore pay the transaction fee.

AliceとBobは署名を使ってトランザクションを承認しますが、これはEthereumのスマートコントラクトで可能です。AliceはEtherを送信できるシンプルなスマートコントラクトを構築しますが、支払いを開始するために自分で関数を呼び出すのではなく、Bobにそれをさせ、その結果、トランザクション手数料を支払うことになります。

.. The contract will work as follows:

..     1. Alice deploys the ``ReceiverPays`` contract, attaching enough Ether to cover the payments that will be made.

..     2. Alice authorises a payment by signing a message with her private key.

..     3. Alice sends the cryptographically signed message to Bob. The message does not need to be kept secret
..        (explained later), and the mechanism for sending it does not matter.

..     4. Bob claims his payment by presenting the signed message to the smart contract, it verifies the
..        authenticity of the message and then releases the funds.

コントラクト内容は以下のようになっています。

    1. アリスは ``ReceiverPays`` コントラクトをデプロイし、行われるであろう支払いをカバーするのに十分なEtherを取り付けます。

    2. アリスは、自分の秘密鍵でメッセージを署名することで、支払いを承認します。

    3. アリスは、暗号署名されたメッセージをボブに送信する。メッセージは秘密にしておく必要はなく（後で説明します）、送信の仕組みも問題ありません。

    4. Bobはスマートコントラクトに署名済みのメッセージを提示して支払いを請求し、スマートコントラクトはメッセージの真正性を検証した後、資金を放出します。

Creating the signature
----------------------

.. Alice does not need to interact with the Ethereum network
.. to sign the transaction, the process is completely offline.
.. In this tutorial, we will sign messages in the browser
.. using `web3.js <https://github.com/ethereum/web3.js>`_ and
.. `MetaMask <https://metamask.io>`_, using the method described in `EIP-762 <https://github.com/ethereum/EIPs/pull/712>`_,
.. as it provides a number of other security benefits.

アリスはトランザクションに署名するためにEthereumネットワークと対話する必要はなく、プロセスは完全にオフラインです。このチュートリアルでは、他にも多くのセキュリティ上の利点があるため、 `EIP-762 <https://github.com/ethereum/EIPs/pull/712>`_ で説明した方法を用いて、 `web3.js <https://github.com/ethereum/web3.js>`_ と `MetaMask <https://metamask.io>`_ を使ってブラウザ上でメッセージを署名します。

.. code-block:: javascript

    /// Hashing first makes things easier
    var hash = web3.utils.sha3("message to sign");
    web3.eth.personal.sign(hash, web3.eth.defaultAccount, function () { console.log("Signed"); });

.. .. note::

..   The ``web3.eth.personal.sign`` prepends the length of the
..   message to the signed data. Since we hash first, the message
..   will always be exactly 32 bytes long, and thus this length
..   prefix is always the same.

.. note::

  ``web3.eth.personal.sign`` はメッセージの長さを署名済みデータの前に付けます。最初にハッシュ化するので、メッセージは常に正確な32バイトの長さになり、したがってこの長さのプレフィックスは常に同じになります。

What to Sign
------------

.. For a contract that fulfils payments, the signed message must include:

..     1. The recipient's address.

..     2. The amount to be transferred.

..     3. Protection against replay attacks.

支払いを履行するコントラクトの場合、署名されたメッセージには以下が含まれていなければなりません。

    1. 受信者の住所です。

    2. 送金される金額です。

    3. リプレイアタックへの対策

.. A replay attack is when a signed message is reused to claim
.. authorization for a second action. To avoid replay attacks
.. we use the same technique as in Ethereum transactions themselves,
.. a so-called nonce, which is the number of transactions sent by
.. an account. The smart contract checks if a nonce is used multiple times.

リプレイ攻撃とは、署名されたメッセージが再利用されて、2回目のアクションの認証を主張することです。リプレイ攻撃を避けるために、私たちはEthereumのトランザクション自体と同じ技術、いわゆるnonceを使用していますが、これはアカウントから送信されたトランザクションの数です。スマートコントラクトは、nonceが複数回使用されているかどうかをチェックします。

.. Another type of replay attack can occur when the owner
.. deploys a ``ReceiverPays`` smart contract, makes some
.. payments, and then destroys the contract. Later, they decide
.. to deploy the ``RecipientPays`` smart contract again, but the
.. new contract does not know the nonces used in the previous
.. deployment, so the attacker can use the old messages again.

別のタイプのリプレイ攻撃は、所有者が ``ReceiverPays`` スマートコントラクトをデプロイし、いくつかの支払いを行った後、コントラクトを破棄した場合に発生します。しかし、新しいコントラクトは前回のデプロイで使用された非暗号を知らないため、攻撃者は古いメッセージを再び使用できます。

.. Alice can protect against this attack by including the
.. contract's address in the message, and only messages containing
.. the contract's address itself will be accepted. You can find
.. an example of this in the first two lines of the ``claimPayment()``
.. function of the full contract at the end of this section.

アリスはメッセージにコントラクトのアドレスを含めることでこの攻撃から守ることができ、コントラクトのアドレス自体を含むメッセージだけが受け入れられます。このセクションの最後にある完全なコントラクトの ``claimPayment()`` 関数の最初の2行に、この例があります。

Packing arguments
-----------------

.. Now that we have identified what information to include in the signed message,
.. we are ready to put the message together, hash it, and sign it. For simplicity,
.. we concatenate the data. The `ethereumjs-abi <https://github.com/ethereumjs/ethereumjs-abi>`_
.. library provides a function called ``soliditySHA3`` that mimics the behaviour of
.. Solidity's ``keccak256`` function applied to arguments encoded using ``abi.encodePacked``.
.. Here is a JavaScript function that creates the proper signature for the ``ReceiverPays`` example:

さて、署名付きメッセージに含めるべき情報がわかったところで、メッセージをまとめ、ハッシュ化し、署名する準備が整いました。簡単にするために、データを連結します。 `ethereumjs-abi <https://github.com/ethereumjs/ethereumjs-abi>`_ ライブラリは、 ``abi.encodePacked`` でエンコードされた引数に適用されるSolidityの ``keccak256`` 関数の動作を模倣した ``soliditySHA3`` という関数を提供しています。以下は、 ``ReceiverPays`` の例で適切な署名を作成するJavaScriptの関数です。

.. code-block:: javascript

    // recipient is the address that should be paid.
    // amount, in wei, specifies how much ether should be sent.
    // nonce can be any unique number to prevent replay attacks
    // contractAddress is used to prevent cross-contract replay attacks
    function signPayment(recipient, amount, nonce, contractAddress, callback) {
        var hash = "0x" + abi.soliditySHA3(
            ["address", "uint256", "uint256", "address"],
            [recipient, amount, nonce, contractAddress]
        ).toString("hex");

        web3.eth.personal.sign(hash, web3.eth.defaultAccount, callback);
    }

Recovering the Message Signer in Solidity
-----------------------------------------

.. In general, ECDSA signatures consist of two parameters,
.. ``r`` and ``s``. Signatures in Ethereum include a third
.. parameter called ``v``, that you can use to verify which
.. account's private key was used to sign the message, and
.. the transaction's sender. Solidity provides a built-in
.. function :ref:`ecrecover <mathematical-and-cryptographic-functions>` that
.. accepts a message along with the ``r``, ``s`` and ``v`` parameters
.. and returns the address that was used to sign the message.

一般的に、ECDSA署名は ``r`` と ``s`` という2つのパラメータで構成されています。Ethereumの署名には、 ``v`` という3つ目のパラメータが含まれており、どのアカウントの秘密鍵がメッセージの署名に使われたか、トランザクションの送信者を確認するために使用できます。Solidityには、メッセージと ``r`` 、 ``s`` 、 ``v`` の各パラメータを受け取り、メッセージの署名に使用されたアドレスを返す組み込み関数 :ref:`ecrecover <mathematical-and-cryptographic-functions>` があります。

Extracting the Signature Parameters
-----------------------------------

.. Signatures produced by web3.js are the concatenation of ``r``,
.. ``s`` and ``v``, so the first step is to split these parameters
.. apart. You can do this on the client-side, but doing it inside
.. the smart contract means you only need to send one signature
.. parameter rather than three. Splitting apart a byte array into
.. its constituent parts is a mess, so we use
.. :doc:`inline assembly <assembly>` to do the job in the ``splitSignature``
.. function (the third function in the full contract at the end of this section).

web3.jsが生成する署名は、 ``r`` 、 ``s`` 、 ``v`` を連結したものなので、まずはこれらのパラメータを分割する必要があります。これはクライアントサイドでもできますが、スマートコントラクト内で行うことで、署名パラメータを3つではなく1つだけ送信すればよくなります。バイト配列を構成要素に分割するのは面倒なので、 ``splitSignature`` 関数（このセクションの最後にあるフルコントラクトの3番目の関数）の中で、:doc: `inline assembly <assembly>` を使ってその作業を行います。

Computing the Message Hash
--------------------------

.. The smart contract needs to know exactly what parameters were signed, and so it
.. must recreate the message from the parameters and use that for signature verification.
.. The functions ``prefixed`` and ``recoverSigner`` do this in the ``claimPayment`` function.

スマートコントラクトは、どのパラメータが署名されたかを正確に知る必要があるため、パラメータからメッセージを再作成し、それを署名検証に使用する必要があります。 ``prefixed`` 関数と ``recoverSigner`` 関数は、 ``claimPayment`` 関数でこれを行います。

The full contract
-----------------

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    contract ReceiverPays {
        address owner = msg.sender;

        mapping(uint256 => bool) usedNonces;

        constructor() payable {}

        function claimPayment(uint256 amount, uint256 nonce, bytes memory signature) external {
            require(!usedNonces[nonce]);
            usedNonces[nonce] = true;

            // this recreates the message that was signed on the client
            bytes32 message = prefixed(keccak256(abi.encodePacked(msg.sender, amount, nonce, this)));

            require(recoverSigner(message, signature) == owner);

            payable(msg.sender).transfer(amount);
        }

        /// destroy the contract and reclaim the leftover funds.
        function shutdown() external {
            require(msg.sender == owner);
            selfdestruct(payable(msg.sender));
        }

        /// signature methods.
        function splitSignature(bytes memory sig)
            internal
            pure
            returns (uint8 v, bytes32 r, bytes32 s)
        {
            require(sig.length == 65);

            assembly {
                // first 32 bytes, after the length prefix.
                r := mload(add(sig, 32))
                // second 32 bytes.
                s := mload(add(sig, 64))
                // final byte (first byte of the next 32 bytes).
                v := byte(0, mload(add(sig, 96)))
            }

            return (v, r, s);
        }

        function recoverSigner(bytes32 message, bytes memory sig)
            internal
            pure
            returns (address)
        {
            (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

            return ecrecover(message, v, r, s);
        }

        /// builds a prefixed hash to mimic the behavior of eth_sign.
        function prefixed(bytes32 hash) internal pure returns (bytes32) {
            return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
        }
    }

Writing a Simple Payment Channel
================================

.. Alice now builds a simple but complete implementation of a payment
.. channel. Payment channels use cryptographic signatures to make
.. repeated transfers of Ether securely, instantaneously, and without transaction fees.

アリスは今、シンプルだが完全なペイメントチャネルの実装を構築しています。ペイメントチャネルは、暗号化された署名を使用して、安全に、瞬時に、トランザクション手数料なしで、Etherの反復送金を行います。

What is a Payment Channel?
--------------------------

.. Payment channels allow participants to make repeated transfers of Ether
.. without using transactions. This means that you can avoid the delays and
.. fees associated with transactions. We are going to explore a simple
.. unidirectional payment channel between two parties (Alice and Bob). It involves three steps:

..     1. Alice funds a smart contract with Ether. This "opens" the payment channel.

..     2. Alice signs messages that specify how much of that Ether is owed to the recipient. This step is repeated for each payment.

..     3. Bob "closes" the payment channel, withdrawing his portion of the Ether and sending the remainder back to the sender.

ペイメントチャンネルでは、参加者はトランザクションを使わずにEtherの送金を繰り返し行うことができます。つまり、トランザクションに伴う遅延や手数料を回避できます。ここでは、2人の当事者（AliceとBob）の間の単純な一方向性の支払いチャネルを調べてみます。それには3つのステップがあります。

    1. アリスはスマートコントラクトにEtherで資金を供給します。これにより、支払いチャネルを「オープン」します。

    2. アリスは、そのイーサのうちどれだけの量を受信者に負担させるかを指定するメッセージに署名します。このステップは支払いごとに繰り返されます。

    3. Bob は支払いチャネルを「クローズ」し、自分の分の Ether を引き出し、残りの Ether を送信者に送り返します。

.. .. note::

..   Only steps 1 and 3 require Ethereum transactions, step 2 means that the sender
..   transmits a cryptographically signed message to the recipient via off chain
..   methods (e.g. email). This means only two transactions are required to support
..   any number of transfers.

.. note::

  ステップ1とステップ3のみがEthereumのトランザクションを必要とし、ステップ2は送信者が暗号化されたメッセージをオフチェーン方式（例: 電子メール）で受信者に送信することを意味します。つまり、2つのトランザクションだけで、任意の数の送金をサポートできます。

.. Bob is guaranteed to receive his funds because the smart contract escrows the
.. Ether and honours a valid signed message. The smart contract also enforces a
.. timeout, so Alice is guaranteed to eventually recover her funds even if the
.. recipient refuses to close the channel. It is up to the participants in a payment
.. channel to decide how long to keep it open. For a short-lived transaction,
.. such as paying an internet café for each minute of network access, the payment
.. channel may be kept open for a limited duration. On the other hand, for a
.. recurring payment, such as paying an employee an hourly wage, the payment channel
.. may be kept open for several months or years.

スマートコントラクトはEtherをエスクローし、有効な署名付きメッセージを尊重するので、Bobは資金を受け取ることが保証されています。また、スマートコントラクトはタイムアウトを強制しているため、受信者がチャネルを閉じることを拒否した場合でも、アリスは最終的に資金を回収できることが保証されています。支払いチャネルの参加者は、そのチャネルをどのくらいの期間開いておくかを決めることができます。例えば、インターネットカフェにネットワーク接続料を支払うような短時間のトランザクションの場合、決済チャネルは限られた時間しか開いていないかもしれません。一方、従業員に時給を支払うような定期的な支払いの場合は、数ヶ月または数年にわたって決済チャネルを開いておくことができます。

Opening the Payment Channel
---------------------------

.. To open the payment channel, Alice deploys the smart contract, attaching
.. the Ether to be escrowed and specifying the intended recipient and a
.. maximum duration for the channel to exist. This is the function
.. ``SimplePaymentChannel`` in the contract, at the end of this section.

支払いチャネルを開くために、アリスはスマートコントラクトをデプロイし、エスクローされるイーサを添付し、意図する受取人とチャネルが存在する最大期間を指定します。これが、このセクションの最後にあるコントラクトの関数 ``SimplePaymentChannel`` です。

Making Payments
---------------

.. Alice makes payments by sending signed messages to Bob.
.. This step is performed entirely outside of the Ethereum network.
.. Messages are cryptographically signed by the sender and then transmitted directly to the recipient.

アリスは、署名されたメッセージをボブに送ることで支払いを行います。このステップは、Ethereumネットワークの外で完全に実行されます。メッセージは送信者によって暗号化されて署名され、受信者に直接送信されます。

.. Each message includes the following information:

..     * The smart contract's address, used to prevent cross-contract replay attacks.

..     * The total amount of Ether that is owed the recipient so far.

各メッセージには以下の情報が含まれています。

    * スマートコントラクトのアドレスは、クロスコントラクトのリプレイ攻撃を防ぐために使用されます。

    * これまでに受信者が負担したEtherの合計額。

.. A payment channel is closed just once, at the end of a series of transfers.
.. Because of this, only one of the messages sent is redeemed. This is why
.. each message specifies a cumulative total amount of Ether owed, rather than the
.. amount of the individual micropayment. The recipient will naturally choose to
.. redeem the most recent message because that is the one with the highest total.
.. The nonce per-message is not needed anymore, because the smart contract only
.. honours a single message. The address of the smart contract is still used
.. to prevent a message intended for one payment channel from being used for a different channel.

ペイメントチャネルは、一連の送金が終わった時点で一度だけ閉じられます。このため、送信されたメッセージのうち1つだけが償還されます。これが、各メッセージが、個々のマイクロペイメントの金額ではなく、支払うべきEtherの累積合計金額を指定する理由です。受信者は当然、最新のメッセージを償還することを選択しますが、それは最も高い合計額を持つメッセージだからです。スマートコントラクトは1つのメッセージのみを尊重するため、メッセージごとのnonceはもう必要ありません。スマートコントラクトのアドレスは、ある決済チャネル用のメッセージが別のチャネルで使用されるのを防ぐために使用されます。

.. Here is the modified JavaScript code to cryptographically sign a message from the previous section:

前述のメッセージを暗号化して署名するためのJavaScriptコードを修正したものです。

.. code-block:: javascript

    function constructPaymentMessage(contractAddress, amount) {
        return abi.soliditySHA3(
            ["address", "uint256"],
            [contractAddress, amount]
        );
    }

    function signMessage(message, callback) {
        web3.eth.personal.sign(
            "0x" + message.toString("hex"),
            web3.eth.defaultAccount,
            callback
        );
    }

    // contractAddress is used to prevent cross-contract replay attacks.
    // amount, in wei, specifies how much Ether should be sent.

    function signPayment(contractAddress, amount, callback) {
        var message = constructPaymentMessage(contractAddress, amount);
        signMessage(message, callback);
    }

Closing the Payment Channel
---------------------------

.. When Bob is ready to receive his funds, it is time to
.. close the payment channel by calling a ``close`` function on the smart contract.
.. Closing the channel pays the recipient the Ether they are owed and
.. destroys the contract, sending any remaining Ether back to Alice. To
.. close the channel, Bob needs to provide a message signed by Alice.

ボブが資金を受け取る準備ができたら、スマートコントラクトの ``close`` 関数を呼び出して支払いチャネルを閉じる時です。チャネルを閉じると、受取人に支払うべきEtherが支払われ、コントラクトが破棄され、残っているEtherがAliceに送り返されます。チャネルを閉じるために、BobはAliceが署名したメッセージを提供する必要があります。

.. The smart contract must verify that the message contains a valid signature from the sender.
.. The process for doing this verification is the same as the process the recipient uses.
.. The Solidity functions ``isValidSignature`` and ``recoverSigner`` work just like their
.. JavaScript counterparts in the previous section, with the latter function borrowed from the ``ReceiverPays`` contract.

スマートコントラクトは、メッセージに送信者の有効な署名が含まれていることを検証する必要があります。この検証を行うためのプロセスは、受信者が使用するプロセスと同じです。Solidityの関数 ``isValidSignature`` と ``recoverSigner`` は、前のセクションのJavaScriptの対応する関数と同じように動作しますが、後者の関数は ``ReceiverPays`` コントラクトから借用しています。

.. Only the payment channel recipient can call the ``close`` function,
.. who naturally passes the most recent payment message because that message
.. carries the highest total owed. If the sender were allowed to call this function,
.. they could provide a message with a lower amount and cheat the recipient out of what they are owed.

``close`` 関数を呼び出すことができるのは、ペイメントチャネルの受信者のみです。受信者は当然、最新のペイメントメッセージを渡します。なぜなら、そのメッセージには最も高い債務総額が含まれているからです。もし送信者がこの関数を呼び出すことができれば、より低い金額のメッセージを提供し、受信者を騙して債務を支払うことができます。

.. The function verifies the signed message matches the given parameters.
.. If everything checks out, the recipient is sent their portion of the Ether,
.. and the sender is sent the rest via a ``selfdestruct``.
.. You can see the ``close`` function in the full contract.

この関数は、署名されたメッセージが与えられたパラメータと一致するかどうかを検証します。すべてがチェックアウトされれば、受信者には自分の分のEtherが送られ、送信者には ``selfdestruct`` 経由で残りの分が送られます。 ``close`` 関数はコントラクト全体で見ることができます。

Channel Expiration
-------------------

.. Bob can close the payment channel at any time, but if they fail to do so,
.. Alice needs a way to recover her escrowed funds. An *expiration* time was set
.. at the time of contract deployment. Once that time is reached, Alice can call
.. ``claimTimeout`` to recover her funds. You can see the ``claimTimeout`` function in the full contract.

ボブはいつでも支払いチャネルを閉じることができますが、それができなかった場合、アリスはエスクローされた資金を回収する方法が必要です。コントラクトのデプロイ時に *有効期限* が設定されました。その時間に達すると、アリスは ``claimTimeout`` を呼び出して資金を回収できます。 ``claimTimeout`` 関数は コントラクト全文で見ることができます。

.. After this function is called, Bob can no longer receive any Ether,
.. so it is important that Bob closes the channel before the expiration is reached.

この関数が呼び出されると、BobはEtherを受信できなくなるため、期限切れになる前にBobがチャネルを閉じることが重要です。

The full contract
-----------------

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    contract SimplePaymentChannel {
        address payable public sender;      // The account sending payments.
        address payable public recipient;   // The account receiving the payments.
        uint256 public expiration;  // Timeout in case the recipient never closes.

        constructor (address payable recipientAddress, uint256 duration)
            payable
        {
            sender = payable(msg.sender);
            recipient = recipientAddress;
            expiration = block.timestamp + duration;
        }

        /// the recipient can close the channel at any time by presenting a
        /// signed amount from the sender. the recipient will be sent that amount,
        /// and the remainder will go back to the sender
        function close(uint256 amount, bytes memory signature) external {
            require(msg.sender == recipient);
            require(isValidSignature(amount, signature));

            recipient.transfer(amount);
            selfdestruct(sender);
        }

        /// the sender can extend the expiration at any time
        function extend(uint256 newExpiration) external {
            require(msg.sender == sender);
            require(newExpiration > expiration);

            expiration = newExpiration;
        }

        /// if the timeout is reached without the recipient closing the channel,
        /// then the Ether is released back to the sender.
        function claimTimeout() external {
            require(block.timestamp >= expiration);
            selfdestruct(sender);
        }

        function isValidSignature(uint256 amount, bytes memory signature)
            internal
            view
            returns (bool)
        {
            bytes32 message = prefixed(keccak256(abi.encodePacked(this, amount)));

            // check that the signature is from the payment sender
            return recoverSigner(message, signature) == sender;
        }

        /// All functions below this are just taken from the chapter
        /// 'creating and verifying signatures' chapter.

        function splitSignature(bytes memory sig)
            internal
            pure
            returns (uint8 v, bytes32 r, bytes32 s)
        {
            require(sig.length == 65);

            assembly {
                // first 32 bytes, after the length prefix
                r := mload(add(sig, 32))
                // second 32 bytes
                s := mload(add(sig, 64))
                // final byte (first byte of the next 32 bytes)
                v := byte(0, mload(add(sig, 96)))
            }

            return (v, r, s);
        }

        function recoverSigner(bytes32 message, bytes memory sig)
            internal
            pure
            returns (address)
        {
            (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

            return ecrecover(message, v, r, s);
        }

        /// builds a prefixed hash to mimic the behavior of eth_sign.
        function prefixed(bytes32 hash) internal pure returns (bytes32) {
            return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
        }
    }

.. .. note::

..   The function ``splitSignature`` does not use all security
..   checks. A real implementation should use a more rigorously tested library,
..   such as openzepplin's `version  <https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol>`_ of this code.

.. note::

  関数 ``splitSignature`` は、すべてのセキュリティチェックを使用していません。実際の実装では、openzepplinの `version  <https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol>`_ のように、より厳密にテストされたライブラリを使用する必要があります。

Verifying Payments
------------------

.. Unlike in the previous section, messages in a payment channel aren't
.. redeemed right away. The recipient keeps track of the latest message and
.. redeems it when it's time to close the payment channel. This means it's
.. critical that the recipient perform their own verification of each message.
.. Otherwise there is no guarantee that the recipient will be able to get paid
.. in the end.

前述のセクションとは異なり、ペイメントチャネル内のメッセージはすぐには償還されません。受信者は最新のメッセージを記録しておき、決済チャネルを閉じるときにそのメッセージを引き換えることになります。つまり、受信者がそれぞれのメッセージに対して独自の検証を行うことが重要です。そうしないと、受信者が最終的に支払いを受けることができるという保証はありません。

.. The recipient should verify each message using the following process:

..     1. Verify that the contract address in the message matches the payment channel.

..     2. Verify that the new total is the expected amount.

..     3. Verify that the new total does not exceed the amount of Ether escrowed.

..     4. Verify that the signature is valid and comes from the payment channel sender.

受信者は、以下のプロセスで各メッセージを確認する必要があります。

    1. メッセージ内のコントラクトアドレスが決済チャネルと一致していることを確認します。

    2. 新しい合計金額が期待通りの金額であることを確認します。

    3. 新しい合計がエスクローされたEtherの量を超えていないことを確認します。

    4. 署名が有効であり、ペイメントチャネルの送信者からのものであることを確認します。

.. We'll use the `ethereumjs-util <https://github.com/ethereumjs/ethereumjs-util>`_
.. library to write this verification. The final step can be done a number of ways,
.. and we use JavaScript. The following code borrows the ``constructPaymentMessage`` function from the signing **JavaScript code** above:

この検証には `ethereumjs-util <https://github.com/ethereumjs/ethereumjs-util>`_ ライブラリを使って書きます。最後のステップはいくつかの方法で行うことができますが、ここではJavaScriptを使用します。次のコードは、上の署名用 **JavaScript code** から ``constructPaymentMessage`` 関数を借りています。

.. code-block:: javascript

    // this mimics the prefixing behavior of the eth_sign JSON-RPC method.
    function prefixed(hash) {
        return ethereumjs.ABI.soliditySHA3(
            ["string", "bytes32"],
            ["\x19Ethereum Signed Message:\n32", hash]
        );
    }

    function recoverSigner(message, signature) {
        var split = ethereumjs.Util.fromRpcSig(signature);
        var publicKey = ethereumjs.Util.ecrecover(message, split.v, split.r, split.s);
        var signer = ethereumjs.Util.pubToAddress(publicKey).toString("hex");
        return signer;
    }

    function isValidSignature(contractAddress, amount, signature, expectedSigner) {
        var message = prefixed(constructPaymentMessage(contractAddress, amount));
        var signer = recoverSigner(message, signature);
        return signer.toLowerCase() ==
            ethereumjs.Util.stripHexPrefix(expectedSigner).toLowerCase();
    }

