.. index:: Bugs

.. _known_bugs:

##################
既知のバグのリスト
##################

.. Below, you can find a JSON-formatted list of some of the known security-relevant bugs in the
.. Solidity compiler. The file itself is hosted in the `Github repository
.. <https://github.com/ethereum/solidity/blob/develop/docs/bugs.json>`_.
.. The list stretches back as far as version 0.3.0, bugs known to be present only
.. in versions preceding that are not listed.

以下に、Solidityコンパイラのセキュリティ関連の既知のバグをJSON形式でリストアップしています。
このファイルは  `Githubリポジトリ <https://github.com/ethereum/solidity/blob/develop/docs/bugs.json>`_  にあります。
このリストはバージョン0.3.0までさかのぼりますが、それ以前のバージョンにしか存在しないことがわかっているバグはリストに含まれていません。

.. There is another file called `bugs_by_version.json
.. <https://github.com/ethereum/solidity/blob/develop/docs/bugs_by_version.json>`_,
.. which can be used to check which bugs affect a specific version of the compiler.

また、 `bugs_by_version.json <https://github.com/ethereum/solidity/blob/develop/docs/bugs_by_version.json>`_ というファイルがあり、特定のバージョンのコンパイラーに影響を与えるバグを確認できます。

.. Contract source verification tools and also other tools interacting with
.. contracts should consult this list according to the following criteria:

コントラクトソース検証ツール、およびコントラクトと相互作用するその他のツールは、以下の基準に従ってこのリストを参照する必要があります。

.. - It is mildly suspicious if a contract was compiled with a nightly compiler version instead of a released version. This list does not keep track of unreleased or nightly versions.

- コントラクトがリリースされたバージョンではなく、nightlyコンパイラのバージョンでコンパイルされた場合は、少し疑わしいです。
  このリストでは、リリースされていないバージョンやnightlyバージョンの記録は取っていません。

.. - It is also mildly suspicious if a contract was compiled with a version that was
..   not the most recent at the time the contract was created. For contracts
..   created from other contracts, you have to follow the creation chain
..   back to a transaction and use the date of that transaction as creation date.

- また、コントラクトが作成された時点で最新ではないバージョンでコンパイルされていた場合、少し疑わしいです。
  他のコントラクトから作成されたコントラクトについては、作成の連鎖をトランザクションまでさかのぼり、そのトランザクションの日付を作成日として使用する必要があります。

.. - It is highly suspicious if a contract was compiled with a compiler that
..   contains a known bug and the contract was created at a time where a newer
..   compiler version containing a fix was already released.

- 既知のバグを含むコンパイラを使用してコントラクトを作成し、修正プログラムを含む新しいバージョンのコンパイラがすでにリリースされている時期にコントラクトが作成された場合、非常に疑わしいです。

.. The JSON file of known bugs below is an array of objects, one for each bug, with the following keys:

以下の既知のバグのJSONファイルは、各バグに1つずつ、以下のキーを持つオブジェクトの配列です。

.. uid
..     Unique identifier given to the bug in the form of ``SOL-<year>-<number>``.
..     It is possible that multiple entries exists with the same uid. This means
..     multiple version ranges are affected by the same bug.
.. name
..     Unique name given to the bug
.. summary
..     Short description of the bug
.. description
..     Detailed description of the bug
.. link
..     URL of a website with more detailed information, optional
.. introduced
..     The first published compiler version that contained the bug, optional
.. fixed
..     The first published compiler version that did not contain the bug anymore
.. publish
..     The date at which the bug became known publicly, optional
.. severity
..     Severity of the bug: very low, low, medium, high. Takes into account
..     discoverability in contract tests, likelihood of occurrence and
..     potential damage by exploits.
.. conditions
..     Conditions that have to be met to trigger the bug. The following
..     keys can be used:
..     ``optimizer``, Boolean value which means that the optimizer has to be switched on to enable the bug.
..     ``evmVersion``, a string that indicates which EVM version compiler settings trigger the bug.
..     The string can contain comparison operators.
..     For example, ``">=constantinople"`` means that the bug is present when the EVM version is set to ``constantinople`` or
..     later.
..     If no conditions are given, assume that the bug is present.
.. check
..     This field contains different checks that report whether the smart contract
..     contains the bug or not. The first type of check are JavaScript regular
..     expressions that are to be matched against the source code ("source-regex")
..     if the bug is present.  If there is no match, then the bug is very likely
..     not present. If there is a match, the bug might be present.  For improved
..     accuracy, the checks should be applied to the source code after stripping
..     comments.
..     The second type of check are patterns to be checked on the compact AST of
..     the Solidity program ("ast-compact-json-path"). The specified search query
..     is a `JsonPath <https://github.com/json-path/JsonPath>`_ expression.
..     If at least one path of the Solidity AST matches the query, the bug is
..     likely present.

uid
   ``SOL-<year>-<number>``  形式でバグに与えられた一意の識別子。
   同じuidで複数のエントリが存在する可能性があります。
name
   バグに付けられたユニークな名前。
summary
   バグの短い説明。
description
   バグの詳細な説明。
link
   より詳細な情報があるウェブサイトのURL。オプション。
introduced
   バグを含んで最初に公開されたコンパイラバージョン。オプション。
fixed
   バグを含まなくなって最初に公開されたコンパイラバージョン。
publish
   バグが公に知られるようになった日付。オプション。
severity
   バグの深刻度: very low、low、medium、high。
   コントラクトテストでの発見可能性、発生の可能性、悪用による被害の可能性を考慮しています。
conditions
   バグを発生させるために満たさなければならない条件。
   以下のキーが使用できます。
   ``optimizer``: ブール値。バグを有効にするにはオプティマイザがオンになっていなければならないことを意味します。
   ``evmVersion``: どのEVMバージョンのコンパイラ設定がバグを引き起こすかを示す文字列。この文字列には比較演算子を含めることができます。
   例えば、 ``">=constantinople"``  は EVM バージョンが  ``constantinople``  以降に設定されている場合にバグが発生することを意味します。
check
<<<<<<< HEAD
   このフィールドには、スマートコントラクトにバグが含まれているかどうかを報告するさまざまなチェックが含まれます。
   最初のタイプのチェックは、バグが存在する場合にソースコード（「source-regex」）に対してマッチされるJavaScriptの正規表現です。
   一致しない場合は、バグが存在しない可能性が高いです。一致するものがあれば、そのバグは存在する可能性があります。
   精度を上げるためには、コメントを削除した後のソースコードにチェックを適用する必要があります。
   2番目のタイプのチェックは、SolidityプログラムのコンパクトASTにチェックするパターンです（「ast-compact-json-path」）。指定された検索クエリは、 `JsonPath <https://github.com/json-path/JsonPath>`_ の式です。
   SolidityのASTの少なくとも1つのパスがクエリにマッチする場合、バグが存在する可能性が高いです。
=======
    This field contains different checks that report whether the smart contract
    contains the bug or not. The first type of check are JavaScript regular
    expressions that are to be matched against the source code ("source-regex")
    if the bug is present.  If there is no match, then the bug is very likely
    not present. If there is a match, the bug might be present.  For improved
    accuracy, the checks should be applied to the source code after stripping
    comments.
    The second type of check are patterns to be checked on the compact AST of
    the Solidity program ("ast-compact-json-path"). The specified search query
    is a `JsonPath <https://github.com/json-path/JsonPath>`_ expression.
    If at least one path of the Solidity AST matches the query, the bug is
    likely present.
>>>>>>> english/develop

.. literalinclude:: bugs.json
   :language: js

