.. index:: ! function;modifier

.. _modifiers:

******************
Function Modifiers
******************

.. Modifiers can be used to change the behaviour of functions in a declarative way.
.. For example,
.. you can use a modifier to automatically check a condition prior to executing the function.

修飾子は、宣言的な方法で関数の動作を変更するために使用できます。例えば、修飾子を使って、関数を実行する前に自動的に条件をチェックできます。

.. Modifiers are
.. inheritable properties of contracts and may be overridden by derived contracts, but only
.. if they are marked ``virtual``. For details, please see
.. :ref:`Modifier Overriding <modifier-overriding>`.

修飾子はコントラクトの継承可能なプロパティであり、派生コントラクトでオーバーライドできますが、 ``virtual`` マークが付いている場合に限ります。詳細は、 :ref:`Modifier Overriding <modifier-overriding>` を参照してください。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.1 <0.9.0;

    contract owned {
        constructor() { owner = payable(msg.sender); }
        address payable owner;

        // This contract only defines a modifier but does not use
        // it: it will be used in derived contracts.
        // The function body is inserted where the special symbol
        // `_;` in the definition of a modifier appears.
        // This means that if the owner calls this function, the
        // function is executed and otherwise, an exception is
        // thrown.
        modifier onlyOwner {
            require(
                msg.sender == owner,
                "Only owner can call this function."
            );
            _;
        }
    }

    contract destructible is owned {
        // This contract inherits the `onlyOwner` modifier from
        // `owned` and applies it to the `destroy` function, which
        // causes that calls to `destroy` only have an effect if
        // they are made by the stored owner.
        function destroy() public onlyOwner {
            selfdestruct(owner);
        }
    }

    contract priced {
        // Modifiers can receive arguments:
        modifier costs(uint price) {
            if (msg.value >= price) {
                _;
            }
        }
    }

    contract Register is priced, destructible {
        mapping (address => bool) registeredAddresses;
        uint price;

        constructor(uint initialPrice) { price = initialPrice; }

        // It is important to also provide the
        // `payable` keyword here, otherwise the function will
        // automatically reject all Ether sent to it.
        function register() public payable costs(price) {
            registeredAddresses[msg.sender] = true;
        }

        function changePrice(uint _price) public onlyOwner {
            price = _price;
        }
    }

    contract Mutex {
        bool locked;
        modifier noReentrancy() {
            require(
                !locked,
                "Reentrant call."
            );
            locked = true;
            _;
            locked = false;
        }

        /// This function is protected by a mutex, which means that
        /// reentrant calls from within `msg.sender.call` cannot call `f` again.
        /// The `return 7` statement assigns 7 to the return value but still
        /// executes the statement `locked = false` in the modifier.
        function f() public noReentrancy returns (uint) {
            (bool success,) = msg.sender.call("");
            require(success);
            return 7;
        }
    }

.. If you want to access a modifier ``m`` defined in a contract ``C``, you can use ``C.m`` to
.. reference it without virtual lookup. It is only possible to use modifiers defined in the current
.. contract or its base contracts. Modifiers can also be defined in libraries but their use is
.. limited to functions of the same library.

コントラクト ``C`` で定義されたモディファイア ``m`` にアクセスしたい場合は、 ``C.m`` を使って仮想ルックアップなしで参照できます。現在のコントラクトまたはそのベースコントラクトで定義された修飾子のみを使用できます。修飾子はライブラリで定義することもできますが、その使用は同じライブラリの関数に限られます。

.. Multiple modifiers are applied to a function by specifying them in a
.. whitespace-separated list and are evaluated in the order presented.

複数の修飾子をホワイトスペースで区切ったリストで指定すると、その関数に適用され、提示された順序で評価されます。

.. Modifiers cannot implicitly access or change the arguments and return values of functions they modify.
.. Their values can only be passed to them explicitly at the point of invocation.

修飾子は、自分が修飾する関数の引数や戻り値に暗黙のうちにアクセスしたり変更したりできません。修飾子の値は、呼び出しの時点で明示的に渡されるだけです。

.. Explicit returns from a modifier or function body only leave the current
.. modifier or function body. Return variables are assigned and
.. control flow continues after the ``_`` in the preceding modifier.

修飾子や関数本体からの明示的な戻りは、現在の修飾子や関数本体のみを残します。戻り値の変数は割り当てられ、制御フローは先行する修飾子の ``_`` の後に続きます。

.. .. warning::

..     In an earlier version of Solidity, ``return`` statements in functions
..     having modifiers behaved differently.

.. warning::

    Solidityの以前のバージョンでは、修飾子を持つ関数内の ``return`` 文の動作が異なっていました。

.. An explicit return from a modifier with ``return;`` does not affect the values returned by the function.
.. The modifier can, however, choose not to execute the function body at all and in that case the return
.. variables are set to their :ref:`default values<default-value>` just as if the function had an empty
.. body.

``return;`` を持つ修飾子からの明示的なリターンは、関数が返す値に影響を与えません。しかし、修飾子は、関数本体を全く実行しないことを選択でき、その場合、関数本体が空であった場合と同様に、戻り値の変数は :ref:`default values<default-value>` に設定されます。

.. The ``_`` symbol can appear in the modifier multiple times. Each occurrence is replaced with
.. the function body.

``_`` マークはモディファイアの中で複数回現れることがあります。それぞれの出現箇所は、関数本体で置き換えられます。

.. Arbitrary expressions are allowed for modifier arguments and in this context,
.. all symbols visible from the function are visible in the modifier. Symbols
.. introduced in the modifier are not visible in the function (as they might
.. change by overriding).
.. 

修飾子の引数には任意の式が許されており、このコンテキストでは、関数から見えるすべてのシンボルが修飾子でも見えます。修飾子で導入されたシンボルは、（オーバーライドによって変更される可能性があるため）関数では見えません。
