.. index:: ! custom storage layout, ! storage layout specifier, ! layout at, ! base slot

.. _custom-storage-layout:

****************************
カスタムストレージレイアウト
****************************

.. A contract can define an arbitrary location for its storage using the ``layout`` specifier.
.. The contract's state variables, including those inherited from base contracts, start from the specified base slot instead of the default slot zero.

コントラクトは ``layout`` 指定子を使って、ストレージの開始位置を任意に定義できます。
この場合、基底コントラクトから継承された変数を含む状態変数は、デフォルトのスロット 0 ではなく、指定されたベーススロットから配置されます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.29;

    contract C layout at 0xAAAA + 0x11 {
        uint[3] x; // Occupies slots 0xAABB..0xAABD
    }

.. As the above example shows, the specifier uses the ``layout at <base-slot-expression>`` syntax and is located in the header of a contract definition.

<<<<<<< HEAD
上の例に示されているように、この指定子は ``layout at <base-slot-expression>`` という構文を使用し、
コントラクト定義のヘッダー部分に記述されます。
=======
The layout specifier can be placed either before or after the inheritance specifier, and can appear at most once.
The ``base-slot-expression`` must be an :ref:`integer literal<rational_literals>` expression
that can be evaluated at compilation time and yields a value in the range of ``uint256``.
The use of constants initialized using such expressions is also allowed.
>>>>>>> english/develop

.. The layout specifier can be placed either before or after the inheritance specifier, and can appear at most once.
.. The ``base-slot-expression`` must be an :ref:`integer literal<rational_literals>` expression that can be evaluated at compilation time and yields a value in the range of ``uint256``.

layout 指定子は、継承指定子の前でも後でも記述可能で、1つのコントラクトにつき1回までしか使用できません。
``base-slot-expression`` は、コンパイル時に評価可能な :ref:`整数リテラル<rational_literals>` 式である必要があり、
その値は ``uint256`` の範囲内でなければなりません。

.. A custom layout cannot make contract's storage "wrap around".
.. If the selected base slot would push the static variables past the end of storage, the compiler will issue an error.
.. Note that the data areas of dynamic arrays and mappings are not affected by this check because their layout is not linear.
.. Regardless of the base slot used, their locations are calculated in a way that always puts them within the range of ``uint256`` and their sizes are not known at compilation time.

カスタムレイアウトを使用しても、コントラクトのストレージが「ラップアラウンド（末尾から先頭へ巻き戻る）」することはできません。
もし指定されたベーススロットによって、静的変数がストレージの末尾を超えることになる場合、コンパイラはエラーを出力します。
なお、動的配列やマッピングのデータ領域は線形なレイアウトを持たないため、このチェックの対象外となります。
使用するベーススロットに関係なく、それらの位置は ``uint256`` の範囲内に収まるように計算され、
またそのサイズはコンパイル時には不明です。

.. While there are no other limits placed on the base slot, it is recommended to avoid locations that are too close to the end of the address space.
.. Leaving too little space may complicate contract upgrades or cause problems for contracts that store additional values past their allocated space using inline assembly.

ベーススロットに対して他の制限はありませんが、アドレス空間の末尾に近すぎる位置は避けることが推奨されます。
残されたスペースが少なすぎると、コントラクトのアップグレードが難しくなったり、
インラインアセンブリで割り当て領域を超えて値を保存するようなコントラクトで問題が発生する可能性があります。

.. The storage layout can only be specified for the topmost contract of an inheritance tree, and affects locations of all the storage variables in all the contracts in that tree.
.. Variables are laid out according to the order of their definitions and the positions of their contracts in the :ref:`linearized inheritance hierarchy<multi-inheritance>` and a custom base slot preserves their relative positions, shifting them all by the same amount.

ストレージレイアウトは、継承ツリーの最上位のコントラクトに対してのみ指定でき、
そのツリー内にあるすべてのコントラクトのストレージ変数の位置に影響を与えます。
変数は、定義された順番とコントラクトの :ref:`線形化された継承階層<multi-inheritance>` に従って配置され、
カスタムベーススロットを指定した場合でも、それらの相対位置は保たれ、すべて同じ量だけシフトされます。

.. The storage layout cannot be specified for abstract contracts, interfaces and libraries.
.. Also, it is important to note that it does *not* affect transient state variables.

ストレージレイアウトは、抽象コントラクト、インターフェース、およびライブラリには指定できません。
また、この指定はトランジェント状態変数には *影響を与えない* ことにも注意が必要です。

.. For details about storage layout and the effect of the layout specifier on it see
.. :ref:`layout of storage variables<storage-inplace-encoding>`.

ストレージレイアウトの詳細や、layout 指定子がそれに与える影響については
:ref:`ストレージ変数のレイアウト<storage-inplace-encoding>` を参照してください。

.. warning::
    .. The identifiers ``layout`` and ``at`` are not yet reserved as keywords in the language.
    .. It is strongly recommended to avoid using them since they will become reserved in a future
    .. breaking release.

    識別子 ``layout`` および ``at`` は、現時点ではまだ言語の予約語ではありません。
    しかし、将来の後方互換性を破るリリースにおいて予約語となる予定のため、これらを使用しないことが強く推奨されます。
