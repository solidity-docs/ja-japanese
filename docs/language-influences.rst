.. Language Influences

##########
言語の影響
##########

Solidityは、いくつかの有名なプログラミング言語に影響やインスピレーションを受けた `カーリーブラケット言語 <https://en.wikipedia.org/wiki/List_of_programming_languages_by_type#Curly-bracket_languages>`_ です。

.. Solidity is most profoundly influenced by C++, but also borrowed concepts from languages like Python, JavaScript, and others.

Solidityは、C++から最も大きな影響を受けていますが、PythonやJavaScriptなどの言語からもコンセプトを借りています。

.. The influence from C++ can be seen in the syntax for variable declarations, for loops, the concept of overloading functions, implicit and explicit type conversions and many other details.

C++からの影響は、変数宣言やforループの構文、関数のオーバーロードの概念、暗黙的な型変換と明示的な型変換、その他多くの細部に見られます。

.. In the early days of the language, Solidity used to be partly influenced by JavaScript.
.. This was due to function-level scoping of variables and the use of the keyword ``var``.
.. The JavaScript influence was reduced starting from version 0.4.0.
.. Now, the main remaining similarity to JavaScript is that functions are defined using the keyword ``function``.
.. Solidity also supports import syntax and semantics that are similar to those available in JavaScript.
.. Besides those points, Solidity looks like most other curly-bracket languages and has no major JavaScript influence anymore.

言語開発の初期において、SolidityはJavaScriptの影響を部分的に受けていました。
これは、関数レベルでの変数のスコープや、キーワード ``var`` の使用によるものでした。
JavaScriptの影響はバージョン0.4.0から少なくなりました。
現在、JavaScriptとの主な類似点は、関数がキーワード ``function`` を使って定義されていることです。
また、Solidityは、JavaScriptと同様のインポート構文とセマンティクスをサポートしています。
これらの点を除けば、Solidityは他の多くのカーリーブラケット言語と同じように見えますし、もはやJavaScriptの影響は大きくありません。

.. Another influence to Solidity was Python.
.. Solidity's modifiers were added trying to model Python's decorators with a much more restricted functionality.
.. Furthermore, multiple inheritance, C3 linearization, and the ``super`` keyword are taken from Python as well as the general assignment and copy semantics of value and reference types.

もう一つSolidityに影響を与えたのがPythonです。
Solidityの修飾子は、Pythonのデコレータをモデルにして追加されたもので、機能はより制限されています。
さらに、多重継承、C3線形化、 ``super`` キーワードは、値や参照型の一般的な代入とコピーのセマンティクスと同様に、Pythonから採用されています。
