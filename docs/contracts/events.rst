.. index:: ! event, ! event; anonymous, ! event; indexed, ! event; topic

.. _events:

********
イベント
********

.. Solidity events give an abstraction on top of the EVM's logging functionality.
.. Applications can subscribe and listen to these events through the RPC interface of an Ethereum client.

Solidityのイベントは、EVMのロギング機能の上に抽象化を与えます。
アプリケーションは、EthereumクライアントのRPCインターフェースを介して、これらのイベントをサブスクライブし、リッスンできます。

.. Events are inheritable members of contracts. When you call them, they cause the
.. arguments to be stored in the transaction's log - a special data structure
.. in the blockchain. These logs are associated with the address of the contract,
.. are incorporated into the blockchain, and stay there as long as a block is
.. accessible (forever as of now, but this might
.. change with Serenity). The Log and its event data is not accessible from within
.. contracts (not even from the contract that created them).

イベントはコントラクトの継承可能なメンバーです。
イベントを呼び出すと、引数がトランザクションのログ（ブロックチェーンの特別なデータ構造）に保存されます。
これらのログはコントラクトのアドレスに関連付けられ、ブロックチェーンに組み込まれ、ブロックがアクセス可能である限りそこに留まります（現時点では永遠ですが、Serenityでは変わるかもしれません）。
ログとそのイベントデータはコントラクト内からはアクセスできません（ログを作成したコントラクトからもアクセスできません）。

.. It is possible to request a Merkle proof for logs, so if
.. an external entity supplies a contract with such a proof, it can check
.. that the log actually exists inside the blockchain. You have to supply block headers
.. because the contract can only see the last 256 block hashes.

ログのMerkle証明を要求することが可能なので、外部のエンティティがコントラクトにそのような証明を供給すれば、ログがブロックチェーン内に実際に存在することをチェックできます。
コントラクトは直近の256個のブロックハッシュしか見ることができないため、ブロックヘッダを提供する必要があります。

.. You can add the attribute ``indexed`` to up to three parameters which adds them
.. to a special data structure known as :ref:`"topics" <abi_events>` instead of
.. the data part of the log.
.. A topic can only hold a single word (32 bytes) so if you use a :ref:`reference type
.. <reference-types>` for an indexed argument, the Keccak-256 hash of the value is stored
.. as a topic instead.

最大3つのパラメータに ``indexed`` 属性を追加すると、ログのデータ部分ではなく、 :ref:`"topics" <abi_events>` と呼ばれる特別なデータ構造に追加されます。
トピックは1つのワード（32バイト）しか保持できないため、インデックス付きの引数に :ref:`参照型 <reference-types>` を使用した場合、値のKeccak-256ハッシュが代わりにトピックとして保存されます。

``indexed`` 属性を持たないパラメータはすべて、ログのデータ部分に :ref:`ABIエンコード <ABI>` されます。

.. Topics allow you to search for events, for example when filtering a sequence of
.. blocks for certain events. You can also filter events by the address of the
.. contract that emitted the event.

トピックを使用すると、イベントを検索できます。
たとえば、一連のブロックを特定のイベントでフィルタリングする場合などです。
また、イベントを発したコントラクトのアドレスでイベントをフィルタリングすることもできます。

.. For example, the code below uses the web3.js ``subscribe("logs")``
.. `method <https://web3js.readthedocs.io/en/1.0/web3-eth-subscribe.html#subscribe-logs>`_ to filter
.. logs that match a topic with a certain address value:

例えば、以下のコードでは、web3.jsの ``subscribe("logs")``   `メソッド <https://web3js.readthedocs.io/en/1.0/web3-eth-subscribe.html#subscribe-logs>`_ を使用して、特定のアドレス値を持つトピックにマッチするログをフィルタリングしています。

.. code-block:: javascript

    var options = {
        fromBlock: 0,
        address: web3.eth.defaultAccount,
        topics: ["0x0000000000000000000000000000000000000000000000000000000000000000", null, null]
    };
    web3.eth.subscribe('logs', options, function (error, result) {
        if (!error)
            console.log(result);
    })
        .on("data", function (log) {
            console.log(log);
        })
        .on("changed", function (log) {
    });

.. The hash of the signature of the event is one of the topics, except if you
.. declared the event with the ``anonymous`` specifier. This means that it is
.. not possible to filter for specific anonymous events by name, you can
.. only filter by the contract address. The advantage of anonymous events
.. is that they are cheaper to deploy and call. It also allows you to declare
.. four indexed arguments rather than three.

``anonymous`` 指定子でイベントを宣言した場合を除き、イベントの署名のハッシュはトピックの一つです。
つまり、特定の匿名イベントを名前でフィルタリングできず、コントラクトアドレスでしかフィルタリングできません。
匿名イベントの利点は、デプロイや呼び出しが安く済むことです。
また、インデックス付きの引数を3つではなく4つ宣言できます。

.. .. note::

..     Since the transaction log only stores the event data and not the type,
..     you have to know the type of the event, including which parameter is
..     indexed and if the event is anonymous in order to correctly interpret
..     the data.
..     In particular, it is possible to "fake" the signature of another event
..     using an anonymous event.

.. note::

    トランザクションログにはイベントデータのみが保存され、型は保存されませんので、データを正しく解釈するためには、どのパラメータがインデックスされているか、イベントが匿名であるかなど、イベントの型を知る必要があります。
    特に、匿名イベントを使って別のイベントの署名を「偽装」することが可能です。

.. index:: ! selector; of an event

.. Members of Events

イベントのメンバー
==================

.. - ``event.selector``: For non-anonymous events, this is a ``bytes32`` value containing the ``keccak256`` hash of the event signature, as used in the default topic.

- ``event.selector``: 匿名でないイベントの場合、デフォルトのトピックで使用されるイベントシグネチャの ``keccak256`` ハッシュを含む ``bytes32`` 値

例
==

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.21 <0.9.0;

    contract ClientReceipt {
        event Deposit(
            address indexed from,
            bytes32 indexed id,
            uint value
        );

        function deposit(bytes32 id) public payable {
            // イベントは `emit` を使って発行され、その後にイベント名と引数 (もしあれば) が括弧で囲まれます。
            // このような呼び出しは (深くネストされていても) JavaScript API から `Deposit` をフィルタリングすることで検出できます。
            emit Deposit(msg.sender, id, msg.value);
        }
    }

JavaScript APIでの使用方法は以下の通りです。

.. code-block:: javascript

    var abi = /* コンパイラが生成するABI */;
    var ClientReceipt = web3.eth.contract(abi);
    var clientReceipt = ClientReceipt.at("0x1234...ab67" /* アドレス */);

    var depositEvent = clientReceipt.Deposit();

    // 変更を監視
    depositEvent.watch(function(error, result){
        // resultには、`Deposit` の呼び出しに与えられたインデックス付けされていない引数とトピックが含まれます。
        if (!error)
            console.log(result);
    });

    // また、コールバックを渡すとすぐに監視を開始します。
    var depositEvent = clientReceipt.Deposit(function(error, result) {
        if (!error)
            console.log(result);
    });

上記の出力は以下のようになります（トリミング済み）。

.. code-block:: json

    {
       "returnValues": {
           "from": "0x1111…FFFFCCCC",
           "id": "0x50…sd5adb20",
           "value": "0x420042"
       },
       "raw": {
           "data": "0x7f…91385",
           "topics": ["0xfd4…b4ead7", "0x7f…1a91385"]
       }
    }

イベントを理解するための追加資料
================================

- `JavaScriptドキュメント <https://github.com/web3/web3.js/blob/1.x/docs/web3-eth-contract.rst#events>`_

- `イベントの使用例 <https://github.com/ethchange/smart-exchange/blob/master/lib/contracts/SmartExchange.sol>`_

- `JSからイベントへのアクセス方法 <https://github.com/ethchange/smart-exchange/blob/master/lib/exchange_transactions.js>`_
