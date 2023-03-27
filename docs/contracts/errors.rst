.. index:: ! error, revert, ! selector; of an error
.. _errors:

******************
エラーとリバート文
******************

Solidityのエラーは、操作が失敗した理由をユーザーに説明するための、便利でガス効率の良い方法です。
エラーはコントラクト（インターフェースやライブラリを含む）の内外で定義できます。

これらは、 :ref:`リバート文<revert-statement>` と一緒に使用する必要があります。
リバート文は、現在のコールのすべての変更をリバートし、エラーデータをコール側に戻します。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    /// 送金の残高不足
    /// `required`必要だが、`available`しか利用可能でない
    /// @param available 利用可能な残高
    /// @param required 送金の要求額
    error InsufficientBalance(uint256 available, uint256 required);

    contract TestToken {
        mapping(address => uint) balance;
        function transfer(address to, uint256 amount) public {
            if (amount > balance[msg.sender])
                revert InsufficientBalance({
                    available: balance[msg.sender],
                    required: amount
                });
            balance[msg.sender] -= amount;
            balance[to] += amount;
        }
        // ...
    }

.. Errors cannot be overloaded or overridden but are inherited.
.. The same error can be defined in multiple places as long as the scopes are distinct.
.. Instances of errors can only be created using ``revert`` statements.

エラーはオーバーロードやオーバーライドできませんが、継承されます。
スコープが異なっている限り、同じエラーを複数の場所で定義できます。
エラーのインスタンスは、 ``revert`` 文を使ってのみ作成できます。

.. The error creates data that is then passed to the caller with the revert operation
.. to either return to the off-chain component or catch it in a :ref:`try/catch statement <try-catch>`.
.. Note that an error can only be caught when coming from an external call,
.. reverts happening in internal calls or inside the same function cannot be caught.

エラーが発生すると、データが作成され、リバート操作で呼び出し側に渡され、オフチェーンコンポーネントに戻るか、 :ref:`try/catch文 <try-catch>` でキャッチされます。
エラーをキャッチできるのは、外部からの呼び出しの場合のみで、内部呼び出しや同じ関数内で発生した復帰はキャッチできないことに注意してください。

.. If you do not provide any parameters, the error only needs four bytes of
.. data and you can use :ref:`NatSpec <natspec>` as above
.. to further explain the reasons behind the error, which is not stored on chain.
.. This makes this a very cheap and convenient error-reporting feature at the same time.

パラメータを何も与えなければ、エラーは4バイトのデータだけで済み、上記のように :ref:`NatSpec <natspec>` を使ってエラーの理由をさらに説明できますが、これはチェーンには保存されません。
これにより、非常に安価で便利なエラー報告機能を同時に実現しています。

.. More specifically, an error instance is ABI-encoded in the same way as
.. a function call to a function of the same name and types would be
.. and then used as the return data in the ``revert`` opcode.
.. This means that the data consists of a 4-byte selector followed by :ref:`ABI-encoded<abi>` data.
.. The selector consists of the first four bytes of the keccak256-hash of the signature of the error type.

具体的には、エラーインスタンスは、同じ名前と型を持つ関数への関数呼び出しと同じ方法でABIエンコードされ、 ``revert`` オペコードのリターンデータとして使用されます。
つまり、データは4バイトのセレクタとそれに続く :ref:`ABIエンコード<abi>` されたデータで構成されています。セレクタは、エラー型のシグネチャのkeccak256ハッシュの最初の4バイトで構成されています。

.. .. note::

..     It is possible for a contract to revert
..     with different errors of the same name or even with errors defined in different places
..     that are indistinguishable by the caller. For the outside, i.e. the ABI,
..     only the name of the error is relevant, not the contract or file where it is defined.

.. note::

    コントラクトが同じ名前の異なるエラーで復帰することは可能ですし、呼び出し元では区別できない異なる場所で定義されたエラーであっても可能です。
    外部、つまりABIにとっては、エラーの名前だけが重要であり、そのエラーが定義されているコントラクトやファイルは関係ありません。

.. The statement ``require(condition, "description");`` would be equivalent to
.. ``if (!condition) revert Error("description")`` if you could define
.. ``error Error(string)``.
.. Note, however, that ``Error`` is a built-in type and cannot be defined in user-supplied code.

``require(condition, "description");`` という文は、 ``error Error(string)`` を定義できれば ``if (!condition) revert Error("description")`` と同じになります。
ただし、 ``Error`` は組み込み型であり、ユーザーが提供するコードでは定義できないことに注意してください。

.. Similarly, a failing ``assert`` or similar conditions will revert with an error
.. of the built-in type ``Panic(uint256)``.

同様に、 ``assert`` が失敗した場合や同様の条件の場合は、ビルトイン型の ``Panic(uint256)`` エラーで復帰します。

Members of Errors
=================

.. .. note::

..     Error data should only be used to give an indication of failure, but
..     not as a means for control-flow. The reason is that the revert data
..     of inner calls is propagated back through the chain of external calls
..     by default. This means that an inner call
..     can "forge" revert data that looks like it could have come from the
..     contract that called it.
.. 

.. note::

    エラーデータは、失敗の兆候を示すためにのみ使用すべきで、コントロールフローの手段としては使用しないでください。
    その理由は、インナーコールのリバートデータは、デフォルトでは外部コールのチェーンを通じて伝搬されるからです。
    つまり、内側の呼び出しは、それを呼び出したコントラクトから来たように見えるリバートデータを「偽造」できるということです。

- ``error.selector``: A ``bytes4`` value containing the error selector.
