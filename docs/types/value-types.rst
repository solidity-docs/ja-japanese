.. index:: ! value type, ! type;value
.. _value-types:

Value Types
===========

.. The following types are also called value types because variables of these
.. types will always be passed by value, i.e. they are always copied when they
.. are used as function arguments or in assignments.

以下の型は、変数が常に値で渡される、つまり、関数の引数や代入で使われるときに常にコピーされることから、値型とも呼ばれます。

.. index:: ! bool, ! true, ! false

Booleans
--------

.. ``bool``: The possible values are constants ``true`` and ``false``.

``bool`` : 可能な値は、定数 ``true`` と ``false`` です。

.. Operators:

オペレーターです。

.. * ``!`` (logical negation)

* ``!`` （ロジカルネガティブ）

.. * ``&&`` (logical conjunction, "and")

* ``&&`` （論理的接続、"and"）

.. * ``||`` (logical disjunction, "or")

* ``||`` （論理的論理和、"or"）

.. * ``==`` (equality)

* ``==`` （イコール）

.. * ``!=`` (inequality)

* ``!=`` （不等号）

.. The operators ``||`` and ``&&`` apply the common short-circuiting rules. This means that in the expression ``f(x) || g(y)``, if ``f(x)`` evaluates to ``true``, ``g(y)`` will not be evaluated even if it may have side-effects.

演算子 ``||`` と ``&&`` は、共通の短絡ルールを適用します。つまり、式 ``f(x) || g(y)`` において、 ``f(x)`` が ``true`` と評価された場合、 ``g(y)`` はたとえ副作用があったとしても評価されません。

.. index:: ! uint, ! int, ! integer
.. _integers:

Integers
--------

.. ``int`` / ``uint``: Signed and unsigned integers of various sizes. Keywords ``uint8`` to ``uint256`` in steps of ``8`` (unsigned of 8 up to 256 bits) and ``int8`` to ``int256``. ``uint`` and ``int`` are aliases for ``uint256`` and ``int256``, respectively.

``int``  /  ``uint`` : さまざまなサイズの符号付きおよび符号なし整数。キーワード ``uint8`` ～ ``uint256`` を ``8`` （8～256ビットの符号なし）、 ``int8`` ～ ``int256`` のステップで表したもの。 ``uint`` と ``int`` は、それぞれ ``uint256`` と ``int256`` の別名です。

.. Operators:

オペレーターです。

.. * Comparisons: ``<=``, ``<``, ``==``, ``!=``, ``>=``, ``>`` (evaluate to ``bool``)

* 比較対象 ``<=`` ,  ``<`` ,  ``==`` ,  ``!=`` ,  ``>=`` ,  ``>``  ( ``bool`` まで評価)

.. * Bit operators: ``&``, ``|``, ``^`` (bitwise exclusive or), ``~`` (bitwise negation)

* ビット演算子。 ``&`` 、 ``|`` 、 ``^`` （ビットごとの排他的論理和）、 ``~`` （ビットごとの否定）

.. * Shift operators: ``<<`` (left shift), ``>>`` (right shift)

* シフト演算子。 ``<<`` (左シフト)、 ``>>`` (右シフト)

.. * Arithmetic operators: ``+``, ``-``, unary ``-`` (only for signed integers), ``*``, ``/``, ``%`` (modulo), ``**`` (exponentiation)

* 算術演算子。 ``+`` 、 ``-`` 、単項 ``-`` （符号付き整数の場合のみ）、 ``*`` 、 ``/`` 、 ``%`` （モジュロ）、 ``**`` （指数化）

.. For an integer type ``X``, you can use ``type(X).min`` and ``type(X).max`` to
.. access the minimum and maximum value representable by the type.

整数型の ``X`` の場合、 ``type(X).min`` と ``type(X).max`` を使って、その型で表現できる最小値と最大値にアクセスできます。

.. .. warning::

..   Integers in Solidity are restricted to a certain range. For example, with ``uint32``, this is ``0`` up to ``2**32 - 1``.
..   There are two modes in which arithmetic is performed on these types: The "wrapping" or "unchecked" mode and the "checked" mode.
..   By default, arithmetic is always "checked", which mean that if the result of an operation falls outside the value range
..   of the type, the call is reverted through a :ref:`failing assertion<assert-and-require>`. You can switch to "unchecked" mode
..   using ``unchecked { ... }``. More details can be found in the section about :ref:`unchecked <unchecked>`.

.. warning::

  Solidityの整数は、ある範囲に制限されています。例えば、 ``uint32`` の場合、 ``0`` から ``2**32 - 1`` までとなります。   これらの型に対して算術演算を行うには2つのモードがあります。折り返し」または「チェックなし」モードと「チェックあり」モードです。   デフォルトでは、演算は常に「チェック」されます。つまり、演算結果が型の値の範囲外になると、呼び出しは :ref:`failing assertion<assert-and-require>` で戻されます。 ``unchecked { ... }`` を使って「チェックなし」モードに切り替えることができます。詳細は :ref:`unchecked <unchecked>` の項を参照してください。

Comparisons
^^^^^^^^^^^

.. The value of a comparison is the one obtained by comparing the integer value.

比較の値は、整数値を比較して得られる値です。

Bit operations
^^^^^^^^^^^^^^

.. Bit operations are performed on the two's complement representation of the number.
.. This means that, for example ``~int256(0) == int256(-1)``.

ビット演算は、数値の2の補数表現に対して行われます。つまり、例えば、 ``~int256(0) == int256(-1)`` .

Shifts
^^^^^^

.. The result of a shift operation has the type of the left operand, truncating the result to match the type.
.. The right operand must be of unsigned type, trying to shift by a signed type will produce a compilation error.

シフト演算の結果は、左オペランドの型を持ち、型に合わせて結果を切り捨てます。右のオペランドは符号なしの型でなければならず、符号ありの型でシフトしようとするとコンパイルエラーになります。

.. Shifts can be "simulated" using multiplication by powers of two in the following way. Note that the truncation
.. to the type of the left operand is always performed at the end, but not mentioned explicitly.

シフトは、以下の方法で2の累乗を使って「シミュレート」できます。なお、左オペランドの型への切り捨ては常に最後に行われますが、明示的には言及されていません。

.. - ``x << y`` is equivalent to the mathematical expression ``x * 2**y``.

-  ``x << y`` は数学的な表現である ``x * 2**y`` に相当します。

.. - ``x >> y`` is equivalent to the mathematical expression ``x / 2**y``, rounded towards negative infinity.

-  ``x >> y`` は、数学の ``x / 2**y`` という表現を負の無限大に向けて丸めたものに相当します。

.. .. warning::

..     Before version ``0.5.0`` a right shift ``x >> y`` for negative ``x`` was equivalent to
..     the mathematical expression ``x / 2**y`` rounded towards zero,
..     i.e., right shifts used rounding up (towards zero) instead of rounding down (towards negative infinity).

.. warning::

    バージョン ``0.5.0`` 以前では、負の ``x`` の右シフト ``x >> y`` は、ゼロに向かって丸められた数学的表現 ``x / 2**y`` に相当していました。つまり、右シフトでは、（負の無限大に向かって）切り捨てるのではなく、（ゼロに向かって）切り上げられていたのです。

.. .. note::

..     Overflow checks are never performed for shift operations as they are done for arithmetic operations.
..     Instead, the result is always truncated.

.. note::

    シフト演算では、算術演算のようなオーバーフローチェックが行われません。     その代わり、結果は常に切り捨てられます。

Addition, Subtraction and Multiplication
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. Addition, subtraction and multiplication have the usual semantics, with two different
.. modes in regard to over- and underflow:

加算、減算、乗算には通常のセマンティクスがあり、オーバーフローとアンダーフローに関しては2つの異なるモードがあります。

.. By default, all arithmetic is checked for under- or overflow, but this can be disabled
.. using the :ref:`unchecked block<unchecked>`, resulting in wrapping arithmetic. More details
.. can be found in that section.

デフォルトでは、すべての演算はアンダーフローまたはオーバーフローをチェックしますが、 :ref:`unchecked block<unchecked>` を使ってこれを無効にでき、結果としてラッピング演算が行われます。詳細はこのセクションを参照してください。

.. The expression ``-x`` is equivalent to ``(T(0) - x)`` where
.. ``T`` is the type of ``x``. It can only be applied to signed types.
.. The value of ``-x`` can be
.. positive if ``x`` is negative. There is another caveat also resulting
.. from two's complement representation:

``-x`` という表現は、 ``T`` が ``x`` の型である ``(T(0) - x)`` と同等です。これは、符号付きの型にのみ適用できます。 ``x`` が負であれば、 ``-x`` の値は正になります。また、2の補数表現にはもう1つの注意点があります。

.. If you have ``int x = type(int).min;``, then ``-x`` does not fit the positive range.
.. This means that ``unchecked { assert(-x == x); }`` works, and the expression ``-x``
.. when used in checked mode will result in a failing assertion.

``int x = type(int).min;`` の場合は、 ``-x`` は正の範囲に当てはまりません。つまり、 ``unchecked { assert(-x == x); }`` は動作し、 ``-x`` という表現をcheckedモードで使用すると、アサーションが失敗するということになります。

Division
^^^^^^^^

.. Since the type of the result of an operation is always the type of one of
.. the operands, division on integers always results in an integer.
.. In Solidity, division rounds towards zero. This means that ``int256(-5) / int256(2) == int256(-2)``.

演算の結果の型は常にオペランドの1つの型であるため、整数の除算は常に整数になります。Solidityでは、除算はゼロに向かって丸められます。これは、 ``int256(-5) / int256(2) == int256(-2)`` .

.. Note that in contrast, division on :ref:`literals<rational_literals>` results in fractional values
.. of arbitrary precision.

これに対し、 :ref:`literals<rational_literals>` での分割では、任意の精度の分数値が得られることに注意してください。

.. .. note::

..   Division by zero causes a :ref:`Panic error<assert-and-require>`. This check can **not** be disabled through ``unchecked { ... }``.

.. note::

  ゼロによる除算は、 :ref:`Panic error<assert-and-require>` を引き起こします。このチェックは ``unchecked { ... }`` で無効にできます。

.. .. note::

..   The expression ``type(int).min / (-1)`` is the only case where division causes an overflow.
..   In checked arithmetic mode, this will cause a failing assertion, while in wrapping
..   mode, the value will be ``type(int).min``.

.. note::

  ``type(int).min / (-1)`` という式は、除算でオーバーフローが発生する唯一のケースです。   チェックされた算術モードでは、これは失敗したアサーションを引き起こしますが、ラッピング・モードでは、値は ``type(int).min`` になります。

Modulo
^^^^^^

.. The modulo operation ``a % n`` yields the remainder ``r`` after the division of the operand ``a``
.. by the operand ``n``, where ``q = int(a / n)`` and ``r = a - (n * q)``. This means that modulo
.. results in the same sign as its left operand (or zero) and ``a % n == -(-a % n)`` holds for negative ``a``:

モジュロ演算 ``a % n`` では、オペランド ``a`` をオペランド ``n`` で除算した後の余り ``r`` が得られますが、ここでは ``q = int(a / n)`` と ``r = a - (n * q)`` が使われています。つまり、モジュロの結果は左のオペランドと同じ符号（またはゼロ）になり、 ``a % n == -(-a % n)`` は負の ``a`` の場合も同様です。

.. * ``int256(5) % int256(2) == int256(1)``

* ``int256(5) % int256(2) == int256(1)``

.. * ``int256(5) % int256(-2) == int256(1)``

* ``int256(5) % int256(-2) == int256(1)``

.. * ``int256(-5) % int256(2) == int256(-1)``

* ``int256(-5) % int256(2) == int256(-1)``

.. * ``int256(-5) % int256(-2) == int256(-1)``

* ``int256(-5) % int256(-2) == int256(-1)``

.. .. note::

..   Modulo with zero causes a :ref:`Panic error<assert-and-require>`. This check can **not** be disabled through ``unchecked { ... }``.

.. note::

  ゼロでのモジュロは :ref:`Panic error<assert-and-require>` を引き起こす。このチェックは ``unchecked { ... }`` で無効にできます。

Exponentiation
^^^^^^^^^^^^^^

.. Exponentiation is only available for unsigned types in the exponent. The resulting type
.. of an exponentiation is always equal to the type of the base. Please take care that it is
.. large enough to hold the result and prepare for potential assertion failures or wrapping behaviour.

指数計算は、指数が符号なしの型の場合のみ可能です。指数計算の結果の型は、常に基底の型と同じです。結果を保持するのに十分な大きさであることに注意し、潜在的なアサーションの失敗やラッピングの動作に備えてください。

.. .. note::

..   In checked mode, exponentiation only uses the comparatively cheap ``exp`` opcode for small bases.
..   For the cases of ``x**3``, the expression ``x*x*x`` might be cheaper.
..   In any case, gas cost tests and the use of the optimizer are advisable.

.. note::

  チェックされたモードでは、指数計算は小さなベースに対して比較的安価な ``exp`` というオペコードしか使いません。    ``x**3`` の場合には ``x*x*x`` という表現の方が安いかもしれません。   いずれにしても、ガスコストのテストとオプティマイザの使用が望まれます。

.. .. note::

..   Note that ``0**0`` is defined by the EVM as ``1``.

.. note::

  なお、 ``0**0`` はEVMでは ``1`` と定義されています。

.. index:: ! ufixed, ! fixed, ! fixed point number

Fixed Point Numbers
-------------------

.. .. warning::

..     Fixed point numbers are not fully supported by Solidity yet. They can be declared, but
..     cannot be assigned to or from.

.. warning::

    固定小数点数はSolidityではまだ完全にはサポートされていません。宣言できますが、代入したり、代入解除したりできません。

.. ``fixed`` / ``ufixed``: Signed and unsigned fixed point number of various sizes. Keywords ``ufixedMxN`` and ``fixedMxN``, where ``M`` represents the number of bits taken by
.. the type and ``N`` represents how many decimal points are available. ``M`` must be divisible by 8 and goes from 8 to 256 bits. ``N`` must be between 0 and 80, inclusive.
.. ``ufixed`` and ``fixed`` are aliases for ``ufixed128x18`` and ``fixed128x18``, respectively.

``fixed``  /  ``ufixed`` : さまざまなサイズの符号付きおよび符号なしの固定小数点数。キーワード ``ufixedMxN`` と ``fixedMxN`` 、 ``M`` は型で取るビット数、 ``N`` は小数点以下の数を表します。 ``M`` は8で割り切れるものでなければならず、8から256ビットまであります。 ``N`` は0から80までの値でなければなりません。 ``ufixed`` と ``fixed`` は、それぞれ ``ufixed128x18`` と ``fixed128x18`` のエイリアスです。

.. Operators:

オペレーターです。

.. * Comparisons: ``<=``, ``<``, ``==``, ``!=``, ``>=``, ``>`` (evaluate to ``bool``)

* 比較対象 ``<=`` ,  ``<`` ,  ``==`` ,  ``!=`` ,  ``>=`` ,  ``>``  ( ``bool`` まで評価)

.. * Arithmetic operators: ``+``, ``-``, unary ``-``, ``*``, ``/``, ``%`` (modulo)

* 算術演算子。 ``+`` ,  ``-`` , unary  ``-`` ,  ``*`` ,  ``/`` ,  ``%``  (modulo)

.. .. note::

..     The main difference between floating point (``float`` and ``double`` in many languages, more precisely IEEE 754 numbers) and fixed point numbers is
..     that the number of bits used for the integer and the fractional part (the part after the decimal dot) is flexible in the former, while it is strictly
..     defined in the latter. Generally, in floating point almost the entire space is used to represent the number, while only a small number of bits define
..     where the decimal point is.

.. note::

    浮動小数点（多くの言語では ``float`` と ``double`` 、正確にはIEEE754の数値）と固定小数点の主な違いは、整数部と小数部（小数点以下の部分）に使用するビット数が、前者では柔軟に設定できるのに対し、後者では厳密に定義されていることです。一般に、浮動小数点では、ほぼすべての空間を使って数値を表現するが、小数点の位置を決めるのは少数のビットです。

.. index:: address, balance, send, call, delegatecall, staticcall, transfer

.. _address:

Address
-------

.. The address type comes in two flavours, which are largely identical:

アドレスタイプには2つの種類がありますが、ほとんど同じです。

<<<<<<< HEAD
.. - ``address``: Holds a 20 byte value (size of an Ethereum address).
=======
The idea behind this distinction is that ``address payable`` is an address you can send Ether to,
while you are not supposed to send Ether to a plain ``address``, for example because it might be a smart contract
that was not built to accept Ether.
>>>>>>> 800088e38b5835ebdc71e9ba5299a70a5accd7c2

-  ``address`` : 20バイトの値（Ethereumのアドレスのサイズ）を保持します。

.. - ``address payable``: Same as ``address``, but with the additional members ``transfer`` and ``send``.

-  ``address payable`` :  ``address`` と同じですが、メンバーの ``transfer`` と ``send`` が追加されます。

.. The idea behind this distinction is that ``address payable`` is an address you can send Ether to,
.. while a plain ``address`` cannot be sent Ether.

この区別の背景にある考え方は、 ``address payable`` はEtherを送ることができるアドレスであるのに対し、プレーン ``address`` はEtherを送ることができないということです。

.. Type conversions:

タイプ変換を行います。

.. Implicit conversions from ``address payable`` to ``address`` are allowed, whereas conversions from ``address`` to ``address payable``
.. must be explicit via ``payable(<address>)``.

``address payable`` から ``address`` への暗黙の変換は許されますが、 ``address`` から ``address payable`` への変換は ``payable(<address>)`` を介して明示的に行う必要があります。

.. Explicit conversions to and from ``address`` are allowed for ``uint160``, integer literals,
.. ``bytes20`` and contract types.

``uint160`` 、整数リテラル、 ``bytes20`` 、コントラクト型については、 ``address`` との明示的な変換が可能です。

.. Only expressions of type ``address`` and contract-type can be converted to the type ``address
.. payable`` via the explicit conversion ``payable(...)``. For contract-type, this conversion is only
.. allowed if the contract can receive Ether, i.e., the contract either has a :ref:`receive
.. <receive-ether-function>` or a payable fallback function. Note that ``payable(0)`` is valid and is
.. an exception to this rule.

``address`` 型とcontract-typeの式のみが、明示的な変換 ``payable(...)`` によって ``address payable`` 型に変換できます。contract-typeについては、コントラクトがEtherを受信できる場合、つまりコントラクトが :ref:`receive <receive-ether-function>` またはpayableのフォールバック関数を持っている場合にのみ、この変換が可能です。 ``payable(0)`` は有効であり、このルールの例外であることに注意してください。

.. .. note::

..     If you need a variable of type ``address`` and plan to send Ether to it, then
..     declare its type as ``address payable`` to make this requirement visible. Also,
..     try to make this distinction or conversion as early as possible.

.. note::

    ``address`` 型の変数が必要で、その変数にEtherを送ろうと思っているなら、その変数の型を ``address payable`` と宣言して、この要求を見えるようにします。また、この区別や変換はできるだけ早い段階で行うようにしてください。

.. Operators:

オペレーターです。

.. * ``<=``, ``<``, ``==``, ``!=``, ``>=`` and ``>``

* ``<=`` ,  ``<`` ,  ``==`` ,  ``!=`` ,  ``>=`` ,  ``>``

.. .. warning::

..     If you convert a type that uses a larger byte size to an ``address``, for example ``bytes32``, then the ``address`` is truncated.
..     To reduce conversion ambiguity version 0.4.24 and higher of the compiler force you make the truncation explicit in the conversion.
..     Take for example the 32-byte value ``0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC``.

..     You can use ``address(uint160(bytes20(b)))``, which results in ``0x111122223333444455556666777788889999aAaa``,
..     or you can use ``address(uint160(uint256(b)))``, which results in ``0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc``.

.. warning::

    より大きなバイトサイズを使用する型を  ``bytes32``  などの  ``address``  に変換した場合、 ``address``  は切り捨てられます。     変換の曖昧さを減らすために、バージョン0.4.24以降のコンパイラでは、変換時に切り捨てを明示するようになっています。     例えば、32バイトの値 ``0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC`` を考えてみましょう。

    ``address(uint160(bytes20(b)))`` を使うと ``0x111122223333444455556666777788889999aAaa`` になり、 ``address(uint160(uint256(b)))`` を使うと ``0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc`` になります。

.. .. note::

..     The distinction between ``address`` and ``address payable`` was introduced with version 0.5.0.
..     Also starting from that version, contracts do not derive from the address type, but can still be explicitly converted to
..     ``address`` or to ``address payable``, if they have a receive or payable fallback function.

.. note::

    ``address`` と ``address payable`` の区別は、バージョン0.5.0から導入されました。     また、このバージョンから、コントラクトはアドレス・タイプから派生しませんが、receiveまたはpayableのフォールバック関数があれば、明示的に ``address`` または ``address payable`` に変換できます。

.. _members-of-addresses:

Members of Addresses
^^^^^^^^^^^^^^^^^^^^

.. For a quick reference of all members of address, see :ref:`address_related`.

全メンバーのアドレスの早見表は、 :ref:`address_related` をご覧ください。

.. * ``balance`` and ``transfer``

* ``balance`` と ``transfer``

.. It is possible to query the balance of an address using the property ``balance``
.. and to send Ether (in units of wei) to a payable address using the ``transfer`` function:

プロパティ「 ``balance`` 」を使ってアドレスの残高を照会したり、「 ``transfer`` 」関数を使って支払先のアドレスにイーサ（wei単位）を送信したりすることが可能です。

.. code-block:: solidity
    :force:

    address payable x = payable(0x123);
    address myAddress = address(this);
    if (x.balance < 10 && myAddress.balance >= 10) x.transfer(10);

.. The ``transfer`` function fails if the balance of the current contract is not large enough
.. or if the Ether transfer is rejected by the receiving account. The ``transfer`` function
.. reverts on failure.

``transfer`` 関数は、現在のコントラクトの残高が十分でない場合や、Ether送金が受信アカウントで拒否された場合に失敗します。 ``transfer`` 関数は失敗すると元に戻ります。

.. .. note::

..     If ``x`` is a contract address, its code (more specifically: its :ref:`receive-ether-function`, if present, or otherwise its :ref:`fallback-function`, if present) will be executed together with the ``transfer`` call (this is a feature of the EVM and cannot be prevented). If that execution runs out of gas or fails in any way, the Ether transfer will be reverted and the current contract will stop with an exception.

.. note::

    ``x`` がコントラクトアドレスの場合、そのコード（具体的には、 :ref:`receive-ether-function` があればその :ref:`receive-ether-function` 、 :ref:`fallback-function` があればその :ref:`fallback-function` ）が ``transfer`` コールとともに実行されます（これはEVMの機能であり、防ぐことはできません）。その実行がガス欠になるか、何らかの形で失敗した場合、Ether送金は元に戻され、現在のコントラクトは例外的に停止します。

.. * ``send``

* ``send``

.. Send is the low-level counterpart of ``transfer``. If the execution fails, the current contract will not stop with an exception, but ``send`` will return ``false``.

Sendは、 ``transfer`` の低レベルのカウンターパートです。実行に失敗した場合、現在のコントラクトは例外的に停止しませんが、 ``send`` は ``false`` を返します。

.. .. warning::

..     There are some dangers in using ``send``: The transfer fails if the call stack depth is at 1024
..     (this can always be forced by the caller) and it also fails if the recipient runs out of gas. So in order
..     to make safe Ether transfers, always check the return value of ``send``, use ``transfer`` or even better:
..     use a pattern where the recipient withdraws the money.

.. warning::

    ``send`` の使用にはいくつかの危険性があります。コールスタックの深さが1024の場合（これは常に呼び出し側で強制できます）、送金は失敗し、また、受信者がガス欠になった場合も失敗します。したがって、安全なEther送金を行うためには、 ``send`` の戻り値を常にチェックするか、 ``transfer`` を使用するか、あるいはさらに良い方法として、受信者がお金を引き出すパターンを使用してください。

.. * ``call``, ``delegatecall`` and ``staticcall``

* ``call`` 、 ``delegatecall`` 、 ``staticcall``

.. In order to interface with contracts that do not adhere to the ABI,
.. or to get more direct control over the encoding,
.. the functions ``call``, ``delegatecall`` and ``staticcall`` are provided.
.. They all take a single ``bytes memory`` parameter and
.. return the success condition (as a ``bool``) and the returned data
.. (``bytes memory``).
.. The functions ``abi.encode``, ``abi.encodePacked``, ``abi.encodeWithSelector``
.. and ``abi.encodeWithSignature`` can be used to encode structured data.

ABIに準拠していないコントラクトとのインターフェースや、エンコーディングをより直接的に制御するために、関数 ``call`` 、 ``delegatecall`` 、 ``staticcall`` が用意されています。これらの関数はすべて1つの ``bytes memory`` パラメータを受け取り、成功条件（ ``bool`` ）と戻りデータ（ ``bytes memory`` ）を返します。関数 ``abi.encode`` 、 ``abi.encodePacked`` 、 ``abi.encodeWithSelector`` 、 ``abi.encodeWithSignature`` は、構造化データのエンコードに使用できます。

.. Example:

例

.. code-block:: solidity

    bytes memory payload = abi.encodeWithSignature("register(string)", "MyName");
    (bool success, bytes memory returnData) = address(nameReg).call(payload);
    require(success);

.. .. warning::

..     All these functions are low-level functions and should be used with care.
..     Specifically, any unknown contract might be malicious and if you call it, you
..     hand over control to that contract which could in turn call back into
..     your contract, so be prepared for changes to your state variables
..     when the call returns. The regular way to interact with other contracts
..     is to call a function on a contract object (``x.f()``).

.. warning::

    これらの関数はすべて低レベルの関数であり、注意して使用する必要があります。     特に、未知のコントラクトは悪意を持っている可能性があり、それを呼び出すと、そのコントラクトに制御を渡すことになり、そのコントラクトが自分のコントラクトにコールバックする可能性があるので、コールが戻ってきたときの自分の状態変数の変化に備えてください。他のコントラクトとやりとりする通常の方法は、コントラクトオブジェクト( ``x.f()`` )の関数を呼び出すことです。

.. .. note::

..     Previous versions of Solidity allowed these functions to receive
..     arbitrary arguments and would also handle a first argument of type
..     ``bytes4`` differently. These edge cases were removed in version 0.5.0.

.. note::

    以前のバージョンのSolidityでは、これらの関数が任意の引数を受け取ることができ、また、 ``bytes4`` 型の第1引数の扱いが異なっていました。これらのエッジケースはバージョン0.5.0で削除されました。

.. It is possible to adjust the supplied gas with the ``gas`` modifier:

``gas`` モディファイアで供給ガスを調整することが可能です。

.. code-block:: solidity

    address(nameReg).call{gas: 1000000}(abi.encodeWithSignature("register(string)", "MyName"));

.. Similarly, the supplied Ether value can be controlled too:

同様に、供給されるEtherの値も制御できます。

.. code-block:: solidity

    address(nameReg).call{value: 1 ether}(abi.encodeWithSignature("register(string)", "MyName"));

.. Lastly, these modifiers can be combined. Their order does not matter:

最後に、これらの修飾子は組み合わせることができます。その順番は問題ではありません。

.. code-block:: solidity

    address(nameReg).call{gas: 1000000, value: 1 ether}(abi.encodeWithSignature("register(string)", "MyName"));

.. In a similar way, the function ``delegatecall`` can be used: the difference is that only the code of the given address is used, all other aspects (storage, balance, ...) are taken from the current contract. The purpose of ``delegatecall`` is to use library code which is stored in another contract. The user has to ensure that the layout of storage in both contracts is suitable for delegatecall to be used.

同様の方法で、関数 ``delegatecall`` を使用できます。違いは、与えられたアドレスのコードのみが使用され、他のすべての側面（ストレージ、バランス、...）は、現在のコントラクトから取得されます。 ``delegatecall`` の目的は、別のコントラクトに保存されているライブラリ・コードを使用することです。ユーザーは、両方のコントラクトのストレージのレイアウトが、delegatecallを使用するのに適していることを確認しなければなりません。

.. .. note::

..     Prior to homestead, only a limited variant called ``callcode`` was available that did not provide access to the original ``msg.sender`` and ``msg.value`` values. This function was removed in version 0.5.0.

.. note::

    ホームステッド以前のバージョンでは、 ``callcode`` という限定されたバリアントのみが利用可能で、オリジナルの ``msg.sender`` と ``msg.value`` の値にアクセスできませんでした。この関数はバージョン0.5.0で削除されました。

.. Since byzantium ``staticcall`` can be used as well. This is basically the same as ``call``, but will revert if the called function modifies the state in any way.

byzantium  ``staticcall`` も使えるようになりました。これは基本的に ``call`` と同じですが、呼び出された関数が何らかの形で状態を変更すると元に戻ります。

.. All three functions ``call``, ``delegatecall`` and ``staticcall`` are very low-level functions and should only be used as a *last resort* as they break the type-safety of Solidity.

``call`` 、 ``delegatecall`` 、 ``staticcall`` の3つの関数は、非常に低レベルな関数で、Solidityの型安全性を壊してしまうため、 *最後の手段* としてのみ使用してください。

.. The ``gas`` option is available on all three methods, while the ``value`` option is only available
.. on ``call``.

``gas`` オプションは3つの方式すべてで利用できますが、 ``value`` オプションは ``call`` でのみ利用できます。

.. .. note::

..     It is best to avoid relying on hardcoded gas values in your smart contract code,
..     regardless of whether state is read from or written to, as this can have many pitfalls.
..     Also, access to gas might change in the future.

.. note::

    スマートコントラクトのコードでは、状態の読み書きにかかわらず、ハードコードされたガスの値に依存することは、多くの落とし穴があるので避けたほうがよいでしょう。     また、ガスへのアクセスが将来的に変わる可能性もあります。

.. .. note::

..     All contracts can be converted to ``address`` type, so it is possible to query the balance of the
..     current contract using ``address(this).balance``.

* ``code`` and ``codehash``

You can query the deployed code for any smart contract. Use ``.code`` to get the EVM bytecode as a
``bytes memory``, which might be empty. Use ``.codehash`` get the Keccak-256 hash of that code
(as a ``bytes32``). Note that ``addr.codehash`` is cheaper than using ``keccak256(addr.code)``.

.. note::

    すべてのコントラクトは ``address`` タイプに変換できるので、 ``address(this).balance`` を使って現在のコントラクトの残高を照会することが可能です。

.. index:: ! contract type, ! type; contract

.. _contract_types:

Contract Types
--------------

.. Every :ref:`contract<contracts>` defines its own type.
.. You can implicitly convert contracts to contracts they inherit from.
.. Contracts can be explicitly converted to and from the ``address`` type.

すべての :ref:`contract<contracts>` はそれ自身のタイプを定義します。コントラクトを、それらが継承するコントラクトに暗黙的に変換できる。コントラクトは、 ``address`` 型との間で明示的に変換できます。

.. Explicit conversion to and from the ``address payable`` type is only possible
.. if the contract type has a receive or payable fallback function.  The conversion is still
.. performed using ``address(x)``. If the contract type does not have a receive or payable
.. fallback function, the conversion to ``address payable`` can be done using
.. ``payable(address(x))``.
.. You can find more information in the section about
.. the :ref:`address type<address>`.

``address payable`` タイプとの間の明示的な変換は、コントラクトタイプにreceiveまたはpayableのフォールバック関数がある場合にのみ可能です。  変換は ``address(x)`` を使用して行われます。コントラクトタイプにreceiveまたはpayment fallback関数がない場合、 ``address payable`` への変換は ``payable(address(x))`` を使用して行うことができます。詳細は、「 :ref:`address type<address>` 」の項を参照してください。

.. .. note::

..     Before version 0.5.0, contracts directly derived from the address type
..     and there was no distinction between ``address`` and ``address payable``.

.. note::

    バージョン0.5.0以前は、コントラクトはアドレスタイプから直接派生し、 ``address`` と ``address payable`` の区別はありませんでした。

.. If you declare a local variable of contract type (``MyContract c``), you can call
.. functions on that contract. Take care to assign it from somewhere that is the
.. same contract type.

コントラクトタイプ( ``MyContract c`` )のローカル変数を宣言すると、そのコントラクトで関数を呼び出すことができます。ただし、同じコントラクト型のどこかから代入するように注意してください。

.. You can also instantiate contracts (which means they are newly created). You
.. can find more details in the :ref:`'Contracts via new'<creating-contracts>`
.. section.

また、コントラクトをインスタンス化することもできます（新規に作成することを意味します）。詳細は「 :ref:`'Contracts via new'<creating-contracts>` 」の項を参照してください。

.. The data representation of a contract is identical to that of the ``address``
.. type and this type is also used in the :ref:`ABI<ABI>`.

コントラクトのデータ表現は ``address`` タイプと同じで、このタイプは :ref:`ABI<ABI>` でも使用されています。

.. Contracts do not support any operators.

コントラクトは、いかなるオペレーターもサポートしません。

.. The members of contract types are the external functions of the contract
.. including any state variables marked as ``public``.

コントラクトタイプのメンバーは、 ``public`` とマークされたステート変数を含むコントラクトの外部関数です。

.. For a contract ``C`` you can use ``type(C)`` to access
.. :ref:`type information<meta-type>` about the contract.

コントラクト ``C`` の場合は、 ``type(C)`` を使ってコントラクトに関する :ref:`type information<meta-type>` にアクセスできます。

.. index:: byte array, bytes32

Fixed-size byte arrays
----------------------

.. The value types ``bytes1``, ``bytes2``, ``bytes3``, ..., ``bytes32``
.. hold a sequence of bytes from one to up to 32.

``bytes1`` ,  ``bytes2`` ,  ``bytes3`` , ...,  ``bytes32`` の値は、1から最大32までのバイト列を保持します。

.. Operators:

オペレーターです。

.. * Comparisons: ``<=``, ``<``, ``==``, ``!=``, ``>=``, ``>`` (evaluate to ``bool``)

* 比較対象 ``<=`` ,  ``<`` ,  ``==`` ,  ``!=`` ,  ``>=`` ,  ``>``  ( ``bool`` まで評価)

.. * Bit operators: ``&``, ``|``, ``^`` (bitwise exclusive or), ``~`` (bitwise negation)

* ビット演算子。 ``&`` 、 ``|`` 、 ``^`` （ビットごとの排他的論理和）、 ``~`` （ビットごとの否定）

.. * Shift operators: ``<<`` (left shift), ``>>`` (right shift)

* シフト演算子。 ``<<`` (左シフト)、 ``>>`` (右シフト)

.. * Index access: If ``x`` is of type ``bytesI``, then ``x[k]`` for ``0 <= k < I`` returns the ``k`` th byte (read-only).

* インデックスアクセスです。 ``x`` がタイプ ``bytesI`` の場合、 ``x[k]``  for  ``0 <= k < I`` は ``k`` 番目のバイトを返します（読み取り専用）。

.. The shifting operator works with unsigned integer type as right operand (but
.. returns the type of the left operand), which denotes the number of bits to shift by.
.. Shifting by a signed type will produce a compilation error.

シフティング演算子は、右オペランドに符号なし整数型を指定して動作します（ただし、左オペランドの型を返します）が、この型はシフトするビット数を表します。符号付きの型でシフトするとコンパイルエラーになります。

.. Members:

メンバーです。

.. * ``.length`` yields the fixed length of the byte array (read-only).

* ``.length`` は、バイト配列の固定長を出力します（読み取り専用）。

.. .. note::

..     The type ``bytes1[]`` is an array of bytes, but due to padding rules, it wastes
..     31 bytes of space for each element (except in storage). It is better to use the ``bytes``
..     type instead.

.. note::

    ``bytes1[]`` 型はバイトの配列ですが、パディングのルールにより、各要素ごとに31バイトのスペースを無駄にしています（ストレージを除く）。代わりに ``bytes`` 型を使うのが良いでしょう。

.. .. note::

..     Prior to version 0.8.0, ``byte`` used to be an alias for ``bytes1``.

.. note::

    バージョン0.8.0以前では、 ``byte`` は ``bytes1`` の別名でした。

Dynamically-sized byte array
----------------------------

.. ``bytes``:
..     Dynamically-sized byte array, see :ref:`arrays`. Not a value-type!
.. ``string``:
..     Dynamically-sized UTF-8-encoded string, see :ref:`arrays`. Not a value-type!

``bytes`` : 動的なサイズのバイト配列、 :ref:`arrays` を参照。値型ではありません ``string`` : 動的サイズのUTF-8エンコードされた文字列で、 :ref:`arrays` を参照。Value-Typeではありません。

.. index:: address, literal;address

.. _address_literals:

Address Literals
----------------

.. Hexadecimal literals that pass the address checksum test, for example
.. ``0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF`` are of ``address`` type.
.. Hexadecimal literals that are between 39 and 41 digits
.. long and do not pass the checksum test produce
.. an error. You can prepend (for integer types) or append (for bytesNN types) zeros to remove the error.

アドレスチェックサムテストに合格した16進数リテラル（例:  ``0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF`` ）は ``address`` タイプです。16進数リテラルの長さが39桁から41桁の間で、チェックサムテストに合格しない場合はエラーになります。エラーを取り除くには、ゼロを前置（整数型の場合）または後置（バイトNN型の場合）する必要があります。

.. .. note::

..     The mixed-case address checksum format is defined in `EIP-55 <https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md>`_.

.. note::

    混合ケースのアドレスチェックサムフォーマットは `EIP-55 <https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md>`_ で定義されています。

.. index:: literal, literal;rational

.. _rational_literals:

Rational and Integer Literals
-----------------------------

<<<<<<< HEAD
.. Integer literals are formed from a sequence of numbers in the range 0-9.
.. They are interpreted as decimals. For example, ``69`` means sixty nine.
.. Octal literals do not exist in Solidity and leading zeros are invalid.

整数リテラルは、0～9の範囲の数字の列で構成されます。小数点以下の数字として解釈されます。例えば、 ``69`` は69を意味します。Solidityには8進数のリテラルは存在せず、先頭のゼロは無効です。

.. Decimal fraction literals are formed by a ``.`` with at least one number on
.. one side.  Examples include ``1.``, ``.1`` and ``1.3``.
=======
Integer literals are formed from a sequence of digits in the range 0-9.
They are interpreted as decimals. For example, ``69`` means sixty nine.
Octal literals do not exist in Solidity and leading zeros are invalid.

Decimal fractional literals are formed by a ``.`` with at least one number after the decimal point.
Examples include ``.1`` and ``1.3`` (but not ``1.``).

Scientific notation in the form of ``2e10`` is also supported, where the
mantissa can be fractional but the exponent has to be an integer.
The literal ``MeE`` is equivalent to ``M * 10**E``.
Examples include ``2e10``, ``-2e10``, ``2e-10``, ``2.5e1``.
>>>>>>> 800088e38b5835ebdc71e9ba5299a70a5accd7c2

小数点以下のリテラルは、片側に少なくとも1つの数字を持つ ``.`` で形成されます。  例えば、 ``1.`` 、 ``.1`` 、 ``1.3`` などです。

<<<<<<< HEAD
.. Scientific notation is also supported, where the base can have fractions and the exponent cannot.
.. Examples include ``2e10``, ``-2e10``, ``2e-10``, ``2.5e1``.
=======
Number literal expressions retain arbitrary precision until they are converted to a non-literal type (i.e. by
using them together with anything other than a number literal expression (like boolean literals) or by explicit conversion).
This means that computations do not overflow and divisions do not truncate
in number literal expressions.
>>>>>>> 800088e38b5835ebdc71e9ba5299a70a5accd7c2

科学的記数法にも対応しており、基数には分数を含めることができますが、指数には含めることができません。例としては、 ``2e10`` 、 ``-2e10`` 、 ``2e-10`` 、 ``2.5e1`` などがあります。

<<<<<<< HEAD
.. Underscores can be used to separate the digits of a numeric literal to aid readability.
.. For example, decimal ``123_000``, hexadecimal ``0x2eff_abde``, scientific decimal notation ``1_2e345_678`` are all valid.
.. Underscores are only allowed between two digits and only one consecutive underscore is allowed.
.. There is no additional semantic meaning added to a number literal containing underscores,
.. the underscores are ignored.
=======
.. warning::
    While most operators produce a literal expression when applied to literals, there are certain operators that do not follow this pattern:

    - Ternary operator (``... ? ... : ...``),
    - Array subscript (``<array>[<index>]``).

    You might expect expressions like ``255 + (true ? 1 : 0)`` or ``255 + [1, 2, 3][0]`` to be equivalent to using the literal 256
    directly, but in fact they are computed within the type ``uint8`` and can overflow.

Any operator that can be applied to integers can also be applied to number literal expressions as
long as the operands are integers. If any of the two is fractional, bit operations are disallowed
and exponentiation is disallowed if the exponent is fractional (because that might result in
a non-rational number).
>>>>>>> 800088e38b5835ebdc71e9ba5299a70a5accd7c2

アンダースコアは、読みやすくするために数値リテラルの桁を区切るのに使用できます。例えば、10進法の ``123_000`` 、16進法の ``0x2eff_abde`` 、科学的10進法の ``1_2e345_678`` はすべて有効です。アンダースコアは2つの数字の間にのみ使用でき、連続したアンダースコアは1つしか使用できません。アンダースコアを含む数値リテラルには、追加の意味はなく、アンダースコアは無視されます。

.. Number literal expressions retain arbitrary precision until they are converted to a non-literal type (i.e. by
.. using them together with a non-literal expression or by explicit conversion).
.. This means that computations do not overflow and divisions do not truncate
.. in number literal expressions.

数リテラル式は、非リテラル型に変換されるまで（非リテラル式との併用や明示的な変換など）、任意の精度を保ちます。このため、数値リテラル式では、計算がオーバーフローしたり、除算が切り捨てられたりすることはありません。

.. For example, ``(2**800 + 1) - 2**800`` results in the constant ``1`` (of type ``uint8``)
.. although intermediate results would not even fit the machine word size. Furthermore, ``.5 * 8`` results
.. in the integer ``4`` (although non-integers were used in between).

例えば、 ``(2**800 + 1) - 2**800`` の結果は定数 ``1`` （ ``uint8`` 型）になりますが、中間の結果はマシンのワードサイズに収まりません。さらに、 ``.5 * 8`` の結果は整数の ``4`` になります（ただし、その間には非整数が使われています）。

.. Any operator that can be applied to integers can also be applied to number literal expressions as
.. long as the operands are integers. If any of the two is fractional, bit operations are disallowed
.. and exponentiation is disallowed if the exponent is fractional (because that might result in
.. a non-rational number).

整数に適用できる演算子は、オペランドが整数であれば、ナンバーリテラル式にも適用できます。2つのうちいずれかが小数の場合、ビット演算は許可されず、指数が小数の場合、指数演算は許可されません（非有理数になってしまう可能性があるため）。

.. Shifts and exponentiation with literal numbers as left (or base) operand and integer types
.. as the right (exponent) operand are always performed
.. in the ``uint256`` (for non-negative literals) or ``int256`` (for a negative literals) type,
.. regardless of the type of the right (exponent) operand.

リテラル数を左（またはベース）オペランドとし、整数型を右（指数）オペランドとするシフトと指数化は、右（指数）オペランドの型にかかわらず、常に ``uint256`` （非負のリテラルの場合）または ``int256`` （負のリテラルの場合）型で実行されます。

.. .. warning::

..     Division on integer literals used to truncate in Solidity prior to version 0.4.0, but it now converts into a rational number, i.e. ``5 / 2`` is not equal to ``2``, but to ``2.5``.

.. warning::

    バージョン0.4.0以前のSolidityでは、整数リテラルの除算は切り捨てられていましたが、有理数に変換されるようになりました。つまり、 ``5 / 2`` は ``2`` とはならず、 ``2.5`` となります。

.. .. note::

..     Solidity has a number literal type for each rational number.
..     Integer literals and rational number literals belong to number literal types.
..     Moreover, all number literal expressions (i.e. the expressions that
..     contain only number literals and operators) belong to number literal
..     types.  So the number literal expressions ``1 + 2`` and ``2 + 1`` both
..     belong to the same number literal type for the rational number three.

.. note::

    Solidityでは、有理数ごとに数値リテラル型が用意されています。     整数リテラルと有理数リテラルは、数リテラル型に属します。     また、すべての数リテラル式（数リテラルと演算子のみを含む式）は、数リテラル型に属します。  つまり、数値リテラル式 ``1 + 2`` と ``2 + 1`` は、有理数3に対して同じ数値リテラル型に属しています。

.. .. note::

..     Number literal expressions are converted into a non-literal type as soon as they are used with non-literal
..     expressions. Disregarding types, the value of the expression assigned to ``b``
..     below evaluates to an integer. Because ``a`` is of type ``uint128``, the
..     expression ``2.5 + a`` has to have a proper type, though. Since there is no common type
..     for the type of ``2.5`` and ``uint128``, the Solidity compiler does not accept
..     this code.

.. note::

    数値リテラル式は、非リテラル式と一緒に使われると同時に、非リテラル型に変換されます。型に関係なく、以下の ``b`` に割り当てられた式の値は整数と評価されます。 ``a`` は ``uint128`` 型なので、 ``2.5 + a`` という式は適切な型を持っていなければなりませんが。 ``2.5`` と ``uint128`` の型には共通の型がないので、Solidityのコンパイラはこのコードを受け入れません。

.. code-block:: solidity

    uint128 a = 1;
    uint128 b = 2.5 + a + 0.5;

.. index:: literal, literal;string, string
.. _string_literals:

String Literals and Types
-------------------------

.. String literals are written with either double or single-quotes (``"foo"`` or ``'bar'``), and they can also be split into multiple consecutive parts (``"foo" "bar"`` is equivalent to ``"foobar"``) which can be helpful when dealing with long strings.  They do not imply trailing zeroes as in C; ``"foo"`` represents three bytes, not four.  As with integer literals, their type can vary, but they are implicitly convertible to ``bytes1``, ..., ``bytes32``, if they fit, to ``bytes`` and to ``string``.

文字列リテラルは、ダブルクオートまたはシングルクオート（ ``"foo"`` または ``'bar'`` ）で記述され、連続した複数の部分に分割することもできます（ ``"foo" "bar"`` は ``"foobar"`` に相当）。これは長い文字列を扱う際に便利です。  また、C言語のように末尾にゼロを付けることはなく、 ``"foo"`` は4バイトではなく3バイトを表します。  整数リテラルと同様に、その型は様々ですが、 ``bytes1`` , ...,  ``bytes32`` , 適合する場合は、 ``bytes`` ,  ``string`` に暗黙のうちに変換可能です。

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

.. .. note::

..     Lambda or inline functions are planned but not yet supported.
.. 

.. note::

    ラムダ関数やインライン関数が予定されていますが、まだサポートされていません。
