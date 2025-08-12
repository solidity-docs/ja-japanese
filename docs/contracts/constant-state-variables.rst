.. index:: ! constant

.. _constants:

****************************************
定数の状態変数とイミュータブルの状態変数
****************************************

状態変数は ``constant`` または ``immutable`` として宣言できます。
どちらの場合も、コントラクトが構築された後は、変数を変更できません。
``constant`` 変数の場合はコンパイル時に値を固定する必要がありますが、 ``immutable`` の場合はコンストラクション時にも値を代入できます。

また、ファイルレベルで ``constant`` 変数を定義することも可能です。

.. Every occurrence of such a variable in the source is replaced by its underlying value and the compiler does not reserve a storage slot for it.
.. It cannot be assigned a slot in transient storage using the ``transient`` keyword either.

このような変数は、ソースコード内で出現するたびにその指定した値に置き換えられ、コンパイラはそのためのストレージスロットを確保しません。
また、 ``transient`` キーワードを使用してトランジェントストレージ内にスロットを割り当てることもできません。

.. Compared to regular state variables, the gas costs of constant and immutable variables
.. are much lower. For a constant variable, the expression assigned to it is copied to
.. all the places where it is accessed and also re-evaluated each time. This allows for local
.. optimizations. Immutable variables are evaluated once at construction time and their value
.. is copied to all the places in the code where they are accessed. For these values,
.. 32 bytes are reserved, even if they would fit in fewer bytes. Due to this, constant values
.. can sometimes be cheaper than immutable values.

通常の状態変数と比較して、定数変数やイミュータブル変数のガスコストは非常に低くなります。
定数変数の場合、それに割り当てられた式は、アクセスされるすべての場所にコピーされ、また毎回再評価されます。
これにより、局所的な最適化が可能になります。
イミュータブルの変数は、構築時に一度だけ評価され、その値はコード内のアクセスされるすべての場所にコピーされます。
これらの値のために、たとえそれより少ないバイト数で収まるとしても、32バイトが確保されます。
このため、定数値の方がイミュータブル値よりもコストが低い場合があります。

現時点では、定数やイミュータブルのすべての型が実装されているわけではありません。
サポートされているのは、 :ref:`strings <strings>` （定数のみ）と :ref:`値型<value-types>` のみです。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.21;

    uint constant X = 32**22 + 8;

    contract C {
        string constant TEXT = "abc";
        bytes32 constant MY_HASH = keccak256("abc");
        uint immutable decimals = 18;
        uint immutable maxBalance;
        address immutable owner = msg.sender;

        constructor(uint decimals_, address ref) {
            if (decimals_ != 0)
                // Immutables are only immutable when deployed.
                // At construction time they can be assigned to any number of times.
                decimals = decimals_;

            // Assignments to immutables can even access the environment.
            maxBalance = ref.balance;
        }

        function isBalanceTooHigh(address other) public view returns (bool) {
            return other.balance > maxBalance;
        }
    }

定数
====

.. For ``constant`` variables, the value has to be a constant at compile time and it has to be
.. assigned where the variable is declared. Any expression
.. that accesses storage, blockchain data (e.g. ``block.timestamp``, ``address(this).balance`` or
.. ``block.number``) or
.. execution data (``msg.value`` or ``gasleft()``) or makes calls to external contracts is disallowed. Expressions
.. that might have a side-effect on memory allocation are allowed, but those that
.. might have a side-effect on other memory objects are not. The built-in functions
.. ``keccak256``, ``sha256``, ``ripemd160``, ``ecrecover``, ``addmod`` and ``mulmod``
.. are allowed (even though, with the exception of ``keccak256``, they do call external contracts).

``constant`` 変数については、コンパイル時に値が定数である必要があり、変数が宣言された場所で代入されなければなりません。
ストレージ、ブロックチェーンデータ（例:  ``block.timestamp`` 、 ``address(this).balance`` 、 ``block.number`` ）、実行データ（ ``msg.value`` 、 ``gasleft()`` ）にアクセスしたり、外部コントラクトを呼び出したりする式はすべて許可されていません。
メモリの割り当てに副作用を及ぼす可能性のある式は許可されますが、他のメモリオブジェクトに副作用を及ぼす可能性のある式は許可されません。
組み込み関数の ``keccak256`` 、 ``sha256`` 、 ``ripemd160`` 、 ``ecrecover`` 、 ``addmod`` 、 ``mulmod`` は許可されています（ ``keccak256`` を除いて外部コントラクトをコールしていますが）。

.. The reason behind allowing side-effects on the memory allocator is that it
.. should be possible to construct complex objects like e.g. lookup-tables.
.. This feature is not yet fully usable.

メモリアロケータの副作用を許可した理由は、ルックアップテーブルなどの複雑なオブジェクトを構築できるようにするためです。
この機能はまだ完全には使用できません。

イミュータブル
==============

``immutable`` として宣言された変数は、 ``constant`` として宣言された変数よりも制限が緩いです。
具体的には、イミュータブルの変数は、コントラクション時に値を代入できます。
その値は、デプロイメントの前であればいつでも変更でき、その後永続的な値になります。

.. One additional restriction is that immutables can only be assigned to inside expressions for which there is no possibility of being executed after creation.
.. This excludes all modifier definitions and functions other than constructors.

もう一つの制限として、 ``immutable`` 変数への代入は、その実行が作成後に行われる可能性がない式の中でのみ行うことができます。
これは、すべての modifier 定義およびコンストラクタ以外の関数を除外することを意味します。

.. There are no restrictions on reading immutable variables.
.. The read is even allowed to happen before the variable is written to for the first time because variables in Solidity always have a well-defined initial value.
.. For this reason it is also allowed to never explicitly assign a value to an immutable.

``immutable`` 変数の読み取りには制限はありません。
Solidity では変数には常に明確に定義された初期値があるため、変数が初めて書き込まれる前に読み取ることも許可されています。
このため、 ``immutable`` 変数に明示的に値を代入しないことも許容されます。

.. warning::
    .. When accessing immutables at construction time, please keep the :ref:`initialization order <state-variable-initialization-order>` in mind.
    .. Even if you provide an explicit initializer, some expressions may end up being evaluated before that initializer, especially when they are at a different level in inheritance hierarchy.

    コンストラクション時に ``immutable`` 変数へアクセスする場合は、:ref:`初期化の順序 <state-variable-initialization-order>` に注意してください。
    明示的に初期化子を指定した場合でも、特に継承階層の異なるレベルにある場合は、いくつかの式がその初期化子よりも前に評価される可能性があります。

.. note::
    .. Before Solidity 0.8.21 initialization of immutable variables was more restrictive.
    .. Such variables had to be initialized exactly once at construction time and could not be read before then.

    Solidity 0.8.21 より前のバージョンでは、 ``immutable`` 変数の初期化はより制限されていました。
    これらの変数はコンストラクション時にちょうど一度だけ初期化される必要があり、それ以前に読み取ることはできませんでした。

.. The contract creation code generated by the compiler will modify the contract's runtime code before it is returned by replacing all references to immutables with the values assigned to them.
.. This is important if you are comparing the runtime code generated by the compiler with the one actually stored in the blockchain.
.. The compiler outputs where these immutables are located in the deployed bytecode in the ``immutableReferences`` field of the :ref:`compiler JSON standard output <compiler-api>`.

コンパイラが生成したコントラクト作成コードは、イミュータブルへのすべての参照をイミュータブルに割り当てられた値に置き換えることで、コントラクトのランタイムコードを返す前に修正します。
これは、コンパイラによって生成されたランタイムコードと、実際にブロックチェーンに保存されているランタイムコードを比較する場合に重要です。
コンパイラは、デプロイされたバイトコードのどこにこれらのイミュータブルがあるかを :ref:`コンパイラのJSONスタンダードアウトプット <compiler-api>` の ``immutableReferences`` フィールドに出力します。
