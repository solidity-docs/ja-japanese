********************************
Layout of a Solidity Source File
********************************

<<<<<<< HEAD
.. Source files can contain an arbitrary number of
.. :ref:`contract definitions<contract_structure>`, import_ directives,
.. :ref:`pragma directives<pragma>` and
.. :ref:`struct<structs>`, :ref:`enum<enums>`, :ref:`function<functions>`, :ref:`error<errors>`
.. and :ref:`constant variable<constants>` definitions.

ソースファイルには、任意の数の :ref:`contract definitions<contract_structure>` 、import_ディレクティブ、 :ref:`pragma directives<pragma>` と :ref:`struct<structs>` 、 :ref:`enum<enums>` 、 :ref:`function<functions>` 、 :ref:`error<errors>` 、 :ref:`constant variable<constants>` の定義を含めることができます。
=======
Source files can contain an arbitrary number of
:ref:`contract definitions<contract_structure>`, import_ ,
:ref:`pragma<pragma>` and :ref:`using for<using-for>` directives and
:ref:`struct<structs>`, :ref:`enum<enums>`, :ref:`function<functions>`, :ref:`error<errors>`
and :ref:`constant variable<constants>` definitions.
>>>>>>> 800088e38b5835ebdc71e9ba5299a70a5accd7c2

.. index:: ! license, spdx

SPDX License Identifier
=======================

<<<<<<< HEAD
.. Trust in smart contract can be better established if their source code
.. is available. Since making source code available always touches on legal problems
.. with regards to copyright, the Solidity compiler encourages the use
.. of machine-readable `SPDX license identifiers <https://spdx.org>`_.
.. Every source file should start with a comment indicating its license:

スマートコントラクトの信頼性は、そのソースコードが利用可能であれば、より確立されます。ソースコードを公開することは、著作権に関する法的な問題に常に触れることになるため、Solidityコンパイラでは、機械可読な `SPDX license identifiers <https://spdx.org>`_ の使用を推奨しています。すべてのソースファイルは、そのライセンスを示すコメントで始まるべきです。

.. ``// SPDX-License-Identifier: MIT``
=======
Trust in smart contracts can be better established if their source code
is available. Since making source code available always touches on legal problems
with regards to copyright, the Solidity compiler encourages the use
of machine-readable `SPDX license identifiers <https://spdx.org>`_.
Every source file should start with a comment indicating its license:
>>>>>>> 800088e38b5835ebdc71e9ba5299a70a5accd7c2

``// SPDX-License-Identifier: MIT``

.. The compiler does not validate that the license is part of the
.. `list allowed by SPDX <https://spdx.org/licenses/>`_, but
.. it does include the supplied string in the :ref:`bytecode metadata <metadata>`.

<<<<<<< HEAD
コンパイラはライセンスが `list allowed by SPDX <https://spdx.org/licenses/>`_ の一部であることを検証しませんが、供給された文字列は :ref:`bytecode metadata <metadata>` に含まれます。
=======
If you do not want to specify a license or if the source code is
not open-source, please use the special value ``UNLICENSED``.
Note that ``UNLICENSED`` (no usage allowed, not present in SPDX license list)
is different from ``UNLICENSE`` (grants all rights to everyone).
Solidity follows `the npm recommendation <https://docs.npmjs.com/cli/v7/configuring-npm/package-json#license>`_.
>>>>>>> 800088e38b5835ebdc71e9ba5299a70a5accd7c2

.. If you do not want to specify a license or if the source code is
.. not open-source, please use the special value ``UNLICENSED``.

ライセンスを指定したくない場合や、ソースコードがオープンソースでない場合は、特別な値 ``UNLICENSED`` を使用してください。

.. Supplying this comment of course does not free you from other
.. obligations related to licensing like having to mention
.. a specific license header in each source file or the
.. original copyright holder.

もちろん、このコメントを提供することで、各ソースファイルに特定のライセンスヘッダーを記載しなければならないとか、オリジナルの著作権者に言及しなければならないといった、ライセンスに関する他の義務から解放されるわけではありません。

.. The comment is recognized by the compiler anywhere in the file at the
.. file level, but it is recommended to put it at the top of the file.

コメントは、ファイルレベルではファイルのどこにあってもコンパイラに認識されますが、ファイルの先頭に置くことをお勧めします。

.. More information about how to use SPDX license identifiers
.. can be found at the `SPDX website <https://spdx.org/ids-how>`_.

SPDXライセンス識別子の使用方法の詳細については、 `SPDX website <https://spdx.org/ids-how>`_ .

.. index:: ! pragma

.. _pragma:

Pragmas
=======

.. The ``pragma`` keyword is used to enable certain compiler features
.. or checks. A pragma directive is always local to a source file, so
.. you have to add the pragma to all your files if you want to enable it
.. in your whole project. If you :ref:`import<import>` another file, the pragma
.. from that file does *not* automatically apply to the importing file.

``pragma`` キーワードは、特定のコンパイラの機能やチェックを有効にするために使用されます。pragmaディレクティブは、常にソースファイルに局所的に適用されるため、プロジェクト全体で有効にしたい場合は、すべてのファイルにpragmaを追加する必要があります。他のファイルを :ref:`import<import>` した場合、そのファイルのプラグマは自動的にインポートしたファイルには適用されません。

.. index:: ! pragma, version

.. _version_pragma:

Version Pragma
--------------

.. Source files can (and should) be annotated with a version pragma to reject
.. compilation with future compiler versions that might introduce incompatible
.. changes. We try to keep these to an absolute minimum and
.. introduce them in a way that changes in semantics also require changes
.. in the syntax, but this is not always possible. Because of this, it is always
.. a good idea to read through the changelog at least for releases that contain
.. breaking changes. These releases always have versions of the form
.. ``0.x.0`` or ``x.0.0``.

ソースファイルには、互換性のない変更が加えられる可能性のある将来のバージョンのコンパイラでのコンパイルを拒否するために、バージョン・プラグマで注釈を付けることができます（また、そうすべきです）。私たちはこれらの変更を最小限にとどめ、セマンティクスの変更がシンタックスの変更を必要とするような方法で導入するようにしていますが、これは必ずしも可能ではありません。このため、少なくとも変更点を含むリリースについては、変更履歴に目を通すことをお勧めします。これらのリリースには、常に ``0.x.0`` または ``x.0.0`` という形式のバージョンがあります。

.. The version pragma is used as follows: ``pragma solidity ^0.5.2;``

バージョンのプラグマは以下のように使用されます。 ``pragma solidity ^0.5.2;``

.. A source file with the line above does not compile with a compiler earlier than version 0.5.2,
.. and it also does not work on a compiler starting from version 0.6.0 (this
.. second condition is added by using ``^``). Because
.. there will be no breaking changes until version ``0.6.0``, you can
.. be sure that your code compiles the way you intended. The exact version of the
.. compiler is not fixed, so that bugfix releases are still possible.

上記の行を含むソースファイルは、バージョン0.5.2以前のコンパイラではコンパイルできず、バージョン0.6.0以降のコンパイラでも動作しません（この2番目の条件は ``^`` を使用することで追加されます）。また、バージョン0.6.0以降のコンパイラでは動作しません。コンパイラの正確なバージョンは固定されていないので、バグフィックス・リリースも可能です。

.. It is possible to specify more complex rules for the compiler version,
.. these follow the same syntax used by `npm <https://docs.npmjs.com/cli/v6/using-npm/semver>`_.

コンパイラー・バージョンには、より複雑なルールを指定できますが、これらは `npm <https://docs.npmjs.com/cli/v6/using-npm/semver>`_ で使用されているのと同じ構文に従います。

.. .. note::

..   Using the version pragma *does not* change the version of the compiler.
..   It also *does not* enable or disable features of the compiler. It just
..   instructs the compiler to check whether its version matches the one
..   required by the pragma. If it does not match, the compiler issues
..   an error.

.. note::

  versionプラグマを使用しても、コンパイラーのバージョンを変更することはありません。   また、コンパイラーの機能を有効にしたり無効にしたりすることもありません。コンパイラに対して、そのバージョンがプラグマで要求されているものと一致するかどうかをチェックするように指示するだけです。一致しない場合、コンパイラはエラーを発行します。

ABI Coder Pragma
----------------

.. By using ``pragma abicoder v1`` or ``pragma abicoder v2`` you can
.. select between the two implementations of the ABI encoder and decoder.

``pragma abicoder v1`` または ``pragma abicoder v2`` を使用すると、ABIエンコーダおよびデコーダの2つの実装を選択できます。

.. The new ABI coder (v2) is able to encode and decode arbitrarily nested
.. arrays and structs. It might produce less optimal code and has not
.. received as much testing as the old encoder, but is considered
.. non-experimental as of Solidity 0.6.0. You still have to explicitly
.. activate it using ``pragma abicoder v2;``. Since it will be
.. activated by default starting from Solidity 0.8.0, there is the option to select
.. the old coder using ``pragma abicoder v1;``.

新しい ABI コーダー (v2) は、任意にネストされた配列や構造体をエンコードおよびデコードできます。
最適なコードを生成できない可能性があり、古いエンコーダほど多くのテストが行われていませんが、Solidity 0.6.0の時点では非実験的なものと考えられています。
ただし、 ``pragma abicoder v2;`` を使って明示的に有効にする必要があります。
Solidity 0.8.0からはデフォルトで有効になりますので、 ``pragma abicoder v1;`` を使って古いコーダーを選択するという選択肢もあります。

.. The set of types supported by the new encoder is a strict superset of
.. the ones supported by the old one. Contracts that use it can interact with ones
.. that do not without limitations. The reverse is possible only as long as the
.. non-``abicoder v2`` contract does not try to make calls that would require
.. decoding types only supported by the new encoder. The compiler can detect this
.. and will issue an error. Simply enabling ``abicoder v2`` for your contract is
.. enough to make the error go away.

新しいエンコーダーがサポートするタイプのセットは、古いエンコーダーがサポートするタイプの厳密なスーパーセットです。このエンコーダーを使用するコントラクトは、制限なしに使用しないコントラクトと相互作用できます。逆は、 ``abicoder v2`` ではないコントラクトが、新しいエンコーダでのみサポートされている型のデコードを必要とするような呼び出しを行わない限り可能です。コンパイラはこれを検知してエラーを出します。コントラクトで ``abicoder v2`` を有効にするだけで、このエラーは解消されます。

.. .. note::

..   This pragma applies to all the code defined in the file where it is activated,
..   regardless of where that code ends up eventually. This means that a contract
..   whose source file is selected to compile with ABI coder v1
..   can still contain code that uses the new encoder
..   by inheriting it from another contract. This is allowed if the new types are only
..   used internally and not in external function signatures.

.. note::

  このプラグマは、コードが最終的にどこに到達するかにかかわらず、このプラグマが有効になっているファイルで定義されたすべてのコードに適用されます。つまり、ソースファイルがABI coder v1でコンパイルするように選択されているコントラクトでも、他のコントラクトから継承することで新しいエンコーダを使用するコードを含むことができます。これは、新しい型が内部的にのみ使用され、外部の関数の署名に使用されない場合に許可されます。

.. .. note::

..   Up to Solidity 0.7.4, it was possible to select the ABI coder v2
..   by using ``pragma experimental ABIEncoderV2``, but it was not possible
..   to explicitly select coder v1 because it was the default.

.. note::

  Solidity 0.7.4までは、 ``pragma experimental ABIEncoderV2`` を使用してABI coder v2を選択できましたが、coder v1がデフォルトであるため、明示的に選択できませんでした。

.. index:: ! pragma, experimental

.. _experimental_pragma:

Experimental Pragma
-------------------

.. The second pragma is the experimental pragma. It can be used to enable
.. features of the compiler or language that are not yet enabled by default.
.. The following experimental pragmas are currently supported:

2つ目のプラグマは、実験的なプラグマです。これは、デフォルトではまだ有効になっていないコンパイラや言語の機能を有効にするために使用できます。現在、以下の実験的プラグマがサポートされています。

ABIEncoderV2
~~~~~~~~~~~~

.. Because the ABI coder v2 is not considered experimental anymore,
.. it can be selected via ``pragma abicoder v2`` (please see above)
.. since Solidity 0.7.4.

ABI coder v2は実験的なものではなくなったので、Solidity 0.7.4から ``pragma abicoder v2`` （上記参照）で選択できるようになりました。

.. _smt_checker:

SMTChecker
~~~~~~~~~~

.. This component has to be enabled when the Solidity compiler is built
.. and therefore it is not available in all Solidity binaries.
.. The :ref:`build instructions<smt_solvers_build>` explain how to activate this option.
.. It is activated for the Ubuntu PPA releases in most versions,
.. but not for the Docker images, Windows binaries or the
.. statically-built Linux binaries. It can be activated for solc-js via the
.. `smtCallback <https://github.com/ethereum/solc-js#example-usage-with-smtsolver-callback>`_ if you have an SMT solver
.. installed locally and run solc-js via node (not via the browser).

このコンポーネントは、Solidityコンパイラのビルド時に有効にする必要があるため、すべてのSolidityバイナリで利用できるわけではありません。 :ref:`build instructions<smt_solvers_build>` では、このオプションを有効にする方法を説明しています。ほとんどのバージョンのUbuntu PPAリリースでは有効になっていますが、Dockerイメージ、Windowsバイナリ、スタティックビルドのLinuxバイナリでは有効になっていません。SMTソルバーがローカルにインストールされていて、ブラウザではなくnode経由でsolc-jsを実行している場合、 `smtCallback <https://github.com/ethereum/solc-js#example-usage-with-smtsolver-callback>`_ 経由でsolc-jsを有効にできます。

.. If you use ``pragma experimental SMTChecker;``, then you get additional
.. :ref:`safety warnings<formal_verification>` which are obtained by querying an
.. SMT solver.
.. The component does not yet support all features of the Solidity language and
.. likely outputs many warnings. In case it reports unsupported features, the
.. analysis may not be fully sound.

``pragma experimental SMTChecker;`` を使用する場合は、SMTソルバーへの問い合わせによって得られる追加の :ref:`safety warnings<formal_verification>` を取得します。このコンポーネントは、Solidity言語のすべての機能をサポートしておらず、多くの警告を出力する可能性があります。サポートされていない機能が報告された場合、解析が完全にはうまくいかない可能性があります。

.. index:: source file, ! import, module, source unit

.. _import:

Importing other Source Files
============================

Syntax and Semantics
--------------------

.. Solidity supports import statements to help modularise your code that
.. are similar to those available in JavaScript
.. (from ES6 on). However, Solidity does not support the concept of
.. a `default export <https://developer.mozilla.org/en-US/docs/web/javascript/reference/statements/export#Description>`_.

Solidityは、JavaScript（ES6以降）と同様に、コードをモジュール化するためのimport文をサポートしています。しかし、Solidityは `default export <https://developer.mozilla.org/en-US/docs/web/javascript/reference/statements/export#Description>`_ の概念をサポートしていません。

.. At a global level, you can use import statements of the following form:

グローバルレベルでは、次のような形式のimport文を使用できます。

.. code-block:: solidity

    import "filename";

.. The ``filename`` part is called an *import path*.
.. This statement imports all global symbols from "filename" (and symbols imported there) into the
.. current global scope (different than in ES6 but backwards-compatible for Solidity).
.. This form is not recommended for use, because it unpredictably pollutes the namespace.
.. If you add new top-level items inside "filename", they automatically
.. appear in all files that import like this from "filename". It is better to import specific
.. symbols explicitly.

``filename`` の部分は、 *import path* と呼ばれる。このステートメントは、"filename"からのすべてのグローバルシンボル（およびそこでインポートされたシンボル）を、現在のグローバルスコープにインポートします（ES6とは異なりますが、Solidityでは後方互換性があります）。この形式は、予測できないほど名前空間を汚染するので、使用を推奨しません。"filename"の中に新しいトップレベルのアイテムを追加すると、"filename"からこのようにインポートされたすべてのファイルに自動的に表示されます。特定のシンボルを明示的にインポートする方が良いでしょう。

.. The following example creates a new global symbol ``symbolName`` whose members are all
.. the global symbols from ``"filename"``:

次の例では、 ``"filename"`` のすべてのグローバルシンボルをメンバーとする新しいグローバルシンボル ``symbolName`` を作成しています。

.. code-block:: solidity

    import * as symbolName from "filename";

.. which results in all global symbols being available in the format ``symbolName.symbol``.

と入力すると、すべてのグローバルシンボルが ``symbolName.symbol`` 形式で利用できるようになります。

.. A variant of this syntax that is not part of ES6, but possibly useful is:

この構文のバリエーションとして、ES6には含まれていませんが、便利なものがあります。

.. code-block:: solidity

  import "filename" as symbolName;

.. which is equivalent to ``import * as symbolName from "filename";``.

となっており、これは ``import * as symbolName from "filename";`` と同じです。

.. If there is a naming collision, you can rename symbols while importing. For example,
.. the code below creates new global symbols ``alias`` and ``symbol2`` which reference
.. ``symbol1`` and ``symbol2`` from inside ``"filename"``, respectively.

名前の衝突があった場合、インポート中にシンボルの名前を変更できます。例えば、以下のコードでは、新しいグローバルシンボル ``alias`` と ``symbol2`` を作成し、それぞれ ``"filename"`` の内部から ``symbol1`` と ``symbol2`` を参照しています。

.. code-block:: solidity

    import {symbol1 as alias, symbol2} from "filename";

.. index:: virtual filesystem, source unit name, import; path, filesystem path, import callback, Remix IDE

Import Paths
------------

.. In order to be able to support reproducible builds on all platforms, the Solidity compiler has to
.. abstract away the details of the filesystem where source files are stored.
.. For this reason import paths do not refer directly to files in the host filesystem.
.. Instead the compiler maintains an internal database (*virtual filesystem* or *VFS* for short) where
.. each source unit is assigned a unique *source unit name* which is an opaque and unstructured identifier.
.. The import path specified in an import statement is translated into a source unit name and used to
.. find the corresponding source unit in this database.

すべてのプラットフォームで再現可能なビルドをサポートするために、Solidityコンパイラは、ソースファイルが保存されているファイルシステムの詳細を抽象化する必要があります。このため、インポート・パスはホスト・ファイルシステム上のファイルを直接参照しません。代わりに、コンパイラは内部データベース（*virtual filesystem*または*VFS*）を維持し、各ソース・ユニットに不透明で構造化されていない識別子である一意の*source unit name*を割り当てます。import文で指定されたインポート・パスは、ソース・ユニット名に変換され、このデータベース内の対応するソース・ユニットを見つけるために使用されます。

.. Using the :ref:`Standard JSON <compiler-api>` API it is possible to directly provide the names and
.. content of all the source files as a part of the compiler input.
.. In this case source unit names are truly arbitrary.
.. If, however, you want the compiler to automatically find and load source code into the VFS, your
.. source unit names need to be structured in a way that makes it possible for an :ref:`import callback
.. <import-callback>` to locate them.
.. When using the command-line compiler the default import callback supports only loading source code
.. from the host filesystem, which means that your source unit names must be paths.
.. Some environments provide custom callbacks that are more versatile.
.. For example the `Remix IDE <https://remix.ethereum.org/>`_ provides one that
.. lets you `import files from HTTP, IPFS and Swarm URLs or refer directly to packages in NPM registry
.. <https://remix-ide.readthedocs.io/en/latest/import.html>`_.

:ref:`Standard JSON <compiler-api>`  APIを使用すると、すべてのソース・ファイルの名前と内容を、コンパイラの入力の一部として直接提供できます。この場合、ソース・ユニット名は本当に任意です。しかし、コンパイラが自動的にソース・コードを見つけてVFSにロードしたい場合は、ソース・ユニット名を :ref:`import callback <import-callback>` が見つけられるように構造化する必要があります。コマンドライン・コンパイラを使用する場合、デフォルトのインポート・コールバックはホスト・ファイルシステムからのソース・コードのロードのみをサポートしているため、ソース・ユニット名はパスでなければなりません。環境によっては、より汎用性の高いカスタムコールバックを提供しています。例えば、 `Remix IDE <https://remix.ethereum.org/>`_ では、 `import files from HTTP, IPFS and Swarm URLs or refer directly to packages in NPM registry <https://remix-ide.readthedocs.io/en/latest/import.html>`_ .

.. For a complete description of the virtual filesystem and the path resolution logic used by the
.. compiler see :ref:`Path Resolution <path-resolution>`.

仮想ファイルシステムとコンパイラーが使用するパス解決ロジックの完全な説明は、 :ref:`Path Resolution <path-resolution>` を参照してください。

.. index:: ! comment, natspec

Comments
========

Single-line comments (``//``) and multi-line comments (``/*...*/``) are possible.

.. code-block:: solidity

    // This is a single-line comment.

    /*
    This is a
    multi-line comment.
    */

.. .. note::

..   A single-line comment is terminated by any unicode line terminator
..   (LF, VF, FF, CR, NEL, LS or PS) in UTF-8 encoding. The terminator is still part of
..   the source code after the comment, so if it is not an ASCII symbol
..   (these are NEL, LS and PS), it will lead to a parser error.

.. note::

  1 行のコメントは、UTF-8 エンコーディングの任意の unicode 行終端記号（LF、VF、FF、CR、NEL、LS、PS）で終了します。ターミネーターはコメントの後もソースコードの一部であるため、ASCIIシンボル（NEL、LS、PS）でない場合はパーサーエラーになります。

.. Additionally, there is another type of comment called a NatSpec comment,
.. which is detailed in the :ref:`style guide<style_guide_natspec>`. They are written with a
.. triple slash (``///``) or a double asterisk block (``/** ... */``) and
.. they should be used directly above function declarations or statements.
.. 

さらに、NatSpecコメントと呼ばれる別の種類のコメントがあり、その詳細は :ref:`style guide<style_guide_natspec>` に記載されています。このコメントは、トリプルスラッシュ（ ``///`` ）またはダブルアスタリスクブロック（ ``/** ... */`` ）で記述され、関数宣言やステートメントの直上で使用されます。
