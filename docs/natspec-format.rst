.. _natspec:

###################
NatSpecフォーマット
###################

Solidityコントラクトでは、特別な形式のコメントを使用して、関数や返り値の変数などに対してリッチなドキュメントを提供できます。
この特別な形式は、Ethereum Natural Language Specification Format (NatSpec)と名付けられています。

.. note::

  NatSpecは `Doxygen <https://en.wikipedia.org/wiki/Doxygen>`_ に触発されて作られました。
  Doxygenスタイルのコメントとタグを使用していますが、Doxygenとの厳密な互換性を維持する意図はありません。
  下記にリストされているサポートされているタグをよく確認してください。

NatSpecのドキュメントは、開発者向けのメッセージと、エンドユーザー向けのメッセージに分けられます。
これらのメッセージは、エンドユーザー（人間）がコントラクトと対話する（すなわち、トランザクションに署名する）際に表示されることがあります。

Solidityのコントラクトは、全てのパブリックインターフェース（ABIにある全て）に対してNatSpecを使用して完全にアノテーションすることが推奨されます。

.. NatSpec includes the formatting for comments that the smart contract author will use, and which are understood by the Solidity compiler.
.. Also detailed below is output of the Solidity compiler, which extracts these comments into a machine-readable format.

NatSpecには、スマートコントラクトの作成者が使用し、Solidityのコンパイラが理解するコメントのフォーマットが含まれています。
また、これらのコメントを機械で読める形式に抽出するSolidityコンパイラの出力も以下に示します。

.. These are most likely accomplished via the ``@custom:<name>`` tag, and a good use case is analysis and verification tools.

NatSpecには、サードパーティのツールが使用するアノテーションが含まれることもあります。
これらは ``@custom:<name>`` タグを介して実現されることが多く、例えば、解析・検証ツールが使用しています。

.. _header-doc-example:

ドキュメントの例
================

.. Documentation is inserted above each ``contract``, ``interface``, ``library``, ``function``, and ``event`` using the Doxygen notation format.
.. A ``public`` state variable is equivalent to a ``function`` for the purposes of NatSpec.

ドキュメントは、Doxygen記法のフォーマットを使用して、各 ``contract`` 、 ``interface`` 、 ``library`` 、 ``function`` 、 ``event`` の上に挿入されます。
``public`` の状態変数は、NatSpecの目的上、 ``function`` と同等です。

- Solidityでは、1行のコメントに ``///`` を、複数行のコメントに ``/**`` から始めて ``*/`` で終わるものを使えます。
- Vyperでは、 ``"""`` を内側のコンテンツにインデントして、コメントをむき出しにして使います。
  詳しくは `Vyperのドキュメント <https://docs.vyperlang.org/en/latest/natspec.html>`_ を参照してください。

.. The following example shows a contract and a function using all available tags.

次の例は、利用可能なすべてのタグを使ったコントラクトと関数です。

.. note::

  Solidityのコンパイラは、タグがexternalまたはpublicの場合のみ解釈します。
  internal関数やprivate関数に同様のコメントを使用することは可能ですが、それらはパースされません。

  これは将来的に変更される可能性があります。

.. code-block:: Solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.2 < 0.9.0;

    /// @title A simulator for trees
    /// @author Larry A. Gardner
    /// @notice You can use this contract for only the most basic simulation
    /// @dev All function calls are currently implemented without side effects
    /// @custom:experimental This is an experimental contract.
    contract Tree {
        /// @notice Calculate tree age in years, rounded up, for live trees
        /// @dev The Alexandr N. Tetearing algorithm could increase precision
        /// @param rings The number of rings from dendrochronological sample
        /// @return Age in years, rounded up for partial years
        function age(uint256 rings) external virtual pure returns (uint256) {
            return rings + 1;
        }

        /// @notice Returns the amount of leaves the tree has.
        /// @dev Returns only a fixed number.
        function leaves() external virtual pure returns(uint256) {
            return 2;
        }
    }

    contract Plant {
        function leaves() external virtual pure returns(uint256) {
            return 3;
        }
    }

    contract KumquatTree is Tree, Plant {
        function age(uint256 rings) external override pure returns (uint256) {
            return rings + 2;
        }

        /// Return the amount of leaves that this specific kind of tree has
        /// @inheritdoc Tree
        function leaves() external override(Tree, Plant) pure returns(uint256) {
            return 3;
        }
    }

.. _header-tags:

タグ
====

すべてのタグはオプションです。
次の表では、各NatSpecタグの目的と使用される場所を説明しています。
特別なケースとして、タグが使用されていない場合、Solidityのコンパイラは ``///`` または ``/**`` のコメントを ``@notice`` のタグが付いている場合と同じように解釈します。

================= ============================================================================================ =============================
タグ                                                                                                           コンテキスト 
================= ============================================================================================ =============================
``@title``        コントラクトあるいはインターフェースを説明すべき名前                                         contract, library, interface
``@author``       オーサーの名前                                                                               contract, library, interface
``@notice``       これがどういうことを行うのか、エンドユーザー向けの説明                                       contract, library, interface, function, public state variable, event
``@dev``          開発者向けの追加の説明                                                                       contract, library, interface, function, state variable, event
``@param``        Doxygenのようなパラメータの説明（後ろにパラメータ名をつける必要がある）                      function, event
``@return``       コントラクトの関数のリターン変数の説明                                                       function, public state variable
``@inheritdoc``   ベース関数から不足しているタグを全てコピーする（後ろにコントラクト名を必要がある）           function, public state variable
``@custom:...``   カスタムタグ、セマンティクスはアプリケーションで定義                                         everywhere
================= ============================================================================================ =============================

``(int quotient, int remainder)`` のように関数が複数の値を返す場合は、 ``@param`` 文と同じ形式で複数の ``@return`` 文を使用します。

.. They can be used everywhere and are part of the developer documentation.

カスタムタグは ``@custom:`` で始まり、その後に1つ以上の小文字またはハイフンを付ける必要があります。
ただし、ハイフンで始まることはできません。
カスタムタグは、あらゆる場所で使用でき、開発者向けドキュメントの一部となります。

.. _header-dynamic:

.. Dynamic expressions

動的表現
--------

Solidityコンパイラは、SolidityソースコードからNatSpecドキュメントを経て、このガイドに記載されているJSON出力に変換します。
このJSON出力の使用者（エンドユーザーのクライアントソフトウェアなど）は、その出力をエンドユーザーに直接提示する場合もあれば、何らかの前処理を施す場合もあります。

例えば、一部のクライアントソフトではレンダリングを行います。

.. code:: Solidity

   /// @notice This function will multiply `a` by 7

このドキュメントは、関数が呼び出され入力 ``a`` に 10 が割り当てられている場合、次のようにエンドユーザーに提供されるかもしれません。

.. code:: text

    This function will multiply 10 by 7

.. Specifying these dynamic expressions is outside the scope of the Solidity
.. documentation and you may read more at `the radspec project <https://github.com/aragon/radspec>`__.

.. _header-inheritance:

継承に関する注意事項
--------------------

NatSpecを持たない関数は、そのベースとなる関数のドキュメントを自動的に継承します。この例外として次の場合があります。

* パラメータ名が異なる場合。
* 複数のベース関数がある場合。
* どのコントラクトを継承すべきを指定する明示的な ``@inheritdoc`` タグがある場合。

.. _header-output:

ドキュメントの出力
==================

.. When parsed by the compiler, documentation such as the one from the above example will produce two different JSON files.
.. One is meant to be consumed by the end user as a notice when a function is executed and the other to be used by the developer.

上記の例のようなドキュメントは、コンパイラによって解析されると、2つの異なるJSONファイルが生成されます。
1つはエンドユーザーが関数実行時の通知として使用するもので、もう1つは開発者が使用するものです。

上記のコントラクトが ``ex1.sol`` として保存されていれば、以下の方法でドキュメントを作成できます。

.. code-block:: shell

   solc --userdoc --devdoc ex1.sol

出力は以下のようになります。

.. .. note::

..     Starting Solidity version 0.6.11 the NatSpec output also contains a ``version`` and a ``kind`` field.
..     Currently the ``version`` is set to ``1`` and ``kind`` must be one of ``user`` or ``dev``.
..     In the future it is possible that new versions will be introduced, deprecating older ones.

.. note::

    Solidityバージョン0.6.11以降、NatSpec出力には ``version`` と ``kind`` フィールドが含まれています。
    現在、 ``version`` は ``1`` に設定されており、 ``kind`` は ``user`` または ``dev`` のいずれかでなければなりません。
    将来的には、新しいバージョンが導入され、古いバージョンが廃止される可能性があります。

.. _header-user-doc:

ユーザードキュメント
--------------------

上記のドキュメントでは、以下のようなユーザードキュメントのJSONファイルが出力されます。

.. code-block:: json

    {
      "version" : 1,
      "kind" : "user",
      "methods" :
      {
        "age(uint256)" :
        {
          "notice" : "Calculate tree age in years, rounded up, for live trees"
        }
      },
      "notice" : "You can use this contract for only the most basic simulation"
    }

.. Note that the key by which to find the methods is the function's canonical signature as defined in the :ref:`Contract ABI <abi_function_selector>` and not simply the function's name.

なお、メソッドを見つけるためのキーは、単に関数名ではなく、 :ref:`コントラクトABI <abi_function_selector>` で定義された関数の正規の署名であることに注意してください。

.. _header-developer-doc:

開発者ドキュメント
------------------

.. Apart from the user documentation file, a developer documentation JSON file should also be produced and should look like this:

ユーザードキュメントファイルとは別に、開発者ドキュメントのJSONファイルも作成する必要があり、以下のような内容になります。

.. code-block:: json

    {
      "version" : 1,
      "kind" : "dev",
      "author" : "Larry A. Gardner",
      "details" : "All function calls are currently implemented without side effects",
      "custom:experimental" : "This is an experimental contract.",
      "methods" :
      {
        "age(uint256)" :
        {
          "details" : "The Alexandr N. Tetearing algorithm could increase precision",
          "params" :
          {
            "rings" : "The number of rings from dendrochronological sample"
          },
          "return" : "age in years, rounded up for partial years"
        }
      },
      "title" : "A simulator for trees"
    }
