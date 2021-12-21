.. _metadata:

#################
Contract Metadata
#################

.. index:: metadata, contract verification

.. The Solidity compiler automatically generates a JSON file, the contract
.. metadata, that contains information about the compiled contract. You can use
.. this file to query the compiler version, the sources used, the ABI and NatSpec
.. documentation to more safely interact with the contract and verify its source
.. code.

Solidity コンパイラは、コンパイルされたコントラクトに関する情報を含む JSON ファイル（コントラクト メタデータ）を自動的に生成します。このファイルを使用して、コンパイラのバージョン、使用されたソース、ABI、NatSpecドキュメントを照会し、コントラクトをより安全に操作し、そのソースコードを検証できます。

.. The compiler appends by default the IPFS hash of the metadata file to the end
.. of the bytecode (for details, see below) of each contract, so that you can
.. retrieve the file in an authenticated way without having to resort to a
.. centralized data provider. The other available options are the Swarm hash and
.. not appending the metadata hash to the bytecode.  These can be configured via
.. the :ref:`Standard JSON Interface<compiler-api>`.

コンパイラはデフォルトで、メタデータ・ファイルのIPFSハッシュを各コントラクトのバイトコードの最後に付加します（詳細は以下を参照）。これにより、中央のデータ・プロバイダに頼ることなく、認証された方法でファイルを取得できます。その他の利用可能なオプションは、Swarmハッシュと、バイトコードにメタデータ・ハッシュを付加しないことです。  これらは :ref:`Standard JSON Interface<compiler-api>` で設定できます。

.. You have to publish the metadata file to IPFS, Swarm, or another service so
.. that others can access it. You create the file by using the ``solc --metadata``
.. command that generates a file called ``ContractName_meta.json``. It contains
.. IPFS and Swarm references to the source code, so you have to upload all source
.. files and the metadata file.

メタデータファイルをIPFSやSwarmなどのサービスに公開して、他の人がアクセスできるようにする必要があります。このファイルを作成するには、 ``solc --metadata`` コマンドを使用して ``ContractName_meta.json`` というファイルを生成します。このファイルにはIPFSやSwarmのソースコードへの参照が含まれているので、すべてのソースファイルとメタデータファイルをアップロードする必要があります。

.. The metadata file has the following format. The example below is presented in a
.. human-readable way. Properly formatted metadata should use quotes correctly,
.. reduce whitespace to a minimum and sort the keys of all objects to arrive at a
.. unique formatting. Comments are not permitted and used here only for
.. explanatory purposes.

メタデータファイルの形式は以下の通りです。以下の例は、人間が読める形で表示されています。適切にフォーマットされたメタデータは、引用符を正しく使用し、ホワイトスペースを最小限に抑え、すべてのオブジェクトのキーをソートして、ユニークなフォーマットに到達する必要があります。コメントは許可されておらず、ここでは説明のためにのみ使用されています。

.. code-block:: javascript

    {
      // Required: The version of the metadata format
      "version": "1",
      // Required: Source code language, basically selects a "sub-version"
      // of the specification
      "language": "Solidity",
      // Required: Details about the compiler, contents are specific
      // to the language.
      "compiler": {
        // Required for Solidity: Version of the compiler
        "version": "0.4.6+commit.2dabbdf0.Emscripten.clang",
        // Optional: Hash of the compiler binary which produced this output
        "keccak256": "0x123..."
      },
      // Required: Compilation source files/source units, keys are file names
      "sources":
      {
        "myFile.sol": {
          // Required: keccak256 hash of the source file
          "keccak256": "0x123...",
          // Required (unless "content" is used, see below): Sorted URL(s)
          // to the source file, protocol is more or less arbitrary, but a
          // Swarm URL is recommended
          "urls": [ "bzzr://56ab..." ],
          // Optional: SPDX license identifier as given in the source file
          "license": "MIT"
        },
        "destructible": {
          // Required: keccak256 hash of the source file
          "keccak256": "0x234...",
          // Required (unless "url" is used): literal contents of the source file
          "content": "contract destructible is owned { function destroy() { if (msg.sender == owner) selfdestruct(owner); } }"
        }
      },
      // Required: Compiler settings
      "settings":
      {
        // Required for Solidity: Sorted list of remappings
        "remappings": [ ":g=/dir" ],
        // Optional: Optimizer settings. The fields "enabled" and "runs" are deprecated
        // and are only given for backwards-compatibility.
        "optimizer": {
          "enabled": true,
          "runs": 500,
          "details": {
            // peephole defaults to "true"
            "peephole": true,
            // inliner defaults to "true"
            "inliner": true,
            // jumpdestRemover defaults to "true"
            "jumpdestRemover": true,
            "orderLiterals": false,
            "deduplicate": false,
            "cse": false,
            "constantOptimizer": false,
            "yul": true,
            // Optional: Only present if "yul" is "true"
            "yulDetails": {
              "stackAllocation": false,
              "optimizerSteps": "dhfoDgvulfnTUtnIf..."
            }
          }
        },
        "metadata": {
          // Reflects the setting used in the input json, defaults to false
          "useLiteralContent": true,
          // Reflects the setting used in the input json, defaults to "ipfs"
          "bytecodeHash": "ipfs"
        },
        // Required for Solidity: File and name of the contract or library this
        // metadata is created for.
        "compilationTarget": {
          "myFile.sol": "MyContract"
        },
        // Required for Solidity: Addresses for libraries used
        "libraries": {
          "MyLib": "0x123123..."
        }
      },
      // Required: Generated information about the contract.
      "output":
      {
        // Required: ABI definition of the contract
        "abi": [/* ... */],
        // Required: NatSpec user documentation of the contract
        "userdoc": [/* ... */],
        // Required: NatSpec developer documentation of the contract
        "devdoc": [/* ... */]
      }
    }

.. .. warning::

..   Since the bytecode of the resulting contract contains the metadata hash by default, any
..   change to the metadata might result in a change of the bytecode. This includes
..   changes to a filename or path, and since the metadata includes a hash of all the
..   sources used, a single whitespace change results in different metadata, and
..   different bytecode.

.. warning::

  結果として得られるコントラクトのバイトコードには、デフォルトでメタデータのハッシュが含まれているため、メタデータを変更すると、バイトコードも変更される可能性があります。これにはファイル名やパスの変更も含まれ、メタデータには使用されたすべてのソースのハッシュが含まれているため、たったひとつのホワイトスペースの変更でもメタデータが異なり、バイトコードも異なります。

.. .. note::

..     The ABI definition above has no fixed order. It can change with compiler versions.
..     Starting from Solidity version 0.5.12, though, the array maintains a certain
..     order.

.. note::

    上記のABIの定義は、固定された順序はありません。コンパイラのバージョンによって変わる可能性があります。     しかし、Solidityのバージョン0.5.12からは、この配列は一定の順序を保っています。

.. _encoding-of-the-metadata-hash-in-the-bytecode:

Encoding of the Metadata Hash in the Bytecode
=============================================

.. Because we might support other ways to retrieve the metadata file in the future,
.. the mapping ``{"ipfs": <IPFS hash>, "solc": <compiler version>}`` is stored
.. `CBOR <https://tools.ietf.org/html/rfc7049>`_-encoded. Since the mapping might
.. contain more keys (see below) and the beginning of that
.. encoding is not easy to find, its length is added in a two-byte big-endian
.. encoding. The current version of the Solidity compiler usually adds the following
.. to the end of the deployed bytecode

将来的には、メタデータファイルを検索する他の方法をサポートするかもしれないので、マッピング ``{"ipfs": <IPFS hash>, "solc": <compiler version>}`` は `CBOR <https://tools.ietf.org/html/rfc7049>`_ エンコードで保存される。マッピングにはさらに多くのキーが含まれている可能性があり（後述）、そのエンコーディングの始まりを見つけるのは容易ではないため、その長さは2バイトのビッグエンディアン・エンコーディングで追加されます。現在のバージョンのSolidityコンパイラは、通常、デプロイされたバイトコードの最後に以下を追加します。

.. code-block:: text

    0xa2
    0x64 'i' 'p' 'f' 's' 0x58 0x22 <34 bytes IPFS hash>
    0x64 's' 'o' 'l' 'c' 0x43 <3 byte version encoding>
    0x00 0x33

.. So in order to retrieve the data, the end of the deployed bytecode can be checked
.. to match that pattern and use the IPFS hash to retrieve the file.

そのため、データを取り出すためには、デプロイされたバイトコードの末尾がそのパターンに一致するかどうかをチェックし、IPFSのハッシュを使ってファイルを取り出すことができます。

.. Whereas release builds of solc use a 3 byte encoding of the version as shown
.. above (one byte each for major, minor and patch version number), prerelease builds
.. will instead use a complete version string including commit hash and build date.

solcのリリースビルドでは、上記のようにバージョンを3バイト（メジャー、マイナー、パッチのバージョン番号を各1バイト）でエンコードしていますが、プレリリースビルドでは、コミットハッシュとビルド日を含む完全なバージョン文字列を使用します。

.. .. note::

..   The CBOR mapping can also contain other keys, so it is better to fully
..   decode the data instead of relying on it starting with ``0xa264``.
..   For example, if any experimental features that affect code generation
..   are used, the mapping will also contain ``"experimental": true``.

.. note::

  CBORマッピングには他のキーも含まれている可能性があるので、 ``0xa264`` から始まるデータに頼るのではなく、完全にデコードした方が良い。   例えば、コード生成に影響を与える実験的な機能が使用されている場合、マッピングには ``"experimental": true`` も含まれます。

.. .. note::

..   The compiler currently uses the IPFS hash of the metadata by default, but
..   it may also use the bzzr1 hash or some other hash in the future, so do
..   not rely on this sequence to start with ``0xa2 0x64 'i' 'p' 'f' 's'``.  We
..   might also add additional data to this CBOR structure, so the best option
..   is to use a proper CBOR parser.

.. note::

  コンパイラは現在、メタデータのIPFSハッシュをデフォルトで使用していますが、将来的にはbzzr1ハッシュやその他のハッシュも使用する可能性がありますので、 ``0xa2 0x64 'i' 'p' 'f' 's'`` から始まるこの配列に依存しないようにしてください。  また、このCBOR構造に追加のデータを加えるかもしれませんので、適切なCBORパーサーを使用することが最良の選択肢です。

Usage for Automatic Interface Generation and NatSpec
====================================================

.. The metadata is used in the following way: A component that wants to interact
.. with a contract (e.g. Mist or any wallet) retrieves the code of the contract,
.. from that the IPFS/Swarm hash of a file which is then retrieved.  That file
.. is JSON-decoded into a structure like above.

このメタデータは次のように使用されます。コントラクトとやりとりしたいコンポーネント（Mistやウォレットなど）は、コントラクトのコードを取得し、そこからIPFS/Swarmのハッシュを取得し、ファイルを取得しています。  そのファイルは、上記のような構造にJSONデコードされます。

.. The component can then use the ABI to automatically generate a rudimentary
.. user interface for the contract.

このコンポーネントは、ABIを使ってコントラクトの初歩的なユーザーインターフェースを自動的に生成できます。

.. Furthermore, the wallet can use the NatSpec user documentation to display a confirmation message to the user
.. whenever they interact with the contract, together with requesting
.. authorization for the transaction signature.

さらに、ウォレットはNatSpecユーザードキュメントを使用して、ユーザーがコントラクトと対話する際には必ず確認メッセージを表示し、併せてトランザクション署名の承認を要求できます。

.. For additional information, read :doc:`Ethereum Natural Language Specification (NatSpec) format <natspec-format>`.

詳しくは、「:doc: `Ethereum Natural Language Specification (NatSpec) format <natspec-format>` 」をご覧ください。

Usage for Source Code Verification
==================================

.. In order to verify the compilation, sources can be retrieved from IPFS/Swarm
.. via the link in the metadata file.
.. The compiler of the correct version (which is checked to be part of the "official" compilers)
.. is invoked on that input with the specified settings. The resulting
.. bytecode is compared to the data of the creation transaction or ``CREATE`` opcode data.
.. This automatically verifies the metadata since its hash is part of the bytecode.
.. Excess data corresponds to the constructor input data, which should be decoded
.. according to the interface and presented to the user.

コンパイルを確認するために、IPFS/Swarmからメタデータファイルのリンクを介してソースを取得できます。その入力に対して、正しいバージョンのコンパイラ（「公式」コンパイラの一部であることが確認されている）が、指定された設定で起動される。結果のバイトコードは、作成トランザクションのデータまたは ``CREATE``  opcodeデータと比較される。メタデータのハッシュはバイトコードの一部であるため、これによりメタデータが自動的に検証されます。余ったデータはコンストラクタの入力データに対応しており、インターフェイスに従ってデコードし、ユーザーに提示する必要があります。

.. In the repository `sourcify <https://github.com/ethereum/sourcify>`_
.. (`npm package <https://www.npmjs.com/package/source-verify>`_) you can see
.. example code that shows how to use this feature.
.. 

リポジトリ `sourcify <https://github.com/ethereum/sourcify>`_ （ `npm package <https://www.npmjs.com/package/source-verify>`_ ）には、この機能の使い方を示すサンプルコードがあります。
