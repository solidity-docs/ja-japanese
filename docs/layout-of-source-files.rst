**********************************
Solidityソースファイルのレイアウト
**********************************

ソースファイルには、任意の数の :ref:`コントラクト定義<contract_structure>` 、import_ 、 :ref:`pragma<pragma>` 、:ref:`using for<using-for>` ディレクティブと :ref:`struct<structs>` 、 :ref:`enum<enums>` 、 :ref:`function<functions>` 、 :ref:`error<errors>` 、 :ref:`constant variable<constants>` の定義を含めることができます。

.. index:: ! license, spdx

SPDXライセンス識別子
====================

スマートコントラクトの信頼性は、そのソースコードが利用可能であれば、より確立されます。
ソースコードを公開することは、著作権に関する法的な問題に常に触れることになるため、Solidityコンパイラでは、機械が解釈可能な `SPDXライセンス識別子（SPDX license identifier） <https://spdx.org>`_ の使用を推奨しています。
すべてのソースファイルは、そのライセンスを示すコメントで始まるべきです。

``// SPDX-License-Identifier: MIT``

コンパイラはライセンスが `SPDXで許可されたリスト <https://spdx.org/licenses/>`_ の一部であることを検証しませんが、供給された文字列は :ref:`bytecodeメタデータ <metadata>` に含まれます。

.. Note that ``UNLICENSED`` (no usage allowed, not present in SPDX license list) is different from ``UNLICENSE`` (grants all rights to everyone).
.. Solidity follows `the npm recommendation <https://docs.npmjs.com/cli/v7/configuring-npm/package-json#license>`_.

ライセンスを指定したくない場合や、ソースコードがオープンソースでない場合は、特別な値 ``UNLICENSED`` を使用してください。
``UNLICENSED`` （使用不可、SPDXライセンスリストに存在しない）は、 ``UNLICENSE`` （すべての権利をすべての人に与える）とは異なることに注意してください。
Solidity は `npm recommendation <https://docs.npmjs.com/cli/v7/configuring-npm/package-json#license>`_ に従っています。

もちろん、このコメントを提供することで、各ソースファイルに特定のライセンスヘッダーを記載しなければならないとか、オリジナルの著作権者に言及しなければならないといった、ライセンスに関する他の義務から解放されるわけではありません。

コメントは、ファイルレベルではファイルのどこにあってもコンパイラに認識されますが、ファイルの先頭に置くことをお勧めします。

SPDXライセンス識別子の使用方法の詳細は、 `SPDXのWebサイト <https://spdx.org/ids-how>`_ に記載されています。

.. index:: ! pragma

.. _pragma:

pragma
======

``pragma`` キーワードは、特定のコンパイラの機能やチェックを有効にするために使用されます。
pragmaディレクティブは、常にソースファイルに局所的に適用されるため、プロジェクト全体で有効にしたい場合は、すべてのファイルにpragmaを追加する必要があります。
他のファイルを :ref:`インポート<import>` した場合、そのファイルのpragmaは自動的にインポートしたファイルには適用されません。

.. index:: ! pragma;version

.. _version_pragma:

バージョンpragma
----------------

ソースファイルには、互換性のない変更が加えられる可能性のある将来のバージョンのコンパイラでのコンパイルを拒否するために、バージョンpragmaで注釈を付けることができます（また、そうすべきです）。
私たちはこれらの変更を最小限にとどめ、セマンティクスの変更がシンタックスの変更を必要とするような方法で導入するようにしていますが、これは必ずしも可能ではありません。
このため、少なくとも変更点を含むリリースについては、変更履歴に目を通すことをお勧めします。
これらのリリースには、常に ``0.x.0`` または ``x.0.0`` という形式のバージョンがあります。

バージョンpragmaは次のように使用されます: ``pragma solidity ^0.5.2;``。

上記の行を含むソースファイルは、バージョン0.5.2以前のコンパイラではコンパイルできず、バージョン0.6.0以降のコンパイラでも動作しません（この2番目の条件は ``^`` を使用することで追加されます）。
また、バージョン0.6.0以降のコンパイラでは動作しません。
コンパイラの正確なバージョンは固定されていないので、バグフィックスリリースも可能です。

コンパイラバージョンには、より複雑なルールを指定できますが、これらは `npm <https://docs.npmjs.com/cli/v6/using-npm/semver>`_ で使用されているのと同じ構文に従います。

.. note::

  バージョンpragmaを使用しても、コンパイラのバージョンを変更することはありません。
  また、コンパイラの機能を有効にしたり無効にしたりすることもありません。
  コンパイラに対して、そのバージョンがpragmaで要求されているものと一致するかどうかをチェックするように指示するだけです。
  一致しない場合、コンパイラはエラーを発行します。

.. index:: ! ABI coder, ! pragma; abicoder, pragma; ABIEncoderV2
.. _abi_coder:

ABIコーダーpragma
-----------------

``pragma abicoder v1`` または ``pragma abicoder v2`` を使用すると、ABIエンコーダおよびデコーダの2つの実装を選択できます。

.. Apart from supporting more types, it involves more extensive validation and safety checks, which may result in higher gas costs, but also heightened security.
.. It is considered non-experimental as of Solidity 0.6.0 and it is enabled by default starting with Solidity 0.8.0.
.. The old ABI coder can still be selected using ``pragma abicoder v1;``.

新しいABIコーダー（v2）は、任意にネストされた配列や構造体をエンコードおよびデコードできます。
より多くの型をサポートするだけでなく、より広範な検証と安全チェックを伴うため、ガスコストが高くなる可能性がありますが、セキュリティも強化されます。
Solidity 0.6.0の時点では非実験的とみなされ、Solidity 0.8.0からデフォルトで有効になりました。
古いABIコーダーは ``pragma abicoder v1;`` を使用して選択できます。

新しいエンコーダーがサポートする型のセットは、古いエンコーダーがサポートする型の厳密なスーパーセットです。
このエンコーダーを使用するコントラクトは、制限なしに使用しないコントラクトと相互作用できます。
逆は、 ``abicoder v2`` ではないコントラクトが、新しいエンコーダでのみサポートされている型のデコードを必要とするような呼び出しを行わない限り可能です。
コンパイラはこれを検知してエラーを出します。
コントラクトで ``abicoder v2`` を有効にするだけで、このエラーは解消されます。

.. note::

  このpragmaは、コードが最終的にどこに到達するかにかかわらず、このpragmaが有効になっているファイルで定義されたすべてのコードに適用されます。
  つまり、ソースファイルがABIコーダーv1でコンパイルするように選択されているコントラクトでも、他のコントラクトから継承することで新しいエンコーダを使用するコードを含むことができます。
  これは、新しい型が内部的にのみ使用され、外部の関数の署名に使用されない場合に許可されます。

.. note::

  Solidity 0.7.4までは、 ``pragma experimental ABIEncoderV2`` を使用してABIコーダーv2を選択できましたが、coder v1がデフォルトであるため、明示的に選択できませんでした。

.. index:: ! pragma; experimental
.. _experimental_pragma:

実験的pragma
------------

2つ目のpragmaは、実験的pragmaです。
これは、デフォルトではまだ有効になっていないコンパイラや言語の機能を有効にするために使用できます。
現在、以下の実験的pragmaがサポートされています。

.. index:: ! pragma; ABIEncoderV2

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

``pragma experimental SMTChecker;`` を使用する場合は、SMTソルバーへの問い合わせによって得られる追加の :ref:`safety warnings<formal_verification>` を取得します。
このコンポーネントは、Solidity言語のすべての機能をサポートしておらず、多くの警告を出力する可能性があります。
サポートされていない機能が報告された場合、解析が完全にはうまくいかない可能性があります。

.. index:: source file, ! import, module, source unit

.. _import:

他のソースファイルのインポート
==============================

シンタックスとセマンティクス
----------------------------

Solidityは、JavaScript（ES6以降）と同様に、コードをモジュール化するためのインポート文をサポートしています。
しかし、Solidityは `default export <https://developer.mozilla.org/en-US/docs/web/javascript/reference/statements/export#description>`_ の概念をサポートしていません。

グローバルレベルでは、次のような形式のインポート文を使用できます。

.. code-block:: solidity

    import "filename";

``filename`` の部分は、 *importパス* と呼ばれます。
この文は、"filename"からのすべてのグローバルシンボル（およびそこでインポートされたシンボル）を、現在のグローバルスコープにインポートします（ES6とは異なりますが、Solidityでは後方互換性があります）。
この形式は、予測できないほど名前空間を汚染するので、使用を推奨しません。
"filename"の中に新しいトップレベルのアイテムを追加すると、"filename"からこのようにインポートされたすべてのファイルに自動的に表示されます。
特定のシンボルを明示的にインポートする方が良いでしょう。

次の例では、 ``"filename"`` のすべてのグローバルシンボルをメンバーとする新しいグローバルシンボル ``symbolName`` を作成しています。

.. code-block:: solidity

    import * as symbolName from "filename";

と入力すると、すべてのグローバルシンボルが ``symbolName.symbol`` 形式で利用できるようになります。

この構文のバリエーションとして、ES6には含まれていませんが、便利なものがあります。

.. code-block:: solidity

  import "filename" as symbolName;

となっており、これは ``import * as symbolName from "filename";`` と同じです。

名前の衝突があった場合、インポート中にシンボルの名前を変更できます。
例えば、以下のコードでは、新しいグローバルシンボル ``alias`` と ``symbol2`` を作成し、それぞれ ``"filename"`` の内部から ``symbol1`` と ``symbol2`` を参照しています。

.. code-block:: solidity

    import {symbol1 as alias, symbol2} from "filename";

.. index:: virtual filesystem, source unit name, import; path, filesystem path, import callback, Remix IDE

インポートパス
--------------

すべてのプラットフォームで再現可能なビルドをサポートするために、Solidityコンパイラは、ソースファイルが保存されているファイルシステムの詳細を抽象化する必要があります。
このため、インポートパスはホストファイルシステム上のファイルを直接参照しません。
代わりに、コンパイラは内部データベース（ *バーチャルファイルシステム（virtual filesystem）* あるいは略して *VFS* ）を維持し、各ソースユニットに不透明で構造化されていない識別子である一意の *ソースユニット名* を割り当てます。
インポート文で指定されたインポートパスは、ソースユニット名に変換され、このデータベース内の対応するソースユニットを見つけるために使用されます。

:ref:`Standard JSON <compiler-api>`  APIを使用すると、すべてのソースファイルの名前と内容を、コンパイラの入力の一部として直接提供できます。
この場合、ソースユニット名は本当に任意です。
しかし、コンパイラが自動的にソースコードを見つけてVFSにロードしたい場合は、ソースユニット名を :ref:`import callback <import-callback>` が見つけられるように構造化する必要があります。
コマンドラインコンパイラを使用する場合、デフォルトのインポートコールバックはホストファイルシステムからのソースコードのロードのみをサポートしているため、ソースユニット名はパスでなければなりません。
環境によっては、より汎用性の高いカスタムコールバックを提供しています。
例えば、 `Remix IDE <https://remix.ethereum.org/>`_ は、 `HTTP、IPFS、SwarmのURLからファイルをインポートしたり、NPMレジストリのパッケージを直接参照したりできる <https://remix-ide.readthedocs.io/en/latest/import.html>`_ ものを提供しています。

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

  一行コメントは、UTF-8エンコーディングの任意のunicode行終端記号（LF、VF、FF、CR、NEL、LS、PS）で終了します。
  ターミネーターはコメントの後もソースコードの一部であるため、ASCIIシンボル（NEL、LS、PS）でない場合はパーサーエラーになります。

さらに、NatSpecコメントと呼ばれる別の種類のコメントがあり、その詳細は :ref:`style guide<style_guide_natspec>` に記載されています。
このコメントは、トリプルスラッシュ（ ``///`` ）またはダブルアスタリスクブロック（ ``/** ... */`` ）で記述され、関数宣言や文の上で使用されます。
