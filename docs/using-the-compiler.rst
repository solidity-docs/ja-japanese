******************
コンパイラの使い方
******************

.. index:: ! commandline compiler, compiler;commandline, ! solc

.. _commandline-compiler:

コマンドラインコンパイラの使い方
********************************

.. .. note::

..     This section does not apply to :ref:`solcjs <solcjs>`, not even if it is used in commandline mode.

.. note::

    このセクションは :ref:`solcjs <solcjs>` には適用されず、コマンドラインモードで使用されても適用されません。

<<<<<<< HEAD
基本的な使い方
--------------
=======
One of the build targets of the Solidity repository is ``solc``, the Solidity commandline compiler.
Using ``solc --help`` provides you with an explanation of all options. The compiler can produce various outputs, ranging from simple binaries and assembly over an abstract syntax tree (parse tree) to estimations of gas usage.
If you only want to compile a single file, you run it as ``solc --bin sourceFile.sol`` and it will print the binary. If you want to get some of the more advanced output variants of ``solc``, it is probably better to tell it to output everything to separate files using ``solc -o outputDirectory --bin --ast-compact-json --asm sourceFile.sol``.
>>>>>>> english/develop

.. One of the build targets of the Solidity repository is ``solc``, the solidity commandline compiler.
.. Using ``solc --help`` provides you with an explanation of all options. The compiler can produce various outputs, ranging from simple binaries and assembly over an abstract syntax tree (parse tree) to estimations of gas usage.
.. If you only want to compile a single file, you run it as ``solc --bin sourceFile.sol`` and it will print the binary.
.. If you want to get some of the more advanced output variants of ``solc``, it is probably better to tell it to output everything to separate files using ``solc -o outputDirectory --bin --ast-compact-json --asm sourceFile.sol``.

Solidityリポジトリのビルドターゲットの1つは、Solidityのコマンドラインコンパイラである ``solc`` です。
``solc --help`` を実行すると、すべてのオプションの説明を見ることができます。
コンパイラは、抽象的な構文木（パースツリー）上の単純なバイナリやアセンブリから、ガス使用量の推定値まで、さまざまな出力を行うことができます。
単一のファイルをコンパイルしたいだけなら、 ``solc --bin sourceFile.sol`` として実行すれば、バイナリを出力します。
``solc`` のより高度な出力を得たい場合は、 ``solc -o outputDirectory --bin --ast-compact-json --asm sourceFile.sol`` を使ってすべてを別々のファイルに出力するように指示したほうがよいでしょう。

オプティマイザオプション
------------------------

.. Before you deploy your contract, activate the optimizer when compiling using ``solc --optimize --bin sourceFile.sol``.
.. By default, the optimizer will optimize the contract assuming it is called 200 times across its lifetime (more specifically, it assumes each opcode is executed around 200 times).
.. If you want the initial contract deployment to be cheaper and the later function executions to be more expensive, set it to ``--optimize-runs=1``.
.. If you expect many transactions and do not care for higher deployment cost and output size, set ``--optimize-runs`` to a high number.
.. This parameter has effects on the following (this might change in the future):

コントラクトをデプロイする前に、 ``solc --optimize --bin sourceFile.sol`` を使ってコンパイルする際にオプティマイザを有効にします。
デフォルトでは、オプティマイザは、コントラクトがそのライフタイム全体で200回呼び出されると仮定して最適化します（より具体的には、各オペコードが約200回実行されると仮定します）。
最初のコントラクトデプロイを安価にし、後の関数実行を高価にしたい場合は、 ``--optimize-runs=1`` に設定してください。
多くのトランザクションが予想され、デプロイコストや出力サイズが高くなっても気にしない場合は、 ``--optimize-runs`` を高い数値に設定してください。
このパラメータは以下に影響を与えます（将来変更される可能性があります）。

.. - the size of the binary search in the function dispatch routine

- 関数ディスパッチルーティンでの二分検索のサイズ
- 大きな数値や文字列などの定数の保存方法

.. index:: allowed paths, --allow-paths, base path, --base-path, include paths, --include-path

ベースパスとインポートのリマッピング
------------------------------------

.. The commandline compiler will automatically read imported files from the filesystem, but it is also possible to provide :ref:`path redirects <import-remapping>` using ``prefix=path`` in the following way:

コマンドラインコンパイラは、インポートされたファイルをファイルシステムから自動的に読み込みますが、以下のように ``prefix=path`` を使って :ref:`パスのリダイレクト <import-remapping>` をすることも可能です。

.. code-block:: bash

    solc github.com/ethereum/dapp-bin/=/usr/local/lib/dapp-bin/ file.sol

.. This essentially instructs the compiler to search for anything starting with ``github.com/ethereum/dapp-bin/`` under ``/usr/local/lib/dapp-bin``.

これは基本的に、 ``github.com/ethereum/dapp-bin/`` で始まるものを ``/usr/local/lib/dapp-bin`` の下で検索するようにコンパイラに指示するものです。

<<<<<<< HEAD
.. When accessing the filesystem to search for imports, :ref:`paths that do not start with ./ or ../ <direct-imports>` are treated as relative to the directories specified using ``--base-path`` and ``--include-path`` options (or the current working directory if base path is not specified).
.. Furthermore, the part of the path added via these options will not appear in the contract metadata.
=======
For security reasons the compiler has :ref:`restrictions on what directories it can access <allowed-paths>`.
Directories of source files specified on the command-line and target paths of
remappings are automatically allowed to be accessed by the file reader, but everything
else is rejected by default.
Additional paths (and their subdirectories) can be allowed via the
``--allow-paths /sample/path,/another/sample/path`` switch.
Everything inside the path specified via ``--base-path`` is always allowed.
>>>>>>> english/develop

インポートを検索するためにファイルシステムにアクセスする際、 :ref:`./または../で始まらないパス <direct-imports>` は ``--base-path`` および ``--include-path`` オプションで指定されたディレクトリ（ベースパスが指定されていない場合はカレントワーキングディレクトリ）からの相対パスとして扱われます。
また、これらのオプションで追加されたパスの部分は、コントラクトのメタデータには表示されません。

.. For security reasons the compiler has :ref:`restrictions on what directories it can access <allowed-paths>`.
.. Directories of source files specified on the command line and target paths of remappings are automatically allowed to be accessed by the file reader, but everything else is rejected by default.
.. Additional paths (and their subdirectories) can be allowed via the ``--allow-paths /sample/path,/another/sample/path`` switch.
.. Everything inside the path specified via ``--base-path`` is always allowed.

セキュリティ上の理由から、コンパイラは :ref:`アクセスできるディレクトリに制限 <allowed-paths>` を設けています。
コマンドラインで指定されたソースファイルのディレクトリと、リマッピングのターゲットパスは、ファイルリーダーからのアクセスが自動的に許可されますが、それ以外はデフォルトで拒否されます。
``--allow-paths /sample/path,/another/sample/path``  スイッチで追加のパス（およびそのサブディレクトリ）を許可できます。
``--base-path``  で指定されたパスの中のものは常に許可されます。

.. The above is only a simplification of how the compiler handles import paths.
.. For a detailed explanation with examples and discussion of corner cases please refer to the section on :ref:`path resolution <path-resolution>`.

上記は、コンパイラがインポートパスをどのように処理するかを簡単に説明したものです。
例を交えた詳細な説明やコーナーケースについては、 :ref:`パスの解決 <path-resolution>` のセクションを参照してください。

.. index:: ! linker, ! --link, ! --libraries
.. _library-linking:

ライブラリのリンク
------------------

.. If your contracts use :ref:`libraries <libraries>`, you will notice that the bytecode contains substrings of the form ``__$53aea86b7d70b31448b230b20ae141a537$__``.
.. These are placeholders for the actual library addresses.
.. The placeholder is a 34 character prefix of the hex encoding of the keccak256 hash of the fully qualified library name.
.. The bytecode file will also contain lines of the form ``// <placeholder> -> <fq library name>`` at the end to help identify which libraries the placeholders represent.
.. Note that the fully qualified library name is the path of its source file and the library name separated by ``:``.
.. You can use ``solc`` as a linker meaning that it will insert the library addresses for you at those points:

コントラクトで :ref:`ライブラリ <libraries>` を使用している場合、バイトコードに ``__$53aea86b7d70b31448b230b20ae141a537$__`` のような部分文字列が含まれていることに気づくでしょう。
これは、実際のライブラリアドレスのプレースホルダーです。
プレースホルダーは、完全に修飾されたライブラリ名のkeccak256ハッシュの16進数エンコーディングの34文字のプレフィックスです。
また、バイトコードファイルには、プレースホルダーがどのライブラリを表しているかを識別するために、最後に ``// <placeholder> -> <fq library name>`` という形式の行が含まれます。
完全に修飾されたライブラリ名は、そのソースファイルのパスとライブラリ名を ``:`` で区切ったものであることに注意してください。
``solc`` をリンカーとして使用すると、これらの箇所にライブラリのアドレスを挿入してくれます。

.. Either add ``--libraries "file.sol:Math=0x1234567890123456789012345678901234567890 file.sol:Heap=0xabCD567890123456789012345678901234567890"`` to your command to provide an address for each library (use commas or spaces as separators) or store the string in a file (one library per line) and run ``solc`` using ``--libraries fileName``.

``--libraries "file.sol:Math=0x1234567890123456789012345678901234567890 file.sol:Heap=0xabCD567890123456789012345678901234567890"`` をコマンドに追加して各ライブラリのアドレスを指定するか（セパレータにはカンマまたはスペースを使用）、文字列をファイルに保存して（1行に1ライブラリ）、 ``--libraries fileName`` を使って ``solc`` を実行するかの2つの方法があります。

.. .. note::

..     Starting Solidity 0.8.1 accepts ``=`` as separator between library and address, and ``:`` as a separator is deprecated.

.. note::

    Solidity 0.8.1より、ライブラリとアドレスの間のセパレータとして ``=`` を受け入れ、セパレータとしての ``:`` は非推奨となりました。
    将来は削除される予定です。
    現在は ``--libraries "file.sol:Math:0x1234567890123456789012345678901234567890 file.sol:Heap:0xabCD567890123456789012345678901234567890"`` も動作します。

.. index:: --standard-json, --base-path

.. If ``solc`` is called with the option ``--standard-json``, it will expect a JSON input (as explained below) on the standard input, and return a JSON output on the standard output.
.. This is the recommended interface for more complex and especially automated uses.
.. The process will always terminate in a "success" state and report any errors via the JSON output.
.. The option ``--base-path`` is also processed in standard-json mode.

``solc`` が ``--standard-json`` オプション付きで呼び出された場合、標準入力に（以下に説明する）JSONの入力を受け取り、標準出力にJSONの出力を返します。
これは、より複雑な用途、特に自動化された用途に推奨されるインターフェースです。
プロセスは常に「成功」の状態で終了し、エラーがあればJSON出力で報告されます。
オプション ``--base-path`` もstandard-jsonモードで処理されます。

.. If ``solc`` is called with the option ``--link``, all input files are interpreted to be unlinked binaries (hex-encoded) in the ``__$53aea86b7d70b31448b230b20ae141a537$__``-format given above and are linked in-place (if the input is read from stdin, it is written to stdout). All options except ``--libraries`` are ignored (including ``-o``) in this case.

``solc`` がオプション ``--link`` 付きで呼ばれた場合、すべての入力ファイルは、上記で与えられた ``__$53aea86b7d70b31448b230b20ae141a537$__`` 形式のリンクされていないバイナリ（16進コード）と解釈され、その場でリンクされます（入力が標準入力から読み込まれた場合は、標準出力に書き込まれます）。
この場合、 ``--libraries`` 以外のオプションはすべて無視されます（ ``-o`` も含む）。

.. .. warning::

..     Manually linking libraries on the generated bytecode is discouraged because it does not update
..     contract metadata. Since metadata contains a list of libraries specified at the time of
..     compilation and bytecode contains a metadata hash, you will get different binaries, depending
..     on when linking is performed.

..     You should ask the compiler to link the libraries at the time a contract is compiled by either
..     using the ``--libraries`` option of ``solc`` or the ``libraries`` key if you use the
..     standard-JSON interface to the compiler.

.. warning::

    生成されたバイトコード上でライブラリを手動でリンクすることは、コントラクトのメタデータが更新されないため、推奨されません。
    メタデータにはコンパイル時に指定されたライブラリのリストが含まれており、バイトコードにはメタデータのハッシュが含まれているため、リンクを実行するタイミングによって異なるバイナリが得られることになります。

    コントラクトのコンパイル時にライブラリをリンクするようにコンパイラに依頼するには、 ``solc`` の ``--libraries`` オプションを使用するか、コンパイラへの標準JSONインターフェースを使用する場合は ``libraries`` キーを使用する必要があります。

.. .. note::

..     The library placeholder used to be the fully qualified name of the library itself instead of the hash of it.
..     This format is still supported by ``solc --link`` but the compiler will no longer output it.
..     This change was made to reduce the likelihood of a collision between libraries, since only the first 36 characters of the fully qualified library name could be used.

.. note::

    ライブラリのプレースホルダーは、以前はライブラリのハッシュではなく、ライブラリ自体の完全修飾名でした。
    この形式は ``solc --link`` ではまだサポートされていますが、コンパイラでは出力されなくなりました。
    この変更は、完全修飾ライブラリ名の最初の36文字しか使用できないため、ライブラリ間の衝突の可能性を減らすために行われました。

.. _evm-version:
.. index:: ! EVM version, compile target

.. Setting the EVM Version to Target

EVMのバージョンをターゲットに設定
*********************************

<<<<<<< HEAD
.. When you compile your contract code you can specify the Ethereum virtual machine version to compile for to avoid particular features or behaviours.

コントラクトコードをコンパイルする際に、特定の機能や動作を避けるためにコンパイルするEthereum Virtual Machineのバージョンを指定できます。

.. .. warning::

..    Compiling for the wrong EVM version can result in wrong, strange and failing behaviour.
..    Please ensure, especially if running a private chain, that you use matching EVM versions.

.. warning::

  EVMのバージョンを間違えてコンパイルすると、間違った動作、おかしな動作、失敗することがあります。
  特にプライベートチェーンを実行している場合は、一致するEVMバージョンを使用するようにしてください。

.. On the command line, you can select the EVM version as follows:

コマンドラインでは、以下のようにEVMのバージョンを選択できます。
=======
When you compile your contract code you can specify the Ethereum virtual machine
version to compile for to avoid particular features or behaviors.

.. warning::

   Compiling for the wrong EVM version can result in wrong, strange and failing
   behavior. Please ensure, especially if running a private chain, that you
   use matching EVM versions.

On the command-line, you can select the EVM version as follows:
>>>>>>> english/develop

.. code-block:: shell

  solc --evm-version <VERSION> contract.sol

.. In the :ref:`standard JSON interface <compiler-api>`, use the ``"evmVersion"`` key in the ``"settings"`` field:

:ref:`標準JSONインターフェース <compiler-api>` では、 ``"settings"`` フィールドに ``"evmVersion"`` キーを使用します。

.. code-block:: javascript

    {
      "sources": {/* ... */},
      "settings": {
        "optimizer": {/* ... */},
        "evmVersion": "<VERSION>"
      }
    }

ターゲットオプション
--------------------

.. Below is a list of target EVM versions and the compiler-relevant changes introduced at each version.
.. Backward compatibility is not guaranteed between each version.

以下は、対象となるEVMのバージョンと、各バージョンで導入されたコンパイラ関連の変更点の一覧です。
各バージョン間の下位互換性は保証されていません。

- ``homestead``

  - （最も古いバージョン）

- ``tangerineWhistle``

  .. - Gas cost for access to other accounts increased, relevant for gas estimation and the optimizer.

  - 他のアカウントへのアクセスのためのガスコストが増加しました。
    ガスの推定とオプティマイザに関係します。

  .. - All gas sent by default for external calls, previously a certain amount had to be retained.

  - 外部からのコールに対しては、デフォルトですべてのガスが送信されますが、従来は一定量を保持する必要がありました。

- ``spuriousDragon``

  .. - Gas cost for the ``exp`` opcode increased, relevant for gas estimation and the optimizer.

  - ``exp`` オペコードのガスコストが増加しました。
    ガスの推定とオプティマイザに関係します。

- ``byzantium``

  .. - Opcodes ``returndatacopy``, ``returndatasize`` and ``staticcall`` are available in assembly.

  - オペコード ``returndatacopy`` 、 ``returndatasize`` 、 ``staticcall`` はアセンブリで利用可能です。

  .. - The ``staticcall`` opcode is used when calling non-library view or pure functions, which prevents the functions from modifying state at the EVM level, i.e., even applies when you use invalid type conversions.

  - ``staticcall`` オペコードは、ライブラリではないview関数やpure関数を呼び出す際に使用され、関数がEVMレベルでステートを変更することを防ぎます。
    つまり、無効な型変換を使用している場合でも適用されます。

  .. - It is possible to access dynamic data returned from function calls.

  - 関数コールから返された動的データにアクセスすることが可能です。

  - ``revert`` のオペコードが導入されたことで、 ``revert()`` がガスを無駄にしないようになりました。

- ``constantinople``
<<<<<<< HEAD

  - オペコード ``create2`` ,  ``extcodehash`` ,  ``shl`` ,  ``shr`` ,  ``sar`` がアセンブリで使用可能です。
  - シフト演算子が、シフトオペコードを使用するため、より少ないガスで済みます。

=======
   - Opcodes ``create2``, ``extcodehash``, ``shl``, ``shr`` and ``sar`` are available in assembly.
   - Shifting operators use shifting opcodes and thus need less gas.
>>>>>>> english/develop
- ``petersburg``

  - コンパイラの動作はconstantinopleの場合と同じです。

- ``istanbul``

  - オペコード  ``chainid`` と ``selfbalance`` がアセンブリで使用可能です。

- ``berlin``

  .. - Gas costs for ``SLOAD``, ``*CALL``, ``BALANCE``, ``EXT*`` and ``SELFDESTRUCT`` increased. The
  ..      compiler assumes cold gas costs for such operations. This is relevant for gas estimation and
  ..      the optimizer.

  - ``SLOAD`` 、 ``*CALL`` 、 ``BALANCE`` 、 ``EXT*`` 、 ``SELFDESTRUCT`` のガス代が増加しました。
    コンパイラーは、このような操作に対して冷たいガスコストを想定しています。
    これは、ガスの推定とオプティマイザに関係します。

- ``london``
<<<<<<< HEAD

  .. - The block's base fee (`EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ and `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_) can be accessed via the global ``block.basefee`` or ``basefee()`` in inline assembly.

  - ブロックのベースフィー（ `EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ および `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_ ）は、インラインアセンブリでグローバルな ``block.basefee`` または ``basefee()`` を介してアクセスできます。

- ``paris`` （ **デフォルト** ）

  .. - Introduces ``prevrandao()`` and ``block.prevrandao``, and changes the semantics of the now deprecated ``block.difficulty``, disallowing ``difficulty()`` in inline assembly (see `EIP-4399 <https://eips.ethereum.org/EIPS/eip-4399>`_).

  - ``prevrandao()``と ``block.prevrandao`` を導入し、現在では非推奨となっている ``block.difficulty`` のセマンティクスを変更し、インラインアセンブリでの ``difficulty()`` を禁止しました（ `EIP-4399 <https://eips.ethereum.org/EIPS/eip-4399>`_ を参照してください）。
=======
   - The block's base fee (`EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ and `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_) can be accessed via the global ``block.basefee`` or ``basefee()`` in inline assembly.
- ``paris``
   - Introduces ``prevrandao()`` and ``block.prevrandao``, and changes the semantics of the now deprecated ``block.difficulty``, disallowing ``difficulty()`` in inline assembly (see `EIP-4399 <https://eips.ethereum.org/EIPS/eip-4399>`_).
- ``shanghai`` (**default**)
  - Smaller code size and gas savings due to the introduction of ``push0`` (see `EIP-3855 <https://eips.ethereum.org/EIPS/eip-3855>`_).
>>>>>>> english/develop

.. index:: ! standard JSON, ! --standard-json
.. _compiler-api:

コンパイラの入出力JSONの説明
****************************

.. The recommended way to interface with the Solidity compiler especially for more complex and automated setups is the so-called JSON-input-output interface.
.. The same interface is provided by all distributions of the compiler.

Solidityコンパイラとのインターフェースとして、特に複雑な自動化されたセットアップには、いわゆるJSON-input-outputインターフェースを使用することをお勧めします。
このインターフェースは、コンパイラのすべてのディストリビューションで提供されています。

.. The fields are generally subject to change, some are optional (as noted), but we try to only make backwards compatible changes.

フィールドは一般的に変更される可能性があり、いくつかの項目はオプションですが（前述のとおり）、後方互換性のある変更のみを行うようにしています。

.. The compiler API expects a JSON formatted input and outputs the compilation result in a JSON formatted output.
.. The standard error output is not used and the process will always terminate in a "success" state, even if there were errors. Errors are always reported as part of the JSON output.

コンパイラAPIは、JSON形式の入力を期待し、コンパイル結果をJSON形式の出力で出力します。
標準のエラー出力は使用されず、エラーがあった場合でも、常に「成功」の状態で処理が終了します。
エラーは常にJSON出力の一部として報告されます。

.. The following subsections describe the format through an example.
.. Comments are of course not permitted and used here only for explanatory purposes.

以下のサブセクションでは、例を挙げてフォーマットを説明します。
もちろん、コメントは許可されておらず、ここでは説明のためにのみ使用されています。

入力の説明
----------

.. code-block:: javascript

    {
      // Required: Source code language. Currently supported are "Solidity", "Yul" and "SolidityAST" (experimental).
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
            // If files are used, their directories should be added to the command-line via
            // `--allow-paths <path>`.
          ]
          // If language is set to "SolidityAST", an AST needs to be supplied under the "ast" key.
          // Note that importing ASTs is experimental and in particular that:
          // - importing invalid ASTs can produce undefined results and
          // - no proper error reporting is available on invalid ASTs.
          // Furthermore, note that the AST import only consumes the fields of the AST as
          // produced by the compiler in "stopAfter": "parsing" mode and then re-performs
          // analysis, so any analysis-based annotations of the AST are ignored upon import.
          "ast": { ... } // formatted as the json ast requested with the ``ast`` output selection.
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
            // The inliner is always off if no details are given,
            // use details to switch it on.
            "inliner": false,
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
              // Select optimization steps to be applied. It is also possible to modify both the
              // optimization sequence and the clean-up sequence. Instructions for each sequence
              // are separated with the ":" delimiter and the values are provided in the form of
              // optimization-sequence:clean-up-sequence. For more information see
              // "The Optimizer > Selecting Optimizations".
              // This field is optional, and if not provided, the default sequences for both
              // optimization and clean-up are used. If only one of the sequences is provided
              // the other will not be run.
              // If only the delimiter ":" is provided then neither the optimization nor the clean-up
              // sequence will be run.
              // If set to an empty value, only the default clean-up sequence is used and
              // no optimization steps are applied.
              "optimizerSteps": "dhfoDgvulfnTUtnIf..."
            }
          }
        },
        // Version of the EVM to compile for.
        // Affects type checking and code generation. Can be homestead,
        // tangerineWhistle, spuriousDragon, byzantium, constantinople, petersburg, istanbul, berlin, london or paris
        "evmVersion": "byzantium",
        // Optional: Change compilation pipeline to go through the Yul intermediate representation.
        // This is false by default.
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
          // The CBOR metadata is appended at the end of the bytecode by default.
          // Setting this to false omits the metadata from the runtime and deploy time code.
          "appendCBOR": true,
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
        //   irAst - AST of Yul intermediate representation of the code before optimization
        //   irOptimized - Intermediate representation after optimization
        //   irOptimizedAst - AST of intermediate representation after optimization
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
        //
        // Note that using a using `evm`, `evm.bytecode`, etc. will select every
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
          // Choose how division and modulo operations should be encoded.
          // When using `false` they are replaced by multiplication with slack
          // variables. This is the default.
          // Using `true` here is recommended if you are using the CHC engine
          // and not using Spacer as the Horn solver (using Eldarica, for example).
          // See the Formal Verification section for a more detailed explanation of this option.
          "divModNoSlacks": false,
          // Choose which model checker engine to use: all (default), bmc, chc, none.
          "engine": "chc",
          // Choose whether external calls should be considered trusted in case the
          // code of the called function is available at compile-time.
          // For details see the SMTChecker section.
          "extCalls": "trusted",
          // Choose which types of invariants should be reported to the user: contract, reentrancy.
          "invariants": ["contract", "reentrancy"],
          // Choose whether to output all proved targets. The default is `false`.
          "showProved": true,
          // Choose whether to output all unproved targets. The default is `false`.
          "showUnproved": true,
          // Choose whether to output all unsupported language features. The default is `false`.
          "showUnsupported": true,
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

出力の説明
----------

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
          // Mandatory: Component where the error originated, such as "general" etc.
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
            // Intermediate representation before optimization (string)
            "ir": "",
            // AST of intermediate representation before optimization
            "irAst":  {/* ... */},
            // Intermediate representation after optimization (string)
            "irOptimized": "",
            // AST of intermediate representation after optimization
            "irOptimizedAst": {/* ... */},
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
            }
          }
        }
      }
    }

エラータイプ
~~~~~~~~~~~~

.. 1. ``JSONError``: JSON input doesn't conform to the required format, e.g. input is not a JSON object, the language is not supported, etc.

<<<<<<< HEAD
1. ``JSONError``: JSON入力が要求されたフォーマットに適合していない。
   例: 入力がJSONオブジェクトでない、言語がサポートされていない、など。

.. 2. ``IOError``: IO and import processing errors, such as unresolvable URL or hash mismatch in supplied sources.

2. ``IOError``: 解決できないURLや提供されたソースのハッシュの不一致など、IOおよびインポート処理のエラー。

.. 3. ``ParserError``: Source code doesn't conform to the language rules.

3. ``ParserError``: ソースコードが言語ルールに準拠していない。

.. 4. ``DocstringParsingError``: The NatSpec tags in the comment block cannot be parsed.

4. ``DocstringParsingError``: コメントブロック内のNatSpecタグが解析できない。

.. 5. ``SyntaxError``: Syntactical error, such as ``continue`` is used outside of a ``for`` loop.

5. ``SyntaxError``:  ``for`` ループの外で ``continue`` が使われているなど、構文上のエラー。

.. 6. ``DeclarationError``: Invalid, unresolvable or clashing identifier names. e.g. ``Identifier not found``

6. ``DeclarationError``: 無効な、解決不可能な、または衝突した識別子名。
   例:  ``Identifier not found``。

.. 7. ``TypeError``: Error within the type system, such as invalid type conversions, invalid assignments, etc.

7. ``TypeError``: 無効な型変換、無効な代入など、型システム内のエラー。

.. 8. ``UnimplementedFeatureError``: Feature is not supported by the compiler, but is expected to be supported in future versions.

8. ``UnimplementedFeatureError``: この機能はコンパイラではサポートされていませんが、将来のバージョンではサポートされる予定です。

.. 9. ``InternalCompilerError``: Internal bug triggered in the compiler - this should be reported as an issue.

9. ``InternalCompilerError``: コンパイラの内部バグが発生しました。

.. 10. ``Exception``: Unknown failure during compilation - this should be reported as an issue.

10. ``Exception``: コンパイル時に不明な障害が発生しました - これはイシューとして報告すべきです。

.. 11. ``CompilerError``: Invalid use of the compiler stack - this should be reported as an issue.

11. ``CompilerError``: コンパイラースタックの無効な使用 - これはイシューとして報告すべきです。

.. 12. ``FatalError``: Fatal error not processed correctly - this should be reported as an issue.

12. ``FatalError``: 致命的なエラーが正しく処理されていない - これはイシューとして報告すべきです。

.. 13. ``YulException``: Error during Yul Code generation - this should be reported as an issue.

13. ``YulException``: Yulコード生成時のエラー - これはイシューとして報告すべきです。

.. 14. ``Warning``: A warning, which didn't stop the compilation, but should be addressed if possible.

14. ``Warning``: 警告。コンパイルは停止しなかったが、できれば対処すべきです。

.. 15. ``Info``: Information that the compiler thinks the user might find useful, but is not dangerous and does not necessarily need to be addressed.

15. ``Info``: コンパイラが、ユーザーが役に立つかもしれないと考えている情報。しかし、危険ではないので、必ず対処する必要はありません。
=======
1. ``JSONError``: JSON input doesn't conform to the required format, e.g. input is not a JSON object, the language is not supported, etc.
2. ``IOError``: IO and import processing errors, such as unresolvable URL or hash mismatch in supplied sources.
3. ``ParserError``: Source code doesn't conform to the language rules.
4. ``DocstringParsingError``: The NatSpec tags in the comment block cannot be parsed.
5. ``SyntaxError``: Syntactical error, such as ``continue`` is used outside of a ``for`` loop.
6. ``DeclarationError``: Invalid, unresolvable or clashing identifier names. e.g. ``Identifier not found``
7. ``TypeError``: Error within the type system, such as invalid type conversions, invalid assignments, etc.
8. ``UnimplementedFeatureError``: Feature is not supported by the compiler, but is expected to be supported in future versions.
9. ``InternalCompilerError``: Internal bug triggered in the compiler - this should be reported as an issue.
10. ``Exception``: Unknown failure during compilation - this should be reported as an issue.
11. ``CompilerError``: Invalid use of the compiler stack - this should be reported as an issue.
12. ``FatalError``: Fatal error not processed correctly - this should be reported as an issue.
13. ``YulException``: Error during Yul code generation - this should be reported as an issue.
14. ``Warning``: A warning, which didn't stop the compilation, but should be addressed if possible.
15. ``Info``: Information that the compiler thinks the user might find useful, but is not dangerous and does not necessarily need to be addressed.
>>>>>>> english/develop
