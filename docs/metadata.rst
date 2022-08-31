.. _metadata:

########################
コントラクトのメタデータ
########################

.. index:: metadata, contract verification

.. You can use this file to query the compiler version, the sources used, the ABI and NatSpec
.. documentation to more safely interact with the contract and verify its source code.

Solidityコンパイラは、コンパイルされたコントラクトに関する情報を含むJSONファイルであるコントラクトのメタデータを自動的に生成します。
このファイルを使用して、コンパイラのバージョン、使用されたソース、ABI、NatSpecドキュメントを照会し、より安全にコントラクトを操作し、そのソースコードを検証できます。

.. so that you can retrieve the file in an authenticated way without having to resort to a
.. centralized data provider. 

コンパイラはデフォルトで、メタデータファイルのIPFSハッシュを各コントラクトのバイトコードの最後に付加します（詳細は以下を参照）。
これにより、中央のデータプロバイダに頼ることなく、認証された方法でファイルを取得できます。
他に利用可能なオプションとして、Swarmハッシュと、バイトコードにメタデータハッシュを付加しないものがあります。
これらは :ref:`標準JSONインターフェース<compiler-api>` で設定できます。

メタデータファイルをIPFSやSwarmなどのサービスに公開して、他の人がアクセスできるようにする必要があります。
このファイルを作成するには、 ``solc --metadata`` コマンドを使用して ``ContractName_meta.json`` というファイルを生成します。
このファイルにはIPFSやSwarmのソースコードへの参照が含まれているので、すべてのソースファイルとメタデータファイルをアップロードする必要があります。

メタデータファイルの形式は以下の通りです。
以下の例は、人間が読める形で表示されています。
適切にフォーマットされたメタデータは、引用符を正しく使用し、ホワイトスペースを可能な限り無くし、すべてのオブジェクトのキーをソートして、ユニークなフォーマットにならなければなりません。
コメントは許可されておらず、ここでは説明のためにのみ使用されています。

.. code-block:: javascript

    {
      // 必須: メタデータのフォーマットのバージョン
      "version": "1",
      // 必須:ソースコード言語。基本的に仕様の「サブバージョン」を選択する。
      "language": "Solidity",
      // 必須: コンパイラの詳細。内容は各言語に固有のもの。
      "compiler": {
        // Solidityには必須: コンパイラのバージョン
        "version": "0.4.6+commit.2dabbdf0.Emscripten.clang",
        // オプション: この出力を生成したコンパイラのバイナリのハッシュ
        "keccak256": "0x123..."
      },
      // 必須: コンパイルされたソースファイル/ソースユニット。キーはファイル名。
      "sources":
      {
        "myFile.sol": {
          // 必須: ソースファイルのkeccak256ハッシュ
          "keccak256": "0x123...",
          // 必須（「content」が使用されていない場合、下記参照）。ソースファイルへのソートされたURL。プロトコルはほぼ任意であるが、SwarmのURLを推奨。
          "urls": [ "bzzr://56ab..." ],
          // オプション: ソースファイルに与えられるSPDXライセンス識別子
          "license": "MIT"
        },
        "destructible": {
          // 必須: ソースファイルのkeccak256ハッシュ
          "keccak256": "0x234...",
          // 必須（「url」が使用されていない場合）：ソースファイルのリテラルコンテンツ
          "content": "contract destructible is owned { function destroy() { if (msg.sender == owner) selfdestruct(owner); } }"
        }
      },
      // 必須: コンパイラの設定
      "settings":
      {
        // Solidityには必須: remappingsのソートされたリスト
        "remappings": [ ":g=/dir" ],
        // オプション: オプティマイザの設定。「enabled」および「runs」フィールドは非推奨であり、後方互換性のためにのみ与えられている。
        "optimizer": {
          "enabled": true,
          "runs": 500,
          "details": {
            // peepholeのデフォルトは「true」
            "peephole": true,
            // inlinerのデフォルトは「true」
            "inliner": true,
            // jumpdestRemoverのデフォルトは「true」
            "jumpdestRemover": true,
            "orderLiterals": false,
            "deduplicate": false,
            "cse": false,
            "constantOptimizer": false,
            "yul": true,
            // オプション: 「yul」が「true」のときのみ
            "yulDetails": {
              "stackAllocation": false,
              "optimizerSteps": "dhfoDgvulfnTUtnIf..."
            }
          }
        },
        "metadata": {
          // 入力のjsonで使用されている設定を反映、デフォルトは「false」
          "useLiteralContent": true,
          // 入力のjsonで使用されている設定を反映、デフォルトは「ipfs」
          "bytecodeHash": "ipfs"
        },
        // Solidityには必須: このメタデータの作成対象となるコントラクトまたはライブラリのファイルおよび名前。
        "compilationTarget": {
          "myFile.sol": "MyContract"
        },
        // Solidityには必須: 使用するライブラリのアドレス
        "libraries": {
          "MyLib": "0x123123..."
        }
      },
      // 必須: コントラクトについて生成される情報
      "output":
      {
        // 必須: コントラクトのABI定義
        "abi": [/* ... */],
        // 必須: コントラクトのNatSpecユーザードキュメント
        "userdoc": [/* ... */],
        // 必須: コントラクトのNatSpec開発者ドキュメント
        "devdoc": [/* ... */]
      }
    }

.. warning::

  結果として得られるコントラクトのバイトコードには、デフォルトでメタデータのハッシュが含まれているため、メタデータを変更すると、バイトコードも変更される可能性があります。
  これにはファイル名やパスの変更も含まれ、メタデータには使用されたすべてのソースのハッシュが含まれているため、たったひとつのホワイトスペースの変更でもメタデータが変わり、バイトコードも異なるものになります。

.. note::

    上記のABIの定義は、固定された順序はありません。
    コンパイラのバージョンによって変わる可能性があります。
    しかし、Solidityのバージョン0.5.12からは、この列は一定の順序を保っています。

.. _encoding-of-the-metadata-hash-in-the-bytecode:

バイトコードにおけるメタデータハッシュのエンコーディング
========================================================

.. Since the mapping might contain more keys (see below) and the beginning of that
.. encoding is not easy to find, its length is added in a two-byte big-endian
.. encoding. 

将来的には、メタデータファイルを検索する他の方法をサポートするかもしれないので、マッピング ``{"ipfs": <IPFS hash>, "solc": <compiler version>}`` は `CBOR <https://tools.ietf.org/html/rfc7049>`_ エンコードされて保存されます。
マッピングにはさらに多くのキーが含まれている可能性があり（後述）、そのエンコーディングの始まりを見つけるのは容易ではないため、その長さは2バイトのビッグエンディアンのエンコーディングで追加されます。
現在のバージョンのSolidityコンパイラは、通常、デプロイされたバイトコードの末尾に以下を追加します。

.. code-block:: text

    0xa2
    0x64 'i' 'p' 'f' 's' 0x58 0x22 <34 bytes IPFS hash>
    0x64 's' 'o' 'l' 'c' 0x43 <3 byte version encoding>
    0x00 0x33

そのため、ファイルを取得するには、デプロイされたバイトコードの末尾がこのパターンに一致するかどうかをチェックし、そのIPFSのハッシュを使用します。

.. Whereas release builds of solc use a 3 byte encoding of the version as shown
.. above (one byte each for major, minor and patch version number), prerelease builds
.. will instead use a complete version string including commit hash and build date.

solcのリリースビルドでは、上記のようにバージョンを3バイト（メジャー、マイナー、パッチのバージョン番号を各1バイト）でエンコードしていますが、プレリリースビルドでは、コミットハッシュとビルド日を含む完全なバージョン文字列を使用します。

.. note::

  CBORマッピングには他のキーも含まれている可能性があるため、 データが ``0xa264`` から始まるかどうかに頼るのではなく、完全にデコードした方が良いです。
  例えば、コード生成に影響を与える実験的な機能が使用されている場合、マッピングには ``"experimental": true`` も含まれます。

.. .. note::

..   The compiler currently uses the IPFS hash of the metadata by default, but
..   it may also use the bzzr1 hash or some other hash in the future, so do
..   not rely on this sequence to start with ``0xa2 0x64 'i' 'p' 'f' 's'``.
..   We might also add additional data to this CBOR structure, so the best option
..   is to use a proper CBOR parser.

.. note::

  コンパイラは現在、メタデータのIPFSハッシュをデフォルトで使用していますが、将来的にはbzzr1ハッシュやその他のハッシュも使用する可能性があるため、 ``0xa2 0x64 'i' 'p' 'f' 's'`` から始まるこのシーケンスに依存しないようにしてください。
  また、このCBOR構造に追加のデータを加えるかもしれないため、適切なCBORパーサーを使用することが最良の選択肢です。

インターフェースの自動生成とNatSpecの使用方法
=============================================

.. The metadata is used in the following way: A component that wants to interact
.. with a contract (e.g. Mist or any wallet) retrieves the code of the contract,
.. from that the IPFS/Swarm hash of a file which is then retrieved.  That file
.. is JSON-decoded into a structure like above.

このメタデータは次のように使用されます。
コントラクトとやりとりしたいコンポーネント（Mistやウォレットなど）は、コントラクトのコードを取得し、そこからIPFS/Swarmのハッシュを取得し、ファイルを取得しています。
そのファイルは、上記のような構造にJSONデコードされます。

.. The component can then use the ABI to automatically generate a rudimentary
.. user interface for the contract.

このコンポーネントは、ABIを使ってコントラクトの初歩的なユーザーインターフェースを自動的に生成できます。

.. Furthermore, the wallet can use the NatSpec user documentation to display a confirmation message to the user
.. whenever they interact with the contract, together with requesting
.. authorization for the transaction signature.

さらに、ウォレットはNatSpecユーザードキュメントを使用して、ユーザーがコントラクトと対話する際には必ず確認メッセージを表示し、併せてトランザクション署名の承認を要求できます。

詳しくは、 :doc:`Ethereum Natural Language Specification (NatSpec) format <natspec-format>` をご覧ください。

ソースコード検証の方法
======================

.. In order to verify the compilation, sources can be retrieved from IPFS/Swarm
.. via the link in the metadata file.
.. The compiler of the correct version (which is checked to be part of the "official" compilers)
.. is invoked on that input with the specified settings. The resulting
.. bytecode is compared to the data of the creation transaction or ``CREATE`` opcode data.
.. This automatically verifies the metadata since its hash is part of the bytecode.
.. Excess data corresponds to the constructor input data, which should be decoded
.. according to the interface and presented to the user.

コンパイルを確認するために、IPFS/Swarmからメタデータファイルのリンクを介してソースを取得できます。
その入力に対して、正しいバージョンのコンパイラ（「公式」コンパイラの一部であることが確認されている）が、指定された設定で起動されます。
結果のバイトコードは、作成トランザクションのデータまたは ``CREATE``  opcodeデータと比較されます。
メタデータのハッシュはバイトコードの一部であるため、これによりメタデータが自動的に検証されます。
余ったデータはコンストラクタの入力データに対応しており、インターフェースに従ってデコードし、ユーザーに提示する必要があります。

リポジトリ `sourcify <https://github.com/ethereum/sourcify>`_ （ `npmパッケージ <https://www.npmjs.com/package/source-verify>`_ ）には、この機能の使い方を示すサンプルコードがあります。
