.. index:: ! installing

.. _installing-solidity:

################################
Solidityコンパイラのインストール
################################

バージョニング
==============

.. In addition, patch-level releases with major release 0 (i.e. 0.x.y) will not contain breaking changes.
.. That means code that compiles with version 0.x.y can be expected to compile with 0.x.z where z > y.

Solidityのバージョンは `セマンティックバージョニング <https://semver.org>`_ に従っています。
さらに、メジャーリリース0（つまり0.x.y）のパッチレベルのリリースには、破壊的な変更が含まれません。
つまり、バージョン0.x.yでコンパイルされたコードは、0.x.z（z > y）でコンパイルされることが期待できます。

.. In addition to releases, we provide **nightly development builds** to make it easy for developers to try out upcoming features and provide early feedback.
.. Note, however, that while the nightly builds are usually very stable, they contain bleeding-edge code from the development branch and are not guaranteed to be always working.
.. Despite our best efforts, they might contain undocumented and/or broken changes that will not become a part of an actual release.
.. They are not meant for production use.

リリースに加え、 **nightly development builds** を提供することで、開発者が簡単に次期機能を試し、早期にフィードバックを提供できるようにしています。
ただし、ナイトリービルドは通常非常に安定していますが、開発ブランチからの最先端のコードを含んでおり、常に動作することを保証するものではないことに注意してください。
私たちの最善の努力にもかかわらず、文書化されていない、あるいは破壊的変更が含まれている可能性があり、実際のリリースの一部にはなりません。
また、本番環境での使用は想定していません。

.. When deploying contracts, you should use the latest released version of Solidity.
.. This is because breaking changes, as well as new features and bug fixes are introduced regularly.
.. We currently use a 0.x version number `to indicate this fast pace of change <https://semver.org/#spec-item-4>`_.

コントラクトをデプロイする場合は、Solidityの最新リリースバージョンを使用する必要があります。
これは、新しい機能やバグ修正だけでなく、破壊的な変更が定期的に導入されるからです。
現在、0.xのバージョン番号を使用していますが、これは `この速いペースでの変更を示すため <https://semver.org/#spec-item-4>`_ です。

Remix
=====

*小規模なコントラクトやSolidityを短期間で習得するにはRemixをお勧めします。*

`Remixにオンラインでアクセスする <https://remix.ethereum.org/>`_ 場合、何もインストールする必要はありません。
インターネットに接続せずに使用したい場合は、https://github.com/ethereum/remix-live/tree/gh-pages#readme に行き、そのページの指示に従ってください。
Remixは、複数のSolidityバージョンをインストールせずにnightlyビルドをテストするのに便利なオプションでもあります。

このページの他のオプションでは、お使いのコンピュータにコマンドラインのSolidityコンパイラソフトウェアをインストールする方法について説明しています。
大規模なコントラクトに取り組む場合や、より多くのコンパイルオプションを必要とする場合は、コマンドラインコンパイラを選択してください。

.. _solcjs:

npm / Node.js
=============

`solcjs` プログラムは、Solidityのコンパイラである ``solcjs`` をインストールするための便利でポータブルな方法として使用します。
`solcjs` プログラムは、このページの下の方で説明されているコンパイラへのアクセス方法よりも機能が少なくなっています。
:ref:`commandline-compiler` のドキュメントでは、フル機能のコンパイラである ``solc`` を使用していることを前提としています。
``solcjs`` の使い方は、独自の `リポジトリ <https://github.com/ethereum/solc-js>`_ の中で説明されています。

注: solc-jsプロジェクトは、Emscriptenを使用してC++  `solc` から派生しており、両者は同じコンパイラのソースコードを使用しています。
`solc-js` はJavaScriptプロジェクト（Remixなど）で直接使用できます。
使用方法はsolc-jsのリポジトリを参照してください。

.. code-block:: bash

    npm install -g solc

.. note::

    コマンドラインの実行ファイルの名前は ``solcjs`` です。

    ``solcjs`` のコマンドラインオプションは ``solc`` と互換性がなく、 ``solc`` の動作を想定したツール（ ``geth`` など）は ``solcjs`` では動作しません。

Docker
======

<<<<<<< HEAD
SolidityのビルドのDockerイメージは、 ``ethereum`` オーガナイゼーションの ``solc`` イメージを使って利用できます。
最新のリリースバージョンには ``stable`` タグを、developブランチの不安定な可能性のある変更には ``nightly`` タグを使用してください。
=======
Docker images of Solidity builds are available using the ``solc`` image from the ``ethereum`` organization.
Use the ``stable`` tag for the latest released version, and ``nightly`` for potentially unstable changes in the ``develop`` branch.
>>>>>>> english/develop

Dockerイメージはコンパイラ実行ファイルを実行するので、すべてのコンパイラ引数を渡すことができます。
例えば、以下のコマンドは、ステーブル版の ``solc`` イメージ（まだ持っていない場合）を取り出し、 ``--help`` 引数を渡して新しいコンテナで実行します。

.. code-block:: bash

    docker run ethereum/solc:stable --help

<<<<<<< HEAD
タグには、0.5.4リリースのように、リリースのビルドバージョンを指定することもできます。
=======
You can specify release build versions in the tag. For example:
>>>>>>> english/develop

.. code-block:: bash

    docker run ethereum/solc:stable --help

Note

Specific compiler versions are supported as the Docker image tag such as `ethereum/solc:0.8.23`. We will be passing the
`stable` tag here instead of specific version tag to ensure that users get the latest version by default and avoid the issue of
an out-of-date version.

<<<<<<< HEAD
ホストマシンでSolidityのファイルをコンパイルするためにDockerイメージを使用するには、入出力用のローカルフォルダーをマウントし、コンパイルするコントラクトを指定します。
例えば、以下のようになります。
=======
To use the Docker image to compile Solidity files on the host machine, mount a
local folder for input and output, and specify the contract to compile. For example:
>>>>>>> english/develop

.. code-block:: bash

    docker run -v /local/path:/sources ethereum/solc:stable -o /sources/output --abi --bin /sources/Contract.sol

また、標準のJSONインターフェースを使用することもできます（コンパイラとツールを使用する場合は、このインターフェースを使用することをお勧めします）。
このインターフェースを使用する場合、JSON入力が自己完結している限り、ディレクトリをマウントする必要はありません（つまり、:ref:`importコールバックによって読み込まれる <initial-vfs-content-standard-json-with-import-callback>` 必要がある外部ファイルを参照しない）。

.. code-block:: bash

    docker run ethereum/solc:stable --standard-json < input.json > output.json

Linuxパッケージ
===============

`solidity/releases <https://github.com/ethereum/solidity/releases>`_ ではSolidityのバイナリパッケージが用意されています。

また、Ubuntu用のPPAも用意しているので、以下のコマンドで最新のステーブル版を入手できます。

.. code-block:: bash

    sudo add-apt-repository ppa:ethereum/ethereum
    sudo apt-get update
    sudo apt-get install solc

nightlyバージョンは、以下のコマンドでインストールできます。

.. code-block:: bash

    sudo add-apt-repository ppa:ethereum/ethereum
    sudo add-apt-repository ppa:ethereum/ethereum-dev
    sudo apt-get update
    sudo apt-get install solc

さらに、一部のLinuxディストリビューションでは、独自のパッケージが提供されています。
これらのパッケージは私たちが直接メンテナンスしているわけではありませんが、基本的にそれぞれのパッケージメンテナによって最新に保たれています。

例えば、Arch Linuxでは、最新の開発版のパッケージがAURパッケージとして用意されています。
`solidity <https://aur.archlinux.org/packages/solidity>`_ と `solidity-bin <https://aur.archlinux.org/packages/solidity-bin>`_ です。

.. note::

    .. Please be aware that `AUR <https://wiki.archlinux.org/title/Arch_User_Repository>`_ packages are user-produced content and unofficial packages. Exercise caution when using them.

    `AUR <https://wiki.archlinux.org/title/Arch_User_Repository>`_ パッケージはユーザーが作成したコンテンツであり、非公式パッケージです。
    使用するときは注意してください。

.. There is also a `snap package <https://snapcraft.io/solc>`_, however, it is **currently unmaintained**.
.. It is installable in all the `supported Linux distros <https://snapcraft.io/docs/core/install>`_.
.. To install the latest stable version of solc:

`snapパッケージ <https://snapcraft.io/solc>`_ もありますが、 **現在メンテナンスされていません** 。
`サポートされているLinuxディストリビューション <https://snapcraft.io/docs/core/install>`_ すべてでインストール可能です。
最新の安定版のsolcをインストールするには:

.. code-block:: bash

    sudo snap install solc

最新のデベロップメント版Solidityを最新の変更点でテストすることに協力したい方は、以下をご利用ください。

.. code-block:: bash

    sudo snap install solc --edge

.. note::

    ``solc`` スナップはstrict confinementを使用します。
    これはスナップパッケージにとって最も安全なモードですが、 ``/home`` と ``/media`` ディレクトリ内のファイルにしかアクセスできないなどの制限があります。
    詳細については、 `Demystifying Snap Confinement <https://snapcraft.io/blog/demystifying-snap-confinement>`_ を参照してください。

macOSパッケージ
===============

私たちは、SolidityコンパイラをHomebrewを通じて、build-from-sourceバージョンとして配布しています。
ビルド済みのボトルは現在サポートされていません。

.. code-block:: bash

    brew update
    brew upgrade
    brew tap ethereum/ethereum
    brew install solidity

最新の0.4.x / 0.5.xバージョンのSolidityをインストールするには、それぞれ ``brew install solidity@4`` と ``brew install solidity@5`` を使用することもできます。

Solidityの特定のバージョンが必要な場合は、Githubから直接Homebrew式をインストールできます。

<<<<<<< HEAD
`solidity.rb commits on Github <https://github.com/ethereum/homebrew-ethereum/commits/master/solidity.rb>`_ を見てください。
=======
View
`solidity.rb commits on GitHub <https://github.com/ethereum/homebrew-ethereum/commits/master/solidity.rb>`_.
>>>>>>> english/develop

欲しいバージョンのコミットハッシュをコピーして、自分のマシンでチェックしてみましょう。

.. code-block:: bash

    git clone https://github.com/ethereum/homebrew-ethereum.git
    cd homebrew-ethereum
    git checkout <your-hash-goes-here>

``brew`` を使ってインストールします。

.. code-block:: bash

    brew unlink solidity
    # eg. Install 0.4.8
    brew install solidity.rb

静的バイナリ
============

`solc-bin`_ では、サポートしているすべてのプラットフォーム用の過去および現在のコンパイラバージョンの静的ビルドを含むリポジトリを管理しています。
ここにはnightlyビルドも置かれています。

リポジトリは、エンドユーザーがすぐに使えるバイナリを素早く簡単に入手できるだけでなく、サードパーティのツールとの親和性も考慮しています。

- コンテンツは https://binaries.soliditylang.org にミラーリングされ、認証やレート制限、gitを使用する必要なく、HTTPSで簡単にダウンロードできます。
- コンテンツは、正しい `Content-Type` ヘッダと寛大なCORS設定で提供され、ブラウザ上で動作するツールで直接読み込めるようになっています。
- バイナリは、インストールや解凍の必要がありません（ただし、必要なDLLがバンドルされた古いWindowsビルドは例外です）。
- 私たちは、高いレベルの後方互換性を確保するよう努めています。
  一度追加されたファイルは、古い場所でシンボリックリンクやリダイレクトを提供することなく削除または移動されることはありません。
  また、ファイルはその場で変更されることはなく、常にオリジナルのチェックサムと一致していなければなりません。
  唯一の例外は、壊れたファイルや使用できないファイルで、そのままにしておくと害になる可能性があるものです。
- ファイルは HTTP と HTTPS の両方で提供されます。ファイルリストを安全な方法（git、HTTPS、IPFS、またはローカルにキャッシュ）で取得し、バイナリをダウンロードした後にバイナリのハッシュを検証する限り、バイナリ自体にHTTPSを使用する必要はありません。

<<<<<<< HEAD
同じバイナリは、ほとんどの場合、 `Solidity release page on Github`_ で入手できます。
異なる点は、Githubのリリースページにある古いリリースを一般的には更新しないことです。
つまり、命名規則が変わっても名前を変えないし、リリース時にサポートされていなかったプラットフォーム用のビルドも追加しません。
これは ``solc-bin`` でのみ起こります。
=======
The same binaries are in most cases available on the `Solidity release page on GitHub`_. The
difference is that we do not generally update old releases on the GitHub release page. This means
that we do not rename them if the naming convention changes and we do not add builds for platforms
that were not supported at the time of release. This only happens in ``solc-bin``.
>>>>>>> english/develop

``solc-bin`` リポジトリには、複数のトップレベルのディレクトリがあり、それぞれが1つのプラットフォームを表しています。
それぞれのディレクトリには、利用可能なバイナリの一覧を示す ``list.json`` ファイルが含まれています。
例えば、 ``emscripten-wasm32/list.json`` にはバージョン0.7.4についての以下の情報があります。

.. code-block:: json

    {
      "path": "solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js",
      "version": "0.7.4",
      "build": "commit.3f05b770",
      "longVersion": "0.7.4+commit.3f05b770",
      "keccak256": "0x300330ecd127756b824aa13e843cb1f43c473cb22eaf3750d5fb9c99279af8c3",
      "sha256": "0x2b55ed5fec4d9625b6c7b3ab1abd2b7fb7dd2a9c68543bf0323db2c7e2d55af2",
      "urls": [
        "dweb:/ipfs/QmTLs5MuLEWXQkths41HiACoXDiH8zxyqBHGFDRSzVE5CS"
      ]
    }

これは次のことを意味します。

<<<<<<< HEAD
- 同じディレクトリに  `solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js <https://github.com/ethereum/solc-bin/blob/gh-pages/emscripten-wasm32/solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js>`_  という名前でバイナリが置かれています。   このファイルはシンボリックリンクになっている可能性があるので、git を使ってダウンロードしていない場合やファイルシステムがシンボリックリンクをサポートしていない場合は、自分で解決する必要があります。

- このバイナリは https://binaries.soliditylang.org/emscripten-wasm32/solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js にもミラーされています。   この場合、git は必要ありません。シンボリックリンクは透過的に解決され、ファイルのコピーを提供するか HTTP リダイレクトを返します。

- このファイルはIPFSの `QmTLs5MuLEWXQkths41HiACoXDiH8zxyqBHGFDRSzVE5CS`_ でも公開されています。

- このファイルは、将来はSwarmの `16c5f09109c793db99fe35f037c6092b061bd39260ee7a677c8a97f18c955ab1`_ で公開されるかもしれません。

- keccak256ハッシュを ``0x300330ecd127756b824aa13e843cb1f43c473cb22eaf3750d5fb9c99279af8c3`` と比較することで、バイナリの完全性を確認できます。  ハッシュは、 `sha3sum`_ が提供する ``keccak256sum`` ユーティリティーを使ってコマンドラインで計算するか、JavaScriptで `keccak256() function   from ethereumjs-util`_ を使って計算できます。

- また、sha256ハッシュを ``0x2b55ed5fec4d9625b6c7b3ab1abd2b7fb7dd2a9c68543bf0323db2c7e2d55af2`` と比較することで、バイナリの完全性を確認できます。
=======
- You can find the binary in the same directory under the name
  `solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js <https://github.com/ethereum/solc-bin/blob/gh-pages/emscripten-wasm32/solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js>`_.
  Note that the file might be a symlink, and you will need to resolve it yourself if you are not using
  git to download it or your file system does not support symlinks.
- The binary is also mirrored at https://binaries.soliditylang.org/emscripten-wasm32/solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js.
  In this case git is not necessary and symlinks are resolved transparently, either by serving a copy
  of the file or returning a HTTP redirect.
- The file is also available on IPFS at `QmTLs5MuLEWXQkths41HiACoXDiH8zxyqBHGFDRSzVE5CS`_.
  Please, be aware that the order of items in the ``urls`` array is not predetermined or guaranteed and users should not rely on it.
- You can verify the integrity of the binary by comparing its keccak256 hash to
  ``0x300330ecd127756b824aa13e843cb1f43c473cb22eaf3750d5fb9c99279af8c3``.  The hash can be computed
  on the command-line using ``keccak256sum`` utility provided by `sha3sum`_ or `keccak256() function
  from ethereumjs-util`_ in JavaScript.
- You can also verify the integrity of the binary by comparing its sha256 hash to
  ``0x2b55ed5fec4d9625b6c7b3ab1abd2b7fb7dd2a9c68543bf0323db2c7e2d55af2``.
>>>>>>> english/develop

.. warning::

   強い後方互換性の要求により、リポジトリにはいくつかのレガシー要素が含まれていますが、新しいツールを書く際にはそれらを使用しないようにしてください。

   - 最高のパフォーマンスを求めるのであれば、 ``bin/`` ではなく ``emscripten-wasm32/`` （ ``emscripten-asmjs/`` へのフォールバック機能あり）を使用してください。バージョン0.6.1まではasm.jsのバイナリのみを提供していました。      0.6.2からは、パフォーマンスが大幅に向上した `WebAssembly builds`_ に切り替えました。古いバージョンを wasm 用に作り直しましたが、オリジナルの asm.js ファイルは  ``bin/``  に残っています。      新しいファイルは、名前の衝突を避けるために別のディレクトリに置く必要がありました。

   - wasmとasm.jsのどちらのバイナリをダウンロードしているかを確認したい場合は、 ``bin/`` と ``wasm/`` ディレクトリではなく、 ``emscripten-asmjs/`` と ``emscripten-wasm32/`` を使用してください。

   -  ``list.js`` と ``list.txt`` の代わりに ``list.json`` を使用します。JSONリスト形式には、旧来のものからすべての情報が含まれています。

   - https://solc-bin.ethereum.org の代わりに https://binaries.soliditylang.org を使用してください。物事をシンプルにするために、コンパイラに関連するほとんどすべてのものを新しい ``soliditylang.org`` ドメインの下に移動しましたが、これは ``solc-bin`` にも当てはまります。新しいドメインを推奨しますが、古いドメインも完全にサポートされており、同じ場所を指すことが保証されています。

.. warning::

    バイナリは https://ethereum.github.io/solc-bin/ にもありますが、このページはバージョン0.7.2のリリース直後に更新が停止しており、プラットフォームを問わず、新しいリリースやnightlyビルドを受け取ることはなく、また、非emscripten のビルドを含む新しいディレクトリ構造にも対応していません。

    使用している場合は、ドロップインで置き換え可能な https://binaries.soliditylang.org に切り替えてください。
    これにより、基盤となるホスティングの変更を透明性のある方法で行い、混乱を最小限に抑えることができます。
    私たちがコントロールできない ``ethereum.github.io`` ドメインとは異なり、 ``binaries.soliditylang.org`` は長期的に機能し、同じURL構造を維持することが保証されています。

.. _IPFS: https://ipfs.io
.. _solc-bin: https://github.com/ethereum/solc-bin/
.. _Solidity release page on GitHub: https://github.com/ethereum/solidity/releases
.. _sha3sum: https://github.com/maandree/sha3sum
.. _keccak256() function from ethereumjs-util: https://github.com/ethereumjs/ethereumjs-util/blob/master/docs/modules/_hash_.md#const-keccak256
.. _WebAssembly builds: https://emscripten.org/docs/compiling/WebAssembly.html
.. _QmTLs5MuLEWXQkths41HiACoXDiH8zxyqBHGFDRSzVE5CS: https://gateway.ipfs.io/ipfs/QmTLs5MuLEWXQkths41HiACoXDiH8zxyqBHGFDRSzVE5CS

.. _building-from-source:

ソースからのビルド
==================

前提知識 - 全オペレーティングシステム共通
-----------------------------------------

<<<<<<< HEAD
以下は、Solidityのすべてのビルドに依存しています。

+----------------------------------------------------------+-------------------------------------------------------+
| ソフトウェア                                             | ノート                                                |
+==========================================================+=======================================================+
| `CMake`_ (Windowsではバージョン3.21.3+、その他では3.13+) | クロスプラットフォームのビルドファイルジェネレーター。|
+----------------------------------------------------------+-------------------------------------------------------+
| `Boost`_ (Windowsではバージョン1.77、その他では1.65+)    | C++ライブラリ。                                       |
+----------------------------------------------------------+-------------------------------------------------------+
| `Git`_                                                   | ソースコードを取得するためのコマンドラインツール。    |
+----------------------------------------------------------+-------------------------------------------------------+
| `z3`_ (バージョン4.8.16+, オプション)                    | SMTチェッカーと併用する場合。                         |
+----------------------------------------------------------+-------------------------------------------------------+
| `cvc4`_ (オプション)                                     | SMTチェッカーと併用する場合。                         |
+----------------------------------------------------------+-------------------------------------------------------+
=======
+-----------------------------------+-------------------------------------------------------+
| Software                          | Notes                                                 |
+===================================+=======================================================+
| `CMake`_ (version 3.21.3+ on      | Cross-platform build file generator.                  |
| Windows, 3.13+ otherwise)         |                                                       |
+-----------------------------------+-------------------------------------------------------+
| `Boost`_ (version 1.77+ on        | C++ libraries.                                        |
| Windows, 1.67+ otherwise)         |                                                       |
+-----------------------------------+-------------------------------------------------------+
| `Git`_                            | Command-line tool for retrieving source code.         |
+-----------------------------------+-------------------------------------------------------+
| `z3`_ (version 4.8.16+, Optional) | For use with SMT checker.                             |
+-----------------------------------+-------------------------------------------------------+
>>>>>>> english/develop

.. _Git: https://git-scm.com/download
.. _Boost: https://www.boost.org
.. _CMake: https://cmake.org/download/
.. _z3: https://github.com/Z3Prover/z3

.. note::

    Solidityのバージョンが0.5.10以前の場合、Boostのバージョン1.70以上に対して正しくリンクできないことがあります。
    これを回避するには、cmakeコマンドを実行してSolidityを設定する前に、一時的に ``<Boost install path>/lib/cmake/Boost-1.70.0`` の名前を変更することが考えられます。

    0.5.10以降、Boost 1.70以上とのリンクは手動での操作なしに動作します。

.. note::

    デフォルトのビルド構成では、特定のZ3バージョン（コードが最後に更新された時点での最新のもの）が必要です。
    Z3のリリース間に導入された変更により、わずかに異なる(ただし有効な)結果が返されることがよくあります。
    私たちのSMTテストはこれらの違いを考慮しておらず、書かれたバージョンとは異なるバージョンで失敗する可能性があります。
    これは、異なるバージョンを使用したビルドが欠陥であることを意味するものではありません。
    CMakeに ``-DSTRICT_Z3_VERSION=OFF`` オプションを渡しておけば、上の表にある要件を満たす任意のバージョンでビルドできます。
    ただし、この場合、SMT テストをスキップするために  ``scripts/tests.sh``  に  ``--no-smt``  オプションを渡すことを忘れないでください。

.. note::
    .. By default the build is performed in *pedantic mode*, which enables extra warnings and tells the compiler to treat all warnings as errors.
    .. This forces developers to fix warnings as they arise, so they do not accumulate "to be fixed later".
    .. If you are only interested in creating a release build and do not intend to modify the source code to deal with such warnings, you can pass ``-DPEDANTIC=OFF`` option to CMake to disable this mode.
    .. Doing this is not recommended for general use but may be necessary when using a toolchain we are not testing with or trying to build an older version with newer tools.
    .. If you encounter such warnings, please consider `reporting them <https://github.com/ethereum/solidity/issues/new>`_.

    デフォルトでは、ビルドは *pedantic mode* で実行され、余分な警告を有効にし、すべての警告をエラーとして扱うようにコンパイラに指示します。
    これにより、開発者は警告が発生したときに修正することを余儀なくされ、「後で修正する」ことが蓄積されることがありません。
    もしあなたがリリースビルドを作ることにしか興味がなく、そのような警告に対処するためにソースコードを修正するつもりがないのであれば、CMakeに ``-DPEDANTIC=OFF`` オプションを渡してこのモードを無効にすることが可能です。
    この方法は一般的な使用では推奨されませんが、私たちがテストしていないツールチェーンを使用する場合や、古いバージョンを新しいツールでビルドしようとする場合には必要かもしれません。
    もしこのような警告に遭遇したら、 `それらを報告すること <https://github.com/ethereum/solidity/issues/new>`_ を検討してください。

最小コンパイラバージョン
^^^^^^^^^^^^^^^^^^^^^^^^

以下のC++コンパイラとその最小バージョンでSolidityのコードベースを構築できます。

-  `GCC <https://gcc.gnu.org>`_ 、バージョン8以上
-  `Clang <https://clang.llvm.org/>`_ 、バージョン7以上
-  `MSVC <https://visualstudio.microsoft.com/vs/>`_ 、バージョン2019以上

<<<<<<< HEAD
前提知識 - macOS
----------------

macOSでビルドする場合は、最新版の `Xcodeがインストールされていること <https://developer.apple.com/xcode/download/>`_ を確認してください。
Xcodeを初めてインストールする場合や、新しいバージョンをインストールしたばかりの場合は、コマンドラインでのビルドを行う前にライセンスに同意する必要があります。
=======
For macOS builds, ensure that you have the latest version of
`Xcode installed <https://developer.apple.com/xcode/resources/>`_.
This contains the `Clang C++ compiler <https://en.wikipedia.org/wiki/Clang>`_, the
`Xcode IDE <https://en.wikipedia.org/wiki/Xcode>`_ and other Apple development
tools that are required for building C++ applications on OS X.
If you are installing Xcode for the first time, or have just installed a new
version then you will need to agree to the license before you can do
command-line builds:
>>>>>>> english/develop

.. code-block:: bash

    sudo xcodebuild -license accept

私たちのOS Xのビルドスクリプトは、外部の依存関係をインストールするために `Homebrew <https://brew.sh>`_ パッケージマネージャーを使用しています。
もし、最初からやり直したいと思ったときのために、 `Homebrewのアンインストール <https://docs.brew.sh/FAQ#how-do-i-uninstall-homebrew>`_ の方法を紹介します。

前提知識 - Windows
------------------

SolidityのWindowsビルドには、以下の依存関係をインストールする必要があります。

+-----------------------------------+-------------------------------------------------------+
| Software                          | Notes                                                 |
+===================================+=======================================================+
| `Visual Studio 2019 Build Tools`_ | C++コンパイラ                                         |
+-----------------------------------+-------------------------------------------------------+
| `Visual Studio 2019`_  (Optional) | C++コンパイラと開発環境                               |
+-----------------------------------+-------------------------------------------------------+
<<<<<<< HEAD
| `Boost`_ (version 1.77)           | C++ライブラリ                                         |
=======
| `Boost`_ (version 1.77+)          | C++ libraries.                                        |
>>>>>>> english/develop
+-----------------------------------+-------------------------------------------------------+

すでに1つのIDEを持っていて、コンパイラとライブラリだけが必要な場合は、Visual Studio 2019 Build Toolsをインストールできます。

Visual Studio 2019は、IDEと必要なコンパイラとライブラリの両方を提供します。
そのため、IDEを持っておらず、Solidityを開発したい場合は、すべてのセットアップを簡単に行うことができるVisual Studio 2019を選択するとよいでしょう。

ここでは、「Visual Studio 2019 Build Tools」または「Visual Studio 2019」にインストールされるべきコンポーネントのリストを示します。

* Visual Studio C++のコア関数
* VC++ 2019 v141ツールセット(x86,x64)
* Windows Universal CRT SDK
* Windows 8.1 SDK
* C++/CLIのサポート

.. _Visual Studio 2019: https://www.visualstudio.com/vs/
.. _Visual Studio 2019 Build Tools: https://visualstudio.microsoft.com/vs/older-downloads/#visual-studio-2019-and-other-products

必要な外部依存パッケージをすべてインストールするためのヘルパースクリプトを用意しています。

.. code-block:: bat

    scripts\install_deps.ps1

これにより、 ``boost`` と ``cmake`` が ``deps`` サブディレクトリにインストールされます。

リポジトリのクローン
--------------------

ソースコードをクローンするには、以下のコマンドを実行します。

.. code-block:: bash

    git clone --recursive https://github.com/ethereum/solidity.git
    cd solidity

もしSolidityの開発に協力したいのであれば、Solidityをフォークして、自分の個人的なフォークをセカンドリモートとして追加してください。

.. code-block:: bash

    git remote add personal git@github.com:[username]/solidity.git

.. note::
<<<<<<< HEAD

    この方法では、プレリリースビルドの結果、そのようなコンパイラで生成された各バイトコードにフラグが設定されるなどの問題が発生します。
    リリースされたSolidityコンパイラを再構築したい場合は、githubのリリースページにあるソースtarballを使用してください。

    https://github.com/ethereum/solidity/releases/download/v0.X.Y/solidity_0.X.Y.tar.gz

    （GitHubで提供されている「ソースコード」ではありません）。
=======
    This method will result in a pre-release build leading to e.g. a flag
    being set in each bytecode produced by such a compiler.
    If you want to re-build a released Solidity compiler, then
    please use the source tarball on the GitHub release page:

    https://github.com/ethereum/solidity/releases/download/v0.X.Y/solidity_0.X.Y.tar.gz

    (not the "Source code" provided by GitHub).
>>>>>>> english/develop

コマンドラインビルド
--------------------

**ビルドする前に、必ず外部依存関係（上記参照）をインストールしてください。**

Solidityプロジェクトでは、CMakeを使ってビルドの設定を行います。
繰り返しのビルドを高速化するために、 `ccache`_ をインストールするとよいでしょう。
CMakeはそれを自動的にピックアップします。
Solidityのビルドは、Linux、macOS、その他のUnicesでもよく似ています。

.. _ccache: https://ccache.dev/

.. code-block:: bash

    mkdir build
    cd build
    cmake .. && make

あるいはLinuxやmacOSではもっと簡単に実行できます:

.. code-block:: bash

    #note: this will install binaries solc and soltest at usr/local/bin
    ./scripts/build.sh

.. warning::

    BSDビルドは動作するはずですが、Solidityチームではテストしていません。

そして、Windows用のビルドは、以下のコマンドを実行します:

.. code-block:: bash

    mkdir build
    cd build
    cmake -G "Visual Studio 16 2019" ..

``scripts\install_deps.ps1`` がインストールしたバージョンのブーストを使用したい場合は、 ``cmake`` の呼び出しの引数として ``-DBoost_DIR="deps\boost\lib\cmake\Boost-*"`` と ``-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded`` を追加で渡す必要があります。

これにより、そのビルドディレクトリに **solidity.sln** が作成されるはずです。
そのファイルをダブルクリックすると、Visual Studioが起動します。
**Release** 構成での構築をお勧めしますが、その他の構成でも動作します。

あるいは、次のようにコマンドラインでWindows用にビルドすることもできます。

.. code-block:: bash

    cmake --build . --config Release

CMakeオプション
===============

もし、CMakeのオプションに興味があれば、 ``cmake .. -LH`` を実行してください。

.. _smt_solvers_build:

SMTソルバー
-----------
<<<<<<< HEAD
=======
Solidity can be built against Z3 SMT solver and will do so by default if
it is found in the system. Z3 can be disabled by a ``cmake`` option.
>>>>>>> english/develop

SolidityはSMTソルバーに対してビルドでき、システムで見つかった場合、デフォルトでそうします。
それぞれのソルバーは ``cmake`` オプションで無効にできます。

*注: 場合によっては、ビルドに失敗したときの回避策としても有効です。*

<<<<<<< HEAD
ビルドフォルダ内では、デフォルトで有効になっているので、無効にできます。
=======
Inside the build folder you can disable Z3, since it is enabled by default:
>>>>>>> english/develop

.. code-block:: bash

    # disables Z3 SMT Solver.
    cmake .. -DUSE_Z3=OFF

.. note::

    Solidity can optionally use other solvers, namely ``cvc5`` and ``Eldarica``,
    but their presence is checked only at runtime, they are not needed for the build to succeed.

バージョン文字列の詳細
======================

Solidityバージョンの文字列は、4つの部分で構成されています。

- バージョン番号
- プレリリースのタグ。通常は ``develop.YYYY.MM.DD`` または ``nightly.YYYY.MM.DD`` に設定されています。
- コミット。フォーマットは ``commit.GITHASH`` です。
- プラットフォーム。任意の数の項目を持ち、プラットフォームとコンパイラに関する詳細を含むます。

ローカルに変更があった場合、そのコミットは ``.mod`` でポストフィックスされます。

これらのパーツはSemVerの要求に応じて組み合わせられます。
SolidityのプレリリースタグはSemVerのプレリリースに相当し、Solidityのコミットとプラットフォームを組み合わせてSemverのビルドメタデータを構成します。

リリース例: ``0.4.8+commit.60cc1668.Emscripten.clang``。

プレリリースの例: ``0.4.9-nightly.2017.1.17+commit.6ecb4aa3.Emscripten.clang``。

バージョニングについての重要な情報
==================================

リリースが行われた後、パッチレベルの変更のみが続くと想定されるため、パッチのバージョンレベルをバンプさせています。
変更がマージされたときには、SemVerと変更の重要度に応じてバージョンを上げる必要があります。
最後に、リリースは常に現在のnightlyビルドのバージョンで作成されますが、 ``prerelease`` 指定子はありません。

例:

1. 0.4.0のリリースを行います。
2. nightlyビルドのバージョンが今後0.4.1になります。
3. 非破壊的な変更があった場合 --> バージョンの変更なし。
4. 破壊的な変更があった場合 --> バージョンは0.5.0にバンプされます。
5. 0.5.0のリリースを行います。

この動作は :ref:`version pragma <version_pragma>` と相性が良いです。
