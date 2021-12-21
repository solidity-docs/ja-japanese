.. _path-resolution:

**********************
Import Path Resolution
**********************

.. In order to be able to support reproducible builds on all platforms, the Solidity compiler has to
.. abstract away the details of the filesystem where source files are stored.
.. Paths used in imports must work the same way everywhere while the command-line interface must be
.. able to work with platform-specific paths to provide good user experience.
.. This section aims to explain in detail how Solidity reconciles these requirements.

すべてのプラットフォームで再現可能なビルドをサポートするために、Solidityのコンパイラは、ソースファイルが格納されているファイルシステムの詳細を抽象化する必要があります。インポートで使用されるパスは、どこでも同じように動作しなければならない一方で、コマンドライン・インターフェースは、良いユーザー・エクスペリエンスを提供するために、プラットフォーム固有のパスを扱うことができなければなりません。このセクションでは、Solidityがこれらの要件をどのように調整しているかを詳しく説明します。

.. index:: ! virtual filesystem, ! VFS, ! source unit name
.. _virtual-filesystem:

Virtual Filesystem
==================

.. The compiler maintains an internal database (*virtual filesystem* or *VFS* for short) where each
.. source unit is assigned a unique *source unit name* which is an opaque and unstructured identifier.
.. When you use the :ref:`import statement <import>`, you specify an *import path* that references a
.. source unit name.

コンパイラは内部データベース（*virtual filesystem*、略して*VFS*）を保持しており、各ソース・ユニットには不透明で構造化されていない識別子である一意の*ソース・ユニット名*が割り当てられています。 :ref:`import statement <import>` を使用する際には、ソース・ユニット名を参照する*インポート・パス*を指定します。

.. index:: ! import callback, ! Host Filesystem Loader
.. _import-callback:

Import Callback
---------------

.. The VFS is initially populated only with files the compiler has received as input.
.. Additional files can be loaded during compilation using an *import callback*, which is different
.. depending on the type of compiler you use (see below).
.. If the compiler does not find any source unit name matching the import path in the VFS, it invokes
.. the callback, which is responsible for obtaining the source code to be placed under that name.
.. An import callback is free to interpret source unit names in an arbitrary way, not just as paths.
.. If there is no callback available when one is needed or if it fails to locate the source code,
.. compilation fails.

VFSには、コンパイラーが入力として受け取ったファイルのみが最初に入力されます。使用するコンパイラの種類によって異なる *import コールバック* を使用して、コンパイル中に追加のファイルを読み込むことができます (後述)。コンパイラは、VFS内のインポート・パスに一致するソース・ユニット名が見つからない場合、コールバックを起動し、その名前で配置されるソース・コードを取得する役割を果たします。インポート コールバックは、ソース ユニット名をパスとしてだけでなく、任意の方法で自由に解釈できます。必要なときに利用可能なコールバックがない場合や、ソースコードの取得に失敗した場合は、コンパイルに失敗します。

.. The command-line compiler provides the *Host Filesystem Loader* - a rudimentary callback
.. that interprets a source unit name as a path in the local filesystem.
.. The `JavaScript interface <https://github.com/ethereum/solc-js>`_ does not provide any by default,
.. but one can be provided by the user.
.. This mechanism can be used to obtain source code from locations other then the local filesystem
.. (which may not even be accessible, e.g. when the compiler is running in a browser).
.. For example the `Remix IDE <https://remix.ethereum.org/>`_ provides a versatile callback that
.. lets you `import files from HTTP, IPFS and Swarm URLs or refer directly to packages in NPM registry
.. <https://remix-ide.readthedocs.io/en/latest/import.html>`_.

コマンドライン・コンパイラには、ソース・ユニット名をローカル・ファイルシステムのパスとして解釈する初歩的なコールバックである*Host Filesystem Loader*が用意されています。 `JavaScript interface <https://github.com/ethereum/solc-js>`_ はデフォルトでは提供していませんが、ユーザーが提供することもできます。このメカニズムを使用して、ローカル・ファイルシステム以外の場所からソース・コードを取得できます（ブラウザでコンパイラを実行している場合など、アクセスできない場合もあります）。例えば、 `Remix IDE <https://remix.ethereum.org/>`_ は汎用性の高いコールバックを提供しており、これを利用して `import files from HTTP, IPFS and Swarm URLs or refer directly to packages in NPM registry <https://remix-ide.readthedocs.io/en/latest/import.html>`_ .

.. .. note::

..     Host Filesystem Loader's file lookup is platform-dependent.
..     For example backslashes in a source unit name can be interpreted as directory separators or not
..     and the lookup can be case-sensitive or not, depending on the underlying platform.

..     For portability it is recommended to avoid using import paths that will work correctly only
..     with a specific import callback or only on one platform.
..     For example you should always use forward slashes since they work as path separators also on
..     platforms that support backslashes.

.. note::

    Host Filesystem Loaderのファイル検索は、プラットフォームに依存します。     例えば、ソースユニット名のバックスラッシュは、ディレクトリセパレータとして解釈されるかどうか、また、検索では大文字と小文字が区別されるかどうかが、基礎となるプラットフォームに依存します。

    移植性を考慮して、特定のインポートコールバックでのみ正しく動作するインポートパスや、特定のプラットフォームでのみ動作するインポートパスは使用しないことをお勧めします。     たとえば、バックスラッシュをサポートするプラットフォームでもパスの区切りとして機能するフォワードスラッシュを常に使用するべきです。

Initial Content of the Virtual Filesystem
-----------------------------------------

.. The initial content of the VFS depends on how you invoke the compiler:

VFSの初期コンテンツは、コンパイラの起動方法によって異なります。

.. #. **solc / command-line interface**

..    When you compile a file using the command-line interface of the compiler, you provide one or
..    more paths to files containing Solidity code:

#. **solc / command-line interface**

   コンパイラのコマンドライン・インターフェースを使用してファイルをコンパイルする際に、Solidityコードを含むファイルへの1つまたは複数のパスを指定します。

   .. code-block:: bash

       solc contract.sol /usr/local/dapp-bin/token.sol

   The source unit name of a file loaded this way is constructed by converting its path to a
   canonical form and, if possible, making it relative to either the base path or one of the
   include paths.
   See :ref:`CLI Path Normalization and Stripping <cli-path-normalization-and-stripping>` for
   a detailed description of this process.

   .. index:: standard JSON

.. #. **Standard JSON**

..    When using the :ref:`Standard JSON <compiler-api>` API (via either the `JavaScript interface
..    <https://github.com/ethereum/solc-js>`_ or the ``--standard-json`` command-line option)
..    you provide input in JSON format, containing, among other things, the content of all your source
..    files:

#. **Standard JSON**

   :ref:`Standard JSON <compiler-api>`  APIを使用する場合（ `JavaScript interface    <https://github.com/ethereum/solc-js>`_ または ``--standard-json`` コマンドライン・オプションを使用）、すべてのソース・ファイルのコンテンツなどを含むJSONフォーマットの入力を提供します。

   .. code-block:: json

       {
           "language": "Solidity",
           "sources": {
               "contract.sol": {
                   "content": "import \"./util.sol\";\ncontract C {}"
               },
               "util.sol": {
                   "content": "library Util {}"
               },
               "/usr/local/dapp-bin/token.sol": {
                   "content": "contract Token {}"
               }
           },
           "settings": {"outputSelection": {"*": { "*": ["metadata", "evm.bytecode"]}}}
       }

   The ``sources`` dictionary becomes the initial content of the virtual filesystem and its keys
   are used as source unit names.

.. _initial-vfs-content-standard-json-with-import-callback:

.. #. **Standard JSON (via import callback)**

..    With Standard JSON it is also possible to tell the compiler to use the import callback to obtain
..    the source code:

#. **Standard JSON (via import callback)**

   Standard JSONでは、ソースコードの取得にimportコールバックを使用するようにコンパイラに指示することも可能です。

   .. code-block:: json

       {
           "language": "Solidity",
           "sources": {
               "/usr/local/dapp-bin/token.sol": {
                   "urls": [
                       "/projects/mytoken.sol",
                       "https://example.com/projects/mytoken.sol"
                   ]
               }
           },
           "settings": {"outputSelection": {"*": { "*": ["metadata", "evm.bytecode"]}}}
       }

   If an import callback is available, the compiler will give it the strings specified in
   ``urls`` one by one, until one is loaded successfully or the end of the list is reached.

   The source unit names are determined the same way as when using ``content`` - they are keys of
   the ``sources`` dictionary and the content of ``urls`` does not affect them in any way.

   .. index:: standard input, stdin, <stdin>

.. #. **Standard input**

..    On the command line it is also possible to provide the source by sending it to compiler's
..    standard input:

#. **Standard input**

   コマンドラインでは、コンパイラの標準入力にソースを送信することも可能です。

   .. code-block:: bash

       echo 'import "./util.sol"; contract C {}' | solc -

   ``-`` used as one of the arguments instructs the compiler to place the content of the standard
   input in the virtual filesystem under a special source unit name: ``<stdin>``.

.. Once the VFS is initialized, additional files can still be added to it only through the import
.. callback.

VFSが初期化された後も、インポートコールバックによってのみファイルを追加できます。

.. index:: ! import; path

Imports
=======

.. The import statement specifies an *import path*.
.. Based on how the import path is specified, we can divide imports into two categories:

インポートステートメントでは、 *import path* を指定します。インポートパスの指定方法に基づいて、インポートは2つのカテゴリーに分けられます。

.. - :ref:`Direct imports <direct-imports>`, where you specify the full source unit name directly.

- :ref:`Direct imports <direct-imports>` では、ソースユニットのフルネームを直接指定します。

.. - :ref:`Relative imports <relative-imports>`, where you specify a path starting with ``./`` or ``../``
..   to be combined with the source unit name of the importing file.

- :ref:`Relative imports <relative-imports>` では、 ``./`` または ``../`` で始まるパスを指定して、インポートファイルのソースユニット名と組み合わせます。

.. code-block:: solidity
    :caption: contracts/contract.sol

    import "./math/math.sol";
    import "contracts/tokens/token.sol";

.. In the above ``./math/math.sol`` and ``contracts/tokens/token.sol`` are import paths while the
.. source unit names they translate to are ``contracts/math/math.sol`` and ``contracts/tokens/token.sol``
.. respectively.

上の例では、 ``./math/math.sol`` と ``contracts/tokens/token.sol`` がインポートパスで、それらが変換するソースユニット名はそれぞれ ``contracts/math/math.sol`` と ``contracts/tokens/token.sol`` です。

.. index:: ! direct import, import; direct
.. _direct-imports:

Direct Imports
--------------

.. An import that does not start with ``./`` or ``../`` is a *direct import*.

``./`` や ``../`` で始まらない輸入は、*direct import* です。

.. code-block:: solidity

    import "/project/lib/util.sol";         // source unit name: /project/lib/util.sol
    import "lib/util.sol";                  // source unit name: lib/util.sol
    import "@openzeppelin/address.sol";     // source unit name: @openzeppelin/address.sol
    import "https://example.com/token.sol"; // source unit name: https://example.com/token.sol

.. After applying any :ref:`import remappings <import-remapping>` the import path simply becomes the
.. source unit name.

:ref:`import remappings <import-remapping>` を適用すると、インポートパスは単にソースユニット名になります。

.. .. note::

..     A source unit name is just an identifier and even if its value happens to look like a path, it
..     is not subject to the normalization rules you would typically expect in a shell.
..     Any ``/./`` or ``/../`` seguments or sequences of multiple slashes remain a part of it.
..     When the source is provided via Standard JSON interface it is entirely possible to associate
..     different content with source unit names that would refer to the same file on disk.

.. note::

    ソースユニット名は単なる識別子であり、その値がたまたまパスのように見えたとしても、シェルで一般的に期待される正規化ルールの対象にはなりません。      ``/./`` や ``/../`` のセグメンテーションや複数のスラッシュのシーケンスがあっても、その一部として残ります。     ソースが標準のJSONインターフェイスで提供されている場合、ディスク上の同じファイルを参照するソースユニット名に、異なるコンテンツを関連付けることができます。

.. When the source is not available in the virtual filesystem, the compiler passes the source unit name
.. to the import callback.
.. The Host Filesystem Loader will attempt to use it as a path and look up the file on disk.
.. At this point the platform-specific normalization rules kick in and names that were considered
.. different in the VFS may actually result in the same file being loaded.
.. For example ``/project/lib/math.sol`` and ``/project/lib/../lib///math.sol`` are considered
.. completely different in the VFS even though they refer to the same file on disk.

ソースが仮想ファイルシステムで利用できない場合、コンパイラはソースユニット名をインポートコールバックに渡します。ホスト・ファイルシステム・ローダはこの名前をパスとして使用し、ディスク上のファイルを検索しようとします。このとき、プラットフォーム固有の正規化ルールが働き、VFSでは異なるとされていた名前が、実際には同じファイルが読み込まれることがあります。例えば、 ``/project/lib/math.sol`` と ``/project/lib/../lib///math.sol`` は、ディスク上の同じファイルを参照しているにもかかわらず、VFSでは全く異なるものとみなされます。

.. .. note::

..     Even if an import callback ends up loading source code for two different source unit names from
..     the same file on disk, the compiler will still see them as separate source units.
..     It is the source unit name that matters, not the physical location of the code.

.. note::

    インポートコールバックがディスク上の同じファイルから2つの異なるソースユニット名のソースコードを読み込むことになっても、コンパイラーはそれらを別々のソースユニットと見なします。     重要なのはソースユニット名であって、コードの物理的な場所ではありません。

.. index:: ! relative import, ! import; relative
.. _relative-imports:

Relative Imports
----------------

.. An import starting with ``./`` or ``../`` is a *relative import*.
.. Such imports specify a path relative to the source unit name of the importing source unit:

``./`` または ``../`` で始まるインポートは、*相対的なインポート* です。このようなインポートは、インポート元のソースユニット名からの相対パスを指定します。

.. code-block:: solidity
    :caption: /project/lib/math.sol

    import "./util.sol" as util;    // source unit name: /project/lib/util.sol
    import "../token.sol" as token; // source unit name: /project/token.sol

.. code-block:: solidity
    :caption: lib/math.sol

    import "./util.sol" as util;    // source unit name: lib/util.sol
    import "../token.sol" as token; // source unit name: token.sol

.. .. note::

..     Relative imports **always** start with ``./`` or ``../`` so ``import "util.sol"``, unlike
..     ``import "./util.sol"``, is a direct import.
..     While both paths would be considered relative in the host filesystem, ``util.sol`` is actually
..     absolute in the VFS.

.. note::

    相対的なインポートである **always** は ``./`` または ``../`` で始まるので、 ``import "util.sol"`` は ``import "./util.sol"`` とは異なり、直接のインポートとなります。     どちらのパスもホストファイルシステムでは相対パスとみなされますが、VFSでは ``util.sol`` が絶対パスとなります。

.. Let us define a *path segment* as any non-empty part of the path that does not contain a separator
.. and is bounded by two path separators.
.. A separator is a forward slash or the beginning/end of the string.
.. For example in ``./abc/..//`` there are three path segments: ``.``, ``abc`` and ``..``.

ここでは、セパレータを含まず、2つのパスセパレータで囲まれた空でない部分を *パスセグメント* と定義します。セパレータとは、フォワードスラッシュや文字列の先頭/末尾のことです。例えば、 ``./abc/..//`` では3つのパスセグメントがあります。 ``.`` 、 ``abc`` 、 ``..``  です。

.. The compiler computes a source unit name from the import path in the following way:

コンパイラは、インポートパスからソースユニット名を以下のように計算します。

.. 1. First a prefix is computed

..     - Prefix is initialized with the source unit name of the importing source unit.

..     - The last path segment with preceding slashes is removed from the prefix.

..     - Then, the leading part of the normalized import path, consisting only of ``/`` and ``.``
..       characters is considered.
..       For every ``..`` segment found in this part the last path segment with preceding slashes is
..       removed from the prefix.

1. まず、プレフィックスを計算します。

    - Prefixは、インポートするソースユニットのソースユニット名で初期化されます。

    - スラッシュが先行する最後のパスセグメントがプレフィックスから削除されます。

    - 次に、 ``/`` と ``.`` の文字のみで構成される正規化されたインポートパスの先頭部分を検討する。       この部分で ``..`` セグメントが見つかるたびに、先行するスラッシュを持つ最後のパスセグメントがプレフィックスから削除されます。

.. 2. Then the prefix is prepended to the normalized import path.
..    If the prefix is non-empty, a single slash is inserted between it and the import path.

2. そして、正規化されたインポートパスの前にプレフィックスが付けられる。    プレフィックスが空でない場合は、プレフィックスとインポートパスの間にスラッシュが1つ挿入されます。

.. The removal of the last path segment with preceding slashes is understood to
.. work as follows:

スラッシュが先行する最後のパスセグメントの削除は、以下のように動作すると理解されています。

.. 1. Everything past the last slash is removed (i.e. ``a/b//c.sol`` becomes ``a/b//``).

1. 最後のスラッシュから先はすべて削除されます（例:  ``a/b//c.sol`` が ``a/b//`` になります）。

.. 2. All trailing slashes are removed (i.e. ``a/b//`` becomes ``a/b``).

2. 後続のスラッシュはすべて削除されます（例:  ``a/b//`` が ``a/b`` になります）。

.. The normalization rules are the same as for UNIX paths, namely:

正規化のルールは、UNIXのパスと同じです。

.. - All the internal ``.`` segments are removed.

- 内部の ``.`` セグメントはすべて削除されます。

.. - Every internal ``..`` segment backtracks one level up in the hierarchy.

- すべての内部 ``..`` セグメントは、1つ上の階層にバックトラックします。

.. - Multiple slashes are squashed into a single one.

- 複数のスラッシュが1つに潰される。

.. Note that normalization is performed only on the import path.
.. The source unit name of the importing module that is used for the prefix remains unnormalized.
.. This ensures that the ``protocol://`` part does not turn into ``protocol:/`` if the importing file
.. is identified with a URL.

正規化はインポートパス上でのみ実行されることに注意してください。プレフィックスに使用されるインポートモジュールのソースユニット名は正規化されずに残ります。これにより、インポートファイルがURLで識別される場合に、 ``protocol://`` の部分が ``protocol:/`` にならないようにしています。

.. If your import paths are already normalized, you can expect the above algorithm to produce very
.. intuitive results.
.. Here are some examples of what you can expect if they are not:

インポートパスがすでに正規化されている場合は、上記のアルゴリズムで非常に直感的な結果を得ることができます。以下は、正規化されていない場合の例です。

.. code-block:: solidity
    :caption: lib/src/../contract.sol

    import "./util/./util.sol";         // source unit name: lib/src/../util/util.sol
    import "./util//util.sol";          // source unit name: lib/src/../util/util.sol
    import "../util/../array/util.sol"; // source unit name: lib/src/array/util.sol
    import "../.././../util.sol";       // source unit name: util.sol
    import "../../.././../util.sol";    // source unit name: util.sol

.. .. note::

..     The use of relative imports containing leading ``..`` segments is not recommended.
..     The same effect can be achieved in a more reliable way by using direct imports with
..     :ref:`base path and include paths <base-and-include-paths>`.

.. note::

    先行する ``..`` セグメントを含む相対輸入品の使用はお勧めできません。     同じ効果を得るには、 :ref:`base path and include paths <base-and-include-paths>` を含む直輸入品を使用する方がより確実です。

.. index:: ! base path, ! --base-path, ! include paths, ! --include-path
.. _base-and-include-paths:

Base Path and Include Paths
===========================

.. The base path and include paths represent directories that the Host Filesystem Loader will load files from.
.. When a source unit name is passed to the loader, it prepends the base path to it and performs a
.. filesystem lookup.
.. If the lookup does not succeed, the same is done with all directories on the include path list.

ベースパスとインクルードパスは、ホストファイルシステムローダがファイルをロードするディレクトリを表します。ローダーにソースユニット名が渡されると、その前にベースパスが付けられ、ファイルシステムのルックアップが行われます。ルックアップが成功しない場合は、インクルードパスリスト上のすべてのディレクトリに対して同様の処理を行います。

.. It is recommended to set the base path to the root directory of your project and use include paths to
.. specify additional locations that may contain libraries your project depends on.
.. This lets you import from these libraries in a uniform way, no matter where they are located in the
.. filesystem relative to your project.
.. For example, if you use npm to install packages and your contract imports
.. ``@openzeppelin/contracts/utils/Strings.sol``, you can use these options to tell the compiler that
.. the library can be found in one of the npm package directories:

ベースパスをプロジェクトのルートディレクトリに設定し、インクルードパスを使って、プロジェクトが依存するライブラリを含む追加の場所を指定することをお勧めします。これにより、プロジェクトのファイルシステム上の位置にかかわらず、これらのライブラリから統一的にインポートできます。例えば、npmを使用してパッケージをインストールし、コントラクトが ``@openzeppelin/contracts/utils/Strings.sol`` をインポートする場合、これらのオプションを使用して、npmパッケージ・ディレクトリのいずれかにライブラリが存在することをコンパイラに伝えることができます。

.. code-block:: bash

    solc contract.sol \
        --base-path . \
        --include-path node_modules/ \
        --include-path /usr/local/lib/node_modules/

.. Your contract will compile (with the same exact metadata) no matter whether you install the library
.. in the local or global package directory or even directly under your project root.

ライブラリをローカル・パッケージ・ディレクトリやグローバル・パッケージ・ディレクトリにインストールしても、あるいはプロジェクト・ルートの直下にインストールしても、コントラクトは（同じメタデータで）コンパイルされます。

.. By default the base path is empty, which leaves the source unit name unchanged.
.. When the source unit name is a relative path, this results in the file being looked up in the
.. directory the compiler has been invoked from.
.. It is also the only value that results in absolute paths in source unit names being actually
.. interpreted as absolute paths on disk.
.. If the base path itself is relative, it is interpreted as relative to the current working directory
.. of the compiler.

デフォルトでは、ベースパスは空で、ソースユニット名は変更されません。ソースユニット名が相対パスの場合、コンパイラを起動したディレクトリでファイルが検索されます。また、ソースユニット名の絶対パスが実際にディスク上の絶対パスとして解釈される唯一の値です。ベースパスが相対パスの場合は、コンパイラの現在の作業ディレクトリからの相対パスとして解釈されます。

.. .. note::

..     Include paths cannot have empty values and must be used together with a non-empty base path.

.. note::

    インクルードパスは空の値を持つことはできず、空ではないベースパスと一緒に使用する必要があります。

.. .. note::

..     Include paths and base path can overlap as long as it does not make import resolution ambiguous.
..     For example, you can specify a directory inside base path as an include directory or have an
..     include directory that is a subdirectory of another include directory.
..     The compiler will only issue an error if the source unit name passed to the Host Filesystem
..     Loader represents an existing path when combined with multiple include paths or an include path
..     and base path.

.. note::

    インクルードパスとベースパスは、インポートの解決を曖昧にしない限り、重なっても構いません。     たとえば、ベースパス内のディレクトリをインクルード・ディレクトリとして指定したり、別のインクルード・ディレクトリのサブディレクトリであるインクルード・ディレクトリを持つことができます。     ホスト・ファイルシステム・ローダーに渡されたソース・ユニット名が、複数のインクルード・パスまたはインクルード・パスとベース・パスの組み合わせで既存のパスを表している場合にのみ、コンパイラはエラーを発行します。

.. _cli-path-normalization-and-stripping:

CLI Path Normalization and Stripping
------------------------------------

.. On the command line the compiler behaves just as you would expect from any other program:
.. it accepts paths in a format native to the platform and relative paths are relative to the current
.. working directory.
.. The source unit names assigned to files whose paths are specified on the command line, however,
.. should not change just because the project is being compiled on a different platform or because the
.. compiler happens to have been invoked from a different directory.
.. To achieve this, paths to source files coming from the command line must be converted to a canonical
.. form, and, if possible, made relative to the base path or one of the include paths.

コマンドラインでは、コンパイラは他のプログラムと同じように動作します。プラットフォームに固有の形式でパスを受け取り、相対パスは現在の作業ディレクトリからの相対パスです。しかし、コマンドラインでパスが指定されたファイルに割り当てられたソースユニット名は、プロジェクトが別のプラットフォームでコンパイルされていたり、コンパイラが別のディレクトリから起動されていたりしても、変更されるべきではありません。そのためには、コマンドラインで指定されたソースファイルのパスを正規の形式に変換し、可能であればベースパスまたはインクルードパスからの相対パスにする必要があります。

.. The normalization rules are as follows:

正規化のルールは以下の通りです。

.. - If a path is relative, it is made absolute by prepending the current working directory to it.

- パスが相対パスの場合は、カレントワーキングディレクトリを先頭に置くことで絶対パスになります。

.. - Internal ``.`` and ``..`` segments are collapsed.

- 内部の ``.`` と ``..`` のセグメントは折りたたまれています。

.. - Platform-specific path separators are replaced with forward slashes.

- プラットフォーム固有のパスセパレータは、フォワードスラッシュに置き換えられます。

.. - Sequences of multiple consecutive path separators are squashed into a single separator (unless
..   they are the leading slashes of an `UNC path <https://en.wikipedia.org/wiki/Path_(computing)#UNC>`_).

- 複数の連続したパスセパレータのシーケンスは、1つのセパレータに潰されます（ `UNC path <https://en.wikipedia.org/wiki/Path_(computing)#UNC>`_ の先頭のスラッシュでない限り）。

.. - If the path includes a root name (e.g. a drive letter on Windows) and the root is the same as the
..   root of the current working directory, the root is replaced with ``/``.

- パスにルート名（Windowsのドライブレターなど）が含まれていて、そのルートが現在の作業ディレクトリのルートと同じ場合は、ルートを ``/`` に置き換えます。

.. - Symbolic links in the path are **not** resolved.

..   - The only exception is the path to the current working directory prepended to relative paths in
..     the process of making them absolute.
..     On some platforms the working directory is reported always with symbolic links resolved so for
..     consistency the compiler resolves them everywhere.

- パスのシンボリックリンクは **not** で解決します。

  - 唯一の例外は、相対パスを絶対パスにする際に、現在の作業ディレクトリへのパスを前置することです。     一部のプラットフォームでは、作業ディレクトリは常にシンボリックリンクが解決された状態で報告されるため、一貫性を保つためにコンパイラはすべての場所でシンボリックリンクを解決します。

.. - The original case of the path is preserved even if the filesystem is case-insensitive but
..   `case-preserving <https://en.wikipedia.org/wiki/Case_preservation>`_ and the actual case on
..   disk is different.

- ファイルシステムでは大文字・小文字を区別しないが、 `case-preserving <https://en.wikipedia.org/wiki/Case_preservation>`_ とディスク上の実際の大文字・小文字が異なる場合でも、パスの元の大文字・小文字は保存される。

.. .. note::

..     There are situations where paths cannot be made platform-independent.
..     For example on Windows the compiler can avoid using drive letters by referring to the root
..     directory of the current drive as ``/`` but drive letters are still necessary for paths leading
..     to other drives.
..     You can avoid such situations by ensuring that all the files are available within a single
..     directory tree on the same drive.

.. note::

    プラットフォームに依存しないパスを作ることができない場合があります。     例えば、Windowsでは、コンパイラが現在のドライブのルート・ディレクトリを ``/`` として参照することで、ドライブ・レターの使用を避けることができますが、他のドライブにつながるパスにはドライブ・レターが必要です。     このような状況を回避するには、すべてのファイルが同じドライブ上の単一のディレクトリ・ツリーで利用できるようにする必要があります。

.. After normalization the compiler attempts to make the source file path relative.
.. It tries the base path first and then the include paths in the order they were given.
.. If the base path is empty or not specified, it is treated as if it was equal to the path to the
.. current working directory (with all symbolic links resolved).
.. The result is accepted only if the normalized directory path is the exact prefix of the normalized
.. file path.
.. Otherwise the file path remains absolute.
.. This makes the conversion unambiguous and ensures that the relative path does not start with ``../``.
.. The resulting file path becomes the source unit name.

正規化後、コンパイラはソースファイルのパスを相対化しようとします。まずベース パスを試し、次にインクルード パスを指定された順に試します。ベース・パスが空であったり、指定されていない場合は、カレント・ワーキング・ディレクトリへのパス（すべてのシンボリック・リンクが解決されている）と同じであるかのように扱われます。この結果は、正規化されたディレクトリパスが正規化されたファイルパスの正確なプレフィックスである場合にのみ受け入れられます。そうでなければ、ファイルパスは絶対的なままです。これにより、変換が曖昧にならず、相対パスが ``../`` で始まらないことが保証されます。変換後のファイルパスがソースユニット名となります。

.. .. note::

..     The relative path produced by stripping must remain unique within the base path and include paths.
..     For example the compiler will issue an error for the following command if both
..     ``/project/contract.sol`` and ``/lib/contract.sol`` exist:

    .. code-block:: bash

        solc /project/contract.sol --base-path /project --include-path /lib

.. .. note::

..     Prior to version 0.8.8, CLI path stripping was not performed and the only normalization applied
..     was the conversion of path separators.
..     When working with older versions of the compiler it is recommended to invoke the compiler from
..     the base path and to only use relative paths on the command line.

.. note::

    ストリッピングによって生成される相対パスは、ベースパスおよびインクルードパス内で一意でなければなりません。     例えば、次のコマンドで ``/project/contract.sol`` と ``/lib/contract.sol`` の両方が存在する場合、コンパイラはエラーを発行します。

.. note::

    バージョン 0.8.8 より前の CLI では、パス・ストリッピングは行われず、適用される正規化はパス・セパレータの変換のみでした。     古いバージョンのコンパイラーを使用する場合は、ベースパスからコンパイラーを起動し、コマンドラインでは相対パスのみを使用することをお勧めします。

.. index:: ! allowed paths, ! --allow-paths, remapping; target
.. _allowed-paths:

Allowed Paths
=============

.. As a security measure, the Host Filesystem Loader will refuse to load files from outside of a few
.. locations that are considered safe by default:

セキュリティ対策として、Host Filesystem Loaderは、デフォルトで安全とされるいくつかの場所以外からのファイルのロードを拒否します。

.. - Outside of Standard JSON mode:

..   - The directories containing input files listed on the command line.

..   - The directories used as :ref:`remapping <import-remapping>` targets.
..     If the target is not a directory (i.e does not end with ``/``, ``/.`` or ``/..``) the directory
..     containing the target is used instead.

..   - Base path and include paths.

- Standard JSONモード以外の場合。

  - コマンドラインで指定された入力ファイルを含むディレクトリ。

  -  :ref:`remapping <import-remapping>` ターゲットとして使用されるディレクトリです。     ターゲットがディレクトリでない場合（ ``/`` 、 ``/.`` 、 ``/..`` で終わらない場合）は、ターゲットを含むディレクトリが代わりに使用されます。

  - ベースパスとインクルードパス

.. - In Standard JSON mode:

..   - Base path and include paths.

- Standard JSONモードの場合。

  - ベースパスとインクルードパス

.. Additional directories can be whitelisted using the ``--allow-paths`` option.
.. The option accepts a comma-separated list of paths:

``--allow-paths`` オプションを使って、追加のディレクトリをホワイトリストに登録できます。このオプションには、コンマで区切られたパスのリストを指定できます。

.. code-block:: bash

    cd /home/user/project/
    solc token/contract.sol \
        lib/util.sol=libs/util.sol \
        --base-path=token/ \
        --include-path=/lib/ \
        --allow-paths=../utils/,/tmp/libraries

.. When the compiler is invoked with the command shown above, the Host Filesystem Loader will allow
.. importing files from the following directories:

上記のコマンドでコンパイラを起動した場合、Host Filesystem Loaderは以下のディレクトリからのファイルのインポートを許可します。

.. - ``/home/user/project/token/`` (because ``token/`` contains the input file and also because it is
..   the base path),

- ``/home/user/project/token/`` （ ``token/`` には入力ファイルがあり、またベースパスでもあるため）。

.. - ``/lib/`` (because ``/lib/`` is one of the include paths),

- ``/lib/`` （ ``/lib/`` はインクルードパスの一つですから）。

.. - ``/home/user/project/libs/`` (because ``libs/`` is a directory containing a remapping target),

- ``/home/user/project/libs/`` （ ``libs/`` はリマップ対象を含むディレクトリのため）。

.. - ``/home/user/utils/`` (because of ``../utils/`` passed to ``--allow-paths``),

- ``/home/user/utils/`` （ ``../utils/`` が ``--allow-paths`` にパスされたため）。

.. - ``/tmp/libraries/`` (because of ``/tmp/libraries`` passed to ``--allow-paths``),

- ``/tmp/libraries/`` （ ``/tmp/libraries`` が ``--allow-paths`` にパスされたため）。

.. .. note::

..     The working directory of the compiler is one of the paths allowed by default only if it
..     happens to be the base path (or the base path is not specified or has an empty value).

.. note::

    コンパイラの作業ディレクトリは、デフォルトで許可されているパスのうち、たまたまベースパスであった場合（またはベースパスが指定されていないか空の値であった場合）にのみ許可されます。

.. .. note::

..     The compiler does not check if allowed paths actually exist and whether they are directories.
..     Non-existent or empty paths are simply ignored.
..     If an allowed path matches a file rather than a directory, the file is considered whitelisted, too.

.. note::

    コンパイラは、許可されたパスが実際に存在するかどうか、またそれらがディレクトリであるかどうかはチェックしません。     存在しないパスや空のパスは単に無視されます。     許可されたパスがディレクトリではなくファイルに一致した場合、そのファイルもホワイトリストとみなされます。

.. .. note::

..     Allowed paths are case-sensitive even if the filesystem is not.
..     The case must exactly match the one used in your imports.
..     For example ``--allow-paths tokens`` will not match ``import "Tokens/IERC20.sol"``.

.. note::

    許可されたパスは、ファイルシステムがそうでない場合でも、大文字と小文字を区別します。     大文字と小文字は、インポートで使われているものと正確に一致しなければなりません。     例えば、 ``--allow-paths tokens`` は ``import "Tokens/IERC20.sol"`` とは一致しません。

.. .. warning::

..     Files and directories only reachable through symbolic links from allowed directories are not
..     automatically whitelisted.
..     For example if ``token/contract.sol`` in the example above was actually a symlink pointing at
..     ``/etc/passwd`` the compiler would refuse to load it unless ``/etc/`` was one of the allowed
..     paths too.

.. warning::

    許可されているディレクトリからシンボリックリンクでのみアクセスできるファイルやディレクトリは、自動的にホワイトリストに登録されません。     例えば、上の例の ``token/contract.sol`` が実際には ``/etc/passwd`` を指すシンボリックリンクであった場合、 ``/etc/`` が許可されたパスの一つでない限り、コンパイラはそれを読み込むことを拒否します。

.. index:: ! remapping; import, ! import; remapping, ! remapping; context, ! remapping; prefix, ! remapping; target
.. _import-remapping:

Import Remapping
================

.. Import remapping allows you to redirect imports to a different location in the virtual filesystem.
.. The mechanism works by changing the translation between import paths and source unit names.
.. For example you can set up a remapping so that any import from the virtual directory
.. ``github.com/ethereum/dapp-bin/library/`` would be seen as an import from ``dapp-bin/library/`` instead.

インポートリマッピングでは、インポートを仮想ファイルシステムの異なる場所にリダイレクトできます。このメカニズムは、インポートパスとソースユニット名の間の変換を変更することで機能します。例えば、仮想ディレクトリ ``github.com/ethereum/dapp-bin/library/`` からのインポートを、代わりに ``dapp-bin/library/`` からのインポートと見なすようなリマッピングを設定できます。

.. You can limit the scope of a remapping by specifying a *context*.
.. This allows creating remappings that apply only to imports located in a specific library or a specific file.
.. Without a context a remapping is applied to every matching import in all the files in the virtual
.. filesystem.

コンテキスト*を指定することで、リマッピングの範囲を制限できます。これにより、特定のライブラリまたは特定のファイルにあるインポートのみに適用されるリマッピングを作成できます。コンテキストを指定しない場合、リマッピングは仮想ファイルシステム内のすべてのファイルにある、一致するすべてのインポートに適用されます。

.. Import remappings have the form of ``context:prefix=target``:

インポートのリマッピングは ``context:prefix=target`` の形をしています。

.. - ``context`` must match the beginning of the source unit name of the file containing the import.

- ``context`` は、インポートを含むファイルのソースユニット名の先頭と一致する必要があります。

.. - ``prefix`` must match the beginning of the source unit name resulting from the import.

- ``prefix`` は、インポート後のソースユニット名の先頭と一致する必要があります。

.. - ``target`` is the value the prefix is replaced with.

- ``target`` は、プレフィックスが置き換えられる値です。

.. For example, if you clone https://github.com/ethereum/dapp-bin/ locally to ``/project/dapp-bin``
.. and run the compiler with:

例えば、ローカルでhttps://github.com/ethereum/dapp-bin/ を ``/project/dapp-bin`` にクローンして、コンパイラを実行した場合。

.. code-block:: bash

    solc github.com/ethereum/dapp-bin/=dapp-bin/ --base-path /project source.sol

.. you can use the following in your source file:

をソースファイルに記述できます。

.. code-block:: solidity

    import "github.com/ethereum/dapp-bin/library/math.sol"; // source unit name: dapp-bin/library/math.sol

.. The compiler will look for the file in the VFS under ``dapp-bin/library/math.sol``.
.. If the file is not available there, the source unit name will be passed to the Host Filesystem
.. Loader, which will then look in ``/project/dapp-bin/library/iterable_mapping.sol``.

コンパイラは、 ``dapp-bin/library/math.sol`` の下のVFSでファイルを探します。そこにファイルがない場合は、ソースユニット名がホストファイルシステムローダに渡され、ホストファイルシステムローダは ``/project/dapp-bin/library/iterable_mapping.sol`` を探します。

.. .. warning::

..     Information about remappings is stored in contract metadata.
..     Since the binary produced by the compiler has a hash of the metadata embedded in it, any
..     modification to the remappings will result in different bytecode.

..     For this reason you should be careful not to include any local information in remapping targets.
..     For example if your library is located in ``/home/user/packages/mymath/math.sol``, a remapping
..     like ``@math/=/home/user/packages/mymath/`` would result in your home directory being included in
..     the metadata.
..     To be able to reproduce the same bytecode with such a remapping on a different machine, you
..     would need to recreate parts of your local directory structure in the VFS and (if you rely on
..     Host Filesystem Loader) also in the host filesystem.

..     To avoid having your local directory structure embedded in the metadata, it is recommended to
..     designate the directories containing libraries as *include paths* instead.
..     For example, in the example above ``--include-path /home/user/packages/`` would let you use
..     imports starting with ``mymath/``.
..     Unlike remapping, the option on its own will not make ``mymath`` appear as ``@math`` but this
..     can be achieved by creating a symbolic link or renaming the package subdirectory.

.. warning::

    リマッピングに関する情報はコントラクトメタデータに格納されています。     コンパイラが生成するバイナリにはメタデータのハッシュが埋め込まれているため、リマッピングを変更すると異なるバイトコードになります。

    このため、リマッピングのターゲットにローカル情報が含まれないように注意する必要があります。     例えば、あなたのライブラリが ``/home/user/packages/mymath/math.sol`` にある場合、 ``@math/=/home/user/packages/mymath/`` のようなリマッピングを行うと、あなたのホームディレクトリがメタデータに含まれることになります。     このようなリマッピングを行った同じバイトコードを別のマシンで再現するためには、ローカルのディレクトリ構造の一部をVFSに、（Host Filesystem Loaderに依存している場合は）ホスト・ファイルシステムにも再現する必要があります。

    ローカルのディレクトリ構造がメタデータに埋め込まれるのを避けるために、ライブラリを含むディレクトリを*include path*として指定することが推奨されます。     例えば、上記の例では、 ``--include-path /home/user/packages/`` を指定すると、 ``mymath/`` で始まるインポートを使用できます。     リマッピングとは異なり、このオプションだけでは ``mymath`` を ``@math`` に見せることはできませんが、シンボリックリンクを作成したり、パッケージのサブディレクトリの名前を変更することで実現できます。

.. As a more complex example, suppose you rely on a module that uses an old version of dapp-bin that
.. you checked out to ``/project/dapp-bin_old``, then you can run:

もっと複雑な例として、 ``/project/dapp-bin_old`` にチェックアウトした古いバージョンのdapp-binを使っているモジュールに依存しているとします。

.. code-block:: bash

    solc module1:github.com/ethereum/dapp-bin/=dapp-bin/ \
         module2:github.com/ethereum/dapp-bin/=dapp-bin_old/ \
         --base-path /project \
         source.sol

.. This means that all imports in ``module2`` point to the old version but imports in ``module1``
.. point to the new version.

つまり、 ``module2`` のインポート品はすべて旧バージョンを指しますが、 ``module1`` のインポート品は新バージョンを指します。

.. Here are the detailed rules governing the behaviour of remappings:

ここでは、リマップの動作に関する詳細なルールをご紹介します。

.. #. **Remappings only affect the translation between import paths and source unit names.**

..    Source unit names added to the VFS in any other way cannot be remapped.
..    For example the paths you specify on the command-line and the ones in ``sources.urls`` in
..    Standard JSON are not affected.

   .. code-block:: bash

       solc /project/=/contracts/ /project/contract.sol # source unit name: /project/contract.sol

   In the example above the compiler will load the source code from ``/project/contract.sol`` and
   place it under that exact source unit name in the VFS, not under ``/contract/contract.sol``.

.. #. **Context and prefix must match source unit names, not import paths.**

..    - This means that you cannot remap ``./`` or ``../`` directly since they are replaced during
..      the translation to source unit name but you can remap the part of the name they are replaced
..      with:

     .. code-block:: bash

         solc ./=a/ /project/=b/ /project/contract.sol # source unit name: /project/contract.sol

     .. code-block:: solidity
         :caption: /project/contract.sol

         import "./util.sol" as util; // source unit name: b/util.sol

   - You cannot remap base path or any other part of the path that is only added internally by an
     import callback:

     .. code-block:: bash

         solc /project/=/contracts/ /project/contract.sol --base-path /project # source unit name: contract.sol

     .. code-block:: solidity
         :caption: /project/contract.sol

         import "util.sol" as util; // source unit name: util.sol

.. #. **Target is inserted directly into the source unit name and does not necessarily have to be a valid path.**

..    - It can be anything as long as the import callback can handle it.
..      In case of the Host Filesystem Loader this includes also relative paths.
..      When using the JavaScript interface you can even use URLs and abstract identifiers if
..      your callback can handle them.

..    - Remapping happens after relative imports have already been resolved into source unit names.
..      This means that targets starting with ``./`` and ``../`` have no special meaning and are
..      relative to the base path rather than to the location of the source file.

..    - Remapping targets are not normalized so ``@root/=./a/b//`` will remap ``@root/contract.sol``
..      to ``./a/b//contract.sol`` and not ``a/b/contract.sol``.

..    - If the target does not end with a slash, the compiler will not add one automatically:

     .. code-block:: bash

         solc /project/=/contracts /project/contract.sol # source unit name: /project/contract.sol

     .. code-block:: solidity
         :caption: /project/contract.sol

         import "/project/util.sol" as util; // source unit name: /contractsutil.sol

.. #. **Context and prefix are patterns and matches must be exact.**

..    - ``a//b=c`` will not match ``a/b``.

..    - source unit names are not normalized so ``a/b=c`` will not match ``a//b`` either.

..    - Parts of file and directory names can match as well.
..      ``/newProject/con:/new=old`` will match ``/newProject/contract.sol`` and remap it to
..      ``oldProject/contract.sol``.

#. **Remappings only affect the translation between import paths and source unit names.**

   その他の方法でVFSに追加されたソースユニット名は、リマップできません。    例えば、コマンドラインで指定したパスや、Standard JSONの ``sources.urls`` にあるパスは影響を受けません。

#. **Context and prefix must match source unit names, not import paths.**

   - つまり、 ``./`` や ``../`` はソースユニット名への変換時に置き換えられてしまうため、直接リマップできませんが、置き換えられた部分をリマップすることは可能です。

#. **Target is inserted directly into the source unit name and does not necessarily have to be a valid path.**

   - インポートコールバックがそれを処理できる限り、何でもよいのです。      ホスト ファイルシステム ローダーの場合は、相対パスも含まれます。      JavaScriptインターフェースを使用する場合、コールバックが処理できるならば、URLや抽象的な識別子を使用することもできます。

   - リマッピングは、相対的なインポートがすでにソースユニット名に解決された後に行われます。      つまり、 ``./`` や ``../`` で始まるターゲットは特別な意味を持たず、ソースファイルの位置ではなくベースパスに対する相対的なものです。

   - リマップ対象は正規化されていないので、 ``@root/=./a/b//`` は ``@root/contract.sol`` を ``./a/b//contract.sol`` にリマップし、 ``a/b/contract.sol`` にはなりません。

   - ターゲットがスラッシュで終わっていない場合、コンパイラは自動的にスラッシュを追加しません。

#. **Context and prefix are patterns and matches must be exact.**

   -  ``a//b=c`` は ``a/b`` に合わせない。

   - ソースユニット名は正規化されていないので、 ``a/b=c`` は ``a//b`` にもマッチしません。

   - ファイル名やディレクトリ名の一部もマッチします。       ``/newProject/con:/new=old`` は ``/newProject/contract.sol`` と一致し、 ``oldProject/contract.sol`` にリマップされます。

.. #. **At most one remapping is applied to a single import.**

..    - If multiple remappings match the same source unit name, the one with the longest matching
..      prefix is chosen.

..    - If prefixes are identical, the one specified last wins.

..    - Remappings do not work on other remappings. For example ``a=b b=c c=d`` will not result in ``a``
..      being remapped to ``d``.

#. **At most one remapping is applied to a single import.**

   - 複数のリマッピングが同じソースユニット名と一致する場合、最も長く一致する接頭辞を持つものが選択されます。

   - プレフィックスが同一の場合は、最後に指定されたものが優先されます。

   - リマッピングは、他のリマッピングには作用しません。例えば、 ``a=b b=c c=d`` は ``a`` を ``d`` にリマッピングすることはありません。

.. #. **Prefix cannot be empty but context and target are optional.**

..    - If ``target`` is the empty string, ``prefix`` is simply removed from import paths.

..    - Empty ``context`` means that the remapping applies to all imports in all source units.

#. **Prefix cannot be empty but context and target are optional.**

   -  ``target`` が空の文字列の場合、 ``prefix`` は単にインポートパスから削除されます。

   - 空の ``context`` は、リマッピングがすべてのソースユニットのすべてのインポートに適用されることを意味します。

.. index:: Remix IDE, file://

Using URLs in imports
=====================

.. Most URL prefixes such as ``https://`` or ``data://`` have no special meaning in import paths.
.. The only exception is ``file://`` which is stripped from source unit names by the Host Filesystem
.. Loader.

``https://`` や ``data://`` のようなほとんどのURLプレフィックスは、インポートパスでは特別な意味を持ちません。唯一の例外は ``file://`` で、これはHost Filesystem Loaderによってソースユニット名から取り除かれます。

.. When compiling locally you can use import remapping to replace the protocol and domain part with a
.. local path:

ローカルにコンパイルする場合、インポートリマッピングを使用して、プロトコルとドメインの部分をローカルパスに置き換えることができます。

.. code-block:: bash

    solc :https://github.com/ethereum/dapp-bin=/usr/local/dapp-bin contract.sol

.. Note the leading ``:``, which is necessary when the remapping context is empty.
.. Otherwise the ``https:`` part would be interpreted by the compiler as the context.
.. 

先頭の ``:`` に注目してください。これは、リマッピングコンテキストが空の場合に必要です。そうしないと、 ``https:`` の部分がコンパイラーによって文脈として解釈されてしまいます。
