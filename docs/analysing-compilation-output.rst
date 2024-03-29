.. index:: analyse, asm

######################
コンパイラの出力の解析
######################

.. It is often useful to look at the assembly code generated by the compiler.
.. The generated binary, i.e., the output of ``solc --bin contract.sol``, is generally difficult to read.
.. It is recommended to use the flag ``--asm`` to analyse the assembly output.
.. Even for large contracts, looking at a visual diff of the assembly before and after a change is often very enlightening.

コンパイラが生成したアセンブリコードを見ると便利なことが多くあります。
生成されたバイナリ、すなわち ``solc --bin contract.sol`` の出力は、一般に読みにくいです。
フラグ ``--asm`` を使用して、アセンブリ出力を分析することをお勧めします。
大規模なコントラクトであっても、変更前と変更後のアセンブリの視覚的なdiffを見ることは、しばしば非常に有益です。

.. Consider the following contract (named, say ``contract.sol``):

次のようなコントラクトを考えます（名前は ``contract.sol`` とします）。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.5.0 <0.9.0;
    contract C {
        function one() public pure returns (uint) {
            return 1;
        }
    }

``solc --asm contract.sol`` の出力は以下のようになります。

.. code-block:: none

    ======= contract.sol:C =======
    EVM assembly:
        /* "contract.sol":0:86  contract C {... */
      mstore(0x40, 0x80)
      callvalue
      dup1
      iszero
      tag_1
      jumpi
      0x00
      dup1
      revert
    tag_1:
      pop
      dataSize(sub_0)
      dup1
      dataOffset(sub_0)
      0x00
      codecopy
      0x00
      return
    stop

    sub_0: assembly {
            /* "contract.sol":0:86  contract C {... */
          mstore(0x40, 0x80)
          callvalue
          dup1
          iszero
          tag_1
          jumpi
          0x00
          dup1
          revert
        tag_1:
          pop
          jumpi(tag_2, lt(calldatasize, 0x04))
          shr(0xe0, calldataload(0x00))
          dup1
          0x901717d1
          eq
          tag_3
          jumpi
        tag_2:
          0x00
          dup1
          revert
            /* "contract.sol":17:84  function one() public pure returns (uint) {... */
        tag_3:
          tag_4
          tag_5
          jump	// in
        tag_4:
          mload(0x40)
          tag_6
          swap2
          swap1
          tag_7
          jump	// in
        tag_6:
          mload(0x40)
          dup1
          swap2
          sub
          swap1
          return
        tag_5:
            /* "contract.sol":53:57  uint */
          0x00
            /* "contract.sol":76:77  1 */
          0x01
            /* "contract.sol":69:77  return 1 */
          swap1
          pop
            /* "contract.sol":17:84  function one() public pure returns (uint) {... */
          swap1
          jump	// out
            /* "#utility.yul":7:125   */
        tag_10:
            /* "#utility.yul":94:118   */
          tag_12
            /* "#utility.yul":112:117   */
          dup2
            /* "#utility.yul":94:118   */
          tag_13
          jump	// in
        tag_12:
            /* "#utility.yul":89:92   */
          dup3
            /* "#utility.yul":82:119   */
          mstore
            /* "#utility.yul":72:125   */
          pop
          pop
          jump	// out
            /* "#utility.yul":131:353   */
        tag_7:
          0x00
            /* "#utility.yul":262:264   */
          0x20
            /* "#utility.yul":251:260   */
          dup3
            /* "#utility.yul":247:265   */
          add
            /* "#utility.yul":239:265   */
          swap1
          pop
            /* "#utility.yul":275:346   */
          tag_15
            /* "#utility.yul":343:344   */
          0x00
            /* "#utility.yul":332:341   */
          dup4
            /* "#utility.yul":328:345   */
          add
            /* "#utility.yul":319:325   */
          dup5
            /* "#utility.yul":275:346   */
          tag_10
          jump	// in
        tag_15:
            /* "#utility.yul":229:353   */
          swap3
          swap2
          pop
          pop
          jump	// out
            /* "#utility.yul":359:436   */
        tag_13:
          0x00
            /* "#utility.yul":425:430   */
          dup2
            /* "#utility.yul":414:430   */
          swap1
          pop
            /* "#utility.yul":404:436   */
          swap2
          swap1
          pop
          jump	// out

        auxdata: 0xa2646970667358221220a5874f19737ddd4c5d77ace1619e5160c67b3d4bedac75fce908fed32d98899864736f6c637827302e382e342d646576656c6f702e323032312e332e33302b636f6d6d69742e65613065363933380058
    }

.. Alternatively, the above output can also be obtained from `Remix <https://remix.ethereum.org/>`_, under the option "Compilation Details" after compiling a contract.

また、上記の出力は、コントラクトをコンパイルした後、 `Remix <https://remix.ethereum.org/>`_ のオプション「Compilation Details」からも得ることができます。

.. Notice that the ``asm`` output starts with the creation / constructor code.
.. The deploy code is provided as part of the sub object (in the above example, it is part of the sub-object ``sub_0``).
.. The ``auxdata`` field corresponds to the contract :ref:`metadata <encoding-of-the-metadata-hash-in-the-bytecode>`.
.. The comments in the assembly output point to the source location.
.. Note that ``#utility.yul`` is an internally generated file of utility functions that can be obtained using the flags ``--combined-json generated-sources,generated-sources-runtime``.

``asm``  の出力は、作成/コンストラクタのコードで始まることに注意してください。
配置コードは、サブオブジェクトの一部として提供されます（上記の例では、サブオブジェクト ``sub_0`` の一部です）。
``auxdata`` フィールドはコントラクトの :ref:`メタデータ <encoding-of-the-metadata-hash-in-the-bytecode>` に対応しています。
アセンブリ出力のコメントは、ソースの位置を示しています。
``#utility.yul`` は、フラグ ``--combined-json generated-sources,generated-sources-runtime`` を使用して取得できるユーティリティー関数の内部生成ファイルであることに注意してください。

.. Similarly, the optimized assembly can be obtained with the command: ``solc --optimize --asm contract.sol``. Often times, it is interesting to see if two different sources in Solidity result in
.. the same optimized code. For example, to see if the expressions ``(a * b) / c``, ``a * b / c``
.. generates the same bytecode. This can be easily done by taking a ``diff`` of the corresponding
.. assembly output, after potentially stripping comments that reference the source locations.

同様に、最適化されたアセンブリは、次のコマンドで得ることができます: ``solc --optimize --asm contract.sol`` 。
しばしば、Solidityの2つの異なるソースが同じ最適化されたコードになるかどうかを確認することは興味深いことです。
例えば、 ``(a * b) / c`` ,  ``a * b / c`` という式が同じバイトコードを生成するかどうかを確認できます。
これは、ソースの位置を参照するコメントを削除した後、対応するアセンブリ出力の ``diff`` を取ることで簡単に行うことができます。

.. .. note::

..    The ``--asm`` output is not designed to be machine readable. Therefore, there may be breaking
..    changes on the output between minor versions of solc.

.. note::

  ``--asm`` 出力は機械で読めるようには設計されていません。
  そのため、solcのマイナーバージョン間では、出力に変更がある可能性があります。
