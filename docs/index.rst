Solidity
========

Solidityは、スマートコントラクトを実装するための、オブジェクト指向の高級言語です。スマートコントラクトとは、Ethereumのアカウントの動作を制御するプログラムです。

<<<<<<< HEAD
Solidityは、 `カーリーブラケット言語 <https://en.wikipedia.org/wiki/List_of_programming_languages_by_type#Curly-bracket_languages>`_ です。C++、Python、JavaScriptの影響を受けており、Ethereum Virtual Machine (EVM)をターゲットにして設計されています。Solidityがどの言語から影響を受けているかについては、 :doc:`言語の影響 <language-influences>` のセクションで詳しく説明しています。
=======
Solidity is a `curly-bracket language <https://en.wikipedia.org/wiki/List_of_programming_languages_by_type#Curly-bracket_languages>`_ designed to target the Ethereum Virtual Machine (EVM).
It is influenced by C++, Python and JavaScript. You can find more details about which languages Solidity has been inspired by in the :doc:`language influences <language-influences>` section.
>>>>>>> ce5da7dbdc13f1ec37a52e9eb76a36bb16af427c

Solidityは、静的型付け、継承、ライブラリ、複雑なユーザー定義型などの機能をサポートしています。

Solidityでは、投票、クラウドファンディング、ブラインド・オークション、マルチシグネチャー・ウォレットなどの用途に応じたコントラクトを作成できます。

コントラクトをデプロイする際には、Solidityの最新のリリースバージョンを使用すべきです。例外的なケースを除いて、最新バージョンには `セキュリティフィックス <https://github.com/ethereum/solidity/security/policy#supported-versions>`_ が施されています。さらに、破壊的な変更や新機能も定期的に導入されます。私たちは現在、 `この速いペースでの変更を示すため <https://semver.org/#spec-item-4>`_ に、0.y.zというバージョン番号を使用しています。

.. warning::

  Solidityは最近バージョン0.8.xをリリースしましたが、多くの変更点があります。必ず :doc:`完全なリスト <080-breaking-changes>` を読んでください。

Solidity やこのドキュメントを改善するためのアイデアはいつでも歓迎します。詳細は :doc:`コントリビューター・ガイド <contributing>` を読んでください。

.. Hint::

  このドキュメントは、左下のバージョン表示メニューをクリックして、希望のダウンロード形式を選択すると、PDF、HTML、Epubのいずれかでダウンロードできます。


はじめに
---------------

**1. スマートコントラクトの基本を理解する**

スマートコントラクトの概念を初めて知る方には、まず「スマートコントラクト入門」を掘り下げて読むことをお勧めします。

* :ref:`スマートコントラクトのシンプルな例 <simple-smart-contract>` （Solidityで記述）
* :ref:`ブロックチェーンの基本 <blockchain-basics>`
* :ref:`Ethereum Virtual Machine <the-ethereum-virtual-machine>`

**2. Solidityを知る**

基本的な操作に慣れてきたら、 :doc:`"Solidity by Example" <solidity-by-example>` や "言語仕様" のセクションを読んで、言語のコア・コンセプトを理解することをお勧めします。

**3. Solidityコンパイラをインストールする**

Solidity コンパイラをインストールするには様々な方法があります。お好みのオプションを選択し、 :ref:`インストールページ <installing-solidity>` に記載されている手順に従ってください。

.. hint::
  `Remix IDE <https://remix.ethereum.org>`_ を使えば、ブラウザ上で直接コード例を試すことができます。RemixはWebブラウザベースのIDEで、Solidityをローカルにインストールすることなく、Solidityスマートコントラクトの作成、デプロイ、管理を行うことができます。

.. warning::
    人間がソフトウェアを書くと、バグが発生することがあります。スマートコントラクトを作成する際には、確立されたソフトウェア開発のベストプラクティスに従うべきです。これには、コードレビュー、テスト、監査、およびコレクトネスの証明が含まれます。スマートコントラクトのユーザーは、コードの作成者よりもコードを信頼している場合があります。また、ブロックチェーンやスマートコントラクトには、注意すべき独自の問題がありますので、本番のコードに取り組む前に、必ず :ref:`security_considerations` のセクションを読んでください。

**4. さらに学ぶ**

Ethereumでの分散型アプリケーションの構築について詳しく知りたい場合は、 `Ethereum Developer Resources <https://ethereum.org/en/developers/>`_ で、Ethereumに関するさらに一般的なドキュメントや、幅広い種類のチュートリアル、ツール、開発フレームワークを紹介しています。

疑問点があれば、検索したり、 `Ethereum StackExchange <https://ethereum.stackexchange.com/>`_ や `Gitterチャンネル <https://gitter.im/ethereum/solidity/>`_ で聞いてみるといいでしょう。

.. _translations:

翻訳
------------

<<<<<<< HEAD
このドキュメントは、コミュニティのボランティアによって、いくつかの言語に翻訳されています。これらの言語は、完全性と最新性の程度が異なります。英語版を参考にしてください。
=======
Community contributors help translate this documentation into several languages.
Note that they have varying degrees of completeness and up-to-dateness. The English
version stands as a reference.
>>>>>>> ce5da7dbdc13f1ec37a52e9eb76a36bb16af427c

You can switch between languages by clicking on the flyout menu in the bottom-left corner
and selecting the preferred language.

* `French <https://docs.soliditylang.org/fr/latest/>`_
* `Indonesian <https://github.com/solidity-docs/id-indonesian>`_
* `Persian <https://github.com/solidity-docs/fa-persian>`_
* `Japanese <https://github.com/solidity-docs/ja-japanese>`_
* `Korean <https://github.com/solidity-docs/ko-korean>`_
* `Chinese <https://github.com/solidity-docs/zh-cn-chinese/>`_

.. note::

<<<<<<< HEAD
   最近、コミュニティの活動を効率化するために、GitHubの組織と翻訳のワークフローを新たに設定しました。今後のコミュニティ翻訳への貢献方法については、 `翻訳ガイド <https://github.com/solidity-docs/translation-guide>`_ をご参照ください。

* `フランス語 <https://solidity-fr.readthedocs.io>`_ (翻訳中)
* `イタリア語 <https://github.com/damianoazzolini/solidity>`_ (翻訳中)
* `日本語 <https://solidity-jp.readthedocs.io>`_
* `韓国語 <https://solidity-kr.readthedocs.io>`_ (翻訳中)
* `ロシア語 <https://github.com/ethereum/wiki/wiki/%5BRussian%5D-%D0%A0%D1%83%D0%BA%D0%BE%D0%B2%D0%BE%D0%B4%D1%81%D1%82%D0%B2%D0%BE-%D0%BF%D0%BE-Solidity>`_ (かなり古い)
* `中国語（簡体字） <https://learnblockchain.cn/docs/solidity/>`_ (翻訳中)
* `スペイン語 <https://solidity-es.readthedocs.io>`_
* `トルコ語 <https://github.com/denizozzgur/Solidity_TR/blob/master/README.md>`_ (翻訳中)
=======
   We recently set up a new GitHub organization and translation workflow to help streamline the
   community efforts. Please refer to the `translation guide <https://github.com/solidity-docs/translation-guide>`_
   for information on how to start a new language or contribute to the community translations.
>>>>>>> ce5da7dbdc13f1ec37a52e9eb76a36bb16af427c

コンテンツ
=============

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
   :caption: 内部仕様 

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
