
.. index: calldata layout

************************
コールデータのレイアウト
************************

.. The input data for a function call is assumed to be in the format defined by the :ref:`ABI
.. specification <ABI>`. Among others, the ABI specification requires arguments to be padded to multiples of 32
.. bytes. The internal function calls use a different convention.

関数呼び出しの入力データは、 :ref:`ABIの仕様<ABI>` で定義されたフォーマットであることが前提となっています。
とりわけ、ABI仕様では、引数を32バイトの倍数にパディングすることが求められています。
内部の関数呼び出しでは、これとは異なる規則が用いられています。

.. Arguments for the constructor of a contract are directly appended at the end of the
.. contract's code, also in ABI encoding. The constructor will access them through a hard-coded offset, and
.. not by using the ``codesize`` opcode, since this of course changes when appending
.. data to the code.

コントラクトのコンストラクタの引数は、コントラクトのコードの最後にABIエンコーディングで直接追加されます。
コンストラクタはハードコードされたオフセットを使ってアクセスしますが、コードにデータを追加するときに変更されるため、 ``codesize``  オペコードは使用しません。

