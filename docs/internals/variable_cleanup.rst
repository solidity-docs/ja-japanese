.. index: variable cleanup

*********************
Cleaning Up Variables
*********************

.. When a value is shorter than 256 bit, in some cases the remaining bits
.. must be cleaned.
.. The Solidity compiler is designed to clean such remaining bits before any operations
.. that might be adversely affected by the potential garbage in the remaining bits.
.. For example, before writing a value to  memory, the remaining bits need
.. to be cleared because the memory contents can be used for computing
.. hashes or sent as the data of a message call.  Similarly, before
.. storing a value in the storage, the remaining bits need to be cleaned
.. because otherwise the garbled value can be observed.

値が256ビットよりも短い場合、場合によっては残りのビットをクリーンアップする必要があります。Solidityのコンパイラは、残りのビットに含まれる潜在的なゴミによって悪影響を受ける可能性のある演算の前に、そのような残りのビットを消去するように設計されています。例えば、値をメモリに書き込む前に、残りのビットをクリアする必要があります。これは、メモリの内容がハッシュの計算に使用されたり、メッセージコールのデータとして送信されたりする可能性があるためです。  同様に、ストレージに値を格納する前に、残りのビットを消去する必要があります。そうしないと、文字化けした値が観測される可能性があるからです。

.. Note that access via inline assembly is not considered such an operation:
.. If you use inline assembly to access Solidity variables
.. shorter than 256 bits, the compiler does not guarantee that
.. the value is properly cleaned up.

なお、インラインアセンブリによるアクセスはそのような操作とはみなされません。インライン・アセンブリを使用して256ビットより短いSolidity変数にアクセスした場合、コンパイラは値が適切にクリーンアップされることを保証しません。

.. Moreover, we do not clean the bits if the immediately
.. following operation is not affected.  For instance, since any non-zero
.. value is considered ``true`` by ``JUMPI`` instruction, we do not clean
.. the boolean values before they are used as the condition for
.. ``JUMPI``.

また、直後の演算に影響がない場合は、ビットのクリーニングは行いません。  例えば、 ``JUMPI`` 命令では0以外の値は ``true`` とみなされるので、 ``JUMPI`` の条件として使われる前のブーリアン値のクリーニングは行わない。

.. In addition to the design principle above, the Solidity compiler
.. cleans input data when it is loaded onto the stack.

上記の設計原理に加えて、Solidityのコンパイラは、入力データがスタックに読み込まれる際に、入力データをクリーニングします。

.. Different types have different rules for cleaning up invalid values:

タイプによって、無効な値を処理するためのルールが異なります。

+---------------+---------------+-------------------+
|Type           |Valid Values   |Invalid Values Mean|
+===============+===============+===================+
|enum of n      |0 until n - 1  |exception          |
|members        |               |                   |
+---------------+---------------+-------------------+
|bool           |0 or 1         |1                  |
+---------------+---------------+-------------------+
|signed integers|sign-extended  |currently silently |
|               |word           |wraps; in the      |
|               |               |future exceptions  |
|               |               |will be thrown     |
|               |               |                   |
|               |               |                   |
+---------------+---------------+-------------------+
|unsigned       |higher bits    |currently silently |
|integers       |zeroed         |wraps; in the      |
|               |               |future exceptions  |
|               |               |will be thrown     |
+---------------+---------------+-------------------+

