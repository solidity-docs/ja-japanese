###############################
スマートコントラクトの紹介
###############################

.. _simple-smart-contract:

************************************
シンプルなスマートコントラクト
************************************

.. Let us begin with a basic example that sets the value of a variable and exposes
.. it for other contracts to access. It is fine if you do not understand
.. everything right now, we will go into more detail later.

まずは、変数の値を設定し、他のコントラクトがアクセスできるように公開する基本的な例から始めましょう。今はまだ全てを理解していなくても構いません、後でもっと詳しく説明します。

ストレージの例
===============

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract SimpleStorage {
        uint storedData;

        function set(uint x) public {
            storedData = x;
        }

        function get() public view returns (uint) {
            return storedData;
        }
    }

.. The first line tells you that the source code is licensed under the
.. GPL version 3.0. Machine-readable license specifiers are important
.. in a setting where publishing the source code is the default.

最初の行は、ソースコードがGPLバージョン3.0でライセンスされていることを示しています。機械的に読み取り可能なライセンス指定子は、ソースコードの公開がデフォルトとなっている環境では重要です。

.. The next line specifies that the source code is written for
.. Solidity version 0.4.16, or a newer version of the language up to, but not including version 0.9.0.
.. This is to ensure that the contract is not compilable with a new (breaking) compiler version, where it could behave differently.
.. :ref:`Pragmas<pragma>` are common instructions for compilers about how to treat the
.. source code (e.g. `pragma once <https://en.wikipedia.org/wiki/Pragma_once>`_).

次の行では、ソースコードがSolidityバージョン0.4.16からバージョン0.9.0の前までのバージョンで書かれたものであることを指定しています（バージョン0.9.0は含まない）。
これは、コントラクトが新しい（破壊的変更があった）コンパイラのバージョンでコンパイルできないことを保証するためです。
:ref:`Pragma<pragma>` は、ソースコードをどのように扱うかについての、コンパイラに対する一般的な指示です（例: `pragma once <https://en.wikipedia.org/wiki/Pragma_once>`_ ）。

.. A contract in the sense of Solidity is a collection of code (its *functions*) and
.. data (its *state*) that resides at a specific address on the Ethereum
.. blockchain. The line ``uint storedData;`` declares a state variable called ``storedData`` of
.. type ``uint`` (*u*\nsigned *int*\eger of *256* bits). You can think of it as a single slot
.. in a database that you can query and alter by calling functions of the
.. code that manages the database. In this example, the contract defines the
.. functions ``set`` and ``get`` that can be used to modify
.. or retrieve the value of the variable.

Solidityでいうコントラクトとは、Ethereumブロックチェーン上の特定のアドレスに存在するコード（その *functions* ）とデータ（その *state* ）の集合体です。
``uint storedData;`` という行は、 ``uint`` （256ビットの *u*\nsigned *int*\eger）型の ``storedData`` という状態変数を宣言しています。
これは、データベースを管理するコードの関数を呼び出すことで問い合わせや変更ができる、データベースの1つのスロットと考えることができます。
この例では、コントラクトによって、変数の値を変更したり取得したりするのに使用できる関数 ``set`` と ``get`` が定義されています。

.. To access a member (like a state variable) of the current contract, you do not typically add the ``this.`` prefix,
.. you just access it directly via its name.
.. Unlike in some other languages, omitting it is not just a matter of style,
.. it results in a completely different way to access the member, but more on this later.

現在のコントラクトのメンバー（ステート変数など）にアクセスする場合、通常は ``this.`` という接頭辞を付けずに、その名前で直接アクセスします。
他のいくつかの言語とは異なり、これを省略することは単なるスタイルの問題ではなく、メンバーへのアクセス方法が全く異なるものになります。

.. This contract does not do much yet apart from (due to the infrastructure
.. built by Ethereum) allowing anyone to store a single number that is accessible by
.. anyone in the world without a (feasible) way to prevent you from publishing
.. this number. Anyone could call ``set`` again with a different value
.. and overwrite your number, but the number is still stored in the history
.. of the blockchain. Later, you will see how you can impose access restrictions
.. so that only you can alter the number.

このコントラクトは、（Ethereumが構築したインフラにより）世界中の誰もがアクセス可能な1つの番号を、あなたがこの番号を公開するのを防ぐ（実現可能な）方法なしに、誰もが保存できることを除けば、まだあまり意味がありません。
誰もが ``set`` に別の値で再度callをし、あなたの番号を上書きできますが、その番号はブロックチェーンの履歴に保存されたままです。
後で、自分だけが番号を変更できるようにアクセス制限をかける方法を見てみましょう。

.. warning::
    .. Be careful with using Unicode text, as similar looking (or even identical) characters can
    .. have different code points and as such are encoded as a different byte array.

    Unicodeテキストを使用する際には、見た目が似ている（あるいは同じ）文字でもコードポイントが異なる場合があり、その場合は異なるバイト配列としてエンコードされるので注意が必要です。

.. note::
    .. All identifiers (contract names, function names and variable names) are restricted to
    .. the ASCII character set. It is possible to store UTF-8 encoded data in string variables.

    すべての識別子（コントラクト名、関数名、変数名）は、ASCII文字セットに制限されています。文字列変数にUTF-8でエンコードされたデータを格納することは可能です。

.. index:: ! subcurrency

.. Subcurrency Example

サブ通貨の例
===================

.. The following contract implements the simplest form of a
.. cryptocurrency. The contract allows only its creator to create new coins (different issuance schemes are possible).
.. Anyone can send coins to each other without a need for
.. registering with a username and password, all you need is an Ethereum keypair.

以下のコントラクトは、最も単純な形態の暗号通貨を実装したものです。
このコントラクトでは、作成者のみが新しいコインを作成できます（異なる発行スキームが可能です）。
誰もがユーザー名とパスワードを登録することなく、Ethereumのキーペアさえあればコインを送り合うことができます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    contract Coin {
        // The keyword "public" makes variables
        // accessible from other contracts
        address public minter;
        mapping (address => uint) public balances;

        // Events allow clients to react to specific
        // contract changes you declare
        event Sent(address from, address to, uint amount);

        // Constructor code is only run when the contract
        // is created
        constructor() {
            minter = msg.sender;
        }

        // Sends an amount of newly created coins to an address
        // Can only be called by the contract creator
        function mint(address receiver, uint amount) public {
            require(msg.sender == minter);
            balances[receiver] += amount;
        }

        // Errors allow you to provide information about
        // why an operation failed. They are returned
        // to the caller of the function.
        error InsufficientBalance(uint requested, uint available);

        // Sends an amount of existing coins
        // from any caller to an address
        function send(address receiver, uint amount) public {
            if (amount > balances[msg.sender])
                revert InsufficientBalance({
                    requested: amount,
                    available: balances[msg.sender]
                });

            balances[msg.sender] -= amount;
            balances[receiver] += amount;
            emit Sent(msg.sender, receiver, amount);
        }
    }

.. This contract introduces some new concepts, let us go through them one by one.

今回のコントラクトでは、いくつかの新しい概念が導入されていますが、それらを一つずつ見ていきましょう。

.. The line ``address public minter;`` declares a state variable of type :ref:`address<address>`.
.. The ``address`` type is a 160-bit value that does not allow any arithmetic operations.
.. It is suitable for storing addresses of contracts, or a hash of the public half
.. of a keypair belonging to :ref:`external accounts<accounts>`.

``address public minter;`` という行は、 :ref:`address<address>` という型のステート変数を宣言しています。 ``address`` 型は160ビットの値で、算術演算を行うことができません。コントラクトのアドレスや、 :ref:`external accounts<accounts>` に属するキーペアのパブリックハーフのハッシュを格納するのに適しています。

.. The keyword ``public`` automatically generates a function that allows you to access the current value of the state
.. variable from outside of the contract. Without this keyword, other contracts have no way to access the variable.
.. The code of the function generated by the compiler is equivalent
.. to the following (ignore ``external`` and ``view`` for now):

キーワード ``public`` を指定すると、コントラクトの外部からステート変数の現在の値にアクセスできる関数が自動的に生成されます。このキーワードがないと、他のコントラクトはその変数にアクセスする方法がありません。コンパイラが生成する関数のコードは以下のようになります（今のところ ``external`` と ``view`` は無視してください）。

.. code-block:: solidity

    function minter() external view returns (address) { return minter; }

.. You could add a function like the above yourself, but you would have a function and state variable with the same name.
.. You do not need to do this, the compiler figures it out for you.

上記のような関数を自分で追加することもできますが、関数とステート変数が同じ名前になってしまいます。
このようなことをする必要はありません。コンパイラが計算してくれます。

.. index:: mapping

.. The next line, ``mapping (address => uint) public balances;`` also
.. creates a public state variable, but it is a more complex datatype.
.. The :ref:`mapping <mapping-types>` type maps addresses to :ref:`unsigned integers <integers>`.

次の行の ``mapping (address => uint) public balances;`` もパブリックな状態変数を作成しますが、より複雑なデータタイプです。:ref:`mapping <mapping-types>` 型は、アドレスを :ref:`unsigned integers <integers>` にマッピングします。

.. Mappings can be seen as `hash tables <https://en.wikipedia.org/wiki/Hash_table>`_ which are
.. virtually initialised such that every possible key exists from the start and is mapped to a
.. value whose byte-representation is all zeros. However, it is neither possible to obtain a list of all keys of
.. a mapping, nor a list of all values. Record what you
.. added to the mapping, or use it in a context where this is not needed. Or
.. even better, keep a list, or use a more suitable data type.

マッピングは、可能なすべてのキーが最初から存在し、バイト表現がすべてゼロである値にマッピングされるように仮想的に初期化された `ハッシュテーブル <https://en.wikipedia.org/wiki/Hash_table>`_ と見なすことができます。しかし、マッピングのすべてのキーのリストを得ることも、すべての値のリストを得ることもできません。マッピングに追加したものを記録するか、これが必要ない文脈で使用してください。あるいは、リストを保持するか、より適切なデータ型を使用することをお勧めします。

.. The :ref:`getter function<getter-functions>` created by the ``public`` keyword
.. is more complex in the case of a mapping. It looks like the
.. following:

``public`` キーワードで作成した :ref:`getter function<getter-functions>` は、マッピングの場合はもっと複雑です。それは次のようなものです。

.. code-block:: solidity

    function balances(address _account) external view returns (uint) {
        return balances[_account];
    }

.. You can use this function to query the balance of a single account.

この関数を使って、1つのアカウントの残高を照会できます。

.. index:: event

.. The line ``event Sent(address from, address to, uint amount);`` declares
.. an :ref:`"event" <events>`, which is emitted in the last line of the function
.. ``send``. Ethereum clients such as web applications can
.. listen for these events emitted on the blockchain without much
.. cost. As soon as it is emitted, the listener receives the
.. arguments ``from``, ``to`` and ``amount``, which makes it possible to track
.. transactions.

``event Sent(address from, address to, uint amount);`` という行は、 :ref:`"event" <events>` を宣言しており、このイベントは関数 ``send`` の最終行で発せられます。ウェブアプリケーションなどのEthereumクライアントは、ブロックチェーン上で発せられるこれらのイベントを、それほどコストをかけずにリッスンできます。イベントが発せられると同時に、リスナーは引数の ``from``, ``to``, ``amount`` を受け取るため、トランザクションの追跡が可能になります。

.. To listen for this event, you could use the following
.. JavaScript code, which uses `web3.js <https://github.com/ethereum/web3.js/>`_ to create the ``Coin`` contract object,
.. and any user interface calls the automatically generated ``balances`` function from above::
..

`web3.js <https://github.com/ethereum/web3.js/>`_ を使って ``Coin`` のコントラクトオブジェクトを作成し、どのようなユーザーインターフェースであっても、上記で自動的に生成された ``balances`` 関数を呼び出すようになっています。::

    Coin.Sent().watch({}, '', function(error, result) {
        if (!error) {
            console.log("Coin transfer: " + result.args.amount +
                " coins were sent from " + result.args.from +
                " to " + result.args.to + ".");
            console.log("Balances now:\n" +
                "Sender: " + Coin.balances.call(result.args.from) +
                "Receiver: " + Coin.balances.call(result.args.to));
        }
    })

.. index:: coin

.. The :ref:`constructor<constructor>` is a special function that is executed during the creation of the contract and
.. cannot be called afterwards. In this case, it permanently stores the address of the person creating the
.. contract. The ``msg`` variable (together with ``tx`` and ``block``) is a
.. :ref:`special global variable <special-variables-functions>` that
.. contains properties which allow access to the blockchain. ``msg.sender`` is
.. always the address where the current (external) function call came from.

:ref:`constructor<constructor>` は、コントラクトの作成時に実行され、その後は呼び出すことができない特別な関数です。
この場合、コントラクトを作成した人のアドレスを恒久的に保存します。
``msg`` 変数は（ ``tx`` や ``block`` と一緒に） :ref:`特別なグローバル変数 <special-variables-functions>` であり、ブロックチェーンへのアクセスを可能にするプロパティを含んでいます。
``msg.sender`` は常に、現在の(外部の)関数呼び出しが行われたアドレスです。

.. The functions that make up the contract, and that users and contracts can call are ``mint`` and ``send``.

コントラクトを構成し、ユーザーやコントラクトが呼び出すことのできる関数は、 ``mint`` と ``send`` です。

.. The ``mint`` function sends an amount of newly created coins to another address. The :ref:`require
.. <assert-and-require>` function call defines conditions that reverts all changes if not met. In this
.. example, ``require(msg.sender == minter);`` ensures that only the creator of the contract can call
.. ``mint``. In general, the creator can mint as many tokens as they like, but at some point, this will
.. lead to a phenomenon called "overflow". Note that because of the default :ref:`Checked arithmetic
.. <unchecked>`, the transaction would revert if the expression ``balances[receiver] += amount;``
.. overflows, i.e., when ``balances[receiver] + amount`` in arbitrary precision arithmetic is larger
.. than the maximum value of ``uint`` (``2**256 - 1``). This is also true for the statement
.. ``balances[receiver] += amount;`` in the function ``send``.

``mint`` 関数は、新しく作成されたコインの量を別のアドレスに送信します。
:ref:`require <assert-and-require>` 関数の呼び出しでは、条件を定義し、満たされない場合はすべての変更を元に戻します。
この例では、 ``require(msg.sender == minter);`` により、コントラクトの作成者だけが ``mint`` を呼び出せるようになっています。
一般的には、作成者は好きなだけトークンをミントできますが、ある時点で「オーバーフロー」と呼ばれる現象が発生します。
デフォルトの :ref:`Checked arithmetic <unchecked>` のため、式 ``balances[receiver] += amount;`` がオーバーフローした場合、つまり、任意精度の算術演算で ``balances[receiver] + amount`` が ``uint`` の最大値（ ``2**256 - 1`` ）よりも大きくなった場合には、トランザクションは元に戻ってしまうことに注意してください。
これは、関数 ``send`` の中の ``balances[receiver] += amount;`` という記述にも当てはまります。

.. :ref:`Errors <errors>` allow you to provide more information to the caller about
.. why a condition or operation failed. Errors are used together with the
.. :ref:`revert statement <revert-statement>`. The revert statement unconditionally
.. aborts and reverts all changes similar to the ``require`` function, but it also
.. allows you to provide the name of an error and additional data which will be supplied to the caller
.. (and eventually to the front-end application or block explorer) so that
.. a failure can more easily be debugged or reacted upon.

:ref:`Errors <errors>` を使うと、条件や操作が失敗したときに呼び出し側に詳しい情報を提供できます。
エラーは :ref:`revert statement <revert-statement>` と一緒に使用されます。
revert 文は ``require`` 関数と同様にすべての変更を無条件に中止、復帰させますが、エラーの名前や、呼び出し側（最終的にはフロントエンドアプリケーションやブロックエクスプローラ）に提供される追加データを提供することもできますので、失敗をより簡単にデバッグしたり、対応したりできます。

.. The ``send`` function can be used by anyone (who already
.. has some of these coins) to send coins to anyone else. If the sender does not have
.. enough coins to send, the ``if`` condition evaluates to true. As a result, the ``revert`` will cause the operation to fail
.. while providing the sender with error details using the ``InsufficientBalance`` error.

``send`` 関数は、（すでにコインを持っている）誰でも、他の人にコインを送るために使うことができます。
送信者が送信するのに十分なコインを持っていない場合は、 ``if`` の条件が true と評価されます。
結果として、 ``revert`` は操作を失敗させ、送信者には ``InsufficientBalance`` というエラーの詳細を伝えます。

.. note::
    .. If you use
    .. this contract to send coins to an address, you will not see anything when you
    .. look at that address on a blockchain explorer, because the record that you sent
    .. coins and the changed balances are only stored in the data storage of this
    .. particular coin contract. By using events, you can create
    .. a "blockchain explorer" that tracks transactions and balances of your new coin,
    .. but you have to inspect the coin contract address and not the addresses of the
    .. coin owners.

    このコントラクトを使ってあるアドレスにコインを送っても、ブロックチェーン・エクスプローラーでそのアドレスを見ても何もわかりません。なぜなら、コインを送ったという記録と変更された残高は、この特定のコインコントラクトのデータストレージにのみ保存されているからです。イベントを使えば、新しいコインのトランザクションや残高を追跡する「ブロックチェーンエクスプローラー」を作ることができますが、コインの所有者のアドレスではなく、コインコントラクトのアドレスを検査する必要があります。

.. _blockchain-basics:

****************************
ブロックチェーンの基本
****************************

.. Blockchains as a concept are not too hard to understand for programmers. The reason is that
.. most of the complications (mining, `hashing <https://en.wikipedia.org/wiki/Cryptographic_hash_function>`_,
.. `elliptic-curve cryptography <https://en.wikipedia.org/wiki/Elliptic_curve_cryptography>`_,
.. `peer-to-peer networks <https://en.wikipedia.org/wiki/Peer-to-peer>`_, etc.)
.. are just there to provide a certain set of features and promises for the platform. Once you accept these
.. features as given, you do not have to worry about the underlying technology - or do you have
.. to know how Amazon's AWS works internally in order to use it?

概念としてのブロックチェーンは、プログラマーにとってはそれほど難しいものではありません。
なぜなら、複雑な仕組み（マイニング、 `ハッシュ <https://en.wikipedia.org/wiki/Cryptographic_hash_function>`_ 、 `楕円曲線暗号 <https://en.wikipedia.org/wiki/Elliptic_curve_cryptography>`_ 、 `ピアツーピア・ネットワーク <https://en.wikipedia.org/wiki/Peer-to-peer>`_ など）のほとんどは、プラットフォームに一定の機能や約束事を提供するために存在しているだけだからです。
これらの機能を当たり前のように受け入れれば、基盤となる技術について心配する必要はありません。あるいは、AmazonのAWSを使うためには、内部でどのように機能しているかを知る必要があるのでしょうか？

.. index:: transaction

トランザクション
====================

.. A blockchain is a globally shared, transactional database.
.. This means that everyone can read entries in the database just by participating in the network.
.. If you want to change something in the database, you have to create a so-called transaction
.. which has to be accepted by all others.
.. The word transaction implies that the change you want to make (assume you want to change
.. two values at the same time) is either not done at all or completely applied. Furthermore,
.. while your transaction is being applied to the database, no other transaction can alter it.

ブロックチェーンとは、グローバルに共有されたトランザクション用のデータベースです。つまり、ネットワークに参加するだけで、誰もがデータベースのエントリーを読むことができるのです。データベース内の何かを変更したい場合は、いわゆるトランザクションを作成し、他のすべての人に受け入れられなければなりません。トランザクションという言葉は、あなたが行いたい変更（2つの値を同時に変更したいと仮定）が、まったく行われないか、完全に適用されるかのどちらかであることを意味しています。さらに、あなたのトランザクションがデータベースに適用されている間は、他のトランザクションはそれを変更できません。

.. As an example, imagine a table that lists the balances of all accounts in an
.. electronic currency. If a transfer from one account to another is requested,
.. the transactional nature of the database ensures that if the amount is
.. subtracted from one account, it is always added to the other account. If due
.. to whatever reason, adding the amount to the target account is not possible,
.. the source account is also not modified.

例として、ある電子通貨のすべての口座の残高を一覧にしたテーブルがあるとします。ある口座から別の口座への振り込みが要求された場合、データベースのトランザクションの性質上、ある口座から金額が差し引かれた場合、必ず別の口座に追加されます。何らかの理由で対象となる口座に金額を追加できない場合は、元の口座も変更されません。

.. Furthermore, a transaction is always cryptographically signed by the sender (creator).
.. This makes it straightforward to guard access to specific modifications of the
.. database. In the example of the electronic currency, a simple check ensures that
.. only the person holding the keys to the account can transfer money from it.

さらに、トランザクションは常に送信者（作成者）によって暗号化されています。これにより、データベースの特定の変更に対するアクセスを簡単に保護できます。電子通貨の例では、簡単なチェックで、口座の鍵を持っている人だけがその口座からお金を送金できるようになっています。

.. index:: ! block

ブロック
=============

.. One major obstacle to overcome is what (in Bitcoin terms) is called a "double-spend attack":
.. What happens if two transactions exist in the network that both want to empty an account?
.. Only one of the transactions can be valid, typically the one that is accepted first.
.. The problem is that "first" is not an objective term in a peer-to-peer network.

克服しなければならない大きな障害のひとつが、ビットコイン用語で「二重支出攻撃」と呼ばれるものです。ネットワーク上に2つのトランザクションが存在し、どちらもアカウントを空にしようとしていたらどうなるでしょうか？ネットワーク上に2つのトランザクションが存在し、どちらもアカウントを空にしようとした場合、どちらか一方のみが有効となります。問題は、ピア・ツー・ピアのネットワークでは「最初」という言葉が客観的ではないことです。

.. The abstract answer to this is that you do not have to care. A globally accepted order of the transactions
.. will be selected for you, solving the conflict. The transactions will be bundled into what is called a "block"
.. and then they will be executed and distributed among all participating nodes.
.. If two transactions contradict each other, the one that ends up being second will
.. be rejected and not become part of the block.

これに対する抽象的な答えは、「気にする必要はない」というものです。世界的に認められたトランザクションの順序が選択され、対立を解決してくれます。トランザクションは「ブロック」と呼ばれるものにまとめられ、実行されて参加しているすべてのノードに分配されることになります。2つのトランザクションが互いに矛盾する場合、2番目になった方が拒否され、ブロックの一部にはなりません。

.. These blocks form a linear sequence in time and that is where the word "blockchain"
.. derives from. Blocks are added to the chain in rather regular intervals - for
.. Ethereum this is roughly every 17 seconds.

これらのブロックは、時間的に直線的な配列を形成しており、これが「ブロックチェーン」という言葉の由来となっています。ブロックは一定の間隔でチェーンに追加され、イーサリアムの場合はおよそ17秒ごとに追加されます。

.. As part of the "order selection mechanism" (which is called "mining") it may happen that
.. blocks are reverted from time to time, but only at the "tip" of the chain. The more
.. blocks are added on top of a particular block, the less likely this block will be reverted. So it might be that your transactions
.. are reverted and even removed from the blockchain, but the longer you wait, the less
.. likely it will be.

「オーダー・セレクション・メカニズム」（これを「マイニング」と呼びます）の一環として、ブロックが時々戻されることがありますが、それはチェーンの「先端」に限ったことです。特定のブロックの上にブロックが追加されればされるほど、そのブロックが元に戻される可能性は低くなります。つまり、あなたのトランザクションが元に戻され、さらにはブロックチェーンから削除されることもあるかもしれませんが、待てば待つほど、その可能性は低くなります。

.. note::
    .. Transactions are not guaranteed to be included in the next block or any specific future block,
    .. since it is not up to the submitter of a transaction, but up to the miners to determine in which block the transaction is included.

    .. If you want to schedule future calls of your contract, you can use
    .. the `alarm clock <https://www.ethereum-alarm-clock.com/>`_ or a similar oracle service.

    トランザクションが次のブロックや将来の特定のブロックに含まれることは保証されていません。
    なぜなら、トランザクションの提出者が決めるのではなく、そのトランザクションがどのブロックに含まれるかを決めるのはマイナーに任されているからです。
    コントラクトの将来の呼び出しをスケジュールしたい場合は、 `alarm clock <https://www.ethereum-alarm-clock.com/>`_ または同様のオラクルサービスを使用できます。

.. _the-ethereum-virtual-machine:

.. index:: !evm, ! ethereum virtual machine

****************************
Ethereum Virtual Machine
****************************

概要
========

.. The Ethereum Virtual Machine or EVM is the runtime environment
.. for smart contracts in Ethereum. It is not only sandboxed but
.. actually completely isolated, which means that code running
.. inside the EVM has no access to network, filesystem or other processes.
.. Smart contracts even have limited access to other smart contracts.

Ethereum Virtual Machine（EVM）は、Ethereumにおけるスマートコントラクトの実行環境です。EVMはサンドボックス化されているだけでなく、実際には完全に隔離されています。つまり、EVM内で実行されるコードは、ネットワーク、ファイルシステム、または他のプロセスにアクセスできません。スマートコントラクトは、他のスマートコントラクトへのアクセスも制限されています。

.. index:: ! account, address, storage, balance

.. _accounts:

アカウント
============

.. There are two kinds of accounts in Ethereum which share the same
.. address space: **External accounts** that are controlled by
.. public-private key pairs (i.e. humans) and **contract accounts** which are
.. controlled by the code stored together with the account.

Ethereumには、同じアドレス空間を共有する2種類のアカウントがあります。それは、公開鍵と秘密鍵のペア（つまり人間）によって管理される **外部アカウント** と、アカウントと一緒に保存されているコードによって管理される **コントラクトアカウント** です。

.. The address of an external account is determined from
.. the public key while the address of a contract is
.. determined at the time the contract is created
.. (it is derived from the creator address and the number
.. of transactions sent from that address, the so-called "nonce").

外部アカウントのアドレスは公開鍵から決定されますが、コントラクトのアドレスはコントラクトが作成された時点で決定されます（作成者のアドレスとそのアドレスから送信されたトランザクションの数、いわゆる「nonce」から導き出されます）。

.. Regardless of whether or not the account stores code, the two types are
.. treated equally by the EVM.

アカウントにコードが格納されているかどうかにかかわらず、EVMでは2つのタイプが同じように扱われます。

.. Every account has a persistent key-value store mapping 256-bit words to 256-bit
.. words called **storage**.

すべてのアカウントには、256ビットのワードと256ビットのワードをマッピングする永続的なキーバリューストアがあり、これを **storage** と呼びます。

.. Furthermore, every account has a **balance** in
.. Ether (in "Wei" to be exact, ``1 ether`` is ``10**18 wei``) which can be modified by sending transactions that
.. include Ether.

さらに、すべてのアカウントはEther（正確には「Wei」で、 ``1 ether`` は ``10**18 wei`` ）で **残高** を持っており、Etherを含むトランザクションを送信することで変更できます。

.. index:: ! transaction

トランザクション
====================

.. A transaction is a message that is sent from one account to another
.. account (which might be the same or empty, see below).
.. It can include binary data (which is called "payload") and Ether.

トランザクションとは、あるアカウントから別のアカウント（同じアカウントの場合もあれば、空のアカウントの場合もある、以下参照）に送信されるメッセージです。このメッセージには、バイナリデータ（これを「ペイロード」と呼びます）とEtherが含まれます。

.. If the target account contains code, that code is executed and
.. the payload is provided as input data.

対象となるアカウントにコードが含まれている場合、そのコードが実行され、ペイロードが入力データとして提供されます。

.. If the target account is not set (the transaction does not have
.. a recipient or the recipient is set to ``null``), the transaction
.. creates a **new contract**.
.. As already mentioned, the address of that contract is not
.. the zero address but an address derived from the sender and
.. its number of transactions sent (the "nonce"). The payload
.. of such a contract creation transaction is taken to be
.. EVM bytecode and executed. The output data of this execution is
.. permanently stored as the code of the contract.
.. This means that in order to create a contract, you do not
.. send the actual code of the contract, but in fact code that
.. returns that code when executed.

対象となる口座が設定されていない（トランザクションに受取人がいない、または受取人が「null」に設定されている）場合、そのトランザクションは **新しいコントラクト** を作成します。すでに述べたように、そのコントラクトのアドレスはゼロのアドレスではなく、送信者とその送信したトランザクション数から得られるアドレス（「nonce」）です。このようなコントラクト作成トランザクションのペイロードは、EVMバイトコードとみなされ、実行される。この実行の出力データは、コントラクトのコードとして永続的に保存されます。つまり、コントラクトを作成するためには、コントラクトの実際のコードを送信するのではなく、実際には、実行されるとそのコードを返すコードを送信することになります。

.. note::
  .. While a contract is being created, its code is still empty.
  .. Because of that, you should not call back into the
  .. contract under construction until its constructor has
  .. finished executing.

  コントラクトが作成されている間、そのコードはまだ空です。そのため、コンストラクタの実行が終了するまで、作成中のコントラクトにコールバックしてはいけません。

.. index:: ! gas, ! gas price

ガス
===

.. Upon creation, each transaction is charged with a certain amount of **gas**,
.. whose purpose is to limit the amount of work that is needed to execute
.. the transaction and to pay for this execution at the same time. While the EVM executes the
.. transaction, the gas is gradually depleted according to specific rules.

生成された各トランザクションには、一定量の **gas** が課されます。
その目的は、トランザクションを実行するために必要な作業量を制限すると同時に、その実行に対する対価を支払うことです。EVMがトランザクションを実行している間、ガスは特定のルールに従って徐々に減っていきます。

.. The **gas price** is a value set by the creator of the transaction, who
.. has to pay ``gas_price * gas`` up front from the sending account.
.. If some gas is left after the execution, it is refunded to the creator in the same way.

**gas price** は、トランザクションの作成者が設定する値で、作成者は送信側の口座から ``gas_price * gas`` を前払いする必要があります。実行後にガスが残っていた場合は、同様の方法で作成者に返金されます。

.. If the gas is used up at any point (i.e. it would be negative),
.. an out-of-gas exception is triggered, which reverts all modifications
.. made to the state in the current call frame.

いずれかの時点でガスが使い切られると（つまりマイナスになると）、ガス切れの例外が発生し、現在のコールフレームで状態に加えられたすべての変更が元に戻ります。

.. index:: ! storage, ! memory, ! stack

.. Storage, Memory and the Stack

ストレージ、メモリおよびスタック
=====================================================

.. The Ethereum Virtual Machine has three areas where it can store data-
.. storage, memory and the stack, which are explained in the following
.. paragraphs.

Ethereum Virtual Machineには、データを保存できる3つの領域「ストレージ」「メモリ」「スタック」があり、以下の段落で説明します。

.. Each account has a data area called **storage**, which is persistent between function calls
.. and transactions.
.. Storage is a key-value store that maps 256-bit words to 256-bit words.
.. It is not possible to enumerate storage from within a contract, it is
.. comparatively costly to read, and even more to initialise and modify storage. Because of this cost,
.. you should minimize what you store in persistent storage to what the contract needs to run.
.. Store data like derived calculations, caching, and aggregates outside of the contract.
.. A contract can neither read nor write to any storage apart from its own.

各アカウントには **storage** と呼ばれるデータ領域があり、関数呼び出しやトランザクション間で永続的に使用されます。
storageは256ビットのワードを256ビットのワードにマッピングするkey-value storeです。
コントラクト内からストレージを列挙できず、読み込みには比較的コストがかかり、ストレージの初期化や変更にはさらにコストがかかります。
このコストのため、永続的なストレージに保存するものは、コントラクトが実行するために必要なものに限定するべきです。
派生する計算、キャッシング、アグリゲートなどのデータはコントラクトの外に保存します。コントラクトは、コントラクト以外のストレージに対して読み書きできません。

.. The second data area is called **memory**, of which a contract obtains
.. a freshly cleared instance for each message call. Memory is linear and can be
.. addressed at byte level, but reads are limited to a width of 256 bits, while writes
.. can be either 8 bits or 256 bits wide. Memory is expanded by a word (256-bit), when
.. accessing (either reading or writing) a previously untouched memory word (i.e. any offset
.. within a word). At the time of expansion, the cost in gas must be paid. Memory is more
.. costly the larger it grows (it scales quadratically).

2つ目のデータ領域は **memory** と呼ばれ、コントラクトはメッセージを呼び出すたびにクリアされたばかりのインスタンスを取得します。メモリは線形で、バイトレベルでアドレスを指定できますが、読み出しは256ビットの幅に制限され、書き込みは8ビットまたは256ビットの幅に制限されます。メモリは、これまで手つかずだったメモリワード（ワード内の任意のオフセット）にアクセス（読み出しまたは書き込み）すると、ワード（256ビット）単位で拡張されます。拡張時には、ガスによるコストを支払わなければならない。メモリは大きくなればなるほどコストが高くなる（二次関数的にスケールする）。

.. The EVM is not a register machine but a stack machine, so all
.. computations are performed on a data area called the **stack**. It has a maximum size of
.. 1024 elements and contains words of 256 bits. Access to the stack is
.. limited to the top end in the following way:
.. It is possible to copy one of
.. the topmost 16 elements to the top of the stack or swap the
.. topmost element with one of the 16 elements below it.
.. All other operations take the topmost two (or one, or more, depending on
.. the operation) elements from the stack and push the result onto the stack.
.. Of course it is possible to move stack elements to storage or memory
.. in order to get deeper access to the stack,
.. but it is not possible to just access arbitrary elements deeper in the stack
.. without first removing the top of the stack.

EVMはレジスタマシンではなく、スタックマシンなので、すべての計算は **stack** と呼ばれるデータ領域で行われます。スタックの最大サイズは1024要素で、256ビットのワードを含みます。スタックへのアクセスは次のように上端に制限されています。一番上の16個の要素の1つをスタックの一番上にコピーしたり、一番上の要素をその下の16個の要素の1つと入れ替えたりすることが可能です。それ以外の操作では、スタックから最上位の2要素（操作によっては1要素、またはそれ以上）を取り出し、その結果をスタックにプッシュします。もちろん、スタックの要素をストレージやメモリに移動させて、スタックに深くアクセスすることは可能ですが、最初にスタックの最上部を取り除かずに、スタックの深いところにある任意の要素にアクセスできません。

.. index:: ! instruction

.. Instruction Set

命令セット
===============

.. The instruction set of the EVM is kept minimal in order to avoid
.. incorrect or inconsistent implementations which could cause consensus problems.
.. All instructions operate on the basic data type, 256-bit words or on slices of memory
.. (or other byte arrays).
.. The usual arithmetic, bit, logical and comparison operations are present.
.. Conditional and unconditional jumps are possible. Furthermore,
.. contracts can access relevant properties of the current block
.. like its number and timestamp.

EVMの命令セットは、コンセンサスの問題を引き起こす可能性のある不正確な実装や矛盾した実装を避けるために、最小限に抑えられています。すべての命令は、基本的なデータ型である256ビットのワード、またはメモリのスライス（または他のバイトアレイ）で動作します。通常の算術演算、ビット演算、論理演算、比較演算が可能です。条件付きおよび無条件のジャンプが可能です。さらにコントラクトでは、番号やタイムスタンプなど、現在のブロックの関連プロパティにアクセスできます。

.. For a complete list, please see the :ref:`list of opcodes <opcodes>` as part of the inline
.. assembly documentation.

完全なリストについては、インラインアセンブリのドキュメントの一部である :ref:`list of opcodes <opcodes>` を参照してください。

.. index:: ! message call, function;call

.. Message Calls

メッセージコール
==============================

.. Contracts can call other contracts or send Ether to non-contract
.. accounts by the means of message calls. Message calls are similar
.. to transactions, in that they have a source, a target, data payload,
.. Ether, gas and return data. In fact, every transaction consists of
.. a top-level message call which in turn can create further message calls.

コントラクトは、メッセージコールによって、他のコントラクトを呼び出したり、コントラクト以外のアカウントにEtherを送信できます。メッセージ・コールは、ソース、ターゲット、データ・ペイロード、Ether、ガス、およびリターン・データを持つという点で、トランザクションと似ています。実際、すべてのトランザクションは、トップレベルのメッセージ・コールで構成されており、そのメッセージ・コールがさらにメッセージ・コールを作成できます。

.. A contract can decide how much of its remaining **gas** should be sent
.. with the inner message call and how much it wants to retain.
.. If an out-of-gas exception happens in the inner call (or any
.. other exception), this will be signaled by an error value put onto the stack.
.. In this case, only the gas sent together with the call is used up.
.. In Solidity, the calling contract causes a manual exception by default in
.. such situations, so that exceptions "bubble up" the call stack.

コントラクトは、その残りの **gas** のうち、どれだけを内部メッセージ呼び出しで送信し、どれだけを保持したいかを決定できます。内側の呼び出しでガス切れの例外（またはその他の例外）が発生した場合は、スタックに置かれたエラー値によって通知されます。この場合、呼び出しと一緒に送られたガスだけが使い切られます。Solidityでは、このような状況では、呼び出し側のコントラクトがデフォルトで手動例外を発生させ、例外がコールスタックを「バブルアップ」するようにしています。

.. As already said, the called contract (which can be the same as the caller)
.. will receive a freshly cleared instance of memory and has access to the
.. call payload - which will be provided in a separate area called the **calldata**.
.. After it has finished execution, it can return data which will be stored at
.. a location in the caller's memory preallocated by the caller.
.. All such calls are fully synchronous.

すでに述べたように、呼び出されたコントラクト（呼び出し側と同じ場合もある）は、メモリのクリアされたばかりのインスタンスを受け取り、呼び出しペイロード（ **calldata** と呼ばれる別の領域に提供される）にアクセスできます。実行終了後、呼び出し元のメモリ内で呼び出し元が事前に割り当てた場所に保存されるデータを返すことができます。このような呼び出しはすべて完全に同期しています。

.. Calls are **limited** to a depth of 1024, which means that for more complex
.. operations, loops should be preferred over recursive calls. Furthermore,
.. only 63/64th of the gas can be forwarded in a message call, which causes a
.. depth limit of a little less than 1000 in practice.

呼び出しの深さは1024までに **制限** されます。
つまり、より複雑な操作を行う場合には、再帰的な呼び出しよりもループの方が望ましいということです。さらに、メッセージコールではガスの63/64番目だけを転送できるため、実際には1000よりも少し少ない深さの制限が発生します。

.. index:: delegatecall, callcode, library

.. Delegatecall / Callcode and Libraries

Delegatecall / Callcode とライブラリ
=====================================

.. There exists a special variant of a message call, named **delegatecall**
.. which is identical to a message call apart from the fact that
.. the code at the target address is executed in the context of the calling
.. contract and ``msg.sender`` and ``msg.value`` do not change their values.

メッセージコールには、 **delegatecall** という特別なバリエーションがあります。
これは、ターゲットアドレスのコードが呼び出し元のコントラクトのコンテキストで実行され、 ``msg.sender`` と ``msg.value`` の値が変更されないという点を除けば、メッセージコールと同じです。

.. This means that a contract can dynamically load code from a different
.. address at runtime. Storage, current address and balance still
.. refer to the calling contract, only the code is taken from the called address.

これは、コントラクトが実行時に異なるアドレスからコードを動的にロードできることを意味します。ストレージ、現在のアドレス、バランスは依然として呼び出したコントラクトのものを参照しており、コードだけが呼び出されたアドレスから取得されます。

.. This makes it possible to implement the "library" feature in Solidity:
.. Reusable library code that can be applied to a contract's storage, e.g. in
.. order to implement a complex data structure.

これにより、Solidityに「ライブラリ」機能を実装することが可能になりました。再利用可能なライブラリコードで、複雑なデータ構造を実装するためにコントラクトのストレージに適用することなどが可能です。

.. index:: log

ログ
====

.. It is possible to store data in a specially indexed data structure
.. that maps all the way up to the block level. This feature called **logs**
.. is used by Solidity in order to implement :ref:`events <events>`.
.. Contracts cannot access log data after it has been created, but they
.. can be efficiently accessed from outside the blockchain.
.. Since some part of the log data is stored in `bloom filters <https://en.wikipedia.org/wiki/Bloom_filter>`_, it is
.. possible to search for this data in an efficient and cryptographically
.. secure way, so network peers that do not download the whole blockchain
.. (so-called "light clients") can still find these logs.

ブロックレベルまでマッピングされた特別なインデックス付きのデータ構造にデータを保存することが可能です。この **logs** と呼ばれる機能は、Solidityでは :ref:`events <events>` を実装するために使用されています。コントラクトはログデータが作成された後はアクセスできませんが、ブロックチェーンの外部から効率的にアクセスできます。ログデータの一部は `bloom filters <https://en.wikipedia.org/wiki/Bloom_filter>`_ に格納されているため、効率的かつ暗号的に安全な方法でこのデータを検索することが可能であり、ブロックチェーン全体をダウンロードしないネットワークピア（いわゆる「ライトクライアント」）でもこれらのログを見つけることができます。

.. index:: contract creation

Create
======

.. Contracts can even create other contracts using a special opcode (i.e.
.. they do not simply call the zero address as a transaction would). The only difference between
.. these **create calls** and normal message calls is that the payload data is
.. executed and the result stored as code and the caller / creator
.. receives the address of the new contract on the stack.

コントラクトは、特別なオペコードを使用して他のコントラクトを作成することもできます（つまり、トランザクションのように単純にゼロアドレスを呼び出すわけではありません）。これらの **createコール** と通常のメッセージコールとの唯一の違いは、ペイロードデータが実行され、その結果がコードとして保存され、呼び出し側/作成側がスタック上の新しいコントラクトのアドレスを受け取ることです。

.. index:: selfdestruct, self-destruct, deactivate

.. Deactivate and Self-destruct

DeactivateとSelf-destruct
============================

.. The only way to remove code from the blockchain is when a contract at that
.. address performs the ``selfdestruct`` operation. The remaining Ether stored
.. at that address is sent to a designated target and then the storage and code
.. is removed from the state. Removing the contract in theory sounds like a good
.. idea, but it is potentially dangerous, as if someone sends Ether to removed
.. contracts, the Ether is forever lost.

ブロックチェーンからコードを削除する唯一の方法は、そのアドレスのコントラクトが ``selfdestruct`` オペレーションを実行することです。そのアドレスに保存されている残りのEtherは、指定されたターゲットに送られ、その後、ストレージとコードが状態から削除されます。理論的にはコントラクトを削除することは良いアイデアのように聞こえますが、削除されたコントラクトに誰かがEtherを送ると、そのEtherは永遠に失われてしまうため、潜在的には危険です。

.. warning::
    .. Even if a contract is removed by ``selfdestruct``, it is still part of the
    .. history of the blockchain and probably retained by most Ethereum nodes.
    .. So using ``selfdestruct`` is not the same as deleting data from a hard disk.

    ``selfdestruct`` によってコントラクトが削除されたとしても、それはブロックチェーンの歴史の一部であり、おそらくほとんどのEthereumノードが保持しています。そのため、 ``selfdestruct`` を使うことは、ハードディスクからデータを削除することと同じではありません。

.. note::
    .. Even if a contract's code does not contain a call to ``selfdestruct``,
    .. it can still perform that operation using ``delegatecall`` or ``callcode``.

    コントラクトのコードに ``selfdestruct`` の呼び出しが含まれていなくても、 ``delegatecall`` や ``callcode`` を使ってその操作を行うことができます。

.. If you want to deactivate your contracts, you should instead **disable** them
.. by changing some internal state which causes all functions to revert. This
.. makes it impossible to use the contract, as it returns Ether immediately.

コントラクトを無効にしたい場合は、代わりに、すべての関数を元に戻すような何らかの内部状態を変更することで**無効**にする必要があります。これにより、コントラクトはすぐにEtherを返してしまうため、使用できなくなります。


.. index:: ! precompiled contracts, ! precompiles, ! contract;precompiled

.. _precompiledContracts:

.. Precompiled Contracts

プリコンパイルされたコントラクト
===================================================

.. There is a small set of contract addresses that are special:
.. The address range between ``1`` and (including) ``8`` contains
.. "precompiled contracts" that can be called as any other contract
.. but their behaviour (and their gas consumption) is not defined
.. by EVM code stored at that address (they do not contain code)
.. but instead is implemented in the EVM execution environment itself.

コントラクトのアドレスの中には、特別なものがあります。 ``1`` から ``8`` までのアドレスには「プリコンパイルされたコントラクト」が含まれており、他のコントラクトと同様に呼び出すことができますが、その動作（およびガス消費量）は、そのアドレスに格納されているEVMコードによって定義されるのではなく（コードが含まれていない）、EVMの実行環境自体に実装されています。

.. Different EVM-compatible chains might use a different set of
.. precompiled contracts. It might also be possible that new
.. precompiled contracts are added to the Ethereum main chain in the future,
.. but you can reasonably expect them to always be in the range between
.. ``1`` and ``0xffff`` (inclusive).

EVMと互換性のあるチェーンでは、異なるプリコンパイルコントラクトのセットを使用する可能性があります。また、将来的にEthereumのメインチェーンに新しいプリコンパイルされたコントラクトが追加される可能性もありますが、常に ``1`` から ``0xffff`` (包括的)の範囲内であると考えるのが妥当でしょう。