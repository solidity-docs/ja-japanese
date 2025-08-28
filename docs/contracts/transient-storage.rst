.. index:: ! transient storage, ! transient, tstore, tload

.. _transient-storage:

************************
トランジェントストレージ
************************

トランジェントストレージは、メモリ、ストレージ、コールデータ（およびリターンデータやコード）に加えて導入された新たなデータ領域であり、これは `EIP-1153 <https://eips.ethereum.org/EIPS/eip-1153>`_ によって提案された ``TSTORE`` および ``TLOAD`` オペコードとともに導入されました。
この新しいデータ領域は、ストレージと同様にKey-Valueストアとして動作しますが、最大の違いは、トランジェントストレージ内のデータは永続的ではなく、現在のトランザクションのスコープ内に限られ、トランザクション終了後にはゼロにリセットされるという点です。
トランジェントストレージの内容はライフタイムもサイズも非常に限定されているため、状態の一部として永続的に保存する必要がなく、ストレージに比べて関連するガスコストも大幅に低くなっています。
トランジェントストレージを利用するには、EVM バージョン ``cancun`` 以降が必要です。

.. Transient storage variables cannot be initialized in place, i.e., they cannot be assigned to upon declaration, since the value would be cleared at the end of the creation transaction, rendering the initialization ineffective.
.. Transient variables will be :ref:`default value<default-value>` initialized depending on their underlying type.
.. ``constant`` and ``immutable`` variables conflict with transient storage, since their values are either inlined or directly stored in code.

トランジェントストレージ変数は、その場で初期化（in-place initialization）することはできません。
つまり、宣言時に値を代入することはできません。なぜなら、その値はコントラクト作成トランザクションの終了時にクリアされるため、初期化が無意味になるからです。
トランジェント変数は、その基礎となる型に応じて :ref:`デフォルト値 <default-value>` で初期化されます。
``constant`` や ``immutable`` 変数は、それぞれの値がインライン展開されるか、コード内に直接格納されるため、トランジェントストレージとは競合します。

.. Transient storage variables have completely independent address space from storage, so that the order of transient state variables does not affect the layout of storage state variables and vice-versa.
.. They do need distinct names though because all state variables share the same namespace.
.. It is also important to note that the values in transient storage are packed in the same fashion as those in persistent storage.
.. See :ref:`Storage Layout <storage-inplace-encoding>` for more information.

トランジェントストレージ変数はストレージとは完全に独立したアドレス空間を持っているため、トランジェント状態変数の順序がストレージ状態変数のレイアウトに影響を与えることはなく、逆も同様です。
ただし、すべての状態変数は同じ名前空間を共有するため、名前は重複できません。
また、トランジェントストレージ内の値は、永続的なストレージと同様の方法でパックされる点にも注意が必要です。
詳細は :ref:`ストレージレイアウト <storage-inplace-encoding>` を参照してください。

.. Besides that, transient variables can have visibility as well and ``public`` ones will have a getter function generated automatically as usual.

そのほか、トランジェント変数にもビジビリティを指定でき、 ``public`` な変数には通常通り自動でゲッター関数が生成されます。

.. Note that, currently, such use of ``transient`` as a data location is only allowed for :ref:`value type <value-types>` state variable declarations.
.. Reference types, such as arrays, mappings and structs, as well as local or parameter variables are not yet supported.

現在のところ、 ``transient`` をデータ位置として使用できるのは、:ref:`値型 <value-types>` の状態変数の宣言に限られています。
配列・マッピング・構造体などの参照型や、ローカル変数・引数にはまだ対応していません。

.. An expected canonical use case for transient storage is cheaper reentrancy locks, which can be readily implemented with the opcodes as showcased next.

トランジェントストレージの代表的なユースケースとして期待されているのは、安価なリエントランシーロックです。
これは、次に示すように対応するオペコードを使って簡単に実装できます。


.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.28;

    contract Generosity {
        mapping(address => bool) sentGifts;
        bool transient locked;

        modifier nonReentrant {
            require(!locked, "Reentrancy attempt");
            locked = true;
            _;
            // Unlocks the guard, making the pattern composable.
            // After the function exits, it can be called again, even in the same transaction.
            locked = false;
        }

        function claimGift() nonReentrant public {
            require(address(this).balance >= 1 ether);
            require(!sentGifts[msg.sender]);
            (bool success, ) = msg.sender.call{value: 1 ether}("");
            require(success);

            // In a reentrant function, doing this last would open up the vulnerability
            sentGifts[msg.sender] = true;
        }
    }

.. Transient storage is private to the contract that owns it, in the same way as persistent storage.
.. Only owning contract frames may access their transient storage, and when they do, all the frames access the same transient store.

トランジェントストレージは、永続的なストレージと同様に、それを所有するコントラクトに対してプライベートです。
トランジェントストレージへアクセスできるのは、そのコントラクトのフレームだけであり、アクセス時にはすべてのフレームが同じトランジェントストアを共有します。

.. Transient storage is part of the EVM state and is subject to the same mutability enforcements as persistent storage.
.. As such, any read access to it is not ``pure`` and writing access is not ``view``.

トランジェントストレージは EVM の状態の一部であり、永続的なストレージと同様の変更制限が適用されます。
そのため、トランジェントストレージへの読み取りは ``pure`` とは見なされず、書き込みは ``view`` と見なされません。

.. If the ``TSTORE`` opcode is called within the context of a ``STATICCALL``, it will result in an exception instead of performing the modification.
.. ``TLOAD`` is allowed within the context of a ``STATICCALL``.

``TSTORE`` オペコードが ``STATICCALL`` のコンテキスト内で呼び出された場合、変更は行われず例外が発生します。
一方、 ``TLOAD`` は ``STATICCALL`` のコンテキスト内でも使用可能です。

.. When transient storage is used in the context of ``DELEGATECALL`` or ``CALLCODE``, then the owning contract of the transient storage is the contract that issued ``DELEGATECALL`` or ``CALLCODE`` instruction (the caller) as with persistent storage.
.. When transient storage is used in the context of ``CALL`` or ``STATICCALL``, then the owning contract of the transient storage is the contract that is the target of the ``CALL`` or ``STATICCALL`` instruction (the callee).

``DELEGATECALL`` や ``CALLCODE`` のコンテキストでトランジェントストレージが使用された場合、  
そのストレージの所有者は ``DELEGATECALL`` や ``CALLCODE`` 命令を発行した呼び出し元のコントラクトになります。
一方、 ``CALL`` や ``STATICCALL`` の場合は、トランジェントストレージの所有者は呼び出し先のコントラクトになります。

.. note::
    .. In the case of ``DELEGATECALL``, since references to transient storage variables are currently not supported, it is not possible to pass those into library calls.
    .. In libraries, access to transient storage is only possible using inline assembly.

    ``DELEGATECALL`` の場合、トランジェントストレージ変数への参照は現在サポートされていないため、それらをライブラリの呼び出しに渡すことはできません。
    ライブラリ内でトランジェントストレージにアクセスするには、インラインアセンブリを使用する必要があります。

.. If a frame reverts, all writes to transient storage that took place between entry to the frame and the return are reverted, including those that took place in inner calls.
.. The caller of an external call may employ a ``try ... catch`` block to prevent reverts bubbling up from the inner calls.

あるフレームがリバートすると、そのフレームに入ってから戻るまでに行われたトランジェントストレージへのすべての書き込みは、内部呼び出しで行われたものであっても、すべてリバートされます。

外部呼び出しの呼び出し元は、 ``try ... catch`` ブロックを用いることで、内部呼び出しからのリバートが上位に伝播するのを防ぐことができます。

.. Composability of Smart Contracts and the Caveats of Transient Storage

************************************************************************
スマートコントラクトの構成可能性とトランジェントストレージに関する注意点
************************************************************************

.. Given the caveats mentioned in the specification of EIP-1153, in order to preserve the composability of your smart contract, utmost care is recommended for more advanced use cases of transient storage.

EIP-1153 の仕様で述べられている注意点を踏まえると、トランジェントストレージを高度なユースケースで使用する場合、  
スマートコントラクトの構成可能性（composability）を維持するために最大限の注意が必要です。

.. For smart contracts, composability is a very important design principle to achieve self-contained behaviour, such that multiple calls into individual smart contracts can be composed to more complex applications.
.. So far the EVM largely guaranteed composable behaviour, since multiple calls into a smart contract within a complex transaction are virtually indistinguishable from multiple calls to the contract stretched over several transactions.
.. However, transient storage allows a violation of this principle, and incorrect use may lead to complex bugs that only surface when used across several calls.

スマートコントラクトにおいて、構成可能性は非常に重要な設計原則です。
これは、個別のスマートコントラクトへの複数の呼び出しを組み合わせて、より複雑なアプリケーションを構築できるようにするためです。
これまでの EVM は、複雑なトランザクション内でのコントラクトへの複数の呼び出しと、複数のトランザクションに分かれた呼び出しとを事実上区別しないことで、この構成可能な動作を保証してきました。
しかし、トランジェントストレージはこの原則を破る可能性があり、その誤った使用は、複数の呼び出しにまたがって使用されたときにのみ表面化するような複雑なバグを引き起こすことがあります。

.. Let's illustrate the problem with a simple example:

この問題を簡単な例で示してみましょう:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.28;

    contract MulService {
        uint transient multiplier;
        function setMultiplier(uint mul) external {
            multiplier = mul;
        }

        function multiply(uint value) external view returns (uint) {
            return value * multiplier;
        }
    }

そして、次のような一連の外部呼び出しが行われるとします:

.. code-block:: solidity

    setMultiplier(42);
    multiply(1);
    multiply(2);

.. If the example used memory or storage to store the multiplier, it would be fully composable.
.. It would not matter whether you split the sequence into separate transactions or grouped them in some way.
.. You would always get the same result: after ``multiplier`` is set to ``42``, the subsequent calls
.. would return ``42`` and ``84`` respectively.
.. This enables use cases such as batching calls from multiple transactions
.. together to reduce gas costs.
.. Transient storage potentially breaks such use cases since composability can no longer be taken for granted.
.. In the example, if the calls are not executed in the same transaction, then ``multiplier``
.. is reset and the next calls to function ``multiply`` would always return ``0``.

この例で ``multiplier`` をメモリやストレージに保存していた場合、コントラクトは完全に構成可能（composable）になります。
シーケンスを別々のトランザクションに分けるか、あるいは一括でまとめるかに関係なく、常に同じ結果が得られます。
つまり、 ``multiplier`` に ``42`` を設定した後の呼び出しは、それぞれ ``42`` と ``84`` を返すことになります。
このような構成可能性は、複数のトランザクションからの呼び出しをまとめてガスコストを削減するなどのユースケースを可能にします。
しかし、トランジェントストレージを使うと、その構成可能性が保証されなくなり、こうしたユースケースが破綻する可能性があります。
例において、もし呼び出しが同一トランザクション内で実行されない場合、 ``multiplier`` はリセットされてしまい、  
次に ``multiply`` 関数を呼び出しても常に ``0`` を返すことになります。

.. As another example, since transient storage is constructed as a relatively cheap key-value store,
.. a smart contract author may be tempted to use transient storage as a replacement for in-memory mappings
.. without keeping track of the modified keys in the mapping and thereby without clearing the mapping
.. at the end of the call.
.. This, however, can easily lead to unexpected behaviour in complex transactions,
.. in which values set by a previous call into the contract within the same transaction remain.

別の例として、トランジェントストレージは比較的安価なキー・バリュー型ストアとして構成されているため、  
スマートコントラクトの開発者が、トランジェントストレージをメモリ上のマッピングの代替として使用したくなるかもしれません。
しかしその際に、変更されたキーの管理を行わず、呼び出しの最後にマッピングをクリアしないような実装をすると、  
複雑なトランザクションにおいて予期しない挙動を引き起こす可能性があります。
たとえば、同じトランザクション内で以前の呼び出しによって設定された値が残っており、  
その影響を後続の呼び出しが受けてしまうようなケースです。

.. The use of transient storage for reentrancy locks that are cleared at the end of the call frame
.. into the contract, is safe.
.. However, be sure to resist the temptation to save the 100 gas used for resetting the
.. reentrancy lock, since failing to do so, will restrict your contract to only one call
.. within a transaction, preventing its use in complex composed transactions,
.. which have been a cornerstone for complex applications on chain.

トランジェントストレージを、コントラクトへの呼び出しフレームの終了時にリセットされるリエントランシー・ロックとして使用するのは安全です。
ただし、リエントランシー・ロックのリセットにかかる 100 gas を節約したいという誘惑には注意が必要です。
これを怠ると、コントラクトは1トランザクション中に1回しか呼び出せなくなり、  
オンチェーンでの複雑なアプリケーションを支えてきた「複数の呼び出しを組み合わせる」構成可能な設計ができなくなってしまいます。

.. It is recommend to generally always clear transient storage completely at the end of a call
.. into your smart contract to avoid these kinds of issues and to simplify
.. the analysis of the behaviour of your contract within complex transactions.
.. Check the `Security Considerations section of EIP-1153 <https://eips.ethereum.org/EIPS/eip-1153#security-considerations>`_
.. for further details.

このような問題を回避し、複雑なトランザクション内でのコントラクトの挙動を分析しやすくするためにも、  
スマートコントラクトへの呼び出しの最後には、トランジェントストレージを完全にクリアすることが常に推奨されます。
詳しくは `EIP-1153 のセキュリティに関する注意事項セクション <https://eips.ethereum.org/EIPS/eip-1153#security-considerations>`_ を参照してください。
