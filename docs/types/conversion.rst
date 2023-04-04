.. index:: ! type;conversion, ! cast

.. _types-conversion-elementary-types:

初等型間の変換
==============

暗黙的な変換
------------

.. An implicit type conversion is automatically applied by the compiler in some cases
.. during assignments, when passing arguments to functions and when applying operators.
.. In general, an implicit conversion between value-types is possible if it makes
.. sense semantically and no information is lost.

暗黙の型変換は、代入時、関数に引数を渡すとき、および演算子を適用するときに、コンパイラによって自動的に適用される場合があります。
一般に、セマンティック的に正しく、情報が失われないのであれば、値型間の暗黙の変換は可能です。

.. For example, ``uint8`` is convertible to
.. ``uint16`` and ``int128`` to ``int256``, but ``int8`` is not convertible to ``uint256``,
.. because ``uint256`` cannot hold values such as ``-1``.

例えば、 ``uint8`` は ``uint16`` に、 ``int128`` は ``int256`` に変換できますが、 ``uint256`` は ``-1`` のような値を保持できないため、 ``int8`` は ``uint256`` に変換できません。

.. If an operator is applied to different types, the compiler tries to implicitly
.. convert one of the operands to the type of the other (the same is true for assignments).
.. This means that operations are always performed in the type of one of the operands.

演算子が異なる型に適用される場合、コンパイラはオペランドの一方を他方の型に暗黙のうちに変換しようとします（代入の場合も同様）。
つまり、演算は常に一方のオペランドの型で実行されることになります。

.. For more details about which implicit conversions are possible,
.. please consult the sections about the types themselves.

どのような暗黙の変換が可能であるかの詳細については、型自体に関するセクションを参照してください。

.. In the example below, ``y`` and ``z``, the operands of the addition,
.. do not have the same type, but ``uint8`` can
.. be implicitly converted to ``uint16`` and not vice-versa. Because of that,
.. ``y`` is converted to the type of ``z`` before the addition is performed
.. in the ``uint16`` type. The resulting type of the expression ``y + z`` is ``uint16``.
.. Because it is assigned to a variable of type ``uint32`` another implicit conversion
.. is performed after the addition.

下の例では、加算のオペランドである ``y`` と ``z`` は同じ型ではありませんが、 ``uint8`` は暗黙のうちに ``uint16`` に変換でき、その逆はできません。
そのため、 ``y`` は ``z`` の型に変換されてから、 ``uint16`` の型で加算が行われます。
その結果、式 ``y + z`` の型は ``uint16`` となります。
``uint32`` 型の変数に代入されているため、加算の後に別の暗黙の変換が行われます。

.. code-block:: solidity

    uint8 y;
    uint16 z;
    uint32 x = y + z;

明示的な変換
------------

.. If the compiler does not allow implicit conversion but you are confident a conversion will work,
.. an explicit type conversion is sometimes possible. This may
.. result in unexpected behaviour and allows you to bypass some security
.. features of the compiler, so be sure to test that the
.. result is what you want and expect!

コンパイラが暗黙的な変換を許可していないが、変換がうまくいくと確信している場合、明示的な型変換が可能な場合があります。
この場合、予期しない動作をしたり、コンパイラのセキュリティ機能を迂回したりすることがありますので、結果が期待通りのものであることを必ずテストしてください。

.. Take the following example that converts a negative ``int`` to a ``uint``:

次の例では、マイナスの ``int`` を ``uint`` に変換しています。

.. code-block:: solidity

    int  y = -3;
    uint x = uint(y);

.. At the end of this code snippet, ``x`` will have the value ``0xfffff..fd`` (64 hex
.. characters), which is -3 in the two's complement representation of 256 bits.

このコードスニペットの最後に、 ``x`` は256ビットの2の補数表現で-3である ``0xfffff..fd`` （64の16進文字）という値を持つことになります。

.. If an integer is explicitly converted to a smaller type, higher-order bits are
.. cut off:

整数を明示的に小さい型に変換すると、高次のビットが削られます。

.. code-block:: solidity

    uint32 a = 0x12345678;
    uint16 b = uint16(a); // b は 0x5678 になる

.. If an integer is explicitly converted to a larger type, it is padded on the left (i.e., at the higher order end).
.. The result of the conversion will compare equal to the original integer:

整数がより大きな型に明示的に変換された場合、その整数は左に（すなわち高次の端に）パディングされます。
変換の結果は、元の整数と同じになります。

.. code-block:: solidity

    uint16 a = 0x1234;
    uint32 b = uint32(a); // b は 0x00001234 になる
    assert(a == b);

.. Fixed-size bytes types behave differently during conversions. They can be thought of as
.. sequences of individual bytes and converting to a smaller type will cut off the
.. sequence:

固定サイズのバイト、変換時の挙動が異なります。
これらは個々のバイトのシーケンスと考えることができ、より小さな型に変換するとシーケンスが切断されます。

.. code-block:: solidity

    bytes2 a = 0x1234;
    bytes1 b = bytes1(a); // b は 0x12 になる

.. If a fixed-size bytes type is explicitly converted to a larger type, it is padded on
.. the right. Accessing the byte at a fixed index will result in the same value before and
.. after the conversion (if the index is still in range):

固定サイズのバイト型が明示的に大きな型に変換された場合は、右にパディングされます。
固定インデックスでバイトにアクセスすると、変換前と変換後で同じ値になります（インデックスがまだ範囲内にある場合）。

.. code-block:: solidity

    bytes2 a = 0x1234;
    bytes4 b = bytes4(a); // b は 0x12340000 になる
    assert(a[0] == b[0]);
    assert(a[1] == b[1]);

.. Since integers and fixed-size byte arrays behave differently when truncating or
.. padding, explicit conversions between integers and fixed-size byte arrays are only allowed,
.. if both have the same size. If you want to convert between integers and fixed-size byte arrays of
.. different size, you have to use intermediate conversions that make the desired truncation and padding
.. rules explicit:

整数と固定サイズのバイト配列は、切り捨てやパディングの際に異なる動作をするので、 整数と固定サイズのバイト配列の間の明示的な変換は、両者が同じサイズである場合にのみ許されます。
異なるサイズの整数と固定サイズのバイト配列の間で変換したい場合は、必要な切り捨てとパディングの規則を明示する中間変換を使用しなければなりません。

.. code-block:: solidity

    bytes2 a = 0x1234;
    uint32 b = uint16(a); // b は 0x00001234 になる
    uint32 c = uint32(bytes4(a)); // c は 0x12340000 になる
    uint8 d = uint8(uint16(a)); // d は 0x34 になる
    uint8 e = uint8(bytes1(a)); // e は 0x12 になる

.. ``bytes`` arrays and ``bytes`` calldata slices can be converted explicitly to fixed bytes types (``bytes1``/.../``bytes32``).
.. In case the array is longer than the target fixed bytes type, truncation at the end will happen.
.. If the array is shorter than the target type, it will be padded with zeros at the end.

``bytes`` 配列と ``bytes``  calldata sliceは、明示的に固定バイト型（ ``bytes1`` / ... / ``bytes32`` ）に変換できます。
配列が対象となる固定バイト型よりも長い場合は、末尾の切り捨てが行われます。
配列が対象となる固定バイト型よりも短い場合は、末尾にゼロが詰められます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.5;

    contract C {
        bytes s = "abcdefgh";
        function f(bytes calldata c, bytes memory m) public view returns (bytes16, bytes3) {
            require(c.length == 16, "");
            bytes16 b = bytes16(m);  // m の長さが 16 より大きい場合、切り捨てが発生します。
            b = bytes16(s);  // 右詰めしたもので、結果は "abcdefgh\0\0\0\0\0\0\0\0"
            bytes3 b1 = bytes3(s); //切り捨て、b1は"abc"に等しい。
            b = bytes16(c[:8]);  // ゼロ埋めされる
            return (b, b1);
        }
    }

.. _types-conversion-literals:

リテラルと初等型間の変換
========================

整数型
------

.. Decimal and hexadecimal number literals can be implicitly converted to any integer type
.. that is large enough to represent it without truncation:

10進数や16進数のリテラルは、切り捨てずに表現できる大きさの整数型に暗黙のうちに変換できます。

.. code-block:: solidity

    uint8 a = 12; // OK
    uint32 b = 1234; // OK
    uint16 c = 0x123456; // 失敗。0x3456 に切り捨てなければならないため。

.. .. note::

..     Prior to version 0.8.0, any decimal or hexadecimal number literals could be explicitly
..     converted to an integer type. From 0.8.0, such explicit conversions are as strict as implicit
..     conversions, i.e., they are only allowed if the literal fits in the resulting range.

.. note::

    バージョン0.8.0以前では、10進数や16進数のリテラルを明示的に整数型に変換できました。
    0.8.0からは、このような明示的な変換は暗黙的な変換と同様に厳格になりました。

固定サイズバイト列
----------------------

.. Decimal number literals cannot be implicitly converted to fixed-size byte arrays. Hexadecimal
.. number literals can be, but only if the number of hex digits exactly fits the size of the bytes
.. type. As an exception both decimal and hexadecimal literals which have a value of zero can be
.. converted to any fixed-size bytes type:

10進数リテラルを固定サイズのバイト列に暗黙的に変換できません。
16進数リテラルは変換できますが、それは16進数の桁数がバイト型のサイズにぴったり合う場合に限られます。
例外として、0の値を持つ10進数リテラルと16進数リテラルは、任意の固定サイズのバイト型に変換できます。

.. code-block:: solidity

    bytes2 a = 54321; // NG
    bytes2 b = 0x12; // NG
    bytes2 c = 0x123; // NG
    bytes2 d = 0x1234; // OK
    bytes2 e = 0x0012; // OK
    bytes4 f = 0; // OK
    bytes4 g = 0x0; // OK

.. String literals and hex string literals can be implicitly converted to fixed-size byte arrays,
.. if their number of characters matches the size of the bytes type:

文字列リテラルと16進文字列リテラルは、その文字数がバイト型のサイズと一致する場合、暗黙のうちに固定サイズのバイト配列に変換できます。

.. code-block:: solidity

    bytes2 a = hex"1234"; // OK
    bytes2 b = "xy"; // OK
    bytes2 c = hex"12"; // NG
    bytes2 d = hex"123"; // NG
    bytes2 e = "x"; // NG
    bytes2 f = "xyz"; // NG

アドレス
------------

.. As described in :ref:`address_literals`, hex literals of the correct size that pass the checksum
.. test are of ``address`` type. No other literals can be implicitly converted to the ``address`` type.

:ref:`address_literals` で説明したように、チェックサムテストに合格した正しいサイズの16進数リテラルは ``address`` 型となります。
他のリテラルは暗黙的に ``address`` 型に変換できません。

Explicit conversions to ``address`` are allowed only from ``bytes20`` and ``uint160``.

An ``address a`` can be converted explicitly to ``address payable`` via ``payable(a)``.

.. note::
    Prior to version 0.8.0, it was possible to explicitly convert from any integer type (of any size, signed or unsigned) to  ``address`` or ``address payable``.
    Starting with in 0.8.0 only conversion from ``uint160`` is allowed.
