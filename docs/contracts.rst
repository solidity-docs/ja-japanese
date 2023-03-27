.. index:: ! contract

.. _contracts:

############
コントラクト
############

.. Contracts in Solidity are similar to classes in object-oriented languages. They
.. contain persistent data in state variables, and functions that can modify these
.. variables. Calling a function on a different contract (instance) will perform
.. an EVM function call and thus switch the context such that state variables
.. in the calling contract are
.. inaccessible. A contract and its functions need to be called for anything to happen.
.. There is no "cron" concept in Ethereum to call a function at a particular event automatically.

Solidityのコントラクトは、オブジェクト指向言語のクラスに似ています。
コントラクトには、状態変数に格納された永続的なデータと、これらの変数を変更できる関数が含まれています。
別のコントラクト（インスタンス）の関数を呼び出すと、EVM関数呼び出しが実行され、呼び出したコントラクトの状態変数にアクセスできないようにコンテキストが切り替わります。
コントラクトとその関数は、何かが起こるために呼び出される必要があります。
Ethereumには、特定のイベントで自動的に関数を呼び出す「cron」の概念はありません。

.. include:: contracts/creating-contracts.rst

.. include:: contracts/visibility-and-getters.rst

.. include:: contracts/function-modifiers.rst

.. include:: contracts/constant-state-variables.rst
.. include:: contracts/functions.rst

.. include:: contracts/events.rst
.. include:: contracts/errors.rst

.. include:: contracts/inheritance.rst

.. include:: contracts/abstract-contracts.rst
.. include:: contracts/interfaces.rst

.. include:: contracts/libraries.rst

.. include:: contracts/using-for.rst
