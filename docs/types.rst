.. index:: type

.. _types:

*****
型
*****

Solidityは静的型付け言語です。
つまり、各変数（ステートとローカル）の型を指定する必要があります。
Solidityにはいくつかの基本的な型があり、それらを組み合わせて複雑な型を作ることができます。

また、演算子を含む式では、型同士が相互に作用できます。様々な演算子のクイックリファレンスについては、 :ref:`order` を参照してください。

Solidityには "undefined"や"null"の値の概念はありませんが、新しく宣言された変数は常にその型に依存した :ref:`デフォルト値<default-value>` を持ちます。
予期せぬ値を処理するには、 :ref:`リバート<assert-and-require>` を使ってトランザクション全体を戻すか、成功を示す ``bool`` 値を2番目に持つタプルを返す必要があります。

.. include:: types/value-types.rst

.. include:: types/reference-types.rst

.. include:: types/mapping-types.rst

.. include:: types/operators.rst

.. include:: types/conversion.rst

