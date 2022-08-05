.. index:: ! function;modifier

.. _modifiers:

******************
関数修飾子
******************

修飾子は、宣言的な方法で関数の動作を変更するために使用できます。
例えば、修飾子を使って、関数を実行する前に自動的に条件をチェックできます。

修飾子はコントラクトの継承可能なプロパティであり、派生コントラクトでオーバーライドできますが、 ``virtual`` マークが付いている場合に限ります。
詳細は、 :ref:`修飾子のオーバーライド <modifier-overriding>` を参照してください。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.1 <0.9.0;

    contract owned {
        constructor() { owner = payable(msg.sender); }
        address payable owner;

        // このコントラクトは修飾子を定義するだけで、それを使用することはありません。派生コントラクトで使用されます。
        // 関数本体は、修飾子の定義にある特別な記号 `_;` が現れる場所に挿入されます。
        // これは、オーナーがこの関数を呼び出した場合は関数が実行され、そうでない場合は例外がスローされることを意味します。
        modifier onlyOwner {
            require(
                msg.sender == owner,
                "Only owner can call this function."
            );
            _;
        }
    }

    contract destructible is owned {
        // このコントラクトは `onlyOwner` 修飾子を `owned` から継承し、 `destroy` 関数に適用します。
        // これにより、 `destroy` への呼び出しは、保存されているオーナーによって実行された場合にのみ有効となります。
        function destroy() public onlyOwner {
            selfdestruct(owner);
        }
    }

    contract priced {
        // 修飾子は引数を受け取ることができます:
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

        // ここで `payable` キーワードを指定することも重要です。
        // さもなければ、この関数は送られてきたすべての Ether を自動的に拒否します。
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

        /// この関数はミューテックスで保護されているので、 `msg.sender.call` 内からのリエントラントなコールは `f` を再び呼び出すことができません。
        /// `return 7` 文は戻り値に 7 を代入しますが、その後に修飾子の `locked = false` という文は実行されます。
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

コントラクト ``C`` で定義された修飾子 ``m`` にアクセスしたい場合は、 ``C.m`` を使って仮想ルックアップなしで参照できます。
現在のコントラクトまたはそのベースコントラクトで定義された修飾子のみを使用できます。
修飾子はライブラリで定義することもできますが、その使用は同じライブラリの関数に限られます。

.. Multiple modifiers are applied to a function by specifying them in a
.. whitespace-separated list and are evaluated in the order presented.

複数の修飾子をホワイトスペースで区切ったリストで指定すると、その関数に適用され、提示された順序で評価されます。

.. Modifiers cannot implicitly access or change the arguments and return values of functions they modify.
.. Their values can only be passed to them explicitly at the point of invocation.

修飾子は、自分が修飾する関数の引数や戻り値に暗黙のうちにアクセスしたり変更したりできません。
修飾子の値は、呼び出しの時点で明示的に渡されるだけです。

.. Explicit returns from a modifier or function body only leave the current
.. modifier or function body. Return variables are assigned and
.. control flow continues after the ``_`` in the preceding modifier.

修飾子や関数本体からの明示的なリターンは、現在の修飾子や関数本体のみを残します。
戻り値の変数は割り当てられ、制御フローは先行する修飾子の ``_`` の後に続きます。

.. warning::

    Solidityの以前のバージョンでは、修飾子を持つ関数内の ``return`` 文の動作が異なっていました。

.. An explicit return from a modifier with ``return;`` does not affect the values returned by the function.
.. The modifier can, however, choose not to execute the function body at all and in that case the return
.. variables are set to their :ref:`default values<default-value>` just as if the function had an empty
.. body.

``return;`` を持つ修飾子からの明示的なリターンは、関数が返す値に影響を与えません。
しかし、修飾子は、関数本体を全く実行しないことを選択でき、その場合、関数本体が空であった場合と同様に、戻り値の変数は :ref:`デフォルト値<default-value>` に設定されます。

``_`` マークは修飾子の中で複数回現れることがあります。
それぞれの出現箇所は、関数本体で置き換えられます。

.. Arbitrary expressions are allowed for modifier arguments and in this context,
.. all symbols visible from the function are visible in the modifier. Symbols
.. introduced in the modifier are not visible in the function (as they might
.. change by overriding).
.. 

修飾子の引数には任意の式が許されており、このコンテキストでは、関数から見えるすべてのシンボルが修飾子でも見えます。
修飾子で導入されたシンボルは、（オーバーライドによって変更される可能性があるため）関数では見えません。
