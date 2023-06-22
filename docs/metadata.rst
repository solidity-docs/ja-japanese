.. _metadata:

########################
コントラクトのメタデータ
########################

.. index:: metadata, contract verification

<<<<<<< HEAD
.. You can use this file to query the compiler version, the sources used, the ABI and NatSpec
.. documentation to more safely interact with the contract and verify its source code.

Solidityコンパイラは、コンパイルされたコントラクトに関する情報を含むJSONファイルであるコントラクトのメタデータを自動的に生成します。
このファイルを使用して、コンパイラのバージョン、使用されたソース、ABI、NatSpecドキュメントを照会し、より安全にコントラクトを操作し、そのソースコードを検証できます。
=======
The Solidity compiler automatically generates a JSON file.
The file contains two kinds of information about the compiled contract:

- How to interact with the contract: ABI, and NatSpec documentation.
- How to reproduce the compilation and verify a deployed contract:
  compiler version, compiler settings, and source files used.

The compiler appends by default the IPFS hash of the metadata file to the end
of the runtime bytecode (not necessarily the creation bytecode) of each contract,
so that, if published, you can retrieve the file in an authenticated way without
having to resort to a centralized data provider. The other available options are
the Swarm hash and not appending the metadata hash to the bytecode. These can be
configured via the :ref:`Standard JSON Interface<compiler-api>`.
>>>>>>> english/develop

.. so that you can retrieve the file in an authenticated way without having to resort to a
.. centralized data provider.

コンパイラはデフォルトで、メタデータファイルのIPFSハッシュを各コントラクトのバイトコードの最後に付加します（詳細は以下を参照）。
これにより、中央のデータプロバイダに頼ることなく、認証された方法でファイルを取得できます。
他に利用可能なオプションとして、Swarmハッシュと、バイトコードにメタデータハッシュを付加しないものがあります。
これらは :ref:`標準JSONインターフェース<compiler-api>` で設定できます。


メタデータファイルをIPFSやSwarmなどのサービスに公開して、他の人がアクセスできるようにする必要があります。
このファイルは ``solc --metadata`` コマンドと ``--output-dir`` パラメータを使用して作成します。
Without the parameter, the metadata will be written to standard output.
The metadata contains IPFS and Swarm references to the source code, so you have to
upload all source files in addition to the metadata file. For IPFS, the hash contained
in the CID returned by ``ipfs add`` (not the direct sha2-256 hash of the file)
shall match with the one contained in the bytecode.

<<<<<<< HEAD
メタデータファイルの形式は以下の通りです。
以下の例は、人間が読める形で表示されています。
適切にフォーマットされたメタデータは、引用符を正しく使用し、ホワイトスペースを可能な限り無くし、すべてのオブジェクトのキーをソートして、ユニークなフォーマットにならなければなりません。
コメントは許可されておらず、ここでは説明のためにのみ使用されています。
=======
The metadata file has the following format. The example below is presented in a
human-readable way. Properly formatted metadata should use quotes correctly,
reduce whitespace to a minimum, and sort the keys of all objects in alphabetical order
to arrive at a canonical formatting. Comments are not permitted and are used here only for
explanatory purposes.
>>>>>>> english/develop

.. code-block:: javascript

    {
<<<<<<< HEAD
      // 必須: メタデータのフォーマットのバージョン
      "version": "1",
      // 必須:ソースコード言語。基本的に仕様の「サブバージョン」を選択します。
      "language": "Solidity",
      // 必須: コンパイラの詳細。内容は各言語に固有のもの。
      "compiler": {
        // Solidityには必須: コンパイラのバージョン
        "version": "0.8.2+commit.661d1103",
        // オプション: この出力を生成したコンパイラのバイナリのハッシュ
        "keccak256": "0x123..."
      },
      // 必須: コンパイルされたソースファイル/ソースユニット。キーはファイルパス。
      "sources":
      {
        "myDirectory/myFile.sol": {
          // 必須: ソースファイルのkeccak256ハッシュ
          "keccak256": "0x123...",
          // 必須（「content」が使用されていない場合、下記参照）。ソースファイルへのソートされたURL。プロトコルはほぼ任意であるが、IPFSのURLを推奨。
          "urls": [ "bzz-raw://7d7a...", "dweb:/ipfs/QmN..." ],
          // オプション: ソースファイルに与えられるSPDXライセンス識別子
          "license": "MIT"
        },
        "destructible": {
          // 必須: ソースファイルのkeccak256ハッシュ
          "keccak256": "0x234...",
          // 必須（「url」が使用されていない場合）: ソースファイルのリテラルコンテンツ
          "content": "contract destructible is owned { function destroy() { if (msg.sender == owner) selfdestruct(owner); } }"
        }
      },
      // 必須: コンパイラの設定
      "settings":
      {
        // Solidityには必須: import remappingsのソートされたリスト
        "remappings": [ ":g=/dir" ],
        // オプション: オプティマイザの設定。「enabled」および「runs」フィールドは非推奨であり、後方互換性のためにのみ与えられています。
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
          // 入力のjsonで使用されている設定を反映、デフォルトは「true」
          "appendCBOR": true,
          // 入力のjsonで使用されている設定を反映、デフォルトは「false」
          "useLiteralContent": true,
          // 入力のjsonで使用されている設定を反映、デフォルトは「ipfs」
          "bytecodeHash": "ipfs"
        },
        // Solidityには必須: このメタデータの作成対象となるコントラクトまたはライブラリのファイルパスおよび名前。
        "compilationTarget": {
          "myDirectory/myFile.sol": "MyContract"
        },
        // Solidityには必須: 使用するライブラリのアドレス
        "libraries": {
          "MyLib": "0x123123..."
        }
      },
      // 必須: コントラクトについて生成される情報
      "output":
      {
        // 必須: コントラクトのABI定義。「Contract ABI Specification」を参照。
        "abi": [/* ... */],
        // 必須: コントラクトのNatSpec開発者ドキュメント
=======
      // Required: Details about the compiler, contents are specific
      // to the language.
      "compiler": {
        // Optional: Hash of the compiler binary which produced this output
        "keccak256": "0x123...",
        // Required for Solidity: Version of the compiler
        "version": "0.8.2+commit.661d1103"
      },
      // Required: Source code language, basically selects a "sub-version"
      // of the specification
      "language": "Solidity",
      // Required: Generated information about the contract.
      "output": {
        // Required: ABI definition of the contract. See "Contract ABI Specification"
        "abi": [/* ... */],
        // Required: NatSpec developer documentation of the contract. See https://docs.soliditylang.org/en/latest/natspec-format.html for details.
>>>>>>> english/develop
        "devdoc": {
          // Contents of the @author NatSpec field of the contract
          "author": "John Doe",
          // Contents of the @dev NatSpec field of the contract
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
              // Contents of the @dev NatSpec field of the method
              "details": "Returns a boolean value indicating whether the operation succeeded. Must be called by the token holder address",
              // Contents of the @param NatSpec fields of the method
              "params": {
                "_value": "The amount tokens to be transferred",
                "_to": "The receiver address"
              },
              // Contents of the @return NatSpec field.
              "returns": {
                // Return var name (here "success") if exists. "_0" as key if return var is unnamed
                "success": "a boolean value indicating whether the operation succeeded"
              }
            }
          },
          "stateVariables": {
            "owner": {
              // Contents of the @dev NatSpec field of the state variable
              "details": "Must be set during contract creation. Can then only be changed by the owner"
            }
<<<<<<< HEAD
          }
          "events": {
            "Transfer(address,address,uint256)": {
              "details": "Emitted when `value` tokens are moved from one account (`from`) toanother (`to`)."
              "params": {
                "from": "The sender address"
                "to": "The receiver address"
                "value": "The token amount"
              }
            }
          }
        },
        // 必須: コントラクトのNatSpecユーザードキュメント
        "userdoc": {
=======
          },
          // Contents of the @title NatSpec field of the contract
          "title": "MyERC20: an example ERC20",
>>>>>>> english/develop
          "version": 1 // NatSpec version
        },
        // Required: NatSpec user documentation of the contract. See "NatSpec Format"
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
          "version": 1 // NatSpec version
        }
      },
      // Required: Compiler settings. Reflects the settings in the JSON input during compilation.
      // Check the documentation of standard JSON input's "settings" field
      "settings": {
        // Required for Solidity: File path and the name of the contract or library this
        // metadata is created for.
        "compilationTarget": {
          "myDirectory/myFile.sol": "MyContract"
        },
        // Required for Solidity.
        "evmVersion": "london",
        // Required for Solidity: Addresses for libraries used.
        "libraries": {
          "MyLib": "0x123123..."
        },
        "metadata": {
          // Reflects the setting used in the input json, defaults to "true"
          "appendCBOR": true,
          // Reflects the setting used in the input json, defaults to "ipfs"
          "bytecodeHash": "ipfs",
          // Reflects the setting used in the input json, defaults to "false"
          "useLiteralContent": true
        },
        // Optional: Optimizer settings. The fields "enabled" and "runs" are deprecated
        // and are only given for backward-compatibility.
        "optimizer": {
          "details": {
            "constantOptimizer": false,
            "cse": false,
            "deduplicate": false,
            // inliner defaults to "false"
            "inliner": false,
            // jumpdestRemover defaults to "true"
            "jumpdestRemover": true,
            "orderLiterals": false,
            // peephole defaults to "true"
            "peephole": true,
            "yul": true,
            // Optional: Only present if "yul" is "true"
            "yulDetails": {
              "optimizerSteps": "dhfoDgvulfnTUtnIf...",
              "stackAllocation": false
            }
          },
          "enabled": true,
          "runs": 500
        },
        // Required for Solidity: Sorted list of import remappings.
        "remappings": [ ":g=/dir" ]
      },
      // Required: Compilation source files/source units, keys are file paths
      "sources": {
        "destructible": {
          // Required (unless "url" is used): literal contents of the source file
          "content": "contract destructible is owned { function destroy() { if (msg.sender == owner) selfdestruct(owner); } }",
          // Required: keccak256 hash of the source file
          "keccak256": "0x234..."
        },
        "myDirectory/myFile.sol": {
          // Required: keccak256 hash of the source file
          "keccak256": "0x123...",
          // Optional: SPDX license identifier as given in the source file
          "license": "MIT",
          // Required (unless "content" is used, see above): Sorted URL(s)
          // to the source file, protocol is more or less arbitrary, but an
          // IPFS URL is recommended
          "urls": [ "bzz-raw://7d7a...", "dweb:/ipfs/QmN..." ]
        }
      },
      // Required: The version of the metadata format
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

<<<<<<< HEAD
.. Since the mapping might contain more keys (see below) and the beginning of that encoding is not easy to find, its length is added in a two-byte big-endian encoding.

将来は、メタデータファイルを検索する他の方法をサポートするかもしれないので、マッピング ``{"ipfs": <IPFS hash>, "solc": <compiler version>}`` は `CBOR <https://tools.ietf.org/html/rfc7049>`_ エンコードされて保存されます。
マッピングにはさらに多くのキーが含まれている可能性があり（後述）、そのエンコーディングの始まりを見つけるのは容易ではないため、その長さは2バイトのビッグエンディアンのエンコーディングで追加されます。
現在のバージョンのSolidityコンパイラは、通常、デプロイされたバイトコードの末尾に以下を追加します。
=======
The compiler currently by default appends the
`IPFS hash (in CID v0) <https://docs.ipfs.tech/concepts/content-addressing/#version-0-v0>`_
of the canonical metadata file and the compiler version to the end of the bytecode.
Optionally, a Swarm hash instead of the IPFS, or an experimental flag is used.
Below are all the possible fields:
>>>>>>> english/develop

.. code-block:: javascript

    {
      "ipfs": "<metadata hash>",
      // If "bytecodeHash" was "bzzr1" in compiler settings not "ipfs" but "bzzr1"
      "bzzr1": "<metadata hash>",
      // Previous versions were using "bzzr0" instead of "bzzr1"
      "bzzr0": "<metadata hash>",
      // If any experimental features that affect code generation are used
      "experimental": true,
      "solc": "<compiler version>"
    }

<<<<<<< HEAD
そのため、データを取得するには、デプロイされたバイトコードの末尾がこのパターンに一致するかどうかをチェックし、IPFSハッシュを使用してファイルを取得できます（pinned/publishedの場合）。

.. Whereas release builds of solc use a 3 byte encoding of the version as shown
.. above (one byte each for major, minor and patch version number), prerelease builds
.. will instead use a complete version string including commit hash and build date.
=======
Because we might support other ways to retrieve the
metadata file in the future, this information is stored
`CBOR <https://tools.ietf.org/html/rfc7049>`_-encoded. The last two bytes in the bytecode
indicate the length of the CBOR encoded information. By looking at this length, the
relevant part of the bytecode can be decoded with a CBOR decoder.

Check the `Metadata Playground <https://playground.sourcify.dev/>`_ to see it in action.

Whereas release builds of solc use a 3 byte encoding of the version as shown
above (one byte each for major, minor and patch version number), pre-release builds
will instead use a complete version string including commit hash and build date.
>>>>>>> english/develop

solcのリリースビルドでは、上記のようにバージョンを3バイト（メジャー、マイナー、パッチのバージョン番号を各1バイト）でエンコードしていますが、プレリリースビルドでは、コミットハッシュとビルド日を含む完全なバージョン文字列を使用します。

.. The commandline flag ``--no-cbor-metadata`` can be used to skip metadata from getting appended at the end of the deployed bytecode.
.. Equivalently, the boolean field ``settings.metadata.appendCBOR`` in Standard JSON input can be set to false.

コマンドラインフラグ ``--no-cbor-metadata`` を使用すると、デプロイされたバイトコードの最後に追加されるメタデータをスキップできます。
同様に、Standard JSON入力のブーリアンフィールド ``settings.metadata.appendCBOR`` をfalseに設定できます。

.. note::
<<<<<<< HEAD

  CBORマッピングには他のキーも含まれている可能性があるため、 データが ``0xa264`` から始まるかどうかに頼るのではなく、完全にデコードした方が良いです。
  例えば、コード生成に影響を与える実験的な機能が使用されている場合、マッピングには ``"experimental": true`` も含まれます。

.. .. note::

..   The compiler currently uses the IPFS hash of the metadata by default, but
..   it may also use the bzzr1 hash or some other hash in the future, so do
..   not rely on this sequence to start with ``0xa2 0x64 'i' 'p' 'f' 's'``.
..   We might also add additional data to this CBOR structure, so the best option
..   is to use a proper CBOR parser.

.. note::

  コンパイラは現在、メタデータのIPFSハッシュをデフォルトで使用していますが、将来はbzzr1ハッシュやその他のハッシュも使用する可能性があるため、 ``0xa2 0x64 'i' 'p' 'f' 's'`` から始まるこのシーケンスに依存しないようにしてください。
  また、このCBOR構造に追加のデータを加えるかもしれないため、適切なCBORパーサーを使用することが最良の選択肢です。
=======
  The CBOR mapping can also contain other keys, so it is better to fully
  decode the data by looking at the end of the bytecode for the CBOR length,
  and to use a proper CBOR parser. Do not rely on it starting with ``0xa264``
  or ``0xa2 0x64 'i' 'p' 'f' 's'``.
>>>>>>> english/develop

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

<<<<<<< HEAD
.. The component can then use the ABI to automatically generate a rudimentary
.. user interface for the contract.
=======
Furthermore, the wallet can use the NatSpec user documentation to display a
human-readable confirmation message to the user whenever they interact with
the contract, together with requesting authorization for the transaction signature.
>>>>>>> english/develop

このコンポーネントは、ABIを使ってコントラクトの初歩的なユーザーインターフェースを自動的に生成できます。

.. Furthermore, the wallet can use the NatSpec user documentation to display a human-readable confirmation message to the user
.. whenever they interact with the contract, together with requesting
.. authorization for the transaction signature.

<<<<<<< HEAD
さらに、ウォレットはNatSpecユーザードキュメントを使用して、ユーザーがコントラクトと対話する際には必ずヒューマンリーダブルな確認メッセージを表示し、併せてトランザクション署名の承認を要求できます。

詳しくは、 :doc:`Ethereum Natural Language Specification (NatSpec) フォーマット <natspec-format>` を参照してください。

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
=======
If pinned/published, it is possible to retrieve the metadata of the contract from IPFS/Swarm.
The metadata file also contains the URLs or the IPFS hashes of the source files, as well as
the compilation settings, i.e. everything needed to reproduce a compilation.

With this information it is then possible to verify the source code of a contract by
reproducing the compilation, and comparing the bytecode from the compilation with
the bytecode of the deployed contract.

This automatically verifies the metadata since its hash is part of the bytecode, as well
as the source codes, because their hashes are part of the metadata. Any change in the files
or settings would result in a different metadata hash. The metadata here serves
as a fingerprint of the whole compilation.

`Sourcify <https://sourcify.dev>`_ makes use of this feature for "full/perfect verification",
as well as pinning the files publicly on IPFS to be accessed with the metadata hash.
>>>>>>> english/develop
