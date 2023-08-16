.. _metadata:

########################
コントラクトのメタデータ
########################

.. index:: metadata, contract verification

Solidityコンパイラは、自動的にJSONファイルを生成します。
このJSONファイルには、コンパイルされたコントラクトに関する2種類の情報が含まれています。

- コントラクトとの対話方法: ABIとNatSpecドキュメント。
- コンパイルを再現し、デプロイされたコントラクトを検証する方法:
  コンパイラのバージョン、コンパイラの設定、使用したソースファイル。

コンパイラはデフォルトで、メタデータファイルのIPFSハッシュを、各コントラクトの実行時バイトコード（生成バイトコードだけではない）の最後に追加します。
これにより、公開された場合、中央集権的なデータプロバイダーに頼ることなく、認証された方法でファイルを取得できるようになります。
他に利用可能なオプションとして、Swarmハッシュと、バイトコードにメタデータハッシュを付加しないものがあります。
これらは :ref:`標準JSONインターフェース<compiler-api>` で設定できます。

.. Without the parameter, the metadata will be written to standard output.
.. The metadata contains IPFS and Swarm references to the source code, so you have to upload all source files in addition to the metadata file.
.. For IPFS, the hash contained in the CID returned by ``ipfs add`` (not the direct sha2-256 hash of the file) shall match with the one contained in the bytecode.

そのメタデータファイルは、IPFSやSwarmなどのサービスに公開して、他の人がアクセスできるようにする必要があります。
このファイルは ``solc --metadata`` コマンドと ``--output-dir`` パラメータを使用して作成します。
パラメータを指定しないと、メタデータは標準出力に書き出されます。
メタデータにはソースコードへのIPFSとSwarmの参照が含まれるので、メタデータファイルに加えてすべてのソースファイルをアップロードする必要があります。
IPFSの場合、 ``ipfs add`` が返すCIDに含まれるハッシュ（ファイルの直接の sha2-256 ハッシュではない）は、バイトコードに含まれるハッシュと一致しなければなりません。

メタデータファイルの形式は以下の通りです。
以下の例は、人間が読める形で表示されています。
適切にフォーマットされたメタデータは、引用符を正しく使用し、ホワイトスペースを可能な限り無くし、すべてのオブジェクトのキーをアルファベット順にソートして、正規化されたフォーマットにならなければなりません。
コメントは許可されておらず、ここでは説明のためにのみ使用されています。

.. code-block:: javascript

  {
    // 必須: コンパイラの詳細。内容は各言語に固有のもの。
    "compiler": {
      // オプション: この出力を生成したコンパイラのバイナリのハッシュ
      "keccak256": "0x123...",
      // Solidityには必須: コンパイラのバージョン
      "version": "0.8.2+commit.661d1103"
    },
    // 必須:ソースコードの言語。基本的に仕様の「サブバージョン」を選択。
    "language": "Solidity",
    // 必須: コントラクトについて生成される情報
    "output": {
      // 必須: コントラクトのABI定義。「Contract ABI Specification」を参照。
      "abi": [/* ... */],
      // 必須: コントラクトのNatSpec開発者ドキュメント。詳しくは https://docs.soliditylang.org/en/latest/natspec-format.html を参照。
      "devdoc": {
        // コントラクトの @author NatSpecフィールドの内容
        "author": "John Doe",
        // コントラクトの @dev NatSpecフィールドの内容
        "details": "Interface of the ERC20 standard as defined in the EIP. See https://eips.ethereum.org/EIPS/eip-20 for details",
        "errors": {
          "MintToZeroAddress()" : {
            "details": "Cannot mint to zero address"
          }
        },
        "events": {
          "Transfer(address,address,uint256)": {
            "details": "Emitted when `value` tokens are moved from one account (`from`) toanother (`to`).",
            "params": {
              "from": "The sender address",
              "to": "The receiver address",
              "value": "The token amount"
            }
          }
        },
        "kind": "dev",
        "methods": {
          "transfer(address,uint256)": {
            // メソッドの @dev NatSpecフィールドの内容
            "details": "Returns a boolean value indicating whether the operation succeeded. Must be called by the token holder address",
            // メソッドの @param NatSpecフィールドの内容
            "params": {
              "_value": "The amount tokens to be transferred",
              "_to": "The receiver address"
            },
            // メソッドの @return NatSpecフィールドの内容
            "returns": {
              // 存在する場合、var名(ここでは "success")を返す。戻り値が無名の場合、"_0 "をキーとして返す。
              "success": "a boolean value indicating whether the operation succeeded"
            }
          }
        },
        "stateVariables": {
          "owner": {
            // 状態変数の @dev NatSpecフィールドの内容
            "details": "Must be set during contract creation. Can then only be changed by the owner"
          }
        },
        // コントラクトの @title NatSpecフィールドの内容
        "title": "MyERC20: an example ERC20",
        "version": 1 // NatSpecバージョン
      },
      // 必須: コントラクトのNatSpecユーザードキュメント。「NatSpec Format」を参照。
      "userdoc": {
        "errors": {
          "ApprovalCallerNotOwnerNorApproved()": [
            {
              "notice": "The caller must own the token or be an approved operator."
            }
          ]
        },
        "events": {
          "Transfer(address,address,uint256)": {
            "notice": "`_value` tokens have been moved from `from` to `to`"
          }
        },
        "kind": "user",
        "methods": {
          "transfer(address,uint256)": {
            "notice": "Transfers `_value` tokens to address `_to`"
          }
        },
        "version": 1 // NatSpecバージョン
      }
    },
    // 必須: コンパイラの設定。コンパイル時のJSON入力の設定が反映。
    // 標準JSON入力の「settings」フィールドのドキュメントを参照。
    "settings": {
      // Solidityには必須: このメタデータの作成対象となるコントラクトまたはライブラリのファイルパスおよび名前。
      "compilationTarget": {
        "myDirectory/myFile.sol": "MyContract"
      },
      // Solidityには必須
      "evmVersion": "london",
      // Solidityには必須: 使用するライブラリのアドレス
      "libraries": {
        "MyLib": "0x123123..."
      },
      "metadata": {
        // 入力のjsonで使用されている設定を反映、デフォルトは「true」
        "appendCBOR": true,
        // 入力のjsonで使用されている設定を反映、デフォルトは「ipfs」
        "bytecodeHash": "ipfs",
        // 入力のjsonで使用されている設定を反映、デフォルトは「false」
        "useLiteralContent": true
      },
      // オプション: オプティマイザの設定。
      // 「enabled」および「runs」フィールドは非推奨であり、後方互換性のためにのみ与えられています。
      "optimizer": {
        "details": {
          "constantOptimizer": false,
          "cse": false,
          "deduplicate": false,
          // inlinerのデフォルトは「true」
          "inliner": true,
          // jumpdestRemoverのデフォルトは「true」
          "jumpdestRemover": true,
          "orderLiterals": false,
          // peepholeのデフォルトは「true」
          "peephole": true,
          "yul": true,
          // オプション: "yul"が"true"の場合にのみ存在
          "yulDetails": {
            "optimizerSteps": "dhfoDgvulfnTUtnIf...",
            "stackAllocation": false
          }
        },
        "enabled": true,
        "runs": 500
      },
      // Solidityには必須: ソースファイルのインポートのリマッピング。
      "remappings": [ ":g=/dir" ]
    },
    // 必須: コンパイルされたソースファイル/ソースユニット。キーはファイルパス。
    "sources": {
      "destructible": {
        // 必須（「url」が使用されていない場合）: ソースファイルのリテラルコンテンツ
        "content": "contract destructible is owned { function destroy() { if (msg.sender == owner) selfdestruct(owner); } }",
        // 必須: ソースファイルのkeccak256ハッシュ
        "keccak256": "0x234..."
      },
      "myDirectory/myFile.sol": {
        // 必須: ソースファイルのkeccak256ハッシュ
        "keccak256": "0x123...",
        // オプション: ソースファイルに与えられるSPDXライセンス識別子
        "license": "MIT",
        // 必須（「content」が使用されていない場合、下記参照）: ソースファイルへのソートされたURL。
        // プロトコルはほぼ任意であるが、IPFSのURLを推奨。
        "urls": [ "bzz-raw://7d7a...", "dweb:/ipfs/QmN..." ]
      }
    },
    // 必須: メタデータフォーマットのバージョン
    "version": 1
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

.. The compiler currently by default appends the `IPFS hash (in CID v0) <https://docs.ipfs.tech/concepts/content-addressing/#version-0-v0>`_ of the canonical metadata file and the compiler version to the end of the bytecode.
.. Optionally, a Swarm hash instead of the IPFS, or an experimental flag is used.
.. Below are all the possible fields:

現在のデフォルトでは、コンパイラは正規メタデータファイルの `IPFS hash (in CID v0) <https://docs.ipfs.tech/concepts/content-addressing/#version-0-v0>`_ とコンパイラバージョンをバイトコードの最後に追加します。
オプションとして、IPFSの代わりにSwarmハッシュ、または実験的なフラグが使用されます。
以下は、使用可能なすべてのフィールドです:

.. code-block:: javascript

    {
      "ipfs": "<metadata hash>",
      // コンパイラの設定で "bytecodeHash" が "ipfs" ではなく "bzzr1" だった場合
      "bzzr1": "<metadata hash>",
      // 以前のバージョンでは "bzzr1" の代わりに "bzzr0" を使用していた
      "bzzr0": "<metadata hash>",
      // コード生成に影響を与える実験的機能が使用されている場合
      "experimental": true,
      "solc": "<compiler version>"
    }

.. Because we might support other ways to retrieve the metadata file in the future, this information is stored `CBOR <https://tools.ietf.org/html/rfc7049>`_-encoded.
.. The last two bytes in the bytecode indicate the length of the CBOR encoded information.
.. By looking at this length, the relevant part of the bytecode can be decoded with a CBOR decoder.

将来、メタデータファイルを取り出す他の方法をサポートするかもしれないので、この情報は `CBOR <https://tools.ietf.org/html/rfc7049>`_ エンコードされて格納されます。
バイトコードの最後の2バイトは、CBORエンコードされた情報の長さを示します。
この長さを見ることで、バイトコードの関連部分をCBORデコーダでデコードできます。

.. Whereas release builds of solc use a 3 byte encoding of the version as shown above (one byte each for major, minor and patch version number), pre-release builds will instead use a complete version string including commit hash and build date.

solcのリリースビルドでは、上記のようにバージョンを3バイト（メジャー、マイナー、パッチのバージョン番号を各1バイト）でエンコードしていますが、プレリリースビルドでは、コミットハッシュとビルド日を含む完全なバージョン文字列を使用します。

.. The commandline flag ``--no-cbor-metadata`` can be used to skip metadata from getting appended at the end of the deployed bytecode.
.. Equivalently, the boolean field ``settings.metadata.appendCBOR`` in Standard JSON input can be set to false.

コマンドラインフラグ ``--no-cbor-metadata`` を使用すると、デプロイされたバイトコードの最後に追加されるメタデータをスキップできます。
同様に、Standard JSON入力のブーリアンフィールド ``settings.metadata.appendCBOR`` をfalseに設定できます。

.. .. note::
..   The CBOR mapping can also contain other keys, so it is better to fully decode the data by looking at the end of the bytecode for the CBOR length, and to use a proper CBOR parser.
..   Do not rely on it starting with ``0xa264`` or ``0xa2 0x64 'i' 'p' 'f' 's'``.

.. note::

  CBORマッピングには他のキーも含まれている可能性があるため、CBORの長さについてはバイトコードの最後を見てデータを完全にデコードし、適切なCBORパーサーを使う方がよいです。
  ``0xa264`` や ``0xa2 0x64 'i' 'p' 'f' 's'`` で始まることはは当てになりません。

インターフェースの自動生成とNatSpecの使用方法
=============================================

.. The metadata is used in the following way: A component that wants to interact with a contract (e.g. a wallet) retrieves the code of the contract.
.. It decodes the CBOR encoded section containing the IPFS/Swarm hash of the metadata file.
.. With that hash, the metadata file is retrieved.
.. That file is JSON-decoded into a structure like above.

メタデータは次のように使用されます: コントラクトと対話したいコンポーネント（例えばウォレット）は、コントラクトのコードを取得します。
その際、メタデータファイルのIPFS/Swarmハッシュを含むCBORエンコードされたセクションをデコードします。
そのハッシュで、メタデータファイルを取得します。
そのファイルはJSONデコードされ、上記のような構造になります。

.. The component can then use the ABI to automatically generate a rudimentary user interface for the contract.

このコンポーネントは、ABIを使ってコントラクトの初歩的なユーザーインターフェースを自動的に生成できます。

.. Furthermore, the wallet can use the NatSpec user documentation to display a human-readable confirmation message to the user
.. whenever they interact with the contract, together with requesting
.. authorization for the transaction signature.

さらに、ウォレットはNatSpecユーザードキュメントを使用して、ユーザーがコントラクトと対話する際には必ずヒューマンリーダブルな確認メッセージを表示し、併せてトランザクション署名の承認を要求できます。

詳しくは、 :doc:`Ethereum Natural Language Specification (NatSpec) フォーマット <natspec-format>` を参照してください。

ソースコード検証の方法
======================

.. If pinned/published, it is possible to retrieve the metadata of the contract from IPFS/Swarm.
.. The metadata file also contains the URLs or the IPFS hashes of the source files, as well as the compilation settings, i.e. everything needed to reproduce a compilation.

ピン/パブリッシュされた場合、コントラクトのメタデータをIPFS/Swarmから取得することが可能です。
メタデータファイルには、ソースファイルのURLやIPFSハッシュ、コンパイル設定、つまりコンパイルを再現するために必要なすべての情報が含まれています。

.. With this information it is then possible to verify the source code of a contract by reproducing the compilation, and comparing the bytecode from the compilation with the bytecode of the deployed contract.

この情報があれば、コンパイルを再現し、コンパイルのバイトコードとデプロイされたコントラクトのバイトコードを比較することで、コントラクトのソースコードを検証できます。

.. This automatically verifies the metadata since its hash is part of the bytecode, as well as the source codes, because their hashes are part of the metadata. Any change in the files or settings would result in a different metadata hash. The metadata here serves as a fingerprint of the whole compilation.

メタデータのハッシュはバイトコードの一部であり、ソースコードのハッシュもメタデータの一部であるため、メタデータも自動的に検証されます。
ファイルや設定に変更があれば、メタデータのハッシュは異なるものになります。
ここでのメタデータはコンパイル全体のフィンガープリントとして機能します。

.. `Sourcify <https://sourcify.dev>`_ makes use of this feature for "full/perfect verification", as well as pinning the files publicly on IPFS to be accessed with the metadata hash.

`Sourcify <https://sourcify.dev>`_ はこの機能を「完全/完璧な検証」のために利用するだけでなく、メタデータのハッシュでアクセスできるようにファイルをIPFSに公開することもできます。
