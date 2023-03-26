Solidity
========

Solidityは、スマートコントラクトを実装するための、オブジェクト指向の高級言語です。スマートコントラクトとは、Ethereumのアカウントの動作を制御するプログラムです。

Solidityは、 Ethereum Virtual Machine (EVM)をターゲットに設計されている `カーリーブラケット言語 <https://en.wikipedia.org/wiki/List_of_programming_languages_by_type#Curly-bracket_languages>`_ です。
C++、Python、JavaScriptの影響を受けています。Solidityがどの言語から影響を受けているかについては、 :doc:`言語の影響 <language-influences>` のセクションで詳しく説明しています。

Solidityは、静的型付け、継承、ライブラリ、複雑なユーザー定義型などの機能をサポートしています。

Solidityでは、投票、クラウドファンディング、ブラインドオークション、マルチシグネチャウォレットなどの用途に応じたコントラクトを作成できます。

コントラクトをデプロイする際には、Solidityの最新のリリースバージョンを使用すべきです。例外的なケースを除いて、最新バージョンには `セキュリティフィックス <https://github.com/ethereum/solidity/security/policy#supported-versions>`_ が施されています。さらに、破壊的な変更や新機能も定期的に導入されます。私たちは現在、 `この速いペースでの変更を示すため <https://semver.org/#spec-item-4>`_ に、0.y.zというバージョン番号を使用しています。

.. warning::

   Solidityは最近バージョン0.8.xをリリースしましたが、多くの変更点があります。
   必ず :doc:`その完全なリスト <080-breaking-changes>` を読んでください。

Solidity やこのドキュメントを改善するためのアイデアはいつでも歓迎します。
詳細は :doc:`コントリビューターガイド <contributing>` を読んでください。

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

基本的な操作に慣れてきたら、 :doc:`"Solidity by Example" <solidity-by-example>` や "言語仕様" のセクションを読んで、言語のコアコンセプトを理解することをお勧めします。

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

このドキュメントは、コミュニティのコントリビューターによって、いくつかの言語に翻訳されています。
これらの言語は、完成度と最新度が異なります。英語版を参考にしてください。

左下のフライアウトメニューをクリックし、好みの言語を選択することで言語を切り替えることができます。

* `Chinese <https://docs.soliditylang.org/zh/latest/>`_
* `French <https://docs.soliditylang.org/fr/latest/>`_
* `Indonesian <https://github.com/solidity-docs/id-indonesian>`_
* `Japanese <https://github.com/solidity-docs/ja-japanese>`_
* `Korean <https://github.com/solidity-docs/ko-korean>`_
* `Persian <https://github.com/solidity-docs/fa-persian>`_
* `Russian <https://github.com/solidity-docs/ru-russian>`_
* `Spanish <https://github.com/solidity-docs/es-spanish>`_
* `Turkish <https://docs.soliditylang.org/tr/latest/>`_

.. note::

   私たちは、コミュニティの取り組みを効率化するために、GitHubのオーガナイゼーションと翻訳ワークフローをセットアップしました。
   新しい言語での翻訳を始めたり、コミュニティの翻訳に貢献する方法については、 `solidity-docs org <https://github.com/solidity-docs>`_ にある翻訳ガイドを参照してください。

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
