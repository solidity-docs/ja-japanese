************
チートシート
************

.. index:: operator;precedence

<<<<<<< HEAD
演算子の優先順位
================
=======
Order of Precedence of Operators
================================

>>>>>>> english/develop
.. include:: types/operator-precedence-table.rst

.. index:: abi;decode, abi;encode, abi;encodePacked, abi;encodeWithSelector, abi;encodeCall, abi;encodeWithSignature

<<<<<<< HEAD
グローバル変数
==============

- ``abi.decode(bytes memory encodedData, (...)) returns (...)``: 
  与えたデータを :ref:`ABI <ABI>` デコードします。
  型は第2引数として括弧内に与えられます。
  例 ``(uint a, uint[2] memory b, bytes memory c) = abi.decode(data, (uint, uint[2], bytes))``
=======
ABI Encoding and Decoding Functions
===================================

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
  to ``abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), ...)``

.. index:: bytes;concat, string;concat

Members of ``bytes`` and  ``string``
====================================

- ``bytes.concat(...) returns (bytes memory)``: :ref:`Concatenates variable number of
  arguments to one byte array<bytes-concat>`

- ``string.concat(...) returns (string memory)``: :ref:`Concatenates variable number of
  arguments to one string array<string-concat>`

.. index:: address;balance, address;codehash, address;send, address;code, address;transfer

Members of ``address``
======================

- ``<address>.balance`` (``uint256``): balance of the :ref:`address` in Wei
- ``<address>.code`` (``bytes memory``): code at the :ref:`address` (can be empty)
- ``<address>.codehash`` (``bytes32``): the codehash of the :ref:`address`
- ``<address payable>.send(uint256 amount) returns (bool)``: send given amount of Wei to :ref:`address`,
  returns ``false`` on failure
- ``<address payable>.transfer(uint256 amount)``: send given amount of Wei to :ref:`address`, throws on failure

.. index:: blockhash, block, block;basefree, block;chainid, block;coinbase, block;difficulty, block;gaslimit, block;number, block;prevrandao, block;timestamp
.. index:: gasleft, msg;data, msg;sender, msg;sig, msg;value, tx;gasprice, tx;origin

Block and Transaction Properties
================================

- ``blockhash(uint blockNumber) returns (bytes32)``: hash of the given block - only works for 256 most recent blocks
- ``block.basefee`` (``uint``): current block's base fee (`EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ and `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_)
- ``block.chainid`` (``uint``): current chain id
- ``block.coinbase`` (``address payable``): current block miner's address
- ``block.difficulty`` (``uint``): current block difficulty (``EVM < Paris``). For other EVM versions it behaves as a deprecated alias for ``block.prevrandao`` that will be removed in the next breaking release
- ``block.gaslimit`` (``uint``): current block gaslimit
- ``block.number`` (``uint``): current block number
- ``block.prevrandao`` (``uint``): random number provided by the beacon chain (``EVM >= Paris``) (see `EIP-4399 <https://eips.ethereum.org/EIPS/eip-4399>`_ )
- ``block.timestamp`` (``uint``): current block timestamp in seconds since Unix epoch
- ``gasleft() returns (uint256)``: remaining gas
- ``msg.data`` (``bytes``): complete calldata
- ``msg.sender`` (``address``): sender of the message (current call)
- ``msg.sig`` (``bytes4``): first four bytes of the calldata (i.e. function identifier)
- ``msg.value`` (``uint``): number of wei sent with the message
- ``tx.gasprice`` (``uint``): gas price of the transaction
- ``tx.origin`` (``address``): sender of the transaction (full call chain)

.. index:: assert, require, revert

Validations and Assertions
==========================

- ``assert(bool condition)``: abort execution and revert state changes if condition is ``false`` (use for internal error)
- ``require(bool condition)``: abort execution and revert state changes if condition is ``false`` (use
  for malformed input or error in external component)
- ``require(bool condition, string memory message)``: abort execution and revert state changes if
  condition is ``false`` (use for malformed input or error in external component). Also provide error message.
- ``revert()``: abort execution and revert state changes
- ``revert(string memory message)``: abort execution and revert state changes providing an explanatory string

.. index:: cryptography, keccak256, sha256, ripemd160, ecrecover, addmod, mulmod

Mathematical and Cryptographic Functions
========================================

- ``keccak256(bytes memory) returns (bytes32)``: compute the Keccak-256 hash of the input
- ``sha256(bytes memory) returns (bytes32)``: compute the SHA-256 hash of the input
- ``ripemd160(bytes memory) returns (bytes20)``: compute the RIPEMD-160 hash of the input
- ``ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)``: recover address associated with
  the public key from elliptic curve signature, return zero on error
- ``addmod(uint x, uint y, uint k) returns (uint)``: compute ``(x + y) % k`` where the addition is performed with
  arbitrary precision and does not wrap around at ``2**256``. Assert that ``k != 0`` starting from version 0.5.0.
- ``mulmod(uint x, uint y, uint k) returns (uint)``: compute ``(x * y) % k`` where the multiplication is performed
  with arbitrary precision and does not wrap around at ``2**256``. Assert that ``k != 0`` starting from version 0.5.0.

.. index:: this, super, selfdestruct

Contract-related
================

- ``this`` (current contract's type): the current contract, explicitly convertible to ``address`` or ``address payable``
- ``super``: a contract one level higher in the inheritance hierarchy
- ``selfdestruct(address payable recipient)``: destroy the current contract, sending its funds to the given address

.. index:: type;name, type;creationCode, type;runtimeCode, type;interfaceId, type;min, type;max

Type Information
================

- ``type(C).name`` (``string``): the name of the contract
- ``type(C).creationCode`` (``bytes memory``): creation bytecode of the given contract, see :ref:`Type Information<meta-type>`.
- ``type(C).runtimeCode`` (``bytes memory``): runtime bytecode of the given contract, see :ref:`Type Information<meta-type>`.
- ``type(I).interfaceId`` (``bytes4``): value containing the EIP-165 interface identifier of the given interface, see :ref:`Type Information<meta-type>`.
- ``type(T).min`` (``T``): the minimum value representable by the integer type ``T``, see :ref:`Type Information<meta-type>`.
- ``type(T).max`` (``T``): the maximum value representable by the integer type ``T``, see :ref:`Type Information<meta-type>`.
>>>>>>> english/develop

- ``abi.encode(...) returns (bytes memory)``:
  与えた引数を :ref:`ABI <ABI>` エンコードします。

- ``abi.encodePacked(...) returns (bytes memory)``:
  与えた引数の :ref:`packed encoding <abi_packed_mode>` を実行します。
  このエンコーディングは曖昧になる可能性があることに注意してください！

- ``abi.encodeWithSelector(bytes4 selector, ...) returns (bytes memory)``: 
  与えた引数を2番目から順に :ref:`ABI <ABI>` エンコードし、与えた4バイトのセレクタを前に付加します。

- ``abi.encodeCall(function functionPointer, (...)) returns (bytes memory)``:
  タプルに含まれる引数を用いて ``functionPointer`` の呼び出しをABIエンコードします。
  完全な型チェックを行い、型が関数のシグネチャと一致することを保証します。
  結果は ``abi.encodeWithSelector(functionPointer.selector, (...))`` に等くなります。

- ``abi.encodeWithSignature(string memory signature, ...) returns (bytes memory)``:
  ``abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), ...)`` と同等です。

- ``bytes.concat(...) returns (bytes memory)``: 
  :ref:`可変個の引数を1つのバイト配列に連結します <bytes-concat>` 。

- ``string.concat(...) returns (string memory)``: :ref:`可変個の引数を1つの文字列に連結します <string-concat>` 。

- ``block.basefee`` (``uint``): カレントブロックのベースフィー（base fee）（ `EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ と `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_ ）。

- ``block.chainid`` (``uint``): カレントブロックのチェーンID。

- ``block.coinbase`` (``address payable``): カレントブロックのマイナーのアドレス。

- ``block.difficulty`` (``uint``):
  カレントブロックの難易度（ ``EVM < Paris`` ）。
  EVMの他のバージョンでは、 ``block.prevrandao`` の非推奨のエイリアスとして動作し、次のブレーキングリリースで削除される予定です。

- ``block.gaslimit`` (``uint``): カレントブロックのガスリミット。

- ``block.number`` (``uint``): カレントブロックの番号。

- ``block.prevrandao`` (``uint``):
  ビーコンチェーンが提供する乱数（ ``EVM < Paris`` ）。
  `EIP-4399 <https://eips.ethereum.org/EIPS/eip-4399>`_ を参照してください。

- ``block.timestamp`` ( ``uint`` ): Unixエポックからのカレントブロックのタイムスタンプ（秒）。

- ``gasleft() returns (uint256)``: 残りのガス。

- ``msg.data`` (``bytes``): 完全なコールデータ。

- ``msg.sender`` (``address``): メッセージの送信者（現在のコール）。

- ``msg.sig`` (``bytes4``): コールデータの最初の4バイト（すなわち関数識別子）。

- ``msg.value`` (``uint``): メッセージと一緒に送られたweiの数。

- ``tx.gasprice`` (``uint``): トランザクションのガスプライス。

- ``tx.origin`` (``address``): トランザクションの送信者（フルコールチェーン）。

- ``assert(bool condition)``: 条件が ``false`` の場合、実行を中止し、ステートの変化をリバートします（内部エラーに使用）。

- ``require(bool condition)``: 条件が ``false`` の場合、実行を中止し、ステートの変化をリバートします（不正な入力や外部コンポーネントのエラーに使用）。

- ``require(bool condition, string memory message)``: 条件が ``false`` の場合、実行を中止し、ステートの変化をリバートします（不正な入力や外部コンポーネントのエラーに使用）。また、エラーメッセージを表示します。

- ``revert()``: 実行を中止し、状態の変化をリバートします。

- ``revert(string memory message)``: 実行を中止し、説明文字列を提供してステートの変化をリバートします。

- ``blockhash(uint blockNumber) returns (bytes32)``: 与えられたブロックのハッシュ - 最新の256ブロックに対してのみ動作します。

- ``keccak256(bytes memory) returns (bytes32)``: 入力のKeccak-256ハッシュを計算します。

- ``sha256(bytes memory) returns (bytes32)``: 入力のSHA-256ハッシュを計算します。

- ``ripemd160(bytes memory) returns (bytes20)``: 入力のRIPEMD-160ハッシュを計算します。

- ``ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)``: 楕円曲線署名から公開鍵に関連したアドレスをリカバリーします。エラー時は0を返します。

- ``addmod(uint x, uint y, uint k) returns (uint)``: 任意の精度で加算が実行され、 ``2**256`` で切り捨てられない ``(x + y) % k`` を計算します。バージョン0.5.0から ``k != 0`` であることをアサートします。

- ``mulmod(uint x, uint y, uint k) returns (uint)``: 任意の精度で乗算が実行され、 ``2**256`` で切り捨てられない ``(x * y) % k`` を計算します。バージョン0.5.0から ``k != 0`` であることをアサートします。

- ``this`` （現在のコントラクトの型）: 現在のコントラクトで、 ``address`` または ``address payable`` に明示的に変換できるもの。

- ``super``: 継承階層の1つ上の階層のコントラクト。

- ``selfdestruct(address payable recipient)``: 現在のコントラクトを破棄し、その資金を指定されたアドレスに送ります。

- ``<address>.balance`` (``uint256``): :ref:`address` のWei残高。

- ``<address>.code`` (``bytes memory``):  :ref:`address` のコード（空でも良い）。

- ``<address>.codehash`` (``bytes32``):  :ref:`address` のコードハッシュ。

- ``<address payable>.send(uint256 amount) returns (bool)``: 
  指定された量のWeiを :ref:`address` に送り、失敗すると ``false`` を返します。

- ``<address payable>.transfer(uint256 amount)``:
  指定された量のWeiを :ref:`address` に送り、失敗したら例外を投げます。

- ``type(C).name`` (``string``): コントラクトの名前。

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

.. index:: visibility, public, private, external, internal

関数の可視性指定子
==================

.. code-block:: solidity
    :force:

    function myFunction() <visibility specifier> returns (bool) {
        return true;
    }

- ``public``: 外部にも内部にも見えます（ストレージ/状態変数の :ref:`ゲッター関数<getter-functions>` を作成する）。
- ``private``: 現在のコントラクトでのみ見えます。
- ``external``: 外部にしか見えません（関数のみ）。つまり、メッセージコールしかできません（ ``this.func`` 経由）。
- ``internal``: 内部でのみ見えます。

.. index:: modifiers, pure, view, payable, constant, anonymous, indexed

修飾子
======

- 関数の ``pure``: 状態の変更やアクセスを禁止します。
- 関数の ``view``: 状態の変更を不可とします。
- 関数の ``payable``: コールと同時にEtherを受信できるようにします。
- 状態変数の ``constant``: 初期化を除き、代入を禁止し、ストレージスロットを占有しません。
- 状態変数の ``immutable``: コンストラクション時に正確に1つの代入を可能にし、その後は一定です。コードに格納されます。
- イベントの ``anonymous``: イベントの署名をトピックとして保存しません。
- イベントパラメータの ``indexed``: パラメータをトピックとして保存します。
- 関数や修飾子の ``virtual``: 関数や修飾子の動作を派生コントラクトで変更できるようにします。
- ``override``: この関数、修飾子、パブリックの状態変数が、ベースコントラクト内の関数や修飾子の動作を変更することを示します。
