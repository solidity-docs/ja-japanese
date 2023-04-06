.. index:: ! value type, ! type;value
.. _value-types:

値型
====

.. The following are called value types because their variables will always be passed by value, i.e. they are always copied when they are used as function arguments or in assignments.

下記で紹介するものは、変数が常に値で渡されるため、値型と呼ばれます、 
つまり、関数の引数や代入で使われるときは、常にコピーされます。

.. index:: ! bool, ! true, ! false

ブーリアン
----------

``bool``: 可能な値は定数 ``true`` と ``false`` です。

演算子:

* ``!`` （論理的否定）
* ``&&`` （論理積、"and"）
* ``||`` （論理和、"or"）
* ``==`` （等号）
* ``!=`` （不等号）

演算子 ``||`` と ``&&`` は、共通の短絡ルールを適用します。
つまり、式 ``f(x) || g(y)`` において、 ``f(x)`` が ``true`` と評価された場合、 ``g(y)`` はたとえ副作用があったとしても評価されません。

.. index:: ! uint, ! int, ! integer
.. _integers:

整数
----

``int`` / ``uint``: さまざまなサイズの符号付きおよび符号なし整数。
キーワード ``uint8`` ～ ``uint256`` （8～256ビットの符号なし）と ``int8`` ～ ``int256`` を ``8`` の間隔で。
``uint`` と ``int`` は、それぞれ ``uint256`` と ``int256`` のエイリアス。

演算子:

* 比較: ``<=``, ``<``,  ``==``,  ``!=``,  ``>=``, ``>`` ( ``bool`` に評価)
* ビット演算子: ``&``, ``|``, ``^`` (ビットごとの排他的論理和), ``~`` (ビットごとの否定)
* シフト演算子: ``<<`` (左シフト), ``>>`` (右シフト)
* 算術演算子: ``+``, ``-``, 単項 ``-`` (符号付き整数の場合のみ), ``*``, ``/``, ``%`` (モジュロ), ``**`` (指数)

整数型の ``X`` の場合、 ``type(X).min`` と ``type(X).max`` を使って、その型で表現できる最小値と最大値にアクセスできます。

.. warning::

    Solidityの整数は、ある範囲に制限されています。
    例えば、 ``uint32`` の場合、 ``0`` から ``2**32 - 1`` までとなります。
    これらの型に対して算術演算を行うには2つのモードがあります。
    "ラッピング"または"チェックなし"モードと"チェックあり"モードです。
    デフォルトでは、演算は常に"チェック"されます。
    つまり、演算結果が型の値の範囲外になると、呼び出しは :ref:`failing assertion<assert-and-require>` でリバートされます。
    ``unchecked { ... }`` を使って"チェックなし"モードに切り替えることができます。
    詳細は :ref:`unchecked <unchecked>` の項を参照してください。

比較
^^^^

比較の値は、整数値を比較して得られる値です。

ビット演算
^^^^^^^^^^

ビット演算は、数値の2の補数表現に対して行われます。
これは例えば、 ``~int256(0) == int256(-1)`` だということです。

シフト
^^^^^^

シフト演算の結果は、左オペランドの型を持ち、型に合わせて結果を切り捨てます。
右のオペランドは符号なしの型でなければならず、符号ありの型でシフトしようとするとコンパイルエラーになります。

シフトは、以下の方法で2の累乗を使って"シミュレート"できます。
なお、左オペランドの型への切り捨ては常に最後に行われますが、明示的には言及されていません。

-  ``x << y`` は数学的表現で ``x * 2**y`` に相当します。
-  ``x >> y`` は、数学的表現で ``x / 2**y`` を負の無限大に向けて丸めたものに相当します。

.. warning::

    バージョン ``0.5.0`` 以前では、負の ``x`` の右シフト ``x >> y`` は、ゼロに向かって丸められた数学的表現 ``x / 2**y`` に相当していました。
    つまり、右シフトでは、（負の無限大に向かって）切り捨てるのではなく、（ゼロに向かって）切り上げられていたのです。

.. note::

    シフト演算では、算術演算のようなオーバーフローチェックが行われません。
    その代わり、結果は常に切り捨てられます。

加算、減算、乗算
^^^^^^^^^^^^^^^^

加算、減算、乗算には通常のセマンティクスがあり、オーバーフローとアンダーフローに関しては2つの異なるモードがあります。

デフォルトでは、すべての演算はアンダーフローまたはオーバーフローをチェックしますが、 :ref:`unchecked block<unchecked>` を使ってこれを無効にでき、結果としてラッピング演算が行われます。
詳細はこのセクションを参照してください。

``-x`` という表現は、 ``T`` を ``x`` の型として ``(T(0) - x)`` と同等です。
これは、符号付きの型にのみ適用できます。
``x`` が負であれば、 ``-x`` の値は正になります。
また、2の補数表現にはもう1つの注意点があります。

``int x = type(int).min;`` の場合は、 ``-x`` は正の範囲に当てはまりません。
つまり、 ``unchecked { assert(-x == x); }`` は動作し、 ``-x`` という表現をcheckedモードで使用すると、アサーションが失敗するということになります。

除算
^^^^

演算の結果の型は常にオペランドの1つの型であるため、整数の除算は常に整数になります。
Solidityでは、除算はゼロに向かって丸められます。
これは、 ``int256(-5) / int256(2) == int256(-2)`` を意味します。

これに対し、 :ref:`リテラル<rational_literals>` での除算では、任意の精度の分数値が得られることに注意してください。

.. note::

    ゼロによる除算は、 :ref:`パニックエラー<assert-and-require>` を引き起こします。
    このチェックは ``unchecked { ... }`` で無効にできます。

.. note::

    ``type(int).min / (-1)`` という式は、除算でオーバーフローが発生する唯一のケースです。
    チェックされた算術モードでは、これは失敗したアサーションを引き起こしますが、ラッピングモードでは、値は ``type(int).min`` になります。

モジュロ
^^^^^^^^

モジュロ演算 ``a % n`` では、オペランド ``a`` をオペランド ``n`` で除算した後の余り ``r`` が得られますが、ここでは ``q = int(a / n)`` と ``r = a - (n * q)`` が使われています。
つまり、モジュロの結果は左のオペランドと同じ符号（またはゼロ）になり、 ``a % n == -(-a % n)`` は負の ``a`` の場合も同様です。

* ``int256(5) % int256(2) == int256(1)``

* ``int256(5) % int256(-2) == int256(1)``

* ``int256(-5) % int256(2) == int256(-1)``

* ``int256(-5) % int256(-2) == int256(-1)``

.. note::

  ゼロでのモジュロは :ref:`パニックエラー<assert-and-require>` を引き起こします。
  このチェックは ``unchecked { ... }`` で無効にできます。

指数
^^^^

指数計算は、指数が符号なしの型の場合のみ可能です。
指数計算の結果の型は、常に基底の型と同じです。
結果を保持するのに十分な大きさであることに注意し、潜在的なアサーションの失敗やラッピングの動作に備えてください。

.. note::

  チェックされたモードでは、指数計算は小さな基底に対して比較的安価な ``exp`` というオペコードしか使いません。
  ``x**3`` の場合には ``x*x*x`` という表現の方が安いかもしれません。
  いずれにしても、ガスコストのテストとオプティマイザの使用が望まれます。

.. note::

  なお、 ``0**0`` はEVMでは ``1`` と定義されています。

.. index:: ! ufixed, ! fixed, ! fixed point number

固定小数点
----------

.. warning::

    固定小数点数はSolidityではまだ完全にはサポートされていません。
    宣言できますが、代入したり、代入解除したりできません。

``fixed``  /  ``ufixed``: さまざまなサイズの符号付きおよび符号なしの固定小数点数。
キーワード ``ufixedMxN`` と ``fixedMxN`` 、 ``M`` は型で取るビット数、 ``N`` は小数点以下の数を表します。
``M`` は8で割り切れるものでなければならず、8から256ビットまであります。
``N`` は0から80までの値でなければなりません。
``ufixed`` と ``fixed`` は、それぞれ ``ufixed128x18`` と ``fixed128x18`` のエイリアスです。

演算子:

* 比較: ``<=``,  ``<``,  ``==``,  ``!=``,  ``>=``,  ``>`` ( ``bool`` に評価)

* 算術演算子: ``+``,  ``-``, 単項 ``-``,  ``*``,  ``/``,  ``%`` (モジュロ)

.. note::

    浮動小数点（多くの言語では ``float`` と ``double`` 、正確にはIEEE754の数値）と固定小数点の主な違いは、整数部と小数部（小数点以下の部分）に使用するビット数が、前者では柔軟に設定できるのに対し、後者では厳密に定義されていることです。
    一般に、浮動小数点では、ほぼすべての空間を使って数値を表現するが、小数点の位置を決めるのは少数のビットです。

.. index:: address, balance, send, call, delegatecall, staticcall, transfer

.. _address:

アドレス
--------

アドレス型には2つの種類がありますが、ほとんど同じです。

-  ``address``: 20バイトの値（Ethereumのアドレスのサイズ）を保持します。

-  ``address payable``:  ``address`` と同じですが、メンバの ``transfer`` と ``send`` が追加されます。

この区別の背景にある考え方は、 ``address payable`` はEtherを送ることができるアドレスであるのに対し、プレーンな ``address`` はEtherを送ることが想定されない、というものです。
例えば、 ``address`` の変数に格納されたアドレスがEtherを受信できるように構築されていないスマートコントラクトである可能性があります。

型変換:

``address payable`` から ``address`` への暗黙の変換は許されますが、 ``address`` から ``address payable`` への変換は ``payable(<address>)`` を介して明示的に行う必要があります。

``uint160`` 、整数リテラル、 ``bytes20`` 、コントラクト型については、 ``address`` との明示的な変換が可能です。

``address`` 型とコントラクト型の式のみが、明示的な変換 ``payable(...)`` によって ``address payable`` 型に変換できます。
コントラクト型については、コントラクトがEtherを受信できる場合、つまりコントラクトが :ref:`receive <receive-ether-function>` またはpayableのフォールバック関数を持っている場合にのみ、この変換が可能です。
``payable(0)`` は有効であり、このルールの例外であることに注意してください。

.. note::

    ``address`` 型の変数が必要で、その変数にEtherを送ろうと思っているなら、その変数の型を ``address payable`` と宣言して、この要求を見えるようにします。
    また、この区別や変換はできるだけ早い段階で行うようにしてください。
    The distinction between ``address`` and ``address payable`` was introduced with version 0.5.0.
    Also starting from that version, contracts are not implicitly convertible to the ``address`` type, but can still be explicitly converted to
    ``address`` or to ``address payable``, if they have a receive or payable fallback function.

演算子:

* ``<=``, ``<``, ``==``,  ``!=``, ``>=``, ``>``

.. warning::

    より大きなバイトサイズを使用する型、例えば ``bytes32`` などを ``address`` に変換した場合、 ``address`` は切り捨てられます。
    変換の曖昧さを減らすために、バージョン0.4.24以降のコンパイラでは、変換時に切り捨てを明示することを強制するようになっています。
    例えば、32バイトの値 ``0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC`` を考えてみましょう。

    ``address(uint160(bytes20(b)))`` を使うと ``0x111122223333444455556666777788889999aAaa`` になり、 ``address(uint160(uint256(b)))`` を使うと ``0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc`` になります。

.. note::

    Mixed-case hexadecimal numbers conforming to `EIP-55 <https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md>`_ are automatically treated as literals of the ``address`` type. See :ref:`Address Literals<address_literals>`.

.. _members-of-addresses:

アドレスのメンバ
^^^^^^^^^^^^^^^^

全メンバーのアドレスの早見表は、 :ref:`address_related` を参照してください。

* ``balance`` と ``transfer``

プロパティ ``balance`` を使ってアドレスの残高を照会したり、 ``transfer`` 関数を使って支払先のアドレスにイーサ（wei単位）を送信したりすることが可能です。

.. code-block:: solidity
    :force:

    address payable x = payable(0x123);
    address myAddress = address(this);
    if (x.balance < 10 && myAddress.balance >= 10) x.transfer(10);

``transfer`` 関数は、現在のコントラクトの残高が十分でない場合や、Ether送金が受信アカウントで拒否された場合に失敗します。
``transfer`` 関数は失敗するとリバートします。

.. note::

    ``x`` がコントラクトアドレスの場合、そのコード（具体的には、 :ref:`receive-ether-function` があればその :ref:`receive-ether-function` 、 :ref:`fallback-function` があればその :ref:`fallback-function` ）が ``transfer`` コールとともに実行されます（これはEVMの機能であり、防ぐことはできません）。
    その実行がガス欠になるか、何らかの形で失敗した場合、Ether送金はリバートされ、現在のコントラクトは例外的に停止します。

* ``send``

``send`` は、 ``transfer`` の低レベルのカウンターパートです。
実行に失敗した場合、現在のコントラクトは例外的に停止しませんが、 ``send`` は ``false`` を返します。

.. warning::

    ``send`` の使用にはいくつかの危険性があります。
    コールスタックの深さが1024の場合（これは常に呼び出し側で強制できます）、送金は失敗し、また、受信者がガス欠になった場合も失敗します。
    したがって、安全なEther送金を行うためには、 ``send`` の戻り値を常にチェックするか、 ``transfer`` を使用するか、あるいはさらに良い方法として、受信者がお金を引き出すパターンを使用してください。

* ``call``, ``delegatecall``, ``staticcall``

ABIに準拠していないコントラクトとのインターフェースや、エンコーディングをより直接的に制御するために、関数 ``call`` 、 ``delegatecall`` 、 ``staticcall`` が用意されています。
これらの関数はすべて1つの ``bytes memory`` パラメータを受け取り、成功条件（ ``bool`` ）と戻りデータ（ ``bytes memory`` ）を返します。
関数 ``abi.encode``、 ``abi.encodePacked``、 ``abi.encodeWithSelector``、 ``abi.encodeWithSignature`` は、構造化データのエンコードに使用できます。

例:

.. code-block:: solidity

    bytes memory payload = abi.encodeWithSignature("register(string)", "MyName");
    (bool success, bytes memory returnData) = address(nameReg).call(payload);
    require(success);

.. warning::

    これらの関数はすべて低レベルの関数であり、注意して使用する必要があります。
    特に、未知のコントラクトは悪意を持っている可能性があり、それを呼び出すと、そのコントラクトに制御を渡すことになり、そのコントラクトが自分のコントラクトにコールバックする可能性があるので、コールが戻ってきたときの自分の状態変数の変化に備えてください。
    他のコントラクトとやりとりする通常の方法は、コントラクトオブジェクト（ ``x.f()`` ）の関数を呼び出すことです。

.. note::

    以前のバージョンのSolidityでは、これらの関数が任意の引数を受け取ることができ、また、 ``bytes4`` 型の第1引数の扱いが異なっていました。
    これらのエッジケースはバージョン0.5.0で削除されました。

``gas`` 修飾子で供給ガスを調整することが可能です。

.. code-block:: solidity

    address(nameReg).call{gas: 1000000}(abi.encodeWithSignature("register(string)", "MyName"));

同様に、送金するEtherの値も制御できます。

.. code-block:: solidity

    address(nameReg).call{value: 1 ether}(abi.encodeWithSignature("register(string)", "MyName"));

最後に、これらの修飾子は組み合わせることができます。
その順番は問題ではありません。

.. code-block:: solidity

    address(nameReg).call{gas: 1000000, value: 1 ether}(abi.encodeWithSignature("register(string)", "MyName"));

同様の方法で、関数 ``delegatecall`` を使用できます。
違いは、与えられたアドレスのコードのみが使用され、他のすべての側面（ストレージ、残高、...）は、現在のコントラクトから取得されます。
``delegatecall`` の目的は、別のコントラクトに保存されているライブラリコードを使用することです。
ユーザーは、両方のコントラクトのストレージのレイアウトが、delegatecallを使用するのに適していることを確認しなければなりません。

.. note::

    Homestead以前のバージョンでは、 ``callcode`` という限定されたバリアントのみが利用可能で、オリジナルの ``msg.sender`` と ``msg.value`` の値にアクセスできませんでした。
    この関数はバージョン0.5.0で削除されました。

Byzantiumから ``staticcall`` も使えるようになりました。
これは基本的に ``call`` と同じですが、呼び出された関数が何らかの形で状態を変更するとリバートされます。

``call``、 ``delegatecall``、 ``staticcall`` の3つの関数は、非常に低レベルな関数で、Solidityの型安全性を壊してしまうため、 *最後の手段* としてのみ使用してください。

``gas`` オプションは3つの方式すべてで利用できますが、 ``value`` オプションは ``call`` でのみ利用できます。

.. note::

    スマートコントラクトのコードでは、状態の読み書きにかかわらず、ハードコードされたガスの値に依存することは、多くの落とし穴があるので避けたほうがよいでしょう。
    また、ガスへのアクセスが将来変わる可能性もあります。

* ``code`` and ``codehash``

You can query the deployed code for any smart contract. Use ``.code`` to get the EVM bytecode as a
``bytes memory``, which might be empty. Use ``.codehash`` to get the Keccak-256 hash of that code
(as a ``bytes32``). Note that ``addr.codehash`` is cheaper than using ``keccak256(addr.code)``.

.. note::

    すべてのコントラクトは ``address`` 型に変換できるので、 ``address(this).balance`` を使って現在のコントラクトの残高を照会することが可能です。

.. index:: ! contract type, ! type; contract

.. _contract_types:

コントラクト型
--------------

すべての :ref:`コントラクト<contracts>` はそれ自身の型を定義します。
コントラクトを、それらが継承するコントラクトに暗黙的に変換できます。
コントラクトは、 ``address`` 型との間で明示的に変換できます。

``address payable`` 型との間の明示的な変換は、コントラクト型にreceiveまたはpayableのフォールバック関数がある場合にのみ可能です。
変換は ``address(x)`` を使用して行われます。
コントラクト型にreceiveまたはpayment fallback関数がない場合、 ``address payable`` への変換は ``payable(address(x))`` を使用して行うことができます。
詳細は、:ref:`アドレス型<address>` の項を参照してください。

.. note::

    バージョン0.5.0以前は、コントラクトはアドレス型から直接派生し、 ``address`` と ``address payable`` の区別はありませんでした。

コントラクト型（ ``MyContract c`` ）のローカル変数を宣言すると、そのコントラクトで関数を呼び出すことができます。
ただし、同じコントラクト型のどこかから代入するように注意してください。

また、コントラクトをインスタンス化することもできます（新規に作成することを意味します）。
詳細は :ref:`'Contracts via new'<creating-contracts>` の項を参照してください。

コントラクトのデータ表現は ``address`` 型と同じで、この型は :ref:`ABI<ABI>` でも使用されています。

コントラクトは、いかなる演算子もサポートしません。

コントラクト型のメンバは、 ``public`` とマークされた状態変数を含むコントラクトの外部関数です。

コントラクト ``C`` の場合は、 ``type(C)`` を使ってコントラクトに関する :ref:`型情報<meta-type>` にアクセスできます。

.. index:: byte array, bytes32

固定長バイト列
--------------

``bytes1`` ,  ``bytes2`` ,  ``bytes3`` , ...,  ``bytes32`` の値は、1から最大32までのバイト列を保持します。

演算子:

* 比較: ``<=``,  ``<``,  ``==``,  ``!=``,  ``>=``,  ``>``  ( ``bool`` に評価)

* ビット演算子: ``&``, ``|``, ``^`` （ビットごとの排他的論理和）, ``~`` （ビットごとの否定）

* シフト演算子: ``<<`` (左シフト), ``>>`` (右シフト)

* インデックスアクセス: ``x`` が型 ``bytesI`` の場合、 ``0 <= k < I`` において ``x[k]``  は ``k`` 番目のバイトを返します（読み取り専用）。

シフト演算子は、右オペランドに符号なし整数型を指定して動作します（ただし、左オペランドの型を返します）が、この型はシフトするビット数を表します。
符号付きの型でシフトするとコンパイルエラーになります。

メンバー:

* ``.length`` は、バイト列の固定長を出力します（読み取り専用）。

.. note::

    ``bytes1[]`` 型はバイトの配列ですが、パディングのルールにより、各要素ごとに31バイトのスペースを無駄にしています（ストレージを除く）。
    代わりに ``bytes`` 型を使うのが良いでしょう。

.. note::

    バージョン0.8.0以前では、 ``byte`` は ``bytes1`` のエイリアスでした。

動的サイズのバイト列
--------------------

``bytes``:
    動的なサイズのバイト配列。
    :ref:`arrays` を参照。
    値型ではありません！
``string``:
    動的サイズのUTF-8エンコードされた文字列。
    :ref:`arrays` を参照。
    値型ではありません！

.. index:: address, literal;address

.. _address_literals:

アドレスリテラル
----------------

アドレスチェックサムテストに合格した16進数リテラル（例:  ``0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF`` ）は ``address`` 型です。
16進数リテラルの長さが39桁から41桁の間で、チェックサムテストに合格しない場合はエラーになります。
エラーを取り除くには、ゼロを前置（整数型の場合）または後置（bytesNN型の場合）する必要があります。

.. note::

    混合ケースのアドレスチェックサムフォーマットは `EIP-55 <https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md>`_ で定義されています。

.. index:: literal, literal;rational

.. _rational_literals:

有理数リテラルと整数リテラル
----------------------------

整数リテラルは、0～9の範囲の数字の列で構成されます。
小数点以下の数字として解釈されます。
例えば、 ``69`` は69を意味します。
Solidityには8進数のリテラルは存在せず、先頭のゼロは無効です。

Decimal fractional literals are formed by a ``.`` with at least one number after the decimal point.
Examples include ``.1`` and ``1.3`` (but not ``1.``).

``2e10`` のような科学的表記（指数表記）もサポートされています。
仮数は小数でも構いませんが、指数は整数でなければなりません。
``MeE`` というリテラルは ``M * 10**E`` と同じ意味です。
例としては、 ``2e10`` 、 ``-2e10`` 、 ``2e-10`` 、 ``2.5e1`` などがあります。

アンダースコアは、読みやすくするために数値リテラルの桁を区切るのに使用できます。
例えば、10進法の ``123_000`` 、16進法の ``0x2eff_abde`` 、科学的10進法の ``1_2e345_678`` はすべて有効です。
アンダースコアは2つの数字の間にのみ使用でき、連続したアンダースコアは1つしか使用できません。
アンダースコアを含む数値リテラルには、追加の意味はなく、アンダースコアは無視されます。

.. Number literal expressions retain arbitrary precision until they are converted to a non-literal type (i.e. by using them together with anything other than a number literal expression (like boolean literals) or by explicit conversion).

数値リテラル式は、非リテラル型に変換されるまで（すなわち、数値リテラル式以外のもの（ブーリアンリテラルなど）と一緒に使用するか、明示的に変換することにより）、任意の精度を保持します。
このため、数値リテラル式では、計算がオーバーフローしたり、除算が切り捨てられたりすることはありません。

例えば、 ``(2**800 + 1) - 2**800`` の結果は定数 ``1`` （ ``uint8`` 型）になりますが、中間の結果はマシンのワードサイズに収まりません。
さらに、 ``.5 * 8`` の結果は整数の ``4`` になります（ただし、その間には非整数が使われています）。

.. warning::
    While most operators produce a literal expression when applied to literals, there are certain operators that do not follow this pattern:

    - Ternary operator (``... ? ... : ...``),
    - Array subscript (``<array>[<index>]``).

    You might expect expressions like ``255 + (true ? 1 : 0)`` or ``255 + [1, 2, 3][0]`` to be equivalent to using the literal 256
    directly, but in fact they are computed within the type ``uint8`` and can overflow.

整数に適用できる演算子は、オペランドが整数であれば、数リテラル式にも適用できます。
2つのうちいずれかが小数の場合、ビット演算は許可されず、指数が小数の場合、指数演算は許可されません（非有理数になってしまう可能性があるため）。

リテラル数を左（またはベース）オペランドとし、整数型を右（指数）オペランドとするシフトと指数計算は、右（指数）オペランドの型にかかわらず、常に ``uint256`` （非負のリテラルの場合）または ``int256`` （負のリテラルの場合）型で実行されます。

.. warning::

    バージョン0.4.0以前のSolidityでは、整数リテラルの除算は切り捨てられていましたが、有理数に変換されるようになりました。
    つまり、 ``5 / 2`` は ``2`` とはならず、 ``2.5`` となります。

.. note::

    Solidityでは、有理数ごとに数リテラル型が用意されています。
    整数リテラルと有理数リテラルは、数リテラル型に属します。
    また、すべての数リテラル式（数リテラルと演算子のみを含む式）は、数リテラル型に属します。
    つまり、数リテラル式 ``1 + 2`` と ``2 + 1`` は、有理数3に対して同じ数リテラル型に属しています。

.. note::

    数リテラル式は、非リテラル式と一緒に使われると同時に、非リテラル型に変換されます。
    型に関係なく、以下の ``b`` に割り当てられた式の値は整数と評価されます。
    ``a`` は ``uint128`` 型なので、 ``2.5 + a`` という式は適切な型を持っていなければなりませんが。
    ``2.5`` と ``uint128`` の型には共通の型がないので、Solidityのコンパイラはこのコードを受け入れません。

.. code-block:: solidity

    uint128 a = 1;
    uint128 b = 2.5 + a + 0.5;

.. index:: literal, literal;string, string
.. _string_literals:

文字列リテラルと文字列型
------------------------

文字列リテラルは、ダブルクオートまたはシングルクオート（ ``"foo"`` または ``'bar'`` ）で記述され、連続した複数の部分に分割することもできます（ ``"foo" "bar"`` は ``"foobar"`` に相当）。
これは長い文字列を扱う際に便利です。
また、C言語のように末尾にゼロを付けることはなく、 ``"foo"`` は4バイトではなく3バイトです。
整数リテラルと同様に、その型は様々ですが、 ``bytes1``, ..., ``bytes32`` に暗黙のうちに変換され、それが適合する場合は、 ``bytes`` や ``string`` に変換されます。

例えば、 ``bytes32 samevar = "stringliteral"`` では文字列リテラルが ``bytes32`` 型に割り当てられると、生のバイト形式で解釈されます。

文字列リテラルには、印刷可能なASCII文字のみを含めることができます。
つまり、0x20から0x7Eまでの文字です。

さらに、文字列リテラルは以下のエスケープ文字にも対応しています。

- ``\<newline>`` (実際の改行のエスケープ)
- ``\\`` (バックスラッシュ)
- ``\'`` (シングルクォート)
- ``\"`` (ダブルクォート)
- ``\n`` (改行)
- ``\r`` (キャリッジリターン)
- ``\t`` (タブ)
- ``\xNN`` (ヘックスエスケープ、下記参照)
- ``\uNNNN`` (Unicodeエスケープ、下記参照)

``\xNN`` は16進数の値を受け取り、適切なバイトを挿入します。
``\uNNNN`` はUnicodeコードポイントを受け取り、UTF-8シーケンスを挿入します。

.. note::

    バージョン0.8.0までは、さらに3つのエスケープシーケンスがありました。
    ``\b``、 ``\f``、 ``\v`` です。
    これらは他の言語ではよく使われていますが、実際にはほとんど必要ありません。
    もし必要であれば、他のASCII文字と同じように16進数のエスケープ、すなわち ``\x08`` 、 ``\x0c`` 、 ``\x0b`` を使って挿入できます。

次の例の文字列の長さは10バイトです。
この文字列は、改行バイトで始まり、ダブルクォート、シングルクォート、バックスラッシュ文字、そして（セパレータなしで）文字列 ``abcdef`` が続きます。

.. code-block:: solidity
    :force:

    "\n\"\'\\abc\
    def"

改行ではない Unicode の行終端記号（LF、VF、FF、CR、NEL、LS、PS など）は、文字列リテラルを終了するものとみなされます。
改行が文字列リテラルを終了させるのは、その前に ``\`` がない場合のみです。

Unicodeリテラル
---------------

通常の文字列リテラルはASCIIのみを含むことができますが、Unicodeリテラル（キーワード ``unicode`` を前に付けたもの）は、有効なUTF-8シーケンスを含むことができます。
また、Unicodeリテラルは、通常の文字列リテラルと同じエスケープシーケンスにも対応しています。

.. code-block:: solidity

    string memory a = unicode"Hello 😃";

.. index:: literal, bytes

16進数リテラル
--------------

16進数リテラルは、キーワード ``hex`` を前に付け、ダブルクオートまたはシングルクオートで囲みます（ ``hex"001122FF"`` 、 ``hex'0011_22_FF'`` ）。
リテラルの内容は16進数でなければならず、バイト境界のセパレータとしてアンダースコアを1つ使用することも可能です。
リテラルの値は、16進数をバイナリ表現したものになります。

空白で区切られた複数の16進数リテラルは、1つのリテラルに連結されます。
``hex"00112233" hex"44556677"`` は ``hex"0011223344556677"`` と同じです。

16進数リテラルは、 :ref:`文字列リテラル<string_literals>` と同じように動作し、同じような変換の制限があります。

.. index:: enum

.. _enums:

列挙
----

列挙（enum）はSolidityでユーザー定義型を作成する一つの方法です。
すべての整数型との間で明示的に変換できますが、暗黙的な変換はできません。
整数型からの明示的な変換は、実行時に値が列挙型の範囲内にあるかどうかをチェックし、そうでない場合は :ref:`パニックエラー<assert-and-require>` を発生させます。
列挙型は少なくとも1つのメンバーを必要とし、宣言時のデフォルト値は最初のメンバーです。
列挙型は256以上のメンバーを持つことはできません。

データ表現は、C言語のenumと同じです。
オプションは、 ``0`` から始まる後続の符号なし整数値で表されます。

``type(NameOfEnum).min`` と ``type(NameOfEnum).max`` を使えば、与えられたenumの最小値と最大値を得ることができます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.8;

    contract test {
        enum ActionChoices { GoLeft, GoRight, GoStraight, SitStill }
        ActionChoices choice;
        ActionChoices constant defaultChoice = ActionChoices.GoStraight;

        function setGoStraight() public {
            choice = ActionChoices.GoStraight;
        }

        // 列挙型はABIの一部ではないため、Solidityの外部に対して、「getChoice」の署名は自動的に「getChoice() returns (uint8)」に変更されることになります。
        function getChoice() public view returns (ActionChoices) {
            return choice;
        }

        function getDefaultChoice() public pure returns (uint) {
            return uint(defaultChoice);
        }

        function getLargestValue() public pure returns (ActionChoices) {
            return type(ActionChoices).max;
        }

        function getSmallestValue() public pure returns (ActionChoices) {
            return type(ActionChoices).min;
        }
    }

.. note::

    Enumは、コントラクトやライブラリの定義とは別に、ファイルレベルで宣言することもできます。

.. index:: ! user defined value type, custom type

.. _user-defined-value-types:

ユーザー定義の値型
------------------

ユーザー定義の値型は、基本的な値型をゼロコストで抽象化して作成できます。
これは、エイリアスに似ていますが、型の要件がより厳しくなっています。

ユーザー定義の値型は、 ``type C is V`` を使って定義されます。
``C`` は新しく導入される型の名前で、 ``V`` は組み込みの値の型（「基礎となる型」）でなければなりません。
関数 ``C.wrap`` は、基礎となる型からカスタム型への変換に使用されます。
同様に、関数 ``C.unwrap`` はカスタム型から基礎型への変換に使用されます。

``C`` 型には、演算子や付属のメンバ関数がありません。
特に、演算子 ``==`` も定義されていません。
他の型との間の明示的および暗黙的な変換は許されません。

このような型の値のデータ表現は、基礎となる型から継承され、基礎となる型はABIでも使用されます。

次の例では、18桁の10進数固定小数点型を表すカスタム型 ``UFixed256x18`` と、その型に対して算術演算を行うための最小限のライブラリを示しています。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.8;

    // 18進数、256ビット幅の固定小数点型をユーザー定義の値型を使用して表現します。
    type UFixed256x18 is uint256;

    /// UFixed256x18に対して固定小数点演算を行うための最小限のライブラリ
    library FixedMath {
        uint constant multiplier = 10**18;

        /// 2つのUFixed256x18の値を足します。
        /// uint256のチェックされた算術に依存して、オーバーフローでリバートします。
        function add(UFixed256x18 a, UFixed256x18 b) internal pure returns (UFixed256x18) {
            return UFixed256x18.wrap(UFixed256x18.unwrap(a) + UFixed256x18.unwrap(b));
        }
        /// UFixed256x18の値とuint256の値を掛けます。
        /// uint256のチェックされた算術に依存して、オーバーフローでリバートします。
        function mul(UFixed256x18 a, uint256 b) internal pure returns (UFixed256x18) {
            return UFixed256x18.wrap(UFixed256x18.unwrap(a) * b);
        }
        /// UFixed256x18の数のフロアを取ります。
        /// @return `a` を超えない最大の整数。
        function floor(UFixed256x18 a) internal pure returns (uint256) {
            return UFixed256x18.unwrap(a) / multiplier;
        }
        /// uint256 を同じ値の UFixed256x18 に変換します。
        /// 整数が大きすぎる場合はリバートします。
        function toUFixed256x18(uint256 a) internal pure returns (UFixed256x18) {
            return UFixed256x18.wrap(a * multiplier);
        }
    }

``UFixed256x18.wrap`` と ``FixedMath.toUFixed256x18`` は同じ署名を持っていますが、全く異なる2つの処理を行っていることに注目してください。
``UFixed256x18.wrap`` 関数は入力と同じデータ表現の ``UFixed256x18`` を返すのに対し、 ``toUFixed256x18`` は同じ数値を持つ ``UFixed256x18`` を返します。

.. index:: ! function type, ! type; function

.. _function_types:

関数型
------

関数型は、関数の型です。
関数型の変数は、関数から代入でき、関数型のパラメータは、関数呼び出しに関数を渡したり、関数呼び出しから関数を返したりするのに使われます。
関数型には、 *内部（internal）* 関数と *外部（external）* 関数の2種類があります。

内部関数は、現在のコントラクトのコンテキストの外では実行できないため、現在のコントラクトの内部（より具体的には、現在のコードユニットの内部で、内部ライブラリ関数や継承された関数も含む）でのみ呼び出すことができます。
内部関数の呼び出しは、現在のコントラクトの関数を内部で呼び出す場合と同様に、そのエントリーラベルにジャンプすることで実現します。

外部関数は、アドレスと関数シグネチャで構成されており、外部関数呼び出しを介して渡したり、外部関数呼び出しから返したりできます。

関数型は以下のように表記されています。

.. code-block:: solidity
    :force:

    function (<parameter types>) {internal|external} [pure|view|payable] [returns (<return types>)]

パラメータ型とは対照的に、リターン型は空にできません。
関数型が何も返さない場合は、 ``returns (<return types>)`` の部分をすべて省略しなければなりません。

デフォルトでは、関数型は内部的なものなので、 ``internal`` キーワードは省略できます。
これは関数型にのみ適用されることに注意してください。
コントラクトで定義された関数については、可視性を明示的に指定する必要があり、デフォルトはありません。

変換:

関数型 ``A`` は、それらのパラメータ型が同一であり、戻り値の型が同一であり、それらの内部/外部プロパティが同一であり、 ``A`` の状態の変更可能性が ``B`` の状態の変更可能性よりも制限されている場合に限り、関数型 ``B`` に暗黙的に変換可能です。
具体的には以下です。

-  ``pure`` 関数を ``view`` 、 ``non-payable`` 関数に変換可能
-  ``view`` 関数から ``non-payable`` 関数への変換が可能
-  ``payable`` 関数から ``non-payable`` 関数への変換が可能

これら以外の関数型間の変換はできません。

.. To clarify, rejecting ether is more restrictive than not rejecting ether.
.. This means you can override a payable function with a non-payable but not the other way around.

``payable`` と ``non-payable`` のルールは少しわかりにくいかもしれませんが、要するにある関数が ``payable`` であれば、ゼロのEtherの支払いも受け入れるということなので、 ``non-payable`` でもあるということです。
一方、 ``non-payable`` 関数は送られてきたEtherを拒否しますので、 ``non-payable`` 関数を ``payable`` 関数に変換できません。
明確にするために、etherを拒否することは、etherを拒否しないことよりも制限されます。
つまり、payableな関数をnon-payableな関数で上書きすることは可能ですが、その逆はできません。

.. Additionally, When you define a ``non-payable`` function pointer, the compiler does not enforce that the pointed function will actually reject ether.
.. Instead, it enforces that the function pointer is never used to send ether.
.. Which makes it possible to assign a ``payable`` function pointer to a ``non-payable`` function pointer ensuring both types behave the same way, i.e, both cannot be used to send ether.

さらに、 ``non-payable`` な関数ポインタを定義した場合、コンパイラは指定した関数が実際にEtherを拒否することを強制するわけではありません。
その代わりに、その関数ポインタは決して ether を送るために使われないことを強制します。
そのため、 ``payable`` な関数ポインタを ``non-payable`` な関数ポインタに割り当てることで、両方の型が同じように動作する、つまり、どちらもEtherを送信するために使用できないことを保証することが可能になります。

関数型変数が初期化されていない場合、それを呼び出すと :ref:`パニックエラー<assert-and-require>` になります。
また、関数に ``delete`` を使用した後に関数を呼び出した場合も同様です。

外部関数型がSolidityのコンテキスト外で使用される場合は、 ``function`` 型として扱われ、アドレスに続いて関数識別子をまとめて1つの ``bytes24`` 型にエンコードします。

現在のコントラクトのパブリック関数は、内部関数としても外部関数としても使用できることに注意してください。
``f`` を内部関数として使用したい場合は ``f`` を、外部関数として使用したい場合は ``this.f`` を使用してください。

内部型の関数は、どこで定義されているかに関わらず、内部関数型の変数に代入できます。
これには、コントラクトとライブラリの両方のプライベート関数、内部関数、パブリック関数のほか、フリーの関数も含まれます。
一方、外部関数型は、パブリック関数と外部コントラクト関数にのみ対応しています。

.. note::
    .. External functions with ``calldata`` parameters are incompatible with external function types with ``calldata`` parameters.
    .. They are compatible with the corresponding types with ``memory`` parameters instead.
    .. For example, there is no function that can be pointed at by a value of type ``function (string calldata) external`` while ``function (string memory) external`` can point at both ``function f(string memory) external {}`` and ``function g(string calldata) external {}``.
    .. This is because for both locations the arguments are passed to the function in the same way.
    .. The caller cannot pass its calldata directly to an external function and always ABI-encodes the arguments into memory.
    .. Marking the parameters as ``calldata`` only affects the implementation of the external function and is meaningless in a function pointer on the caller's side.

    ``calldata`` パラメータを持つ外部関数は、 ``calldata`` パラメータを持つ外部関数型と互換性がありません。
    代わりに ``memory`` パラメータを持つ対応する型と互換性があります。
    例えば、 ``function (string calldata) external`` 型の値が指すことのできる関数はありませんが、 ``function (string memory) external`` は ``function f(string memory) external {}`` と ``function g(string calldata) external {}`` を指すことができます。
    これは、どちらの場所でも、引数が同じように関数に渡されるからです。
    呼び出し元はcalldataを直接外部関数に渡すことはできず、常に引数をメモリにABIエンコードします。
    パラメータを ``calldata`` としてマークすることは、外部関数の実装にのみ影響し、呼び出し側の関数ポインタでは意味を持ちません。

ライブラリは、 ``delegatecall`` と :ref:`セレクタへの異なるABI規約<library-selectors>` の使用を必要とするため、除外されます。
インターフェースで宣言された関数は定義を持たないので、それを指し示すことも意味がありません。

メンバー:

外部（またはパブリック）関数には、次のようなメンバーを持ちます。

* ``.address`` は、関数のコントラクトのアドレスを返します。

* ``.selector`` が :ref:`ABI関数セレクタ<abi_function_selector>` を返します。

.. note::

    外部（またはパブリック）関数には、追加のメンバー ``.gas(uint)`` と ``.value(uint)`` がありました。
    これらはSolidity 0.6.2で非推奨となり、Solidity 0.7.0で削除されました。
    代わりに ``{gas: ...}`` と ``{value: ...}`` を使って、それぞれ関数に送られるガスの量やweiの量を指定してください。
    詳細は :ref:`外部関数呼び出し<external-function-calls>` を参照してください。

メンバーの使用法を示す例:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.4 <0.9.0;

    contract Example {
        function f() public payable returns (bytes4) {
            assert(this.f.address == address(this));
            return this.f.selector;
        }

        function g() public {
            this.f{gas: 10, value: 800}();
        }
    }

内部関数型の使用法を示す例:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    library ArrayUtils {
        // 内部関数は、同じコードコンテキストの一部となるため、内部ライブラリ関数で使用できる
        function map(uint[] memory self, function (uint) pure returns (uint) f)
            internal
            pure
            returns (uint[] memory r)
        {
            r = new uint[](self.length);
            for (uint i = 0; i < self.length; i++) {
                r[i] = f(self[i]);
            }
        }

        function reduce(
            uint[] memory self,
            function (uint, uint) pure returns (uint) f
        )
            internal
            pure
            returns (uint r)
        {
            r = self[0];
            for (uint i = 1; i < self.length; i++) {
                r = f(r, self[i]);
            }
        }

        function range(uint length) internal pure returns (uint[] memory r) {
            r = new uint[](length);
            for (uint i = 0; i < r.length; i++) {
                r[i] = i;
            }
        }
    }

    contract Pyramid {
        using ArrayUtils for *;

        function pyramid(uint l) public pure returns (uint) {
            return ArrayUtils.range(l).map(square).reduce(sum);
        }

        function square(uint x) internal pure returns (uint) {
            return x * x;
        }

        function sum(uint x, uint y) internal pure returns (uint) {
            return x + y;
        }
    }

外部関数型を使用するもう一つの例: 

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.22 <0.9.0;

    contract Oracle {
        struct Request {
            bytes data;
            function(uint) external callback;
        }

        Request[] private requests;
        event NewRequest(uint);

        function query(bytes memory data, function(uint) external callback) public {
            requests.push(Request(data, callback));
            emit NewRequest(requests.length - 1);
        }

        function reply(uint requestID, uint response) public {
            // Here goes the check that the reply comes from a trusted source
            requests[requestID].callback(response);
        }
    }

    contract OracleUser {
        Oracle constant private ORACLE_CONST = Oracle(address(0x00000000219ab540356cBB839Cbe05303d7705Fa)); // known contract
        uint private exchangeRate;

        function buySomething() public {
            ORACLE_CONST.query("USD", this.oracleResponse);
        }

        function oracleResponse(uint response) public {
            require(
                msg.sender == address(ORACLE_CONST),
                "Only oracle can call this."
            );
            exchangeRate = response;
        }
    }

.. note::

    ラムダ関数やインライン関数が予定されていますが、まだサポートされていません。
