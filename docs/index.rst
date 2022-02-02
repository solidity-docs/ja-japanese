Solidity
========

.. Solidity is an object-oriented, high-level language for implementing smart
.. contracts. Smart contracts are programs which govern the behaviour of accounts
.. within the Ethereum state.

Solidityは、スマートコントラクトを実装するための、オブジェクト指向の高級言語です。スマートコントラクトとは、Ethereumのアカウントの動作を制御するプログラムです。

.. Solidity is a `curly-bracket language <https://en.wikipedia.org/wiki/List_of_programming_languages_by_type#Curly-bracket_languages>`_.
.. It is influenced by C++, Python and JavaScript, and is designed to target the Ethereum Virtual Machine (EVM).
.. You can find more details about which languages Solidity has been inspired by in
.. the :doc:`language influences <language-influences>` section.

Solidityは、 `カーリーブラケット言語 <https://en.wikipedia.org/wiki/List_of_programming_languages_by_type#Curly-bracket_languages>`_ です。C++、Python、JavaScriptの影響を受けており、Ethereum Virtual Machine (EVM)をターゲットにして設計されています。Solidityがどの言語から影響を受けているかについては、 :doc:`言語の影響 <language-influences>` のセクションで詳しく説明しています。

.. Solidity is statically typed, supports inheritance, libraries and complex
.. user-defined types among other features.

Solidityは、静的型付け、継承、ライブラリ、複雑なユーザー定義型などの機能をサポートしています。

.. With Solidity you can create contracts for uses such as voting, crowdfunding, blind auctions,
.. and multi-signature wallets.

Solidityでは、投票、クラウドファンディング、ブラインド・オークション、マルチ・シグネチャー・ウォレットなどの用途に応じたコントラクトを作成できます。

.. When deploying contracts, you should use the latest released
.. version of Solidity. Apart from exceptional cases, only the latest version receives
.. `security fixes <https://github.com/ethereum/solidity/security/policy#supported-versions>`_.
.. Furthermore, breaking changes as well as
.. new features are introduced regularly. We currently use
.. a 0.y.z version number `to indicate this fast pace of change <https://semver.org/#spec-item-4>`_.

コントラクトをデプロイする際には、Solidityの最新のリリースバージョンを使用する必要があります。例外的なケースを除いて、最新バージョンには `セキュリティフィックス <https://github.com/ethereum/solidity/security/policy#supported-versions>`_ が施されています。さらに、破壊的な変更や新機能も定期的に導入されます。私たちは現在、 `この速いペースでの変更を示すため <https://semver.org/#spec-item-4>`_ に、0.y.zというバージョン番号を使用しています。

.. warning::

  .. Solidity recently released the 0.8.x version that introduced a lot of breaking
  .. changes. Make sure you read :doc:`the full list <080-breaking-changes>`.

  Solidityは最近バージョン0.8.xをリリースしましたが、多くの変更点があります。必ず :doc:`完全なリスト <080-breaking-changes>` を読んでください。

.. Ideas for improving Solidity or this documentation are always welcome,
.. read our :doc:`contributors guide <contributing>` for more details.

Solidity やこのドキュメントを改善するためのアイデアはいつでも歓迎します。詳細は :doc:`コントリビューター・ガイド <contributing>` を読んでください。

.. Hint::

  .. You can download this documentation as PDF, HTML or Epub by clicking on the versions
  .. flyout menu in the bottom-left corner and selecting the preferred download format.

  このドキュメントは、左下のバージョン表示メニューをクリックして、ご希望のダウンロード形式を選択すると、PDF、HTML、Epubのいずれかでダウンロードできます。


Getting Started
---------------

.. **1. Understand the Smart Contract Basics**

**1. スマートコントラクトの基本を理解する**

.. If you are new to the concept of smart contracts we recommend you to get started by digging
.. into the "Introduction to Smart Contracts" section, which covers:

スマートコントラクトの概念を初めて知る方には、まず「スマートコントラクト入門」を掘り下げて読むことをお勧めします。

.. * :ref:`A simple example smart contract <simple-smart-contract>` written in Solidity.
.. * :ref:`Blockchain Basics <blockchain-basics>`.
.. * :ref:`The Ethereum Virtual Machine <the-ethereum-virtual-machine>`.

* :ref:`スマートコントラクトのシンプルな例 <simple-smart-contract>` （Solidityで記述）
* :ref:`ブロックチェーンの基本 <blockchain-basics>`
* :ref:`Ethereum Virtual Machine <the-ethereum-virtual-machine>`

.. **2. Get to Know Solidity**

**2. Solidityを知る**

.. Once you are accustomed to the basics, we recommend you read the :doc:`"Solidity by Example" <solidity-by-example>`
.. and “Language Description” sections to understand the core concepts of the language.

基本的な操作に慣れてきたら、 :doc:`"Solidity by Example" <solidity-by-example>` や "言語仕様" のセクションを読んで、言語のコア・コンセプトを理解することをお勧めします。

.. **3. Install the Solidity Compiler**

**3. Solidityコンパイラをインストールする**

.. There are various ways to install the Solidity compiler,
.. simply choose your preferred option and follow the steps outlined on the :ref:`installation page <installing-solidity>`.

Solidity コンパイラをインストールするには様々な方法があります。お好みのオプションを選択し、 :ref:`インストールページ <installing-solidity>` に記載されている手順に従ってください。

.. hint::
  .. You can try out code examples directly in your browser with the
  .. `Remix IDE <https://remix.ethereum.org>`_. Remix is a web browser based IDE
  .. that allows you to write, deploy and administer Solidity smart contracts, without
  .. the need to install Solidity locally.

  `Remix IDE <https://remix.ethereum.org>`_ を使えば、ブラウザ上で直接コード例を試すことができます。RemixはWebブラウザベースのIDEで、Solidityをローカルにインストールすることなく、Solidityスマートコントラクトの作成、デプロイ、管理を行うことができます。

.. warning::
    .. As humans write software, it can have bugs. You should follow established
    .. software development best-practices when writing your smart contracts. This
    .. includes code review, testing, audits, and correctness proofs. Smart contract
    .. users are sometimes more confident with code than their authors, and
    .. blockchains and smart contracts have their own unique issues to
    .. watch out for, so before working on production code, make sure you read the
    .. :ref:`security_considerations` section.

    人間がソフトウェアを書くと、バグが発生することがあります。スマートコントラクトを作成する際には、確立されたソフトウェア開発のベストプラクティスに従うべきです。これには、コードレビュー、テスト、監査、および正しさの証明が含まれます。スマートコントラクトのユーザーは、コードの作成者よりもコードを信頼している場合があります。また、ブロックチェーンやスマートコントラクトには、注意すべき独自の問題がありますので、本番のコードに取り組む前に、必ず :ref:`security_considerations` のセクションを読んでください。

**4. さらに学ぶ**

.. If you want to learn more about building decentralized applications on Ethereum, the
.. `Ethereum Developer Resources <https://ethereum.org/en/developers/>`_
.. can help you with further general documentation around Ethereum, and a wide selection of tutorials,
.. tools and development frameworks.

Ethereumでの分散型アプリケーションの構築について詳しく知りたい場合は、 `Ethereum Developer Resources <https://ethereum.org/en/developers/>`_ で、Ethereumに関するさらに一般的なドキュメントや、幅広い種類のチュートリアル、ツール、開発フレームワークを紹介しています。

.. If you have any questions, you can try searching for answers or asking on the
.. `Ethereum StackExchange <https://ethereum.stackexchange.com/>`_, or
.. our `Gitter channel <https://gitter.im/ethereum/solidity/>`_.

疑問点があれば、検索したり、 `Ethereum StackExchange <https://ethereum.stackexchange.com/>`_ や `Gitterチャンネル <https://gitter.im/ethereum/solidity/>`_ で聞いてみるといいでしょう。

.. _translations:

.. Translations

翻訳
------------

.. Community volunteers help translate this documentation into several languages.
.. They have varying degrees of completeness and up-to-dateness. The English
.. version stands as a reference.

このドキュメントは、コミュニティのボランティアによって、いくつかの言語に翻訳されています。これらの言語は、完全性と最新性の程度が異なります。英語版を参考にしてください。

.. note::

   .. We recently set up a new GitHub organization and translation workflow to help streamline the
   .. community efforts. Please refer to the `translation guide <https://github.com/solidity-docs/translation-guide>`_
   .. for information on how to contribute to the community translations moving forward.

   最近、コミュニティの活動を効率化するために、GitHubの組織と翻訳のワークフローを新たに設定しました。今後のコミュニティ翻訳への貢献方法については、 `翻訳ガイド <https://github.com/solidity-docs/translation-guide>`_ をご参照ください。

* `フランス語 <https://solidity-fr.readthedocs.io>`_ (翻訳中)
* `イタリア語 <https://github.com/damianoazzolini/solidity>`_ (翻訳中)
* `日本語 <https://solidity-jp.readthedocs.io>`_
* `韓国語 <https://solidity-kr.readthedocs.io>`_ (翻訳中)
* `ロシア語 <https://github.com/ethereum/wiki/wiki/%5BRussian%5D-%D0%A0%D1%83%D0%BA%D0%BE%D0%B2%D0%BE%D0%B4%D1%81%D1%82%D0%B2%D0%BE-%D0%BF%D0%BE-Solidity>`_ (rather outdated)
* `中国語（簡体字） <https://learnblockchain.cn/docs/solidity/>`_ (翻訳中)
* `スペイン語 <https://solidity-es.readthedocs.io>`_
* `トルコ語 <https://github.com/denizozzgur/Solidity_TR/blob/master/README.md>`_ (翻訳中)

コンテンツ
========

:ref:`キーワードインデックス <genindex>`, :ref:`検索ページ <search>`

.. toctree::
   :maxdepth: 2
   :caption: 基本

   introduction-to-smart-contracts.rst
   installing-solidity.rst
   solidity-by-example.rst

.. toctree::
   :maxdepth: 2
   :caption: 言語仕様

   layout-of-source-files.rst
   structure-of-a-contract.rst
   types.rst
   units-and-global-variables.rst
   control-structures.rst
   contracts.rst
   assembly.rst
   cheatsheet.rst
   grammar.rst

.. toctree::
   :maxdepth: 2
   :caption: コンパイラ 

   using-the-compiler.rst
   analysing-compilation-output.rst
   ir-breaking-changes.rst

.. toctree::
   :maxdepth: 2
   :caption: インターナル

   internals/layout_in_storage.rst
   internals/layout_in_memory.rst
   internals/layout_in_calldata.rst
   internals/variable_cleanup.rst
   internals/source_mappings.rst
   internals/optimizer.rst
   metadata.rst
   abi-spec.rst

.. toctree::
   :maxdepth: 2
   :caption: その他の資料

   050-breaking-changes.rst
   060-breaking-changes.rst
   070-breaking-changes.rst
   080-breaking-changes.rst
   natspec-format.rst
   security-considerations.rst
   smtchecker.rst
   resources.rst
   path-resolution.rst
   yul.rst
   style-guide.rst
   common-patterns.rst
   bugs.rst
   contributing.rst
   brand-guide.rst
   language-influences.rst
