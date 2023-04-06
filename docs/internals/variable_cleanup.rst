.. index: variable cleanup

********************
変数のクリーンアップ
********************

.. Ultimately, all values in the EVM are stored in 256 bit words.
.. Thus, in some cases, when the type of a value has less than 256 bits, it is necessary to clean the remaining bits.
.. The Solidity compiler is designed to do such cleaning before any operations
.. that might be adversely affected by the potential garbage in the remaining bits.
.. For example, before writing a value to  memory, the remaining bits need
.. to be cleared because the memory contents can be used for computing
.. hashes or sent as the data of a message call.  Similarly, before
.. storing a value in the storage, the remaining bits need to be cleaned
.. because otherwise the garbled value can be observed.

値が256ビットよりも短い場合、場合によっては残りのビットをクリーンアップする必要があります。
最終的に、EVM内のすべての値は256ビットのワードで保存されます。
したがって、値の型が256ビット未満である場合、残りのビットをクリーニングする必要があるケースがあります。
Solidityのコンパイラは、残りのビットに含まれる潜在的なゴミによって悪影響を受ける可能性のある演算の前に、このようなクリーニングを行うように設計されています。

例えば、値をメモリに書き込む前に、残りのビットをクリアする必要があります。
これは、メモリの内容がハッシュの計算に使用されたり、メッセージコールのデータとして送信されたりする可能性があるためです。
同様に、ストレージに値を格納する前に、残りのビットを消去する必要があります。
そうしないと、文字化けした値が観測される可能性があるからです。

.. Note that access via inline assembly is not considered such an operation:
.. If you use inline assembly to access Solidity variables
.. shorter than 256 bits, the compiler does not guarantee that
.. the value is properly cleaned up.

なお、インラインアセンブリによるアクセスはそのような操作とはみなされません。
インラインアセンブリを使用して256ビットより短いSolidity変数にアクセスした場合、コンパイラは値が適切にクリーンアップされることを保証しません。

.. Moreover, we do not clean the bits if the immediately
.. following operation is not affected.  For instance, since any non-zero
.. value is considered ``true`` by ``JUMPI`` instruction, we do not clean
.. the boolean values before they are used as the condition for
.. ``JUMPI``.

また、直後の演算に影響がない場合は、ビットのクリーニングは行いません。
例えば、 ``JUMPI`` 命令では0以外の値は ``true`` とみなされるので、 ``JUMPI`` の条件として使われる前のブーリアン値のクリーニングは行いません。

.. In addition to the design principle above, the Solidity compiler
.. cleans input data when it is loaded onto the stack.

上記の設計原理に加えて、Solidityのコンパイラは、入力データがスタックに読み込まれる際に、入力データをクリーニングします。

.. The following table describes the cleaning rules applied to different types, where ``higher bits`` refers to the remaining bits in case the type has less than 256 bits.

次の表は、異なるタイプに適用されるクリーニングルールを説明するもので、 ``higher bits`` は、タイプが256ビット未満の場合の残りのビットを指します。

.. csv-table::
   :header: "型", "有効な値", "無効な値のクリーンアップ"
   :widths: 10, 10, 30

   "n個のメンバーのenum", "0 から n-1", "例外を投げる"
   "bool", "0 あるいは 1", "1になる"
   "符号付き整数", "higher bits set to the sign bit", "currently silently signextends to a valid  value, i.e. all higher bits are set to the sign bit; may throw an exception in the future"
   "符号なし整数", "上位ビットがゼロ", "currently silently masks to a valid value, i.e. all higher bits are set to zero; may throw an exception in the future"

.. Note that valid and invalid values are dependent on their type size.
.. Consider ``uint8``, the unsigned 8-bit type, which has the following valid values:

有効な値と無効な値は、その型サイズに依存することに注意してください。
符号なし8ビット型である ``uint8`` を考えてみると、次のような有効な値があります:

.. code-block:: none

    0000...0000 0000 0000
    0000...0000 0000 0001
    0000...0000 0000 0010
    ....
    0000...0000 1111 1111

.. Any invalid value will have the higher bits set to zero:

無効な値は、上位ビットが0に設定されます:

.. code-block:: none

    0101...1101 0010 1010   invalid value
    0000...0000 0010 1010   cleaned value

.. For ``int8``, the signed 8-bit type, the valid values are:

符号付き8ビット型である ``int8`` の場合、有効な値は次のとおりです:

Negative

.. code-block:: none

    1111...1111 1111 1111
    1111...1111 1111 1110
    ....
    1111...1111 1000 0000

Positive

.. code-block:: none

    0000...0000 0000 0000
    0000...0000 0000 0001
    0000...0000 0000 0010
    ....
    0000...0000 1111 1111

.. The compiler will ``signextend`` the sign bit, which is 1 for negative and 0 for positive values, overwriting the higher bits:

コンパイラは符号ビットを ``signextend`` する。符号ビットは負の値を1、正の値を0とし、上位ビットを上書きします:

Negative

.. code-block:: none

    0010...1010 1111 1111   invalid value
    1111...1111 1111 1111   cleaned value

Positive

.. code-block:: none

    1101...0101 0000 0100   invalid value
    0000...0000 0000 0100   cleaned value
