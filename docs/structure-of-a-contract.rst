.. index:: contract, state variable, function, event, struct, enum, function;modifier

.. _contract_structure:

***********************
コントラクトの構造
***********************

Solidityのコントラクトは、オブジェクト指向言語のクラスに似ています。各コントラクトは、 :ref:`structure-state-variables` 、 :ref:`structure-functions` 、 :ref:`structure-function-modifiers` 、 :ref:`structure-events` 、 :ref:`structure-errors` 、 :ref:`structure-struct-types` 、 :ref:`structure-enum-types` の宣言を含むことができます。さらに、コントラクトは他のコントラクトを継承できます。

また、 :ref:`ライブラリ<libraries>` や :ref:`インターフェース<interfaces>` と呼ばれる特別な種類のコントラクトもあります。

:ref:`コントラクト<contracts>` のセクションには、このセクションよりも詳細な情報が記載されており、概要を説明するための役割を担っています。

.. _structure-state-variables:

ステート変数
===============

ステート変数は、コントラクトストレージに値が永続的に保存される変数です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract SimpleStorage {
        uint storedData; // ステート変数
        // ...
    }

有効なステート変数の型については :ref:`types` セクションを、可視性についての可能な選択肢については :ref:`visibility-and-getters` を参照してください。

.. _structure-functions:

関数
=========

関数は、実行可能なコードの単位です。関数は通常、コントラクトの中で定義されますが、コントラクトの外で定義することもできます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.1 <0.9.0;

    contract SimpleAuction {
        function bid() public payable { // 関数
            // ...
        }
    }

    // コントラクトの外で定義されたヘルパー関数
    function helper(uint x) pure returns (uint) {
        return x * 2;
    }

:ref:`function-calls` は内部または外部で起こり、他のコントラクトに対して異なるレベルの :ref:`可視性<visibility-and-getters>` を持つことができます。
:ref:`関数<functions>` は、それらの間でパラメータと値を渡すために :ref:`パラメータと返り値<function-parameters-return-variables>` を受け入れます。

.. _structure-function-modifiers:

関数修飾子
==================

関数修飾子を使うと、宣言的に関数のセマンティクスを変更できます（コントラクトセクションの :ref:`modifiers` を参照）。

オーバーロード、つまり、同じ修飾子名で異なるパラメータを持つことはできません。

関数と同様、修飾子も :ref:`overridden <modifier-overriding>` にできます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.22 <0.9.0;

    contract Purchase {
        address public seller;

        modifier onlySeller() { // 修飾子
            require(
                msg.sender == seller,
                "Only seller can call this."
            );
            _;
        }

        function abort() public view onlySeller { // 修飾子の使用
            // ...
        }
    }

.. _structure-events:

イベント
========

イベントは、EVMのログ機能を使った便利なインターフェースです。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.21 <0.9.0;

    contract SimpleAuction {
        event HighestBidIncreased(address bidder, uint amount); // イベント

        function bid() public payable {
            // ...
            emit HighestBidIncreased(msg.sender, msg.value); // イベントのトリガー
        }
    }

イベントがどのように宣言され、dapp内でどのように使用されるかについては、コントラクトセクションの :ref:`events` を参照してください。

.. _structure-errors:

エラー
======

エラーは障害が発生したときの記述的な名前とデータを定義できます。
エラーは :ref:`リバート文<revert-statement>` で使用できます。
文字列による説明に比べて、エラーははるかに安価で、追加データをエンコードできます。NatSpecを使って、ユーザーにエラーを説明できます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    // 送金資金の不足。要求したのは`requested`だが、利用可能なのは`available`だけ。
    error NotEnoughFunds(uint requested, uint available);

    contract Token {
        mapping(address => uint) balances;
        function transfer(address to, uint amount) public {
            uint balance = balances[msg.sender];
            if (balance < amount)
                revert NotEnoughFunds(amount, balance);
            balances[msg.sender] -= amount;
            balances[to] += amount;
            // ...
        }
    }

詳しくは、コントラクト編の :ref:`errors` をご覧ください。

.. _structure-struct-types:

構造体型
=============

構造体（struct）は、複数の変数をグループ化できるカスタム定義の型です（型の項の :ref:`structs` を参照）。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract Ballot {
        struct Voter { // 構造体
            uint weight;
            bool voted;
            address delegate;
            uint vote;
        }
    }

.. _structure-enum-types:

列挙型
==========

列挙（enum）は、有限の「定数値」を持つカスタム型を作成するために使用できます（型の項の :ref:`enums` を参照）。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract Purchase {
        enum State { Created, Locked, Inactive } // 列挙
    }

