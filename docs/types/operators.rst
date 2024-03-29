.. index:: ! operator


演算子
======

.. Arithmetic and bit operators can be applied even if the two operands do not have the same type.
.. For example, you can compute ``y = x + z``, where ``x`` is a ``uint8`` and ``z`` has the type ``uint32``.
.. In these cases, the following mechanism will be used to determine the type in which the operation is computed (this is important in case of overflow) and the type of the operator's result:

算術演算子やビット演算子は、2つのオペランドが同じ型でなくても適用できます。
例えば、 ``y = x + z`` で ``x`` は ``uint8`` で、 ``z`` は ``uint32`` という型を持っていても計算できます。
このような場合、次のようなメカニズムで、演算が計算される型（これはオーバーフローの場合に重要です）と演算子の結果の型を決定します:

.. 1. If the type of the right operand can be implicitly converted to the type of the left operand, use the type of the left operand,
.. 2. if the type of the left operand can be implicitly converted to the type of the right operand, use the type of the right operand,
.. 3. otherwise, the operation is not allowed.

1. 右オペランドの型が左オペランドの型に暗黙のうちに変換できる場合、左オペランドの型を使用します。
2. 左オペランドの型が右オペランドの型に暗黙のうちに変換できる場合、右オペランドの型を使用します。
3. それ以外の場合は、演算ができません。

.. In case one of the operands is a :ref:`literal number <rational_literals>` it is first converted to its "mobile type", which is the smallest type that can hold the value (unsigned types of the same bit-width are considered "smaller" than the signed types).
.. If both are literal numbers, the operation is computed with effectively unlimited precision in that the expression is evaluated to whatever precision is necessary so that none is lost when the result is used with a non-literal type.

オペランドの一方が :ref:`リテラルの数値 <rational_literals>` の場合、まずその値を保持できる最小の型である「モバイル型」に変換されます（同じビット幅の符号なし型は符号付き型より「小さい」とみなされます）。
両方がリテラルの数値の場合、演算は事実上無制限の精度で計算されます。
つまり、式は必要な限りの精度で評価され、結果がリテラルでない型で使われたときに失われることはありません。

.. The operator's result type is the same as the type the operation is performed in, except for comparison operators where the result is always ``bool``.

演算子の結果の型は、結果が常に ``bool`` になる比較演算子を除いて、演算が行われた型と同じです。

.. The operators ``**`` (exponentiation), ``<<``  and ``>>`` use the type of the left operand for the operation and the result.

演算子 ``**`` （指数）、 ``<<`` 、 ``>>`` は、演算と結果において左オペランドの型を使用します。

三項演算子
----------

.. The ternary operator is used in expressions of the form ``<expression> ? <trueExpression> : <falseExpression>``.
.. It evaluates one of the latter two given expressions depending upon the result of the evaluation of the main ``<expression>``.
.. If ``<expression>`` evaluates to ``true``, then ``<trueExpression>`` will be evaluated, otherwise ``<falseExpression>`` is evaluated.

三項演算子は、 ``<expression> ? <trueExpression> : <falseExpression>`` という形式の式で使われます。
これは、メインの ``<expression>`` の評価結果に応じて、後者の2つの式のうち1つを評価するものです。
もし ``<expression>`` が ``true`` と評価されれば ``<trueExpression>`` が評価され、そうでなければ ``<falseExpression>`` が評価されます。

.. The result of the ternary operator does not have a rational number type, even if all of its operands are rational number literals.
.. The result type is determined from the types of the two operands in the same way as above, converting to their mobile type first if required.

三項演算子の結果は、たとえすべてのオペランドが有理数リテラルであっても、有理数型を持ちません。
結果の型は、上記と同じように2つのオペランドの型から決定され、必要であれば最初にその移動型に変換されます。

.. As a consequence, ``255 + (true ? 1 : 0)`` will revert due to arithmetic overflow.
.. The reason is that ``(true ? 1 : 0)`` is of ``uint8`` type, which forces the addition to be performed in ``uint8`` as well, and 256 exceeds the range allowed for this type.

その結果、 ``255 + (true ? 1 : 0)`` は算術オーバーフローによりリバートされてしまいます。
これは ``(true ? 1 : 0)`` が ``uint8`` 型であるため、加算も ``uint8`` で行う必要があり、256はこの型で許される範囲を超えているためです。

.. Another consequence is that an expression like ``1.5 + 1.5`` is valid but ``1.5 + (true ? 1.5 : 2.5)`` is not.
.. This is because the former is a rational expression evaluated in unlimited precision and only its final value matters.
.. The latter involves a conversion of a fractional rational number to an integer, which is currently disallowed.

もう一つの結果として、 ``1.5 + 1.5`` のような式は有効だが、 ``1.5 + (true ? 1.5 : 2.5)`` は無効です。
これは、前者が無制限の精度で評価される有理式であり、その最終値のみが重要だからです。
後者は小数有理数から整数への変換を伴うので、現在では認められていません。

.. index:: assignment, lvalue, ! compound operators

複合演算子、インクリメント/デクリメント演算子
---------------------------------------------

.. If ``a`` is an LValue (i.e. a variable or something that can be assigned to), the
.. following operators are available as shorthands:

``a`` がLValue（すなわち変数や代入可能なもの）の場合、以下の演算子がショートハンドとして利用できます。

.. ``a += e`` is equivalent to ``a = a + e``. The operators ``-=``, ``*=``, ``/=``, ``%=``,
.. ``|=``, ``&=``, ``^=``, ``<<=`` and ``>>=`` are defined accordingly. ``a++`` and ``a--`` are equivalent
.. to ``a += 1`` / ``a -= 1`` but the expression itself still has the previous value
.. of ``a``. In contrast, ``--a`` and ``++a`` have the same effect on ``a`` but
.. return the value after the change.

``a += e`` は ``a = a + e`` と同等です。
演算子 ``-=`` 、 ``*=`` 、 ``/=`` 、 ``%=`` 、 ``|=`` 、 ``&=`` 、 ``^=`` 、 ``<<=`` 、 ``>>=`` はそれぞれ定義されています。
``a++`` と ``a--`` は ``a += 1``  /  ``a -= 1`` に相当しますが、表現自体は ``a`` の前の値のままです。
一方、 ``--a`` と ``++a`` は、 ``a`` に同じ効果を与えますが、変更後の値を返します。

.. index:: !delete

.. _delete:

delete
------

.. ``delete a`` assigns the initial value for the type to ``a``. I.e. for integers it is
.. equivalent to ``a = 0``, but it can also be used on arrays, where it assigns a dynamic
.. array of length zero or a static array of the same length with all elements set to their
.. initial value. ``delete a[x]`` deletes the item at index ``x`` of the array and leaves
.. all other elements and the length of the array untouched. This especially means that it leaves
.. a gap in the array. If you plan to remove items, a :ref:`mapping <mapping-types>` is probably a better choice.

``delete a`` は、 ``a`` に型の初期値を割り当てます。
つまり、整数の場合は ``a = 0`` と同じですが、配列にも使用でき、長さ0の動的配列や、すべての要素を初期値に設定した同じ長さの静的配列を割り当てます。
``delete a[x]`` は、配列のインデックス ``x`` の項目を削除し、他のすべての要素と配列の長さはそのままにします。
これは特に、配列にギャップを残すことを意味します。
アイテムを削除する予定なら、 :ref:`マッピング<mapping-types>` の方が良いでしょう。

.. For structs, it assigns a struct with all members reset. In other words,
.. the value of ``a`` after ``delete a`` is the same as if ``a`` would be declared
.. without assignment, with the following caveat:

構造体の場合は、すべてのメンバーがリセットされた構造体が割り当てられます。
つまり、 ``delete a`` 後の ``a`` の値は、以下の注意点を除いて、 ``a`` が代入なしで宣言された場合と同じになります。

.. ``delete`` has no effect on mappings (as the keys of mappings may be arbitrary and
.. are generally unknown). So if you delete a struct, it will reset all members that
.. are not mappings and also recurse into the members unless they are mappings.
.. However, individual keys and what they map to can be deleted: If ``a`` is a
.. mapping, then ``delete a[x]`` will delete the value stored at ``x``.

``delete`` はマッピングには影響を与えません（マッピングのキーは任意である可能性があり、一般的には不明であるため）。
そのため、構造体を削除すると、マッピングではないすべてのメンバーがリセットされ、またマッピングでない限り、そのメンバーに再帰します。
しかし、個々のキーとそれが何にマッピングされているかは削除できます。
``a`` がマッピングであれば、 ``delete a[x]`` は ``x`` に格納されている値を削除します。

.. It is important to note that ``delete a`` really behaves like an
.. assignment to ``a``, i.e. it stores a new object in ``a``.
.. This distinction is visible when ``a`` is reference variable: It
.. will only reset ``a`` itself, not the
.. value it referred to previously.

``delete a`` は実際には ``a`` への代入のように振る舞います。
つまり、 ``a`` に新しいオブジェクトを格納するということに注意することが重要です。
この違いは、 ``a`` が参照変数の場合に見られます。
``delete a`` は ``a`` 自体をリセットするだけで、以前参照していた値はリセットしません。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract DeleteExample {
        uint data;
        uint[] dataArray;

        function f() public {
            uint x = data;
            delete x; // xを0にセットし、dataには影響を与えない
            delete data; // dataを0にセットし、xには影響を与えない
            uint[] storage y = dataArray;
            delete dataArray; // これは dataArray.length を 0 にするものですが、
            // uint[] は複合オブジェクトであるため、ストレージオブジェクトのエイリアスである y にも影響が及びます。
            // ストレージオブジェクトを参照するローカル変数への代入は、既存のストレージオブジェクトからしか行えないため、"delete y"は有効ではありません。
            assert(y.length == 0);
        }
    }

.. index:: ! operator; precedence
.. _order:

演算子の優先順位
----------------

.. include:: types/operator-precedence-table.rst
