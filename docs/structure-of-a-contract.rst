.. index:: contract, state variable, function, event, struct, enum, function;modifier

.. _contract_structure:

***********************
Structure of a Contract
***********************

.. Contracts in Solidity are similar to classes in object-oriented languages.
.. Each contract can contain declarations of :ref:`structure-state-variables`, :ref:`structure-functions`,
.. :ref:`structure-function-modifiers`, :ref:`structure-events`, :ref:`structure-errors`, :ref:`structure-struct-types` and :ref:`structure-enum-types`.
.. Furthermore, contracts can inherit from other contracts.

Solidityのコントラクトは、オブジェクト指向言語のクラスに似ています。各コントラクトは、 :ref:`structure-state-variables` 、 :ref:`structure-functions` 、 :ref:`structure-function-modifiers` 、 :ref:`structure-events` 、 :ref:`structure-errors` 、 :ref:`structure-struct-types` 、 :ref:`structure-enum-types` の宣言を含むことができます。さらに、コントラクトは他のコントラクトを継承できます。

.. There are also special kinds of contracts called :ref:`libraries<libraries>` and :ref:`interfaces<interfaces>`.

また、 :ref:`libraries<libraries>` や :ref:`interfaces<interfaces>` と呼ばれる特別な種類のコントラクトもあります。

.. The section about :ref:`contracts<contracts>` contains more details than this section,
.. which serves to provide a quick overview.

:ref:`contracts<contracts>` についてのセクションには、このセクションよりも詳細な情報が記載されていますが、これは概要を説明するためのものです。

.. _structure-state-variables:

State Variables
===============

.. State variables are variables whose values are permanently stored in contract
.. storage.

State変数は、コントラクトストレージに値が永続的に保存される変数です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract SimpleStorage {
        uint storedData; // State variable
        // ...
    }

.. See the :ref:`types` section for valid state variable types and
.. :ref:`visibility-and-getters` for possible choices for
.. visibility.

有効なステート変数のタイプについては :ref:`types` セクションを、可視性についての可能な選択肢については :ref:`visibility-and-getters` を参照してください。

.. _structure-functions:

Functions
=========

.. Functions are the executable units of code. Functions are usually
.. defined inside a contract, but they can also be defined outside of
.. contracts.

関数は、実行可能なコードの単位です。関数は通常、コントラクトの中で定義されますが、コントラクトの外で定義することもできます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.1 <0.9.0;

    contract SimpleAuction {
        function bid() public payable { // Function
            // ...
        }
    }

    // Helper function defined outside of a contract
    function helper(uint x) pure returns (uint) {
        return x * 2;
    }

.. :ref:`function-calls` can happen internally or externally
.. and have different levels of :ref:`visibility<visibility-and-getters>`
.. towards other contracts. :ref:`Functions<functions>` accept :ref:`parameters and return variables<function-parameters-return-variables>` to pass parameters
.. and values between them.

:ref:`function-calls` は内部または外部で起こり、他のコントラクトに対する :ref:`visibility<visibility-and-getters>` のレベルが異なる。 :ref:`Functions<functions>` は、それらの間でパラメータと値を渡すために :ref:`parameters and return variables<function-parameters-return-variables>` を受け入れる。

.. _structure-function-modifiers:

Function Modifiers
==================

.. Function modifiers can be used to amend the semantics of functions in a declarative way
.. (see :ref:`modifiers` in the contracts section).

関数修飾子を使うと、宣言的に関数のセマンティクスを変更できます（コントラクトセクションの :ref:`modifiers` を参照）。

.. Overloading, that is, having the same modifier name with different parameters,
.. is not possible.

オーバーロード、つまり、同じモディファイア名で異なるパラメータを持つことはできません。

.. Like functions, modifiers can be :ref:`overridden <modifier-overriding>`.

関数と同様、修飾子も :ref:`overridden <modifier-overriding>` にできます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.22 <0.9.0;

    contract Purchase {
        address public seller;

        modifier onlySeller() { // Modifier
            require(
                msg.sender == seller,
                "Only seller can call this."
            );
            _;
        }

        function abort() public view onlySeller { // Modifier usage
            // ...
        }
    }

.. _structure-events:

Events
======

.. Events are convenience interfaces with the EVM logging facilities.

イベントは、EVMのログ機能を使った便利なインターフェースです。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.21 <0.9.0;

    contract SimpleAuction {
        event HighestBidIncreased(address bidder, uint amount); // Event

        function bid() public payable {
            // ...
            emit HighestBidIncreased(msg.sender, msg.value); // Triggering event
        }
    }

.. See :ref:`events` in contracts section for information on how events are declared
.. and can be used from within a dapp.

イベントがどのように宣言され、dapp内でどのように使用されるかについては、コントラクトセクションの :ref:`events` を参照してください。

.. _structure-errors:

Errors
======

.. Errors allow you to define descriptive names and data for failure situations.
.. Errors can be used in :ref:`revert statements <revert-statement>`.
.. In comparison to string descriptions, errors are much cheaper and allow you
.. to encode additional data. You can use NatSpec to describe the error to
.. the user.

エラーでは、障害が発生したときの記述的な名前とデータを定義できます。エラーは :ref:`revert statements <revert-statement>` で使用できます。文字列による説明に比べて、エラーははるかに安価で、追加データをエンコードできます。NatSpecを使って、ユーザーにエラーを説明できます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    /// Not enough funds for transfer. Requested `requested`,
    /// but only `available` available.
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

.. See :ref:`errors` in the contracts section for more information.

詳しくは、コントラクト編の :ref:`errors` をご覧ください。

.. _structure-struct-types:

Struct Types
=============

.. Structs are custom defined types that can group several variables (see
.. :ref:`structs` in types section).

ストラクチャは、複数の変数をグループ化できるカスタム定義の型です（型の項の :ref:`structs` を参照）。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract Ballot {
        struct Voter { // Struct
            uint weight;
            bool voted;
            address delegate;
            uint vote;
        }
    }

.. _structure-enum-types:

Enum Types
==========

.. Enums can be used to create custom types with a finite set of 'constant values' (see
.. :ref:`enums` in types section).

Enumは、有限の「定数値」を持つカスタムタイプを作成するために使用できます（タイプの項の :ref:`enums` を参照）。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract Purchase {
        enum State { Created, Locked, Inactive } // Enum
    }

