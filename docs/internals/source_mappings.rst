.. index:: source mappings

******************
ソースマッピング
******************

.. As part of the AST output, the compiler provides the range of the source
.. code that is represented by the respective node in the AST. This can be
.. used for various purposes ranging from static analysis tools that report
.. errors based on the AST and debugging tools that highlight local variables
.. and their uses.

コンパイラは、ASTの出力の一部として、ASTの各ノードで表現されるソースコードの範囲を提供します。
これは、ASTに基づいてエラーを報告する静的解析ツールや、ローカル変数とその用途を強調するデバッグツールなど、さまざまな目的に利用できます。

.. Furthermore, the compiler can also generate a mapping from the bytecode
.. to the range in the source code that generated the instruction. This is again
.. important for static analysis tools that operate on bytecode level and
.. for displaying the current position in the source code inside a debugger
.. or for breakpoint handling. This mapping also contains other information,
.. like the jump type and the modifier depth (see below).

さらに、コンパイラは、バイトコードから、その命令を生成したソースコードの範囲へのマッピングを生成することもできます。
これは、バイトコードレベルで動作する静的解析ツールや、デバッガ内でソースコードの現在の位置を表示したり、ブレークポイントを処理する際にも重要です。
このマッピングには、ジャンプタイプや修飾子の深さなど、他の情報も含まれています（後述）。

.. Both kinds of source mappings use integer identifiers to refer to source files.
.. The identifier of a source file is stored in
.. ``output['sources'][sourceName]['id']`` where ``output`` is the output of the
.. standard-json compiler interface parsed as JSON.
.. For some utility routines, the compiler generates "internal" source files
.. that are not part of the original input but are referenced from the source
.. mappings. These source files together with their identifiers can be
.. obtained via ``output['contracts'][sourceName][contractName]['evm']['bytecode']['generatedSources']``.

どちらのソースマッピングも、ソースファイルの参照には整数の識別子を使用します。
ソースファイルの識別子は  ``output['sources'][sourceName]['id']`` に格納され、 ``output`` はJSONとして解析された standard-json コンパイラインターフェースの出力です。
一部のユーティリティルーチンでは、コンパイラーは元の入力の一部ではなく、ソースマッピングから参照される「内部」ソースファイルを生成します。
これらのソースファイルは、その識別子とともに、 ``output['contracts'][sourceName][contractName]['evm']['bytecode']['generatedSources']`` を通じて入手できます。

.. .. note ::
..     In the case of instructions that are not associated with any particular source file,
..     the source mapping assigns an integer identifier of ``-1``. This may happen for
..     bytecode sections stemming from compiler-generated inline assembly statements.

.. note :: 
    特定のソースファイルに関連付けられていない命令の場合、ソースマッピングでは ``-1`` という整数の識別子が割り当てられます。これは、コンパイラによって生成されたインラインアセンブリステートメントに由来するバイトコードセクションで発生する可能性があります。

.. The source mappings inside the AST use the following
.. notation:

AST内部のソースマッピングは以下の表記を使用しています。

``s:l:f``

.. Where ``s`` is the byte-offset to the start of the range in the source file,
.. ``l`` is the length of the source range in bytes and ``f`` is the source
.. index mentioned above.

``s`` はソースファイル内の範囲の開始点へのバイトオフセット、 ``l`` はソース範囲の長さ（バイト）、 ``f`` は前述のソースインデックスです。

.. The encoding in the source mapping for the bytecode is more complicated:
.. It is a list of ``s:l:f:j:m`` separated by ``;``. Each of these
.. elements corresponds to an instruction, i.e. you cannot use the byte offset
.. but have to use the instruction offset (push instructions are longer than a single byte).
.. The fields ``s``, ``l`` and ``f`` are as above. ``j`` can be either
.. ``i``, ``o`` or ``-`` signifying whether a jump instruction goes into a
.. function, returns from a function or is a regular jump as part of e.g. a loop.
.. The last field, ``m``, is an integer that denotes the "modifier depth". This depth
.. is increased whenever the placeholder statement (``_``) is entered in a modifier
.. and decreased when it is left again. This allows debuggers to track tricky cases
.. like the same modifier being used twice or multiple placeholder statements being
.. used in a single modifier.

バイトコードのソースマッピングでのエンコーディングはもっと複雑です。
それは ``;`` で区切られた ``s:l:f:j:m`` のリストです。
これらの要素はそれぞれ命令に対応しています。
つまり、バイトオフセットを使用することはできず、命令オフセットを使用する必要があります（プッシュ命令は1バイトよりも長い）。
フィールド ``s`` 、 ``l`` 、 ``f`` は上記の通りです。
``j`` は ``i`` 、 ``o`` 、 ``-`` のいずれかで、ジャンプ命令が関数に入るのか、関数から戻るのか、ループなどの一部としての通常のジャンプなのかを示します。
最後のフィールド ``m`` は、「修飾子の深さ」を示す整数です。
この深さは、修飾子にプレースホルダーステートメント（ ``_`` ）が入力されるたびに増加し、再び入力されると減少します。
これにより、同じ修飾子が2回使われたり、1つの修飾子に複数のプレースホルダー文が使われたりするようなトリッキーなケースをデバッガーが追跡できます。

.. In order to compress these source mappings especially for bytecode, the
.. following rules are used:
.. - If a field is empty, the value of the preceding element is used.
.. - If a ``:`` is missing, all following fields are considered empty.

特にバイトコードの場合、これらのソースマッピングを圧縮するために、以下のルールが使われています。

- フィールドが空の場合は、直前の要素の値が使用されます。

- ``:`` がない場合、以下のすべてのフィールドは空であるとみなされます。

これは、次のソースマッピングが同じ情報を表していることを意味します。

``1:2:1;1:9:1;2:1:2;2:1:2;2:1:2``

``1:2:1;:9;2:1:2;;``

.. Important to note is that when the :ref:`verbatim <yul-verbatim>` builtin is used,
.. the source mappings will be invalid: The builtin is considered a single
.. instruction instead of potentially multiple.
.. 

重要なのは、 :ref:`verbatim <yul-verbatim>` ビルトインを使用すると、ソースマッピングが無効になることです。
ビルドインは複数の命令ではなく、1つの命令とみなされます。
