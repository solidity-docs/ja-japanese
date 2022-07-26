**************
チートシート
**************

.. index:: operator; precedence

演算子の優先順位
================================
<<<<<<< HEAD

演算子の優先順位を評価順に並べると以下のようになります。

+------------+-------------------------------------+--------------------------------------------+
| 優先順位   | 説明                                | 演算子                                     |
+============+=====================================+============================================+
| *1*        | 後置インクリメントとデクリメント    | ``++``, ``--``                             |
+            +-------------------------------------+--------------------------------------------+
|            | New式                               | ``new <typename>``                         |
+            +-------------------------------------+--------------------------------------------+
|            | 配列添字アクセス                    | ``<array>[<index>]``                       |
+            +-------------------------------------+--------------------------------------------+
|            | メンバアクセス                      | ``<object>.<member>``                      |
+            +-------------------------------------+--------------------------------------------+
|            | 関数的呼び出し                      | ``<func>(<args...>)``                      |
+            +-------------------------------------+--------------------------------------------+
|            | 括弧                                | ``(<statement>)``                          |
+------------+-------------------------------------+--------------------------------------------+
| *2*        | 前置インクリメントとデクリメント    | ``++``, ``--``                             |
+            +-------------------------------------+--------------------------------------------+
|            | 単項マイナス                        | ``-``                                      |
+            +-------------------------------------+--------------------------------------------+
|            | 単項演算子                          | ``delete``                                 |
+            +-------------------------------------+--------------------------------------------+
|            | 論理否定                            | ``!``                                      |
+            +-------------------------------------+--------------------------------------------+
|            | ビット単位の否定                    | ``~``                                      |
+------------+-------------------------------------+--------------------------------------------+
| *3*        | 累乗                                | ``**``                                     |
+------------+-------------------------------------+--------------------------------------------+
| *4*        | 乗算、除算、剰余                    | ``*``, ``/``, ``%``                        |
+------------+-------------------------------------+--------------------------------------------+
| *5*        | 加算、減算                          | ``+``, ``-``                               |
+------------+-------------------------------------+--------------------------------------------+
| *6*        | ビット単位のシフト演算              | ``<<``, ``>>``                             |
+------------+-------------------------------------+--------------------------------------------+
| *7*        | ビット単位のAND                     | ``&``                                      |
+------------+-------------------------------------+--------------------------------------------+
| *8*        | ビット単位のXOR                     | ``^``                                      |
+------------+-------------------------------------+--------------------------------------------+
| *9*        | ビット単位のOR                      | ``|``                                      |
+------------+-------------------------------------+--------------------------------------------+
| *10*       | 不等号演算子                        | ``<``, ``>``, ``<=``, ``>=``               |
+------------+-------------------------------------+--------------------------------------------+
| *11*       | 等号演算子                          | ``==``, ``!=``                             |
+------------+-------------------------------------+--------------------------------------------+
| *12*       | 論理AND                             | ``&&``                                     |
+------------+-------------------------------------+--------------------------------------------+
| *13*       | 論理OR                              | ``||``                                     |
+------------+-------------------------------------+--------------------------------------------+
| *14*       | 三項演算子                          | ``<conditional> ? <if-true> : <if-false>`` |
+            +-------------------------------------+--------------------------------------------+
|            | 代入演算子                          | ``=``, ``|=``, ``^=``, ``&=``, ``<<=``,    |
|            |                                     | ``>>=``, ``+=``, ``-=``, ``*=``, ``/=``,   |
|            |                                     | ``%=``                                     |
+------------+-------------------------------------+--------------------------------------------+
| *15*       | カンマ演算子                        | ``,``                                      |
+------------+-------------------------------------+--------------------------------------------+
=======
.. include:: types/operator-precedence-table.rst
>>>>>>> 9f34322f394fc939fac0bf8b683fd61c45173674

.. index:: assert, block, coinbase, difficulty, number, block;number, timestamp, block;timestamp, msg, data, gas, sender, value, gas price, origin, revert, require, keccak256, ripemd160, sha256, ecrecover, addmod, mulmod, cryptography, this, super, selfdestruct, balance, codehash, send

グローバル変数
================

<<<<<<< HEAD
- ``abi.decode(bytes memory encodedData, (...)) returns (...)``: 
  与えたデータを :ref:`ABI <ABI>` デコードします。型は第2引数として括弧内に与えられます。
  例 ``(uint a, uint[2] memory b, bytes memory c) = abi.decode(data, (uint, uint[2], bytes))``

- ``abi.encode(...) returns (bytes memory)``:
  与えた引数を :ref:`ABI <ABI>` エンコードします。

- ``abi.encodePacked(...) returns (bytes memory)``:
  与えた引数の :ref:`packed encoding <abi_packed_mode>` を実行します。
  このエンコーディングは曖昧になる可能性があることに注意してください！

- ``abi.encodeWithSelector(bytes4 selector, ...) returns (bytes memory)``: 
  与えた引数を2番目から順に :ref:`ABI <ABI>` エンコードし、与えた4バイトのセレクタを前に付加します。

- ``abi.encodeWithSignature(string memory signature, ...) returns (bytes memory)``:
  ``abi.encodeWithSelector(bytes4(keccak256(bytes(signature)), ...)`` と同等です。

- ``bytes.concat(...) returns (bytes memory)``: 
  :ref:`可変個の引数を1つのバイト配列に連結する。<bytes-concat>`

- ``block.basefee`` (``uint``): カレントブロックのベースフィー（base fee）（ `EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ と `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_)

- ``block.chainid`` (``uint``): カレントブロックのチェーンID

- ``block.coinbase`` (``address payable``): カレントブロックのマイナーのアドレス

- ``block.difficulty`` (``uint``): カレントブロックの難易度

- ``block.gaslimit`` (``uint``): カレントブロックのガスリミット

- ``block.number`` (``uint``): カレントブロックの番号

- ``block.timestamp`` ( ``uint`` ): カレントブロックのタイムスタンプ

- ``gasleft() returns (uint256)``: 残りのガス

- ``msg.data`` (``bytes``): 完全なコールデータ

- ``msg.sender`` (``address``): メッセージの送信者（現在のコール）

- ``msg.sig`` (``bytes4``): コールデータの最初の4バイト（すなわち関数識別子）

- ``msg.value`` (``uint``): メッセージと一緒に送られたweiの数

- ``tx.gasprice`` (``uint``): トランザクションのガスプライス

- ``tx.origin`` (``address``): トランザクションの送信者（フルコールチェーン）

- ``assert(bool condition)``: 条件が ``false`` の場合、実行を中止し、状態変化を戻す（内部エラーに使用）

- ``require(bool condition)``: 条件が ``false`` の場合、実行を中止し、状態の変化を元に戻す（不正な入力や外部コンポーネントのエラーに使用する）

- ``require(bool condition, string memory message)``: 条件が ``false`` の場合、実行を中止し、状態の変化を戻す（不正な入力や外部コンポーネントのエラーに使用）。また、エラーメッセージを表示します。

- ``revert()``: 実行を中止し、状態の変化を戻す

- ``revert(string memory message)``: 実行を中止し、説明文字列を提供して状態変化を元に戻す

- ``blockhash(uint blockNumber) returns (bytes32)``: 与えられたブロックのハッシュ - 最新の256ブロックに対してのみ動作

- ``keccak256(bytes memory) returns (bytes32)``: 入力のKeccak-256ハッシュを計算する

- ``sha256(bytes memory) returns (bytes32)``: 入力のSHA-256ハッシュを計算する

- ``ripemd160(bytes memory) returns (bytes20)``: 入力のRIPEMD-160ハッシュを計算する。

- ``ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)``: 楕円曲線署名から公開鍵に関連したアドレスを回復する、エラー時は0を返す

- ``addmod(uint x, uint y, uint k) returns (uint)``: 任意の精度で加算が実行され、 ``2**256`` で切り捨てられない ``(x + y) % k`` を計算します。バージョン0.5.0から ``k != 0`` であることをアサートします。

- ``mulmod(uint x, uint y, uint k) returns (uint)``: 任意の精度で乗算が実行され、 ``2**256`` で切り捨てられない ``(x * y) % k`` を計算します。バージョン0.5.0から ``k != 0`` であることをアサートします。

- ``this`` （現在のコントラクトの型）: 現在のコントラクトで、 ``address`` または ``address payable`` に明示的に変換できるもの

- ``super``: 継承階層の1つ上の階層のコントラクト

- ``selfdestruct(address payable recipient)``: 現在のコントラクトを破棄し、その資金を指定されたアドレスに送る

- ``<address>.balance`` (``uint256``): :ref:`address` のWei残高

- ``<address>.code`` (``bytes memory``):  :ref:`address` のコード（空でも良い）

- ``<address>.codehash`` (``bytes32``):  :ref:`address` のコードハッシュ

- ``<address payable>.send(uint256 amount) returns (bool)``: 
  指定された量のWeiを :ref:`address` に送り、失敗すると ``false`` を返す。

- ``<address payable>.transfer(uint256 amount)``:
  指定された量のWeiを :ref:`address` に送り、失敗したら例外を投げる

- ``type(C).name`` (``string``): コントラクトの名前

- ``type(C).creationCode`` ( ``bytes memory`` ):
  与えられたコントラクトの作成バイトコード、 :ref:`型情報<meta-type>` を参照。

- ``type(C).runtimeCode`` ( ``bytes memory`` ):
  与えられたコントラクトのランタイムのバイトコード、 :ref:`型情報<meta-type>` を参照。

- ``type(I).interfaceId`` (``bytes4``):
  指定されたインターフェースのEIP-165インターフェース識別子を含む値、 :ref:`型情報<meta-type>` を参照。

- ``type(T).min`` (``T``):
  整数型 ``T`` で表現可能な最小値、 :ref:`型情報<meta-type>` を参照。

- ``type(T).max`` (``T``): 
  整数型 ``T`` で表現可能な最大値、 :ref:`型情報<meta-type>` を参照。

.. .. note::

..     When contracts are evaluated off-chain rather than in context of a transaction included in a
..     block, you should not assume that ``block.*`` and ``tx.*`` refer to values from any specific
..     block or transaction. These values are provided by the EVM implementation that executes the
..     contract and can be arbitrary.

.. note::

    コントラクトが、ブロックに含まれるトランザクションのコンテキストではなく、オフチェーンで評価される場合、 ``block.*`` と ``tx.*`` が特定のブロックやトランザクションの値を参照していると仮定してはなりません。これらの値は、コントラクトを実行するEVMの実装によって提供され、任意のものとなりえます。

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

    自分が何をしているか分かっていない限り、ランダム性の源として ``block.timestamp`` や ``blockhash`` に頼ってはいけません。

    タイムスタンプもブロックハッシュも、ある程度はマイナーの影響を受ける可能性があります。     マイニングコミュニティの悪質な行為者は、例えば、選択したハッシュでカジノのペイアウト関数を実行し、お金を受け取れなかった場合は別のハッシュで再試行できます。

    現在のブロックのタイムスタンプは、最後のブロックのタイムスタンプよりも厳密に大きくなければなりませんが、唯一の保証は、正規のチェーンで連続する2つのブロックのタイムスタンプの間のどこかになるということです。

.. .. note::

..     The block hashes are not available for all blocks for scalability reasons.
..     You can only access the hashes of the most recent 256 blocks, all other
..     values will be zero.

.. note::

    ブロックハッシュは、スケーラビリティの観点から、すべてのブロックで利用できるわけではありません。     アクセスできるのは最新の256ブロックのハッシュのみで、その他の値はすべてゼロになります。

.. note::

    バージョン0.5.0では、以下のエイリアスが削除されました: ``suicide`` (``selfdestruct`` のエイリアス)、 ``msg.gas`` (``gasleft`` のエイリアス)、 ``block.blockhash`` ( ``blockhash`` のエイリアス)、 ``sha3`` (``keccak256`` のエイリアス)。
    
.. note::

    バージョン0.7.0では、 エイリアス ``now`` （ ``block.timestamp`` に対するもの ）を削除しました。
=======
- ``abi.decode(bytes memory encodedData, (...)) returns (...)``: :ref:`ABI <ABI>`-decodes
  the provided data. The types are given in parentheses as second argument.
  Example: ``(uint a, uint[2] memory b, bytes memory c) = abi.decode(data, (uint, uint[2], bytes))``
- ``abi.encode(...) returns (bytes memory)``: :ref:`ABI <ABI>`-encodes the given arguments
- ``abi.encodePacked(...) returns (bytes memory)``: Performs :ref:`packed encoding <abi_packed_mode>` of
  the given arguments. Note that this encoding can be ambiguous!
- ``abi.encodeWithSelector(bytes4 selector, ...) returns (bytes memory)``: :ref:`ABI <ABI>`-encodes
  the given arguments starting from the second and prepends the given four-byte selector
- ``abi.encodeCall(function functionPointer, (...)) returns (bytes memory)``: ABI-encodes a call to ``functionPointer`` with the arguments found in the
  tuple. Performs a full type-check, ensuring the types match the function signature. Result equals ``abi.encodeWithSelector(functionPointer.selector, (...))``
- ``abi.encodeWithSignature(string memory signature, ...) returns (bytes memory)``: Equivalent
  to ``abi.encodeWithSelector(bytes4(keccak256(bytes(signature)), ...)``
- ``bytes.concat(...) returns (bytes memory)``: :ref:`Concatenates variable number of
  arguments to one byte array<bytes-concat>`
- ``string.concat(...) returns (string memory)``: :ref:`Concatenates variable number of
  arguments to one string array<string-concat>`
- ``block.basefee`` (``uint``): current block's base fee (`EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ and `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_)
- ``block.chainid`` (``uint``): current chain id
- ``block.coinbase`` (``address payable``): current block miner's address
- ``block.difficulty`` (``uint``): current block difficulty
- ``block.gaslimit`` (``uint``): current block gaslimit
- ``block.number`` (``uint``): current block number
- ``block.timestamp`` (``uint``): current block timestamp in seconds since Unix epoch
- ``gasleft() returns (uint256)``: remaining gas
- ``msg.data`` (``bytes``): complete calldata
- ``msg.sender`` (``address``): sender of the message (current call)
- ``msg.sig`` (``bytes4``): first four bytes of the calldata (i.e. function identifier)
- ``msg.value`` (``uint``): number of wei sent with the message
- ``tx.gasprice`` (``uint``): gas price of the transaction
- ``tx.origin`` (``address``): sender of the transaction (full call chain)
- ``assert(bool condition)``: abort execution and revert state changes if condition is ``false`` (use for internal error)
- ``require(bool condition)``: abort execution and revert state changes if condition is ``false`` (use
  for malformed input or error in external component)
- ``require(bool condition, string memory message)``: abort execution and revert state changes if
  condition is ``false`` (use for malformed input or error in external component). Also provide error message.
- ``revert()``: abort execution and revert state changes
- ``revert(string memory message)``: abort execution and revert state changes providing an explanatory string
- ``blockhash(uint blockNumber) returns (bytes32)``: hash of the given block - only works for 256 most recent blocks
- ``keccak256(bytes memory) returns (bytes32)``: compute the Keccak-256 hash of the input
- ``sha256(bytes memory) returns (bytes32)``: compute the SHA-256 hash of the input
- ``ripemd160(bytes memory) returns (bytes20)``: compute the RIPEMD-160 hash of the input
- ``ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)``: recover address associated with
  the public key from elliptic curve signature, return zero on error
- ``addmod(uint x, uint y, uint k) returns (uint)``: compute ``(x + y) % k`` where the addition is performed with
  arbitrary precision and does not wrap around at ``2**256``. Assert that ``k != 0`` starting from version 0.5.0.
- ``mulmod(uint x, uint y, uint k) returns (uint)``: compute ``(x * y) % k`` where the multiplication is performed
  with arbitrary precision and does not wrap around at ``2**256``. Assert that ``k != 0`` starting from version 0.5.0.
- ``this`` (current contract's type): the current contract, explicitly convertible to ``address`` or ``address payable``
- ``super``: the contract one level higher in the inheritance hierarchy
- ``selfdestruct(address payable recipient)``: destroy the current contract, sending its funds to the given address
- ``<address>.balance`` (``uint256``): balance of the :ref:`address` in Wei
- ``<address>.code`` (``bytes memory``): code at the :ref:`address` (can be empty)
- ``<address>.codehash`` (``bytes32``): the codehash of the :ref:`address`
- ``<address payable>.send(uint256 amount) returns (bool)``: send given amount of Wei to :ref:`address`,
  returns ``false`` on failure
- ``<address payable>.transfer(uint256 amount)``: send given amount of Wei to :ref:`address`, throws on failure
- ``type(C).name`` (``string``): the name of the contract
- ``type(C).creationCode`` (``bytes memory``): creation bytecode of the given contract, see :ref:`Type Information<meta-type>`.
- ``type(C).runtimeCode`` (``bytes memory``): runtime bytecode of the given contract, see :ref:`Type Information<meta-type>`.
- ``type(I).interfaceId`` (``bytes4``): value containing the EIP-165 interface identifier of the given interface, see :ref:`Type Information<meta-type>`.
- ``type(T).min`` (``T``): the minimum value representable by the integer type ``T``, see :ref:`Type Information<meta-type>`.
- ``type(T).max`` (``T``): the maximum value representable by the integer type ``T``, see :ref:`Type Information<meta-type>`.

>>>>>>> 9f34322f394fc939fac0bf8b683fd61c45173674

.. index:: visibility, public, private, external, internal

関数の可視性指定子
==============================

.. code-block:: solidity
    :force:

    function myFunction() <visibility specifier> returns (bool) {
        return true;
    }

- ``public``: 外部にも内部にも見える（ストレージ/ステート変数の :ref:`ゲッター関数<getter-functions>` を作成する）

- ``private``: 現在のコントラクトでのみ見える

- ``external``: 外部にしか見えない（関数のみ） - つまり、メッセージコールしかできない（ ``this.func`` 経由）。

- ``internal``: 内部でのみ見える

.. index:: modifiers, pure, view, payable, constant, anonymous, indexed

修飾子
=========

- 関数の ``pure``: 状態の変更やアクセスを禁止する。

<<<<<<< HEAD
- 関数の ``view``: 状態の変更を不可とする。

- 関数の ``payable``: コールと同時にイーサを受信できるようにする。

- 状態変数の ``constant``: 初期化を除き、代入を禁止し、ストレージスロットを占有しない。

- 状態変数の ``immutable``: コンストラクション時に正確に1つの代入を可能にし、その後は一定です。コードに格納される。

- イベントの ``anonymous``: イベントの署名をトピックとして保存しない。

- イベントパラメータの ``indexed``: パラメータをトピックとして保存する。

- 関数や修飾子の ``virtual``: 関数や修飾子の動作を派生コントラクトで変更できるようにする。

- ``override``: この関数、修飾子、パブリックのステート変数が、ベースコントラクト内の関数や修飾子の動作を変更することを示す。

予約語
=================

これらのキーワードはSolidityで予約されています。将来的には構文の一部になるかもしれません。

``after``, ``alias``, ``apply``, ``auto``, ``byte``, ``case``, ``copyof``, ``default``,
``define``, ``final``, ``implements``, ``in``, ``inline``, ``let``, ``macro``, ``match``,
``mutable``, ``null``, ``of``, ``partial``, ``promise``, ``reference``, ``relocatable``,
``sealed``, ``sizeof``, ``static``, ``supports``, ``switch``, ``typedef``, ``typeof``,
``var``.
=======
>>>>>>> 9f34322f394fc939fac0bf8b683fd61c45173674
