************
チートシート
************

.. index:: operator;precedence

演算子の優先順位
================

.. include:: types/operator-precedence-table.rst

.. index:: abi;decode, abi;encode, abi;encodePacked, abi;encodeWithSelector, abi;encodeCall, abi;encodeWithSignature

ABIのエンコード関数とデコード関数
=================================

<<<<<<< HEAD
- ``abi.decode(bytes memory encodedData, (...)) returns (...)``:
  与えたデータを :ref:`ABI <ABI>` デコードします。
  型は第2引数として括弧内に与えられます。
  例 ``(uint a, uint[2] memory b, bytes memory c) = abi.decode(data, (uint, uint[2], bytes))``

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
  tuple. Performs a full type-check, ensuring the types match the function signature. Result equals ``abi.encodeWithSelector(functionPointer.selector, ...)``
- ``abi.encodeWithSignature(string memory signature, ...) returns (bytes memory)``: Equivalent
  to ``abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), ...)``
>>>>>>> english/develop

.. index:: bytes;concat, string;concat

``bytes`` と ``string`` のメンバー
==================================

- ``bytes.concat(...) returns (bytes memory)``:
  :ref:`可変個の引数を1つのバイト配列に連結します <bytes-concat>` 。

- ``string.concat(...) returns (string memory)``: :ref:`可変個の引数を1つの文字列に連結します <string-concat>` 。

.. index:: address;balance, address;codehash, address;send, address;code, address;transfer

``address`` のメンバー
======================

<<<<<<< HEAD
- ``<address>.balance`` (``uint256``): :ref:`address` の残高（Wei）
- ``<address>.code`` (``bytes memory``): :ref:`address` のコード（空にもなり得る）
- ``<address>.codehash`` (``bytes32``): :ref:`address` のコードハッシュ
- ``<address payable>.send(uint256 amount) returns (bool)``: 指定した量のWeiを :ref:`address` に送り、失敗したら ``false`` を返します。
- ``<address payable>.transfer(uint256 amount)``: 指定した量のWeiを :ref:`address` に送り、失敗したらリバートします。
=======
- ``<address>.balance`` (``uint256``): balance of the :ref:`address` in Wei
- ``<address>.code`` (``bytes memory``): code at the :ref:`address` (can be empty)
- ``<address>.codehash`` (``bytes32``): the codehash of the :ref:`address`
- ``<address>.call(bytes memory) returns (bool, bytes memory)``: issue low-level ``CALL`` with the given payload,
  returns success condition and return data
- ``<address>.delegatecall(bytes memory) returns (bool, bytes memory)``: issue low-level ``DELEGATECALL`` with the given payload,
  returns success condition and return data
- ``<address>.staticcall(bytes memory) returns (bool, bytes memory)``: issue low-level ``STATICCALL`` with the given payload,
  returns success condition and return data
- ``<address payable>.send(uint256 amount) returns (bool)``: send given amount of Wei to :ref:`address`,
  returns ``false`` on failure
- ``<address payable>.transfer(uint256 amount)``: send given amount of Wei to :ref:`address`, throws on failure
>>>>>>> english/develop

.. index:: blockhash, blobhash, block, block;basefee, block;blobbasefee, block;chainid, block;coinbase, block;difficulty, block;gaslimit, block;number, block;prevrandao, block;timestamp
.. index:: gasleft, msg;data, msg;sender, msg;sig, msg;value, tx;gasprice, tx;origin

ブロックとトランザクションのプロパティ
======================================

<<<<<<< HEAD
- ``blockhash(uint blockNumber) returns (bytes32)``: 指定したブロックのハッシュ。最新の256ブロックに対してのみ動作します。

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
=======
- ``blockhash(uint blockNumber) returns (bytes32)``: hash of the given block - only works for 256 most recent blocks
- ``blobhash(uint index) returns (bytes32)``: versioned hash of the ``index``-th blob associated with the current transaction.
  A versioned hash consists of a single byte representing the version (currently ``0x01``), followed by the last 31 bytes
  of the SHA256 hash of the KZG commitment (`EIP-4844 <https://eips.ethereum.org/EIPS/eip-4844>`_).
  Returns zero if no blob with the given index exists.
- ``block.basefee`` (``uint``): current block's base fee (`EIP-3198 <https://eips.ethereum.org/EIPS/eip-3198>`_ and `EIP-1559 <https://eips.ethereum.org/EIPS/eip-1559>`_)
- ``block.blobbasefee`` (``uint``): current block's blob base fee (`EIP-7516 <https://eips.ethereum.org/EIPS/eip-7516>`_ and `EIP-4844 <https://eips.ethereum.org/EIPS/eip-4844>`_)
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
>>>>>>> english/develop

.. index:: assert, require, revert

バリデーションとアサーション
============================

- ``assert(bool condition)``: 条件が ``false`` の場合、実行を中止し、ステートの変化をリバートします（内部エラーに使用）。

- ``require(bool condition)``: 条件が ``false`` の場合、実行を中止し、ステートの変化をリバートします（不正な入力や外部コンポーネントのエラーに使用）。

- ``require(bool condition, string memory message)``: 条件が ``false`` の場合、実行を中止し、ステートの変化をリバートします（不正な入力や外部コンポーネントのエラーに使用）。また、エラーメッセージを表示します。

- ``revert()``: 実行を中止し、状態の変化をリバートします。

- ``revert(string memory message)``: 実行を中止し、説明文字列を提供してステートの変化をリバートします。

.. index:: cryptography, keccak256, sha256, ripemd160, ecrecover, addmod, mulmod

数学的関数と暗号学的関数
========================

- ``keccak256(bytes memory) returns (bytes32)``: 入力のKeccak-256ハッシュを計算します。

- ``sha256(bytes memory) returns (bytes32)``: 入力のSHA-256ハッシュを計算します。

- ``ripemd160(bytes memory) returns (bytes20)``: 入力のRIPEMD-160ハッシュを計算します。

- ``ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)``: 楕円曲線署名から公開鍵に関連したアドレスをリカバリーします。エラー時は0を返します。

- ``addmod(uint x, uint y, uint k) returns (uint)``: 任意の精度で加算が実行され、 ``2**256`` で切り捨てられない ``(x + y) % k`` を計算します。バージョン0.5.0から ``k != 0`` であることをアサートします。

- ``mulmod(uint x, uint y, uint k) returns (uint)``: 任意の精度で乗算が実行され、 ``2**256`` で切り捨てられない ``(x * y) % k`` を計算します。バージョン0.5.0から ``k != 0`` であることをアサートします。

.. index:: this, super, selfdestruct

コントラクト関連
================

<<<<<<< HEAD
- ``this`` （現在のコントラクトの型）: 現在のコントラクトで、 ``address`` または ``address payable`` に明示的に変換できるもの。

- ``super``: 継承階層の1つ上の階層のコントラクト。

- ``selfdestruct(address payable recipient)``: 現在のコントラクトを破棄し、その資金を指定されたアドレスに送ります。
=======
- ``this`` (current contract's type): the current contract, explicitly convertible to ``address`` or ``address payable``
- ``super``: a contract one level higher in the inheritance hierarchy
- ``selfdestruct(address payable recipient)``: send all funds to the given address and (only on EVMs before Cancun or when invoked within the transaction creating the contract) destroy the contract.
>>>>>>> english/develop

.. index:: type;name, type;creationCode, type;runtimeCode, type;interfaceId, type;min, type;max

型情報
======

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

関数のビジビリティ指定子
========================

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

<<<<<<< HEAD
モディファイア
==============
=======
Modifiers
=========

- ``pure`` for functions: Disallows modification or access of state.
- ``view`` for functions: Disallows modification of state.
- ``payable`` for functions: Allows them to receive Ether together with a call.
- ``constant`` for state variables: Disallows assignment (except initialization), does not occupy storage slot.
- ``immutable`` for state variables: Allows assignment at construction time and is constant when deployed. Is stored in code.
- ``anonymous`` for events: Does not store event signature as topic.
- ``indexed`` for event parameters: Stores the parameter as topic.
- ``virtual`` for functions and modifiers: Allows the function's or modifier's
  behavior to be changed in derived contracts.
- ``override``: States that this function, modifier or public state variable changes
  the behavior of a function or modifier in a base contract.
>>>>>>> english/develop

- 関数の ``pure``: 状態の変更やアクセスを禁止します。
- 関数の ``view``: 状態の変更を不可とします。
- 関数の ``payable``: コールと同時にEtherを受信できるようにします。
- 状態変数の ``constant``: 初期化を除き、代入を禁止し、ストレージスロットを占有しません。
- 状態変数の ``immutable``: コンストラクション時に正確に1つの代入を可能にし、その後は一定です。コードに格納されます。
- イベントの ``anonymous``: イベントのシグネチャをトピックとして保存しません。
- イベントパラメータの ``indexed``: パラメータをトピックとして保存します。
- 関数やモディファイアの ``virtual``: 関数やモディファイアの動作を派生コントラクトで変更できるようにします。
- ``override``: この関数、モディファイア、パブリックの状態変数が、ベースコントラクト内の関数やモディファイアの動作を変更することを示します。
