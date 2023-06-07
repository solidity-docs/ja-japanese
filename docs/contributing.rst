######################
コントリビューティング
######################

貢献はいつでも歓迎です。
Solidityに貢献するための選択肢はたくさんあります。

特に、以下の領域でのサポートに感謝します。

* イシューの報告。

* `SolidityのGitHubイシュー <https://github.com/ethereum/solidity/issues>`_ （特に「 `good first issue <https://github.com/ethereum/solidity/labels/good%20first%20issue>`_ 」タグの付いた、外部の貢献者のための入門的なイシュー）の修正と対応。

* ドキュメントの改善。

* 新しい言語のドキュメントの `翻訳 <https://github.com/solidity-docs>`_ 。

<<<<<<< HEAD
* 他のユーザーからの `StackExchange <https://ethereum.stackexchange.com>`_ や `Solidity Gitter Chat   <https://gitter.im/ethereum/solidity>`_ での質問への返答。

* `Solidityフォーラム <https://forum.soliditylang.org/>`_ で言語の変更や新機能を提案やフィードバックの提供による言語設計プロセスへの関与。

.. To get started, you can try :ref:`building-from-source` in order to familiarize yourself with the components of Solidity and the build process.
.. Also, it may be useful to become well-versed at writing smart-contracts in Solidity.
=======
If you have issues or pull requests to discuss, or are interested in hearing what
the team and contributors are working on, you can join our public team call:

- Wednesdays at 3PM CET/CEST.

The call takes place on `Jitsi <https://meet.soliditylang.org/>`_.
>>>>>>> english/develop

まずは :ref:`building-from-source` を使って、Solidityのコンポーネントやビルドプロセスに慣れてみてください。
また、Solidityでのスマートコントラクトの書き方を熟知することも有効でしょう。

.. Please note that this project is released with a `Contributor Code of Conduct <https://raw.githubusercontent.com/ethereum/solidity/develop/CODE_OF_CONDUCT.md>`_. By participating in this project — in the issues, pull requests, or Gitter channels — you agree to abide by its terms.

<<<<<<< HEAD
このプロジェクトは `Contributor Code of Conduct <https://raw.githubusercontent.com/ethereum/solidity/develop/CODE_OF_CONDUCT.md>`_ 付きで公開されていることにご注意ください。
イシュー、プルリクエスト、Gitterチャンネルなど、このプロジェクトに参加することで、その条件を守ることに同意したことになります。
=======
* Solidity version.
* Source code (if applicable).
* Operating system.
* Steps to reproduce the issue.
* Actual vs. expected behavior.
>>>>>>> english/develop

チームコール
============

.. If you have issues or pull requests to discuss, or are interested in hearing what the team and contributors are working on, you can join our public team calls:

議論したいイシューやプルリクエストがある場合や、チームやコントリビューターが取り組んでいることを聞きたい場合は、パブリックなチームコールに参加できます。

- 毎週月曜日と水曜日の午後3時（CET/CEST）から。

どちらのコールも `Jitsi <https://meet.soliditylang.org/>`_ で行われます。

イシューの報告方法
==================

.. To report an issue, please use the
.. `GitHub issues tracker <https://github.com/ethereum/solidity/issues>`_. When
.. reporting issues, please mention the following details:

問題を報告するには、 `GitHubイシュートラッカー <https://github.com/ethereum/solidity/issues>`_ を利用してください。
報告の際には、以下の内容をお知らせください。

* Solidityのバージョン。
* ソースコード（必要に応じて）。
* オペレーティングシステム。
* イシューを再現するための手順。
* 実際の挙動と期待される挙動の比較。

.. Reducing the source code that caused the issue to a bare minimum is always very helpful and sometimes even clarifies a misunderstanding.

イシューの原因となったソースコードを最小限に減らすことは、常に非常に役に立ち、時には誤解を解くことにもなります。

.. For technical discussions about language design, a post in the `Solidity forum <https://forum.soliditylang.org/>`_ is the correct place (see :ref:`solidity_language_design`).

言語設計に関する技術的な議論については、 `Solidity forum <https://forum.soliditylang.org/>`_ への投稿が正しい場所です（ :ref:`solidity_language_design` を参照してください）。

<<<<<<< HEAD
プルリクエストのワークフロー
============================
=======
For running all compiler tests you may want to optionally install a few
dependencies (`evmone <https://github.com/ethereum/evmone/releases>`_,
`libz3 <https://github.com/Z3Prover/z3>`_).
>>>>>>> english/develop

.. In order to contribute, please fork off of the ``develop`` branch and make your changes there.
.. Your commit messages should detail *why* you made your change in addition to *what* you did (unless it is a tiny change).

貢献するためには、 ``develop`` ブランチをフォークして、そこで変更を加えてください。
コミットメッセージには、変更した内容に加えて、変更した理由を詳しく書いてください（小さな変更の場合を除く）。

.. If you need to pull in any changes from ``develop`` after making your fork (for example, to resolve potential merge conflicts), please avoid using ``git merge`` and instead, ``git rebase`` your branch.
.. This will help us review your change more easily.

フォーク後に ``develop`` からの変更を取り込む必要がある場合（たとえば、潜在的なマージコンフリクトを解決するため）、 ``git merge`` の使用を避け、代わりに ``git rebase`` でブランチを作成してください。
そうすることで、あなたの変更をより簡単に確認できます。

<<<<<<< HEAD
.. Additionally, if you are writing a new feature, please ensure you add appropriate test cases under ``test/`` (see below).
=======
The ``./scripts/tests.sh`` script executes most Solidity tests automatically,
including those bundled into the `Boost C++ Test Framework <https://www.boost.org/doc/libs/release/libs/test/doc/html/index.html>`_
application ``soltest`` (or its wrapper ``scripts/soltest.sh``), as well as command-line tests and
compilation tests.
>>>>>>> english/develop

また、新機能を書いている場合は、 ``test/`` の下に適切なテストケースを追加してください（下記を参照してください）。

.. However, if you are making a larger change, please consult with the `Solidity Development Gitter channel <https://gitter.im/ethereum/solidity-dev>`_ (different from the one mentioned above — this one is focused on compiler and language development instead of language usage) first.

ただし、より大きな変更を行う場合は、まず `Solidity Development Gitter チャンネル <https://gitter.im/ethereum/solidity-dev>`_ （前述のものとは異なり、こちらは言語の使い方ではなく、コンパイラや言語の開発に重点を置いています）に相談してください。

<<<<<<< HEAD
.. New features and bugfixes should be added to the ``Changelog.md`` file: please follow the style of previous entries, when applicable.

新機能やバグフィックスは、 ``Changelog.md`` ファイルに追加してください。
該当する場合は、過去のエントリーのスタイルに従ってください。
=======
The ``evmone`` library should both end with the file name
extension ``.so`` on Linux, ``.dll`` on Windows systems and ``.dylib`` on macOS.
>>>>>>> english/develop

.. Finally, please make sure you respect the `coding style <https://github.com/ethereum/solidity/blob/develop/CODING_STYLE.md>`_ for this project.
.. Also, even though we do CI testing, please test your code and ensure that it builds locally before submitting a pull request.

最後に、このプロジェクトの `コーディングスタイル <https://github.com/ethereum/solidity/blob/develop/CODING_STYLE.md>`_ を尊重するようにしてください。
また、CIテストを行っているとはいえ、プルリクエストを提出する前にコードをテストし、ローカルにビルドされることを確認してください。

<<<<<<< HEAD
.. We highly recommend going through our `review checklist <https://github.com/ethereum/solidity/blob/develop/ReviewChecklist.md>`_ before submitting the pull request.
.. We thoroughly review every PR and will help you get it right, but there are many common problems that can be easily avoided, making the review much smoother.
=======
.. note::
>>>>>>> english/develop

プルリクエストを提出する前に、私たちの `レビューチェックリスト <https://github.com/ethereum/solidity/blob/develop/ReviewChecklist.md>`_ に目を通すことを強くお勧めします。
私たちはすべてのPRを徹底的にレビューし、あなたが正しい結果を得られるようサポートしますが、簡単に回避できる多くの一般的な問題があり、レビューがよりスムーズに行えるようになります。

.. Thank you for your help!

ご協力ありがとうございます！

コンパイラーテストの実行
========================

.. Prerequisites

事前準備
--------

.. For running all compiler tests you may want to optionally install a few dependencies (`evmone <https://github.com/ethereum/evmone/releases>`_, `libz3 <https://github.com/Z3Prover/z3>`_, and `libhera <https://github.com/ewasm/hera>`_).

<<<<<<< HEAD
すべてのコンパイラテストを実行するために、いくつかの依存関係（ `evmone <https://github.com/ethereum/evmone/releases>`_ 、 `libz3 <https://github.com/Z3Prover/z3>`_ 、 `libhera <https://github.com/ewasm/hera>`_ ）をオプションでインストールできます。
=======
.. note::
>>>>>>> english/develop

.. On macOS systems, some of the testing scripts expect GNU coreutils to be installed. 
.. This can be easiest accomplished using Homebrew: ``brew install coreutils``.

macOSでは、一部のテストスクリプトでGNU coreutilsがインストールされていることが前提となっています。
インストールするにはHomebrewを使うのが最も簡単です: ``brew install coreutils`` 。

.. On Windows systems, make sure that you have a privilege to create symlinks, otherwise several tests may fail.
.. Administrators should have that privilege, but you may also `grant it to other users <https://learn.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/create-symbolic-links#policy-management>`_ or `enable Developer Mode <https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development>`_.

Windowsシステムでは、シンボリックリンクを作成する権限を持っていることを確認してください、さもなければいくつかのテストが失敗するかもしれません。
管理者がその権限を持つべきですが、 `他のユーザーにその権限を与えること <https://learn.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/create-symbolic-links#policy-management>`_ や、 `開発者モードを有効にする <https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development>`_ ことも可能です。

テストの実行
------------

.. Solidity includes different types of tests, most of them bundled into the
.. `Boost C++ Test Framework <https://www.boost.org/doc/libs/release/libs/test/doc/html/index.html>`_ application ``soltest``.
.. Running ``build/test/soltest`` or its wrapper ``scripts/soltest.sh`` is sufficient for most changes.

Solidityには様々なタイプのテストがあり、そのほとんどが `Boost C++ Test Framework <https://www.boost.org/doc/libs/release/libs/test/doc/html/index.html>`_ アプリケーション ``soltest`` にバンドルされています。
ほとんどの変更には、 ``build/test/soltest`` またはそのラッパー ``scripts/soltest.sh`` を実行すれば十分です。

.. The ``./scripts/tests.sh`` script executes most Solidity tests automatically, including those bundled into the `Boost C++ Test Framework <https://www.boost.org/doc/libs/release/libs/test/doc/html/index.html>`_ application ``soltest`` (or its wrapper ``scripts/soltest.sh``), as well as command line tests and compilation tests.

``./scripts/tests.sh`` スクリプトは、 `Boost C++ Test Framework <https://www.boost.org/doc/libs/release/libs/test/doc/html/index.html>`_ アプリケーション ``soltest`` （またはそのラッパー ``scripts/soltest.sh`` ）にバンドルされているものや、コマンドラインテスト、コンパイルテストなど、ほとんどのSolidityテストを自動的に実行します。

.. The test system automatically tries to discover the location of the `evmone <https://github.com/ethereum/evmone/releases>`_ for running the semantic tests.

テストシステムは、セマンティックテストを実行するための `evmone <https://github.com/ethereum/evmone/releases>`_ の場所を自動的に発見しようとします。

.. The ``evmone`` library must be located in the ``deps`` or ``deps/lib`` directory relative to the current working directory, to its parent or its parent's parent.
.. Alternatively an explicit location for the ``evmone`` shared object can be specified via the ``ETH_EVMONE`` environment variable.

``evmone`` ライブラリは、現在の作業ディレクトリ、その親、またはその親の親に対する ``deps`` または ``deps/lib`` ディレクトリに配置されている必要があります。
また、環境変数 ``ETH_EVMONE`` を使って ``evmone`` 共有オブジェクトの場所を明示的に指定することもできます。

.. ``evmone`` is needed mainly for running semantic and gas tests.
.. If you do not have it installed, you can skip these tests by passing the ``--no-semantic-tests`` flag to ``scripts/soltest.sh``.

``evmone`` は主にセマンティックテストとガステストを実行するために必要です。
インストールされていない場合は、 ``scripts/soltest.sh`` に ``--no-semantic-tests`` フラグを渡すことで、これらのテストをスキップできます。

.. Running Ewasm tests is disabled by default and can be explicitly enabled
.. via ``./scripts/soltest.sh --ewasm`` and requires `hera <https://github.com/ewasm/hera>`_
.. to be found by ``soltest``.
.. The mechanism for locating the ``hera`` library is the same as for ``evmone``, except that the
.. variable for specifying an explicit location is called ``ETH_HERA``.

Ewasmのテストの実行は、デフォルトでは無効になっており、 ``./scripts/soltest.sh --ewasm`` を介して明示的に有効にでき、 ``soltest`` で `hera <https://github.com/ewasm/hera>`_ を見つけることが必要です。
``hera`` ライブラリを探す仕組みは、明示的に場所を指定するための変数が ``ETH_HERA`` と呼ばれていることを除けば、 ``evmone`` と同じです。

.. The ``evmone`` and ``hera`` libraries should both end with the file name
.. extension ``.so`` on Linux, ``.dll`` on Windows systems and ``.dylib`` on macOS.

``evmone`` ライブラリと ``hera`` ライブラリは、どちらもファイル名の拡張子が、Linuxでは ``.so`` 、Windowsシステムでは ``.dll`` 、macOSでは ``.dylib`` になるようにしてください。

.. For running SMT tests, the ``libz3`` library must be installed and locatable
.. by ``cmake`` during compiler configure stage.

SMTテストを実行するためには、 ``libz3`` ライブラリがインストールされており、コンパイラのconfigure段階で ``cmake`` が位置を特定できる必要があります。

.. If the ``libz3`` library is not installed on your system, you should disable the
.. SMT tests by exporting ``SMT_FLAGS=--no-smt`` before running ``./scripts/tests.sh`` or
.. running ``./scripts/soltest.sh --no-smt``.
.. These tests are ``libsolidity/smtCheckerTests`` and ``libsolidity/smtCheckerTestsJSON``.

``libz3`` ライブラリがシステムにインストールされていない場合は、 ``./scripts/tests.sh`` を実行する前に ``SMT_FLAGS=--no-smt`` をエクスポートしてSMTテストを無効にするか、 ``./scripts/soltest.sh --no-smt`` を実行する必要があります。
これらのテストは ``libsolidity/smtCheckerTests`` と ``libsolidity/smtCheckerTestsJSON`` です。

.. note::

    Soltestで実行されたすべてのユニットテストのリストを取得するには、 ``./build/test/soltest --list_content=HRF`` を実行してください。

.. For quicker results you can run a subset of, or specific tests.

より迅速な結果を得るために、一部のテストや特定のテストを実行できます。

.. To run a subset of tests, you can use filters:
.. ``./scripts/soltest.sh -t TestSuite/TestName``,
.. where ``TestName`` can be a wildcard ``*``.

テストのサブセットを実行するには、 ``./scripts/soltest.sh -t TestSuite/TestName``のようにフィルターを使うことができます。
``TestName`` にはワイルドカード ``*`` を指定できます。

.. Or, for example, to run all the tests for the yul disambiguator:
.. ``./scripts/soltest.sh -t "yulOptimizerTests/disambiguator/*" --no-smt``.

あるいは、例えば、yul disambiguatorのすべてのテストを実行するには、次のようにします。
``./scripts/soltest.sh -t "yulOptimizerTests/disambiguator/*" --no-smt`` です。

.. ``./build/test/soltest --help`` has extensive help on all of the options available.

``./build/test/soltest --help`` には、利用可能なすべてのオプションに関する広範なヘルプがあります。

特に、以下のオプションを参考にしてください。

.. - `show_progress (-p) <https://www.boost.org/doc/libs/release/libs/test/doc/html/boost_test/utf_reference/rt_param_reference/show_progress.html>`_ to show test completion,
.. - `run_test (-t) <https://www.boost.org/doc/libs/release/libs/test/doc/html/boost_test/utf_reference/rt_param_reference/run_test.html>`_ to run specific tests cases, and
.. - `report-level (-r) <https://www.boost.org/doc/libs/release/libs/test/doc/html/boost_test/utf_reference/rt_param_reference/report_level.html>`_ give a more detailed report.

- `show_progress (-p) <https://www.boost.org/doc/libs/release/libs/test/doc/html/boost_test/utf_reference/rt_param_reference/show_progress.html>`_: テストの進行状態を表示します。
- `run_test (-t) <https://www.boost.org/doc/libs/release/libs/test/doc/html/boost_test/utf_reference/rt_param_reference/run_test.html>`_ : 特定のテストケースを実行します。
- `report-level (-r) <https://www.boost.org/doc/libs/release/libs/test/doc/html/boost_test/utf_reference/rt_param_reference/report_level.html>`_: より詳細な報告をします。

.. .. note::

..     Those working in a Windows environment wanting to run the above basic sets without libz3.
..     Using Git Bash, you use: ``./build/test/Release/soltest.exe -- --no-smt``.
..     If you are running this in plain Command Prompt, use ``.\build\test\Release\soltest.exe -- --no-smt``.

.. note::

    Windows環境で、上記の基本セットをlibz3なしで実行したい方は、次のようにしてください。
    Git Bashを使っている場合、 ``./build/test/Release/soltest.exe -- --no-smt`` を実行してください。
    プレーンなコマンドプロンプトで実行する場合、 ``.\build\test\Release\soltest.exe -- --no-smt`` を実行してください。

.. If you want to debug using GDB, make sure you build differently than the "usual".
.. For example, you could run the following command in your ``build`` folder:

GDBを使ってデバッグしたい場合は、「通常」とは異なる方法でビルドするようにしてください。
例えば、 ``build`` フォルダで以下のコマンドを実行します。

<<<<<<< HEAD
=======
If you want to debug using GDB, make sure you build differently than the "usual".
For example, you could run the following command in your ``build`` folder:

>>>>>>> english/develop
.. code-block:: bash

   cmake -DCMAKE_BUILD_TYPE=Debug ..
   make

.. This creates symbols so that when you debug a test using the ``--debug`` flag, you have access to functions and variables in which you can break or print with.

これにより、 ``--debug`` フラグを使ってテストをデバッグする際に、ブレークやプリントが可能な関数や変数にアクセスできるようにシンボルが作成されます。

.. The CI runs additional tests (including ``solc-js`` and testing third party Solidity frameworks) that require compiling the Emscripten target.

CIは、Emscriptenターゲットのコンパイルを必要とする追加のテスト（ ``solc-js`` やサードパーティのSolidityフレームワークのテストなど）を実行します。

.. Writing and Running Syntax Tests

構文テストの作成と実行
----------------------

.. Syntax tests check that the compiler generates the correct error messages for invalid code and properly accepts valid code.
.. They are stored in individual files inside the ``tests/libsolidity/syntaxTests`` folder.
.. These files must contain annotations, stating the expected result(s) of the respective test.
.. The test suite compiles and checks them against the given expectations.

構文テストは、コンパイラが無効なコードに対して正しいエラーメッセージを生成し、有効なコードを適切に受け入れるかどうかをチェックします。
これらのテストは  ``tests/libsolidity/syntaxTests``  フォルダー内の個々のファイルに格納されます。
これらのファイルには、それぞれのテストで期待される結果を記載した注釈を含める必要があります。
テストスイートは、これらのファイルをコンパイルし、期待される結果に対してチェックします。

.. For example: ``./test/libsolidity/syntaxTests/double_stateVariable_declaration.sol``

例えば、次のようなものです。
``./test/libsolidity/syntaxTests/double_stateVariable_declaration.sol``

.. code-block:: solidity

    contract test {
        uint256 variable;
        uint128 variable;
    }
    // ----
    // DeclarationError: (36-52): Identifier already declared.

.. A syntax test must contain at least the contract under test itself, followed by the separator ``// ----``.
.. The comments that follow the separator are used to describe the expected compiler errors or warnings.
.. The number range denotes the location in the source where the error occurred.
.. If you want the contract to compile without any errors or warning you can leave out the separator and the comments that follow it.

構文テストは、少なくともテスト対象のコントラクトそのものと、それに続くセパレータ ``// ----`` を含んでいなければなりません。
セパレータに続くコメントは、予想されるコンパイラのエラーや警告を説明するために使用されます。
数字の範囲は、エラーが発生したソースの場所を示します。
もし、エラーや警告を出さずにコントラクトをコンパイルしたい場合は、セパレータとそれに続くコメントを省くことができます。

.. In the above example, the state variable ``variable`` was declared twice, which is not allowed. This results in a ``DeclarationError`` stating that the identifier was already declared.

上の例では、状態変数 ``variable`` が2回宣言されていますが、これは許されません。
この結果、識別子がすでに宣言されているという ``DeclarationError`` が表示されます。

.. The ``isoltest`` tool is used for these tests and you can find it under ``./build/test/tools/``. It is an interactive tool which allows
.. editing of failing contracts using your preferred text editor. Let's try to break this test by removing the second declaration of ``variable``:

これらのテストには ``isoltest`` ツールが使用されており、 ``./build/test/tools/`` で見つけることができます。
これは対話型のツールで、好みのテキストエディタを使って失敗したコントラクトを編集できます。
``variable`` の2番目の宣言を削除することで、このテストを破ってみましょう。

.. code-block:: solidity

    contract test {
        uint256 variable;
    }
    // ----
    // DeclarationError: (36-52): Identifier already declared.

.. Running ``./build/test/tools/isoltest`` again results in a test failure:

``./build/test/tools/isoltest`` を再度実行すると、テストが失敗します。

.. code-block:: text

    syntaxTests/double_stateVariable_declaration.sol: FAIL
        Contract:
            contract test {
                uint256 variable;
            }

        Expected result:
            DeclarationError: (36-52): Identifier already declared.
        Obtained result:
            Success

.. ``isoltest`` prints the expected result next to the obtained result, and also provides a way to edit, update or skip the current contract file, or quit the application.

``isoltest`` は、期待される結果を得られた結果の横に表示し、また、現在のコントラクトファイルを編集、更新、スキップしたり、アプリケーションを終了する方法を提供します。

.. It offers several options for failing tests:

<<<<<<< HEAD
テストを失敗させるためのいくつかのオプションがあります。
=======
- ``edit``: ``isoltest`` tries to open the contract in an editor so you can adjust it. It either uses the editor given on the command-line (as ``isoltest --editor /path/to/editor``), in the environment variable ``EDITOR`` or just ``/usr/bin/editor`` (in that order).
- ``update``: Updates the expectations for contract under test. This updates the annotations by removing unmet expectations and adding missing expectations. The test is then run again.
- ``skip``: Skips the execution of this particular test.
- ``quit``: Quits ``isoltest``.
>>>>>>> english/develop

.. - ``edit``: ``isoltest`` tries to open the contract in an editor so you can adjust it. It either uses the editor given on the command line (as ``isoltest --editor /path/to/editor``), in the environment variable ``EDITOR`` or just ``/usr/bin/editor`` (in that order).

- ``edit``: ``isoltest`` は、コントラクト内容を調整できるように、エディタでコントラクト内容を開こうとします。
  ``isoltest --editor /path/to/editor`` のようにコマンドラインで指定されたエディタを使用するか、 ``EDITOR`` のように環境変数で指定されたエディタを使用するか、 ``/usr/bin/editor`` だけを使用するか（順不同）。

.. - ``update``: Updates the expectations for contract under test. This updates the annotations by removing unmet expectations and adding missing expectations. The test is then run again.

- ``update``: テスト中のコントラクトに対する期待値を更新。
  これは、満たされていない期待値を削除し、満たされていない期待値を追加することで、アノテーションを更新します。
  その後、テストが再度実行されます。

.. - ``skip``: Skips the execution of this particular test.

- ``skip``: この特定のテストの実行をスキップします。

.. - ``quit``: Quits ``isoltest``.

- ``quit``: ``isoltest`` を終了します。

.. All of these options apply to the current contract, except ``quit`` which stops the entire testing process.

これらのオプションは、テストプロセス全体を停止する ``quit`` を除いて、すべて現在のコントラクトに適用されます。

.. Automatically updating the test above changes it to

上のテストを自動的に更新すると、次のように変更されます。

.. code-block:: solidity

    contract test {
        uint256 variable;
    }
    // ----

.. and re-run the test.
.. It now passes again:

そして、テストを再実行します。
これで合格です。

.. code-block:: text

    Re-running test case...
    syntaxTests/double_stateVariable_declaration.sol: OK

.. .. note::

..     Choose a name for the contract file that explains what it tests, e.g. ``double_variable_declaration.sol``.
..     Do not put more than one contract into a single file, unless you are testing inheritance or cross-contract calls.
..     Each file should test one aspect of your new feature.

.. note::

    コントラクトファイルの名前には、 ``double_variable_declaration.sol``  など、テストする内容を説明するものを選んでください。
    継承やクロスコントラクトコールをテストする場合を除き、1つのファイルに複数のコントラクトを入れないでください。
    各ファイルは、新機能の1つの側面をテストする必要があります。

<<<<<<< HEAD
AFLによるファザーの実行
=======================
=======
Command-line Tests
------------------

Our suite of end-to-end command-line tests checks the behaviour of the compiler binary as a whole
in various scenarios.
These tests are located in `test/cmdlineTests/ <https://github.com/ethereum/solidity/tree/develop/test/cmdlineTests>`_,
one per subdirectory, and can be executed using the ``cmdlineTests.sh`` script.

By default the script runs all available tests.
You can also provide one or more `file name patterns <https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion>`_,
in which case only the tests matching at least one pattern will be executed.

By default the script assumes that a ``solc`` binary is available inside the ``build/`` subdirectory
inside the working copy.
If you build the compiler outside of the source tree, you can use the ``SOLIDITY_BUILD_DIR`` environment
variable to specify a different location for the build directory.

Example:

.. code-block:: bash

    export SOLIDITY_BUILD_DIR=~/solidity/build/
    test/cmdlineTests.sh "standard_*" "*_yul_*"

The commands above will run tests from directories starting with ``test/cmdlineTests/standard_`` and
subdirectories of ``test/cmdlineTests/`` that have ``_yul_`` somewhere in the name.
It will also assume that the file ``solidity/build/solc/solc`` inside your home directory is the
compiler binary (unless you are on Windows -- then ``solidity/build/solc/Release/solc.exe``).

There are several kinds of command-line tests:

- *Standard JSON test*: contains at least an ``input.json`` file.
  In general may contain:

    - ``input.json``: input file to be passed to the ``--standard-json`` option on the command line.
    - ``output.json``: expected Standard JSON output.
    - ``args``: extra command-line arguments passed to ``solc``.

- *CLI test*: contains at least an ``input.*`` file (other than ``input.json``).
  In general may contain:

    - ``input.*``: a single input file, whose name will be supplied to ``solc`` on the command line.
      Usually ``input.sol`` or ``input.yul``.
    - ``args``: extra command-line arguments passed to ``solc``.
    - ``stdin``: content to be passed to ``solc`` via standard input.
    - ``output``: expected content of the standard output.
    - ``err``: expected content of the standard error output.
    - ``exit``: expected exit code. If not provided, zero is expected.

- *Script test*: contains a ``test.*`` file.
  In general may contain:

    - ``test.*``: a single script to run, usually ``test.sh`` or ``test.py``.
      The script must be executable.
>>>>>>> english/develop

.. Fuzzing is a technique that runs programs on more or less random inputs to find exceptional execution
.. states (segmentation faults, exceptions, etc). Modern fuzzers are clever and run a directed search
.. inside the input. We have a specialized binary called ``solfuzzer`` which takes source code as input
.. and fails whenever it encounters an internal compiler error, segmentation fault or similar, but
.. does not fail if e.g., the code contains an error. This way, fuzzing tools can find internal problems in the compiler.

ファジングとは、多かれ少なかれランダムな入力に対してプログラムを実行し、例外的な実行状態（セグメンテーションフォールトや例外など）を見つける技術です。
最近のFuzzerは賢く、入力の内部で有向検索を行います。
私たちは ``solfuzzer`` と呼ばれる特殊なバイナリを持っています。
``solfuzzer`` はソースコードを入力として受け取り、内部のコンパイラエラーやセグメンテーションフォールトなどに遭遇するたびに失敗しますが、例えばコードにエラーが含まれている場合は失敗しません。
このようにして、ファジングツールはコンパイラの内部問題を見つけることができます。

.. We mainly use `AFL <https://lcamtuf.coredump.cx/afl/>`_ for fuzzing. You need to download and
.. install the AFL packages from your repositories (afl, afl-clang) or build them manually.
.. Next, build Solidity (or just the ``solfuzzer`` binary) with AFL as your compiler:

ファジングには主に `AFL <https://lcamtuf.coredump.cx/afl/>`_ を使用しています。
AFLパッケージをリポジトリ（afl, afl-clang）からダウンロードしてインストールするか、手動でビルドする必要があります。
次に、AFLをコンパイラとしてSolidity（または ``solfuzzer`` バイナリのみ）をビルドします。

.. code-block:: bash

    cd build
    # if needed
    make clean
    cmake .. -DCMAKE_C_COMPILER=path/to/afl-gcc -DCMAKE_CXX_COMPILER=path/to/afl-g++
    make solfuzzer

.. At this stage, you should be able to see a message similar to the following:

この段階では、以下のようなメッセージが表示されます。

.. code-block:: text

    Scanning dependencies of target solfuzzer
    [ 98%] Building CXX object test/tools/CMakeFiles/solfuzzer.dir/fuzzer.cpp.o
    afl-cc 2.52b by <lcamtuf@google.com>
    afl-as 2.52b by <lcamtuf@google.com>
    [+] Instrumented 1949 locations (64-bit, non-hardened mode, ratio 100%).
    [100%] Linking CXX executable solfuzzer

.. If the instrumentation messages did not appear, try switching the cmake flags pointing to AFL's clang binaries:

インストルメンテーションメッセージが表示されない場合は、AFLのclangバイナリを指すcmakeフラグを切り替えてみてください。

.. code-block:: bash

    # if previously failed
    make clean
    cmake .. -DCMAKE_C_COMPILER=path/to/afl-clang -DCMAKE_CXX_COMPILER=path/to/afl-clang++
    make solfuzzer

.. Otherwise, upon execution the fuzzer halts with an error saying binary is not instrumented:

そうでない場合は、実行時に「binary is not instrumented」というエラーでファザーが停止します。

.. code-block:: text

    afl-fuzz 2.52b by <lcamtuf@google.com>
    ... (truncated messages)
    [*] Validating target binary...

    [-] Looks like the target binary is not instrumented! The fuzzer depends on
        compile-time instrumentation to isolate interesting test cases while
        mutating the input data. For more information, and for tips on how to
        instrument binaries, please see /usr/share/doc/afl-doc/docs/README.

        When source code is not available, you may be able to leverage QEMU
        mode support. Consult the README for tips on how to enable this.
        (It is also possible to use afl-fuzz as a traditional, "dumb" fuzzer.
        For that, you can use the -n option - but expect much worse results.)

    [-] PROGRAM ABORT : No instrumentation detected
             Location : check_binary(), afl-fuzz.c:6920

.. Next, you need some example source files. This makes it much easier for the fuzzer
.. to find errors. You can either copy some files from the syntax tests or extract test files
.. from the documentation or the other tests:

次に、いくつかのサンプルソースファイルが必要です。
これにより、ファザーがエラーを見つけるのが非常に簡単になります。
構文テストからいくつかのファイルをコピーするか、ドキュメントや他のテストからテストファイルを抽出できます。

.. code-block:: bash

    mkdir /tmp/test_cases
    cd /tmp/test_cases
    # extract from tests:
    path/to/solidity/scripts/isolate_tests.py path/to/solidity/test/libsolidity/SolidityEndToEndTest.cpp
    # extract from documentation:
    path/to/solidity/scripts/isolate_tests.py path/to/solidity/docs

<<<<<<< HEAD
.. The AFL documentation states that the corpus (the initial input files) should not be
.. too large. The files themselves should not be larger than 1 kB and there should be
.. at most one input file per functionality, so better start with a small number of.
.. There is also a tool called ``afl-cmin`` that can trim input files
.. that result in similar behaviour of the binary.
=======
The AFL documentation states that the corpus (the initial input files) should not be
too large. The files themselves should not be larger than 1 kB and there should be
at most one input file per functionality, so better start with a small number of.
There is also a tool called ``afl-cmin`` that can trim input files
that result in similar behavior of the binary.
>>>>>>> english/develop

AFLのドキュメントでは、コーパス（最初の入力ファイル）はあまり大きくしない方が良いとされています。
ファイル自体の大きさは1kB以下で、1つの機能に対して入力ファイルは多くても1つなので、少ない数から始めた方が良いでしょう。
また、 ``afl-cmin`` というツールがあり、バイナリの挙動が似ている入力ファイルをトリミングできます。

.. Now run the fuzzer (the ``-m`` extends the size of memory to 60 MB):

ここで、ファザーを実行します（ ``-m`` ではメモリサイズを60MBに拡張しています）。

.. code-block:: bash

    afl-fuzz -m 60 -i /tmp/test_cases -o /tmp/fuzzer_reports -- /path/to/solfuzzer

.. The fuzzer creates source files that lead to failures in ``/tmp/fuzzer_reports``.
.. Often it finds many similar source files that produce the same error. You can
.. use the tool ``scripts/uniqueErrors.sh`` to filter out the unique errors.

ファザーは、 ``/tmp/fuzzer_reports`` の失敗につながるソースファイルを作成します。
多くの場合、同じエラーを発生させる多くの類似したソースファイルを見つけます。
ツール ``scripts/uniqueErrors.sh`` を使って、固有のエラーをフィルタリングできます。

Whiskers
========

.. *Whiskers* is a string templating system similar to `Mustache <https://mustache.github.io>`_. It is used by the
.. compiler in various places to aid readability, and thus maintainability and verifiability, of the code.

*Whiskers* は、 `Mustache <https://mustache.github.io>`_  に似た文字列テンプレートシステムです。
コンパイラは、コードの可読性、ひいては保守性や検証性を高めるために、さまざまな場所でこのシステムを使用しています。

.. The syntax comes with a substantial difference to Mustache. The template markers ``{{`` and ``}}`` are
.. replaced by ``<`` and ``>`` in order to aid parsing and avoid conflicts with :ref:`yul`
.. (The symbols ``<`` and ``>`` are invalid in inline assembly, while ``{`` and ``}`` are used to delimit blocks).
.. Another limitation is that lists are only resolved one depth and they do not recurse. This may change in the future.

この構文は、Mustacheとは大幅に異なります。
テンプレートマーカー ``{{`` と ``}}`` は、解析を助け、 :ref:`yul` との衝突を避けるために、 ``<`` と ``>`` に置き換えられています（シンボル ``<`` と ``>`` はインラインアセンブリでは無効であり、 ``{`` と ``}`` はブロックの区切りに使用されます）。
もう1つの制限は、リストは1つの深さまでしか解決されず、再帰的にはならないことです。
これは将来変更される可能性があります。

.. A rough specification is the following:

大まかな仕様は以下の通りです。

.. Any occurrence of ``<name>`` is replaced by the string-value of the supplied variable ``name`` without any
.. escaping and without iterated replacements. An area can be delimited by ``<#name>...</name>``. It is replaced
.. by as many concatenations of its contents as there were sets of variables supplied to the template system,
.. each time replacing any ``<inner>`` items by their respective value. Top-level variables can also be used
.. inside such areas.

``<name>`` が出現すると、与えられた変数 ``name`` の文字列値で置き換えられます。
このとき、エスケープや繰り返しの置き換えは行われません。
ある領域は  ``<#name>...</name>``  で区切ることができます。
領域は、テンプレートシステムに供給された変数セットの数だけ、その内容を連結したものに置き換えられ、その都度、 ``<inner>`` 項目をそれぞれの値で置き換えます。
トップレベルの変数は、このような領域内で使用することもできます。

.. There are also conditionals of the form ``<?name>...<!name>...</name>``, where template replacements
.. continue recursively either in the first or the second segment depending on the value of the boolean
.. parameter ``name``. If ``<?+name>...<!+name>...</+name>`` is used, then the check is whether
.. the string parameter ``name`` is non-empty.

``<?name>...<!name>...</name>`` 形式の条件式もあります。
ここでは、ブーリアンパラメータ ``name`` の値に応じて、テンプレートの置換が最初のセグメントまたは2番目のセグメントで再帰的に続けられます。
``<?+name>...<!+name>...</+name>`` を使用する場合は、文字列パラメータ ``name`` が空でないかどうかをチェックします。

.. _documentation-style:

ドキュメンテーションのスタイルガイド
====================================

.. In the following section you find style recommendations specifically focusing on documentation
.. contributions to Solidity.

次のセクションでは、Solidityへのドキュメント提供に特化したスタイルの推奨事項を紹介します。

<<<<<<< HEAD
.. English Language

英語
----

.. Use English, with British English spelling preferred, unless using project or brand names. Try to reduce the usage of
.. local slang and references, making your language as clear to all readers as possible. Below are some references to help:

プロジェクト名やブランド名を使用する場合を除き、イギリス英語のスペルを使用してください。
現地のスラングや参考文献の使用を極力控え、誰が読んでも分かりやすい言葉遣いを心がけてください。
以下は参考になる文献です。

* `Simplified technical English <https://en.wikipedia.org/wiki/Simplified_Technical_English>`_
* `International English <https://en.wikipedia.org/wiki/International_English>`_
* `British English spelling <https://web.archive.org/web/20220324094038/https://www.lexico.com/grammar/british-and-spelling>`_

.. .. note::

..     While the official Solidity documentation is written in English, there are community contributed :ref:`translations`
..     in other languages available. Please refer to the `translation guide <https://github.com/solidity-docs/translation-guide>`_
..     for information on how to contribute to the community translations.
=======
Use International English, unless using project or brand names. Try to reduce the usage of
local slang and references, making your language as clear to all readers as possible.
Below are some references to help:

* `Simplified technical English <https://en.wikipedia.org/wiki/Simplified_Technical_English>`_
* `International English <https://en.wikipedia.org/wiki/International_English>`_
>>>>>>> english/develop

.. note::

    公式のSolidityドキュメントは英語で書かれていますが、コミュニティの貢献によって他の言語の :ref:`translations` も利用できます。
    コミュニティの翻訳に貢献する方法については、 `翻訳ガイド <https://github.com/solidity-docs#solidity-documentation-translation-guide>`_ を参照してください。

.. Title Case for Headings

見出しのタイトルケース
----------------------

.. Use `title case <https://titlecase.com>`_ for headings. This means capitalise all principal words in
.. titles, but not articles, conjunctions, and prepositions unless they start the
.. title.

見出しには `タイトルケース <https://titlecase.com>`_ を使用します。
つまり、タイトルの主要な単語はすべて大文字にしますが、冠詞、接続詞、前置詞はタイトルの最初でない限り、大文字にしません。

.. For example, the following are all correct:

例えば、次のようなものはすべて正しいです。

* Title Case for Headings
* For Headings Use Title Case
* Local and State Variable Names
* Order of Layout

Expand Contractions
-------------------

.. Use expanded contractions for words, for example:

単語では短縮形を利用しないでください。
例えば、

* 「Don't」ではなく「Do not」。
* 「Can't」ではなく「Can not」。

.. Active and Passive Voice

能動態と受動態
--------------

.. Active voice is typically recommended for tutorial style documentation as it
.. helps the reader understand who or what is performing a task. However, as the
.. Solidity documentation is a mixture of tutorials and reference content, passive
.. voice is sometimes more applicable.

チュートリアル形式のドキュメントでは、誰が、何がタスクを実行しているのかを読者が理解しやすいように、能動態（アクティブボイス）を推奨します。
しかし、Solidityのドキュメントは、チュートリアルとリファレンスコンテンツが混在しているため、受動態（パッシブボイス）の方が適している場合もあります。

.. As a summary:

要約すると

.. * Use passive voice for technical reference, for example language definition and internals of the Ethereum VM.

* 例えば、Ethereum VMの言語定義や内部構造などの技術的な参照には、受動態を使用します。

.. * Use active voice when describing recommendations on how to apply an aspect of Solidity.

* Solidityのある側面を適用するための推奨事項を説明する際には、能動態を使用します。

.. For example, the below is in passive voice as it specifies an aspect of Solidity:

例えば、以下はSolidityの側面を指定しているため、受動態になっています。

  Functions can be declared ``pure`` in which case they promise not to read from or modify the state.

.. For example, the below is in active voice as it discusses an application of Solidity:

..   When invoking the compiler, you can specify how to discover the first element of a path, and also path prefix remappings.

例えば、以下はSolidityのアプリケーションについて説明しているので、能動態になっています。

  When invoking the compiler, you can specify how to discover the first element of a path, and also path prefix remappings.

Common Terms
------------

.. * "Function parameters" and "return variables", not input and output parameters.

* 「function parameters」と「return variables」であり、input parametersとoutput parametersではありません。

.. Code Examples

コードの例
----------

.. A CI process tests all code block formatted code examples that begin with ``pragma solidity``, ``contract``, ``library``
.. or ``interface`` using the ``./test/cmdlineTests.sh`` script when you create a PR. If you are adding new code examples,
.. ensure they work and pass tests before creating the PR.

CIプロセスでは、PRを作成する際に ``./test/cmdlineTests.sh`` スクリプトを使用して ``pragma solidity`` 、 ``contract`` 、 ``library`` 、 ``interface`` で始まるコードブロック形式のコード例をすべてテストします。
新しいコード例を追加する場合は、PRを作成する前にそのコード例が動作し、テストに合格することを確認してください。

.. Ensure that all code examples begin with a ``pragma`` version that spans the largest where the contract code is valid.
.. For example ``pragma solidity >=0.4.0 <0.9.0;``.

すべてのコード例は、コントラクトコードが有効な最大の範囲をカバーする ``pragma`` バージョンで始まるようにします。
例えば、 ``pragma solidity >=0.4.0 <0.9.0;`` などとしてください。

ドキュメントのテストの実行
--------------------------

.. Make sure your contributions pass our documentation tests by running ``./docs/docs.sh`` that installs dependencies
.. needed for documentation and checks for any problems such as broken links or syntax issues.

ドキュメントに必要な依存関係をインストールし、リンク切れや構文の問題などの問題をチェックする ``./docs/docs.sh`` を実行することで、あなたの貢献が私たちのドキュメントテストに合格することを確認してください。

.. _solidity_language_design:

Solidityの言語設計
==================

.. To actively get involved in the language design process and to share your ideas concerning the future of Solidity,
.. please join the `Solidity forum <https://forum.soliditylang.org/>`_.

言語設計のプロセスに積極的に参加し、Solidityの将来に関するアイデアを共有するには、 `Solidityフォーラム <https://forum.soliditylang.org/>`_ に参加してください。

.. The Solidity forum serves as the place to propose and discuss new language features and their implementation in the early stages of ideation or modifications of existing features.

Solidityフォーラムは、新しい言語機能やその実装のアイデアの初期段階や、既存の機能の修正を提案し、議論する場として機能しています。

.. As soon as proposals get more tangible, their implementation will also be discussed in the `Solidity GitHub repository <https://github.com/ethereum/solidity>`_ in the form of issues.

提案が具体的になれば、その実現に向けて `SolidityのGitHubリポジトリ <https://github.com/ethereum/solidity>`_ でもイシューという形で議論されます。

.. In addition to the forum and issue discussions, we regularly host language design discussion calls in which selected topics, issues or feature implementations are debated in detail.
.. The invitation to those calls is shared via the forum.

フォーラムやイシューの議論に加えて、定期的に言語設計ディスカッションコールを開催し、特定のトピックや課題、機能の実装について詳細に議論しています。
これらのコールへの招待状は、フォーラムを通じて共有されます。

.. We are also sharing feedback surveys and other content that is relevant to language design in the forum.

また、フィードバックアンケートなど、言語設計に関連したコンテンツをフォーラムで共有しています。

.. If you want to know where the team is standing in terms or implementing new features, you can follow the implementation status in the `Solidity Github project <https://github.com/ethereum/solidity/projects/43>`_.
.. Issues in the design backlog need further specification and will either be discussed in a language design call or in a regular team call. You can
.. see the upcoming changes for the next breaking release by changing from the default branch (`develop`) to the `breaking branch <https://github.com/ethereum/solidity/tree/breaking>`_.

新機能の実装についてチームの状況を知りたい場合は、 `SolidityのGithubプロジェクト <https://github.com/ethereum/solidity/projects/43>`_ で実装状況を確認できます。
デザインバックログに登録されている問題は、さらに詳細な仕様が必要なため、言語デザインコールまたは通常のチームコールで議論されます。
デフォルトのブランチ（ `develop` ）から `breakingブランチ <https://github.com/ethereum/solidity/tree/breaking>`_ に変更することで、次のブレーキングリリースに向けた変更点を確認できます。

.. For ad-hoc cases and questions, you can reach out to us via the `Solidity-dev Gitter channel <https://gitter.im/ethereum/solidity-dev>`_ — a dedicated chatroom for conversations around the Solidity compiler and language development.

その場限りのケースや質問については、Solidityコンパイラや言語開発に関する会話のための専用チャットルームである  `Solidity-dev Gitter チャンネル <https://gitter.im/ethereum/solidity-dev>`_  を通じて連絡を取ることができます。

.. We are happy to hear your thoughts on how we can improve the language design process to be even more collaborative and transparent.

言語設計のプロセスをより協力的で透明性の高いものに改善するために、みなさんの意見をお聞かせください。
