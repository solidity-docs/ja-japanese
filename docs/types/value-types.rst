.. index:: ! value type, ! type;value
.. _value-types:

値型
===========

以下の型は、変数が常に値で渡される、つまり、関数の引数や代入で使われるときに常にコピーされることから、値型とも呼ばれます。

.. index:: ! bool, ! true, ! false

ブーリアン
------------

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
--------

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

  Solidityの整数は、ある範囲に制限されています。例えば、 ``uint32`` の場合、 ``0`` から ``2**32 - 1`` までとなります。
  これらの型に対して算術演算を行うには2つのモードがあります。"ラッピング"または"チェックなし"モードと"チェックあり"モードです。
  デフォルトでは、演算は常に"チェック"されます。
  つまり、演算結果が型の値の範囲外になると、呼び出しは :ref:`failing assertion<assert-and-require>` で戻されます。
  ``unchecked { ... }`` を使って"チェックなし"モードに切り替えることができます。詳細は :ref:`unchecked <unchecked>` の項を参照してください。

比較
^^^^^^^^^^^

比較の値は、整数値を比較して得られる値です。

ビット演算
^^^^^^^^^^^^^^

ビット演算は、数値の2の補数表現に対して行われます。
これは例えば、 ``~int256(0) == int256(-1)`` だということです。

シフト
^^^^^^

シフト演算の結果は、左オペランドの型を持ち、型に合わせて結果を切り捨てます。
右のオペランドは符号なしの型でなければならず、符号ありの型でシフトしようとするとコンパイルエラーになります。

シフトは、以下の方法で2の累乗を使って"シミュレート"できます。なお、左オペランドの型への切り捨ては常に最後に行われますが、明示的には言及されていません。
-  ``x << y`` は数学的表現で ``x * 2**y`` に相当します。
-  ``x >> y`` は、数学的表現で ``x / 2**y`` を負の無限大に向けて丸めたものに相当します。

.. warning::

    バージョン ``0.5.0`` 以前では、負の ``x`` の右シフト ``x >> y`` は、ゼロに向かって丸められた数学的表現 ``x / 2**y`` に相当していました。
    つまり、右シフトでは、（負の無限大に向かって）切り捨てるのではなく、（ゼロに向かって）切り上げられていたのです。

.. note::

    シフト演算では、算術演算のようなオーバーフローチェックが行われません。
    その代わり、結果は常に切り捨てられます。

加算、減算、乗算
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
^^^^^^^^

演算の結果の型は常にオペランドの1つの型であるため、整数の除算は常に整数になります。
Solidityでは、除算はゼロに向かって丸められます。
これは、 ``int256(-5) / int256(2) == int256(-2)`` を意味します。

これに対し、 :ref:`literals<rational_literals>` での除算では、任意の精度の分数値が得られることに注意してください。

.. note::

  ゼロによる除算は、 :ref:`パニックエラー<assert-and-require>` を引き起こします。このチェックは ``unchecked { ... }`` で無効にできます。

.. note::

  ``type(int).min / (-1)`` という式は、除算でオーバーフローが発生する唯一のケースです。
  チェックされた算術モードでは、これは失敗したアサーションを引き起こしますが、ラッピングモードでは、値は ``type(int).min`` になります。

モジュロ
^^^^^^^^^^^^

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
^^^^^^^^^^^^^^

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
-------------------

.. warning::

    固定小数点数はSolidityではまだ完全にはサポートされていません。宣言できますが、代入したり、代入解除したりできません。

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
-----------

アドレスタイプには2つの種類がありますが、ほとんど同じです。
-  ``address``: 20バイトの値（Ethereumのアドレスのサイズ）を保持します。
-  ``address payable``:  ``address`` と同じですが、メンバの ``transfer`` と ``send`` が追加されます。

この区別の背景にある考え方は、 ``address payable`` はEtherを送ることができるアドレスであるのに対し、プレーン ``address`` はEtherを送ることができないということです。

型変換:

``address payable`` から ``address`` への暗黙の変換は許されますが、 ``address`` から ``address payable`` への変換は ``payable(<address>)`` を介して明示的に行う必要があります。

``uint160`` 、整数リテラル、 ``bytes20`` 、コントラクト型については、 ``address`` との明示的な変換が可能です。

``address`` 型とコントラクト型の式のみが、明示的な変換 ``payable(...)`` によって ``address payable`` 型に変換できます。
コントラクト型については、コントラクトがEtherを受信できる場合、つまりコントラクトが :ref:`receive <receive-ether-function>` またはpayableのフォールバック関数を持っている場合にのみ、この変換が可能です。
``payable(0)`` は有効であり、このルールの例外であることに注意してください。

.. note::

    ``address`` 型の変数が必要で、その変数にEtherを送ろうと思っているなら、その変数の型を ``address payable`` と宣言して、この要求を見えるようにします。
    また、この区別や変換はできるだけ早い段階で行うようにしてください。

演算子:
* ``<=``, ``<``, ``==``,  ``!=``, ``>=``, ``>``

.. warning::

    より大きなバイトサイズを使用する型、例えば ``bytes32`` などを ``address`` に変換した場合、 ``address`` は切り捨てられます。
    変換の曖昧さを減らすために、バージョン0.4.24以降のコンパイラでは、変換時に切り捨てを明示するようになっています。
    例えば、32バイトの値 ``0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC`` を考えてみましょう。

    ``address(uint160(bytes20(b)))`` を使うと ``0x111122223333444455556666777788889999aAaa`` になり、 ``address(uint160(uint256(b)))`` を使うと ``0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc`` になります。

.. note::

    ``address`` と ``address payable`` の区別は、バージョン0.5.0から導入されました。
    また、このバージョンから、コントラクトはアドレス型から派生しませんが、receiveまたはpayableのフォールバック関数があれば、明示的に ``address`` または ``address payable`` に変換できます。

.. _members-of-addresses:

アドレスのメンバ
^^^^^^^^^^^^^^^^^^^^

全メンバーのアドレスの早見表は、 :ref:`address_related` をご覧ください。

* ``balance`` と ``transfer``

プロパティ ``balance`` を使ってアドレスの残高を照会したり、 ``transfer`` 関数を使って支払先のアドレスにイーサ（wei単位）を送信したりすることが可能です。

.. code-block:: solidity
    :force:

    address payable x = payable(0x123);
    address myAddress = address(this);
    if (x.balance < 10 && myAddress.balance >= 10) x.transfer(10);

``transfer`` 関数は、現在のコントラクトの残高が十分でない場合や、Ether送金が受信アカウントで拒否された場合に失敗します。
``transfer`` 関数は失敗すると元に戻ります。

.. note::

    ``x`` がコントラクトアドレスの場合、そのコード（具体的には、 :ref:`receive-ether-function` があればその :ref:`receive-ether-function` 、 :ref:`fallback-function` があればその :ref:`fallback-function` ）が ``transfer`` コールとともに実行されます（これはEVMの機能であり、防ぐことはできません）。
    その実行がガス欠になるか、何らかの形で失敗した場合、Ether送金は元に戻され、現在のコントラクトは例外的に停止します。

* ``send``

Sendは、 ``transfer`` の低レベルのカウンターパートです。
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

最後に、これらの修飾子は組み合わせることができます。その順番は問題ではありません。

.. code-block:: solidity

    address(nameReg).call{gas: 1000000, value: 1 ether}(abi.encodeWithSignature("register(string)", "MyName"));

同様の方法で、関数 ``delegatecall`` を使用できます。
違いは、与えられたアドレスのコードのみが使用され、他のすべての側面（ストレージ、残高、...）は、現在のコントラクトから取得されます。
``delegatecall`` の目的は、別のコントラクトに保存されているライブラリコードを使用することです。
ユーザーは、両方のコントラクトのストレージのレイアウトが、delegatecallを使用するのに適していることを確認しなければなりません。

.. note::

    Homestead以前のバージョンでは、 ``callcode`` という限定されたバリアントのみが利用可能で、オリジナルの ``msg.sender`` と ``msg.value`` の値にアクセスできませんでした。この関数はバージョン0.5.0で削除されました。

Byzantiumから ``staticcall`` も使えるようになりました。
これは基本的に ``call`` と同じですが、呼び出された関数が何らかの形で状態を変更するとリバートされます。

``call``、 ``delegatecall``、 ``staticcall`` の3つの関数は、非常に低レベルな関数で、Solidityの型安全性を壊してしまうため、 *最後の手段* としてのみ使用してください。

``gas`` オプションは3つの方式すべてで利用できますが、 ``value`` オプションは ``call`` でのみ利用できます。

.. note::

    スマートコントラクトのコードでは、状態の読み書きにかかわらず、ハードコードされたガスの値に依存することは、多くの落とし穴があるので避けたほうがよいでしょう。
    また、ガスへのアクセスが将来的に変わる可能性もあります。

.. note::

    すべてのコントラクトは ``address`` タイプに変換できるので、 ``address(this).balance`` を使って現在のコントラクトの残高を照会することが可能です。

.. index:: ! contract type, ! type; contract

.. _contract_types:

コントラクト型
--------------

すべての :ref:`コントラクト<contracts>` はそれ自身の型を定義します。
コントラクトを、それらが継承するコントラクトに暗黙的に変換できます。
コントラクトは、 ``address`` 型との間で明示的に変換できます。

``address payable`` タイプとの間の明示的な変換は、コントラクトタイプにreceiveまたはpayableのフォールバック関数がある場合にのみ可能です。
変換は ``address(x)`` を使用して行われます。
コントラクトタイプにreceiveまたはpayment fallback関数がない場合、 ``address payable`` への変換は ``payable(address(x))`` を使用して行うことができます。
詳細は、:ref:`アドレス型<address>` の項を参照してください。

.. note::

    バージョン0.5.0以前は、コントラクトはアドレスタイプから直接派生し、 ``address`` と ``address payable`` の区別はありませんでした。

コントラクト型（ ``MyContract c`` ）のローカル変数を宣言すると、そのコントラクトで関数を呼び出すことができます。
ただし、同じコントラクト型のどこかから代入するように注意してください。

また、コントラクトをインスタンス化することもできます（新規に作成することを意味します）。
詳細は :ref:`'Contracts via new'<creating-contracts>` の項を参照してください。

コントラクトのデータ表現は ``address`` 型と同じで、このタイプは :ref:`ABI<ABI>` でも使用されています。

コントラクトは、いかなる演算子もサポートしません。

コントラクト型のメンバは、 ``public`` とマークされたステート変数を含むコントラクトの外部関数です。

コントラクト ``C`` の場合は、 ``type(C)`` を使ってコントラクトに関する :ref:`型情報<meta-type>` にアクセスできます。

.. index:: byte array, bytes32

固定長バイト列
----------------------

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
----------------------------

``bytes``: 動的なサイズのバイト配列、 :ref:`arrays` を参照。値型ではありません。
``string``: 動的サイズのUTF-8エンコードされた文字列で、 :ref:`arrays` を参照。値型ではありません。

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
-----------------------------

整数リテラルは、0～9の範囲の数字の列で構成されます。
小数点以下の数字として解釈されます。例えば、 ``69`` は69を意味します。
Solidityには8進数のリテラルは存在せず、先頭のゼロは無効です。

小数点以下のリテラルは、片側に少なくとも1つの数字を持つ ``.`` で形成されます。  例えば、 ``1.`` 、 ``.1`` 、 ``1.3`` などです。

科学的表記（指数表記）にも対応しており、基数には分数を含めることができますが、指数には含めることができません。
例としては、 ``2e10`` 、 ``-2e10`` 、 ``2e-10`` 、 ``2.5e1`` などがあります。

アンダースコアは、読みやすくするために数値リテラルの桁を区切るのに使用できます。
例えば、10進法の ``123_000`` 、16進法の ``0x2eff_abde`` 、科学的10進法の ``1_2e345_678`` はすべて有効です。
アンダースコアは2つの数字の間にのみ使用でき、連続したアンダースコアは1つしか使用できません。
アンダースコアを含む数値リテラルには、追加の意味はなく、アンダースコアは無視されます。

数リテラル式は、非リテラル型に変換されるまで（非リテラル式との併用や明示的な変換など）、任意の精度を保ちます。
このため、数値リテラル式では、計算がオーバーフローしたり、除算が切り捨てられたりすることはありません。

例えば、 ``(2**800 + 1) - 2**800`` の結果は定数 ``1`` （ ``uint8`` 型）になりますが、中間の結果はマシンのワードサイズに収まりません。さらに、 ``.5 * 8`` の結果は整数の ``4`` になります（ただし、その間には非整数が使われています）。

整数に適用できる演算子は、オペランドが整数であれば、数リテラル式にも適用できます。
2つのうちいずれかが小数の場合、ビット演算は許可されず、指数が小数の場合、指数演算は許可されません（非有理数になってしまう可能性があるため）。

リテラル数を左（またはベース）オペランドとし、整数型を右（指数）オペランドとするシフトと指数計算は、右（指数）オペランドの型にかかわらず、常に ``uint256`` （非負のリテラルの場合）または ``int256`` （負のリテラルの場合）型で実行されます。

.. warning::

    バージョン0.4.0以前のSolidityでは、整数リテラルの除算は切り捨てられていましたが、有理数に変換されるようになりました。つまり、 ``5 / 2`` は ``2`` とはならず、 ``2.5`` となります。

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
-------------------------

.. String literals are written with either double or single-quotes (``"foo"`` or ``'bar'``), and they can also be split into multiple consecutive parts (``"foo" "bar"`` is equivalent to ``"foobar"``) which can be helpful when dealing with long strings.  They do not imply trailing zeroes as in C; ``"foo"`` represents three bytes, not four.  As with integer literals, their type can vary, but they are implicitly convertible to ``bytes1``, ..., ``bytes32``, if they fit, to ``bytes`` and to ``string``.

文字列リテラルは、ダブルクオートまたはシングルクオート（ ``"foo"`` または ``'bar'`` ）で記述され、連続した複数の部分に分割することもできます（ ``"foo" "bar"`` は ``"foobar"`` に相当）。これは長い文字列を扱う際に便利です。
また、C言語のように末尾にゼロを付けることはなく、 ``"foo"`` は4バイトではなく3バイトを表します。
整数リテラルと同様に、その型は様々ですが、 ``bytes1`` , ...,  ``bytes32`` に暗黙のうちに変換され、それが適合する場合は、 ``bytes`` や ``string`` に変換されます。

.. For example, with ``bytes32 samevar = "stringliteral"`` the string literal is interpreted in its raw byte form when assigned to a ``bytes32`` type.

例えば、 ``bytes32 samevar = "stringliteral"`` では文字列リテラルが ``bytes32`` タイプに割り当てられると、生のバイト形式で解釈されます。

.. String literals can only contain printable ASCII characters, which means the characters between and including 0x20 .. 0x7E.

文字列リテラルには、印刷可能なASCII文字のみを含めることができます。つまり、0x20から0x7Eまでの文字です。

.. Additionally, string literals also support the following escape characters:

さらに、文字列リテラルは以下のエスケープ文字にも対応しています。

.. - ``\<newline>`` (escapes an actual newline)

-  ``\<newline>``  (実際の改行をエスケープ)

.. - ``\\`` (backslash)

-  ``\\`` (バックスラッシュ)

.. - ``\'`` (single quote)

-  ``\'`` （シングルクォート）

.. - ``\"`` (double quote)

-  ``\"`` (ダブルクォート)

.. - ``\n`` (newline)

-  ``\n`` (ニューライン)

.. - ``\r`` (carriage return)

-  ``\r`` （キャリッジリターン）

.. - ``\t`` (tab)

-  ``\t`` （タブ）

.. - ``\xNN`` (hex escape, see below)

-  ``\xNN`` (ヘックスエスケープ、下記参照)

.. - ``\uNNNN`` (unicode escape, see below)

-  ``\uNNNN`` （ユニコードエスケープ、下記参照）

.. ``\xNN`` takes a hex value and inserts the appropriate byte, while ``\uNNNN`` takes a Unicode codepoint and inserts an UTF-8 sequence.

``\xNN`` は16進数の値を受け取り、適切なバイトを挿入します。 ``\uNNNN`` はUnicodeコードポイントを受け取り、UTF-8シーケンスを挿入します。

.. .. note::

..     Until version 0.8.0 there were three additional escape sequences: ``\b``, ``\f`` and ``\v``.
..     They are commonly available in other languages but rarely needed in practice.
..     If you do need them, they can still be inserted via hexadecimal escapes, i.e. ``\x08``, ``\x0c``
..     and ``\x0b``, respectively, just as any other ASCII character.

.. note::

    バージョン0.8.0までは、さらに3つのエスケープシーケンスがありました。 ``\b`` 、 ``\f`` 、 ``\v`` です。     これらは他の言語ではよく使われていますが、実際にはほとんど必要ありません。     もし必要であれば、他のASCII文字と同じように16進数のエスケープ、すなわち ``\x08`` 、 ``\x0c`` 、 ``\x0b`` を使って挿入できます。

.. The string in the following example has a length of ten bytes.
.. It starts with a newline byte, followed by a double quote, a single
.. quote a backslash character and then (without separator) the
.. character sequence ``abcdef``.

次の例の文字列の長さは10バイトです。この文字列は、改行バイトで始まり、ダブルクォート、シングルクォート、バックスラッシュ文字、そして（セパレータなしで）文字列 ``abcdef`` が続きます。

.. code-block:: solidity
    :force:

    "\n\"\'\\abc\
    def"

.. Any Unicode line terminator which is not a newline (i.e. LF, VF, FF, CR, NEL, LS, PS) is considered to
.. terminate the string literal. Newline only terminates the string literal if it is not preceded by a ``\``.

改行ではない Unicode の行終端記号（LF、VF、FF、CR、NEL、LS、PS など）は、文字列リテラルを終了するものとみなされます。改行が文字列リテラルを終了させるのは、その前に ``\`` がない場合のみです。

Unicode Literals
----------------

.. While regular string literals can only contain ASCII, Unicode literals – prefixed with the keyword ``unicode`` – can contain any valid UTF-8 sequence.
.. They also support the very same escape sequences as regular string literals.

通常の文字列リテラルはASCIIのみを含むことができますが、Unicodeリテラル（キーワード ``unicode`` を前に付けたもの）は、有効なUTF-8シーケンスを含むことができます。また、Unicodeリテラルは、通常の文字列リテラルと同じエスケープシーケンスにも対応しています。

.. code-block:: solidity

    string memory a = unicode"Hello 😃";

.. index:: literal, bytes

Hexadecimal Literals
--------------------

.. Hexadecimal literals are prefixed with the keyword ``hex`` and are enclosed in double
.. or single-quotes (``hex"001122FF"``, ``hex'0011_22_FF'``). Their content must be
.. hexadecimal digits which can optionally use a single underscore as separator between
.. byte boundaries. The value of the literal will be the binary representation
.. of the hexadecimal sequence.

16進数リテラルは、キーワード ``hex`` を前に付け、ダブルクオートまたはシングルクオートで囲みます（ ``hex"001122FF"`` 、 ``hex'0011_22_FF'`` ）。リテラルの内容は16進数でなければならず、バイト境界のセパレータとしてアンダースコアを1つ使用することも可能です。リテラルの値は、16進数を2進数で表現したものになります。

.. Multiple hexadecimal literals separated by whitespace are concatenated into a single literal:
.. ``hex"00112233" hex"44556677"`` is equivalent to ``hex"0011223344556677"``

空白で区切られた複数の16進数リテラルが、1つのリテラルに連結されます。 ``hex"00112233" hex"44556677"`` は ``hex"0011223344556677"`` と同じです。

.. Hexadecimal literals behave like :ref:`string literals <string_literals>` and have the same convertibility restrictions.

16進数のリテラルは、 :ref:`string literals <string_literals>` と同じように動作し、同じような変換の制限があります。

.. index:: enum

.. _enums:

Enums
-----

.. Enums are one way to create a user-defined type in Solidity. They are explicitly convertible
.. to and from all integer types but implicit conversion is not allowed.  The explicit conversion
.. from integer checks at runtime that the value lies inside the range of the enum and causes a
.. :ref:`Panic error<assert-and-require>` otherwise.
.. Enums require at least one member, and its default value when declared is the first member.
.. Enums cannot have more than 256 members.

EnumはSolidityでユーザー定義型を作成する一つの方法です。すべての整数型との間で明示的に変換できますが、暗黙的な変換はできません。  整数型からの明示的な変換は、実行時に値が列挙型の範囲内にあるかどうかをチェックし、そうでない場合は :ref:`Panic error<assert-and-require>` を発生させます。列挙型は少なくとも1つのメンバーを必要とし、宣言時のデフォルト値は最初のメンバーです。列挙型は256以上のメンバーを持つことはできません。

.. The data representation is the same as for enums in C: The options are represented by
.. subsequent unsigned integer values starting from ``0``.

データ表現は、C言語のenumと同じです。オプションは、 ``0`` から始まる後続の符号なし整数値で表されます。

.. Using ``type(NameOfEnum).min`` and ``type(NameOfEnum).max`` you can get the
.. smallest and respectively largest value of the given enum.

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

        // Since enum types are not part of the ABI, the signature of "getChoice"
        // will automatically be changed to "getChoice() returns (uint8)"
        // for all matters external to Solidity.
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

.. .. note::

..     Enums can also be declared on the file level, outside of contract or library definitions.

.. note::

    Enumは、コントラクトやライブラリの定義とは別に、ファイルレベルで宣言することもできます。

.. index:: ! user defined value type, custom type

.. _user-defined-value-types:

User Defined Value Types
------------------------

.. A user defined value type allows creating a zero cost abstraction over an elementary value type.
.. This is similar to an alias, but with stricter type requirements.

ユーザー定義の値型は、基本的な値型をゼロコストで抽象化して作成できます。これは、エイリアスに似ていますが、型の要件がより厳しくなっています。

.. A user defined value type is defined using ``type C is V``, where ``C`` is the name of the newly
.. introduced type and ``V`` has to be a built-in value type (the "underlying type"). The function
.. ``C.wrap`` is used to convert from the underlying type to the custom type. Similarly, the
.. function ``C.unwrap`` is used to convert from the custom type to the underlying type.

ユーザー定義の値の型は、 ``type C is V`` を使って定義されます。 ``C`` は新しく導入される型の名前で、 ``V`` は組み込みの値の型（「基礎となる型」）でなければなりません。関数 ``C.wrap`` は、基礎となる型からカスタム型への変換に使用されます。同様に、関数 ``C.unwrap`` はカスタムタイプから基礎タイプへの変換に使用されます。

.. The type ``C`` does not have any operators or bound member functions. In particular, even the
.. operator ``==`` is not defined. Explicit and implicit conversions to and from other types are
.. disallowed.

``C`` 型には、演算子やバインドされたメンバ関数がありません。特に、演算子 ``==`` も定義されていません。他の型との間の明示的および暗黙的な変換は許されません。

.. The data-representation of values of such types are inherited from the underlying type
.. and the underlying type is also used in the ABI.

このような型の値のデータ表現は、基礎となる型から継承され、基礎となる型はABIでも使用されます。

.. The following example illustrates a custom type ``UFixed256x18`` representing a decimal fixed point
.. type with 18 decimals and a minimal library to do arithmetic operations on the type.

次の例では、18桁の10進数固定小数点型を表すカスタム型 ``UFixed256x18`` と、その型に対して算術演算を行うための最小限のライブラリを示しています。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.8;

    // Represent a 18 decimal, 256 bit wide fixed point type using a user defined value type.
    type UFixed256x18 is uint256;

    /// A minimal library to do fixed point operations on UFixed256x18.
    library FixedMath {
        uint constant multiplier = 10**18;

        /// Adds two UFixed256x18 numbers. Reverts on overflow, relying on checked
        /// arithmetic on uint256.
        function add(UFixed256x18 a, UFixed256x18 b) internal pure returns (UFixed256x18) {
            return UFixed256x18.wrap(UFixed256x18.unwrap(a) + UFixed256x18.unwrap(b));
        }
        /// Multiplies UFixed256x18 and uint256. Reverts on overflow, relying on checked
        /// arithmetic on uint256.
        function mul(UFixed256x18 a, uint256 b) internal pure returns (UFixed256x18) {
            return UFixed256x18.wrap(UFixed256x18.unwrap(a) * b);
        }
        /// Take the floor of a UFixed256x18 number.
        /// @return the largest integer that does not exceed `a`.
        function floor(UFixed256x18 a) internal pure returns (uint256) {
            return UFixed256x18.unwrap(a) / multiplier;
        }
        /// Turns a uint256 into a UFixed256x18 of the same value.
        /// Reverts if the integer is too large.
        function toUFixed256x18(uint256 a) internal pure returns (UFixed256x18) {
            return UFixed256x18.wrap(a * multiplier);
        }
    }

.. Notice how ``UFixed256x18.wrap`` and ``FixedMath.toUFixed256x18`` have the same signature but
.. perform two very different operations: The ``UFixed256x18.wrap`` function returns a ``UFixed256x18``
.. that has the same data representation as the input, whereas ``toUFixed256x18`` returns a
.. ``UFixed256x18`` that has the same numerical value.

``UFixed256x18.wrap`` と ``FixedMath.toUFixed256x18`` は同じ署名を持っていますが、全く異なる2つの処理を行っていることに注目してください。 ``UFixed256x18.wrap`` 関数は入力と同じデータ表現の ``UFixed256x18`` を返すのに対し、 ``toUFixed256x18`` は同じ数値を持つ ``UFixed256x18`` を返します。

.. index:: ! function type, ! type; function

.. _function_types:

Function Types
--------------

.. Function types are the types of functions. Variables of function type
.. can be assigned from functions and function parameters of function type
.. can be used to pass functions to and return functions from function calls.
.. Function types come in two flavours - *internal* and *external* functions:

関数型は、関数の型です。関数型の変数は、関数から代入でき、関数型のパラメータは、関数呼び出しに関数を渡したり、関数呼び出しから関数を返したりするのに使われます。関数型には、 *内部* 関数と *外部* 関数の2種類があります。

.. Internal functions can only be called inside the current contract (more specifically,
.. inside the current code unit, which also includes internal library functions
.. and inherited functions) because they cannot be executed outside of the
.. context of the current contract. Calling an internal function is realized
.. by jumping to its entry label, just like when calling a function of the current
.. contract internally.

内部関数は、現在のコントラクトのコンテキストの外では実行できないため、現在のコントラクトの内部（より具体的には、現在のコードユニットの内部で、内部ライブラリ関数や継承された関数も含む）でのみ呼び出すことができます。内部関数の呼び出しは、現在のコントラクトの関数を内部で呼び出す場合と同様に、そのエントリーラベルにジャンプすることで実現します。

.. External functions consist of an address and a function signature and they can
.. be passed via and returned from external function calls.

外部関数は、アドレスと関数シグネチャで構成されており、外部関数呼び出しを介して渡したり、外部関数呼び出しから返したりできます。

.. Function types are notated as follows:

関数タイプは以下のように表記されています。

.. code-block:: solidity
    :force:

    function (<parameter types>) {internal|external} [pure|view|payable] [returns (<return types>)]

.. In contrast to the parameter types, the return types cannot be empty - if the
.. function type should not return anything, the whole ``returns (<return types>)``
.. part has to be omitted.

パラメータ型とは対照的に、リターン型は空にできません。関数型が何も返さない場合は、 ``returns (<return types>)`` の部分をすべて省略しなければなりません。

.. By default, function types are internal, so the ``internal`` keyword can be
.. omitted. Note that this only applies to function types. Visibility has
.. to be specified explicitly for functions defined in contracts, they
.. do not have a default.

デフォルトでは、関数型は内部的なものなので、 ``internal`` キーワードは省略できます。これは関数型にのみ適用されることに注意してください。コントラクトで定義された関数については、可視性を明示的に指定する必要があり、デフォルトはありません。

.. Conversions:

Conversions:

.. A function type ``A`` is implicitly convertible to a function type ``B`` if and only if
.. their parameter types are identical, their return types are identical,
.. their internal/external property is identical and the state mutability of ``A``
.. is more restrictive than the state mutability of ``B``. In particular:

関数型 ``A`` は、それらのパラメータ型が同一であり、戻り値の型が同一であり、それらの内部/外部プロパティが同一であり、 ``A`` の状態の変更可能性が ``B`` の状態の変更可能性よりも制限されている場合に限り、関数型 ``B`` に暗黙的に変換可能です。具体的には

.. - ``pure`` functions can be converted to ``view`` and ``non-payable`` functions

-  ``pure`` 関数を ``view`` 、 ``non-payable`` 関数に変換可能

.. - ``view`` functions can be converted to ``non-payable`` functions

-  ``view`` 関数から ``non-payable`` 関数への変換が可能

.. - ``payable`` functions can be converted to ``non-payable`` functions

-  ``payable`` 関数から ``non-payable`` 関数への変換が可能

.. No other conversions between function types are possible.

それ以外の関数型間の変換はできません。

.. The rule about ``payable`` and ``non-payable`` might be a little
.. confusing, but in essence, if a function is ``payable``, this means that it
.. also accepts a payment of zero Ether, so it also is ``non-payable``.
.. On the other hand, a ``non-payable`` function will reject Ether sent to it,
.. so ``non-payable`` functions cannot be converted to ``payable`` functions.

``payable`` と ``non-payable`` のルールは少しわかりにくいかもしれませんが、要するにある関数が ``payable`` であれば、ゼロのEtherの支払いも受け入れるということなので、 ``non-payable`` でもあるということです。一方、 ``non-payable`` 関数は送られてきたEtherを拒否しますので、 ``non-payable`` 関数を ``payable`` 関数に変換できません。

.. If a function type variable is not initialised, calling it results
.. in a :ref:`Panic error<assert-and-require>`. The same happens if you call a function after using ``delete``
.. on it.

関数型変数が初期化されていない場合、それを呼び出すと :ref:`Panic error<assert-and-require>` になります。また、関数に ``delete`` を使用した後に関数を呼び出した場合も同様です。

.. If external function types are used outside of the context of Solidity,
.. they are treated as the ``function`` type, which encodes the address
.. followed by the function identifier together in a single ``bytes24`` type.

外部関数型がSolidityのコンテキスト外で使用される場合は、 ``function`` 型として扱われ、アドレスに続いて関数識別子をまとめて1つの ``bytes24`` 型にエンコードします。

.. Note that public functions of the current contract can be used both as an
.. internal and as an external function. To use ``f`` as an internal function,
.. just use ``f``, if you want to use its external form, use ``this.f``.

現在のコントラクトのパブリック関数は、内部関数としても外部関数としても使用できることに注意してください。 ``f`` を内部関数として使用したい場合は ``f`` を、外部関数として使用したい場合は ``this.f`` を使用してください。

.. A function of an internal type can be assigned to a variable of an internal function type regardless
.. of where it is defined.
.. This includes private, internal and public functions of both contracts and libraries as well as free
.. functions.
.. External function types, on the other hand, are only compatible with public and external contract
.. functions.
.. Libraries are excluded because they require a ``delegatecall`` and use :ref:`a different ABI
.. convention for their selectors <library-selectors>`.
.. Functions declared in interfaces do not have definitions so pointing at them does not make sense either.

内部型の関数は、どこで定義されているかに関わらず、内部関数型の変数に代入できます。これには、コントラクトとライブラリの両方のプライベート関数、内部関数、パブリック関数のほか、フリー関数も含まれます。一方、外部関数型は、パブリック関数と外部コントラクト関数にのみ対応しています。ライブラリは、 ``delegatecall`` とuse  :ref:`a different ABI convention for their selectors <library-selectors>` を必要とするため、除外されます。インターフェースで宣言された関数は定義を持たないので、それを指し示すことも意味がありません。

.. Members:

メンバーです。

.. External (or public) functions have the following members:

外部（またはパブリック）関数には、次のようなメンバーを持ちます。

.. * ``.address`` returns the address of the contract of the function.

* ``.address`` は、関数のコントラクトのアドレスを返します。

.. * ``.selector`` returns the :ref:`ABI function selector <abi_function_selector>`

* ``.selector`` が :ref:`ABI function selector <abi_function_selector>` を返します。

.. .. note::

..   External (or public) functions used to have the additional members
..   ``.gas(uint)`` and ``.value(uint)``. These were deprecated in Solidity 0.6.2
..   and removed in Solidity 0.7.0. Instead use ``{gas: ...}`` and ``{value: ...}``
..   to specify the amount of gas or the amount of wei sent to a function,
..   respectively. See :ref:`External Function Calls <external-function-calls>` for
..   more information.

.. note::

  外部（またはパブリック）関数には、追加のメンバー ``.gas(uint)`` と ``.value(uint)`` がありました。これらはSolidity 0.6.2で非推奨となり、Solidity 0.7.0で削除されました。代わりに ``{gas: ...}`` と ``{value: ...}`` を使って、それぞれ関数に送られるガスの量やweiの量を指定してください。詳細は :ref:`External Function Calls <external-function-calls>` を参照してください。

.. Example that shows how to use the members:

メンバーの使用方法を示す例

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

.. Example that shows how to use internal function types:

内部関数型の使用方法を示す例です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    library ArrayUtils {
        // internal functions can be used in internal library functions because
        // they will be part of the same code context
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

.. Another example that uses external function types:

外部関数型を使用するもう一つの例です。

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
