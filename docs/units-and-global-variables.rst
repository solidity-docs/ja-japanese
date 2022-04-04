**************************************
Units and Globally Available Variables
**************************************

.. index:: wei, finney, szabo, gwei, ether

Ether Units
===========

.. A literal number can take a suffix of ``wei``, ``gwei`` or ``ether`` to specify a subdenomination of Ether, where Ether numbers without a postfix are assumed to be Wei.

リテラル・ナンバーに ``wei`` 、 ``gwei`` 、 ``ether`` の接尾辞を付けて、Etherのサブデノミネーションを指定できますが、接尾辞のないEtherナンバーはWeiとみなされます。

.. code-block:: solidity
    :force:

    assert(1 wei == 1);
    assert(1 gwei == 1e9);
    assert(1 ether == 1e18);

.. The only effect of the subdenomination suffix is a multiplication by a power of ten.

subdenominationという接尾語の効果は、10の累乗だけです。

.. .. note::

..     The denominations ``finney`` and ``szabo`` have been removed in version 0.7.0.

.. note::

    バージョン0.7.0では、デノミネーションの ``finney`` と ``szabo`` が削除されました。

.. index:: time, seconds, minutes, hours, days, weeks, years

Time Units
==========

.. Suffixes like ``seconds``, ``minutes``, ``hours``, ``days`` and ``weeks``
.. after literal numbers can be used to specify units of time where seconds are the base
.. unit and units are considered naively in the following way:

リテラル数字の後に ``seconds`` 、 ``minutes`` 、 ``hours`` 、 ``days`` 、 ``weeks`` などのサフィックスをつけると、時間の単位を指定できます。ここでは、秒を基本単位とし、単位は次のように素朴に考えます。

.. * ``1 == 1 seconds``

* ``1 == 1 seconds``

.. * ``1 minutes == 60 seconds``

* ``1 minutes == 60 seconds``

.. * ``1 hours == 60 minutes``

* ``1 hours == 60 minutes``

.. * ``1 days == 24 hours``

* ``1 days == 24 hours``

.. * ``1 weeks == 7 days``

* ``1 weeks == 7 days``

.. Take care if you perform calendar calculations using these units, because
.. not every year equals 365 days and not even every day has 24 hours
.. because of `leap seconds <https://en.wikipedia.org/wiki/Leap_second>`_.
.. Due to the fact that leap seconds cannot be predicted, an exact calendar
.. library has to be updated by an external oracle.

これらの単位を使ってカレンダー計算を行う場合、 `leap seconds <https://en.wikipedia.org/wiki/Leap_second>`_ のために1年が365日ではなく、1日が24時間でもないので注意が必要です。うるう秒が予測できないため、正確なカレンダーライブラリは外部のオラクルで更新する必要があります。

.. .. note::

..     The suffix ``years`` has been removed in version 0.5.0 due to the reasons above.

.. note::

    上記の理由により、バージョン0.5.0では接尾語の ``years`` が削除されました。

.. These suffixes cannot be applied to variables. For example, if you want to
.. interpret a function parameter in days, you can in the following way:

これらの接尾辞は、変数には適用できません。例えば、関数のパラメータを日単位で解釈したい場合は、以下のようになります。

.. code-block:: solidity

    function f(uint start, uint daysAfter) public {
        if (block.timestamp >= start + daysAfter * 1 days) {
          // ...
        }
    }

.. _special-variables-functions:

Special Variables and Functions
===============================

.. There are special variables and functions which always exist in the global
.. namespace and are mainly used to provide information about the blockchain
.. or are general-use utility functions.

グローバルな名前空間に常に存在し、主にブロックチェーンに関する情報を提供するために使用されたり、汎用的なユーティリティー関数である特別な変数や関数があります。

.. index:: abi, block, coinbase, difficulty, encode, number, block;number, timestamp, block;timestamp, msg, data, gas, sender, value, gas price, origin

Block and Transaction Properties
--------------------------------

.. - ``blockhash(uint blockNumber) returns (bytes32)``: hash of the given block when ``blocknumber`` is one of the 256 most recent blocks; otherwise returns zero

-  ``blockhash(uint blockNumber) returns (bytes32)`` :  ``blocknumber`` が256個の最新ブロックの一つである場合は、与えられたブロックのハッシュ、そうでない場合はゼロを返す

.. - ``block.basefee`` (``uint``): current block's base fee (`EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ and `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_)

-  ``block.basefee`` (``uint``): 現在のブロックの基本料金（ `EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ と `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_)

.. - ``block.chainid`` (``uint``): current chain id

-  ``block.chainid`` (``uint``): 現在のチェーンID

.. - ``block.coinbase`` (``address payable``): current block miner's address

-  ``block.coinbase`` (``address payable``): 現在のブロックマイナーのアドレス

.. - ``block.difficulty`` (``uint``): current block difficulty

-  ``block.difficulty`` (``uint``): 現在のブロックの難易度

.. - ``block.gaslimit`` (``uint``): current block gaslimit

-  ``block.gaslimit`` (``uint``): カレントブロックのガスリミット

.. - ``block.number`` (``uint``): current block number

-  ``block.number`` (``uint``): 現在のブロック番号

.. - ``block.timestamp`` (``uint``): current block timestamp as seconds since unix epoch

-  ``block.timestamp``  ( ``uint`` ): 現在のブロックのタイムスタンプ(unixエポックからの秒数)

.. - ``gasleft() returns (uint256)``: remaining gas

-  ``gasleft() returns (uint256)`` : 残りのガス

.. - ``msg.data`` (``bytes calldata``): complete calldata

-  ``msg.data`` (``bytes calldata``): コンプリートカルデータ

.. - ``msg.sender`` (``address``): sender of the message (current call)

-  ``msg.sender`` (``address``): メッセージの送信者（現在のコール相手）

.. - ``msg.sig`` (``bytes4``): first four bytes of the calldata (i.e. function identifier)

-  ``msg.sig`` (``bytes4``): コールデータの最初の4バイト（＝関数識別子）

.. - ``msg.value`` (``uint``): number of wei sent with the message

-  ``msg.value`` (``uint``): メッセージと一緒に送られたweiの数

.. - ``tx.gasprice`` (``uint``): gas price of the transaction

-  ``tx.gasprice`` (``uint``): トランザクションのガス価格

.. - ``tx.origin`` (``address``): sender of the transaction (full call chain)

-  ``tx.origin`` (``address``): トランザクションの送信者（フルコールチェーン）

.. .. note::

..     The values of all members of ``msg``, including ``msg.sender`` and
..     ``msg.value`` can change for every **external** function call.
..     This includes calls to library functions.

.. note::

    ``msg.sender`` と ``msg.value`` を含む ``msg`` のすべてのメンバーの値は、 **external** 関数を呼び出すたびに変わる可能性があります。     これには、ライブラリ関数の呼び出しも含まれます。

.. .. note::

..     When contracts are evaluated off-chain rather than in context of a transaction included in a
..     block, you should not assume that ``block.*`` and ``tx.*`` refer to values from any specific
..     block or transaction. These values are provided by the EVM implementation that executes the
..     contract and can be arbitrary.

.. note::

    コントラクトが、ブロックに含まれるトランザクションのコンテキストではなく、オフチェーンで評価される場合、 ``block.*`` と ``tx.*`` が特定のブロックやトランザクションの値を参照していると仮定すべきではない。これらの値は、コントラクトを実行するEVM実装によって提供され、任意のものとなり得る。

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

    自分が何をしているか分かっていない限り、ランダム性の源として ``block.timestamp`` や ``blockhash`` に頼らないでください。

    タイムスタンプもブロックハッシュも、ある程度はマイナーの影響を受ける可能性があります。     マイニングコミュニティの悪質な行為者は、例えば、選択したハッシュでカジノのペイアウト関数を実行し、お金を受け取れなかった場合は別のハッシュで再試行できます。

    現在のブロックのタイムスタンプは、最後のブロックのタイムスタンプよりも厳密に大きくなければなりませんが、唯一の保証は、正規のチェーンで連続する2つのブロックのタイムスタンプの間のどこかになるということです。

.. .. note::

..     The block hashes are not available for all blocks for scalability reasons.
..     You can only access the hashes of the most recent 256 blocks, all other
..     values will be zero.

.. note::

    ブロックハッシュは、スケーラビリティの観点から、すべてのブロックで利用できるわけではありません。     アクセスできるのは最新の256ブロックのハッシュのみで、その他の値はすべてゼロになります。

.. .. note::

..     The function ``blockhash`` was previously known as ``block.blockhash``, which was deprecated in
..     version 0.4.22 and removed in version 0.5.0.

.. note::

    関数 ``blockhash`` は、以前は ``block.blockhash`` と呼ばれていましたが、バージョン0.4.22で非推奨となり、バージョン0.5.0で削除されました。

.. .. note::

..     The function ``gasleft`` was previously known as ``msg.gas``, which was deprecated in
..     version 0.4.21 and removed in version 0.5.0.

.. note::

    ``gasleft`` 関数は、以前は ``msg.gas`` と呼ばれていましたが、バージョン0.4.21で非推奨となり、バージョン0.5.0で削除されました。

.. .. note::

..     In version 0.7.0, the alias ``now`` (for ``block.timestamp``) was removed.

.. note::

    バージョン0.7.0では、 ``now`` (``block.timestamp``)というエイリアスを削除しました。

.. index:: abi, encoding, packed

ABI Encoding and Decoding Functions
-----------------------------------

.. - ``abi.decode(bytes memory encodedData, (...)) returns (...)``: ABI-decodes the given data, while the types are given in parentheses as second argument. Example: ``(uint a, uint[2] memory b, bytes memory c) = abi.decode(data, (uint, uint[2], bytes))``

-  ``abi.decode(bytes memory encodedData, (...)) returns (...)`` : ABIは与えられたデータをデコードしますが、タイプは第2引数として括弧内に与えられます。例 ``(uint a, uint[2] memory b, bytes memory c) = abi.decode(data, (uint, uint[2], bytes))``

.. - ``abi.encode(...) returns (bytes memory)``: ABI-encodes the given arguments

-  ``abi.encode(...) returns (bytes memory)`` : 与えられた引数をABIエンコードする

.. - ``abi.encodePacked(...) returns (bytes memory)``: Performs :ref:`packed encoding <abi_packed_mode>` of the given arguments. Note that packed encoding can be ambiguous!

-  ``abi.encodePacked(...) returns (bytes memory)`` : 与えられた引数の :ref:`packed encoding <abi_packed_mode>` を実行します。パックされたエンコーディングは曖昧になる可能性があることに注意してください。

.. - ``abi.encodeWithSelector(bytes4 selector, ...) returns (bytes memory)``: ABI-encodes the given arguments starting from the second and prepends the given four-byte selector

-  ``abi.encodeWithSelector(bytes4 selector, ...) returns (bytes memory)`` : 与えられた引数を2番目から順にABIエンコードし、与えられた4バイトのセレクタを前置する。

.. - ``abi.encodeWithSignature(string memory signature, ...) returns (bytes memory)``: Equivalent to ``abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), ...)``

-  ``abi.encodeWithSignature(string memory signature, ...) returns (bytes memory)`` :  ``abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), ...)`` に相当。

.. .. note::

..     These encoding functions can be used to craft data for external function calls without actually
..     calling an external function. Furthermore, ``keccak256(abi.encodePacked(a, b))`` is a way
..     to compute the hash of structured data (although be aware that it is possible to
..     craft a "hash collision" using different function parameter types).

.. note::

    これらのエンコーディング関数は、実際に外部関数を呼び出すことなく、外部関数呼び出しのためにデータを細工するために使用できます。さらに、 ``keccak256(abi.encodePacked(a, b))`` は構造化されたデータのハッシュを計算する方法でもあります（ただし、異なる関数パラメータタイプを使って「ハッシュの衝突」を工作することが可能なので注意が必要です）。

.. See the documentation about the :ref:`ABI <ABI>` and the
.. :ref:`tightly packed encoding <abi_packed_mode>` for details about the encoding.

エンコーディングの詳細については、 :ref:`ABI <ABI>` および :ref:`tightly packed encoding <abi_packed_mode>` に関するドキュメントを参照してください。

.. index:: bytes members

Members of bytes
----------------

.. - ``bytes.concat(...) returns (bytes memory)``: :ref:`Concatenates variable number of bytes and bytes1, ..., bytes32 arguments to one byte array<bytes-concat>`

-  ``bytes.concat(...) returns (bytes memory)`` :  :ref:`Concatenates variable number of bytes and bytes1, ..., bytes32 arguments to one byte array<bytes-concat>`

.. index:: assert, revert, require

Error Handling
--------------

.. See the dedicated section on :ref:`assert and require<assert-and-require>` for
.. more details on error handling and when to use which function.

エラー処理の詳細や、いつどの関数を使うかについては、 :ref:`assert and require<assert-and-require>` の専用セクションを参照してください。

.. ``assert(bool condition)``
..     causes a Panic error and thus state change reversion if the condition is not met - to be used for internal errors.

``assert(bool condition)`` はパニック・エラーを引き起こし、条件が満たされないと状態変化が戻る - 内部エラーに使用される。

.. ``require(bool condition)``
..     reverts if the condition is not met - to be used for errors in inputs or external components.

``require(bool condition)`` は、条件が満たされないと復帰します。入力や外部コンポーネントのエラーに使用されます。

.. ``require(bool condition, string memory message)``
..     reverts if the condition is not met - to be used for errors in inputs or external components. Also provides an error message.

``require(bool condition, string memory message)`` は、条件が満たされない場合に復帰します。入力や外部コンポーネントのエラーに使用します。また、エラーメッセージも表示されます。

.. ``revert()``
..     abort execution and revert state changes

``revert()`` の実行を中止し、状態変化を元に戻す

.. ``revert(string memory reason)``
..     abort execution and revert state changes, providing an explanatory string

``revert(string memory reason)`` の実行を中止し、状態の変化を元に戻すために、説明用の文字列を提供します。

.. index:: keccak256, ripemd160, sha256, ecrecover, addmod, mulmod, cryptography,

.. _mathematical-and-cryptographic-functions:

Mathematical and Cryptographic Functions
----------------------------------------

.. ``addmod(uint x, uint y, uint k) returns (uint)``
..     compute ``(x + y) % k`` where the addition is performed with arbitrary precision and does not wrap around at ``2**256``. Assert that ``k != 0`` starting from version 0.5.0.

``addmod(uint x, uint y, uint k) returns (uint)`` は、任意の精度で加算が行われ、 ``2**256`` で折り返されない ``(x + y) % k`` を計算します。 ``k != 0`` のバージョンが0.5.0からであることを主張する。

.. ``mulmod(uint x, uint y, uint k) returns (uint)``
..     compute ``(x * y) % k`` where the multiplication is performed with arbitrary precision and does not wrap around at ``2**256``. Assert that ``k != 0`` starting from version 0.5.0.

``mulmod(uint x, uint y, uint k) returns (uint)`` は、乗算が任意の精度で実行され、 ``2**256`` で折り返されない ``(x * y) % k`` を計算します。 ``k != 0`` がバージョン0.5.0から始まったことを主張する。

.. ``keccak256(bytes memory) returns (bytes32)``
..     compute the Keccak-256 hash of the input

``keccak256(bytes memory) returns (bytes32)`` は、入力のKeccak-256ハッシュを計算します。

.. .. note::

..     There used to be an alias for ``keccak256`` called ``sha3``, which was removed in version 0.5.0.

.. note::

    以前は ``sha3`` という ``keccak256`` のエイリアスがありましたが、バージョン0.5.0で削除されました。

.. ``sha256(bytes memory) returns (bytes32)``
..     compute the SHA-256 hash of the input

``sha256(bytes memory) returns (bytes32)`` は、入力のSHA-256ハッシュを計算します。

.. ``ripemd160(bytes memory) returns (bytes20)``
..     compute RIPEMD-160 hash of the input

``ripemd160(bytes memory) returns (bytes20)`` は入力のRIPEMD-160ハッシュを計算します。

.. ``ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)``
..     recover the address associated with the public key from elliptic curve signature or return zero on error.
..     The function parameters correspond to ECDSA values of the signature:

..     * ``r`` = first 32 bytes of signature

..     * ``s`` = second 32 bytes of signature

..     * ``v`` = final 1 byte of signature

..     ``ecrecover`` returns an ``address``, and not an ``address payable``. See :ref:`address payable<address>` for
..     conversion, in case you need to transfer funds to the recovered address.

..     For further details, read `example usage <https://ethereum.stackexchange.com/questions/1777/workflow-on-signing-a-string-with-private-key-followed-by-signature-verificatio>`_.

``ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)`` は楕円曲線署名から公開鍵に関連するアドレスを復元するか、エラーで0を返します。     この関数のパラメータは、署名のECDSA値に対応しています。

    *  ``r``  = 署名の最初の32バイト

    *  ``s``  = 署名の2番目の32バイト

    *  ``v``  = 署名の最後の1バイト

    ``ecrecover`` は ``address`` を返し、 ``address payable`` を返しません。復旧したアドレスに送金する必要がある場合は、 :ref:`address payable<address>` を参照して変換してください。

    詳しくは `example usage <https://ethereum.stackexchange.com/questions/1777/workflow-on-signing-a-string-with-private-key-followed-by-signature-verificatio>`_ をご覧ください。

.. .. warning::

..     If you use ``ecrecover``, be aware that a valid signature can be turned into a different valid signature without
..     requiring knowledge of the corresponding private key. In the Homestead hard fork, this issue was fixed
..     for _transaction_ signatures (see `EIP-2 <https://eips.ethereum.org/EIPS/eip-2#specification>`_), but
..     the ecrecover function remained unchanged.

..     This is usually not a problem unless you require signatures to be unique or
..     use them to identify items. OpenZeppelin have a `ECDSA helper library <https://docs.openzeppelin.com/contracts/2.x/api/cryptography#ECDSA>`_ that you can use as a wrapper for ``ecrecover`` without this issue.

.. warning::

    ``ecrecover`` を使用している場合、対応する秘密鍵を知らなくても、有効な署名を別の有効な署名に変えることができることに注意してください。Homesteadのハードフォークでは、この問題は _transaction_ signaturesで修正されましたが（ `EIP-2 <https://eips.ethereum.org/EIPS/eip-2#specification>`_ 参照）、ecrecover関数は変更されませんでした。

    これは、署名を一意にする必要がある場合や、アイテムを識別するために使用する場合を除き、通常は問題になりません。OpenZeppelinには、この問題なしに ``ecrecover`` のラッパーとして使用できる `ECDSA helper library <https://docs.openzeppelin.com/contracts/2.x/api/cryptography#ECDSA>`_ があります。

.. .. note::

..     When running ``sha256``, ``ripemd160`` or ``ecrecover`` on a *private blockchain*, you might encounter Out-of-Gas. This is because these functions are implemented as "precompiled contracts" and only really exist after they receive the first message (although their contract code is hardcoded). Messages to non-existing contracts are more expensive and thus the execution might run into an Out-of-Gas error. A workaround for this problem is to first send Wei (1 for example) to each of the contracts before you use them in your actual contracts. This is not an issue on the main or test net.

.. note::

    ``sha256`` 、 ``ripemd160`` 、 ``ecrecover`` を*プライベートブロックチェーン*で実行すると、Out-of-Gasに遭遇することがあります。これは、これらの関数が「プリコンパイル済みコントラクト」として実装されており、最初のメッセージを受信して初めて実際に存在するからです（ただし、コントラクトコードはハードコードされています）。存在しないコントラクトへのメッセージはより高価であるため、実行時にOut-of-Gasエラーが発生する可能性があります。この問題を回避するには、実際のコントラクトで使用する前に、まず各コントラクトにWei（例: 1）を送信することです。これは、メインネットやテストネットでは問題になりません。

.. index:: balance, codehash, send, transfer, call, callcode, delegatecall, staticcall

.. _address_related:

Members of Address Types
------------------------

.. ``<address>.balance`` (``uint256``)
..     balance of the :ref:`address` in Wei

``<address>.balance`` (``uint256``) 魏の :ref:`address` のバランス

.. ``<address>.code`` (``bytes memory``)
..     code at the :ref:`address` (can be empty)

:ref:`address` の ``<address>.code`` (``bytes memory``)コード（空でも可）

.. ``<address>.codehash`` (``bytes32``)
..     the codehash of the :ref:`address`

``<address>.codehash`` (``bytes32``) :ref:`address` のコードハッシュ

.. ``<address payable>.transfer(uint256 amount)``
..     send given amount of Wei to :ref:`address`, reverts on failure, forwards 2300 gas stipend, not adjustable

``<address payable>.transfer(uint256 amount)`` は指定された量のWeiを :ref:`address` に送る、失敗すると元に戻る、フォワードは2300ガスの俸給、調整不可

.. ``<address payable>.send(uint256 amount) returns (bool)``
..     send given amount of Wei to :ref:`address`, returns ``false`` on failure, forwards 2300 gas stipend, not adjustable

``<address payable>.send(uint256 amount) returns (bool)`` は指定された量のWeiを :ref:`address` に送り、失敗すると ``false`` を返し、2300のgas stipendを送り、調整できない。

.. ``<address>.call(bytes memory) returns (bool, bytes memory)``
..     issue low-level ``CALL`` with the given payload, returns success condition and return data, forwards all available gas, adjustable

``<address>.call(bytes memory) returns (bool, bytes memory)`` は与えられたペイロードで低レベルの ``CALL`` を発行し、成功条件とリターンデータを返し、利用可能なすべてのガスを送金し、調整可能な

.. ``<address>.delegatecall(bytes memory) returns (bool, bytes memory)``
..     issue low-level ``DELEGATECALL`` with the given payload, returns success condition and return data, forwards all available gas, adjustable

``<address>.delegatecall(bytes memory) returns (bool, bytes memory)`` は与えられたペイロードで低レベルの ``DELEGATECALL`` を発行し、成功条件とリターンデータを返し、利用可能なすべてのガスを送金し、調整可能な

.. ``<address>.staticcall(bytes memory) returns (bool, bytes memory)``
..     issue low-level ``STATICCALL`` with the given payload, returns success condition and return data, forwards all available gas, adjustable

``<address>.staticcall(bytes memory) returns (bool, bytes memory)`` は、与えられたペイロードで低レベルの ``STATICCALL`` を発行し、成功条件とリターンデータを返し、利用可能なすべてのガスを送金し、調整可能です。

.. For more information, see the section on :ref:`address`.

詳しくは、「 :ref:`address` 」の項をご覧ください。

.. .. warning::

..     You should avoid using ``.call()`` whenever possible when executing another contract function as it bypasses type checking,
..     function existence check, and argument packing.

.. warning::

    ``.call()`` は、型チェック、関数の存在チェック、引数のパッキングをバイパスするので、他のコントラクト関数を実行する際には、可能な限り使用を避けるべきです。

.. .. warning::

..     There are some dangers in using ``send``: The transfer fails if the call stack depth is at 1024
..     (this can always be forced by the caller) and it also fails if the recipient runs out of gas. So in order
..     to make safe Ether transfers, always check the return value of ``send``, use ``transfer`` or even better:
..     Use a pattern where the recipient withdraws the money.

.. warning::

    ``send`` の使用にはいくつかの危険があります。コールスタックの深さが1024の場合、送金は失敗し（これは常に呼び出し側で強制できます）、受信者がガス欠になった場合も失敗します。そのため、安全なEther送金を行うためには、 ``send`` の戻り値を常にチェックし、 ``transfer`` を使用するか、あるいはそれ以上の方法をとる必要があります。     受信者がお金を引き出すパターンを使いましょう。

.. .. warning::

..     Due to the fact that the EVM considers a call to a non-existing contract to always succeed,
..     Solidity includes an extra check using the ``extcodesize`` opcode when performing external calls.
..     This ensures that the contract that is about to be called either actually exists (it contains code)
..     or an exception is raised.

..     The low-level calls which operate on addresses rather than contract instances (i.e. ``.call()``,
..     ``.delegatecall()``, ``.staticcall()``, ``.send()`` and ``.transfer()``) **do not** include this
..     check, which makes them cheaper in terms of gas but also less safe.

.. warning::

    EVMでは、存在しないコントラクトへの呼び出しは常に成功すると考えられているため、Solidityでは外部呼び出しを行う際に、 ``extcodesize``  opcodeを使用した追加のチェックを行っています。     これにより、呼び出されようとしているコントラクトが実際に存在する（コードが含まれている）か、例外が発生するかを確認します。

    コントラクトインスタンスではなくアドレスを操作する低レベルコール（ ``.call()`` 、 ``.delegatecall()`` 、 ``.staticcall()`` 、 ``.send()`` 、 ``.transfer()`` など） **do not** には、このチェックが含まれているため、ガス代が安く済みますが、安全性も低くなります。

.. .. note::

..    Prior to version 0.5.0, Solidity allowed address members to be accessed by a contract instance, for example ``this.balance``.
..    This is now forbidden and an explicit conversion to address must be done: ``address(this).balance``.

.. note::

   バージョン0.5.0以前のSolidityでは、 ``this.balance`` などのコントラクトインスタンスからアドレスメンバーにアクセスできました。    これは現在では禁止されており、アドレスへの明示的な変換を行う必要があります。 ``address(this).balance`` です。

.. .. note::

..    If state variables are accessed via a low-level delegatecall, the storage layout of the two contracts
..    must align in order for the called contract to correctly access the storage variables of the calling contract by name.
..    This is of course not the case if storage pointers are passed as function arguments as in the case for
..    the high-level libraries.

.. note::

   低レベルのデリゲートコールで状態変数にアクセスする場合、呼び出されたコントラクトが呼び出し元のコントラクトのストレージ変数に名前で正しくアクセスするためには、2つのコントラクトのストレージレイアウトが一致していなければなりません。    もちろん、高レベルライブラリの場合のように、ストレージポインタが関数の引数として渡される場合は、この限りではありません。

.. .. note::

..     Prior to version 0.5.0, ``.call``, ``.delegatecall`` and ``.staticcall`` only returned the
..     success condition and not the return data.

.. note::

    バージョン0.5.0以前では、 ``.call`` 、 ``.delegatecall`` 、 ``.staticcall`` は成功条件のみを返し、リターンデータを返しませんでした。

.. .. note::

..     Prior to version 0.5.0, there was a member called ``callcode`` with similar but slightly different
..     semantics than ``delegatecall``.

.. note::

    バージョン0.5.0以前では、 ``delegatecall`` と似ているが若干意味合いが異なる ``callcode`` というメンバーがいました。

.. index:: this, selfdestruct

Contract Related
----------------

.. ``this`` (current contract's type)
..     the current contract, explicitly convertible to :ref:`address`

``this`` （現在のコントラクトのタイプ）現在のコントラクトで、 :ref:`address` に明示的に変換可能なもの

.. ``selfdestruct(address payable recipient)``
..     Destroy the current contract, sending its funds to the given :ref:`address`
..     and end execution.
..     Note that ``selfdestruct`` has some peculiarities inherited from the EVM:

..     - the receiving contract's receive function is not executed.

..     - the contract is only really destroyed at the end of the transaction and ``revert`` s might "undo" the destruction.

``selfdestruct(address payable recipient)`` は現在のコントラクトを破棄し、その資金を所定の :ref:`address` に送り、実行を終了する。      ``selfdestruct`` はEVMから引き継いだいくつかの特殊性を持っていることに注意してください。

    - 受信側コントラクトの受信関数が実行されない。

    - コントラクトが実際に破壊されるのはトランザクション終了時であり、 ``revert``  sはその破壊を「元に戻す」かもしれません。

.. Furthermore, all functions of the current contract are callable directly including the current function.

さらに、現在のコントラクトのすべての関数は、現在の関数を含めて直接呼び出すことができます。

.. .. note::

..     Prior to version 0.5.0, there was a function called ``suicide`` with the same
..     semantics as ``selfdestruct``.

.. note::

    バージョン0.5.0以前では、 ``selfdestruct`` と同じセマンティクスを持つ ``suicide`` という関数がありました。

.. index:: type, creationCode, runtimeCode

.. _meta-type:

Type Information
----------------

.. The expression ``type(X)`` can be used to retrieve information about the type
.. ``X``. Currently, there is limited support for this feature (``X`` can be either
.. a contract or an integer type) but it might be expanded in the future.

``type(X)`` という式を使って、 ``X`` という型に関する情報を取り出すことができます。現在のところ、この機能のサポートは限られていますが（ ``X`` はcontract型かinteger型のどちらかです）、将来的には拡張されるかもしれません。

.. The following properties are available for a contract type ``C``:

コントラクトタイプ ``C`` には以下のプロパティがあります。

.. ``type(C).name``
..     The name of the contract.

``type(C).name``  コントラクトの名称です。

.. ``type(C).creationCode``
..     Memory byte array that contains the creation bytecode of the contract.
..     This can be used in inline assembly to build custom creation routines,
..     especially by using the ``create2`` opcode.
..     This property can **not** be accessed in the contract itself or any
..     derived contract. It causes the bytecode to be included in the bytecode
..     of the call site and thus circular references like that are not possible.

``type(C).creationCode``  コントラクトの作成バイトコードを含むメモリバイト配列。     これはインラインアセンブリで使用でき、特に ``create2``  opcodeを使用してカスタム作成ルーチンを構築できます。     このプロパティは、コントラクト自体または派生コントラクトで **not** アクセスできます。これにより、バイトコードはコールサイトのバイトコードに含まれることになり、そのような循環参照はできません。

.. ``type(C).runtimeCode``
..     Memory byte array that contains the runtime bytecode of the contract.
..     This is the code that is usually deployed by the constructor of ``C``.
..     If ``C`` has a constructor that uses inline assembly, this might be
..     different from the actually deployed bytecode. Also note that libraries
..     modify their runtime bytecode at time of deployment to guard against
..     regular calls.
..     The same restrictions as with ``.creationCode`` also apply for this
..     property.

``type(C).runtimeCode``  コントラクトのランタイムバイトコードを含むメモリバイト配列。     これは、通常、 ``C`` のコンストラクタによってデプロイされるコードです。      ``C``  のコンストラクタがインライン アセンブリを使用している場合、これは実際にデプロイされるバイトコードとは異なる可能性があります。また、ライブラリはデプロイ時にランタイムのバイトコードを変更し、正規の呼び出しを防ぐことにも注意してください。     このプロパティにも、 ``.creationCode``  と同様の制限が適用されます。

.. In addition to the properties above, the following properties are available
.. for an interface type ``I``:

上記のプロパティに加えて、インターフェースタイプ ``I`` では以下のプロパティが利用可能です。

.. ``type(I).interfaceId``:
..     A ``bytes4`` value containing the `EIP-165 <https://eips.ethereum.org/EIPS/eip-165>`_
..     interface identifier of the given interface ``I``. This identifier is defined as the ``XOR`` of all
..     function selectors defined within the interface itself - excluding all inherited functions.

``type(I).interfaceId`` :  ``bytes4`` 値で、与えられたインターフェース ``I`` の `EIP-165 <https://eips.ethereum.org/EIPS/eip-165>`_ インターフェース識別子を含む。この識別子は、インターフェイス自身の中で定義されたすべての関数セレクタの ``XOR`` として定義され、すべての継承された関数は除外されます。

.. The following properties are available for an integer type ``T``:

整数型の ``T`` には以下のプロパティがあります。

.. ``type(T).min``
..     The smallest value representable by type ``T``.

``type(T).min``  タイプ ``T`` で表現可能な最小の値です。

.. ``type(T).max``
..     The largest value representable by type ``T``.
.. 

``type(T).max``  タイプ ``T`` で表現可能な最大の値。
