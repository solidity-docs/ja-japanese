.. index:: ! using for, library

.. _using-for:

*********
Using For
*********

``using A for B;`` ディレクティブは、コントラクトの文脈において、（ライブラリ ``A`` の）ライブラリ関数を任意の型（ ``B`` ）にアタッチするために使用できます。
これらの関数は、呼び出されたオブジェクトを最初のパラメータとして受け取ります（Pythonの ``self`` 変数のようなものです）。

``using A for *;`` の効果は、ライブラリ ``A`` の関数が *あらゆる* タイプに付けられることです。

どちらの場合も、最初のパラメータの型がオブジェクトの型と一致しないものも含めて、ライブラリの *すべての* 関数がアタッチされます。
関数が呼び出された時点で型がチェックされ、関数のオーバーロードの解決が行われます。

``using A for B;`` ディレクティブは、現在のコントラクト（そのすべての関数を含む）の中でのみ有効であり、使用されているコントラクトの外では何の影響も受けません。
また、コントラクトの内部でのみ使用でき、コントラクトのどの関数の中でも使用できません。

.. Let us rewrite the set example from the
.. :ref:`libraries` in this way:

:ref:`libraries` のセット例をこのように書き換えてみましょう。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    // これは前と同じコードで、コメントがないだけです。
    struct Data { mapping(uint => bool) flags; }

    library Set {
        function insert(Data storage self, uint value)
            public
            returns (bool)
        {
            if (self.flags[value])
                return false; // すでに存在する
            self.flags[value] = true;
            return true;
        }

        function remove(Data storage self, uint value)
            public
            returns (bool)
        {
            if (!self.flags[value])
                return false; // 存在しない
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
        using Set for Data; // ここが重要な変更点
        Data knownValues;

        function register(uint value) public {
            // ここでは、Data型のすべての変数に対応するメンバ関数があります。
            // 以下の関数呼び出しは， `Set.insert(knownValues, value)` と同じです．
            require(knownValues.insert(value));
        }
    }

また、そのようにして基本型（値型）を拡張することも可能です。

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
            // これは、ライブラリ関数呼び出しを実行します
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

すべての外部ライブラリ呼び出しは、実際のEVM関数呼び出しであることに注意してください。
つまり、メモリや値の型を渡す場合は、 ``self`` 変数であってもコピーが実行されます。
コピーが行われない唯一の状況は、ストレージ参照変数が使用されている場合や、内部ライブラリ関数が呼び出されている場合です。
