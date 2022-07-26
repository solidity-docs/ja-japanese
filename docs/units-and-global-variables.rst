*******************************************
単位とグローバルで利用可能な変数
*******************************************

.. index:: wei, finney, szabo, gwei, ether

Etherの単位
============

リテラルの数に ``wei`` 、 ``gwei`` 、 ``ether`` の接尾辞を付けて、Etherの別の単位を指定できますが、接尾辞のないEtherの数はWeiとみなされます。

.. code-block:: solidity
    :force:

    assert(1 wei == 1);
    assert(1 gwei == 1e9);
    assert(1 ether == 1e18);

単位の接尾辞は、10の累乗にだけ対応しています。

.. note::

    バージョン0.7.0では、単位 ``finney`` と ``szabo`` が削除されました。

.. index:: time, seconds, minutes, hours, days, weeks, years

時間の単位
==========

リテラルの数の後に ``seconds`` 、 ``minutes`` 、 ``hours`` 、 ``days`` 、 ``weeks`` などの接尾辞をつけると、時間の単位を指定できます。
秒を基本単位とし、単位は次のように単純なものです。

* ``1 == 1 seconds``

* ``1 minutes == 60 seconds``

* ``1 hours == 60 minutes``

* ``1 days == 24 hours``

* ``1 weeks == 7 days``

.. Take care if you perform calendar calculations using these units, because
.. not every year equals 365 days and not even every day has 24 hours
.. because of `leap seconds <https://en.wikipedia.org/wiki/Leap_second>`_.
.. Due to the fact that leap seconds cannot be predicted, an exact calendar
.. library has to be updated by an external oracle.

これらの単位を使ってカレンダーの計算を行う場合、 `leap seconds <https://en.wikipedia.org/wiki/Leap_second>`_ のために1年が365日ではなく、1日が24時間でもないので注意が必要です。
うるう秒が予測できないため、正確なカレンダーライブラリは外部のオラクルで更新する必要があります。

.. note::

    上記の理由により、バージョン0.5.0では接尾語の ``years`` が削除されました。

これらの接尾辞は、変数には適用できません。例えば、関数のパラメータを日単位で解釈したい場合は、以下のようになります。

.. code-block:: solidity

    function f(uint start, uint daysAfter) public {
        if (block.timestamp >= start + daysAfter * 1 days) {
          // ...
        }
    }

.. _special-variables-functions:

特別な変数と関数
===============================

グローバルな名前空間に常に存在し、主にブロックチェーンに関する情報を提供するために使用されたり、汎用的なユーティリティー関数である特別な変数や関数があります。

.. index:: abi, block, coinbase, difficulty, encode, number, block;number, timestamp, block;timestamp, msg, data, gas, sender, value, gas price, origin

ブロックとトランザクションのプロパティ
----------------------------------------

- ``blockhash(uint blockNumber) returns (bytes32)``: ``blocknumber`` が直近256個のブロックの一つである場合は、与えられたブロックのハッシュ、そうでない場合はゼロを返す

- ``block.basefee`` (``uint``): カレントブロックのベースフィー（base fee）（ `EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ と `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_)

- ``block.chainid`` (``uint``): カレントブロックのチェーンID

- ``block.coinbase`` (``address payable``): カレントブロックのマイナーのアドレス

- ``block.difficulty`` (``uint``): カレントブロックの難易度

- ``block.gaslimit`` (``uint``): カレントブロックのガスリミット

- ``block.number`` (``uint``): カレントブロックの番号

- ``block.timestamp`` ( ``uint`` ): カレントブロックのタイムスタンプ（Unixエポックからの秒数）

- ``gasleft() returns (uint256)``: 残りのガス

- ``msg.data`` (``bytes calldata``): 完全なコールデータ

- ``msg.sender`` (``address``): メッセージの送信者（現在のコール）

- ``msg.sig`` (``bytes4``): コールデータの最初の4バイト（すなわち関数識別子）

- ``msg.value`` (``uint``): メッセージと一緒に送られたweiの数

- ``tx.gasprice`` (``uint``): トランザクションのガスプライス

- ``tx.origin`` (``address``): トランザクションの送信者（フルコールチェーン）

.. note::

    ``msg.sender`` と ``msg.value`` を含む ``msg`` のすべてのメンバーの値は、 **外部（external）** 関数を呼び出すたびに変わる可能性があります。
    これには、ライブラリ関数の呼び出しも含まれます。

.. .. note::

..     When contracts are evaluated off-chain rather than in context of a transaction included in a
..     block, you should not assume that ``block.*`` and ``tx.*`` refer to values from any specific
..     block or transaction. These values are provided by the EVM implementation that executes the
..     contract and can be arbitrary.

.. note::

    コントラクトが、ブロックに含まれるトランザクションのコンテキストではなく、オフチェーンで評価される場合、 ``block.*`` と ``tx.*`` が特定のブロックやトランザクションの値を参照していると仮定すべきではない。
    これらの値は、コントラクトを実行するEVM実装によって提供され、任意のものとなり得る。

.. .. note::

..     Do not rely on ``block.timestamp`` or ``blockhash`` as a source of randomness,
..     unless you know what you are doing.

..     Both the timestamp and the block hash can be influenced by miners to some degree.
..     Bad actors in the mining community can for example run a casino payout function on a chosen hash
..     and just retry a different hash if they did not receive any money.

..     The current block timestamp must be strictly larger than the timestamp of the last block,
..     but the only guarantee is that it will be somewhere between the timestamps of two
..     consecutive blocks in the canonical chain.

.. note::

    自分が何をしているか分かっていない限り、ランダムネスのソースとして ``block.timestamp`` や ``blockhash`` に頼らないでください。

    タイムスタンプもブロックハッシュも、ある程度はマイナーの影響を受ける可能性があります。
    マイニングコミュニティの悪質なアクターは、例えば、選択したハッシュでカジノのペイアウト関数を実行し、お金を受け取れなかった場合は別のハッシュで再試行できます。

    現在のブロックのタイムスタンプは、最後のブロックのタイムスタンプよりも厳密に大きくなければなりませんが、唯一の保証は、正規のチェーンで連続する2つのブロックのタイムスタンプの間のどこかになるということです。

.. note::

    ブロックハッシュは、スケーラビリティの観点から、すべてのブロックで利用できるわけではありません。
    アクセスできるのは最新の256ブロックのハッシュのみで、その他の値はすべてゼロになります。

.. note::

    関数 ``blockhash`` は、以前は ``block.blockhash`` と呼ばれていましたが、バージョン0.4.22で非推奨となり、バージョン0.5.0で削除されました。

.. note::

    ``gasleft`` 関数は、以前は ``msg.gas`` と呼ばれていましたが、バージョン0.4.21で非推奨となり、バージョン0.5.0で削除されました。

.. note::

    バージョン0.7.0では、 ``now`` (``block.timestamp``)というエイリアスを削除しました。

.. index:: abi, encoding, packed

ABIエンコーディングおよびデコーディングの関数
-----------------------------------------------

<<<<<<< HEAD
.. - ``abi.decode(bytes memory encodedData, (...)) returns (...)``: ABI-decodes the given data, while the types are given in parentheses as second argument. Example: ``(uint a, uint[2] memory b, bytes memory c) = abi.decode(data, (uint, uint[2], bytes))``
.. - ``abi.encode(...) returns (bytes memory)``: ABI-encodes the given arguments
.. - ``abi.encodePacked(...) returns (bytes memory)``: Performs :ref:`packed encoding <abi_packed_mode>` of the given arguments. Note that packed encoding can be ambiguous!
.. - ``abi.encodeWithSelector(bytes4 selector, ...) returns (bytes memory)``: ABI-encodes the given arguments starting from the second and prepends the given four-byte selector
.. - ``abi.encodeWithSignature(string memory signature, ...) returns (bytes memory)``: Equivalent to ``abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), ...)``

- ``abi.decode(bytes memory encodedData, (...)) returns (...)``: ABIは与えられたデータをデコードしますが、型は第2引数として括弧内に与えられます。例 ``(uint a, uint[2] memory b, bytes memory c) = abi.decode(data, (uint, uint[2], bytes))``。

- ``abi.encode(...) returns (bytes memory)``: 与えられた引数をABIエンコードします。

- ``abi.encodePacked(...) returns (bytes memory)``: 与えられた引数の :ref:`packed encoding <abi_packed_mode>` を実行します。パックされたエンコーディングは曖昧になる可能性があることに注意してください。

- ``abi.encodeWithSelector(bytes4 selector, ...) returns (bytes memory)``: 与えられた引数を2番目から順にABIエンコードし、与えられた4バイトのセレクタを前に付加します。

- ``abi.encodeWithSignature(string memory signature, ...) returns (bytes memory)``: ``abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), ...)`` に相当。

.. .. note::

..     These encoding functions can be used to craft data for external function calls without actually
..     calling an external function. Furthermore, ``keccak256(abi.encodePacked(a, b))`` is a way
..     to compute the hash of structured data (although be aware that it is possible to
..     craft a "hash collision" using different function parameter types).
=======
- ``abi.decode(bytes memory encodedData, (...)) returns (...)``: ABI-decodes the given data, while the types are given in parentheses as second argument. Example: ``(uint a, uint[2] memory b, bytes memory c) = abi.decode(data, (uint, uint[2], bytes))``
- ``abi.encode(...) returns (bytes memory)``: ABI-encodes the given arguments
- ``abi.encodePacked(...) returns (bytes memory)``: Performs :ref:`packed encoding <abi_packed_mode>` of the given arguments. Note that packed encoding can be ambiguous!
- ``abi.encodeWithSelector(bytes4 selector, ...) returns (bytes memory)``: ABI-encodes the given arguments starting from the second and prepends the given four-byte selector
- ``abi.encodeWithSignature(string memory signature, ...) returns (bytes memory)``: Equivalent to ``abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), ...)``
- ``abi.encodeCall(function functionPointer, (...)) returns (bytes memory)``: ABI-encodes a call to ``functionPointer`` with the arguments found in the tuple. Performs a full type-check, ensuring the types match the function signature. Result equals ``abi.encodeWithSelector(functionPointer.selector, (...))``
>>>>>>> 9f34322f394fc939fac0bf8b683fd61c45173674

.. note::

    これらのエンコーディング関数は、実際に外部関数を呼び出すことなく、外部関数呼び出しのためにデータを細工するために使用できます。
    さらに、 ``keccak256(abi.encodePacked(a, b))`` は構造化されたデータのハッシュを計算する方法でもあります（ただし、異なる関数パラメータタイプを使って「ハッシュの衝突」を工作することが可能なので注意が必要です）。

エンコーディングの詳細については、 :ref:`ABI<ABI>` および :ref:`tightly packed encoding<abi_packed_mode>` に関するドキュメントを参照してください。

.. index:: bytes members

bytesのメンバー
----------------

- ``bytes.concat(...) returns (bytes memory)`` :  :ref:`可変個の bytes, bytes1, ..., bytes32 の引数を一つのバイト列に連結します<bytes-concat>`。

.. index:: string members

Members of string
-----------------

- ``string.concat(...) returns (string memory)``: :ref:`Concatenates variable number of string arguments to one string array<string-concat>`


.. index:: assert, revert, require

エラーハンドリング
----------------------

エラー処理の詳細や、いつどの関数を使うかについては、 :ref:`assertとrequire<assert-and-require>` の専用セクションを参照してください。

``assert(bool condition)``
    条件が満たされないとパニックエラーを引き起こし、状態変化が戻ります - 内部エラーに使用されます。

``require(bool condition)`` 
    条件が満たされないとリバートします - 入力や外部コンポーネントのエラーに使用されます。

``require(bool condition, string memory message)``
    条件が満たされないとリバートします - 入力や外部コンポーネントのエラーに使用します。また、エラーメッセージも表示されます。

``revert()``
    実行を中止し、状態変化をリバートします。

``revert(string memory reason)``
    実行を中止し、状態変化をリバートするために、説明用の文字列を提供します。

.. index:: keccak256, ripemd160, sha256, ecrecover, addmod, mulmod, cryptography,

.. _mathematical-and-cryptographic-functions:

数理的関数と暗号学的関数
----------------------------------------

``addmod(uint x, uint y, uint k) returns (uint)``
    任意の精度で加算が実行され、 ``2**256`` で切り捨てられない ``(x + y) % k`` を計算します。バージョン0.5.0から ``k != 0`` であることをアサートします。

``mulmod(uint x, uint y, uint k) returns (uint)``
    任意の精度で乗算が実行され、 ``2**256`` で切り捨てられない ``(x * y) % k`` を計算します。バージョン0.5.0から ``k != 0`` であることをアサートします。


``keccak256(bytes memory) returns (bytes32)``
    入力のKeccak-256ハッシュを計算します。

.. note::

    以前は ``sha3`` という ``keccak256`` のエイリアスがありましたが、バージョン0.5.0で削除されました。

``sha256(bytes memory) returns (bytes32)``
    入力のSHA-256ハッシュを計算します。

``ripemd160(bytes memory) returns (bytes20)`` 
    入力のRIPEMD-160ハッシュを計算します。

.. ``ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)``
..     recover the address associated with the public key from elliptic curve signature or return zero on error.
..     The function parameters correspond to ECDSA values of the signature:

..     * ``r`` = first 32 bytes of signature

..     * ``s`` = second 32 bytes of signature

..     * ``v`` = final 1 byte of signature

..     ``ecrecover`` returns an ``address``, and not an ``address payable``. See :ref:`address payable<address>` for
..     conversion, in case you need to transfer funds to the recovered address.

..     For further details, read `example usage <https://ethereum.stackexchange.com/questions/1777/workflow-on-signing-a-string-with-private-key-followed-by-signature-verificatio>`_.

``ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)``
    楕円曲線の署名から公開鍵に紐づくアドレスを復元するか、エラーで0を返します。
    この関数のパラメータは、署名のECDSA値に対応しています。

    * ``r`` = 署名の最初の32バイト

    * ``s`` = 署名の2番目の32バイト

    * ``v`` = 署名の最後の1バイト

    ``ecrecover`` は ``address`` を返し、 ``address payable`` を返しません。
    復旧したアドレスに送金する必要がある場合は、 :ref:`address payable<address>` を参照して変換してください。

    詳しくは `使用例 <https://ethereum.stackexchange.com/questions/1777/workflow-on-signing-a-string-with-private-key-followed-by-signature-verificatio>`_ をご覧ください。

.. .. warning::

..     If you use ``ecrecover``, be aware that a valid signature can be turned into a different valid signature without
..     requiring knowledge of the corresponding private key. In the Homestead hard fork, this issue was fixed
..     for _transaction_ signatures (see `EIP-2 <https://eips.ethereum.org/EIPS/eip-2#specification>`_), but
..     the ecrecover function remained unchanged.

..     This is usually not a problem unless you require signatures to be unique or
..     use them to identify items. OpenZeppelin have a `ECDSA helper library <https://docs.openzeppelin.com/contracts/2.x/api/cryptography#ECDSA>`_ that you can use as a wrapper for ``ecrecover`` without this issue.

.. warning::

    ``ecrecover`` を使用している場合、対応する秘密鍵を知らなくても、有効な署名を別の有効な署名に変えることができることに注意してください。
    Homesteadのハードフォークでは、この問題は _transaction_ signaturesで修正されましたが（ `EIP-2 <https://eips.ethereum.org/EIPS/eip-2#specification>`_ 参照）、ecrecover関数は変更されませんでした。

    これは、署名を一意にする必要がある場合や、アイテムを識別するために使用する場合を除き、通常は問題になりません。
    OpenZeppelinには、この問題なしに ``ecrecover`` のラッパーとして使用できる `ECDSAヘルパーライブラリ <https://docs.openzeppelin.com/contracts/2.x/api/cryptography#ECDSA>`_ があります。

.. .. note::

..     When running ``sha256``, ``ripemd160`` or ``ecrecover`` on a *private blockchain*, you might encounter Out-of-Gas. This is because these functions are implemented as "precompiled contracts" and only really exist after they receive the first message (although their contract code is hardcoded). Messages to non-existing contracts are more expensive and thus the execution might run into an Out-of-Gas error. A workaround for this problem is to first send Wei (1 for example) to each of the contracts before you use them in your actual contracts. This is not an issue on the main or test net.

.. note::

    ``sha256`` 、 ``ripemd160`` 、 ``ecrecover`` を　*プライベートブロックチェーン* で実行すると、Out-of-Gasに遭遇することがあります。
    これは、これらの関数が「プリコンパイル済みコントラクト」として実装されており、最初のメッセージを受信して初めて実際に存在するからです（ただし、コントラクトコードはハードコードされています）。
    存在しないコントラクトへのメッセージはより高価であるため、実行時にOut-of-Gasエラーが発生する可能性があります。
    この問題を回避するには、実際のコントラクトで使用する前に、まず各コントラクトにWei（例: 1）を送信することです。
    これは、メインネットやテストネットでは問題になりません。

.. index:: balance, codehash, send, transfer, call, callcode, delegatecall, staticcall

.. _address_related:

アドレス型のメンバー
------------------------

``<address>.balance`` (``uint256``)
    :ref:`address` のWei残高

``<address>.code`` (``bytes memory``)
    :ref:`address` のコード（空でも良い）

``<address>.codehash`` (``bytes32``)
    :ref:`address` のコードハッシュ

``<address payable>.transfer(uint256 amount)``
    指定された量のWeiを :ref:`address` に送る、失敗するとリバートされる。2300ガスのみ使用可能（調整不可）。

``<address payable>.send(uint256 amount) returns (bool)``
    指定された量のWeiを :ref:`address` に送り、失敗すると ``false`` を返す。2300ガスのみ使用可能（調整不可）。

``<address>.call(bytes memory) returns (bool, bytes memory)``
    与えたペイロードで低レベルの ``CALL`` を発行し、成功条件とリターンデータを返す。利用可能なすべてのガスを送金できる（調整可能）。

``<address>.delegatecall(bytes memory) returns (bool, bytes memory)``
    与えたペイロードで低レベルの ``DELEGATECALL`` を発行し、成功条件とリターンデータを返す。利用可能なすべてのガスを送金できる（調整可能）。

``<address>.staticcall(bytes memory) returns (bool, bytes memory)``
    与えたペイロードで低レベルの ``STATICCALL`` を発行し、成功条件とリターンデータを返す。利用可能なすべてのガスを送金できる（調整可能）。

詳しくは、 :ref:`address` の項をご覧ください。

.. warning::

    ``.call()`` は、型チェック、関数の存在チェック、引数のパッキングをバイパスするので、他のコントラクトにある関数を実行する際には、可能な限り使用を避けるべきです。

.. warning::

    ``send`` の使用にはいくつかの危険があります。
    コールスタックの深さが1024の場合、送金は失敗し（これは常に呼び出し側で強制できます）、受信者がガス欠（out of gas）になった場合も失敗します。
    そのため、安全なEther送金を行うためには、 ``send`` の戻り値を常にチェックし、 ``transfer`` を使用するか、あるいはそれ以上の方法をとる必要があります。
    受信者がお金を引き出すパターンを使いましょう。

.. .. warning::

..     Due to the fact that the EVM considers a call to a non-existing contract to always succeed,
..     Solidity includes an extra check using the ``extcodesize`` opcode when performing external calls.
..     This ensures that the contract that is about to be called either actually exists (it contains code)
..     or an exception is raised.

..     The low-level calls which operate on addresses rather than contract instances (i.e. ``.call()``,
..     ``.delegatecall()``, ``.staticcall()``, ``.send()`` and ``.transfer()``) **do not** include this
..     check, which makes them cheaper in terms of gas but also less safe.

.. warning::

    EVMでは、存在しないコントラクトへの呼び出しは常に成功すると考えられているため、Solidityでは外部呼び出しを行う際に、 ``extcodesize`` オペコードを使用した追加のチェックを行っています。
    これにより、呼び出されようとしているコントラクトが実際に存在する（コードが含まれている）か、例外が発生するかを確認します。

    コントラクトインスタンスではなくアドレスを操作する低レベルコール（ ``.call()`` 、 ``.delegatecall()`` 、 ``.staticcall()`` 、 ``.send()`` 、 ``.transfer()`` など） には、このチェックが含まれて **いない** ため、ガス代が安く済みますが、安全性も低くなります。

.. note::

   バージョン0.5.0以前のSolidityでは、 ``this.balance`` などのコントラクトインスタンスからアドレスメンバーにアクセスできました。
   これは現在では禁止されており、アドレスへの明示的な変換を行う必要があります。 ``address(this).balance`` です。

.. .. note::

..    If state variables are accessed via a low-level delegatecall, the storage layout of the two contracts
..    must align in order for the called contract to correctly access the storage variables of the calling contract by name.
..    This is of course not the case if storage pointers are passed as function arguments as in the case for
..    the high-level libraries.

.. note::

    低レベルのdelegatecallで状態変数にアクセスする場合、呼び出されたコントラクトが呼び出し元のコントラクトのストレージ変数に名前で正しくアクセスするためには、2つのコントラクトのストレージレイアウトが一致していなければなりません。
    もちろん、高レベルライブラリの場合のように、ストレージポインタが関数の引数として渡される場合は、この限りではありません。

.. note::

    バージョン0.5.0以前では、 ``.call`` 、 ``.delegatecall`` 、 ``.staticcall`` は成功条件のみを返し、リターンデータを返しませんでした。

.. note::

    バージョン0.5.0以前では、 ``delegatecall`` と似ているが若干セマンティクスが異なる ``callcode`` というメンバーがありました。

.. index:: this, selfdestruct

コントラクト関連
----------------

``this`` （現在のコントラクト型）
    現在のコントラクトで、 :ref:`address` に明示的に変換可能なもの

.. ``selfdestruct(address payable recipient)``
..     Destroy the current contract, sending its funds to the given :ref:`address`
..     and end execution.
..     Note that ``selfdestruct`` has some peculiarities inherited from the EVM:

..     - the receiving contract's receive function is not executed.

..     - the contract is only really destroyed at the end of the transaction and ``revert`` s might "undo" the destruction.

``selfdestruct(address payable recipient)``
    現在のコントラクトを破棄し、その資金を所定の :ref:`address` に送り、実行を終了する。
    ``selfdestruct`` はEVMから引き継いだいくつかの特殊性を持っていることに注意してください。

    - 受信側コントラクトのレシーブ関数が実行されない。

    - コントラクトが実際に破壊されるのはトランザクション終了時であり、 ``revert`` はその破壊を「元に戻す」かもしれません。

さらに、現在のコントラクトのすべての関数は、現在の関数を含めて直接呼び出すことができます。

.. note::

    バージョン0.5.0以前では、 ``selfdestruct`` と同じセマンティクスを持つ ``suicide`` という関数がありました。

.. index:: type, creationCode, runtimeCode

.. _meta-type:

型情報
----------------

.. The expression ``type(X)`` can be used to retrieve information about the type
.. ``X``. Currently, there is limited support for this feature (``X`` can be either
.. a contract or an integer type) but it might be expanded in the future.

``type(X)`` という式を使って、 ``X`` という型に関する情報を取り出すことができます。
現在のところ、この機能のサポートは限られていますが（ ``X`` はコントラクト型か整数型のどちらかです）、将来的には拡張されるかもしれません。

コントラクト型 ``C`` には以下のプロパティがあります。

``type(C).name``
    コントラクトの名称です。

.. ``type(C).creationCode``
..     Memory byte array that contains the creation bytecode of the contract.
..     This can be used in inline assembly to build custom creation routines,
..     especially by using the ``create2`` opcode.
..     This property can **not** be accessed in the contract itself or any
..     derived contract. It causes the bytecode to be included in the bytecode
..     of the call site and thus circular references like that are not possible.

``type(C).creationCode``
    コントラクトの作成バイトコードを含むメモリバイト列。
    これはインラインアセンブリで使用でき、特に ``create2`` オペコードを使用してカスタム作成ルーチンを構築できます。
    このプロパティは、コントラクト自体または派生コントラクトでアクセスできま **せん**。
    これにより、バイトコードはコールサイトのバイトコードに含まれることになり、そのような循環参照はできません。

.. ``type(C).runtimeCode``
..     Memory byte array that contains the runtime bytecode of the contract.
..     This is the code that is usually deployed by the constructor of ``C``.
..     If ``C`` has a constructor that uses inline assembly, this might be
..     different from the actually deployed bytecode. Also note that libraries
..     modify their runtime bytecode at time of deployment to guard against
..     regular calls.
..     The same restrictions as with ``.creationCode`` also apply for this
..     property.

``type(C).runtimeCode``
    コントラクトのランタイムバイトコードを含むメモリバイト列。
    これは、通常、 ``C`` のコンストラクタによってデプロイされるコードです。
    ``C`` のコンストラクタがインラインアセンブリを使用している場合、これは実際にデプロイされるバイトコードとは異なる可能性があります。
    また、ライブラリはデプロイ時にランタイムのバイトコードを変更し、正規の呼び出しを防ぐことにも注意してください。
    このプロパティにも、 ``.creationCode`` と同様の制限が適用されます。

上記のプロパティに加えて、インターフェース型 ``I`` では以下のプロパティが利用可能です。

.. ``type(I).interfaceId``:
..     A ``bytes4`` value containing the `EIP-165 <https://eips.ethereum.org/EIPS/eip-165>`_
..     interface identifier of the given interface ``I``. This identifier is defined as the ``XOR`` of all
..     function selectors defined within the interface itself - excluding all inherited functions.

``type(I).interfaceId``:
    ``bytes4`` 値で、与えられたインターフェース ``I`` の `EIP-165 <https://eips.ethereum.org/EIPS/eip-165>`_ インターフェース識別子を含む。
    この識別子は、インターフェイス自身の中で定義されたすべての関数セレクタの ``XOR`` として定義され、すべての継承された関数は除外されます。

.. The following properties are available for an integer type ``T``:

整数型の ``T`` には以下のプロパティがあります。

``type(T).min``
    型 ``T`` で表現可能な最小の値です。

``type(T).max``
<<<<<<< HEAD
    型 ``T`` で表現可能な最大の値です。
=======
    The largest value representable by type ``T``.

Reserved Keywords
=================

These keywords are reserved in Solidity. They might become part of the syntax in the future:

``after``, ``alias``, ``apply``, ``auto``, ``byte``, ``case``, ``copyof``, ``default``,
``define``, ``final``, ``implements``, ``in``, ``inline``, ``let``, ``macro``, ``match``,
``mutable``, ``null``, ``of``, ``partial``, ``promise``, ``reference``, ``relocatable``,
``sealed``, ``sizeof``, ``static``, ``supports``, ``switch``, ``typedef``, ``typeof``,
``var``.
>>>>>>> 9f34322f394fc939fac0bf8b683fd61c45173674
