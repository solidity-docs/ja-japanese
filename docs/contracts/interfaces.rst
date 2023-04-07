.. index:: ! contract;interface, ! interface contract

.. _interfaces:

****************
インターフェース
****************

インターフェースは、抽象的なコントラクトと似ていますが、いかなる関数も実装できません。
さらに以下の制限があります。

- 他のコントラクトを継承できませんが、他のインターフェースを継承できます。
- 宣言された関数は、コントラクトでpublicであっても、インターフェースではexternalでなければなりません。
- コンストラクタを宣言できません。
- 状態変数を宣言できません。
- モディファイアを宣言できません。

これらの制限の一部は、将来解除される可能性があります。

インターフェースは基本的にコントラクトABIが表現できる内容に限定されており、ABIとインターフェースの間の変換は情報を失うことなく可能でなければなりません。

インターフェースは、次のように定義されます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.2 <0.9.0;

    interface Token {
        enum TokenType { Fungible, NonFungible }
        struct Coin { string obverse; string reverse; }
        function transfer(address recipient, uint amount) external;
    }

コントラクトは、他のコントラクトを継承するように、インターフェースを継承できます。

.. All functions declared in interfaces are implicitly ``virtual`` and any
.. functions that override them do not need the ``override`` keyword.
.. This does not automatically mean that an overriding function can be overridden again -
.. this is only possible if the overriding function is marked ``virtual``.

インターフェースで宣言されたすべての関数は暗黙のうちに ``virtual`` となり、それをオーバーライドする関数には ``override`` キーワードは必要ありません。
これは、オーバーライドされた関数が再びオーバーライドできることを自動的に意味するものではありません。
オーバーライドされた関数が ``virtual`` とマークされている場合にのみ、それは可能です。

インターフェースは、他のインターフェースを継承できます。
これには通常の継承と同じルールがあります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.2 <0.9.0;

    interface ParentA {
        function test() external returns (uint256);
    }

    interface ParentB {
        function test() external returns (uint256);
    }

    interface SubInterface is ParentA, ParentB {
        // Parentと互換性があることを主張するために、testを再定義する必要があります。
        function test() external override(ParentA, ParentB) returns (uint256);
    }

.. Types defined inside interfaces and other contract-like structures
.. can be accessed from other contracts: ``Token.TokenType`` or ``Token.Coin``.

インターフェースや他のコントラクトに似た構造の中で定義された型は、他のコントラクトからアクセスできます。
``Token.TokenType`` または ``Token.Coin`` 。

.. warning:

    Interfaces have supported ``enum`` types since :doc:`Solidity version 0.5.0 <050-breaking-changes>`, make
    sure the pragma version specifies this version as a minimum.

