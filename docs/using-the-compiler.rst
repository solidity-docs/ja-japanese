******************
Using the Compiler
******************

.. index:: ! commandline compiler, compiler;commandline, ! solc

.. _commandline-compiler:

Using the Commandline Compiler
******************************

.. .. note::

..     This section does not apply to :ref:`solcjs <solcjs>`, not even if it is used in commandline mode.

.. note::

    このセクションは :ref:`solcjs <solcjs>` には適用されず、コマンドラインモードで使用されても適用されません。

Basic Usage
-----------

.. One of the build targets of the Solidity repository is ``solc``, the solidity commandline compiler.
.. Using ``solc --help`` provides you with an explanation of all options. The compiler can produce various outputs, ranging from simple binaries and assembly over an abstract syntax tree (parse tree) to estimations of gas usage.
.. If you only want to compile a single file, you run it as ``solc --bin sourceFile.sol`` and it will print the binary. If you want to get some of the more advanced output variants of ``solc``, it is probably better to tell it to output everything to separate files using ``solc -o outputDirectory --bin --ast-compact-json --asm sourceFile.sol``.

Solidityリポジトリのビルドターゲットの1つは、solidityのコマンドラインコンパイラである ``solc`` です。 ``solc --help`` を使用すると、すべてのオプションの説明を受けることができます。コンパイラは、抽象的な構文木（パースツリー）上の単純なバイナリやアセンブリから、ガス使用量の推定値まで、さまざまな出力を行うことができます。単一のファイルをコンパイルしたいだけなら、 ``solc --bin sourceFile.sol`` として実行すれば、バイナリを出力します。 ``solc`` のより高度な出力を得たい場合は、 ``solc -o outputDirectory --bin --ast-compact-json --asm sourceFile.sol`` を使ってすべてを別々のファイルに出力するように指示したほうがよいでしょう。

Optimizer Options
-----------------

.. Before you deploy your contract, activate the optimizer when compiling using ``solc --optimize --bin sourceFile.sol``.
.. By default, the optimizer will optimize the contract assuming it is called 200 times across its lifetime
.. (more specifically, it assumes each opcode is executed around 200 times).
.. If you want the initial contract deployment to be cheaper and the later function executions to be more expensive,
.. set it to ``--optimize-runs=1``. If you expect many transactions and do not care for higher deployment cost and
.. output size, set ``--optimize-runs`` to a high number.
.. This parameter has effects on the following (this might change in the future):

コントラクトをデプロイする前に、 ``solc --optimize --bin sourceFile.sol`` を使ってコンパイルする際にオプティマイザを有効にします。デフォルトでは、オプティマイザは、コントラクトがそのライフタイム全体で200回呼び出されると仮定して最適化します（より具体的には、各オペコードが約200回実行されると仮定します）。最初のコントラクトデプロイを安価にし、後の関数実行を高価にしたい場合は、 ``--optimize-runs=1`` に設定してください。多くのトランザクションが予想され、デプロイコストや出力サイズが高くなっても気にしない場合は、 ``--optimize-runs`` を高い数値に設定してください。このパラメータは以下に影響を与えます（将来的に変更される可能性があります）。

.. - the size of the binary search in the function dispatch routine

- 関数ディスパッチルーチンでのバイナリ検索のサイズ

.. - the way constants like large numbers or strings are stored

- 大きな数字や文字列などの定数の保存方法について

.. index:: allowed paths, --allow-paths, base path, --base-path, include paths, --include-path

Base Path and Import Remapping
------------------------------

.. The commandline compiler will automatically read imported files from the filesystem, but
.. it is also possible to provide :ref:`path redirects <import-remapping>` using ``prefix=path`` in the following way:

コマンドライン・コンパイラは、インポートされたファイルをファイルシステムから自動的に読み込みますが、以下のように ``prefix=path`` を使って :ref:`path redirects <import-remapping>` を提供することも可能です。

.. code-block:: bash

    solc github.com/ethereum/dapp-bin/=/usr/local/lib/dapp-bin/ file.sol

.. This essentially instructs the compiler to search for anything starting with
.. ``github.com/ethereum/dapp-bin/`` under ``/usr/local/lib/dapp-bin``.

これは基本的に、 ``github.com/ethereum/dapp-bin/`` で始まるものを ``/usr/local/lib/dapp-bin`` の下で検索するようにコンパイラに指示するものです。

.. When accessing the filesystem to search for imports, :ref:`paths that do not start with ./
.. or ../ <direct-imports>` are treated as relative to the directories specified using
.. ``--base-path`` and ``--include-path`` options (or the current working directory if base path is not specified).
.. Furthermore, the part of the path added via these options will not appear in the contract metadata.

インポートを検索するためにファイルシステムにアクセスする際、 :ref:`paths that do not start with ./ or ../ <direct-imports>` は ``--base-path`` および ``--include-path`` オプションで指定されたディレクトリ（ベースパスが指定されていない場合はカレントワーキングディレクトリ）からの相対パスとして扱われます。また、これらのオプションで追加されたパスの部分は、コントラクトのメタデータには表示されません。

.. For security reasons the compiler has :ref:`restrictions on what directories it can access <allowed-paths>`.
.. Directories of source files specified on the command line and target paths of
.. remappings are automatically allowed to be accessed by the file reader, but everything
.. else is rejected by default.
.. Additional paths (and their subdirectories) can be allowed via the
.. ``--allow-paths /sample/path,/another/sample/path`` switch.
.. Everything inside the path specified via ``--base-path`` is always allowed.

セキュリティ上の理由から、コンパイラは :ref:`restrictions on what directories it can access <allowed-paths>` .コマンドラインで指定されたソースファイルのディレクトリと、リマッピングのターゲットパスは、ファイルリーダーからのアクセスが自動的に許可されますが、それ以外はデフォルトで拒否されます。 ``--allow-paths /sample/path,/another/sample/path``  スイッチで追加のパス（およびそのサブディレクトリ）を許可できます。 ``--base-path``  で指定されたパスの中のものは常に許可されます。

.. The above is only a simplification of how the compiler handles import paths.
.. For a detailed explanation with examples and discussion of corner cases please refer to the section on
.. :ref:`path resolution <path-resolution>`.

上記は、コンパイラがインポートパスをどのように処理するかを簡単に説明したものです。例を挙げての詳細な説明やコーナーケースについては、 :ref:`path resolution <path-resolution>` のセクションを参照してください。

.. index:: ! linker, ! --link, ! --libraries
.. _library-linking:

Library Linking
---------------

.. If your contracts use :ref:`libraries <libraries>`, you will notice that the bytecode contains substrings of the form ``__$53aea86b7d70b31448b230b20ae141a537$__``. These are placeholders for the actual library addresses.
.. The placeholder is a 34 character prefix of the hex encoding of the keccak256 hash of the fully qualified library name.
.. The bytecode file will also contain lines of the form ``// <placeholder> -> <fq library name>`` at the end to help
.. identify which libraries the placeholders represent. Note that the fully qualified library name
.. is the path of its source file and the library name separated by ``:``.
.. You can use ``solc`` as a linker meaning that it will insert the library addresses for you at those points:

コントラクトで :ref:`libraries <libraries>` を使用している場合、バイトコードに ``__$53aea86b7d70b31448b230b20ae141a537$__`` という形式の部分文字列が含まれていることに気づくでしょう。これは、実際のライブラリアドレスのプレースホルダーです。プレースホルダーは、完全修飾ライブラリ名の keccak256 ハッシュの 16 進数エンコーディングの 34 文字のプレフィックスです。また、バイトコードファイルには、プレースホルダーがどのライブラリを表しているかを識別するために、最後に ``// <placeholder> -> <fq library name>`` という形式の行が含まれます。完全修飾ライブラリ名は、そのソースファイルのパスとライブラリ名を ``:`` で区切ったものであることに注意してください。 ``solc`` をリンカーとして使用すると、これらの箇所にライブラリのアドレスを挿入してくれます。

.. Either add ``--libraries "file.sol:Math=0x1234567890123456789012345678901234567890 file.sol:Heap=0xabCD567890123456789012345678901234567890"`` to your command to provide an address for each library (use commas or spaces as separators) or store the string in a file (one library per line) and run ``solc`` using ``--libraries fileName``.

``--libraries "file.sol:Math=0x1234567890123456789012345678901234567890 file.sol:Heap=0xabCD567890123456789012345678901234567890"`` をコマンドに追加して各ライブラリのアドレスを指定するか（セパレータにはカンマまたはスペースを使用）、文字列をファイルに保存して（1行に1ライブラリ）、 ``--libraries fileName`` を使って ``solc`` を実行するかです。

.. .. note::

..     Starting Solidity 0.8.1 accepts ``=`` as separator between library and address, and ``:`` as a separator is deprecated. It will be removed in the future. Currently ``--libraries "file.sol:Math:0x1234567890123456789012345678901234567890 file.sol:Heap:0xabCD567890123456789012345678901234567890"`` will work too.

.. note::

    Solidity 0.8.1より、ライブラリとアドレスの間のセパレータとして ``=`` を受け入れ、セパレータとしての ``:`` は非推奨となりました。将来的には削除される予定です。現在は ``--libraries "file.sol:Math:0x1234567890123456789012345678901234567890 file.sol:Heap:0xabCD567890123456789012345678901234567890"`` も動作します。

.. index:: --standard-json, --base-path

.. If ``solc`` is called with the option ``--standard-json``, it will expect a JSON input (as explained below) on the standard input, and return a JSON output on the standard output. This is the recommended interface for more complex and especially automated uses. The process will always terminate in a "success" state and report any errors via the JSON output.
.. The option ``--base-path`` is also processed in standard-json mode.

``solc`` が ``--standard-json`` オプション付きで呼び出された場合、標準入力に（以下に説明する）JSONの入力を受け取り、標準出力にJSONの出力を返します。これは、より複雑な用途、特に自動化された用途に推奨されるインターフェースです。プロセスは常に「成功」の状態で終了し、エラーがあればJSON出力で報告されます。オプション ``--base-path`` もstandard-jsonモードで処理されます。

.. If ``solc`` is called with the option ``--link``, all input files are interpreted to be unlinked binaries (hex-encoded) in the ``__$53aea86b7d70b31448b230b20ae141a537$__``-format given above and are linked in-place (if the input is read from stdin, it is written to stdout). All options except ``--libraries`` are ignored (including ``-o``) in this case.

``solc`` がオプション ``--link`` 付きで呼ばれた場合、すべての入力ファイルは、上記で与えられた ``__$53aea86b7d70b31448b230b20ae141a537$__`` 形式のリンクされていないバイナリ（16進コード）と解釈され、その場でリンクされます（入力が標準入力から読み込まれた場合は、標準出力に書き込まれます）。この場合、 ``--libraries`` 以外のオプションはすべて無視されます（ ``-o`` も含む）。

.. .. warning::

..     Manually linking libraries on the generated bytecode is discouraged because it does not update
..     contract metadata. Since metadata contains a list of libraries specified at the time of
..     compilation and bytecode contains a metadata hash, you will get different binaries, depending
..     on when linking is performed.

..     You should ask the compiler to link the libraries at the time a contract is compiled by either
..     using the ``--libraries`` option of ``solc`` or the ``libraries`` key if you use the
..     standard-JSON interface to the compiler.

.. warning::

    生成されたバイトコード上でライブラリを手動でリンクすることは、コントラクトのメタデータが更新されないため、推奨されません。メタデータにはコンパイル時に指定されたライブラリのリストが含まれており、バイトコードにはメタデータのハッシュが含まれているため、リンクを実行するタイミングによって異なるバイナリが得られることになります。

     コントラクトのコンパイル時にライブラリをリンクするようにコンパイラに依頼するには、 ``solc`` の ``--libraries`` オプションを使用するか、コンパイラへの標準JSONインターフェースを使用する場合は ``libraries`` キーを使用する必要があります。

.. .. note::

..     The library placeholder used to be the fully qualified name of the library itself
..     instead of the hash of it. This format is still supported by ``solc --link`` but
..     the compiler will no longer output it. This change was made to reduce
..     the likelihood of a collision between libraries, since only the first 36 characters
..     of the fully qualified library name could be used.

.. note::

    ライブラリのプレースホルダーは、以前はライブラリのハッシュではなく、ライブラリ自体の完全修飾名でした。この形式は ``solc --link`` ではまだサポートされていますが、コンパイラでは出力されなくなりました。この変更は、完全修飾ライブラリ名の最初の36文字しか使用できないため、ライブラリ間の衝突の可能性を減らすために行われました。

.. _evm-version:
.. index:: ! EVM version, compile target

Setting the EVM Version to Target
*********************************

.. When you compile your contract code you can specify the Ethereum virtual machine
.. version to compile for to avoid particular features or behaviours.

コントラクトコードをコンパイルする際に、特定の機能や動作を避けるためにコンパイルするEthereum仮想マシンのバージョンを指定できます。

.. .. warning::

..    Compiling for the wrong EVM version can result in wrong, strange and failing
..    behaviour. Please ensure, especially if running a private chain, that you
..    use matching EVM versions.

.. warning::

   EVMのバージョンを間違えてコンパイルすると、間違った動作、おかしな動作、失敗することがあります。特にプライベートチェーンを実行している場合は、一致するEVMバージョンを使用するようにしてください。

.. On the command line, you can select the EVM version as follows:

コマンドラインでは、以下のようにEVMのバージョンを選択できます。

.. code-block:: shell

  solc --evm-version <VERSION> contract.sol

.. In the :ref:`standard JSON interface <compiler-api>`, use the ``"evmVersion"``
.. key in the ``"settings"`` field:

:ref:`standard JSON interface <compiler-api>` では、 ``"settings"`` フィールドに ``"evmVersion"`` キーを使用します。

.. code-block:: javascript

    {
      "sources": {/* ... */},
      "settings": {
        "optimizer": {/* ... */},
        "evmVersion": "<VERSION>"
      }
    }

Target Options
--------------

.. Below is a list of target EVM versions and the compiler-relevant changes introduced
.. at each version. Backward compatibility is not guaranteed between each version.

以下は、対象となるEVMのバージョンと、各バージョンで導入されたコンパイラ関連の変更点の一覧です。各バージョン間の下位互換性は保証されていません。

.. - ``homestead``

- ``homestead``

.. - (oldest version)

- (古いバージョン)

.. - ``tangerineWhistle``

- ``tangerineWhistle``

.. - Gas cost for access to other accounts increased, relevant for gas estimation and the optimizer.

- 他のアカウントへのアクセスのためのガスコストが増加し、ガス推定とオプティマイザに関連する。

.. - All gas sent by default for external calls, previously a certain amount had to be retained.

- 外部からの電話に対しては、デフォルトですべてのガスが送信されますが、従来は一定量を保持する必要がありました。

.. - ``spuriousDragon``

- ``spuriousDragon``

.. - Gas cost for the ``exp`` opcode increased, relevant for gas estimation and the optimizer.

- ``exp`` オペコードのガスコストが増加し、ガス推定とオプティマイザに関連する。

.. - ``byzantium``

- ``byzantium``

.. - Opcodes ``returndatacopy``, ``returndatasize`` and ``staticcall`` are available in assembly.

- オペコード ``returndatacopy`` 、 ``returndatasize`` 、 ``staticcall`` はアセンブリで利用可能です。

.. - The ``staticcall`` opcode is used when calling non-library view or pure functions, which prevents the functions from modifying state at the EVM level, i.e., even applies when you use invalid type conversions.

- ``staticcall``  opcodeは、ライブラリではないビューや純粋な関数を呼び出す際に使用され、関数がEVMレベルで状態を変更することを防ぎます。つまり、無効な型変換を使用している場合でも適用されます。

.. - It is possible to access dynamic data returned from function calls.

- ファンクションコールから返されたダイナミックデータにアクセスすることが可能です。

.. - ``revert`` opcode introduced, which means that ``revert()`` will not waste gas.

- ``revert`` のオペコードが導入されたことで、 ``revert()`` がガスを無駄にしないようになりました。

.. - ``constantinople``

- ``constantinople``

.. - Opcodes ``create2`, ``extcodehash``, ``shl``, ``shr`` and ``sar`` are available in assembly.

- Opcode ` `create2` ,  ``extcodehash`` ,  ``shl`` ,  ``shr`` ,  ``sar`` はアセンブリで使用可能です。

.. - Shifting operators use shifting opcodes and thus need less gas.

- シフト演算子は、シフトオペコードを使用するため、より少ないガスで済みます。

- ``petersburg``

.. - The compiler behaves the same way as with constantinople.

- コンパイラは constantinople の場合と同じように動作します。

.. - ``istanbul``

- ``istanbul``

.. - Opcodes ``chainid`` and ``selfbalance`` are available in assembly.

- Opcodes  ``chainid`` と ``selfbalance`` はアセンブリで利用可能です。

.. - ``berlin``

- ``berlin``

.. - Gas costs for ``SLOAD``, ``*CALL``, ``BALANCE``, ``EXT*`` and ``SELFDESTRUCT`` increased. The
..      compiler assumes cold gas costs for such operations. This is relevant for gas estimation and
..      the optimizer.

- ``SLOAD`` 、 ``*CALL`` 、 ``BALANCE`` 、 ``EXT*`` 、 ``SELFDESTRUCT`` のガス代が増加しました。コンパイラーは、このような操作に対して冷たいガスコストを想定しています。これは、ガス推定とオプティマイザに関連します。

.. - ``london`` (**default**)

- ``london``  ( **default** )

.. - The block's base fee (`EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ and `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_) can be accessed via the global ``block.basefee`` or ``basefee()`` in inline assembly.

- ブロックの基本料金（ `EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ および `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_ ）は、インラインアセンブリのグローバル ``block.basefee`` または ``basefee()`` を介してアクセスできます。

.. index:: ! standard JSON, ! --standard-json
.. _compiler-api:

Compiler Input and Output JSON Description
******************************************

.. The recommended way to interface with the Solidity compiler especially for
.. more complex and automated setups is the so-called JSON-input-output interface.
.. The same interface is provided by all distributions of the compiler.

Solidity コンパイラとのインターフェースとして、特に複雑な自動化されたセットアップには、いわゆる JSON-input-output インターフェースを使用することをお勧めします。このインターフェースは、コンパイラのすべてのディストリビューションで提供されています。

.. The fields are generally subject to change,
.. some are optional (as noted), but we try to only make backwards compatible changes.

フィールドは一般的に変更される可能性があり、いくつかの項目はオプションですが（前述のとおり）、後方互換性のある変更のみを行うようにしています。

.. The compiler API expects a JSON formatted input and outputs the compilation result in a JSON formatted output.
.. The standard error output is not used and the process will always terminate in a "success" state, even
.. if there were errors. Errors are always reported as part of the JSON output.

コンパイラAPIは、JSON形式の入力を期待し、コンパイル結果をJSON形式の出力で出力します。標準のエラー出力は使用されず、エラーがあった場合でも、常に「成功」の状態で処理が終了します。エラーは常にJSON出力の一部として報告されます。

.. The following subsections describe the format through an example.
.. Comments are of course not permitted and used here only for explanatory purposes.

以下のサブセクションでは、例を挙げてフォーマットを説明します。もちろん、コメントは許可されておらず、ここでは説明のためにのみ使用されています。

Input Description
-----------------

.. code-block:: javascript

    {
      // Required: Source code language. Currently supported are "Solidity" and "Yul".
      "language": "Solidity",
      // Required
      "sources":
      {
        // The keys here are the "global" names of the source files,
        // imports can use other files via remappings (see below).
        "myFile.sol":
        {
          // Optional: keccak256 hash of the source file
          // It is used to verify the retrieved content if imported via URLs.
          "keccak256": "0x123...",
          // Required (unless "content" is used, see below): URL(s) to the source file.
          // URL(s) should be imported in this order and the result checked against the
          // keccak256 hash (if available). If the hash doesn't match or none of the
          // URL(s) result in success, an error should be raised.
          // Using the commandline interface only filesystem paths are supported.
          // With the JavaScript interface the URL will be passed to the user-supplied
          // read callback, so any URL supported by the callback can be used.
          "urls":
          [
            "bzzr://56ab...",
            "ipfs://Qma...",
            "/tmp/path/to/file.sol"
            // If files are used, their directories should be added to the command line via
            // `--allow-paths <path>`.
          ]
        },
        "destructible":
        {
          // Optional: keccak256 hash of the source file
          "keccak256": "0x234...",
          // Required (unless "urls" is used): literal contents of the source file
          "content": "contract destructible is owned { function shutdown() { if (msg.sender == owner) selfdestruct(owner); } }"
        }
      },
      // Optional
      "settings":
      {
        // Optional: Stop compilation after the given stage. Currently only "parsing" is valid here
        "stopAfter": "parsing",
        // Optional: Sorted list of remappings
        "remappings": [ ":g=/dir" ],
        // Optional: Optimizer settings
        "optimizer": {
          // Disabled by default.
          // NOTE: enabled=false still leaves some optimizations on. See comments below.
          // WARNING: Before version 0.8.6 omitting the 'enabled' key was not equivalent to setting
          // it to false and would actually disable all the optimizations.
          "enabled": true,
          // Optimize for how many times you intend to run the code.
          // Lower values will optimize more for initial deployment cost, higher
          // values will optimize more for high-frequency usage.
          "runs": 200,
          // Switch optimizer components on or off in detail.
          // The "enabled" switch above provides two defaults which can be
          // tweaked here. If "details" is given, "enabled" can be omitted.
          "details": {
            // The peephole optimizer is always on if no details are given,
            // use details to switch it off.
            "peephole": true,
            // The inliner is always on if no details are given,
            // use details to switch it off.
            "inliner": true,
            // The unused jumpdest remover is always on if no details are given,
            // use details to switch it off.
            "jumpdestRemover": true,
            // Sometimes re-orders literals in commutative operations.
            "orderLiterals": false,
            // Removes duplicate code blocks
            "deduplicate": false,
            // Common subexpression elimination, this is the most complicated step but
            // can also provide the largest gain.
            "cse": false,
            // Optimize representation of literal numbers and strings in code.
            "constantOptimizer": false,
            // The new Yul optimizer. Mostly operates on the code of ABI coder v2
            // and inline assembly.
            // It is activated together with the global optimizer setting
            // and can be deactivated here.
            // Before Solidity 0.6.0 it had to be activated through this switch.
            "yul": false,
            // Tuning options for the Yul optimizer.
            "yulDetails": {
              // Improve allocation of stack slots for variables, can free up stack slots early.
              // Activated by default if the Yul optimizer is activated.
              "stackAllocation": true,
              // Select optimization steps to be applied.
              // Optional, the optimizer will use the default sequence if omitted.
              "optimizerSteps": "dhfoDgvulfnTUtnIf..."
            }
          }
        },
        // Version of the EVM to compile for.
        // Affects type checking and code generation. Can be homestead,
        // tangerineWhistle, spuriousDragon, byzantium, constantinople, petersburg, istanbul or berlin
        "evmVersion": "byzantium",
        // Optional: Change compilation pipeline to go through the Yul intermediate representation.
        // This is a highly EXPERIMENTAL feature, not to be used for production. This is false by default.
        "viaIR": true,
        // Optional: Debugging settings
        "debug": {
          // How to treat revert (and require) reason strings. Settings are
          // "default", "strip", "debug" and "verboseDebug".
          // "default" does not inject compiler-generated revert strings and keeps user-supplied ones.
          // "strip" removes all revert strings (if possible, i.e. if literals are used) keeping side-effects
          // "debug" injects strings for compiler-generated internal reverts, implemented for ABI encoders V1 and V2 for now.
          // "verboseDebug" even appends further information to user-supplied revert strings (not yet implemented)
          "revertStrings": "default",
          // Optional: How much extra debug information to include in comments in the produced EVM
          // assembly and Yul code. Available components are:
          // - `location`: Annotations of the form `@src <index>:<start>:<end>` indicating the
          //    location of the corresponding element in the original Solidity file, where:
          //     - `<index>` is the file index matching the `@use-src` annotation,
          //     - `<start>` is the index of the first byte at that location,
          //     - `<end>` is the index of the first byte after that location.
          // - `snippet`: A single-line code snippet from the location indicated by `@src`.
          //     The snippet is quoted and follows the corresponding `@src` annotation.
          // - `*`: Wildcard value that can be used to request everything.
          "debugInfo": ["location", "snippet"]
        },
        // Metadata settings (optional)
        "metadata": {
          // Use only literal content and not URLs (false by default)
          "useLiteralContent": true,
          // Use the given hash method for the metadata hash that is appended to the bytecode.
          // The metadata hash can be removed from the bytecode via option "none".
          // The other options are "ipfs" and "bzzr1".
          // If the option is omitted, "ipfs" is used by default.
          "bytecodeHash": "ipfs"
        },
        // Addresses of the libraries. If not all libraries are given here,
        // it can result in unlinked objects whose output data is different.
        "libraries": {
          // The top level key is the the name of the source file where the library is used.
          // If remappings are used, this source file should match the global path
          // after remappings were applied.
          // If this key is an empty string, that refers to a global level.
          "myFile.sol": {
            "MyLib": "0x123123..."
          }
        },
        // The following can be used to select desired outputs based
        // on file and contract names.
        // If this field is omitted, then the compiler loads and does type checking,
        // but will not generate any outputs apart from errors.
        // The first level key is the file name and the second level key is the contract name.
        // An empty contract name is used for outputs that are not tied to a contract
        // but to the whole source file like the AST.
        // A star as contract name refers to all contracts in the file.
        // Similarly, a star as a file name matches all files.
        // To select all outputs the compiler can possibly generate, use
        // "outputSelection: { "*": { "*": [ "*" ], "": [ "*" ] } }"
        // but note that this might slow down the compilation process needlessly.
        //
        // The available output types are as follows:
        //
        // File level (needs empty string as contract name):
        //   ast - AST of all source files
        //
        // Contract level (needs the contract name or "*"):
        //   abi - ABI
        //   devdoc - Developer documentation (natspec)
        //   userdoc - User documentation (natspec)
        //   metadata - Metadata
        //   ir - Yul intermediate representation of the code before optimization
        //   irOptimized - Intermediate representation after optimization
        //   storageLayout - Slots, offsets and types of the contract's state variables.
        //   evm.assembly - New assembly format
        //   evm.legacyAssembly - Old-style assembly format in JSON
        //   evm.bytecode.functionDebugData - Debugging information at function level
        //   evm.bytecode.object - Bytecode object
        //   evm.bytecode.opcodes - Opcodes list
        //   evm.bytecode.sourceMap - Source mapping (useful for debugging)
        //   evm.bytecode.linkReferences - Link references (if unlinked object)
        //   evm.bytecode.generatedSources - Sources generated by the compiler
        //   evm.deployedBytecode* - Deployed bytecode (has all the options that evm.bytecode has)
        //   evm.deployedBytecode.immutableReferences - Map from AST ids to bytecode ranges that reference immutables
        //   evm.methodIdentifiers - The list of function hashes
        //   evm.gasEstimates - Function gas estimates
        //   ewasm.wast - Ewasm in WebAssembly S-expressions format
        //   ewasm.wasm - Ewasm in WebAssembly binary format
        //
        // Note that using a using `evm`, `evm.bytecode`, `ewasm`, etc. will select every
        // target part of that output. Additionally, `*` can be used as a wildcard to request everything.
        //
        "outputSelection": {
          "*": {
            "*": [
              "metadata", "evm.bytecode" // Enable the metadata and bytecode outputs of every single contract.
              , "evm.bytecode.sourceMap" // Enable the source map output of every single contract.
            ],
            "": [
              "ast" // Enable the AST output of every single file.
            ]
          },
          // Enable the abi and opcodes output of MyContract defined in file def.
          "def": {
            "MyContract": [ "abi", "evm.bytecode.opcodes" ]
          }
        },
        // The modelChecker object is experimental and subject to changes.
        "modelChecker":
        {
          // Chose which contracts should be analyzed as the deployed one.
          "contracts":
          {
            "source1.sol": ["contract1"],
            "source2.sol": ["contract2", "contract3"]
          },
          // Choose whether division and modulo operations should be replaced by
          // multiplication with slack variables. Default is `true`.
          // Using `false` here is recommended if you are using the CHC engine
          // and not using Spacer as the Horn solver (using Eldarica, for example).
          // See the Formal Verification section for a more detailed explanation of this option.
          "divModWithSlacks": true,
          // Choose which model checker engine to use: all (default), bmc, chc, none.
          "engine": "chc",
          // Choose which types of invariants should be reported to the user: contract, reentrancy.
          "invariants": ["contract", "reentrancy"],
          // Choose whether to output all unproved targets. The default is `false`.
          "showUnproved": true,
          // Choose which solvers should be used, if available.
          // See the Formal Verification section for the solvers description.
          "solvers": ["cvc4", "smtlib2", "z3"],
          // Choose which targets should be checked: constantCondition,
          // underflow, overflow, divByZero, balance, assert, popEmptyArray, outOfBounds.
          // If the option is not given all targets are checked by default,
          // except underflow/overflow for Solidity >=0.8.7.
          // See the Formal Verification section for the targets description.
          "targets": ["underflow", "overflow", "assert"],
          // Timeout for each SMT query in milliseconds.
          // If this option is not given, the SMTChecker will use a deterministic
          // resource limit by default.
          // A given timeout of 0 means no resource/time restrictions for any query.
          "timeout": 20000
        }
      }
    }

Output Description
------------------

.. code-block:: javascript

    {
      // Optional: not present if no errors/warnings/infos were encountered
      "errors": [
        {
          // Optional: Location within the source file.
          "sourceLocation": {
            "file": "sourceFile.sol",
            "start": 0,
            "end": 100
          },
          // Optional: Further locations (e.g. places of conflicting declarations)
          "secondarySourceLocations": [
            {
              "file": "sourceFile.sol",
              "start": 64,
              "end": 92,
              "message": "Other declaration is here:"
            }
          ],
          // Mandatory: Error type, such as "TypeError", "InternalCompilerError", "Exception", etc.
          // See below for complete list of types.
          "type": "TypeError",
          // Mandatory: Component where the error originated, such as "general", "ewasm", etc.
          "component": "general",
          // Mandatory ("error", "warning" or "info", but please note that this may be extended in the future)
          "severity": "error",
          // Optional: unique code for the cause of the error
          "errorCode": "3141",
          // Mandatory
          "message": "Invalid keyword",
          // Optional: the message formatted with source location
          "formattedMessage": "sourceFile.sol:100: Invalid keyword"
        }
      ],
      // This contains the file-level outputs.
      // It can be limited/filtered by the outputSelection settings.
      "sources": {
        "sourceFile.sol": {
          // Identifier of the source (used in source maps)
          "id": 1,
          // The AST object
          "ast": {}
        }
      },
      // This contains the contract-level outputs.
      // It can be limited/filtered by the outputSelection settings.
      "contracts": {
        "sourceFile.sol": {
          // If the language used has no contract names, this field should equal to an empty string.
          "ContractName": {
            // The Ethereum Contract ABI. If empty, it is represented as an empty array.
            // See https://docs.soliditylang.org/en/develop/abi-spec.html
            "abi": [],
            // See the Metadata Output documentation (serialised JSON string)
            "metadata": "{/* ... */}",
            // User documentation (natspec)
            "userdoc": {},
            // Developer documentation (natspec)
            "devdoc": {},
            // Intermediate representation (string)
            "ir": "",
            // See the Storage Layout documentation.
            "storageLayout": {"storage": [/* ... */], "types": {/* ... */} },
            // EVM-related outputs
            "evm": {
              // Assembly (string)
              "assembly": "",
              // Old-style assembly (object)
              "legacyAssembly": {},
              // Bytecode and related details.
              "bytecode": {
                // Debugging data at the level of functions.
                "functionDebugData": {
                  // Now follows a set of functions including compiler-internal and
                  // user-defined function. The set does not have to be complete.
                  "@mint_13": { // Internal name of the function
                    "entryPoint": 128, // Byte offset into the bytecode where the function starts (optional)
                    "id": 13, // AST ID of the function definition or null for compiler-internal functions (optional)
                    "parameterSlots": 2, // Number of EVM stack slots for the function parameters (optional)
                    "returnSlots": 1 // Number of EVM stack slots for the return values (optional)
                  }
                },
                // The bytecode as a hex string.
                "object": "00fe",
                // Opcodes list (string)
                "opcodes": "",
                // The source mapping as a string. See the source mapping definition.
                "sourceMap": "",
                // Array of sources generated by the compiler. Currently only
                // contains a single Yul file.
                "generatedSources": [{
                  // Yul AST
                  "ast": {/* ... */},
                  // Source file in its text form (may contain comments)
                  "contents":"{ function abi_decode(start, end) -> data { data := calldataload(start) } }",
                  // Source file ID, used for source references, same "namespace" as the Solidity source files
                  "id": 2,
                  "language": "Yul",
                  "name": "#utility.yul"
                }],
                // If given, this is an unlinked object.
                "linkReferences": {
                  "libraryFile.sol": {
                    // Byte offsets into the bytecode.
                    // Linking replaces the 20 bytes located there.
                    "Library1": [
                      { "start": 0, "length": 20 },
                      { "start": 200, "length": 20 }
                    ]
                  }
                }
              },
              "deployedBytecode": {
                /* ..., */ // The same layout as above.
                "immutableReferences": {
                  // There are two references to the immutable with AST ID 3, both 32 bytes long. One is
                  // at bytecode offset 42, the other at bytecode offset 80.
                  "3": [{ "start": 42, "length": 32 }, { "start": 80, "length": 32 }]
                }
              },
              // The list of function hashes
              "methodIdentifiers": {
                "delegate(address)": "5c19a95c"
              },
              // Function gas estimates
              "gasEstimates": {
                "creation": {
                  "codeDepositCost": "420000",
                  "executionCost": "infinite",
                  "totalCost": "infinite"
                },
                "external": {
                  "delegate(address)": "25000"
                },
                "internal": {
                  "heavyLifting()": "infinite"
                }
              }
            },
            // Ewasm related outputs
            "ewasm": {
              // S-expressions format
              "wast": "",
              // Binary format (hex string)
              "wasm": ""
            }
          }
        }
      }
    }

Error Types
~~~~~~~~~~~

.. 1. ``JSONError``: JSON input doesn't conform to the required format, e.g. input is not a JSON object, the language is not supported, etc.

1. ``JSONError`` : JSON入力が要求されたフォーマットに適合していない。例: 入力がJSONオブジェクトでない、言語がサポートされていない、など。

.. 2. ``IOError``: IO and import processing errors, such as unresolvable URL or hash mismatch in supplied sources.

2. ``IOError`` : 解決できないURLや提供されたソースのハッシュの不一致など、IOおよびインポート処理のエラー。

.. 3. ``ParserError``: Source code doesn't conform to the language rules.

3. ``ParserError`` : ソースコードが言語ルールに準拠していない。

.. 4. ``DocstringParsingError``: The NatSpec tags in the comment block cannot be parsed.

4. ``DocstringParsingError`` : コメントブロック内のNatSpecタグが解析できない。

.. 5. ``SyntaxError``: Syntactical error, such as ``continue`` is used outside of a ``for`` loop.

5. ``SyntaxError`` :  ``for`` ループの外で ``continue`` が使われているなど、構文上のエラー。

.. 6. ``DeclarationError``: Invalid, unresolvable or clashing identifier names. e.g. ``Identifier not found``

6. ``DeclarationError`` : 無効な、解決不可能な、または衝突した識別子名 例:  ``Identifier not found``

.. 7. ``TypeError``: Error within the type system, such as invalid type conversions, invalid assignments, etc.

7. ``TypeError`` : 無効な型変換、無効な代入など、型システム内のエラー。

.. 8. ``UnimplementedFeatureError``: Feature is not supported by the compiler, but is expected to be supported in future versions.

8. ``UnimplementedFeatureError`` : この機能はコンパイラではサポートされていませんが、将来のバージョンではサポートされる予定です。

.. 9. ``InternalCompilerError``: Internal bug triggered in the compiler - this should be reported as an issue.
.. 1

9. ``InternalCompilerError`` : コンパイラの内部バグが発生しました。1

.. 10. ``Exception``: Unknown failure during compilation - this should be reported as an issue.
.. 1

10. ``Exception`` : コンパイル時に不明な障害が発生しました - これは問題として報告する必要があります。1

.. 11. ``CompilerError``: Invalid use of the compiler stack - this should be reported as an issue.
.. 1

11. ``CompilerError`` : コンパイラー・スタックの無効な使用 - これは問題として報告する必要があります。1

.. 12. ``FatalError``: Fatal error not processed correctly - this should be reported as an issue.
.. 1

12. ``FatalError`` : 致命的なエラーが正しく処理されていない - これは問題として報告する必要があります。1

.. 13. ``Warning``: A warning, which didn't stop the compilation, but should be addressed if possible.
.. 1

13. ``Warning`` : 警告であり、コンパイルを止めることはできなかったが、可能であれば対処すべきです。1

.. 14. ``Info``: Information that the compiler thinks the user might find useful, but is not dangerous and does not necessarily need to be addressed.

14. ``Info`` : ユーザーが役に立つかもしれないが、危険ではなく、必ずしも対処する必要がないとコンパイラが考えている情報。

.. _compiler-tools:

Compiler Tools
**************

solidity-upgrade
----------------

.. ``solidity-upgrade`` can help you to semi-automatically upgrade your contracts
.. to breaking language changes. While it does not and cannot implement all
.. required changes for every breaking release, it still supports the ones, that
.. would need plenty of repetitive manual adjustments otherwise.

``solidity-upgrade`` は、最新の言語変更に合わせてコントラクトを半自動的にアップグレードするのに役立ちます。 ``solidity-upgrade`` は、すべての変更されたリリースに必要なすべての変更を実装するわけではありませんし、そうすることもできませんが、他の方法では多くの反復的な手動調整を必要とするようなものをサポートしています。

.. .. note::

..     ``solidity-upgrade`` carries out a large part of the work, but your
..     contracts will most likely need further manual adjustments. We recommend
..     using a version control system for your files. This helps reviewing and
..     eventually rolling back the changes made.

.. note::

    ``solidity-upgrade`` は作業の大部分を行いますが、 コントラクトはさらに手動で調整する必要がある場合がほとんどです。ファイルにはバージョン管理システムを使用することをお勧めします。これにより、変更内容を確認し、最終的にはロールバックできます。

.. .. warning::

..     ``solidity-upgrade`` is not considered to be complete or free from bugs, so
..     please use with care.

.. warning::

    ``solidity-upgrade`` は完全なものではなく、バグもないと考えられますので、注意してお使いください。

How it Works
~~~~~~~~~~~~

.. You can pass (a) Solidity source file(s) to ``solidity-upgrade [files]``. If
.. these make use of ``import`` statement which refer to files outside the
.. current source file's directory, you need to specify directories that
.. are allowed to read and import files from, by passing
.. ``--allow-paths [directory]``. You can ignore missing files by passing
.. ``--ignore-missing``.

``solidity-upgrade [files]`` にはSolidityのソースファイルを渡すことができます。これらのファイルが、現在のソースファイルのディレクトリ外のファイルを参照する ``import`` ステートメントを使用する場合は、 ``--allow-paths [directory]`` を渡して、ファイルの読み込みとインポートが許可されているディレクトリを指定する必要があります。 ``--ignore-missing`` を渡すと、見つからないファイルを無視できます。

.. ``solidity-upgrade`` is based on ``libsolidity`` and can parse, compile and
.. analyse your source files, and might find applicable source upgrades in them.

``solidity-upgrade`` は ``libsolidity`` をベースにしており、ソースファイルを解析、コンパイル、分析でき、その中から該当するソースアップグレードを見つけることができるかもしれません。

.. Source upgrades are considered to be small textual changes to your source code.
.. They are applied to an in-memory representation of the source files
.. given. The corresponding source file is updated by default, but you can pass
.. ``--dry-run`` to simulate to whole upgrade process without writing to any file.

ソースアップグレードとは、ソースコードに小さな文字の変更を加えることと考えられます。ソースアップグレードは、与えられたソースファイルのメモリ内表現に適用されます。デフォルトでは、対応するソースファイルが更新されますが、 ``--dry-run``  を渡すことで、ファイルに書き込まずにアップグレード処理全体をシミュレートできます。

.. The upgrade process itself has two phases. In the first phase source files are
.. parsed, and since it is not possible to upgrade source code on that level,
.. errors are collected and can be logged by passing ``--verbose``. No source
.. upgrades available at this point.

アップグレード処理自体は2つのフェーズで構成されています。最初のフェーズでは、ソースファイルが解析され、そのレベルではソースコードをアップグレードできないため、エラーが収集され、 ``--verbose`` を渡すことでログに残すことができます。この時点では、ソースのアップグレードはできません。

.. In the second phase, all sources are compiled and all activated upgrade analysis
.. modules are run alongside compilation. By default, all available modules are
.. activated. Please read the documentation on
.. :ref:`available modules <upgrade-modules>` for further details.

第 2 段階では、すべてのソースがコンパイルされ、アクティベートされたすべてのアップグレード分析モジュールがコンパイルと同時に実行されます。デフォルトでは、利用可能なすべてのモジュールが起動されます。詳細については、 :ref:`available modules <upgrade-modules>` のドキュメントをお読みください。

.. This can result in compilation errors that may
.. be fixed by source upgrades. If no errors occur, no source upgrades are being
.. reported and you're done.
.. If errors occur and some upgrade module reported a source upgrade, the first
.. reported one gets applied and compilation is triggered again for all given
.. source files. The previous step is repeated as long as source upgrades are
.. reported. If errors still occur, you can log them by passing ``--verbose``.
.. If no errors occur, your contracts are up to date and can be compiled with
.. the latest version of the compiler.

その結果、ソースのアップグレードによって修正される可能性のあるコンパイルエラーが発生することがあります。エラーが発生しなければ、ソース・アップグレードは報告されていないので、これで終了です。エラーが発生し、あるアップグレード・モジュールがソース・アップグレードを報告した場合は、最初に報告されたものが適用され、与えられたすべてのソース・ファイルに対して再びコンパイルが行われます。ソース・アップグレードが報告されている限り、前のステップが繰り返されます。それでもエラーが発生した場合は、 ``--verbose``  を渡すことでエラーをログに記録できます。エラーが発生しなければ、コントラクトは最新の状態になっており、最新バージョンのコンパイラでコンパイルできます。

.. _upgrade-modules:

Available Upgrade Modules
~~~~~~~~~~~~~~~~~~~~~~~~~

+----------------------------+---------+--------------------------------------------------+
| Module                     | Version | Description                                      |
+============================+=========+==================================================+
| ``constructor``            | 0.5.0   | Constructors must now be defined using the       |
|                            |         | ``constructor`` keyword.                         |
+----------------------------+---------+--------------------------------------------------+
| ``visibility``             | 0.5.0   | Explicit function visibility is now mandatory,   |
|                            |         | defaults to ``public``.                          |
+----------------------------+---------+--------------------------------------------------+
| ``abstract``               | 0.6.0   | The keyword ``abstract`` has to be used if a     |
|                            |         | contract does not implement all its functions.   |
+----------------------------+---------+--------------------------------------------------+
| ``virtual``                | 0.6.0   | Functions without implementation outside an      |
|                            |         | interface have to be marked ``virtual``.         |
+----------------------------+---------+--------------------------------------------------+
| ``override``               | 0.6.0   | When overriding a function or modifier, the new  |
|                            |         | keyword ``override`` must be used.               |
+----------------------------+---------+--------------------------------------------------+
| ``dotsyntax``              | 0.7.0   | The following syntax is deprecated:              |
|                            |         | ``f.gas(...)()``, ``f.value(...)()`` and         |
|                            |         | ``(new C).value(...)()``. Replace these calls by |
|                            |         | ``f{gas: ..., value: ...}()`` and                |
|                            |         | ``(new C){value: ...}()``.                       |
+----------------------------+---------+--------------------------------------------------+
| ``now``                    | 0.7.0   | The ``now`` keyword is deprecated. Use           |
|                            |         | ``block.timestamp`` instead.                     |
+----------------------------+---------+--------------------------------------------------+
| ``constructor-visibility`` | 0.7.0   | Removes visibility of constructors.              |
|                            |         |                                                  |
+----------------------------+---------+--------------------------------------------------+

.. Please read :doc:`0.5.0 release notes <050-breaking-changes>`,
.. :doc:`0.6.0 release notes <060-breaking-changes>`,
.. :doc:`0.7.0 release notes <070-breaking-changes>` and :doc:`0.8.0 release notes <080-breaking-changes>` for further details.

詳しくは :doc: `0.5.0 release notes <050-breaking-changes>` , :doc: `0.6.0 release notes <060-breaking-changes>` , :doc: `0.7.0 release notes <070-breaking-changes>` , :doc: `0.8.0 release notes <080-breaking-changes>`  をご覧ください。

Synopsis
~~~~~~~~

.. code-block:: none

    Usage: solidity-upgrade [options] contract.sol

    Allowed options:
        --help               Show help message and exit.
        --version            Show version and exit.
        --allow-paths path(s)
                             Allow a given path for imports. A list of paths can be
                             supplied by separating them with a comma.
        --ignore-missing     Ignore missing files.
        --modules module(s)  Only activate a specific upgrade module. A list of
                             modules can be supplied by separating them with a comma.
        --dry-run            Apply changes in-memory only and don't write to input
                             file.
        --verbose            Print logs, errors and changes. Shortens output of
                             upgrade patches.
        --unsafe             Accept *unsafe* changes.

Bug Reports / Feature Requests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. If you found a bug or if you have a feature request, please
.. `file an issue <https://github.com/ethereum/solidity/issues/new/choose>`_ on Github.

もし、バグを見つけたり、機能のリクエストがあれば、Githubで `file an issue <https://github.com/ethereum/solidity/issues/new/choose>`_ をお願いします。

Example
~~~~~~~

.. Assume that you have the following contract in ``Source.sol``:

``Source.sol`` で次のようなコントラクトをしているとします。

.. code-block:: Solidity

    pragma solidity >=0.6.0 <0.6.4;
    // This will not compile after 0.7.0
    // SPDX-License-Identifier: GPL-3.0
    contract C {
        // FIXME: remove constructor visibility and make the contract abstract
        constructor() internal {}
    }

    contract D {
        uint time;

        function f() public payable {
            // FIXME: change now to block.timestamp
            time = now;
        }
    }

    contract E {
        D d;

        // FIXME: remove constructor visibility
        constructor() public {}

        function g() public {
            // FIXME: change .value(5) =>  {value: 5}
            d.f.value(5)();
        }
    }

Required Changes
^^^^^^^^^^^^^^^^

.. The above contract will not compile starting from 0.7.0. To bring the contract up to date with the
.. current Solidity version, the following upgrade modules have to be executed:
.. ``constructor-visibility``, ``now`` and ``dotsyntax``. Please read the documentation on
.. :ref:`available modules <upgrade-modules>` for further details.

上記のコントラクトは、0.7.0からコンパイルできなくなります。 コントラクトを現在のSolidityのバージョンに合わせるためには、以下のアップグレードモジュールを実行する必要があります。 ``constructor-visibility`` 、 ``now`` 、 ``dotsyntax`` です。詳しくは、 :ref:`available modules <upgrade-modules>` のドキュメントをご覧ください。

Running the Upgrade
^^^^^^^^^^^^^^^^^^^

.. It is recommended to explicitly specify the upgrade modules by using ``--modules`` argument.

``--modules`` 引数でアップグレードモジュールを明示的に指定することをお勧めします。

.. code-block:: bash

    solidity-upgrade --modules constructor-visibility,now,dotsyntax Source.sol

.. The command above applies all changes as shown below. Please review them carefully (the pragmas will
.. have to be updated manually.)

上記のコマンドは、以下のようにすべての変更を適用します。慎重に確認してください(プラグマは手動で更新する必要があります)。

.. code-block:: Solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    abstract contract C {
        // FIXME: remove constructor visibility and make the contract abstract
        constructor() {}
    }

    contract D {
        uint time;

        function f() public payable {
            // FIXME: change now to block.timestamp
            time = block.timestamp;
        }
    }

    contract E {
        D d;

        // FIXME: remove constructor visibility
        constructor() {}

        function g() public {
            // FIXME: change .value(5) =>  {value: 5}
            d.f{value: 5}();
        }
    }

