.. index:: ! contract;abstract, ! abstract contract

.. _abstract-contract:

****************
抽象コントラクト
****************

<<<<<<< HEAD
コントラクトは、その関数の少なくとも1つが実装されていない場合、抽象的であることを示す必要があります。
すべての関数が実装されていても、コントラクトは抽象的であるとマークできます。

これは、次の例のように ``abstract`` キーワードを使うことで可能です。
関数 ``utterance()`` は定義されているが、実装が提供されていない（実装体 ``{ }`` が与えられていない）ため、このコントラクトはabstractと定義する必要があることに注意してください。
=======
Contracts must be marked as abstract when at least one of their functions is not implemented or when
they do not provide arguments for all of their base contract constructors.
Even if this is not the case, a contract may still be marked abstract, such as when you do not intend
for the contract to be created directly. Abstract contracts are similar to :ref:`interfaces` but an
interface is more limited in what it can declare.

An abstract contract is declared using the ``abstract`` keyword as shown in the following example.
Note that this contract needs to be defined as abstract, because the function ``utterance()`` is declared,
but no implementation was provided (no implementation body ``{ }`` was given).
>>>>>>> english/develop

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    abstract contract Feline {
        function utterance() public virtual returns (bytes32);
    }

.. Such abstract contracts can not be instantiated directly. This is also true, if an abstract contract itself does implement
.. all defined functions. The usage of an abstract contract as a base class is shown in the following example:

このような抽象コントラクトは、直接インスタンス化できません。
これは、抽象コントラクト自体がすべての定義された関数を実装している場合にも当てはまります。
ベースクラスとしての抽象コントラクトの使い方を以下の例で示します。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    abstract contract Feline {
        function utterance() public pure virtual returns (bytes32);
    }

    contract Cat is Feline {
        function utterance() public pure override returns (bytes32) { return "miaow"; }
    }

コントラクトが抽象コントラクトを継承し、オーバーライドによって未実装関数を全て実装していない場合は、抽象としてマークする必要があります。

.. Note that a function without implementation is different from
.. a :ref:`Function Type <function_types>` even though their syntax looks very similar.

なお、実装のない関数は、構文がよく似ていても、 :ref:`関数型 <function_types>` とは異なるものです。

実装のない関数（関数宣言）の例:

.. code-block:: solidity

    function foo(address) external returns (address);

型が関数型である変数の宣言の例:

.. code-block:: solidity

    function(address) external returns (address) foo;

.. Abstract contracts decouple the definition of a contract from its
.. implementation providing better extensibility and self-documentation and
.. facilitating patterns like the `Template method <https://en.wikipedia.org/wiki/Template_method_pattern>`_ and removing code duplication.
.. Abstract contracts are useful in the same way that defining methods
.. in an interface is useful. It is a way for the designer of the
.. abstract contract to say "any child of mine must implement this method".

抽象コントラクトは、コントラクトの定義とその実装を切り離し、より良い拡張性と自己文書化を提供し、 `テンプレートメソッド <https://en.wikipedia.org/wiki/Template_method_pattern>`_ のようなパターンを促進し、コードの重複を取り除きます。
抽象コントラクトは、インターフェースでメソッドを定義することが有用であるのと同じ方法で有用です。
抽象コントラクトの設計者が「私の子供はこのメソッドを実装しなければならない」と言える方法です。

.. note::

    抽象コントラクトは、実装済みの仮想関数を未実装の仮想関数で上書きできません。
