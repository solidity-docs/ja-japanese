.. index:: ! visibility, external, public, private, internal

.. _visibility-and-getters:

**********************
可視性とゲッター
**********************

.. Solidity knows two kinds of function calls: internal
.. ones that do not create an actual EVM call (also called
.. a "message call") and external
.. ones that do. Because of that, there are four types of visibility for
.. functions and state variables.

Solidityは、実際のEVMコール（「メッセージコール」とも呼ばれる）を作成しない内部のものと、作成する外部のものの2種類の関数コールを認識しています。
そのため、関数と状態変数の可視性には4つのタイプがあります。

.. Functions have to be specified as being ``external``,
.. ``public``, ``internal`` or ``private``.
.. For state variables, ``external`` is not possible.

関数は、 ``external`` 、 ``public`` 、 ``internal`` 、 ``private`` のいずれかを指定する必要があります。
状態変数の場合、 ``external`` は指定できません。

.. ``external``
..     External functions are part of the contract interface,
..     which means they can be called from other contracts and
..     via transactions. An external function ``f`` cannot be called
..     internally (i.e. ``f()`` does not work, but ``this.f()`` works).

``external``
    外部関数はコントラクトインターフェースの一部であり、他のコントラクトやトランザクションを介して呼び出すことができることを意味します。
    外部関数 ``f`` は、内部で呼び出すことはできません（すなわち、 ``f()`` は動作しませんが、 ``this.f()`` は動作します）。

.. ``public``
..     Public functions are part of the contract interface
..     and can be either called internally or via
..     messages. For public state variables, an automatic getter
..     function (see below) is generated.

``public``
    パブリック関数は、コントラクトインターフェースの一部であり、内部またはメッセージ経由で呼び出すことができます。
    パブリックな状態の変数に対しては、自動的にゲッター関数（下記参照）が生成されます。

.. ``internal``
..     Those functions and state variables can only be
..     accessed internally (i.e. from within the current contract
..     or contracts deriving from it), without using ``this``.
..     This is the default visibility level for state variables.

``internal``
    それらの関数と状態変数は、 ``this`` を使用せずに、内部的にのみ（すなわち、現在のコントラクトまたはそのコントラクトから派生したコントラクトの中から）アクセスできます。
    これは状態変数のデフォルトの可視性レベルです。

``private``
    プライベート関数とプレイベート状態変数は、それらが定義されているコントラクトでのみ利用でき、派生コントラクトでは利用できません。

.. .. note::

..     Everything that is inside a contract is visible to
..     all observers external to the blockchain. Making something ``private``
..     only prevents other contracts from reading or modifying
..     the information, but it will still be visible to the
..     whole world outside of the blockchain.

.. note::

    コントラクトの中にあるものはすべて、ブロックチェーンの外部にいるすべてのオブザーバーから見えるようになっています。
    何かを ``private`` にしても、他のコントラクトが情報を読んだり修正したりすることを防ぐことができるだけで、ブロックチェーンの外の全世界からは見える状態になります。

.. The visibility specifier is given after the type for
.. state variables and between parameter list and
.. return parameter list for functions.

可視性指定子は、状態変数の場合は型の後に、関数の場合はパラメータリストとリターンパラメータリストの間に与えられます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract C {
        function f(uint a) private pure returns (uint b) { return a + 1; }
        function setData(uint a) internal { data = a; }
        uint public data;
    }

.. In the following example, ``D``, can call ``c.getData()`` to retrieve the value of
.. ``data`` in state storage, but is not able to call ``f``. Contract ``E`` is derived from
.. ``C`` and, thus, can call ``compute``.

次の例では、 ``D`` は ``c.getData()`` を呼び出してステートのストレージ内にある ``data`` の値を取り出すことができますが、 ``f`` を呼び出すことはできません。
コントラクト ``E`` は ``C`` から派生したものであるため、 ``compute`` を呼び出すことができます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract C {
        uint private data;

        function f(uint a) private pure returns(uint b) { return a + 1; }
        function setData(uint a) public { data = a; }
        function getData() public view returns(uint) { return data; }
        function compute(uint a, uint b) internal pure returns (uint) { return a + b; }
    }

    // これはコンパイルできません
    contract D {
        function readData() public {
            C c = new C();
            uint local = c.f(7); // error: member `f` is not visible
            c.setData(3);
            local = c.getData();
            local = c.compute(3, 5); // error: member `compute` is not visible
        }
    }

    contract E is C {
        function g() public {
            C c = new C();
            uint val = compute(3, 5); // 内部メンバへのアクセス（親コントラクトから派生したもの）
        }
    }

.. index:: ! getter;function, ! function;getter
.. _getter-functions:

ゲッター関数
================

.. The compiler automatically creates getter functions for
.. all **public** state variables. For the contract given below, the compiler will
.. generate a function called ``data`` that does not take any
.. arguments and returns a ``uint``, the value of the state
.. variable ``data``. State variables can be initialized
.. when they are declared.

コンパイラは、すべての **public** 状態変数のゲッター関数を自動的に作成します。
以下のコントラクトでは、コンパイラーは ``data`` という関数を生成します。
この関数は引数を取らず、状態変数 ``data`` の値である ``uint`` を返します。
状態変数は、宣言時に初期化できます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract C {
        uint public data = 42;
    }

    contract Caller {
        C c = new C();
        function f() public view returns (uint) {
            return c.data();
        }
    }

.. The getter functions have external visibility. If the
.. symbol is accessed internally (i.e. without ``this.``),
.. it evaluates to a state variable.  If it is accessed externally
.. (i.e. with ``this.``), it evaluates to a function.

ゲッター関数は外部から見えるようになっています。
シンボルが内部的にアクセスされた場合（すなわち、 ``this.`` なし）、それは状態変数として評価されます。
外部からアクセスされた場合（つまり ``this.`` あり）、それは関数として評価されます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract C {
        uint public data;
        function x() public returns (uint) {
            data = 3; // internal access
            return this.data(); // 外部アクセス
        }
    }

.. If you have a ``public`` state variable of array type, then you can only retrieve
.. single elements of the array via the generated getter function. This mechanism
.. exists to avoid high gas costs when returning an entire array. You can use
.. arguments to specify which individual element to return, for example
.. ``myArray(0)``. If you want to return an entire array in one call, then you need
.. to write a function, for example:

配列型の ``public`` 状態変数を持っている場合、生成されたゲッター関数を介して配列の単一要素を取り出すことしかできません。
このメカニズムは、配列全体を返すときの高いガスコストを避けるために存在します。
引数を使って、例えば ``myArray(0)`` のように、どの個別要素を返すかを指定できます。
一度の呼び出しで配列全体を返したい場合は、例えば、関数を書く必要があります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract arrayExample {
        // パブリック状態変数
        uint[] public myArray;

        // コンパイラが生成するゲッター関数
        /*
        function myArray(uint i) public view returns (uint) {
            return myArray[i];
        }
        */

        // 配列全体を返す関数
        function getArray() public view returns (uint[] memory) {
            return myArray;
        }
    }

.. Now you can use ``getArray()`` to retrieve the entire array, instead of
.. ``myArray(i)``, which returns a single element per call.

これで、1回の呼び出しで1つの要素を返す ``myArray(i)`` ではなく、 ``getArray()`` を使って配列全体を取り出すことができます。

.. The next example is more complex:

次の例はもっと複雑です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract Complex {
        struct Data {
            uint a;
            bytes3 b;
            mapping (uint => uint) map;
            uint[3] c;
            uint[] d;
            bytes e;
        }
        mapping (uint => mapping(bool => Data[])) public data;
    }

.. It generates a function of the following form. The mapping and arrays (with the
.. exception of byte arrays) in the struct are omitted because there is no good way
.. to select individual struct members or provide a key for the mapping:

次のような形式の関数を生成します。
構造体のマッピングと配列（バイト配列を除く）は、個々の構造体メンバーを選択する、あるいはマッピングにキーを提供する良い方法がないため、省略されています。

.. code-block:: solidity

    function data(uint arg1, bool arg2, uint arg3)
        public
        returns (uint a, bytes3 b, bytes memory e)
    {
        a = data[arg1][arg2][arg3].a;
        b = data[arg1][arg2][arg3].b;
        e = data[arg1][arg2][arg3].e;
    }

