**************************
マイクロペイメントチャネル
**************************

このセクションでは、ペイメントチャネルの実装例を構築する方法を学びます。
これは、暗号化された署名を使用して、同一の当事者間で繰り返されるEtherの送金を、安全かつ瞬時に、トランザクション手数料なしで行うものです。
この例では、署名と検証の方法を理解し、ペイメントチャネルを設定する必要があります。

署名の作成と検証
================

アリスがボブにEtherを送りたい、つまりアリスが送信者でボブが受信者であるとします。

アリスは暗号化されたメッセージをオフチェーンで（例えばメールで）ボブに送るだけでよく、小切手を書くのと同じようなものです。

アリスとボブは署名を使ってトランザクションを承認しますが、これはEthereumのスマートコントラクトで可能です。
アリスはEtherを送信できるシンプルなスマートコントラクトを構築しますが、支払いを開始するために自分で関数を呼び出すのではなく、ボブにそれをさせ、その結果、トランザクション手数料を支払うことになります。

コントラクト内容は以下のようになっています。

    1. アリスは ``ReceiverPays`` コントラクトをデプロイし、行われるであろう支払いをカバーするのに十分なEtherを取り付けます。
    2. アリスは、自分の秘密鍵でメッセージを署名することで、支払いを承認します。
    3. アリスは、暗号署名されたメッセージをボブに送信します。
       メッセージは秘密にしておく必要はなく（後で説明します）、送信の仕組みも問題ありません。
    4. Bobはスマートコントラクトに署名済みのメッセージを提示して支払いを請求し、スマートコントラクトはメッセージの真正性を検証した後、資金を放出します。

署名の作成
----------

アリスはトランザクションに署名するためにEthereumネットワークと対話する必要はなく、プロセスは完全にオフラインです。
このチュートリアルでは、他にも多くのセキュリティ上の利点があるため、 `EIP-712 <https://github.com/ethereum/EIPs/pull/712>`_ で説明した方法を用いて、 `web3.js <https://github.com/web3/web3.js>`_ と `MetaMask <https://metamask.io>`_ を使ってブラウザ上でメッセージを署名します。

.. Fix typo: EIP-712

.. code-block:: javascript

    /// ハッシュ化を先に行うことで、より簡単になります。
    var hash = web3.utils.sha3("message to sign");
    web3.eth.personal.sign(hash, web3.eth.defaultAccount, function () { console.log("Signed"); });

.. note::

    ``web3.eth.personal.sign`` はメッセージの長さを署名済みデータの前に付けます。
    最初にハッシュ化するので、メッセージは常に正確な32バイトの長さになり、したがってこの長さのプレフィックスは常に同じになります。

署名するもの
------------

支払いを履行するコントラクトの場合、署名されたメッセージには以下が含まれていなければなりません。

    1. 受信者のアドレス
    2. 送金される金額
    3. リプレイアタックへの対策

リプレイアタックとは、署名されたメッセージが再利用されて、2回目のアクションの認証を主張することです。
リプレイアタックを避けるために、私たちはEthereumのトランザクション自体と同じ技術、いわゆるnonceを使用していますが、これはアカウントから送信されたトランザクションの数です。
スマートコントラクトは、nonceが複数回使用されているかどうかをチェックします。

別のタイプのリプレイアタックは、所有者が ``ReceiverPays`` スマートコントラクトをデプロイし、いくつかの支払いを行った後、コントラクトを破棄した場合に発生します。
しかし、新しいコントラクトは前回のデプロイで使用されたnonceを知らないため、攻撃者は古いメッセージを再び使用できます。

アリスはメッセージにコントラクトのアドレスを含めることでこの攻撃から守ることができ、コントラクトのアドレス自体を含むメッセージだけが受け入れられます。
このセクションの最後にある完全なコントラクトの ``claimPayment()`` 関数の最初の2行に、この例があります。

引数のパッキング
----------------

さて、署名付きメッセージに含めるべき情報がわかったところで、メッセージをまとめ、ハッシュ化し、署名する準備が整いました。
簡単にするために、データを連結します。
`ethereumjs-abi <https://github.com/ethereumjs/ethereumjs-abi>`_ ライブラリは、 ``abi.encodePacked`` でエンコードされた引数に適用されるSolidityの ``keccak256`` 関数の動作を模倣した ``soliditySHA3`` という関数を提供しています。
以下は、 ``ReceiverPays`` の例で適切な署名を作成するJavaScriptの関数です。

.. code-block:: javascript

    // recipient は、支払いを受けるべきアドレスです。
    // amount (wei) は、どれだけのEtherを送るべきかを指定します。
    // nonce は、リプレイアタックを防ぐために任意の一意な番号を指定します。
    // contractAddress は、クロスコントラクトのリプレイアタックを防ぐために使用します。
    function signPayment(recipient, amount, nonce, contractAddress, callback) {
        var hash = "0x" + abi.soliditySHA3(
            ["address", "uint256", "uint256", "address"],
            [recipient, amount, nonce, contractAddress]
        ).toString("hex");

        web3.eth.personal.sign(hash, web3.eth.defaultAccount, callback);
    }

Solidityでメッセージの署名者の復元
----------------------------------

一般的に、ECDSA署名は ``r`` と ``s`` という2つのパラメータで構成されています。
Ethereumの署名には、 ``v`` という3つ目のパラメータが含まれており、どのアカウントの秘密鍵がメッセージの署名に使われたか、トランザクションの送信者を確認するために使用できます。
Solidityには、メッセージと ``r`` 、 ``s`` 、 ``v`` の各パラメータを受け取り、メッセージの署名に使用されたアドレスを返す組み込み関数 :ref:`ecrecover <mathematical-and-cryptographic-functions>` があります。

署名パラメータの抽出
--------------------

web3.jsが生成する署名は、 ``r`` 、 ``s`` 、 ``v`` を連結したものなので、まずはこれらのパラメータを分割する必要があります。
これはクライアントサイドでもできますが、スマートコントラクト内で行うことで、署名パラメータを3つではなく1つだけ送信すればよくなります。
バイト配列を構成要素に分割するのは面倒なので、 ``splitSignature`` 関数（このセクションの最後にあるフルコントラクトの3番目の関数）の中で、:doc:`インラインアセンブリ <assembly>` を使ってその作業を行います。

メッセージハッシュの計算
------------------------

スマートコントラクトは、どのパラメータが署名されたかを正確に知る必要があるため、パラメータからメッセージを再作成し、それを署名検証に使用する必要があります。
``prefixed`` 関数と ``recoverSigner`` 関数は、 ``claimPayment`` 関数でこれを行います。

コントラクト全体
----------------

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    // 非推奨のselfdestructを使用するためwarningが出力されます。
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

シンプルなペイメントチャンネルの書き方
======================================

アリスは今、シンプルだが完全なペイメントチャネルの実装を構築しています。
ペイメントチャネルは、暗号化された署名を使用して、安全に、瞬時に、トランザクション手数料なしで、Etherの反復送金を行えます。

ペイメントチャネルとは
----------------------

ペイメントチャンネルでは、参加者はトランザクションを使わずにEtherの送金を繰り返し行うことができます。
つまり、トランザクションに伴う遅延や手数料を回避できます。
ここでは、2人の当事者（AliceとBob）の間の単純な一方向性の支払いチャネルを調べてみます。
それには3つのステップがあります。

    1. アリスはスマートコントラクトにEtherで資金を供給します。
       これにより、ペイメントチャネルを「オープン」します。
    2. アリスは、そのEtherのうちどれだけの量を受信者に支払うかを指定するメッセージに署名します。
       このステップは支払いごとに繰り返されます。
    3. Bob はペイメントチャネルを「クローズ」し、自分の分のEtherを引き出し、残りのEtherを送信者に送り返します。

.. note::

    ステップ1とステップ3のみがEthereumのトランザクションを必要とし、ステップ2は送信者が暗号化されたメッセージをオフチェーン方式（例: 電子メール）で受信者に送信することを意味します。
    つまり、2つのトランザクションだけで、任意の数の送金をサポートできます。

スマートコントラクトはEtherをエスクローし、有効な署名付きメッセージを尊重するので、ボブは資金を受け取ることが保証されています。
また、スマートコントラクトはタイムアウトを強制しているため、受信者がチャネルを閉じることを拒否した場合でも、アリスは最終的に資金を回収できることが保証されています。
ペイメントチャネルの参加者は、そのチャネルをどのくらいの期間開いておくかを決めることができます。
例えば、インターネットカフェにネットワーク接続料を支払うような短時間のトランザクションの場合、ペイメントチャネルは限られた時間しか開いていないかもしれません。
一方、従業員に時給を支払うような定期的な支払いの場合は、数ヶ月または数年にわたってペイメントチャネルを開いておくことができます。

ペイメントチャネルのオープン
----------------------------

ペイメントチャネルを開くために、アリスはスマートコントラクトをデプロイし、エスクローされるイーサを添付し、意図する受取人とチャネルが存在する最大期間を指定します。
これが、このセクションの最後にあるコントラクトの関数 ``SimplePaymentChannel`` です。

ペイメントの作成
----------------

アリスは、署名されたメッセージをボブに送ることで支払いを行います。
このステップは、Ethereumネットワークの外で完全に実行されます。
メッセージは送信者によって暗号化されて署名され、受信者に直接送信されます。

各メッセージには以下の情報が含まれています。

    * スマートコントラクトのアドレス。
      クロスコントラクトのリプレイアタックを防ぐために使用されます。
    * これまでに受取人に支払われたEtherの合計額。

ペイメントチャネルは、一連の送金が終わった時点で一度だけ閉じられます。
このため、送信されたメッセージのうち1つだけが償還されます。
これが、各メッセージが、個々のマイクロペイメントの金額ではなく、支払うべきEtherの累積合計金額を指定する理由です。
受信者は当然、最新のメッセージを償還することを選択しますが、それは最も高い合計額を持つメッセージだからです。
スマートコントラクトは1つのメッセージのみを尊重するため、メッセージごとのnonceはもう必要ありません。
スマートコントラクトのアドレスは、あるペイメントチャネル用のメッセージが別のチャネルで使用されるのを防ぐために使用されます。

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

    // contractAddressは、クロスコントラクトリプレイ攻撃を防ぐために使用されます。
    // amount (wei)は、送信されるべきEtherの量を指定します。

    function signPayment(contractAddress, amount, callback) {
        var message = constructPaymentMessage(contractAddress, amount);
        signMessage(message, callback);
    }

ペイメントチャネルのクローズ
----------------------------

ボブが資金を受け取る準備ができたら、スマートコントラクトの ``close`` 関数をコールしてペイメントチャネルを閉じる時です。
チャネルを閉じると、受取人に支払うべきEtherが支払われ、コントラクトが破棄され、残っているEtherがAliceに送り返されます。
チャネルを閉じるために、BobはAliceが署名したメッセージを提供する必要があります。

スマートコントラクトは、メッセージに送信者の有効な署名が含まれていることを検証する必要があります。
この検証を行うためのプロセスは、受信者が使用するプロセスと同じです。
Solidityの関数 ``isValidSignature`` と ``recoverSigner`` は、前のセクションのJavaScriptの対応する関数と同じように動作しますが、後者の関数は ``ReceiverPays`` コントラクトから借用しています。

``close`` 関数を呼び出すことができるのは、ペイメントチャネルの受信者のみです。
受信者は当然、最新のペイメントメッセージを渡します。
なぜなら、そのメッセージには最も高い債務総額が含まれているからです。
もし送信者がこの関数を呼び出すことができれば、より低い金額のメッセージを提供し、受信者を騙して債務を支払うことができます。

この関数は、署名されたメッセージが与えられたパラメータと一致するかどうかを検証します。
すべてがチェックアウトされれば、受信者には自分の分のEtherが送られ、送信者には ``selfdestruct`` 経由で残りの分が送られます。
``close`` 関数はコントラクト全体で見ることができます。

チャネルの有効期限
------------------

ボブはいつでも支払いチャネルを閉じることができますが、それができなかった場合、アリスはエスクローされた資金を回収する方法が必要です。
コントラクトのデプロイ時に *有効期限* が設定されました。
その時間に達すると、アリスは ``claimTimeout`` をコールして資金を回収できます。
``claimTimeout`` 関数は コントラクト全文で見ることができます。

この関数が呼び出されると、BobはEtherを受信できなくなるため、期限切れになる前にBobがチャネルを閉じることが重要です。

コントラクト全体
----------------

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    // 非推奨のselfdestructを使用するためwarningが出力されます。
    contract SimplePaymentChannel {
        address payable public sender;      // 支払いを送信するアカウント
        address payable public recipient;   // 支払いを受けるアカウント
        uint256 public expiration;  // 受信者が閉じない場合のタイムアウト

        constructor (address payable recipientAddress, uint256 duration)
            payable
        {
            sender = payable(msg.sender);
            recipient = recipientAddress;
            expiration = block.timestamp + duration;
        }

        /// 受信者は送信者から署名された金額を提示することで、いつでもチャンネルを閉じることができます。
        /// 受信者はその金額を送信し、残りは送信者に戻ります。
        function close(uint256 amount, bytes memory signature) external {
            require(msg.sender == recipient);
            require(isValidSignature(amount, signature));

            recipient.transfer(amount);
            selfdestruct(sender);
        }

        /// 送信者はいつでも有効期限を延長できます。
        function extend(uint256 newExpiration) external {
            require(msg.sender == sender);
            require(newExpiration > expiration);

            expiration = newExpiration;
        }

        /// 受信者がチャネルを閉じることなくタイムアウトに達した場合、Etherは送信者に戻されます。
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

            // 署名が支払い送信者のものであることを確認します。
            return recoverSigner(message, signature) == sender;
        }

        /// これ以下の関数はすべて「署名の作成と検証」の章から引用しているだけです。

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

        /// eth_sign の動作を模倣して、接頭辞付きハッシュを構築します。
        function prefixed(bytes32 hash) internal pure returns (bytes32) {
            return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
        }
    }

.. note::

    関数 ``splitSignature`` は、すべてのセキュリティチェックを使用していません。
    実際の実装では、openzepplinの `バージョン  <https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol>`_ のように、より厳密にテストされたライブラリを使用する必要があります。

ペイメントの検証
----------------

前述のセクションとは異なり、ペイメントチャネル内のメッセージはすぐには償還されません。
受信者は最新のメッセージを記録しておき、決済チャネルを閉じるときにそのメッセージを引き換えることになります。
つまり、受信者がそれぞれのメッセージに対して独自の検証を行うことが重要です。
そうしないと、受信者が最終的に支払いを受けることができるという保証はありません。

受信者は、以下のプロセスで各メッセージを確認する必要があります。

    1. メッセージ内のコントラクトアドレスがペイメントチャネルと一致していることを確認します。
    2. 新しい合計金額が期待通りの金額であることを確認します。
    3. 新しい合計がエスクローされたEtherの量を超えていないことを確認します。
    4. 署名が有効であり、ペイメントチャネルの送信者からのものであることを確認します。

この検証には `ethereumjs-util <https://github.com/ethereumjs/ethereumjs-util>`_ ライブラリを使って書きます。
最後のステップはいくつかの方法で行うことができますが、ここではJavaScriptを使用します。
次のコードは、上の署名用 **JavaScriptコード** から ``constructPaymentMessage`` 関数を借りています。

.. code-block:: javascript

    // これは eth_sign JSON-RPC メソッドのプリフィックス動作を模倣しています。
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

