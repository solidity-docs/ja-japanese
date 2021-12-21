.. index:: ! using for, library

.. _using-for:

*********
Using For
*********

.. The directive ``using A for B;`` can be used to attach library
.. functions (from the library ``A``) to any type (``B``)
.. in the context of a contract.
.. These functions will receive the object they are called on
.. as their first parameter (like the ``self`` variable in Python).

``using A for B;`` 指令は、コントラクトの文脈において、（ ``A`` ライブラリの）ライブラリ関数を任意の型（ ``B`` ）にアタッチするために使用できます。これらの関数は、呼び出されたオブジェクトを最初のパラメータとして受け取ります（Pythonの ``self`` 変数のようなものです）。

.. The effect of ``using A for *;`` is that the functions from
.. the library ``A`` are attached to *any* type.

``using A for *;`` の効果は、ライブラリ ``A`` の関数が*あらゆる*タイプに付けられることです。

.. In both situations, *all* functions in the library are attached,
.. even those where the type of the first parameter does not
.. match the type of the object. The type is checked at the
.. point the function is called and function overload
.. resolution is performed.

どちらの場合も、最初のパラメータの型がオブジェクトの型と一致しないものも含めて、ライブラリの*すべての*関数がアタッチされます。関数が呼び出された時点で型がチェックされ、関数のオーバーロードの解決が行われます。

.. The ``using A for B;`` directive is active only within the current
.. contract, including within all of its functions, and has no effect
.. outside of the contract in which it is used. The directive
.. may only be used inside a contract, not inside any of its functions.

``using A for B;``  ディレクティブは、すべての関数を含む現在のコントラクトの中でのみ有効であり、使用されているコントラクトの外では何の影響も受けません。 ``using A for B;``  ディレクティブは、コントラクトの内部でのみ使用でき、コントラクトのどの関数の中でも使用できません。

.. Let us rewrite the set example from the
.. :ref:`libraries` in this way:

:ref:`libraries` のセット例をこのように書き換えてみましょう。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    // This is the same code as before, just without comments
    struct Data { mapping(uint => bool) flags; }

    library Set {
        function insert(Data storage self, uint value)
            public
            returns (bool)
        {
            if (self.flags[value])
                return false; // already there
            self.flags[value] = true;
            return true;
        }

        function remove(Data storage self, uint value)
            public
            returns (bool)
        {
            if (!self.flags[value])
                return false; // not there
            self.flags[value] = false;
            return true;
        }

        function contains(Data storage self, uint value)
            public
            view
            returns (bool)
        {
            return self.flags[value];
        }
    }

    contract C {
        using Set for Data; // this is the crucial change
        Data knownValues;

        function register(uint value) public {
            // Here, all variables of type Data have
            // corresponding member functions.
            // The following function call is identical to
            // `Set.insert(knownValues, value)`
            require(knownValues.insert(value));
        }
    }

.. It is also possible to extend elementary types in that way:

また、そのようにして基本型を拡張することも可能です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.8 <0.9.0;

    library Search {
        function indexOf(uint[] storage self, uint value)
            public
            view
            returns (uint)
        {
            for (uint i = 0; i < self.length; i++)
                if (self[i] == value) return i;
            return type(uint).max;
        }
    }

    contract C {
        using Search for uint[];
        uint[] data;

        function append(uint value) public {
            data.push(value);
        }

        function replace(uint _old, uint _new) public {
            // This performs the library function call
            uint index = data.indexOf(_old);
            if (index == type(uint).max)
                data.push(_new);
            else
                data[index] = _new;
        }
    }

.. Note that all external library calls are actual EVM function calls. This means that
.. if you pass memory or value types, a copy will be performed, even of the
.. ``self`` variable. The only situation where no copy will be performed
.. is when storage reference variables are used or when internal library
.. functions are called.
.. 

すべての外部ライブラリ呼び出しは、実際のEVM関数呼び出しであることに注意してください。つまり、メモリや値の型を渡す場合は、 ``self`` 変数であってもコピーが実行されます。コピーが行われない唯一の状況は、ストレージ参照変数が使用されている場合や、内部ライブラリ関数が呼び出されている場合です。
