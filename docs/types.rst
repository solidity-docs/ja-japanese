.. index:: type

.. _types:

*****
Types
*****

.. Solidity is a statically typed language, which means that the type of each
.. variable (state and local) needs to be specified.
.. Solidity provides several elementary types which can be combined to form complex types.

Solidityは静的型付け言語です。つまり、各変数（ステートとローカル）の型を指定する必要があります。Solidityにはいくつかの基本的な型があり、それらを組み合わせて複雑な型を作ることができます。

.. In addition, types can interact with each other in expressions containing
.. operators. For a quick reference of the various operators, see :ref:`order`.

また、演算子を含む式では、型同士が相互に作用できます。様々な演算子のクイックリファレンスについては、 :ref:`order` を参照してください。

.. The concept of "undefined" or "null" values does not exist in Solidity, but newly
.. declared variables always have a :ref:`default value<default-value>` dependent
.. on its type. To handle any unexpected values, you should use the :ref:`revert function<assert-and-require>` to revert the whole transaction, or return a
.. tuple with a second ``bool`` value denoting success.

Solidityには "未定義 "や "NULL "の値の概念はありませんが、新しく宣言された変数は常にその型に依存した :ref:`default value<default-value>` を持ちます。予期せぬ値を処理するには、 :ref:`revert function<assert-and-require>` を使ってトランザクション全体を戻すか、成功を示す第2の ``bool`` 値を持つタプルを返す必要があります。

.. include:: types/value-types.rst

.. include:: types/reference-types.rst

.. include:: types/mapping-types.rst

.. include:: types/operators.rst

.. include:: types/conversion.rst

