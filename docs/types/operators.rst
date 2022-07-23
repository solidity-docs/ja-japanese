.. index:: assignment, ! delete, lvalue

LValueに関する演算子
===========================

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
これは特に、配列にギャップを残すことを意味します。アイテムを削除する予定なら、 :ref:`マッピング<mapping-types>` の方が良いでしょう。

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
しかし、個々のキーとそれが何にマッピングされているかは削除できます。 ``a`` がマッピングであれば、 ``delete a[x]`` は ``x`` に格納されている値を削除します。

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

