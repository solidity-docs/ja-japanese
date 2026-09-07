.. index:: ! installing

.. _installing-solidity:

################################
Solidityコンパイラのインストール
################################

バージョニング
==============

.. In addition, patch-level releases with major release 0 (i.e. 0.x.y) will not contain breaking changes.
.. That means code that compiles with version 0.x.y can be expected to compile with 0.x.z where z > y.

<<<<<<< HEAD
Solidityのバージョンは `セマンティックバージョニング <https://semver.org>`_ に従っています。
さらに、メジャーリリース0（つまり0.x.y）のパッチレベルのリリースには、破壊的な変更が含まれません。
つまり、バージョン0.x.yでコンパイルされたコードは、0.x.z（z > y）でコンパイルされることが期待できます。
=======
In addition to releases, we provide **prereleases** and **nightly development builds** to make it
easy for developers to try out upcoming features and provide early feedback.
Note that such builds contain bleeding-edge code from the development branch and are not guaranteed
to be of the same quality as full releases.
Despite our best efforts, they might contain undocumented and/or broken changes that will not
become a part of an actual release. They are not meant for production use.
>>>>>>> english/develop

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

<<<<<<< HEAD
`Remixにオンラインでアクセスする <https://remix.ethereum.org/>`_ 場合、何もインストールする必要はありません。
インターネットに接続せずに使用したい場合は、https://github.com/ethereum/remix-live/tree/gh-pages#readme に行き、そのページの指示に従ってください。
Remixは、複数のSolidityバージョンをインストールせずにnightlyビルドをテストするのに便利なオプションでもあります。
=======
`Access Remix online <https://remix.ethereum.org/>`_, you do not need to install anything.
If you want to use it without connection to the Internet, download Remix Desktop from `the releases page <https://github.com/remix-project-org/remix-desktop/releases/>`_.
Remix is also a convenient option for testing nightly builds
without installing multiple Solidity versions.
>>>>>>> english/develop

このページの他のオプションでは、お使いのコンピュータにコマンドラインのSolidityコンパイラソフトウェアをインストールする方法について説明しています。
大規模なコントラクトに取り組む場合や、より多くのコンパイルオプションを必要とする場合は、コマンドラインコンパイラを選択してください。

.. _solcjs:

npm / Node.js
=============

<<<<<<< HEAD
``solcjs`` プログラムは、Solidityのコンパイラである ``solcjs`` をインストールするための便利でポータブルな方法として使用します。
また、 ``solcjs`` プログラムは、このページの下の方で説明されているコンパイラへのアクセス方法よりも機能が少なくなっています。
:ref:`commandline-compiler` のドキュメントでは、フル機能のコンパイラである ``solc`` を使用していることを前提としています。
``solcjs`` の使い方は、独自の `リポジトリ <https://github.com/ethereum/solc-js>`_ の中で説明されています。
=======
Use ``npm`` for a convenient and portable way to install ``solcjs``, a Solidity compiler. The
``solcjs`` program has fewer features than the ways to access the compiler described
further down this page. The
:ref:`commandline-compiler` documentation assumes you are using
the full-featured compiler, ``solc``. The usage of ``solcjs`` is documented inside its own
`repository <https://github.com/argotorg/solc-js>`_.
>>>>>>> english/develop

注: ``solc-js`` プロジェクトは、Emscriptenを使用してC++  ``solc`` から派生しており、両者は同じコンパイラのソースコードを使用しています。
``solc-js`` はJavaScriptプロジェクト（Remixなど）で直接使用できます。
使用方法は solc-js のリポジトリを参照してください。

.. code-block:: bash

    npm install --global solc

.. note::

    コマンドラインの実行ファイルの名前は ``solcjs`` です。

    ``solcjs`` のコマンドラインオプションは ``solc`` と互換性がなく、 ``solc`` の動作を想定したツール（ ``geth`` など）は ``solcjs`` では動作しません。

Docker
======

<<<<<<< HEAD
SolidityのビルドのDockerイメージは、 ``ethereum`` オーガナイゼーションの ``solc`` イメージを使って利用できます。
最新のリリースバージョンには ``stable`` タグを、 ``develop`` ブランチの不安定な可能性のある変更には ``nightly`` タグを使用してください。
=======
Docker images of Solidity builds are available using the `solc <https://github.com/argotorg/solidity/pkgs/container/solc>`_ image from the argotorg organization on ghcr.io.
Use the ``stable`` tag for the latest released version, and ``nightly`` for potentially unstable changes in the ``develop`` branch.
>>>>>>> english/develop

Dockerイメージはコンパイラ実行ファイルを実行するので、すべてのコンパイラ引数を渡すことができます。
例えば、以下のコマンドは、ステーブル版の ``solc`` イメージ（まだ持っていない場合）を取り出し、 ``--help`` 引数を渡して新しいコンテナで実行します。

.. code-block:: bash

    docker run ghcr.io/argotorg/solc:stable --help

.. note::
    .. Specific compiler versions are supported as the Docker image tag such as ``ethereum/solc:0.8.23``.
    .. We will be passing the ``stable`` tag here instead of specific version tag to ensure that users get
    .. the latest version by default and avoid the issue of an out-of-date version.

<<<<<<< HEAD
    特定のコンパイラバージョンは ``ethereum/solc:0.8.23`` のように Docker イメージのタグとして指定できます。
    ここでは特定のバージョンタグの代わりに ``stable`` タグを使用することで、  
    ユーザーがデフォルトで最新バージョンを取得できるようにし、古いバージョンによる問題を回避します。
=======
    Specific compiler versions are supported as the Docker image tag such as ``ghcr.io/argotorg/solc:0.8.23``.
    We will be passing the ``stable`` tag here instead of specific version tag to ensure that users get
    the latest version by default and avoid the issue of an out-of-date version.
>>>>>>> english/develop

ホストマシンでSolidityのファイルをコンパイルするためにDockerイメージを使用するには、入出力用のローカルフォルダーをマウントし、コンパイルするコントラクトを指定します。
例えば、以下のようになります:

.. code-block:: bash

    docker run \
        --volume "/tmp/some/local/path/:/sources/" \
        ghcr.io/argotorg/solc:stable \
            /sources/Contract.sol \
            --abi \
            --bin \
            --output-dir /sources/output/

また、標準のJSONインターフェースを使用することもできます（コンパイラとツールを使用する場合は、このインターフェースを使用することをお勧めします）。
このインターフェースを使用する場合、JSON入力が自己完結している限り、ディレクトリをマウントする必要はありません（つまり、:ref:`importコールバックによって読み込まれる <initial-vfs-content-standard-json-with-import-callback>` 必要がある外部ファイルを参照しない）。

.. code-block:: bash

    docker run ghcr.io/argotorg/solc:stable --standard-json < input.json > output.json

Linuxパッケージ
===============

<<<<<<< HEAD
`solidity/releases <https://github.com/ethereum/solidity/releases>`_ ではSolidityのバイナリパッケージが用意されています。

また、Ubuntu用のPPAも用意しているので、以下のコマンドで最新のステーブル版を入手できます。
=======
We provide :ref:`standalone binaries <static-binaries>` of the compiler that should run on most
distributions without any additional installation steps.

Ubuntu packages for versions up to 0.8.30 are available in the
`ethereum/ethereum PPA <https://launchpad.net/~ethereum/+archive/ubuntu/ethereum>`_.
However, we have discontinued this distribution method and future versions will not be added there.
>>>>>>> english/develop

Some Linux distributions provide their own packages.
These packages are not directly maintained by us but usually kept up-to-date by the respective
package maintainers.

Unofficial, community-maintained scripts for building and installing the compiler are also
available for some distributions:

<<<<<<< HEAD
nightlyバージョンは、以下のコマンドでインストールできます。
=======
- Arch Linux / (AUR):
>>>>>>> english/develop

    - `solidity <https://aur.archlinux.org/packages/solidity>`_ (builds from source),
    - `solidity-bin <https://aur.archlinux.org/packages/solidity-bin>`_ (uses our standalone binaries).

- Nix:

<<<<<<< HEAD
さらに、一部のLinuxディストリビューションでは、独自のパッケージが提供されています。
これらのパッケージは私たちが直接メンテナンスしているわけではありませんが、基本的にそれぞれのパッケージメンテナによって最新に保たれています。

例えば、Arch Linuxでは、最新の開発版のパッケージがAURパッケージとして用意されています。
`solidity <https://aur.archlinux.org/packages/solidity>`_ と `solidity-bin <https://aur.archlinux.org/packages/solidity-bin>`_ です。
=======
    - `solc.nix <https://github.com/hellwolf/solc.nix>`_ (builds from source).
>>>>>>> english/develop

.. note::
    `AUR <https://wiki.archlinux.org/title/Arch_User_Repository>`_ パッケージはユーザーが作成したコンテンツであり、非公式パッケージです。
    使用する際には注意してください。

<<<<<<< HEAD
.. There is also a `snap package <https://snapcraft.io/solc>`_, however, it is **currently unmaintained**.
.. It is installable in all the `supported Linux distros <https://snapcraft.io/docs/core/install>`_.
.. To install the latest stable version of solc:

`snapパッケージ <https://snapcraft.io/solc>`_ もありますが、 **現在メンテナンスされていません** 。
`サポートされているLinuxディストリビューション <https://snapcraft.io/docs/core/install>`_ すべてでインストール可能です。
最新の安定版のsolcをインストールするには:
=======
    Please be aware that these scripts are produced and maintained by users and not vetted in any
    way by the distro maintainers.
    Exercise caution when using them.

There is also a `snap package <https://snapcraft.io/solc>`_, however, it is **currently unmaintained**.
It is installable in all the `supported Linux distros <https://snapcraft.io/docs/reference/administration/distribution-support/>`_. To
install the latest stable version of solc:
>>>>>>> english/develop

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

`GitHub の solidity.rb コミット <https://github.com/ethereum/homebrew-ethereum/commits/master/solidity.rb>`_ を見てください。

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

<<<<<<< HEAD
静的バイナリ
============
=======
.. _static-binaries:

Static Binaries
===============
>>>>>>> english/develop

`solc-bin`_ では、サポートしているすべてのプラットフォーム用の過去および現在のコンパイラバージョンの静的ビルドを含むリポジトリを管理しています。
ここにはnightlyビルドも置かれています。

リポジトリは、エンドユーザーがすぐに使えるバイナリを素早く簡単に入手できるだけでなく、サードパーティのツールとの親和性も考慮しています。

- コンテンツは https://binaries.soliditylang.org にミラーリングされ、認証やレート制限、gitを使用する必要なく、HTTPSで簡単にダウンロードできます。
- コンテンツは、正しい ``Content-Type`` ヘッダと寛大なCORS設定で提供され、ブラウザ上で動作するツールで直接読み込めるようになっています。
- バイナリは、インストールや解凍の必要がありません（ただし、必要なDLLがバンドルされた古いWindowsビルドは例外です）。
- 私たちは、高いレベルの後方互換性を確保するよう努めています。
  一度追加されたファイルは、古い場所でシンボリックリンクやリダイレクトを提供することなく削除または移動されることはありません。
  また、ファイルはその場で変更されることはなく、常にオリジナルのチェックサムと一致していなければなりません。
  唯一の例外は、壊れたファイルや使用できないファイルで、そのままにしておくと害になる可能性があるものです。
- ファイルは HTTP と HTTPS の両方で提供されます。ファイルリストを安全な方法（git、HTTPS、IPFS、またはローカルにキャッシュ）で取得し、バイナリをダウンロードした後にバイナリのハッシュを検証する限り、バイナリ自体にHTTPSを使用する必要はありません。

同じバイナリは、ほとんどの場合、 `Solidity release page on GitHub`_ で入手できます。
異なる点は、GitHubのリリースページにある古いリリースを一般的には更新しないことです。
つまり、命名規則が変わっても名前を変えないし、リリース時にサポートされていなかったプラットフォーム用のビルドも追加しません。
これは ``solc-bin`` でのみ起こります。

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
- 同じディレクトリに  `solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js <https://github.com/ethereum/solc-bin/blob/gh-pages/emscripten-wasm32/solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js>`_  という名前でバイナリが置かれています。 このファイルはシンボリックリンクになっている可能性があるので、git を使ってダウンロードしていない場合やファイルシステムがシンボリックリンクをサポートしていない場合は、自分で解決する必要があります。

- このバイナリは https://binaries.soliditylang.org/emscripten-wasm32/solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js にもミラーされています。この場合、git は必要ありません。シンボリックリンクは透過的に解決され、ファイルのコピーを提供するか HTTP リダイレクトを返します。

- このファイルはIPFSの `QmTLs5MuLEWXQkths41HiACoXDiH8zxyqBHGFDRSzVE5CS`_ でも公開されています。
  ``urls`` 配列内の項目の順序は、あらかじめ決まっているわけでも保証されているわけでもないため、ユーザーはその順序に依存すべきではありません。

- keccak256ハッシュを ``0x300330ecd127756b824aa13e843cb1f43c473cb22eaf3750d5fb9c99279af8c3`` と比較することで、バイナリの完全性を確認できます。ハッシュは、 `sha3sum`_ が提供する ``keccak256sum`` ユーティリティーを使ってコマンドラインで計算するか、JavaScriptで `keccak256() function   from ethereumjs-util`_ を使って計算できます。

- また、sha256ハッシュを ``0x2b55ed5fec4d9625b6c7b3ab1abd2b7fb7dd2a9c68543bf0323db2c7e2d55af2`` と比較することで、バイナリの完全性を確認できます。
=======
- You can find the binary in the same directory under the name
  `solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js <https://github.com/argotorg/solc-bin/blob/gh-pages/emscripten-wasm32/solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js>`_.
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

<<<<<<< HEAD
   - 最高のパフォーマンスを求めるのであれば、 ``bin/`` ではなく ``emscripten-wasm32/`` （ ``emscripten-asmjs/`` へのフォールバック機能あり）を使用してください。バージョン0.6.1まではasm.jsのバイナリのみを提供していました。    0.6.2からは、パフォーマンスが大幅に向上した `WebAssembly builds`_ に切り替えました。古いバージョンを wasm 用に作り直しましたが、オリジナルの asm.js ファイルは  ``bin/``  に残っています。    新しいファイルは、名前の衝突を避けるために別のディレクトリに置く必要がありました。

   - wasmとasm.jsのどちらのバイナリをダウンロードしているかを確認したい場合は、 ``bin/`` と ``wasm/`` ディレクトリではなく、 ``emscripten-asmjs/`` と ``emscripten-wasm32/`` を使用してください。

   -  ``list.js`` と ``list.txt`` の代わりに ``list.json`` を使用します。JSONリスト形式には、旧来のものからすべての情報が含まれています。

   - https://solc-bin.ethereum.org の代わりに https://binaries.soliditylang.org を使用してください。物事をシンプルにするために、コンパイラに関連するほとんどすべてのものを新しい ``soliditylang.org`` ドメインの下に移動しましたが、これは ``solc-bin`` にも当てはまります。新しいドメインを推奨しますが、古いドメインも完全にサポートされており、同じ場所を指すことが保証されています。

.. warning::

    バイナリは https://ethereum.github.io/solc-bin/ にもありますが、このページはバージョン0.7.2のリリース直後に更新が停止しており、プラットフォームを問わず、新しいリリースやnightlyビルドを受け取ることはなく、また、非emscripten のビルドを含む新しいディレクトリ構造にも対応していません。

    使用している場合は、ドロップインで置き換え可能な https://binaries.soliditylang.org に切り替えてください。
    これにより、基盤となるホスティングの変更を透明性のある方法で行い、混乱を最小限に抑えることができます。
    私たちがコントロールできない ``ethereum.github.io`` ドメインとは異なり、 ``binaries.soliditylang.org`` は長期的に機能し、同じURL構造を維持することが保証されています。
=======
   - Use ``emscripten-wasm32/`` (with a fallback to ``emscripten-asmjs/``) instead of ``bin/`` if
     you want the best performance. Until version 0.6.1 we only provided asm.js binaries.
     Starting with 0.6.2 we switched to `WebAssembly builds`_ with much better performance. We have
     rebuilt the older versions for wasm but the original asm.js files remain in ``bin/``.
     The new ones had to be placed in a separate directory to avoid name clashes.
   - Use ``emscripten-asmjs/`` and ``emscripten-wasm32/`` instead of ``bin/`` and ``wasm/`` directories
     if you want to be sure whether you are downloading a wasm or an asm.js binary.
   - Use ``list.json`` instead of ``list.js`` and ``list.txt``. The JSON list format contains all
     the information from the old ones and more.

.. warning::
   - The solc-bin.ethereum.org domain is no longer supported. Going forward,
     we recommend any tools which are still using it as the source of Solidity binaries
     to switch to binaries.soliditylang.org.

.. warning::

    The binaries are also available at https://argotorg.github.io/solc-bin/ but this page
    stopped being updated just after the release of version 0.7.2, will not receive any new releases
    or nightly builds for any platform and does not serve the new directory structure, including
    non-emscripten builds.

    If you are using it, please switch to https://binaries.soliditylang.org, which is a drop-in
    replacement. This allows us to make changes to the underlying hosting in a transparent way and
    minimize disruption. Unlike the ``argotorg.github.io`` domain, which we do not have any control
    over, ``binaries.soliditylang.org`` is guaranteed to work and maintain the same URL structure
    in the long-term.
>>>>>>> english/develop

.. _IPFS: https://ipfs.io
.. _solc-bin: https://github.com/argotorg/solc-bin/
.. _Solidity release page on GitHub: https://github.com/argotorg/solidity/releases
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
| `Boost`_ (Windowsではバージョン1.77+、その他では1.70+)   | C++ライブラリ。                                       |
+----------------------------------------------------------+-------------------------------------------------------+
| `Git`_                                                   | ソースコードを取得するためのコマンドラインツール。    |
+----------------------------------------------------------+-------------------------------------------------------+
| `z3`_ (バージョン4.8.16+, オプション)                    | SMTチェッカーと併用する場合。                         |
+----------------------------------------------------------+-------------------------------------------------------+
=======
.. Note: This has to be kept in sync with `scripts/ci/install_and_check_minimum_requirements.sh`.

+-----------------------------------+-------------------------------------------------------+
| Software                          | Notes                                                 |
+===================================+=======================================================+
| `CMake`_ (version 3.21.3+ on      | Cross-platform build file generator.                  |
| Windows, 3.13+ otherwise)         |                                                       |
+-----------------------------------+-------------------------------------------------------+
| `Boost`_ (version 1.83+)          | C++ libraries.                                        |
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
<<<<<<< HEAD
    .. By default the build is performed in *pedantic mode*, which enables extra warnings and tells the compiler to treat all warnings as errors.
    .. This forces developers to fix warnings as they arise, so they do not accumulate "to be fixed later".
    .. If you are only interested in creating a release build and do not intend to modify the source code to deal with such warnings, you can pass ``-DPEDANTIC=OFF`` option to CMake to disable this mode.
    .. Doing this is not recommended for general use but may be necessary when using a toolchain we are not testing with or trying to build an older version with newer tools.
    .. If you encounter such warnings, please consider `reporting them <https://github.com/ethereum/solidity/issues/new>`_.
=======
    By default the build is performed in *pedantic mode*, which enables extra warnings and tells the
    compiler to treat all warnings as errors.
    This forces developers to fix warnings as they arise, so they do not accumulate "to be fixed later".
    If you are only interested in creating a release build and do not intend to modify the source code
    to deal with such warnings, you can pass ``-DPEDANTIC=OFF`` option to CMake to disable this mode.
    Doing this is not recommended for general use but may be necessary when using a toolchain we are
    not testing with or trying to build an older version with newer tools.
    If you encounter such warnings, please consider
    `reporting them <https://github.com/argotorg/solidity/issues/new>`_.
>>>>>>> english/develop

    デフォルトでは、ビルドは *pedantic mode* で実行され、余分な警告を有効にし、すべての警告をエラーとして扱うようにコンパイラに指示します。
    これにより、開発者は警告が発生したときに修正することを余儀なくされ、「後で修正する」ことが蓄積されることがありません。
    もしあなたがリリースビルドを作ることにしか興味がなく、そのような警告に対処するためにソースコードを修正するつもりがないのであれば、CMakeに ``-DPEDANTIC=OFF`` オプションを渡してこのモードを無効にすることが可能です。
    この方法は一般的な使用では推奨されませんが、私たちがテストしていないツールチェーンを使用する場合や、古いバージョンを新しいツールでビルドしようとする場合には必要かもしれません。
    もしこのような警告に遭遇したら、 `それらを報告すること <https://github.com/ethereum/solidity/issues/new>`_ を検討してください。

最小コンパイラバージョン
^^^^^^^^^^^^^^^^^^^^^^^^

<<<<<<< HEAD
以下のC++コンパイラとその最小バージョンでSolidityのコードベースを構築できます。
=======
.. Note: Minimum versions for GCC and Clang are based on availability in Ubuntu 24.04.

- `GCC <https://gcc.gnu.org>`_, version 13.3+
- `Clang <https://clang.llvm.org/>`_, version 18.1.3+
- `MSVC <https://visualstudio.microsoft.com/vs/>`_, version 2019+
>>>>>>> english/develop

-  `GCC <https://gcc.gnu.org>`_ 、バージョン11以上
-  `Clang <https://clang.llvm.org/>`_ 、バージョン14以上
-  `MSVC <https://visualstudio.microsoft.com/vs/>`_ 、バージョン2019以上

前提知識 - macOS
----------------

macOSでビルドする場合は、最新版の `Xcodeがインストールされていること <https://developer.apple.com/xcode/resources/>`_ を確認してください。
Xcodeを初めてインストールする場合や、新しいバージョンをインストールしたばかりの場合は、コマンドラインでのビルドを行う前にライセンスに同意する必要があります:

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
| `Boost`_ (version 1.77+)          | C++ライブラリ                                         |
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

    git clone --recursive https://github.com/argotorg/solidity.git
    cd solidity

もしSolidityの開発に協力したいのであれば、Solidityをフォークして、自分の個人的なフォークをセカンドリモートとして追加してください。

.. code-block:: bash

    git remote add personal git@github.com:[username]/solidity.git

.. note::

    この方法では、プレリリースビルドの結果、そのようなコンパイラで生成された各バイトコードにフラグが設定されるなどの問題が発生します。
    リリースされたSolidityコンパイラを再構築したい場合は、GitHubのリリースページにあるソースtarballを使用してください。

    https://github.com/argotorg/solidity/releases/download/v0.X.Y/solidity_0.X.Y.tar.gz

    （GitHubで提供されている「ソースコード」ではありません）。

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

``scripts\install_deps.ps1`` がインストールしたバージョンのブーストを使用したい場合は、 ``cmake`` の呼び出しの引数として ``-DBoost_ROOT="deps/boost" -DBoost_INCLUDE_DIR="deps/boost/include"`` と ``-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded`` を追加で渡す必要があります。

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

Solidity はオプションで SMT ソルバー（ ``z3``、 ``cvc5``、 ``Eldarica``）を使用できますが、それらの存在は実行時にのみチェックされ、ビルドの成功には必要ありません。

.. note::

    emscripten ビルドでは Z3 が必要であり、代わりにそれを静的リンクします。

バージョン文字列の詳細
======================

Solidityバージョンの文字列は、4つの部分で構成されています。

<<<<<<< HEAD
- バージョン番号
- プレリリースのタグ。通常は ``develop.YYYY.MM.DD`` または ``nightly.YYYY.MM.DD`` に設定されています。
- コミット。フォーマットは ``commit.GITHASH`` です。
- プラットフォーム。任意の数の項目を持ち、プラットフォームとコンパイラに関する詳細を含むます。
=======
- the version number
- pre-release tag, usually set to ``develop.YYYY.MM.DD``, ``pre.N`` or ``nightly.YYYY.MM.DD``
- commit in the format of ``commit.GITHASH``
- platform, which has an arbitrary number of items, containing details about the platform and compiler
>>>>>>> english/develop

ローカルに変更があった場合、そのコミットは ``.mod`` でポストフィックスされます。

これらのパーツはSemVerの要求に応じて組み合わせられます。
SolidityのプレリリースタグはSemVerのプレリリースに相当し、Solidityのコミットとプラットフォームを組み合わせてSemverのビルドメタデータを構成します。

<<<<<<< HEAD
リリース例: ``0.4.8+commit.60cc1668.Emscripten.clang``。

プレリリースの例: ``0.4.9-nightly.2017.1.17+commit.6ecb4aa3.Emscripten.clang``。
=======
Examples:

- release: ``0.4.8+commit.60cc1668.Emscripten.clang``
- pre-release: ``0.4.9-pre.3+commit.fb60450bc.Emscripten.clang``
- nightly build: ``0.4.9-nightly.2017.1.17+commit.6ecb4aa3.Emscripten.clang``
>>>>>>> english/develop

バージョニングについての重要な情報
==================================

<<<<<<< HEAD
リリースが行われた後、パッチレベルの変更のみが続くと想定されるため、パッチのバージョンレベルをバンプさせています。
変更がマージされたときには、SemVerと変更の重要度に応じてバージョンを上げる必要があります。
最後に、リリースは常に現在のnightlyビルドのバージョンで作成されますが、 ``prerelease`` 指定子はありません。
=======
After a release is made, the patch version level is bumped, because we assume that only
patch level changes follow. When changes are merged, the version should be bumped according
to SemVer and the severity of the change. Finally, a release is always made with the version
of the current build, but without the ``prerelease`` specifier.
>>>>>>> english/develop

例:

<<<<<<< HEAD
1. 0.4.0のリリースを行います。
2. nightlyビルドのバージョンが今後0.4.1になります。
3. 非破壊的な変更があった場合 --> バージョンの変更なし。
4. 破壊的な変更があった場合 --> バージョンは0.5.0にバンプされます。
5. 0.5.0のリリースを行います。

この動作は :ref:`version pragma <version_pragma>` と相性が良いです。
=======
1. The 0.4.0 release is made.
2. Nightly builds and preerelases have a version of 0.4.1 from now on.
3. Non-breaking changes are introduced --> no change in version.
4. A breaking change is introduced --> version is bumped to 0.5.0.
5. The 0.5.0 release is made.

This behavior works well with the :ref:`version pragma <version_pragma>`.
>>>>>>> english/develop
