.. index:: ! functions

.. _functions:

****
関数
****

.. Functions can be defined inside and outside of contracts.

関数は、コントラクトの内側にも外側にも定義できます。

.. Functions outside of a contract, also called "free functions", always have implicit ``internal``
.. :ref:`visibility<visibility-and-getters>`. Their code is included in all contracts
.. that call them, similar to internal library functions.

コントラクト外の関数は「フリー関数」とも呼ばれ、常に暗黙の ``internal`` :ref:`visibility<visibility-and-getters>` を持っています。
そのコードは、内部のライブラリ関数と同様に、それらを呼び出したすべてのコントラクトに含まれます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.1 <0.9.0;

    function sum(uint[] memory arr) pure returns (uint s) {
        for (uint i = 0; i < arr.length; i++)
            s += arr[i];
    }

    contract ArrayExample {
        bool found;
        function f(uint[] memory arr) public {
            // This calls the free function internally.
            // The compiler will add its code to the contract.
            uint s = sum(arr);
            require(s >= 10);
            found = true;
        }
    }

.. .. note::

.. Functions defined outside a contract are still always executed in the context of a contract.
.. They still can call other contracts, send them Ether and destroy the contract that called them, among other things.
.. The main difference to functions defined inside a contract is that free functions do not have direct access to the variable ``this``, storage variables and functions not in their scope.

.. note::

    コントラクトの外で定義された関数は、常にコントラクトのコンテキストで実行されます。
    他のコントラクトを呼び出したり、Etherを送ったり、呼び出したコントラクトを破壊したりできます。
    コントラクト内で定義された関数との主な違いは、フリー関数は変数 ``this`` やストレージ変数、自分のスコープにない関数に直接アクセスできないことです。

.. _function-parameters-return-variables:

関数パラメータと返り値
======================

.. Functions take typed parameters as input and may, unlike in many other
.. languages, also return an arbitrary number of values as output.

関数は入力として型付けされたパラメータを受け取り、他の多くの言語とは異なり、出力として任意の数の値を返せます。

関数パラメータ
--------------

関数のパラメータは変数と同じように宣言され、使わないパラメータの名前は省略できます。

.. For example, if you want your contract to accept one kind of external call
.. with two integers, you would use something like the following:

例えば、コントラクトが2つの整数で1種類の外部呼び出しを受け付けるようにしたい場合は、以下のようにします。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract Simple {
        uint sum;
        function taker(uint a, uint b) public {
            sum = a + b;
        }
    }

.. Function parameters can be used as any other local variable and they can also be assigned to.

関数パラメータは、他のローカル変数と同様に使用でき、また、それらを割り当てることもできます。

.. index:: return array, return string, array, string, array of strings, dynamic array, variably sized array, return struct, struct

リターン変数
------------

.. Function return variables are declared with the same syntax after the
.. ``returns`` keyword.

関数のリターン変数は、 ``returns`` キーワードの後に同じ構文で宣言されます。

.. For example, suppose you want to return two results: the sum and the product of
.. two integers passed as function parameters, then you use something like:

例えば、関数のパラメータとして渡された2つの整数の和と積の2つの結果を返したい場合、次のように使います。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract Simple {
        function arithmetic(uint a, uint b)
            public
            pure
            returns (uint sum, uint product)
        {
            sum = a + b;
            product = a * b;
        }
    }

.. The names of return variables can be omitted.
.. Return variables can be used as any other local variable and they
.. are initialized with their :ref:`default value <default-value>` and have that
.. value until they are (re-)assigned.

リターン変数の名前は省略可能です。リターン変数は、他のローカル変数と同様に使用でき、 :ref:`default value <default-value>` で初期化され、（再）割り当てされるまでその値を保持します。

.. You can either explicitly assign to return variables and
.. then leave the function as above,
.. or you can provide return values
.. (either a single or :ref:`multiple ones<multi-return>`) directly with the ``return``
.. statement:

上記のように明示的にリターン変数に代入してから関数を残すか、 ``return`` 文でリターン値（シングルまたは :ref:`multiple ones<multi-return>` ）を直接指定できます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract Simple {
        function arithmetic(uint a, uint b)
            public
            pure
            returns (uint sum, uint product)
        {
            return (a + b, a * b);
        }
    }

.. If you use an early ``return`` to leave a function that has return variables,
.. you must provide return values together with the return statement.

return変数を持つ関数を終了するためにearly  ``return`` を使用する場合は、return文と一緒にreturn値を指定する必要があります。

.. note::

    You cannot return some types from non-internal functions.
    This includes the types listed below and any composite types that recursively contain them:

    - mappings,
    - internal function types,
    - reference types with location set to ``storage``,
    - multi-dimensional arrays (applies only to :ref:`ABI coder v1 <abi_coder>`),
    - structs (applies only to :ref:`ABI coder v1 <abi_coder>`).

    This restriction does not apply to library functions because of their different :ref:`internal ABI <library-selectors>`.

.. _multi-return:

複数の値を返す
-------------------------

.. When a function has multiple return types, the statement ``return (v0, v1, ..., vn)`` can be used to return multiple values.
.. The number of components must be the same as the number of return variables
.. and their types have to match, potentially after an :ref:`implicit conversion <types-conversion-elementary-types>`.

関数が複数の戻り値の型を持つ場合、 ``return (v0, v1, ..., vn)`` という文を複数の値を返すために使用できます。
構成要素の数は戻り値の変数の数と同じでなければならず、また、 :ref:`暗黙の変換 <types-conversion-elementary-types>` の後にそれらの型は一致しなければなりません。

.. _state-mutability:

ステートのミュータビリティ
===========================

.. index:: ! view function, function;view

.. _view-functions:

View関数
--------------

関数は ``view`` を宣言でき、その場合は状態を変更しないことが約束されます。

.. .. note::

..   If the compiler's EVM target is Byzantium or newer (default) the opcode
..   ``STATICCALL`` is used when ``view`` functions are called, which enforces the state
..   to stay unmodified as part of the EVM execution. For library ``view`` functions
..   ``DELEGATECALL`` is used, because there is no combined ``DELEGATECALL`` and ``STATICCALL``.
..   This means library ``view`` functions do not have run-time checks that prevent state
..   modifications. This should not impact security negatively because library code is
..   usually known at compile-time and the static checker performs compile-time checks.

.. note::

    コンパイラのEVMのターゲットがByzantium以降（デフォルト）の場合、 ``view`` 関数が呼び出されるとオペコード ``STATICCALL`` が使用され、EVM実行の一部として状態が変更されないように強制されます。
    ライブラリ ``view`` 関数では、 ``DELEGATECALL`` と ``STATICCALL`` の組み合わせがないため、 ``DELEGATECALL`` が使用されます。
    つまり、ライブラリ ``view`` 関数には、状態の変更を防ぐランタイムチェックがありません。
    ライブラリのコードは通常、コンパイル時に知られており、静的チェッカーはコンパイル時のチェックを行うため、このことがセキュリティに悪影響を及ぼすことはありません。

.. The following statements are considered modifying the state:

次のような記述は、状態の修正とみなされます。

.. #. Writing to state variables.
.. #. :ref:`Emitting events <events>`.
.. #. :ref:`Creating other contracts <creating-contracts>`.
.. #. Using ``selfdestruct``.
.. #. Sending Ether via calls.
.. #. Calling any function not marked ``view`` or ``pure``.
.. #. Using low-level calls.
.. #. Using inline assembly that contains certain opcodes.

#. 状態変数への書き込み。
#. :ref:`イベントの発生<events>` 。
#. :ref:`他のコントラクトの作成<creating-contracts>` 。
#. ``selfdestruct`` の使用。
#. コールでのEtherの送金。
#. ``view`` または ``pure`` と表示されていない関数の呼び出し。
#. 低レベルコールの使用。
#. 特定のオペコードを含むインラインアセンブリの使用。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.5.0 <0.9.0;

    contract C {
        function f(uint a, uint b) public view returns (uint) {
            return a * (b + 42) + block.timestamp;
        }
    }

.. note::

    関数の ``constant`` は、かつては ``view`` の別名でしたが、バージョン0.5.0で廃止されました。


.. note::

    ゲッターメソッドは自動的に ``view`` とマークされます。

.. .. note::

..   Prior to version 0.5.0, the compiler did not use the ``STATICCALL`` opcode
..   for ``view`` functions.
..   This enabled state modifications in ``view`` functions through the use of
..   invalid explicit type conversions.
..   By using  ``STATICCALL`` for ``view`` functions, modifications to the
..   state are prevented on the level of the EVM.

.. note::

    バージョン0.5.0以前のコンパイラでは、 ``view`` 関数に ``STATICCALL`` オペコードを使用していませんでした。
    これにより、無効な明示的型変換を使用して、 ``view`` 関数の状態を変更できました。
    ``view`` 関数に ``STATICCALL`` を使用することで、EVMのレベルで状態の変更を防ぐことができます。

.. index:: ! pure function, function;pure

.. _pure-functions:

Pure関数
--------------

.. Functions can be declared ``pure`` in which case they promise not to read from or modify the state.
.. In particular, it should be possible to evaluate a ``pure`` function at compile-time given
.. only its inputs and ``msg.data``, but without any knowledge of the current blockchain state.
.. This means that reading from ``immutable`` variables can be a non-pure operation.

関数は ``pure`` を宣言でき、その場合、状態を読み取ったり変更したりしないことが約束されます。
特に、 ``pure`` 関数をコンパイル時に、入力と ``msg.data`` のみを与えて評価することが可能でなければなりませんが、現在のブロックチェーンの状態については一切知りません。
これは、 ``immutable`` 変数からの読み取りが非純粋な操作である可能性があることを意味します。

.. .. note::

..   If the compiler's EVM target is Byzantium or newer (default) the opcode ``STATICCALL`` is used,
..   which does not guarantee that the state is not read, but at least that it is not modified.

.. note::

    コンパイラのEVMターゲットがByzantium以降（デフォルト）の場合、オペコード ``STATICCALL`` が使用されます。
    これは、状態が読み取られないことを保証するものではありませんが、少なくとも修正されないことを保証するものです。

.. In addition to the list of state modifying statements explained above, the following are considered reading from the state:

上記で説明したステートの修飾文のリストに加えて、以下のものはステートからの読み取りとみなされます。

.. #. Reading from state variables.
.. #. Accessing ``address(this).balance`` or ``<address>.balance``.
.. #. Accessing any of the members of ``block``, ``tx``, ``msg`` (with the exception of ``msg.sig`` and ``msg.data``).
.. #. Calling any function not marked ``pure``.
.. #. Using inline assembly that contains certain opcodes.

#. 状態変数からの読み出し。

#. ``address(this).balance`` または ``<address>.balance`` へのアクセス。

#. ``block`` 、 ``tx`` 、 ``msg`` （ ``msg.sig`` 、 ``msg.data`` を除く）のメンバーのいずれかにアクセスすること。

#. ``pure`` とマークされていない関数を呼び出すこと。

#. 特定のオペコードを含むインラインアセンブリの使用。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.5.0 <0.9.0;

    contract C {
        function f(uint a, uint b) public pure returns (uint) {
            return a * (b + 42);
        }
    }

.. Pure functions are able to use the ``revert()`` and ``require()`` functions to revert
.. potential state changes when an :ref:`error occurs <assert-and-require>`.

Pure関数は、 :ref:`エラーが発生 <assert-and-require>` したときに、 ``revert()`` および ``require()`` 関数を使って潜在的な状態変化を戻すことができます。

.. Reverting a state change is not considered a "state modification", as only changes to the
.. state made previously in code that did not have the ``view`` or ``pure`` restriction
.. are reverted and that code has the option to catch the ``revert`` and not pass it on.

``view`` や ``pure`` の制限を受けていないコードで以前に行われた状態の変更のみが元に戻され、そのコードは ``revert`` をキャッチして渡さないというオプションを持っているため、状態の変更を元に戻すことは「状態の修正」とはみなされません。

.. This behaviour is also in line with the ``STATICCALL`` opcode.

この動作は、 ``STATICCALL`` のオペコードとも一致しています。

.. .. warning::

..   It is not possible to prevent functions from reading the state at the level
..   of the EVM, it is only possible to prevent them from writing to the state
..   (i.e. only ``view`` can be enforced at the EVM level, ``pure`` can not).

.. warning::

  EVMのレベルで関数が状態を読み取るのを防ぐことはできず、状態に書き込むのを防ぐことしかできません（つまり、EVMのレベルで強制できるのは ``view`` だけで、 ``pure`` はできません）。

.. .. note::

..   Prior to version 0.5.0, the compiler did not use the ``STATICCALL`` opcode
..   for ``pure`` functions.
..   This enabled state modifications in ``pure`` functions through the use of
..   invalid explicit type conversions.
..   By using  ``STATICCALL`` for ``pure`` functions, modifications to the
..   state are prevented on the level of the EVM.

.. note::

    バージョン0.5.0以前のコンパイラでは、 ``pure`` 関数に ``STATICCALL`` オペコードを使用していませんでした。
    これにより、無効な明示的型変換を使用して、 ``pure`` 関数の状態を変更できました。
    ``pure`` 関数に ``STATICCALL`` を使用することで、EVMのレベルで状態の変更を防ぐことができます。

.. .. note::

..   Prior to version 0.4.17 the compiler did not enforce that ``pure`` is not reading the state.
..   It is a compile-time type check, which can be circumvented doing invalid explicit conversions
..   between contract types, because the compiler can verify that the type of the contract does
..   not do state-changing operations, but it cannot check that the contract that will be called
..   at runtime is actually of that type.

.. note::

    バージョン0.4.17以前では、コンパイラは ``pure`` が状態を読んでいないことを強制していませんでした。
    これはコンパイル時の型チェックで、コントラクトの型の間で無効な明示的変換を行うことで回避できます。
    コンパイラはコントラクトの型が状態を変更する操作を行わないことを検証できますが、実行時に呼び出されるコントラクトが実際にその型であることをチェックできないからです。

.. _special-functions:

特殊な関数
=================

.. index:: ! receive ether function, function;receive ! receive

.. _receive-ether-function:

Receive Ether関数
----------------------

.. A contract can have at most one ``receive`` function, declared using
.. ``receive() external payable { ... }``
.. (without the ``function`` keyword).
.. This function cannot have arguments, cannot return anything and must have
.. ``external`` visibility and ``payable`` state mutability.
.. It can be virtual, can override and can have modifiers.

コントラクトは最大で1つの ``receive`` 関数を持つことができ、 ``receive() external payable { ... }`` を使って宣言されます（ ``function`` キーワードなし）。
この関数は、引数を持つことができず、何も返すことができず、 ``external`` の可視性と ``payable`` の状態変更性を持たなければなりません。
この関数は仮想的であり、オーバーライドでき、修飾子を持つことができます。

.. The receive function is executed on a call to the contract with empty calldata. This is the function that is executed on plain Ether transfers (e.g. via ``.send()`` or ``.transfer()``).
.. If no such function exists, but a payable :ref:`fallback function <fallback-function> exists, the fallback function will be called on a plain Ether transfer.
.. If neither a receive Ether nor a payable fallback function is present, the contract cannot receive Ether through a transaction that does not represent a payable function call and throws an exception.

receive関数は、空のcalldataを持つコントラクトへの呼び出しで実行されます。
これは、プレーンなEther送金（例:  ``.send()`` または ``.transfer()`` 経由）で実行される関数です。
このような関数が存在せず、payableな :ref:`fallback関数 <fallback-function>` が存在する場合は、プレーンなEther送金時にフォールバック関数が呼び出されます。
receive Ether関数もpayable fallback関数も存在しない場合、コントラクトはpayableな関数呼び出しを表さないトランザクションを通じてEtherを受信できず、例外をスローします。

.. In the worst case, the ``receive`` function can only rely on 2300 gas being
.. available (for example when ``send`` or ``transfer`` is used), leaving little
.. room to perform other operations except basic logging. The following operations
.. will consume more gas than the 2300 gas stipend:

最悪の場合、 ``receive`` 関数は2300のガスが使えることに頼るしかなく（ ``send`` や ``transfer`` を使用した場合など）、基本的なロギング以外の操作を行う余裕はありません。以下のような操作は、2300ガスの規定値よりも多くのガスを消費します。

.. - Writing to storage
.. - Creating a contract
.. - Calling an external function which consumes a large amount of gas
.. - Sending Ether

- ストレージへの書き込み

- コントラクトの作成

- 大量のガスを消費する外部関数の呼び出し

- Etherの送信

.. warning::
    When Ether is sent directly to a contract (without a function call, i.e. sender uses ``send`` or ``transfer``)
    but the receiving contract does not define a receive Ether function or a payable fallback function,
    an exception will be thrown, sending back the Ether (this was different
    before Solidity v0.4.0). If you want your contract to receive Ether,
    you have to implement a receive Ether function (using payable fallback functions for receiving Ether is
    not recommended, since the fallback is invoked and would not fail for interface confusions
    on the part of the sender).

.. .. warning::

..     A contract without a receive Ether function can receive Ether as a
..     recipient of a *coinbase transaction* (aka *miner block reward*)
..     or as a destination of a ``selfdestruct``.

..     A contract cannot react to such Ether transfers and thus also
..     cannot reject them. This is a design choice of the EVM and
..     Solidity cannot work around it.

..     It also means that ``address(this).balance`` can be higher
..     than the sum of some manual accounting implemented in a
..     contract (i.e. having a counter updated in the receive Ether function).

.. warning::

    Etherを受け取る関数を持たないコントラクトは、 *coinbaseトランザクション* （別名: *minerブロックリワード* ）の受信者として、または ``selfdestruct`` の宛先としてEtherを受け取ることができます。

    コントラクトは、そのようなEther送金に反応できず、したがって、それらを拒否することもできません。
    これはEVMの設計上の選択であり、Solidityはこれを回避できません。

    また、 ``address(this).balance`` は、コントラクトに実装されている手動の会計処理（receive Ether関数でカウンタを更新するなど）の合計よりも高くなる可能性があることを意味しています。

関数 ``receive`` を使用したSinkコントラクトの例です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    // このコントラクトは、送られてきたEtherをすべて保持し、それを取り戻す方法はない。
    contract Sink {
        event Received(address, uint);
        receive() external payable {
            emit Received(msg.sender, msg.value);
        }
    }

.. index:: ! fallback function, function;fallback

.. _fallback-function:

Fallback関数
-----------------

.. A contract can have at most one ``fallback`` function, declared using either ``fallback () external [payable]``
.. or ``fallback (bytes calldata input) external [payable] returns (bytes memory output)``
.. (both without the ``function`` keyword).
.. This function must have ``external`` visibility. A fallback function can be virtual, can override
.. and can have modifiers.

コントラクトは最大で1つの ``fallback`` 関数を持つことができ、 ``fallback () external [payable]`` または ``fallback (bytes calldata input) external [payable] returns (bytes memory output)`` （いずれも ``function`` キーワードなし）を使って宣言されます。
この関数は ``external`` 可視性を持たなければなりません。
フォールバック関数は、仮想的であり、オーバーライドでき、修飾子を持つことができます。

.. The fallback function is executed on a call to the contract if none of the other
.. functions match the given function signature, or if no data was supplied at
.. all and there is no :ref:`receive Ether function <receive-ether-function>`.
.. The fallback function always receives data, but in order to also receive Ether
.. it must be marked ``payable``.

フォールバック関数は、他の関数が与えられた関数シグネチャに一致しない場合、またはデータが全く供給されず :ref:`receive Ether関数 <receive-ether-function>` がない場合、コントラクトへの呼び出しで実行されます。
フォールバック関数は常にデータを受信しますが、Etherも受信するためには、 ``payable`` とマークされていなければなりません。

.. If the version with parameters is used, ``input`` will contain the full data sent to the contract
.. (equal to ``msg.data``) and can return data in ``output``. The returned data will not be
.. ABI-encoded. Instead it will be returned without modifications (not even padding).

パラメータ付きバージョンを使用した場合、 ``input`` にはコントラクトに送信された完全なデータ（ ``msg.data`` に等しい）が含まれ、 ``output`` でデータを返すことができます。返されたデータはABIエンコードされません。代わりに、修正なしで（パディングさえもしない）返されます。

.. In the worst case, if a payable fallback function is also used in
.. place of a receive function, it can only rely on 2300 gas being
.. available (see :ref:`receive Ether function <receive-ether-function>`
.. for a brief description of the implications of this).

最悪の場合、受信関数の代わりに支払い可能なフォールバック関数も使用されている場合、2300ガスが使用可能であることだけに頼ることができます（この意味については、 :ref:`receive Ether関数 <receive-ether-function>` を参照してください）。

他の関数と同様に、fallback関数も、十分な量のガスが渡されている限り、複雑な処理を実行できます。

.. .. warning::

..     A ``payable`` fallback function is also executed for
..     plain Ether transfers, if no :ref:`receive Ether function <receive-ether-function>`
..     is present. It is recommended to always define a receive Ether
..     function as well, if you define a payable fallback function
..     to distinguish Ether transfers from interface confusions.

.. warning::

    ``payable`` フォールバック関数は、 :ref:`receive Ether関数<receive-ether-function>` が存在しない場合、プレーンなEther送金に対しても実行されます。
    Ether送金をインターフェースの混乱と区別するために、payable fallback関数を定義する場合は、必ずreceive Ether関数も定義することをお勧めします。

.. .. note::

..     If you want to decode the input data, you can check the first four bytes
..     for the function selector and then
..     you can use ``abi.decode`` together with the array slice syntax to
..     decode ABI-encoded data:
..     ``(c, d) = abi.decode(input[4:], (uint256, uint256));``
..     Note that this should only be used as a last resort and
..     proper functions should be used instead.

.. note::

    入力データをデコードしたい場合は、最初の4バイトで関数セレクタをチェックし、 ``abi.decode`` と配列スライス構文を併用することで、ABIエンコードされたデータをデコードできます。
    ``(c, d) = abi.decode(input[4:], (uint256, uint256));``
    この方法は最後の手段としてのみ使用し、代わりに適切な関数を使用すべきであることに注意してください。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.2 <0.9.0;

    contract Test {
        uint x;
        // この関数はこのコントラクトに送られるすべてのメッセージに対して呼び出されます（他の関数は存在しません）。
        // このコントラクトにEtherを送信すると例外が発生します。なぜなら、fallback関数が `payable` 修飾子を持たないからです。
        fallback() external { x = 1; }
    }

    contract TestPayable {
        uint x;
        uint y;
        // この関数は、プレーンなEther送金を除く、このコントラクトに送信されるすべてのメッセージに対して呼び出されます（受信関数以外の関数は存在しません）。
        // このコントラクトへの空でないcalldataを持つ呼び出しは、フォールバック関数を実行します（呼び出しと一緒にEtherが送信された場合でも同様です）。
        fallback() external payable { x = 1; y = msg.value; }

        // この関数は、プレーンなEther送金、すなわち空のcalldataを持つすべてのコールに対して呼び出されます。
        receive() external payable { x = 2; y = msg.value; }
    }

    contract Caller {
        function callTest(Test test) public returns (bool) {
            (bool success,) = address(test).call(abi.encodeWithSignature("nonExistingFunction()"));
            require(success);
            // test.xが1になる

            // address(test) は ``send`` を直接呼び出すことはできません。
            // なぜなら、 ``test`` には支払い可能なフォールバック関数がないからです。
            // その上で ``send`` を呼び出すには ``address payable`` 型に変換する必要があります。
            address payable testPayable = payable(address(test));

            // 誰かがそのコントラクトにEtherを送ると、送金は失敗します。
            // つまり、ここではfalseが返されます。
            return testPayable.send(2 ether);
        }

        function callTestPayable(TestPayable test) public returns (bool) {
            (bool success,) = address(test).call(abi.encodeWithSignature("nonExistingFunction()"));
            require(success);
            // test.xが1、test.yが0になります
            (success,) = address(test).call{value: 1}(abi.encodeWithSignature("nonExistingFunction()"));
            require(success);
            // test.xが1、test.yが1になります

            // 誰かがそのコントラクトにEtherを送ると、TestPayableのreceive関数が呼び出されます。
            // この関数はストレージに書き込むので、単純な ``send`` や ``transfer`` よりも多くのガスを消費します。
            // そのため、低レベルの呼び出しを使用する必要があります。
            (success,) = address(test).call{value: 2 ether}("");
            require(success);
            // test.xが2、test.yが2 etherになります。

            return true;
        }
    }

.. index:: ! overload

.. _overload-function:

関数のオーバーロード
====================

.. A contract can have multiple functions of the same name but with different parameter
.. types.
.. This process is called "overloading" and also applies to inherited functions.
.. The following example shows overloading of the function
.. ``f`` in the scope of contract ``A``.

コントラクトは、同じ名前でパラメータの種類が異なる複数の関数を持つことができます。
この処理は「オーバーロード」と呼ばれ、継承された関数にも適用されます。
次の例では、コントラクト ``A`` のスコープ内での関数 ``f`` のオーバーロードを示しています。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract A {
        function f(uint value) public pure returns (uint out) {
            out = value;
        }

        function f(uint value, bool really) public pure returns (uint out) {
            if (really)
                out = value;
        }
    }

.. Overloaded functions are also present in the external interface. It is an error if two
.. externally visible functions differ by their Solidity types but not by their external types.

オーバーロードされた関数は、外部インターフェースにも存在します。
外部から見える2つの関数が、Solidityの型ではなく、外部の型で異なる場合はエラーになります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    // これはコンパイルできません
    contract A {
        function f(B value) public pure returns (B out) {
            out = value;
        }

        function f(address value) public pure returns (address out) {
            out = value;
        }
    }

    contract B {
    }

.. Both ``f`` function overloads above end up accepting the address type for the ABI although
.. they are considered different inside Solidity.

上記の両方の ``f`` 関数のオーバーロードは、Solidity内では異なるものと考えられていますが、最終的にはABI用のアドレス型を受け入れます。

オーバーロードの解決と引数のマッチング
-----------------------------------------

.. Overloaded functions are selected by matching the function declarations in the current scope
.. to the arguments supplied in the function call. Functions are selected as overload candidates
.. if all arguments can be implicitly converted to the expected types. If there is not exactly one
.. candidate, resolution fails.

オーバーロードされた関数は、現在のスコープ内の関数宣言と、関数呼び出しで提供される引数を照合することで選択されます。
すべての引数が期待される型に暗黙的に変換できる場合、関数はオーバーロードの候補として選択されます。
正確に1つの候補がない場合、解決は失敗します。

.. .. note::

..     Return parameters are not taken into account for overload resolution.

.. note::

    オーバーロードの解決にリターンパラメータは考慮されません。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    contract A {
        function f(uint8 val) public pure returns (uint8 out) {
            out = val;
        }

        function f(uint256 val) public pure returns (uint256 out) {
            out = val;
        }
    }

.. Calling ``f(50)`` would create a type error since ``50`` can be implicitly converted both to ``uint8``
.. and ``uint256`` types. On another hand ``f(256)`` would resolve to ``f(uint256)`` overload as ``256`` cannot be implicitly
.. converted to ``uint8``.
.. 

``f(50)`` を呼び出すと、 ``50`` は暗黙のうちに ``uint8`` 型と ``uint256`` 型の両方に変換できるため、型エラーが発生します。
一方、 ``f(256)`` は、 ``256`` が暗黙のうちに ``uint8`` に変換できないため、 ``f(uint256)`` のオーバーロードとなります。
