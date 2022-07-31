
.. index: memory layout

*********************
メモリ内のレイアウト
*********************

.. Solidity reserves four 32-byte slots, with specific byte ranges (inclusive of endpoints) being used as follows:
.. - ``0x00`` - ``0x3f`` (64 bytes): scratch space for hashing methods
.. - ``0x40`` - ``0x5f`` (32 bytes): currently allocated memory size (aka. free memory pointer)
.. - ``0x60`` - ``0x7f`` (32 bytes): zero slot

Solidityは4つの32バイトスロットを確保しており、特定のバイト範囲（エンドポイントを含む）は以下のように使用されます。

- ``0x00`` - ``0x3f`` （64バイト）: ハッシュ化のためのスクラッチ領域

- ``0x40`` - ``0x5f`` （32バイト）: 現在割り当てられているメモリサイズ（別名: フリーメモリポインタ）

- ``0x60`` - ``0x7f`` （32バイト）: ゼロスロット

.. Scratch space can be used between statements (i.e. within inline assembly). The zero slot
.. is used as initial value for dynamic memory arrays and should never be written to
.. (the free memory pointer points to ``0x80`` initially).

スクラッチ領域は、ステートメント間（インラインアセンブリ内）で使用できます。
ゼロスロットは、動的メモリ配列の初期値として使用され、決して書き込まれてはいけません（フリーメモリポインタは初期値として ``0x80`` を指します）。

.. Solidity always places new objects at the free memory pointer and
.. memory is never freed (this might change in the future).

Solidityは常に新しいオブジェクトをフリーメモリポインタに配置し、メモリは解放されません（これは将来変更されるかもしれません）。

.. Elements in memory arrays in Solidity always occupy multiples of 32 bytes (this
.. is even true for ``bytes1[]``, but not for ``bytes`` and ``string``).
.. Multi-dimensional memory arrays are pointers to memory arrays. The length of a
.. dynamic array is stored at the first slot of the array and followed by the array
.. elements.

Solidityのメモリ配列の要素は、常に32バイトの倍数を占めています（これは ``bytes1[]`` でも当てはまりますが、 ``bytes`` と ``string`` では当てはまりません）。
多次元のメモリ配列は、メモリ配列へのポインタです。
動的配列の長さは、配列の最初のスロットに格納され、その後に配列要素が続きます。

.. .. warning::

..   There are some operations in Solidity that need a temporary memory area
..   larger than 64 bytes and therefore will not fit into the scratch space.
..   They will be placed where the free memory points to, but given their
..   short lifetime, the pointer is not updated. The memory may or may not
..   be zeroed out. Because of this, one should not expect the free memory
..   to point to zeroed out memory.

..   While it may seem like a good idea to use ``msize`` to arrive at a
..   definitely zeroed out memory area, using such a pointer non-temporarily
..   without updating the free memory pointer can have unexpected results.

.. warning::

  Solidityには、64バイト以上の一時的なメモリ領域を必要とする操作があり、そのためスクラッチ領域には収まりません。
  これらはフリーメモリが指す場所に配置されますが、その寿命が短いため、ポインタは更新されません。
  メモリはゼロになってもならなくても構いません。
  このため、フリーメモリがゼロアウトされたメモリを指していると思ってはいけません。

  確実にゼロになったメモリ領域に到達するために ``msize`` を使用するのは良いアイデアに思えるかもしれませんが、空きメモリポインタを更新せずにそのようなポインタを非一時的に使用すると、予期しない結果になることがあります。

ストレージ内のレイアウトとの違い
================================

以上のように、メモリ上のレイアウトと :ref:`ストレージ<storage-inplace-encoding>` 上のレイアウトは異なります。
以下、いくつかの例を紹介します。

配列における違いの例
--------------------------------

次の配列は、ストレージでは32バイト（1スロット）ですが、メモリでは128バイト（32バイトずつの4つのアイテム）を占有します。

.. code-block:: solidity

    uint8[4] a;

構造体レイアウトにおける違いの例
---------------------------------------

次の構造体は、ストレージでは96バイト（32バイトのスロットが3つ）ですが、メモリでは128バイト（32バイトずつのアイテムが4つ）を占有します。

.. code-block:: solidity

    struct S {
        uint a;
        uint b;
        uint8 c;
        uint8 d;
    }

