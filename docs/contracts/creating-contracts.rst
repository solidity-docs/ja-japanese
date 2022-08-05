.. index:: ! contract;creation, constructor

**********************
コントラクトの作成
**********************

コントラクトは、Ethereumのトランザクションを介して「外部から」作成することも、Solidityのコントラクトから作成することもできます。

`Remix <https://remix.ethereum.org/>`_ に代表されるIDEは、UIによって作成プロセスをシームレスにします。

Ethereumでプログラマティックにコントラクトを作成する方法の一つとして、JavaScript APIの `web3.js <https://github.com/ethereum/web3.js>`_ があります。
これにはコントラクトの作成を容易にする `web3.eth.Contract <https://web3js.readthedocs.io/en/1.0/web3-eth-contract.html#new-contract>`_ という関数があります。

コントラクトが作成されると、その :ref:`コンストラクタ <constructor>` （ ``constructor`` キーワードで宣言された関数）が一度だけ実行されます。

コンストラクタはオプションです。コンストラクタは1つしか許可されていないので、オーバーロードはサポートされていません。

.. After the constructor has executed, the final code of the contract is stored on the
.. blockchain. This code includes all public and external functions and all functions
.. that are reachable from there through function calls. The deployed code does not
.. include the constructor code or internal functions only called from the constructor.

コンストラクタが実行された後、コントラクトの最終コードがブロックチェーンに保存されます。
このコードには、すべてのパブリック関数と外部関数、および関数呼び出しによってそこから到達可能なすべての関数が含まれます。
デプロイされたコードには、コンストラクタのコードや、コンストラクタからのみ呼び出される内部関数は含まれません。

.. index:: constructor;arguments

.. Internally, constructor arguments are passed :ref:`ABI encoded <ABI>` after the code of
.. the contract itself, but you do not have to care about this if you use ``web3.js``.

内部的にはコンストラクタの引数はコントラクト自体のコードの後に :ref:`ABIエンコード <ABI>` を渡していますが、 ``web3.js`` を使用する場合はこれを気にする必要はありません。

あるコントラクトが別のコントラクトを作成したい場合、作成するコントラクトのソースコード（およびバイナリ）を作成者が知っていなければなりません。
これは周期的な作成の依存関係は不可能であることを意味します。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.22 <0.9.0;

    contract OwnedToken {
        // `TokenCreator` は、以下で定義されるコントラクトの型です。
        // 新しいコントラクトを作成するために使用しない限り、これを参照することは問題ありません。
        TokenCreator creator;
        address owner;
        bytes32 name;

        // 作成者と割り当てられた名前を登録するコンストラクタです。
        constructor(bytes32 _name) {
            // 状態変数には、その名前を通してアクセスします（`this.owner` などではない）。
            // 関数には、直接アクセスすることも、 `this.f` を介してアクセスすることもできますが、後者は関数への外部からのアクセスを提供します。
            // 特にコンストラクタでは、まだ関数が存在しないので、外部から関数にアクセスするべきではありません。
            // 詳しくは次のセクションを参照してください。
            owner = msg.sender;

            // `address` から `TokenCreator` への明示的な型変換を行い、
            // 呼び出したコントラクトの型が `TokenCreator` であることを仮定していますが、
            // 実際にそれを確認する方法はありません。
            // これは新しいコントラクトを作成するわけではありません。
            creator = TokenCreator(msg.sender);
            name = _name;
        }

        function changeName(bytes32 newName) public {
            // 作成者のみが名称を変更できる。
            // コントラクトの比較は、アドレスに明示的に変換することで取得できるアドレスをもとに行う。
            if (msg.sender == address(creator))
                name = newName;
        }

        function transfer(address newOwner) public {
            // トークンを送信できるのは、現在の所有者のみです。
            if (msg.sender != owner) return;

            // 以下に定義する `TokenCreator` コントラクトの関数を用いて、送金を進めるべきかどうかを作成者コントラクトに問い合わせる。
            // 呼び出しに失敗した場合（ガス欠など）、ここでの実行も失敗する。
            if (creator.isTokenTransferOK(owner, newOwner))
                owner = newOwner;
        }
    }

    contract TokenCreator {
        function createToken(bytes32 name)
            public
            returns (OwnedToken tokenAddress)
        {
            // 新しい `Token` コントラクトを作成し、そのアドレスを返す。
            // JavaScript 側から見ると、この関数の戻り値の型は `address` です。これは ABI で利用可能な最も近い型だからです。
            return new OwnedToken(name);
        }

        function changeName(OwnedToken tokenAddress, bytes32 name) public {
            // ここでも、`tokenAddress` の外部型は単純に `address` です。
            tokenAddress.changeName(name);
        }

        // `OwnedToken`コントラクトにトークンを送信するかどうかのチェックを行う。
        function isTokenTransferOK(address currentOwner, address newOwner)
            public
            pure
            returns (bool ok)
        {
            // 送金を進めるかどうか、任意の条件をチェックする。
            return keccak256(abi.encodePacked(currentOwner, newOwner))[0] == 0x7f;
        }
    }

