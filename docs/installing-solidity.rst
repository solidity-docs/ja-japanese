.. index:: ! installing

.. _installing-solidity:

################################
Installing the Solidity Compiler
################################

Versioning
==========

.. Solidity versions follow `semantic versioning <https://semver.org>`_ and in addition to
.. releases, **nightly development builds** are also made available.  The nightly builds
.. are not guaranteed to be working and despite best efforts they might contain undocumented
.. and/or broken changes. We recommend using the latest release. Package installers below
.. will use the latest release.

Solidityのバージョンは `semantic versioning <https://semver.org>`_ に続き、リリースに加えて **nightly development builds** も提供されます。  ナイトリービルドは動作を保証するものではなく、最善の努力にもかかわらず、文書化されていない、または壊れた変更が含まれている可能性があります。最新のリリースを使用することをお勧めします。以下のパッケージインストーラーは最新のリリースを使用しています。

Remix
=====

.. *We recommend Remix for small contracts and for quickly learning Solidity.*

*小規模なコントラクトやSolidityを短期間で習得するにはRemixをお勧めします。*

.. `Access Remix online <https://remix.ethereum.org/>`_, you do not need to install anything.
.. If you want to use it without connection to the Internet, go to
.. https://github.com/ethereum/remix-live/tree/gh-pages and download the ``.zip`` file as
.. explained on that page. Remix is also a convenient option for testing nightly builds
.. without installing multiple Solidity versions.

`Access Remix online <https://remix.ethereum.org/>`_ の場合、何もインストールする必要はありません。インターネットに接続せずに使用したい場合は、https://github.com/ethereum/remix-live/tree/gh-pages、そのページで説明されているように ``.zip`` ファイルをダウンロードしてください。Remixは、複数のSolidityバージョンをインストールせずにナイトリービルドをテストするのに便利なオプションでもあります。

.. Further options on this page detail installing commandline Solidity compiler software
.. on your computer. Choose a commandline compiler if you are working on a larger contract
.. or if you require more compilation options.

このページの他のオプションでは、お使いのコンピュータにコマンドラインのSolidityコンパイラソフトウェアをインストールする方法について説明しています。大規模なコントラクトに取り組む場合や、より多くのコンパイル・オプションを必要とする場合は、コマンドライン・コンパイラを選択してください。

.. _solcjs:

npm / Node.js
=============

.. Use ``npm`` for a convenient and portable way to install ``solcjs``, a Solidity compiler. The
.. `solcjs` program has fewer features than the ways to access the compiler described
.. further down this page. The
.. :ref:`commandline-compiler` documentation assumes you are using
.. the full-featured compiler, ``solc``. The usage of ``solcjs`` is documented inside its own
.. `repository <https://github.com/ethereum/solc-js>`_.

`solcjs` プログラムは、Solidityのコンパイラである ``solcjs`` をインストールするための便利でポータブルな方法として使用します。 `solcjs`  プログラムは、このページの下の方で説明されているコンパイラへのアクセス方法よりも機能が少なくなっています。 :ref:`commandline-compiler` のドキュメントでは、フル機能のコンパイラである ``solc`` を使用していることを前提としています。 ``solcjs`` の使い方は、独自の `repository <https://github.com/ethereum/solc-js>`_ の中で説明されています。

.. Note: The solc-js project is derived from the C++
.. `solc` by using Emscripten which means that both use the same compiler source code.
.. `solc-js` can be used in JavaScript projects directly (such as Remix).
.. Please refer to the solc-js repository for instructions.

注: solc-jsプロジェクトは、Emscriptenを使用してC++  `solc` から派生しており、両者は同じコンパイラのソースコードを使用しています。 `solc-js` はJavaScriptプロジェクト（Remixなど）で直接使用できます。使用方法はsolc-jsのリポジトリを参照してください。

.. code-block:: bash

    npm install -g solc

.. .. note::

..     The commandline executable is named ``solcjs``.

..     The commandline options of ``solcjs`` are not compatible with ``solc`` and tools (such as ``geth``)
..     expecting the behaviour of ``solc`` will not work with ``solcjs``.

.. note::

    コマンドラインの実行ファイルの名前は「 ``solcjs`` 」です。

    ``solcjs`` のコマンドラインオプションは ``solc`` と互換性がなく、 ``solc`` の動作を想定したツール（ ``geth`` など）は ``solcjs`` では動作しません。

Docker
======

.. Docker images of Solidity builds are available using the ``solc`` image from the ``ethereum`` organisation.
.. Use the ``stable`` tag for the latest released version, and ``nightly`` for potentially unstable changes in the develop branch.

SolidityのビルドのDockerイメージは、 ``ethereum`` 組織の ``solc`` イメージを使って利用できます。最新のリリースバージョンには ``stable`` タグを、developブランチの不安定な可能性のある変更には ``nightly`` タグを使用してください。

.. The Docker image runs the compiler executable, so you can pass all compiler arguments to it.
.. For example, the command below pulls the stable version of the ``solc`` image (if you do not have it already),
.. and runs it in a new container, passing the ``--help`` argument.

Dockerイメージはコンパイラ実行ファイルを実行するので、すべてのコンパイラ引数を渡すことができます。例えば、以下のコマンドは、安定版の ``solc`` イメージ（まだ持っていない場合）を取り出し、 ``--help`` 引数を渡して新しいコンテナで実行します。

.. code-block:: bash

    docker run ethereum/solc:stable --help

.. You can also specify release build versions in the tag, for example, for the 0.5.4 release.

タグには、0.5.4リリースのように、リリースのビルドバージョンを指定することもできます。

.. code-block:: bash

    docker run ethereum/solc:0.5.4 --help

.. To use the Docker image to compile Solidity files on the host machine mount a
.. local folder for input and output, and specify the contract to compile. For example.

ホストマシンでSolidityのファイルをコンパイルするためにDockerイメージを使用するには、入出力用のローカルフォルダーをマウントし、コンパイルするコントラクトを指定します。例えば、以下のようになります。

.. code-block:: bash

    docker run -v /local/path:/sources ethereum/solc:stable -o /sources/output --abi --bin /sources/Contract.sol

.. You can also use the standard JSON interface (which is recommended when using the compiler with tooling).
.. When using this interface it is not necessary to mount any directories as long as the JSON input is
.. self-contained (i.e. it does not refer to any external files that would have to be
.. :ref:`loaded by the import callback <initial-vfs-content-standard-json-with-import-callback>`).

また、標準のJSONインターフェイスを使用することもできます（コンパイラとツールを使用する場合は、このインターフェイスを使用することをお勧めします）。このインターフェースを使用する場合、JSON入力が自己完結していれば（つまり、 :ref:`loaded by the import callback <initial-vfs-content-standard-json-with-import-callback>` が必要な外部ファイルを参照していなければ）、ディレクトリをマウントする必要はありません。

.. code-block:: bash

    docker run ethereum/solc:stable --standard-json < input.json > output.json

Linux Packages
==============

.. Binary packages of Solidity are available at
.. `solidity/releases <https://github.com/ethereum/solidity/releases>`_.

`solidity/releases <https://github.com/ethereum/solidity/releases>`_ ではSolidityのバイナリパッケージが用意されています。

.. We also have PPAs for Ubuntu, you can get the latest stable
.. version using the following commands:

また、Ubuntu用のPPAも用意していますので、以下のコマンドで最新の安定版を入手できます。

.. code-block:: bash

    sudo add-apt-repository ppa:ethereum/ethereum
    sudo apt-get update
    sudo apt-get install solc

.. The nightly version can be installed using these commands:

ナイトリーバージョンは、以下のコマンドでインストールできます。

.. code-block:: bash

    sudo add-apt-repository ppa:ethereum/ethereum
    sudo add-apt-repository ppa:ethereum/ethereum-dev
    sudo apt-get update
    sudo apt-get install solc

.. We are also releasing a `snap package <https://snapcraft.io/>`_, which is
.. installable in all the `supported Linux distros <https://snapcraft.io/docs/core/install>`_. To
.. install the latest stable version of solc:

また、すべての `supported Linux distros <https://snapcraft.io/docs/core/install>`_ でインストール可能な `snap package <https://snapcraft.io/>`_ もリリースしています。solcの最新安定版をインストールするには

.. code-block:: bash

    sudo snap install solc

.. If you want to help testing the latest development version of Solidity
.. with the most recent changes, please use the following:

最新の開発版Solidityを最新の変更点でテストすることに協力したい方は、以下をご利用ください。

.. code-block:: bash

    sudo snap install solc --edge

.. .. note::

..     The ``solc`` snap uses strict confinement. This is the most secure mode for snap packages
..     but it comes with limitations, like accessing only the files in your ``/home`` and ``/media`` directories.
..     For more information, go to `Demystifying Snap Confinement <https://snapcraft.io/blog/demystifying-snap-confinement>`_.

.. note::

    ``solc`` スナップはstrict confinementを使用します。これはスナップパッケージにとって最も安全なモードですが、 ``/home`` と ``/media`` ディレクトリ内のファイルにしかアクセスできないなどの制限があります。     詳細については、 `Demystifying Snap Confinement <https://snapcraft.io/blog/demystifying-snap-confinement>`_ をご覧ください。

.. Arch Linux also has packages, albeit limited to the latest development version:

Arch Linuxにも、最新の開発バージョンに限定されますが、パッケージがあります。

.. code-block:: bash

    pacman -S solidity

.. Gentoo Linux has an `Ethereum overlay <https://overlays.gentoo.org/#ethereum>`_ that contains a Solidity package.
.. After the overlay is setup, ``solc`` can be installed in x86_64 architectures by:

Gentoo Linuxには、Solidityパッケージを含む `Ethereum overlay <https://overlays.gentoo.org/#ethereum>`_ があります。オーバーレイの設定後、 ``solc`` はx86_64アーキテクチャでは以下の方法でインストールできます。

.. code-block:: bash

    emerge dev-lang/solidity

macOS Packages
==============

.. We distribute the Solidity compiler through Homebrew
.. as a build-from-source version. Pre-built bottles are
.. currently not supported.

私たちは、Solidity コンパイラを Homebrew を通じて、build-from-source バージョンとして配布しています。ビルド済みのボトルは現在サポートされていません。

.. code-block:: bash

    brew update
    brew upgrade
    brew tap ethereum/ethereum
    brew install solidity

.. To install the most recent 0.4.x / 0.5.x version of Solidity you can also use ``brew install solidity@4``
.. and ``brew install solidity@5``, respectively.

最新の0.4.x / 0.5.xバージョンのSolidityをインストールするには、それぞれ ``brew install solidity@4`` と ``brew install solidity@5`` を使用することもできます。

.. If you need a specific version of Solidity you can install a
.. Homebrew formula directly from Github.

Solidityの特定のバージョンが必要な場合は、Githubから直接Homebrew式をインストールできます。

.. View
.. `solidity.rb commits on Github <https://github.com/ethereum/homebrew-ethereum/commits/master/solidity.rb>`_.

`solidity.rb commits on Github <https://github.com/ethereum/homebrew-ethereum/commits/master/solidity.rb>`_ を見る。

.. Copy the commit hash of the version you want and check it out on your machine.

欲しいバージョンのコミットハッシュをコピーして、自分のマシンでチェックしてみましょう。

.. code-block:: bash

    git clone https://github.com/ethereum/homebrew-ethereum.git
    cd homebrew-ethereum
    git checkout <your-hash-goes-here>

.. Install it using ``brew``:

``brew`` を使ってインストールします。

.. code-block:: bash

    brew unlink solidity
    # eg. Install 0.4.8
    brew install solidity.rb

Static Binaries
===============

.. We maintain a repository containing static builds of past and current compiler versions for all
.. supported platforms at `solc-bin`_. This is also the location where you can find the nightly builds.

`solc-bin`_ では、サポートしているすべてのプラットフォーム用の過去および現在のコンパイラバージョンのスタティックビルドを含むリポジトリを管理しています。ここにはナイトリービルドも置かれています。

.. The repository is not only a quick and easy way for end users to get binaries ready to be used
.. out-of-the-box but it is also meant to be friendly to third-party tools:

リポジトリは、エンドユーザーがすぐに使えるバイナリを素早く簡単に入手できるだけでなく、サードパーティのツールとの親和性も考慮しています。

.. - The content is mirrored to https://binaries.soliditylang.org where it can be easily downloaded over
..   HTTPS without any authentication, rate limiting or the need to use git.

- コンテンツは https://binaries.soliditylang.org にミラーリングされ、認証やレート制限、git を使用する必要なく、HTTPS で簡単にダウンロードできます。

.. - Content is served with correct `Content-Type` headers and lenient CORS configuration so that it
..   can be directly loaded by tools running in the browser.

- コンテンツは、正しい `Content-Type` ヘッダと寛大なCORS設定で提供され、ブラウザ上で動作するツールで直接読み込めるようになっています。

.. - Binaries do not require installation or unpacking (with the exception of older Windows builds
..   bundled with necessary DLLs).

- バイナリは、インストールや解凍の必要がありません（ただし、必要なDLLがバンドルされた古いWindowsビルドは例外です）。

.. - We strive for a high level of backwards-compatibility. Files, once added, are not removed or moved
..   without providing a symlink/redirect at the old location. They are also never modified
..   in place and should always match the original checksum. The only exception would be broken or
..   unusable files with a potential to cause more harm than good if left as is.

- 私たちは、高いレベルの後方互換性を確保するよう努めています。一度追加されたファイルは、古い場所でシンボリックリンクやリダイレクトを提供することなく削除または移動されることはありません。また、ファイルはその場で変更されることはなく、常にオリジナルのチェックサムと一致していなければなりません。唯一の例外は、壊れたファイルや使用できないファイルで、そのままにしておくと害になる可能性があるものです。

.. - Files are served over both HTTP and HTTPS. As long as you obtain the file list in a secure way
..   (via git, HTTPS, IPFS or just have it cached locally) and verify hashes of the binaries
..   after downloading them, you do not have to use HTTPS for the binaries themselves.

- ファイルは HTTP と HTTPS の両方で提供されます。ファイルリストを安全な方法（git、HTTPS、IPFS、またはローカルにキャッシュ）で取得し、バイナリをダウンロードした後にバイナリのハッシュを検証する限り、バイナリ自体にHTTPSを使用する必要はありません。

.. The same binaries are in most cases available on the `Solidity release page on Github`_. The
.. difference is that we do not generally update old releases on the Github release page. This means
.. that we do not rename them if the naming convention changes and we do not add builds for platforms
.. that were not supported at the time of release. This only happens in ``solc-bin``.

同じバイナリは、ほとんどの場合、 `Solidity release page on Github`_ で入手できます。異なる点は、Githubのリリースページにある古いリリースを一般的には更新しないことです。つまり、命名規則が変わっても名前を変えないし、リリース時にサポートされていなかったプラットフォーム用のビルドも追加しません。これは ``solc-bin`` でのみ起こります。

.. The ``solc-bin`` repository contains several top-level directories, each representing a single platform.
.. Each one contains a ``list.json`` file listing the available binaries. For example in
.. ``emscripten-wasm32/list.json`` you will find the following information about version 0.7.4:

``solc-bin`` リポジトリには、複数のトップレベルのディレクトリがあり、それぞれが1つのプラットフォームを表しています。それぞれのディレクトリには、利用可能なバイナリの一覧を示す ``list.json`` ファイルが含まれています。例えば、 ``emscripten-wasm32/list.json`` にはバージョン0.7.4についての以下の情報があります。

.. code-block:: json

    {
      "path": "solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js",
      "version": "0.7.4",
      "build": "commit.3f05b770",
      "longVersion": "0.7.4+commit.3f05b770",
      "keccak256": "0x300330ecd127756b824aa13e843cb1f43c473cb22eaf3750d5fb9c99279af8c3",
      "sha256": "0x2b55ed5fec4d9625b6c7b3ab1abd2b7fb7dd2a9c68543bf0323db2c7e2d55af2",
      "urls": [
        "bzzr://16c5f09109c793db99fe35f037c6092b061bd39260ee7a677c8a97f18c955ab1",
        "dweb:/ipfs/QmTLs5MuLEWXQkths41HiACoXDiH8zxyqBHGFDRSzVE5CS"
      ]
    }

.. This means that:

ということになります。

.. - You can find the binary in the same directory under the name
..   `solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js <https://github.com/ethereum/solc-bin/blob/gh-pages/emscripten-wasm32/solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js>`_.
..   Note that the file might be a symlink, and you will need to resolve it yourself if you are not using
..   git to download it or your file system does not support symlinks.

- 同じディレクトリに  `solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js <https://github.com/ethereum/solc-bin/blob/gh-pages/emscripten-wasm32/solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js>`_  という名前でバイナリが置かれています。   このファイルはシンボリックリンクになっている可能性があるので、git を使ってダウンロードしていない場合やファイルシステムがシンボリックリンクをサポートしていない場合は、自分で解決する必要があります。

.. - The binary is also mirrored at https://binaries.soliditylang.org/emscripten-wasm32/solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js.
..   In this case git is not necessary and symlinks are resolved transparently, either by serving a copy
..   of the file or returning a HTTP redirect.

- このバイナリは https://binaries.soliditylang.org/emscripten-wasm32/solc-emscripten-wasm32-v0.7.4+commit.3f05b770.js にもミラーされています。   この場合、git は必要ありません。シンボリックリンクは透過的に解決され、ファイルのコピーを提供するか HTTP リダイレクトを返します。

.. - The file is also available on IPFS at `QmTLs5MuLEWXQkths41HiACoXDiH8zxyqBHGFDRSzVE5CS`_.

- このファイルはIPFSの `QmTLs5MuLEWXQkths41HiACoXDiH8zxyqBHGFDRSzVE5CS`_ でも公開されています。

.. - The file might in future be available on Swarm at `16c5f09109c793db99fe35f037c6092b061bd39260ee7a677c8a97f18c955ab1`_.

- このファイルは、将来的にはSwarm at  `16c5f09109c793db99fe35f037c6092b061bd39260ee7a677c8a97f18c955ab1`_ で公開されるかもしれません。

.. - You can verify the integrity of the binary by comparing its keccak256 hash to
..   ``0x300330ecd127756b824aa13e843cb1f43c473cb22eaf3750d5fb9c99279af8c3``.  The hash can be computed
..   on the command line using ``keccak256sum`` utility provided by `sha3sum`_ or `keccak256() function
..   from ethereumjs-util`_ in JavaScript.

- keccak256ハッシュを ``0x300330ecd127756b824aa13e843cb1f43c473cb22eaf3750d5fb9c99279af8c3`` と比較することで、バイナリの完全性を確認できます。  ハッシュは、 `sha3sum`_ が提供する ``keccak256sum`` ユーティリティーを使ってコマンドラインで計算するか、JavaScriptで `keccak256() function   from ethereumjs-util`_ を使って計算できます。

.. - You can also verify the integrity of the binary by comparing its sha256 hash to
..   ``0x2b55ed5fec4d9625b6c7b3ab1abd2b7fb7dd2a9c68543bf0323db2c7e2d55af2``.

- また、sha256ハッシュを ``0x2b55ed5fec4d9625b6c7b3ab1abd2b7fb7dd2a9c68543bf0323db2c7e2d55af2`` と比較することで、バイナリの完全性を確認できます。

.. .. warning::

..    Due to the strong backwards compatibility requirement the repository contains some legacy elements
..    but you should avoid using them when writing new tools:

..    - Use ``emscripten-wasm32/`` (with a fallback to ``emscripten-asmjs/``) instead of ``bin/`` if
..      you want the best performance. Until version 0.6.1 we only provided asm.js binaries.
..      Starting with 0.6.2 we switched to `WebAssembly builds`_ with much better performance. We have
..      rebuilt the older versions for wasm but the original asm.js files remain in ``bin/``.
..      The new ones had to be placed in a separate directory to avoid name clashes.

..    - Use ``emscripten-asmjs/`` and ``emscripten-wasm32/`` instead of ``bin/`` and ``wasm/`` directories
..      if you want to be sure whether you are downloading a wasm or an asm.js binary.

..    - Use ``list.json`` instead of ``list.js`` and ``list.txt``. The JSON list format contains all
..      the information from the old ones and more.

..    - Use https://binaries.soliditylang.org instead of https://solc-bin.ethereum.org. To keep things
..      simple we moved almost everything related to the compiler under the new ``soliditylang.org``
..      domain and this applies to ``solc-bin`` too. While the new domain is recommended, the old one
..      is still fully supported and guaranteed to point at the same location.

.. warning::

   強い後方互換性の要求により、リポジトリにはいくつかのレガシー要素が含まれていますが、新しいツールを書く際にはそれらを使用しないようにしてください。

   - 最高のパフォーマンスを求めるのであれば、 ``bin/`` ではなく ``emscripten-wasm32/`` （ ``emscripten-asmjs/`` へのフォールバック機能あり）を使用してください。バージョン0.6.1まではasm.jsのバイナリのみを提供していました。      0.6.2からは、パフォーマンスが大幅に向上した `WebAssembly builds`_ に切り替えました。古いバージョンを wasm 用に作り直しましたが、オリジナルの asm.js ファイルは  ``bin/``  に残っています。      新しいファイルは、名前の衝突を避けるために別のディレクトリに置く必要がありました。

   - wasmとasm.jsのどちらのバイナリをダウンロードしているかを確認したい場合は、 ``bin/`` と ``wasm/`` ディレクトリではなく、 ``emscripten-asmjs/`` と ``emscripten-wasm32/`` を使用してください。

   -  ``list.js`` と ``list.txt`` の代わりに ``list.json`` を使用します。JSONリスト形式には、旧来のものからすべての情報が含まれています。

   - https://solc-bin.ethereum.org の代わりに https://binaries.soliditylang.org を使用してください。物事をシンプルにするために、コンパイラに関連するほとんどすべてのものを新しい ``soliditylang.org`` ドメインの下に移動しましたが、これは ``solc-bin`` にも当てはまります。新しいドメインを推奨しますが、古いドメインも完全にサポートされており、同じ場所を指すことが保証されています。

.. .. warning::

..     The binaries are also available at https://ethereum.github.io/solc-bin/ but this page
..     stopped being updated just after the release of version 0.7.2, will not receive any new releases
..     or nightly builds for any platform and does not serve the new directory structure, including
..     non-emscripten builds.

..     If you are using it, please switch to https://binaries.soliditylang.org, which is a drop-in
..     replacement. This allows us to make changes to the underlying hosting in a transparent way and
..     minimize disruption. Unlike the ``ethereum.github.io`` domain, which we do not have any control
..     over, ``binaries.soliditylang.org`` is guaranteed to work and maintain the same URL structure
..     in the long-term.

.. warning::

    バイナリは https://ethereum.github.io/solc-bin/ にもありますが、このページはバージョン 0.7.2 のリリース直後に更新が停止しており、プラットフォームを問わず、新しいリリースやナイトリービルドを受け取ることはなく、また、非emscripten のビルドを含む新しいディレクトリ構造にも対応していません。

    使用している場合は、ドロップインで置き換え可能な https://binaries.soliditylang.org に切り替えてください。これにより、基盤となるホスティングの変更を透明性のある方法で行い、混乱を最小限に抑えることができます。私たちがコントロールできない ``ethereum.github.io`` ドメインとは異なり、 ``binaries.soliditylang.org`` は長期的に機能し、同じURL構造を維持することが保証されています。

.. _IPFS: https://ipfs.io
.. _Swarm: https://swarm-gateways.net/bzz:/swarm.eth
.. _solc-bin: https://github.com/ethereum/solc-bin/
.. _Solidity release page on github: https://github.com/ethereum/solidity/releases
.. _sha3sum: https://github.com/maandree/sha3sum
.. _keccak256() function from ethereumjs-util: https://github.com/ethereumjs/ethereumjs-util/blob/master/docs/modules/_hash_.md#const-keccak256
.. _WebAssembly builds: https://emscripten.org/docs/compiling/WebAssembly.html
.. _QmTLs5MuLEWXQkths41HiACoXDiH8zxyqBHGFDRSzVE5CS: https://gateway.ipfs.io/ipfs/QmTLs5MuLEWXQkths41HiACoXDiH8zxyqBHGFDRSzVE5CS
.. _16c5f09109c793db99fe35f037c6092b061bd39260ee7a677c8a97f18c955ab1: https://swarm-gateways.net/bzz:/16c5f09109c793db99fe35f037c6092b061bd39260ee7a677c8a97f18c955ab1/

.. _building-from-source:

Building from Source
====================

Prerequisites - All Operating Systems
-------------------------------------

.. The following are dependencies for all builds of Solidity:

以下は、Solidityのすべてのビルドに依存しています。

+-----------------------------------+-------------------------------------------------------+
| Software                          | Notes                                                 |
+===================================+=======================================================+
| `CMake`_ (version 3.13+)          | Cross-platform build file generator.                  |
+-----------------------------------+-------------------------------------------------------+
| `Boost`_ (version 1.77+ on        | C++ libraries.                                        |
| Windows, 1.65+ otherwise)         |                                                       |
+-----------------------------------+-------------------------------------------------------+
| `Git`_                            | Command-line tool for retrieving source code.         |
+-----------------------------------+-------------------------------------------------------+
| `z3`_ (version 4.8+, Optional)    | For use with SMT checker.                             |
+-----------------------------------+-------------------------------------------------------+
| `cvc4`_ (Optional)                | For use with SMT checker.                             |
+-----------------------------------+-------------------------------------------------------+

.. _cvc4: https://cvc4.cs.stanford.edu/web/
.. _Git: https://git-scm.com/download
.. _Boost: https://www.boost.org
.. _CMake: https://cmake.org/download/
.. _z3: https://github.com/Z3Prover/z3

.. .. note::

..     Solidity versions prior to 0.5.10 can fail to correctly link against Boost versions 1.70+.
..     A possible workaround is to temporarily rename ``<Boost install path>/lib/cmake/Boost-1.70.0``
..     prior to running the cmake command to configure solidity.

..     Starting from 0.5.10 linking against Boost 1.70+ should work without manual intervention.

.. note::

    Solidityのバージョンが0.5.10以前の場合、Boostのバージョン1.70以上に対して正しくリンクできないことがあります。     これを回避するには、cmakeコマンドを実行してsolidityを設定する前に、一時的に ``<Boost install path>/lib/cmake/Boost-1.70.0`` の名前を変更することが考えられます。

    0.5.10以降、Boost 1.70以上とのリンクは手動での操作なしに動作します。

.. .. note::

..     The default build configuration requires a specific Z3 version (the latest one at the time the
..     code was last updated). Changes introduced between Z3 releases often result in slightly different
..     (but still valid) results being returned. Our SMT tests do not account for these differences and
..     will likely fail with a different version than the one they were written for. This does not mean
..     that a build using a different version is faulty. If you pass ``-DSTRICT_Z3_VERSION=OFF`` option
..     to CMake, you can build with any version that satisfies the requirement given in the table above.
..     If you do this, however, please remember to pass the ``--no-smt`` option to ``scripts/tests.sh``
..     to skip the SMT tests.

.. note::

    デフォルトのビルド構成では、特定のZ3バージョン（コードが最後に更新された時点での最新のもの）が必要です。Z3のリリース間に導入された変更により、わずかに異なる(ただし有効な)結果が返されることがよくあります。私たちのSMTテストはこれらの違いを考慮しておらず、書かれたバージョンとは異なるバージョンで失敗する可能性があります。これは、異なるバージョンを使用したビルドが欠陥であることを意味するものではありません。CMakeに ``-DSTRICT_Z3_VERSION=OFF`` オプションを渡しておけば、上の表にある要件を満たす任意のバージョンでビルドできます。     ただし、この場合、SMT テストをスキップするために  ``scripts/tests.sh``  に  ``--no-smt``  オプションを渡すことを忘れないでください。

Minimum Compiler Versions
^^^^^^^^^^^^^^^^^^^^^^^^^

.. The following C++ compilers and their minimum versions can build the Solidity codebase:

以下のC++コンパイラとその最小バージョンでSolidityのコードベースを構築できます。

.. - `GCC <https://gcc.gnu.org>`_, version 8+

-  `GCC <https://gcc.gnu.org>`_ 、バージョン8以上

.. - `Clang <https://clang.llvm.org/>`_, version 7+

-  `Clang <https://clang.llvm.org/>`_ 、バージョン7以上

.. - `MSVC <https://visualstudio.microsoft.com/vs/>`_, version 2019+

-  `MSVC <https://visualstudio.microsoft.com/vs/>`_ 、バージョン2019以上

Prerequisites - macOS
---------------------

.. For macOS builds, ensure that you have the latest version of
.. `Xcode installed <https://developer.apple.com/xcode/download/>`_.
.. This contains the `Clang C++ compiler <https://en.wikipedia.org/wiki/Clang>`_, the
.. `Xcode IDE <https://en.wikipedia.org/wiki/Xcode>`_ and other Apple development
.. tools that are required for building C++ applications on OS X.
.. If you are installing Xcode for the first time, or have just installed a new
.. version then you will need to agree to the license before you can do
.. command-line builds:

macOSでビルドする場合は、最新版の `Xcode installed <https://developer.apple.com/xcode/download/>`_ を用意してください。Xcodeを初めてインストールする場合や、新しいバージョンをインストールしたばかりの場合は、コマンドラインでのビルドを行う前にライセンスに同意する必要があります。

.. code-block:: bash

    sudo xcodebuild -license accept

.. Our OS X build script uses `the Homebrew <https://brew.sh>`_
.. package manager for installing external dependencies.
.. Here's how to `uninstall Homebrew
.. <https://docs.brew.sh/FAQ#how-do-i-uninstall-homebrew>`_,
.. if you ever want to start again from scratch.

私たちのOS Xのビルドスクリプトは、外部の依存関係をインストールするために `the Homebrew <https://brew.sh>`_ パッケージマネージャーを使用しています。もし、最初からやり直したいと思ったときのために、 `uninstall Homebrew <https://docs.brew.sh/FAQ#how-do-i-uninstall-homebrew>`_ の方法を紹介します。

Prerequisites - Windows
-----------------------

.. You need to install the following dependencies for Windows builds of Solidity:

SolidityのWindowsビルドには、以下の依存関係をインストールする必要があります。

+-----------------------------------+-------------------------------------------------------+
| Software                          | Notes                                                 |
+===================================+=======================================================+
| `Visual Studio 2019 Build Tools`_ | C++ compiler                                          |
+-----------------------------------+-------------------------------------------------------+
| `Visual Studio 2019`_  (Optional) | C++ compiler and dev environment.                     |
+-----------------------------------+-------------------------------------------------------+
| `Boost`_ (version 1.77+)          | C++ libraries.                                        |
+-----------------------------------+-------------------------------------------------------+

.. If you already have one IDE and only need the compiler and libraries,
.. you could install Visual Studio 2019 Build Tools.

すでに1つのIDEを持っていて、コンパイラとライブラリだけが必要な場合は、Visual Studio 2019 Build Toolsをインストールできます。

.. Visual Studio 2019 provides both IDE and necessary compiler and libraries.
.. So if you have not got an IDE and prefer to develop Solidity, Visual Studio 2019
.. may be a choice for you to get everything setup easily.

Visual Studio 2019は、IDEと必要なコンパイラとライブラリの両方を提供します。そのため、IDEを持っておらず、Solidityを開発したい場合は、すべてのセットアップを簡単に行うことができるVisual Studio 2019を選択するとよいでしょう。

.. Here is the list of components that should be installed
.. in Visual Studio 2019 Build Tools or Visual Studio 2019:

ここでは、「Visual Studio 2019 Build Tools」または「Visual Studio 2019」にインストールされるべきコンポーネントのリストを示します。

.. * Visual Studio C++ core features

* Visual Studio C++のコア関数

.. * VC++ 2019 v141 toolset (x86,x64)

* VC++ 2019 v141ツールセット(x86,x64)

.. * Windows Universal CRT SDK

* Windows Universal CRT SDK

.. * Windows 8.1 SDK

* Windows 8.1 SDK

.. * C++/CLI support

* C++/CLIのサポート

.. _Visual Studio 2019: https://www.visualstudio.com/vs/
.. _Visual Studio 2019 Build Tools: https://www.visualstudio.com/downloads/#build-tools-for-visual-studio-2019

.. We have a helper script which you can use to install all required external dependencies:

必要な外部依存パッケージをすべてインストールするためのヘルパー・スクリプトを用意しています。

.. code-block:: bat

    scripts\install_deps.ps1

.. This will install ``boost`` and ``cmake`` to the ``deps`` subdirectory.

これにより、 ``boost`` と ``cmake`` が ``deps`` サブディレクトリにインストールされます。

Clone the Repository
--------------------

.. To clone the source code, execute the following command:

ソースコードをクローンするには、以下のコマンドを実行します。

.. code-block:: bash

    git clone --recursive https://github.com/ethereum/solidity.git
    cd solidity

.. If you want to help developing Solidity,
.. you should fork Solidity and add your personal fork as a second remote:

もしSolidityの開発に協力したいのであれば、Solidityをフォークして、自分の個人的なフォークをセカンドリモートとして追加してください。

.. code-block:: bash

    git remote add personal git@github.com:[username]/solidity.git

.. .. note::

..     This method will result in a prerelease build leading to e.g. a flag
..     being set in each bytecode produced by such a compiler.
..     If you want to re-build a released Solidity compiler, then
..     please use the source tarball on the github release page:

..     https://github.com/ethereum/solidity/releases/download/v0.X.Y/solidity_0.X.Y.tar.gz

..     (not the "Source code" provided by github).

.. note::

    この方法では、プレリリース・ビルドの結果、そのようなコンパイラで生成された各バイトコードにフラグが設定されるなどの問題が発生します。     リリースされたSolidityコンパイラを再構築したい場合は、githubのリリースページにあるソースtarballを使用してください。

    https://github.com/ethereum/solidity/releases/download/v0.X.Y/solidity_0.X.Y.tar.gz

    (githubで提供されている「ソースコード」ではありません)。

Command-Line Build
------------------

.. **Be sure to install External Dependencies (see above) before build.**

**Be sure to install External Dependencies (see above) before build.**

.. Solidity project uses CMake to configure the build.
.. You might want to install `ccache`_ to speed up repeated builds.
.. CMake will pick it up automatically.
.. Building Solidity is quite similar on Linux, macOS and other Unices:

Solidityプロジェクトでは、CMakeを使ってビルドの設定を行います。繰り返しのビルドを高速化するために、 `ccache`_ をインストールするとよいでしょう。CMakeはそれを自動的にピックアップします。Solidityのビルドは、Linux、macOS、その他のUnicesでもよく似ています。

.. _ccache: https://ccache.dev/

.. code-block:: bash

    mkdir build
    cd build
    cmake .. && make

.. or even easier on Linux and macOS, you can run:

を、あるいはLinuxやmacOSではもっと簡単に実行できます。

.. code-block:: bash

    #note: this will install binaries solc and soltest at usr/local/bin
    ./scripts/build.sh

.. .. warning::

..     BSD builds should work, but are untested by the Solidity team.

.. warning::

    BSDビルドは動作するはずですが、Solidityチームではテストしていません。

.. And for Windows:

そして、Windows用。

.. code-block:: bash

    mkdir build
    cd build
    cmake -G "Visual Studio 16 2019" ..

.. In case you want to use the version of boost installed by ``scripts\install_deps.ps1``, you will
.. additionally need to pass ``-DBoost_DIR="deps\boost\lib\cmake\Boost-*"`` and ``-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded``
.. as arguments to the call to ``cmake``.

``scripts\install_deps.ps1`` がインストールしたバージョンのブーストを使用したい場合は、 ``cmake`` の呼び出しの引数として ``-DBoost_DIR="deps\boost\lib\cmake\Boost-*"`` と ``-DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded`` を追加で渡す必要があります。

.. This should result in the creation of **solidity.sln** in that build directory.
.. Double-clicking on that file should result in Visual Studio firing up.  We suggest building
.. **Release** configuration, but all others work.

これにより、そのビルドディレクトリに **solidity.sln** が作成されるはずです。そのファイルをダブルクリックすると、Visual Studioが起動します。   **Release** 構成での構築をお勧めしますが、その他の構成でも動作します。

.. Alternatively, you can build for Windows on the command-line, like so:

あるいは、次のようにコマンドラインでWindows用にビルドすることもできます。

.. code-block:: bash

    cmake --build . --config Release

CMake Options
=============

If you are interested what CMake options are available run ``cmake .. -LH``.

.. _smt_solvers_build:

SMT Solvers
-----------
Solidity can be built against SMT solvers and will do so by default if
they are found in the system. Each solver can be disabled by a `cmake` option.

.. *Note: In some cases, this can also be a potential workaround for build failures.*

*注: 場合によっては、ビルドに失敗したときの回避策としても有効です。*

.. Inside the build folder you can disable them, since they are enabled by default:

ビルドフォルダ内では、デフォルトで有効になっているので、無効にできます。

.. code-block:: bash

    # disables only Z3 SMT Solver.
    cmake .. -DUSE_Z3=OFF

    # disables only CVC4 SMT Solver.
    cmake .. -DUSE_CVC4=OFF

    # disables both Z3 and CVC4
    cmake .. -DUSE_CVC4=OFF -DUSE_Z3=OFF

The Version String in Detail
============================

.. The Solidity version string contains four parts:

Solidityバージョンの文字列は、4つの部分で構成されています。

.. - the version number

- バージョン番号

.. - pre-release tag, usually set to ``develop.YYYY.MM.DD`` or ``nightly.YYYY.MM.DD``

- 発売前のタグで、通常は ``develop.YYYY.MM.DD`` または ``nightly.YYYY.MM.DD`` に設定されています。

.. - commit in the format of ``commit.GITHASH``

- の形式でコミットします。

.. - platform, which has an arbitrary number of items, containing details about the platform and compiler

- platform（任意の数の項目を持ち、プラットフォームとコンパイラに関する詳細を含む

.. If there are local modifications, the commit will be postfixed with ``.mod``.

ローカルに変更があった場合、そのコミットは ``.mod`` でポストフィックスされます。

.. These parts are combined as required by Semver, where the Solidity pre-release tag equals to the Semver pre-release
.. and the Solidity commit and platform combined make up the Semver build metadata.

これらのパーツはSemverの要求に応じて組み合わせられます。SolidityのプレリリースタグはSemverのプレリリースに相当し、Solidityのコミットとプラットフォームを組み合わせてSemverのビルドメタデータを構成します。

.. A release example: ``0.4.8+commit.60cc1668.Emscripten.clang``.

リリース例です。 ``0.4.8+commit.60cc1668.Emscripten.clang`` を使用しています。

.. A pre-release example: ``0.4.9-nightly.2017.1.17+commit.6ecb4aa3.Emscripten.clang``

発売前の例です。 ``0.4.9-nightly.2017.1.17+commit.6ecb4aa3.Emscripten.clang``

Important Information About Versioning
======================================

.. After a release is made, the patch version level is bumped, because we assume that only
.. patch level changes follow. When changes are merged, the version should be bumped according
.. to semver and the severity of the change. Finally, a release is always made with the version
.. of the current nightly build, but without the ``prerelease`` specifier.

リリースが行われた後、パッチレベルの変更のみが続くと想定されるため、パッチのバージョンレベルをバンプさせています。変更がマージされたときには、semver と変更の重要度に応じてバージョンを上げる必要があります。最後に、リリースは常に現在のナイトリービルドのバージョンで作成されますが、 ``prerelease`` 指定子はありません。

.. Example:

例

.. 0. The 0.4.0 release is made.
.. 1. The nightly build has a version of 0.4.1 from now on.
.. 2. Non-breaking changes are introduced --> no change in version.
.. 3. A breaking change is introduced --> version is bumped to 0.5.0.
.. 4. The 0.5.0 release is made.

0.0.4.0のリリースを行います。1.ナイトリービルドのバージョンが今後0.4.1になります。2.非破壊的な変更を導入→バージョンの変更なし。3.壊れるような変更があった場合、バージョンは0.5.0になります。4.0.5.0のリリースを行う。

.. This behaviour works well with the  :ref:`version pragma <version_pragma>`.
.. 

この動作は :ref:`version pragma <version_pragma>` と相性が良い。
