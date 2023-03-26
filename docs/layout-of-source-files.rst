**********************************
Solidityソースファイルのレイアウト
**********************************

<<<<<<< HEAD
ソースファイルには、任意の数の :ref:`コントラクト定義<contract_structure>` 、import_ ディレクティブ、 :ref:`pragmaディレクティブ<pragma>` と :ref:`struct<structs>` 、 :ref:`enum<enums>` 、 :ref:`function<functions>` 、 :ref:`error<errors>` 、 :ref:`constant variable<constants>` の定義を含めることができます。
=======
Source files can contain an arbitrary number of
:ref:`contract definitions<contract_structure>`, import_ ,
:ref:`pragma<pragma>` and :ref:`using for<using-for>` directives and
:ref:`struct<structs>`, :ref:`enum<enums>`, :ref:`function<functions>`, :ref:`error<errors>`
and :ref:`constant variable<constants>` definitions.
>>>>>>> english/develop

.. index:: ! license, spdx

SPDX License Identifier
=======================

<<<<<<< HEAD
スマートコントラクトの信頼性は、そのソースコードが利用可能であれば、より確立されます。
ソースコードを公開することは、著作権に関する法的な問題に常に触れることになるため、Solidityコンパイラでは、機械が解釈可能な `SPDX license identifiers <https://spdx.org>`_ の使用を推奨しています。
すべてのソースファイルは、そのライセンスを示すコメントで始まるべきです。
=======
Trust in smart contracts can be better established if their source code
is available. Since making source code available always touches on legal problems
with regards to copyright, the Solidity compiler encourages the use
of machine-readable `SPDX license identifiers <https://spdx.org>`_.
Every source file should start with a comment indicating its license:
>>>>>>> english/develop

``// SPDX-License-Identifier: MIT``

コンパイラはライセンスが `SPDXで許可されたリスト <https://spdx.org/licenses/>`_ の一部であることを検証しませんが、供給された文字列は :ref:`bytecodeメタデータ <metadata>` に含まれます。

<<<<<<< HEAD
ライセンスを指定したくない場合や、ソースコードがオープンソースでない場合は、特別な値 ``UNLICENSED`` を使用してください。
=======
If you do not want to specify a license or if the source code is
not open-source, please use the special value ``UNLICENSED``.
Note that ``UNLICENSED`` (no usage allowed, not present in SPDX license list)
is different from ``UNLICENSE`` (grants all rights to everyone).
Solidity follows `the npm recommendation <https://docs.npmjs.com/cli/v7/configuring-npm/package-json#license>`_.
>>>>>>> english/develop

もちろん、このコメントを提供することで、各ソースファイルに特定のライセンスヘッダーを記載しなければならないとか、オリジナルの著作権者に言及しなければならないといった、ライセンスに関する他の義務から解放されるわけではありません。

コメントは、ファイルレベルではファイルのどこにあってもコンパイラに認識されますが、ファイルの先頭に置くことをお勧めします。

.. More information about how to use SPDX license identifiers
.. can be found at the `SPDX website <https://spdx.org/ids-how>`_.

SPDXライセンス識別子の使用方法の詳細については、 `SPDXのWebサイト <https://spdx.org/ids-how>`_ に記載されています。

.. index:: ! pragma

.. _pragma:

Pragma
======

``pragma`` キーワードは、特定のコンパイラの機能やチェックを有効にするために使用されます。pragmaディレクティブは、常にソースファイルに局所的に適用されるため、プロジェクト全体で有効にしたい場合は、すべてのファイルにpragmaを追加する必要があります。他のファイルを :ref:`インポート<import>` した場合、そのファイルのPragmaは自動的にインポートしたファイルには適用されません。

.. index:: ! pragma;version

.. _version_pragma:

<<<<<<< HEAD
バージョンPragma
=======
Version Pragma
--------------

Source files can (and should) be annotated with a version pragma to reject
compilation with future compiler versions that might introduce incompatible
changes. We try to keep these to an absolute minimum and
introduce them in a way that changes in semantics also require changes
in the syntax, but this is not always possible. Because of this, it is always
a good idea to read through the changelog at least for releases that contain
breaking changes. These releases always have versions of the form
``0.x.0`` or ``x.0.0``.

The version pragma is used as follows: ``pragma solidity ^0.5.2;``

A source file with the line above does not compile with a compiler earlier than version 0.5.2,
and it also does not work on a compiler starting from version 0.6.0 (this
second condition is added by using ``^``). Because
there will be no breaking changes until version ``0.6.0``, you can
be sure that your code compiles the way you intended. The exact version of the
compiler is not fixed, so that bugfix releases are still possible.

It is possible to specify more complex rules for the compiler version,
these follow the same syntax used by `npm <https://docs.npmjs.com/cli/v6/using-npm/semver>`_.

.. note::
  Using the version pragma *does not* change the version of the compiler.
  It also *does not* enable or disable features of the compiler. It just
  instructs the compiler to check whether its version matches the one
  required by the pragma. If it does not match, the compiler issues
  an error.

.. index:: ! ABI coder, ! pragma; abicoder, pragma; ABIEncoderV2
.. _abi_coder:

ABI Coder Pragma
>>>>>>> english/develop
----------------

ソースファイルには、互換性のない変更が加えられる可能性のある将来のバージョンのコンパイラでのコンパイルを拒否するために、バージョンPragmaで注釈を付けることができます（また、そうすべきです）。私たちはこれらの変更を最小限にとどめ、セマンティクスの変更がシンタックスの変更を必要とするような方法で導入するようにしていますが、これは必ずしも可能ではありません。このため、少なくとも変更点を含むリリースについては、変更履歴に目を通すことをお勧めします。これらのリリースには、常に ``0.x.0`` または ``x.0.0`` という形式のバージョンがあります。

<<<<<<< HEAD
バージョンPragmaは次のように使用されます: ``pragma solidity ^0.5.2;``。
=======
The new ABI coder (v2) is able to encode and decode arbitrarily nested
arrays and structs. Apart from supporting more types, it involves more extensive
validation and safety checks, which may result in higher gas costs, but also heightened
security. It is considered
non-experimental as of Solidity 0.6.0 and it is enabled by default starting
with Solidity 0.8.0. The old ABI coder can still be selected using ``pragma abicoder v1;``.
>>>>>>> english/develop

上記の行を含むソースファイルは、バージョン0.5.2以前のコンパイラではコンパイルできず、バージョン0.6.0以降のコンパイラでも動作しません（この2番目の条件は ``^`` を使用することで追加されます）。また、バージョン0.6.0以降のコンパイラでは動作しません。コンパイラの正確なバージョンは固定されていないので、バグフィックスリリースも可能です。

コンパイラバージョンには、より複雑なルールを指定できますが、これらは `npm <https://docs.npmjs.com/cli/v6/using-npm/semver>`_ で使用されているのと同じ構文に従います。

.. note::

  バージョンPragmaを使用しても、コンパイラのバージョンを変更することはありません。
  また、コンパイラの機能を有効にしたり無効にしたりすることもありません。
  コンパイラに対して、そのバージョンがPragmaで要求されているものと一致するかどうかをチェックするように指示するだけです。
  一致しない場合、コンパイラはエラーを発行します。

ABIコーダーPragma
-----------------

``pragma abicoder v1`` または ``pragma abicoder v2`` を使用すると、ABIエンコーダおよびデコーダの2つの実装を選択できます。

新しいABIコーダー（v2）は、任意にネストされた配列や構造体をエンコードおよびデコードできます。
最適なコードを生成できない可能性があり、古いエンコーダほど多くのテストが行われていませんが、Solidity 0.6.0の時点では非実験的なものと考えられています。
ただし、 ``pragma abicoder v2;`` を使って明示的に有効にする必要があります。
Solidity 0.8.0からはデフォルトで有効になりますので、 ``pragma abicoder v1;`` を使って古いコーダーを選択するという選択肢もあります。

新しいエンコーダーがサポートする型のセットは、古いエンコーダーがサポートする型の厳密なスーパーセットです。このエンコーダーを使用するコントラクトは、制限なしに使用しないコントラクトと相互作用できます。逆は、 ``abicoder v2`` ではないコントラクトが、新しいエンコーダでのみサポートされている型のデコードを必要とするような呼び出しを行わない限り可能です。コンパイラはこれを検知してエラーを出します。コントラクトで ``abicoder v2`` を有効にするだけで、このエラーは解消されます。

.. note::

  このPragmaは、コードが最終的にどこに到達するかにかかわらず、このPragmaが有効になっているファイルで定義されたすべてのコードに適用されます。つまり、ソースファイルがABIコーダーv1でコンパイルするように選択されているコントラクトでも、他のコントラクトから継承することで新しいエンコーダを使用するコードを含むことができます。これは、新しい型が内部的にのみ使用され、外部の関数の署名に使用されない場合に許可されます。

.. note::

  Solidity 0.7.4までは、 ``pragma experimental ABIEncoderV2`` を使用してABIコーダーv2を選択できましたが、coder v1がデフォルトであるため、明示的に選択できませんでした。

.. index:: ! pragma; experimental
.. _experimental_pragma:

実験的Pragma
------------

<<<<<<< HEAD
2つ目のPragmaは、実験的Pragmaです。これは、デフォルトではまだ有効になっていないコンパイラや言語の機能を有効にするために使用できます。現在、以下の実験的Pragmaがサポートされています。
=======
.. index:: ! pragma; ABIEncoderV2
>>>>>>> english/develop

ABIEncoderV2
~~~~~~~~~~~~

ABIコーダーv2は実験的なものではなくなったので、Solidity 0.7.4から ``pragma abicoder v2`` （上記参照）で選択できるようになりました。

.. index:: ! pragma; SMTChecker
.. _smt_checker:

SMTChecker
~~~~~~~~~~

このコンポーネントは、Solidityコンパイラのビルド時に有効にする必要があるため、すべてのSolidityバイナリで利用できるわけではありません。
:ref:`build instructions<smt_solvers_build>` では、このオプションを有効にする方法を説明しています。
ほとんどのバージョンのUbuntu PPAリリースでは有効になっていますが、Dockerイメージ、Windowsバイナリ、静的ビルドのLinuxバイナリでは有効になっていません。
SMTソルバーがローカルにインストールされていて、ブラウザではなくnode経由でsolc-jsを実行している場合、 `smtCallback <https://github.com/ethereum/solc-js#example-usage-with-smtsolver-callback>`_ 経由でsolc-jsを有効にできます。

``pragma experimental SMTChecker;`` を使用する場合は、SMTソルバーへの問い合わせによって得られる追加の :ref:`safety warnings<formal_verification>` を取得します。このコンポーネントは、Solidity言語のすべての機能をサポートしておらず、多くの警告を出力する可能性があります。サポートされていない機能が報告された場合、解析が完全にはうまくいかない可能性があります。

.. index:: source file, ! import, module, source unit

.. _import:

他のソースファイルのインポート
==============================

シンタックスとセマンティクス
----------------------------

<<<<<<< HEAD
Solidityは、JavaScript（ES6以降）と同様に、コードをモジュール化するためのimport文をサポートしています。しかし、Solidityは `default export <https://developer.mozilla.org/en-US/docs/web/javascript/reference/statements/export#Description>`_ の概念をサポートしていません。
=======
Solidity supports import statements to help modularise your code that
are similar to those available in JavaScript
(from ES6 on). However, Solidity does not support the concept of
a `default export <https://developer.mozilla.org/en-US/docs/web/javascript/reference/statements/export#description>`_.
>>>>>>> english/develop

グローバルレベルでは、次のような形式のimport文を使用できます。

.. code-block:: solidity

    import "filename";

``filename`` の部分は、 *importパス* と呼ばれる。このステートメントは、"filename"からのすべてのグローバルシンボル（およびそこでインポートされたシンボル）を、現在のグローバルスコープにインポートします（ES6とは異なりますが、Solidityでは後方互換性があります）。この形式は、予測できないほど名前空間を汚染するので、使用を推奨しません。"filename"の中に新しいトップレベルのアイテムを追加すると、"filename"からこのようにインポートされたすべてのファイルに自動的に表示されます。特定のシンボルを明示的にインポートする方が良いでしょう。

次の例では、 ``"filename"`` のすべてのグローバルシンボルをメンバーとする新しいグローバルシンボル ``symbolName`` を作成しています。

.. code-block:: solidity

    import * as symbolName from "filename";

と入力すると、すべてのグローバルシンボルが ``symbolName.symbol`` 形式で利用できるようになります。

この構文のバリエーションとして、ES6には含まれていませんが、便利なものがあります。

.. code-block:: solidity

  import "filename" as symbolName;

となっており、これは ``import * as symbolName from "filename";`` と同じです。

名前の衝突があった場合、インポート中にシンボルの名前を変更できます。例えば、以下のコードでは、新しいグローバルシンボル ``alias`` と ``symbol2`` を作成し、それぞれ ``"filename"`` の内部から ``symbol1`` と ``symbol2`` を参照しています。

.. code-block:: solidity

    import {symbol1 as alias, symbol2} from "filename";

.. index:: virtual filesystem, source unit name, import; path, filesystem path, import callback, Remix IDE

インポートパス
--------------

すべてのプラットフォームで再現可能なビルドをサポートするために、Solidityコンパイラは、ソースファイルが保存されているファイルシステムの詳細を抽象化する必要があります。このため、インポートパスはホストファイルシステム上のファイルを直接参照しません。代わりに、コンパイラは内部データベース（ *バーチャルファイルシステム（virtual filesystem）* あるいは略して *VFS* ）を維持し、各ソースユニットに不透明で構造化されていない識別子である一意の *ソースユニット名* を割り当てます。import文で指定されたインポートパスは、ソースユニット名に変換され、このデータベース内の対応するソースユニットを見つけるために使用されます。

:ref:`Standard JSON <compiler-api>`  APIを使用すると、すべてのソースファイルの名前と内容を、コンパイラの入力の一部として直接提供できます。この場合、ソースユニット名は本当に任意です。しかし、コンパイラが自動的にソースコードを見つけてVFSにロードしたい場合は、ソースユニット名を :ref:`import callback <import-callback>` が見つけられるように構造化する必要があります。コマンドラインコンパイラを使用する場合、デフォルトのインポートコールバックはホストファイルシステムからのソースコードのロードのみをサポートしているため、ソースユニット名はパスでなければなりません。環境によっては、より汎用性の高いカスタムコールバックを提供しています。例えば、 `Remix IDE <https://remix.ethereum.org/>`_ は、 `HTTP、IPFS、SwarmのURLからファイルをインポートしたり、NPMレジストリのパッケージを直接参照したりできる <https://remix-ide.readthedocs.io/en/latest/import.html>`_ ものを提供しています。

バーチャルファイルシステムとコンパイラが使用するパス解決ロジックの完全な説明は、 :ref:`Path Resolution <path-resolution>` を参照してください。

.. index:: ! comment, natspec

コメント
========

一行コメント (``//``) と複数行コメント (``/*...*/``) が使用可能です。

.. code-block:: solidity

    // これは一行コメントです。

    /*
    これは
    複数行コメントです。
    */

.. note::

  一行コメントは、UTF-8エンコーディングの任意のunicode行終端記号（LF、VF、FF、CR、NEL、LS、PS）で終了します。ターミネーターはコメントの後もソースコードの一部であるため、ASCIIシンボル（NEL、LS、PS）でない場合はパーサーエラーになります。

さらに、NatSpecコメントと呼ばれる別の種類のコメントがあり、その詳細は :ref:`style guide<style_guide_natspec>` に記載されています。このコメントは、トリプルスラッシュ（ ``///`` ）またはダブルアスタリスクブロック（ ``/** ... */`` ）で記述され、関数宣言やステートメントの上で使用されます。
