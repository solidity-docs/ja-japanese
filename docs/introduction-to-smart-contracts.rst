##########################
スマートコントラクトの紹介
##########################

.. _simple-smart-contract:

******************************
シンプルなスマートコントラクト
******************************

まずは、他のコントラクトが変数の値を読み書きできる基本的なコントラクトの例から始めましょう。
今はまだ全てを理解しなくても構いません、後でもっと詳しく説明します。

ストレージの例
==============

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

最初の行は、ソースコードがGPLバージョン3.0でライセンスされていることを示しています。
このライセンス指定子は機械的に読み取り可能であり、ソースコードの公開がデフォルトとなっている環境では重要です。

2行目では、ソースコードがSolidityバージョン0.4.16からバージョン0.9.0の前までのバージョンで書かれたものであることを示しています（バージョン0.9.0は含みません）。
これは、コントラクトが新しい（破壊的変更があった）コンパイラのバージョンでコンパイルできないことを保証するためです。
:ref:`pragma<pragma>` は、コンパイラに対してソースコードをどのように扱うかを規定する指示であり、Solidityに限らず一般的に使われているものです（例: `pragma once <https://en.wikipedia.org/wiki/Pragma_once>`_ ）。

Solidityにおけるコントラクトとは、Ethereumブロックチェーン上の特定のアドレスに存在するコード（ *関数* ）とデータ（ *ステート* ）の集合です。
``uint storedData;`` という行は、 ``uint`` （256ビットの非負整数）型の ``storedData`` という状態変数を宣言しています。
これは、データベースの1つのスロットとして考えることができます。
データベースを管理するコードの関数を呼び出すと、そのスロットの取得や変更ができるようなイメージです。
この例では、コントラクトによって、変数の値を変更したり取得したりするのに使用できる関数 ``set`` と ``get`` が定義されています。

現在のコントラクトのメンバ（状態変数など）にアクセスする場合、通常は ``this.`` という接頭辞を付けずに、その名前で直接アクセスします。
他のいくつかの言語とは異なり、これを省略することは単なるスタイルの問題ではなく、メンバへのアクセス方法が全く異なるのです。

このコントラクトを使えば、（Ethereumが構築したインフラにより）世界中の誰もがアクセス可能な1つの番号を誰もが保存できます。
その番号の公開を防ぐ現実的な方法はないのです。
ただし、この用途を除けば大したことはできません。
誰もが ``set`` に別の値で再度コールをし、あなたの番号を上書きできますが、元の番号はブロックチェーンの履歴に保存されたままです。
後で、自分だけが番号を変更できるようにアクセス制限をかける方法を見てみましょう。

.. warning::
    Unicodeテキストを使用する際には、見た目が似ている（あるいは同じ）文字でもコードポイントが異なる場合があり、その場合は異なるバイト配列としてエンコードされるので注意が必要です。

.. note::
    すべての識別子（コントラクト名、関数名、変数名）は、ASCII文字に制限されています。
    文字列変数にUTF-8でエンコードされたデータを格納することは可能です。

.. index:: ! subcurrency

サブ通貨の例
============

以下のコントラクトは、最も単純な形の暗号通貨を実装したものです。
このコントラクトでは、作成者のみが新しいコインを作成できます（異なる発行スキームに変えることが可能です）。
誰もがユーザー名とパスワードを登録することなく、Ethereumのキーペアさえあればコインを送り合うことができます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    contract Coin {
        // キーワード「public」は、変数を他のコントラクトからアクセスできるようにします
        address public minter;
        mapping(address => uint) public balances;

        // イベントは、コントラクトの特定の変更にクライアントが反応できるようにします
        event Sent(address from, address to, uint amount);

        // コンストラクタのコードは、コントラクトが作成されるときにのみ実行されます
        constructor() {
            minter = msg.sender;
        }

        // 指定した量のコインを新しく作成して、指定したアドレスの残高に追加します
        // コントラクトの作成者のみが呼び出せます
        function mint(address receiver, uint amount) public {
            require(msg.sender == minter);
            balances[receiver] += amount;
        }

        // エラーは、操作に失敗した理由の情報を提供できます
        // エラーは関数のコール側に返されます
        error InsufficientBalance(uint requested, uint available);

        // コールしてきたアカウントから指定したアドレスに指定した量のコインを送ります
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

今回のコントラクトでは、いくつかの新しい概念が導入されています。
それらを一つずつ見ていきましょう。

``address public minter;`` という行は、 :ref:`address<address>` という型の状態変数を宣言しています。
``address`` 型は160ビットの値で、算術演算を行うことができません。
コントラクトのアドレスや、 :ref:`外部アカウント<accounts>` に属するキーペアの公開鍵のハッシュを格納するのに適しています。

キーワード ``public`` を指定すると、コントラクトの外部から状態変数の現在の値にアクセスできる関数が自動的に生成されます。
このキーワードがないと、他のコントラクトはその変数にアクセスする方法がありません。
コンパイラが生成する関数のコードは以下のようになります（今のところ ``external`` と ``view`` は無視してください）。

.. code-block:: solidity

    function minter() external view returns (address) { return minter; }

上記のような関数を自分で追加することもできはしますが、関数と状態変数が同じ名前になってしまいます。
コンパイラが同じことを代わりにやってくれるので、そのようなことはする必要はありません。

.. index:: mapping

次の行の ``mapping(address => uint) public balances;`` もパブリックな状態変数を作成しますが、より複雑なデータ型です。
この :ref:`mapping <mapping-types>` 型は、アドレスを :ref:`符号なし整数 <integers>` にマッピングします。

マッピングは、考えられるすべてのキーが最初から存在し、バイト表現がすべてゼロである値にマッピングされるように仮想的に初期化された `ハッシュテーブル <https://en.wikipedia.org/wiki/Hash_table>`_ と見なすことができます。
しかし、マッピングのすべてのキーのリストを得ることも、すべての値のリストを得ることもできません。
マッピングに追加したものを記録するか、そのようなことが必要ないコンテキストで使用してください。
あるいは、リストで保持するか、より適切なデータ型を使用することをお勧めします。

``public`` キーワードで作成した :ref:`ゲッター関数<getter-functions>` は、マッピングの場合は複雑です。
次のようになります。

.. code-block:: solidity

    function balances(address account) external view returns (uint) {
        return balances[account];
    }

この関数を使って、ある1つのアカウントの残高を取得できます。

.. index:: event

``event Sent(address from, address to, uint amount);`` という行は、 :ref:`イベント <events>` を宣言しており、このイベントは関数 ``send`` の最後の行で発生します。
WebアプリケーションなどのEthereumクライアントは、ブロックチェーン上で発せられるこれらのイベントを、それほどコストをかけずにリッスンできます。
イベントが発せられると同時に、リスナーは引数の ``from``, ``to``, ``amount`` を受け取るため、トランザクションの追跡が可能になります。

このイベントをリッスンするには、次のJavaScriptコードを使用します。
`web3.js <https://github.com/web3/web3.js/>`_ を使って ``Coin`` のコントラクトオブジェクトを作成し、上記の関数定義から自動生成された ``balances`` 関数を呼び出します:

.. code-block:: javascript

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

:ref:`コンストラクタ<constructor>` は、コントラクトの作成時に実行され、その後は呼び出すことができない特別な関数です。
上記のコントラクトの場合、コントラクトを作成した人のアドレスを永続的に保存します。
``msg`` 変数は（ ``tx`` や ``block`` と一緒に） :ref:`特別なグローバル変数 <special-variables-functions>` であり、ブロックチェーンへのアクセスを可能にするプロパティを含んでいます。
``msg.sender`` は常に、現在の（外部の）関数呼び出しが行われたアドレスです。

コントラクトを構成する関数で、ユーザーやコントラクトが呼び出すことのできるものは、 ``mint`` と ``send`` です。

``mint`` 関数は、指定した量のコインを新しく作成して、指定したアドレスに追加します。
:ref:`require <assert-and-require>` 関数のコールでは、条件を定義し、満たされない場合はすべての変更をリバートします。
この例では、 ``require(msg.sender == minter);`` により、コントラクトの作成者だけが ``mint`` を呼び出せるようになっています。
一般的には、作成者は好きなだけトークンをミントできますが、ある時点で「オーバーフロー」と呼ばれる現象が発生します。
デフォルトの :ref:`算術チェック <unchecked>` により、式 ``balances[receiver] += amount;`` がオーバーフローした場合、つまり、任意精度の算術演算で ``balances[receiver] + amount`` が ``uint`` の最大値（ ``2**256 - 1`` ）よりも大きくなった場合には、トランザクションはリバートしてしまうことに注意してください。
これは、関数 ``send`` の中の ``balances[receiver] += amount;`` という文にも当てはまります。

:ref:`エラー <errors>` を使うと、条件や演算が失敗したときに呼び出し側に詳しい情報を提供できます。
エラーは :ref:`revert文 <revert-statement>` と一緒に使用されます。
``revert`` 文は ``require`` 関数と同様にすべての変更を無条件に中止してリバートさせますが、エラーの名前や、呼び出し側（最終的にはフロントエンドアプリケーションやブロックエクスプローラ）に提供される追加データを提供することもできるので、失敗をデバッグしたり対処したりすることがより簡単にできます。

``send`` 関数は、（すでにコインを持っている人なら）誰でも他の人にコインを送るために使えます。
送金者が送金するのに十分なコインを持っていない場合は、 ``if`` の条件がtrueと評価されます。
結果として、 ``revert`` は操作を失敗させ、送金者には ``InsufficientBalance`` というエラーの詳細を伝えます。

.. note::
    このコントラクトを使ってあるアドレスにコインを送っても、ブロックチェーンエクスプローラではそのアドレスを見ても何もわかりません。
    なぜなら、コインを送ったという記録と変更された残高は、このコインコントラクトのデータストレージにのみ保存されているからです。
    イベントを使えば、新しいコインのトランザクションや残高を追跡する「ブロックチェーンエクスプローラ」を作ることができますが、コインの所有者のアドレスを調べるのではなく、コインコントラクトのアドレスを調べる必要があります。

.. _blockchain-basics:

**********************
ブロックチェーンの基本
**********************

概念としてのブロックチェーンは、プログラマーにとってはそれほど難しいものではありません。
なぜなら、複雑な仕組み（マイニング、 `ハッシュ <https://en.wikipedia.org/wiki/Cryptographic_hash_function>`_ 、 `楕円曲線暗号 <https://en.wikipedia.org/wiki/Elliptic_curve_cryptography>`_ 、 `peer-to-peerネットワーク <https://en.wikipedia.org/wiki/Peer-to-peer>`_ など）のほとんどは、プラットフォームに一定の機能や約束事を提供するために存在しているだけだからです。
これらの機能を当たり前のように受け入れれば、基盤となる技術について心配する必要はありません。
AmazonのAWSを使うためには、内部でどのように機能しているかを知る必要があるでしょうか？

.. index:: transaction

トランザクション
================

ブロックチェーンとは、グローバルに共有されたトランザクション用のデータベースです。
つまり、ネットワークに参加するだけで、誰もがデータベースのエントリーを読むことができるのです。
データベース内の何かを変更したい場合は、いわゆるトランザクションを作成し、他のすべての人に受け入れられなければなりません。
トランザクションという言葉は、あなたが行いたい変更（2つの値を同時に変更したいと仮定）が、全く行われないか、完全に適用されるかのどちらかであることを意味しています。
さらに、あなたのトランザクションがデータベースに実行されている間は、他のトランザクションは干渉できません。

例として、ある電子通貨のすべてのアカウントの残高を一覧にしたテーブルがあるとします。
あるアカウントから別のアカウントへの送金がリクエストされた場合、データベースのトランザクションの性質上、あるアカウントから金額が差し引かれた場合、必ず別のアカウントに追加されます。
何らかの理由で対象となるアカウントに金額を追加できない場合は、元のアカウントも変更されません。

さらに、トランザクションは常に送信者（作成者）によって暗号学的に署名されています。
これにより、データベースの特定の変更に対するアクセスを簡単に保護できます。
電子通貨の例では、簡単なチェックで、アカウントの鍵を持っている人だけがそのアカウントからその通貨を送金できるようになっています。

.. index:: ! block

ブロック
========

克服しなければならない大きな障害のひとつが、ビットコイン用語で「二重支出攻撃」と呼ばれるものです。
ネットワーク上に2つのトランザクションが存在し、どちらもアカウントを空にしようとしていたらどうなるでしょうか？
有効なトランザクションは1つだけで、通常は最初に受け入れられたトランザクションが有効です。
問題は、peer-to-peerネットワークでは「最初」という言葉が客観的ではないことです。

これに対する抽象的な答えは、「気にする必要はない」というものです。
グローバルに決められているトランザクションの順序が選択され、そのコンフリクトを解決してくれます。
トランザクションは「ブロック」と呼ばれるものにまとめられ、実行されて参加しているすべてのノードに分配されることになります。
2つのトランザクションが互いに矛盾する場合、2番目になった方が拒否され、ブロックに含まれません。

これらのブロックは、時間的に直線的な列を形成しており、これが「ブロックチェーン」という言葉の由来となっています。
ブロックは一定の間隔でチェーンに追加されますが、この間隔は将来変更される可能性があります。
最新の情報については、 `Etherscan <https://etherscan.io/chart/blocktime>`_ などでネットワークをモニタリングすることをお勧めします。

「オーダーセレクションメカニズム」（これを「マイニング」と呼びます）の一環として、ブロックが時々リバートされることがありますが、それはチェーンの「端」に限ったことです。
特定のブロックの上にブロックが追加されればされるほど、そのブロックがリバートされる可能性は低くなります。
つまり、あなたのトランザクションがリバートされ、さらにはブロックチェーンから削除されることもあるかもしれませんが、時間が経てば経つほど、その可能性は低くなります。

.. note::

    トランザクションが次のブロックや将来の特定のブロックに含まれることは保証されていません。
    なぜなら、そのトランザクションがどのブロックに含まれるかを決めるのは、トランザクションの提出者ではなく、マイナーに任されているからです。
    コントラクトの将来の呼び出しをスケジュールしたい場合は、 スマートコントラクトの自動化ツールやオラクルサービスを利用できます。

.. _the-ethereum-virtual-machine:

.. index:: !evm, ! ethereum virtual machine

************************
Ethereum Virtual Machine
************************

概要
====

Ethereum Virtual Machine（EVM）は、Ethereumにおけるスマートコントラクトの実行環境です。
EVMはサンドボックス化されているだけでなく、完全に隔離されています。
つまり、EVM内で実行されるコードは、ネットワーク、ファイルシステム、または他のプロセスにアクセスできません。
スマートコントラクトは、他のスマートコントラクトへのアクセスも制限されています。

.. index:: ! account, address, storage, balance

.. _accounts:

アカウント
==========

Ethereumには、同じアドレス空間を共有する2種類のアカウントがあります。
それは、公開鍵と秘密鍵のペア（つまり人間）によって管理される **外部アカウント** と、アカウントと一緒に保存されているコードによって管理される **コントラクトアカウント** です。

外部アカウントのアドレスは公開鍵から決定されますが、コントラクトのアドレスはコントラクトが作成された時点で決定されます（作成者のアドレスとそのアドレスから送信されたトランザクションの数、いわゆる「nonce」から導き出されます）。

アカウントにコードが格納されているかどうかにかかわらず、EVMでは2つの型が同じように扱われます。

すべてのアカウントには、256ビットのワードと256ビットのワードをマッピングする永続的なキーバリューストアがあり、これを **ストレージ** と呼びます。

さらに、すべてのアカウントはEther（正確には「Wei」で、 ``1 ether`` は ``10**18 wei`` ）で **残高** を持っており、Etherを含むトランザクションを送信することで更新されます。

.. index:: ! transaction

トランザクション
================

トランザクションとは、あるアカウントから別のアカウント（同じアカウントの場合もあれば、空のアカウントの場合もある、以下参照）に送信されるメッセージです。
このメッセージには、バイナリデータ（これを「ペイロード」と呼びます）とEtherが含まれます。

対象となるアカウントにコードが含まれている場合、そのコードが実行され、ペイロードが入力データとして提供されます。

対象となるアカウントが設定されていない（トランザクションに受取人がいない、または受取人が「null」に設定されている）場合、そのトランザクションは **新しいコントラクト** を作成します。
すでに述べたように、そのコントラクトのアドレスはゼロのアドレスではなく、送信者とその送信したトランザクション数から得られるアドレス（「nonce」）です。
このようなコントラクト作成トランザクションのペイロードは、EVMバイトコードとみなされ、実行されます。
この実行の出力データは、コントラクトのコードとして永続的に保存されます。
つまり、コントラクトを作成するためには、コントラクトの実際のコードを送信するのではなく、実際には、実行されるとその実際のコードを返すコードを送信することになります。

.. note::
    コントラクトが作成されている間、そのコードはまだ空です。
    そのため、コンストラクタの実行が終了するまで、作成中のコントラクトにコールバックしてはいけません。

.. index:: ! gas, ! gas price

ガス
====

トランザクションの作成時に、各トランザクションには一定量の **ガス** がチャージされ、トランザクションの作成者（ ``tx.origin`` ）が支払う必要があります。
EVMがトランザクションを実行している間、ガスは特定のルールに従って徐々に減っていきます。

いずれかの時点でガスが使い切られると（つまりマイナスになると）、ガス切れの例外が発生して、実行が停止し、現在のコールフレームでステートに加えられたすべての変更がリバートされます。

.. This mechanism incentivizes economical use of EVM execution time and also compensates EVM executors (i.e. miners / stakers) for their work.
.. Since each block has a maximum amount of gas, it also limits the amount of work needed to validate a block.

このメカニズムは、EVMの実行時間の経済的な使用を奨励し、EVMのエグゼキューター（すなわち、マイナーあるいはステーカー）の作業に対する補償を行うものです。
各ブロックには最大量のガスがあるため、ブロックの検証に必要な作業量も制限されます。

.. The **gas price** is a value set by the originator of the transaction, who has to pay ``gas_price * gas`` up front to the EVM executor.
.. If some gas is left after execution, it is refunded to the transaction originator.
.. In case of an exception that reverts changes, already used up gas is not refunded.

**ガスプライス** はトランザクションの作成者が設定する値であり、作成者はEVM実行者に ``gas_price * gas`` を前払いする必要があります。
実行後にガスが残っている場合、それはトランザクションの作成者に返金されます。
変更をリバートする例外が発生した場合、既に使用されたガスは払い戻されません。

.. Since EVM executors can choose to include a transaction or not, transaction senders cannot abuse the system by setting a low gas price.

EVMのエグゼキューターはトランザクションを含めるかどうかを選択できるため、トランザクション送信者は低いガス価格を設定することでシステムを悪用することはできません。

.. index:: ! storage, ! memory, ! stack

ストレージ、メモリ、スタック
============================

Ethereum Virtual Machineには、データを保存できる3つの領域「ストレージ」「メモリ」「スタック」があります。

各アカウントには **ストレージ** と呼ばれるデータ領域があり、関数呼び出しやトランザクション間で永続的に使用されます。
storageは256ビットのワードを256ビットのワードにマッピングするkey-value storeです。
コントラクト内からストレージを列挙できず、読み込みには比較的コストがかかり、ストレージの初期化や変更にはさらにコストがかかります。
このコストのため、永続的なストレージに保存するものは、コントラクトが実行するために必要なものに限定するべきです。
派生する計算、キャッシング、アグリゲートなどのデータはコントラクトの外に保存します。
コントラクトは、コントラクト以外のストレージに対して読み書きできません。

2つ目のデータ領域は **メモリ** と呼ばれ、コントラクトはメッセージを呼び出すたびにクリアされたばかりのインスタンスを取得します。
メモリは線形で、バイトレベルでアドレスを指定できますが、読み出しは256ビットの幅に制限され、書き込みは8ビットまたは256ビットの幅に制限されます。
メモリは、これまで手つかずだったメモリワード（ワード内の任意のオフセット）にアクセス（読み出しまたは書き込み）すると、ワード（256ビット）単位で拡張されます。
拡張時には、ガスによるコストを支払わなければなりません。
メモリは大きくなればなるほどコストが高くなります（二次関数的にスケールする）。

EVMはレジスタマシンではなく、スタックマシンなので、すべての計算は **スタック** と呼ばれるデータ領域で行われます。
スタックの最大サイズは1024要素で、256ビットのワードを含みます。
スタックへのアクセスは次のように上端に制限されています。
一番上の16個の要素の1つをスタックの一番上にコピーしたり、一番上の要素をその下の16個の要素の1つと入れ替えたりすることが可能です。
それ以外の操作では、スタックから最上位の2要素（操作によっては1要素、またはそれ以上）を取り出し、その結果をスタックにプッシュします。
もちろん、スタックの要素をストレージやメモリに移動させて、スタックに深くアクセスすることは可能ですが、最初にスタックの最上部を取り除かずに、スタックの深いところにある任意の要素にアクセスすることはできません。

.. index:: ! instruction

命令セット
==========

EVMの命令セットは、コンセンサスの問題を引き起こす可能性のある不正確な実装や矛盾した実装を避けるために、最小限に抑えられています。
すべての命令は、基本的なデータ型である256ビットのワード、またはメモリのスライス（または他のバイトアレイ）で動作します。
通常の算術演算、ビット演算、論理演算、比較演算が可能です。
条件付きおよび無条件のジャンプが可能です。
さらにコントラクトでは、番号やタイムスタンプなど、現在のブロックの関連プロパティにアクセスできます。

完全なリストについては、インラインアセンブリのドキュメントの一部である :ref:`オペコードの一覧 <opcodes>` を参照してください。

.. index:: ! message call, function;call

メッセージコール
================

コントラクトは、メッセージコールによって、他のコントラクトを呼び出したり、コントラクト以外のアカウントにEtherを送金できます。
メッセージコールは、ソース、ターゲット、データペイロード、Ether、ガス、およびリターンデータを持つという点で、トランザクションと似ています。
実際、すべてのトランザクションは、トップレベルのメッセージコールで構成されており、そのメッセージコールがさらにメッセージコールを作成できます。

コントラクトは、その残りの **ガス** のうち、どれだけを内部メッセージ呼び出しで送信し、どれだけを保持したいかを決定できます。
内側の呼び出しでガス切れの例外（またはその他の例外）が発生した場合は、スタックに置かれたエラー値によって通知されます。
この場合、呼び出しと一緒に送られたガスだけが使い切られます。
Solidityでは、このような状況では、呼び出し側のコントラクトがデフォルトで手動例外を発生させ、例外がコールスタックを「バブルアップ」するようにしています。

すでに述べたように、呼び出されたコントラクト（呼び出し側と同じ場合もある）は、メモリのクリアされたばかりのインスタンスを受け取り、呼び出しペイロード（ **calldata** と呼ばれる別の領域に提供される）にアクセスできます。
実行終了後、呼び出し元のメモリ内で呼び出し元が事前に割り当てた場所に保存されるデータを返すことができます。
このような呼び出しはすべて完全に同期しています。

呼び出しの深さは1024までに **制限** されます。
つまり、より複雑な操作を行う場合には、再帰的な呼び出しよりもループの方が望ましいということです。
さらに、メッセージコールではガスの63/64だけを転送できるため、実際には1000よりも少し少ない深さの制限が発生します。

.. index:: delegatecall, library

delegatecallとライブラリ
========================

メッセージコールには、 **delegatecall** という特別なバリエーションがあります。
これは、ターゲットアドレスのコードが呼び出し元のコントラクトのコンテキスト（すなわち、そのアドレス）で実行され、 ``msg.sender`` と ``msg.value`` の値が変更されないという点を除けば、メッセージコールと同じです。

.. There exists a special variant of a message call, named **delegatecall** which is identical to a message call apart from the fact that the code at the target address is executed in the context (i.e. at the address) of the calling contract and ``msg.sender`` and ``msg.value`` do not change their values.

これは、ターゲットアドレスのコードが呼び出し元のコントラクトのコンテキスト（つまりアドレス）で実行され、 ``msg.sender`` と ``msg.value`` が値を変えないという事実を除けば、メッセージコールと同じである **delegatecall** という特殊なバリエーションが存在します。

これは、コントラクトが実行時に異なるアドレスからコードを動的にロードできることを意味します。
ストレージ、現在のアドレス、バランスは依然として呼び出したコントラクトのものを参照しており、コードだけが呼び出されたアドレスから取得されます。

これにより、Solidityに「ライブラリ」機能を実装することが可能になりました。
再利用可能なライブラリコードで、複雑なデータ構造を実装するためにコントラクトのストレージに適用することなどが可能です。

.. index:: log

ログ
====

ブロックレベルまでマッピングされた特別なインデックス付きのデータ構造にデータを保存することが可能です。
この **ログ** と呼ばれる機能は、Solidityでは :ref:`イベント <events>` を実装するために使用されています。
コントラクトはログデータが作成された後はアクセスできませんが、ブロックチェーンの外部から効率的にアクセスできます。
ログデータの一部は `Bloom Filter <https://en.wikipedia.org/wiki/Bloom_filter>`_ に格納されているため、効率的かつ暗号的に安全な方法でこのデータを検索することが可能であり、ブロックチェーン全体をダウンロードしないネットワークピア（いわゆる「ライトクライアント」）でもこれらのログを見つけることができます。

.. index:: contract creation

create
======

コントラクトは、特別なオペコードを使用して他のコントラクトを作成することもできます（つまり、トランザクションのように単純にゼロアドレスを呼び出すわけではありません）。
これらの **createコール** と通常のメッセージコールとの唯一の違いは、ペイロードデータが実行され、その結果がコードとして保存され、呼び出し側/作成側がスタック上の新しいコントラクトのアドレスを受け取ることです。

.. index:: ! selfdestruct, deactivate

非アクティブ化と自己破壊
========================

ブロックチェーンからコードを削除する唯一の方法は、そのアドレスのコントラクトが ``selfdestruct`` 命令を実行することです。
そのアドレスに保存されている残りのEtherは、指定されたターゲットに送られ、その後、ストレージとコードがステートから削除されます。
理論的にはコントラクトを削除することは良いアイデアのように聞こえますが、削除されたコントラクトに誰かがEtherを送ると、そのEtherは永遠に失われてしまうため、潜在的には危険です。

.. warning::
    .. From version 0.8.18 and up, the use of ``selfdestruct`` in both Solidity and Yul will trigger a deprecation warning, since the ``SELFDESTRUCT`` opcode will eventually undergo breaking changes in behavior as stated in `EIP-6049 <https://eips.ethereum.org/EIPS/eip-6049>`_.

    バージョン 0.8.18 以降、Solidity と Yul の両方で ``selfdestruct`` を使用すると、 `EIP-6049 <https://eips.ethereum.org/EIPS/eip-6049>`_ で述べられているように、 ``SELFDESTRUCT`` オペコードがいずれ動作に破壊的変更を受けるため、非推奨の警告が発せられます。

.. warning::
    ``selfdestruct`` によってコントラクトが削除されたとしても、それはブロックチェーンの歴史の一部であり、おそらくほとんどのEthereumノードが保持しています。
    そのため、 ``selfdestruct`` を使うことは、ハードディスクからデータを削除することと同じではありません。

.. note::
    コントラクトのコードに ``selfdestruct`` の呼び出しが含まれていなくても、 ``delegatecall`` や ``callcode`` を使ってその操作を行うことができます。

コントラクトを非アクティブ化したい場合、すべての関数をリバートするように内部状態を変更することで実現できます。
これにより、コントラクトは即座にEtherを返すようになるため、使用できなくなります。

.. index:: ! precompiled contracts, ! precompiles, ! contract;precompiled

.. _precompiledContracts:

プリコンパイル済みコントラクト
==============================

コントラクトのアドレスの中には、特別なものがあります。
``1`` から ``8`` までのアドレスには「プリコンパイル済みコントラクト」が含まれており、他のコントラクトと同様に呼び出すことができますが、その動作（およびガス消費量）は、そのアドレスに格納されているEVMコードによって定義されるのではなく（コードが含まれていない）、EVMの実行環境自体に実装されています。

EVMと互換性のあるチェーンでは、異なるプリコンパイル済みコントラクトのセットを使用する可能性があります。
また、将来Ethereumのメインチェーンに新しいプリコンパイル済みコントラクトが追加される可能性もありますが、常に ``1`` から ``0xffff`` （包括的）の範囲内であると考えるのが妥当でしょう。
