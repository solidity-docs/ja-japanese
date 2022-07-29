.. _natspec:

##############
NatSpec Format
##############

.. Solidity contracts can use a special form of comments to provide rich
.. documentation for functions, return variables and more. This special form is
.. named the Ethereum Natural Language Specification Format (NatSpec).

Solidityコントラクトでは、コメントの特別な形式を使用して、関数やリターン変数などのリッチなドキュメントを提供できます。この特別な形式は、Ethereum Natural Language Specification Format (NatSpec)と名付けられています。

.. .. note::

..   NatSpec was inspired by `Doxygen <https://en.wikipedia.org/wiki/Doxygen>`_.
..   While it uses Doxygen-style comments and tags, there is no intention to keep
..   strict compatibility with Doxygen. Please carefully examine the supported tags
..   listed below.

.. note::

  NatSpecは `Doxygen <https://en.wikipedia.org/wiki/Doxygen>`_ に触発されて作られました。   Doxygenスタイルのコメントとタグを使用していますが、Doxygenとの厳密な互換性を維持する意図はありません。下記のサポートされているタグをよくご確認ください。

.. This documentation is segmented into developer-focused messages and end-user-facing
.. messages. These messages may be shown to the end user (the human) at the
.. time that they will interact with the contract (i.e. sign a transaction).

このドキュメントは、開発者向けのメッセージと、エンドユーザー向けのメッセージに分けられます。これらのメッセージは、エンドユーザー（人間）がコントラクトと対話する（すなわち、トランザクションに署名する）際に表示されることがあります。

.. It is recommended that Solidity contracts are fully annotated using NatSpec for
.. all public interfaces (everything in the ABI).

Solidityのコントラクトは、すべてのパブリック・インターフェース（ABI内のすべて）に対してNatSpecを使用して完全にアノテーションすることが推奨されます。

.. NatSpec includes the formatting for comments that the smart contract author will
.. use, and which are understood by the Solidity compiler. Also detailed below is
.. output of the Solidity compiler, which extracts these comments into a machine-readable
.. format.

NatSpecには、スマートコントラクトの作成者が使用し、Solidityのコンパイラが理解するコメントのフォーマットが含まれています。また、これらのコメントを機械で読める形式に抽出するSolidityコンパイラの出力も以下に示します。

.. NatSpec may also include annotations used by third-party tools. These are most likely
.. accomplished via the ``@custom:<name>`` tag, and a good use case is analysis and verification
.. tools.

NatSpecには、サードパーティのツールが使用するアノテーションが含まれることもあります。これらは ``@custom:<name>`` タグを介して実現されることが多く、解析・検証ツールが良い使用例となります。

.. _header-doc-example:

Documentation Example
=====================

<<<<<<< HEAD
.. Documentation is inserted above each ``contract``, ``interface``,
.. ``function``, and ``event`` using the Doxygen notation format.
.. A ``public`` state variable is equivalent to a ``function``
.. for the purposes of NatSpec.
=======
Documentation is inserted above each ``contract``, ``interface``, ``library``,
``function``, and ``event`` using the Doxygen notation format.
A ``public`` state variable is equivalent to a ``function``
for the purposes of NatSpec.
>>>>>>> d5a78b18b3fd9e54b2839e9685127c6cdbddf614

ドキュメントは、Doxygen記法のフォーマットを使用して、各 ``contract`` 、 ``interface`` 、 ``function`` 、 ``event`` の上に挿入されます。 ``public`` 状態変数は、NatSpecの目的上、 ``function`` と同等です。

.. - For Solidity you may choose ``///`` for single or multi-line
..    comments, or ``/**`` and ending with ``*/``.

- Solidityでは、1行または複数行のコメントに ``///`` を、または ``/**`` を選択し、最後に ``*/`` を選択できます。

.. - For Vyper, use ``"""`` indented to the inner contents with bare
..    comments. See the `Vyper
..    documentation <https://vyper.readthedocs.io/en/latest/natspec.html>`__.

- Vyperの場合は、 ``"""`` を内側のコンテンツにインデントして、コメントをむき出しにして使います。 `Vyper    documentation <https://vyper.readthedocs.io/en/latest/natspec.html>`_ _を参照してください。

.. The following example shows a contract and a function using all available tags.

次の例では、利用可能なすべてのタグを使って、コントラクトとファンクションを表示しています。

.. .. note::

..   The Solidity compiler only interprets tags if they are external or
..   public. You are welcome to use similar comments for your internal and
..   private functions, but those will not be parsed.

..   This may change in the future.

.. note::

  Solidityのコンパイラは、タグがexternalまたはpublicの場合のみ解釈します。内部関数やプライベート関数に同様のコメントを使用することは可能ですが、それらは解析されません。

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

Tags
====

.. All tags are optional. The following table explains the purpose of each
.. NatSpec tag and where it may be used. As a special case, if no tags are
.. used then the Solidity compiler will interpret a ``///`` or ``/**`` comment
.. in the same way as if it were tagged with ``@notice``.

すべてのタグはオプションです。次の表では、各NatSpecタグの目的と使用される場所を説明しています。特別なケースとして、タグが使用されていない場合、Solidityのコンパイラは ``///`` または ``/**`` のコメントを ``@notice`` のタグが付いている場合と同じように解釈します。

=============== ====================================================================================== =============================
Tag                                                                                                    Context
=============== ====================================================================================== =============================
``@title``      A title that should describe the contract/interface                                    contract, library, interface
``@author``     The name of the author                                                                 contract, library, interface
``@notice``     Explain to an end user what this does                                                  contract, library, interface, function, public state variable, event
``@dev``        Explain to a developer any extra details                                               contract, library, interface, function, state variable, event
``@param``      Documents a parameter just like in Doxygen (must be followed by parameter name)        function, event
``@return``     Documents the return variables of a contract's function                                function, public state variable
``@inheritdoc`` Copies all missing tags from the base function (must be followed by the contract name) function, public state variable
``@custom:...`` Custom tag, semantics is application-defined                                           everywhere
=============== ====================================================================================== =============================

.. If your function returns multiple values, like ``(int quotient, int remainder)``
.. then use multiple ``@return`` statements in the same format as the ``@param`` statements.

``(int quotient, int remainder)`` のように関数が複数の値を返す場合は、 ``@param`` ステートメントと同じ形式で複数の ``@return`` ステートメントを使用します。

.. Custom tags start with ``@custom:`` and must be followed by one or more lowercase letters or hyphens.
.. It cannot start with a hyphen however. They can be used everywhere and are part of the developer documentation.

カスタムタグは ``@custom:`` で始まり、その後に1つ以上の小文字またはハイフンを付ける必要があります。ただし、ハイフンで始まることはできません。カスタムタグは、あらゆる場所で使用でき、開発者向けドキュメントの一部となっています。

.. _header-dynamic:

Dynamic expressions
-------------------

.. The Solidity compiler will pass through NatSpec documentation from your Solidity
.. source code to the JSON output as described in this guide. The consumer of this
.. JSON output, for example the end-user client software, may present this to the end-user directly or it may apply some pre-processing.

Solidityコンパイラは、SolidityソースコードからNatSpecドキュメントを経て、このガイドに記載されているJSON出力に渡します。このJSON出力の消費者（エンドユーザーのクライアントソフトウェアなど）は、これをエンドユーザーに直接提示する場合もあれば、何らかの前処理を施す場合もあります。

.. For example, some client software will render:

例えば、一部のクライアントソフトではレンダリングを行います。

.. code:: Solidity

   /// @notice This function will multiply `a` by 7

.. to the end-user as:

として、エンドユーザーに提供する。

.. code:: text

    This function will multiply 10 by 7

.. if a function is being called and the input ``a`` is assigned a value of 10.

関数が呼び出され、入力 ``a`` に10の値が割り当てられている場合。

.. Specifying these dynamic expressions is outside the scope of the Solidity
.. documentation and you may read more at
.. `the radspec project <https://github.com/aragon/radspec>`__.

これらの動的な式を指定することは、Solidityのドキュメントの範囲外であるため、詳細は `the radspec project <https://github.com/aragon/radspec>`_ _を参照してください。

.. _header-inheritance:

Inheritance Notes
-----------------

.. Functions without NatSpec will automatically inherit the documentation of their
.. base function. Exceptions to this are:

NatSpecを持たない関数は、そのベースとなる関数のドキュメントを自動的に継承します。この例外として

.. * When the parameter names are different.

* パラメータ名が異なる場合

.. * When there is more than one base function.

* 複数の基底関数がある場合

.. * When there is an explicit ``@inheritdoc`` tag which specifies which contract should be used to inherit.

* どのコントラクトを継承するかを指定する明示的な ``@inheritdoc`` タグがある場合。

.. _header-output:

Documentation Output
====================

.. When parsed by the compiler, documentation such as the one from the
.. above example will produce two different JSON files. One is meant to be
.. consumed by the end user as a notice when a function is executed and the
.. other to be used by the developer.

上記の例のようなドキュメントは、コンパイラによって解析されると、2つの異なるJSONファイルが生成されます。1つはエンドユーザーが関数実行時の通知として使用するもので、もう1つは開発者が使用するものです。

.. If the above contract is saved as ``ex1.sol`` then you can generate the
.. documentation using:

上記のコントラクトが ``ex1.sol`` として保存されていれば、以下の方法でドキュメントを作成できます。

.. code::

   solc --userdoc --devdoc ex1.sol

.. And the output is below.

そして、出力は以下の通りです。

.. .. note::

..     Starting Solidity version 0.6.11 the NatSpec output also contains a ``version`` and a ``kind`` field.
..     Currently the ``version`` is set to ``1`` and ``kind`` must be one of ``user`` or ``dev``.
..     In the future it is possible that new versions will be introduced, deprecating older ones.

.. note::

    Solidityバージョン0.6.11以降、NatSpec出力には ``version`` と ``kind`` フィールドが含まれています。     現在、 ``version`` は ``1`` に設定されており、 ``kind`` は ``user`` または ``dev`` のいずれかでなければなりません。     将来的には、新しいバージョンが導入され、古いバージョンが廃止される可能性があります。

.. _header-user-doc:

User Documentation
------------------

.. The above documentation will produce the following user documentation
.. JSON file as output:

上記のドキュメントでは、以下のようなユーザードキュメントのJSONファイルが出力されます。

.. code::

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

.. Note that the key by which to find the methods is the function's
.. canonical signature as defined in the :ref:`Contract
.. ABI <abi_function_selector>` and not simply the function's
.. name.

なお、メソッドを見つけるためのキーは、単に関数名ではなく、 :ref:`Contract ABI <abi_function_selector>` で定義された関数の正規署名であることに注意してください。

.. _header-developer-doc:

Developer Documentation
-----------------------

.. Apart from the user documentation file, a developer documentation JSON
.. file should also be produced and should look like this:

ユーザードキュメントファイルとは別に、開発者ドキュメントのJSONファイルも作成する必要があり、以下のような内容になります。

.. code::

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

