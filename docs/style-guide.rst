.. index:: style, coding style

##############
スタイルガイド
##############

******************
イントロダクション
******************

.. This guide is intended to provide coding conventions for writing Solidity code.
.. This guide should be thought of as an evolving document that will change over time as useful conventions are found and old conventions are rendered obsolete.

このガイドは、Solidityのコードを書くためのコーディング規約を提供することを目的としています。
このガイドは、有用な規約が発見されたり、古い規約が廃止されたりして、時間とともに変化していく進化する文書として考えるべきです。

.. Many projects will implement their own style guides.
.. In the event of conflicts, project specific style guides take precedence.

多くのプロジェクトでは、独自のスタイルガイドを導入しています。
矛盾が生じた場合は、プロジェクト独自のスタイルガイドが優先されます。

.. The structure and many of the recommendations within this style guide were taken from Python's `pep8 style guide <https://peps.python.org/pep-0008/>`_.

このスタイルガイドの構造や推奨事項の多くは、Pythonの `pep8スタイルガイド <https://peps.python.org/pep-0008/>`_ から引用されています。

.. The goal of this guide is *not* to be the right way or the best way to write Solidity code.
.. The goal of this guide is *consistency*.
.. A quote from Python's `pep8 <https://peps.python.org/pep-0008/#a-foolish-consistency-is-the-hobgoblin-of-little-minds>`_ captures this concept well.

このガイドの目的は、Solidityのコードを書くための正しい方法や最良の方法であることではありません。
このガイドの目的は、 *一貫性* です。
Pythonの `pep8 <https://peps.python.org/pep-0008/#a-foolish-consistency-is-the-hobgoblin-of-little-minds>`_ からの引用はこの概念をよく表しています。

.. .. note::

..     A style guide is about consistency.
..     Consistency with this style guide is important.
..     Consistency within a project is more important.
..     Consistency within one module or function is most important.

..     But most importantly: **know when to be inconsistent** -- sometimes the style guide just doesn't apply. When in doubt, use your best judgment. Look at other examples and decide what looks best. And do not hesitate to ask!

.. note::

    スタイルガイドとは一貫性のことです。
    このスタイルガイドとの一貫性は重要です。
    プロジェクト内での一貫性はより重要です。
    一つのモジュールや関数の中での一貫性が最も重要です。

    しかし、最も重要なことは、 **一貫性がないことを自覚すること** です。
    時には、スタイルガイドが適用できないこともあります。
    迷ったときは、自分のベストな判断で行動しましょう。
    他の例を見て、何がベストなのかを判断してください。
    そして、迷わず質問してください！

****************
コードレイアウト
****************

インデント
==========

インデントレベルごとに4つのスペースを使用してください。

タブかスペースか
================

スペースのほうが好ましいインデント方法です。

タブとスペースの混在は避けてください。

空行
====

Solidityのソースコードでは、トップレベルの宣言を2つの空行で囲んでください。

.. Yes:

OK:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract A {
        // ...
    }

    contract B {
        // ...
    }

    contract C {
        // ...
    }

.. No:

NG:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract A {
        // ...
    }
    contract B {
        // ...
    }

    contract C {
        // ...
    }

.. Within a contract surround function declarations with a single blank line.

コントラクト内では、関数宣言を1行の空行で囲みます。

.. Blank lines may be omitted between groups of related one-liners (such as stub functions for an abstract contract)

関連するワンライナーのグループの間では、空白行を省略できます（抽象的なコントラクトのスタブ関数など）。

.. Yes:

OK:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    abstract contract A {
        function spam() public virtual pure;
        function ham() public virtual pure;
    }

    contract B is A {
        function spam() public pure override {
            // ...
        }

        function ham() public pure override {
            // ...
        }
    }

.. No:

NG:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    abstract contract A {
        function spam() virtual pure public;
        function ham() public virtual pure;
    }

    contract B is A {
        function spam() public pure override {
            // ...
        }
        function ham() public pure override {
            // ...
        }
    }

.. _maximum_line_length:

最大の行の長さ
==============

.. Maximum suggested line length is 120 characters.

推奨される行の長さは最大120文字です。

.. Wrapped lines should conform to the following guidelines.

ラップされる行は以下のガイドラインに沿ってください。

.. 1. The first argument should not be attached to the opening parenthesis.
.. 2. One, and only one, indent should be used.
.. 3. Each argument should fall on its own line.
.. 4. The terminating element, :code:`);`, should be placed on the final line by itself.

1. 第1引数は、開始括弧に付けてはいけません。
2. インデントは1つだけにしてください。
3. それぞれの主張は、それぞれのライン上にあるべきものです。
4. 終端要素である :code:`);` は、それ自体で最終行に配置する必要があります。

関数呼び出し

.. Yes:

OK:

.. code-block:: solidity

    thisFunctionCallIsReallyLong(
        longArgument1,
        longArgument2,
        longArgument3
    );

.. No:

NG:

.. code-block:: solidity

    thisFunctionCallIsReallyLong(longArgument1,
                                  longArgument2,
                                  longArgument3
    );

    thisFunctionCallIsReallyLong(longArgument1,
        longArgument2,
        longArgument3
    );

    thisFunctionCallIsReallyLong(
        longArgument1, longArgument2,
        longArgument3
    );

    thisFunctionCallIsReallyLong(
    longArgument1,
    longArgument2,
    longArgument3
    );

    thisFunctionCallIsReallyLong(
        longArgument1,
        longArgument2,
        longArgument3);

.. Assignment Statements

代入文

.. Yes:

OK:

.. code-block:: solidity

    thisIsALongNestedMapping[being][set][toSomeValue] = someFunction(
        argument1,
        argument2,
        argument3,
        argument4
    );

.. No:

NG:

.. code-block:: solidity

    thisIsALongNestedMapping[being][set][toSomeValue] = someFunction(argument1,
                                                                       argument2,
                                                                       argument3,
                                                                       argument4);

.. Event Definitions and Event Emitters

イベント定義とイベントエミッタ

.. Yes:

OK:

.. code-block:: solidity

    event LongAndLotsOfArgs(
        address sender,
        address recipient,
        uint256 publicKey,
        uint256 amount,
        bytes32[] options
    );

    LongAndLotsOfArgs(
        sender,
        recipient,
        publicKey,
        amount,
        options
    );

.. No:

NG:

.. code-block:: solidity

    event LongAndLotsOfArgs(address sender,
                            address recipient,
                            uint256 publicKey,
                            uint256 amount,
                            bytes32[] options);

    LongAndLotsOfArgs(sender,
                      recipient,
                      publicKey,
                      amount,
                      options);

.. Source File Encoding

ソースファイルのエンコーディング
================================

.. UTF-8 or ASCII encoding is preferred.

UTF-8またはASCIIのエンコーディングが望ましいです。

インポート
==========

.. Import statements should always be placed at the top of the file.

インポート文は、常にファイルの先頭に配置する必要があります。

.. Yes:

OK:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    import "./Owned.sol";

    contract A {
        // ...
    }


    contract B is Owned {
        // ...
    }

.. No:

NG:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract A {
        // ...
    }

    import "./Owned.sol";

    contract B is Owned {
        // ...
    }

.. Order of Functions

関数の順番
==========

.. Ordering helps readers identify which functions they can call and to find the constructor and fallback definitions easier.

順番を決めることで、読者はどの関数を呼び出すことができるかを識別し、コンストラクタやフォールバックの定義を見つけやすくなります。

.. Functions should be grouped according to their visibility and ordered:

関数はビジビリティに応じてグループ化し、順序立てて配置します。

.. - constructor
.. - receive function (if exists)
.. - fallback function (if exists)
.. - external
.. - public
.. - internal
.. - private

- コンストラクタ
- 受信関数（ある場合）
- フォールバック関数（存在する場合）
- 外部
- パブリック
- 内部
- プライベート

.. Within a grouping, place the ``view`` and ``pure`` functions last.

グループ内では、 ``view`` と ``pure`` の関数を最後に配置します。

.. Yes:

OK:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    contract A {
        constructor() {
            // ...
        }

        receive() external payable {
            // ...
        }

        fallback() external {
            // ...
        }

        // External functions
        // ...

        // External functions that are view
        // ...

        // External functions that are pure
        // ...

        // Public functions
        // ...

        // Internal functions
        // ...

        // Private functions
        // ...
    }

.. No:

NG:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    contract A {

        // External functions
        // ...

        fallback() external {
            // ...
        }
        receive() external payable {
            // ...
        }

        // Private functions
        // ...

        // Public functions
        // ...

        constructor() {
            // ...
        }

        // Internal functions
        // ...
    }

.. Whitespace in Expressions

式中の空白文字
==============

.. Avoid extraneous whitespace in the following  situations:

次のような場合は、余計な空白を入れないようにしましょう。

.. Immediately inside parenthesis, brackets or braces, with the exception of single line function declarations.

括弧、大括弧、中括弧のすぐ内側。
ただし、1行の関数宣言は例外です。

.. Yes:

OK:

.. code-block:: solidity

    spam(ham[1], Coin({name: "ham"}));

.. No:

NG:

.. code-block:: solidity

    spam( ham[ 1 ], Coin( { name: "ham" } ) );

.. Exception:

例外:

.. code-block:: solidity

    function singleLine() public { spam(); }

.. Immediately before a comma, semicolon:

コンマ、セミコロンの直前。

.. Yes:

OK:

.. code-block:: solidity

    function spam(uint i, Coin coin) public;

.. No:

NG:

.. code-block:: solidity

    function spam(uint i , Coin coin) public ;

.. More than one space around an assignment or other operator to align with another:

代入や他の演算子の周りに1つ以上のスペースを設けて整列させます。

.. Yes:

OK:

.. code-block:: solidity

    x = 1;
    y = 2;
    longVariable = 3;

.. No:

NG:

.. code-block:: solidity

    x            = 1;
    y            = 2;
    longVariable = 3;

.. Don not include a whitespace in the receive and fallback functions:

受信関数とフォールバック関数に空白を入れてはいけません:

.. Yes:

OK:

.. code-block:: solidity

    receive() external payable {
        ...
    }

    fallback() external {
        ...
    }

.. No:

NG:

.. code-block:: solidity

    receive () external payable {
        ...
    }

    fallback () external {
        ...
    }

.. Control Structures

制御構造
========

.. The braces denoting the body of a contract, library, functions and structs should:

コントラクト、ライブラリ、関数、構造体の本体を示す中括弧は、次のようにします。

.. * open on the same line as the declaration
.. * close on their own line at the same indentation level as the beginning of the declaration.
.. * The opening brace should be preceded by a single space.

* 宣言と同じ行にオープンする
* 宣言の先頭と同じインデントレベルで独立した行でクローズする
* 冒頭のブレースの前に半角スペースを入れる

.. Yes:

OK:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract Coin {
        struct Bank {
            address owner;
            uint balance;
        }
    }

.. No:

NG:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract Coin
    {
        struct Bank {
            address owner;
            uint balance;
        }
    }

.. The same recommendations apply to the control structures ``if``, ``else``, ``while``,
.. and ``for``.

制御構造 ``if`` 、 ``else`` 、 ``while`` 、 ``for`` にも同じ推奨事項が適用されます。

.. Additionally there should be a single space between the control structures
.. ``if``, ``while``, and ``for`` and the parenthetic block representing the
.. conditional, as well as a single space between the conditional parenthetic
.. block and the opening brace.

また、制御構造 ``if`` 、 ``while`` 、 ``for`` と条件を表す親ブロックの間には半角スペースを入れ、条件を表す親ブロックと開始ブレースの間にも半角スペースを入れる必要があります。

.. Yes:

OK:

.. code-block:: solidity

    if (...) {
        ...
    }

    for (...) {
        ...
    }

.. No:

NG:

.. code-block:: solidity

    if (...)
    {
        ...
    }

    while(...){
    }

    for (...) {
        ...;}

.. For control structures whose body contains a single statement, omitting the
.. braces is ok *if* the statement is contained on a single line.

本体が1つの文を含む制御構造の場合、文が1行に収まっていれば、中括弧を省略しても問題ありません。

.. Yes:

OK:

.. code-block:: solidity

    if (x < 10)
        x += 1;

.. No:

NG:

.. code-block:: solidity

    if (x < 10)
        someArray.push(Coin({
            name: 'spam',
            value: 42
        }));

.. For ``if`` blocks which have an ``else`` or ``else if`` clause, the ``else`` should be
.. placed on the same line as the ``if``'s closing brace. This is an exception compared
.. to the rules of other block-like structures.

``else`` または ``else if`` 句を持つ ``if`` ブロックでは、 ``else`` は ``if`` の閉じ括弧と同じ行に配置します。
これは、他のブロックのような構造のルールに比べて例外的なものです。

.. Yes:

OK:

.. code-block:: solidity

    if (x < 3) {
        x += 1;
    } else if (x > 7) {
        x -= 1;
    } else {
        x = 5;
    }

    if (x < 3)
        x += 1;
    else
        x -= 1;

.. No:

NG:

.. code-block:: solidity

    if (x < 3) {
        x += 1;
    }
    else {
        x -= 1;
    }

.. Function Declaration

関数宣言
========

.. For short function declarations, it is recommended for the opening brace of the
.. function body to be kept on the same line as the function declaration.

短い関数宣言の場合は、関数本体の開始波括弧を関数宣言と同じ行に置くことをお勧めします。

.. The closing brace should be at the same indentation level as the function
.. declaration.

閉じ括弧は、関数宣言と同じインデントレベルでなければなりません。

.. The opening brace should be preceded by a single space.

冒頭のブレースの前には半角スペースを入れてください。

.. Yes:

OK:

.. code-block:: solidity

    function increment(uint x) public pure returns (uint) {
        return x + 1;
    }

    function increment(uint x) public pure onlyOwner returns (uint) {
        return x + 1;
    }

.. No:

NG:

.. code-block:: solidity

    function increment(uint x) public pure returns (uint)
    {
        return x + 1;
    }

    function increment(uint x) public pure returns (uint){
        return x + 1;
    }

    function increment(uint x) public pure returns (uint) {
        return x + 1;
        }

    function increment(uint x) public pure returns (uint) {
        return x + 1;}

.. The modifier order for a function should be:

関数の修飾順序は次のようになります。

.. 1. Visibility
.. 2. Mutability
.. 3. Virtual
.. 4. Override
.. 5. Custom modifiers

1. ビジビリティ
2. ミュータビリティ
3. バーチャル
4. オーバーライド
5. カスタムモディファイア

.. Yes:

OK:

.. code-block:: solidity

    function balance(uint from) public view override returns (uint)  {
        return balanceOf[from];
    }

    function shutdown() public onlyOwner {
        selfdestruct(owner);
    }

.. No:

NG:

.. code-block:: solidity

    function balance(uint from) public override view returns (uint)  {
        return balanceOf[from];
    }

    function shutdown() onlyOwner public {
        selfdestruct(owner);
    }

.. For long function declarations, it is recommended to drop each argument onto
.. its own line at the same indentation level as the function body.  The closing
.. parenthesis and opening bracket should be placed on their own line as well at
.. the same indentation level as the function declaration.

長い関数宣言の場合は、各引数を関数本体と同じインデントレベルで一行にまとめることをお勧めします。
閉じ括弧と開き括弧も同様に、関数宣言と同じインデントレベルで一行に置く必要があります。

.. Yes:

OK:

.. code-block:: solidity

    function thisFunctionHasLotsOfArguments(
        address a,
        address b,
        address c,
        address d,
        address e,
        address f
    )
        public
    {
        doSomething();
    }

.. No:

NG:

.. code-block:: solidity

    function thisFunctionHasLotsOfArguments(address a, address b, address c,
        address d, address e, address f) public {
        doSomething();
    }

    function thisFunctionHasLotsOfArguments(address a,
                                            address b,
                                            address c,
                                            address d,
                                            address e,
                                            address f) public {
        doSomething();
    }

    function thisFunctionHasLotsOfArguments(
        address a,
        address b,
        address c,
        address d,
        address e,
        address f) public {
        doSomething();
    }

.. If a long function declaration has modifiers, then each modifier should be
.. dropped to its own line.

長い関数宣言にモディファイアがある場合は、各モディファイアをそれぞれの行に落とす必要があります。

.. Yes:

OK:

.. code-block:: solidity

    function thisFunctionNameIsReallyLong(address x, address y, address z)
        public
        onlyOwner
        priced
        returns (address)
    {
        doSomething();
    }

    function thisFunctionNameIsReallyLong(
        address x,
        address y,
        address z
    )
        public
        onlyOwner
        priced
        returns (address)
    {
        doSomething();
    }

.. No:

NG:

.. code-block:: solidity

    function thisFunctionNameIsReallyLong(address x, address y, address z)
                                          public
                                          onlyOwner
                                          priced
                                          returns (address) {
        doSomething();
    }

    function thisFunctionNameIsReallyLong(address x, address y, address z)
        public onlyOwner priced returns (address)
    {
        doSomething();
    }

    function thisFunctionNameIsReallyLong(address x, address y, address z)
        public
        onlyOwner
        priced
        returns (address) {
        doSomething();
    }

.. Multiline output parameters and return statements should follow the same style recommended for wrapping long lines found in the :ref:`Maximum Line Length <maximum_line_length>` section.

複数行の出力パラメータやreturn文は、 :ref:`最大の行の長さ <maximum_line_length>` セクションで推奨されている長い行の折り返しと同じスタイルにしてください。

.. Yes:

OK:

.. code-block:: solidity

    function thisFunctionNameIsReallyLong(
        address a,
        address b,
        address c
    )
        public
        returns (
            address someAddressName,
            uint256 LongArgument,
            uint256 Argument
        )
    {
        doSomething()

        return (
            veryLongReturnArg1,
            veryLongReturnArg2,
            veryLongReturnArg3
        );
    }

.. No:

NG:

.. code-block:: solidity

    function thisFunctionNameIsReallyLong(
        address a,
        address b,
        address c
    )
        public
        returns (address someAddressName,
                 uint256 LongArgument,
                 uint256 Argument)
    {
        doSomething()

        return (veryLongReturnArg1,
                veryLongReturnArg1,
                veryLongReturnArg1);
    }

.. For constructor functions on inherited contracts whose bases require arguments, it is recommended to drop the base constructors onto new lines in the same manner as modifiers if the function declaration is long or hard to read.

ベースが引数を必要とする継承されたコントラクトのコンストラクタ関数については、関数宣言が長い場合や読みにくい場合には、モディファイアと同じ方法でベースのコンストラクタを新しい行に落とすことをお勧めします。

.. Yes:

OK:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    // Base contracts just to make this compile
    contract B {
        constructor(uint) {
        }
    }


    contract C {
        constructor(uint, uint) {
        }
    }


    contract D {
        constructor(uint) {
        }
    }


    contract A is B, C, D {
        uint x;

        constructor(uint param1, uint param2, uint param3, uint param4, uint param5)
            B(param1)
            C(param2, param3)
            D(param4)
        {
            // do something with param5
            x = param5;
        }
    }

.. No:

NG:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;

    // Base contracts just to make this compile
    contract B {
        constructor(uint) {
        }
    }

    contract C {
        constructor(uint, uint) {
        }
    }

    contract D {
        constructor(uint) {
        }
    }

    contract A is B, C, D {
        uint x;

        constructor(uint param1, uint param2, uint param3, uint param4, uint param5)
        B(param1)
        C(param2, param3)
        D(param4) {
            x = param5;
        }
    }

    contract X is B, C, D {
        uint x;

        constructor(uint param1, uint param2, uint param3, uint param4, uint param5)
            B(param1)
            C(param2, param3)
            D(param4) {
                x = param5;
            }
    }

.. When declaring short functions with a single statement, it is permissible to do it on a single line.

短い関数を1つの文で宣言する場合、1行で宣言しても構いません。

.. Permissible:

許可されています。

.. code-block:: solidity

    function shortFunction() public { doSomething(); }

.. These guidelines for function declarations are intended to improve readability.
.. Authors should use their best judgment as this guide does not try to cover all possible permutations for function declarations.

この関数宣言のガイドラインは、読みやすさを向上させることを目的としています。
このガイドラインは、関数宣言のすべての可能性を網羅するものではありませんので、執筆者は最善の判断を下す必要があります。

マッピング
==========

.. In variable declarations, do not separate the keyword ``mapping`` from its type by a space.
.. Do not separate any nested ``mapping`` keyword from its type by whitespace.

変数宣言では、キーワード ``mapping`` とその型は空白で区切りません。
また、ネストした ``mapping`` キーワードとその型は空白で区切りません。

.. Yes:

OK:

.. code-block:: solidity

    mapping(uint => uint) map;
    mapping(address => bool) registeredAddresses;
    mapping(uint => mapping(bool => Data[])) public data;
    mapping(uint => mapping(uint => s)) data;

.. No:

NG:

.. code-block:: solidity

    mapping (uint => uint) map;
    mapping( address => bool ) registeredAddresses;
    mapping (uint => mapping (bool => Data[])) public data;
    mapping(uint => mapping (uint => s)) data;

.. Variable Declarations

変数宣言
========

.. Declarations of array variables should not have a space between the type and the brackets.

配列変数の宣言では、型と括弧の間にスペースを入れてはいけません。

.. Yes:

OK:

.. code-block:: solidity

    uint[] x;

.. No:

NG:

.. code-block:: solidity

    uint [] x;

.. Other Recommendations

その他の推奨事項
================

.. * Strings should be quoted with double-quotes instead of single-quotes.

* 文字列は、シングルクォートではなくダブルクォートで引用してください。

.. Yes:

OK:

.. code-block:: solidity

    str = "foo";
    str = "Hamlet says, 'To be or not to be...'";

.. No:

NG:

.. code-block:: solidity

    str = 'bar';
    str = '"Be yourself; everyone else is already taken." -Oscar Wilde';

.. * Surround operators with a single space on either side.

* 演算子を左右の半角スペースで囲みます。

.. Yes:

OK:

.. code-block:: solidity
    :force:

    x = 3;
    x = 100 / 10;
    x += 3 + 4;
    x |= y && z;

.. No:

NG:

.. code-block:: solidity
    :force:

    x=3;
    x = 100/10;
    x += 3+4;
    x |= y&&z;

.. * Operators with a higher priority than others can exclude surrounding whitespace in order to denote precedence.
..   This is meant to allow for improved readability for complex statements.
..   You should always use the same amount of whitespace on either side of an operator:

* 優先順位の高い演算子は、優先順位を示すために周囲の空白を除外できます。
  これは、複雑な文の可読性を高めるためのものです。
  演算子の両側には、常に同じ量の空白を使用する必要があります。

.. Yes:

OK:

.. code-block:: solidity

    x = 2**3 + 5;
    x = 2*y + 3*z;
    x = (a+b) * (a-b);

.. No:

NG:

.. code-block:: solidity

    x = 2** 3 + 5;
    x = y+z;
    x +=1;

.. Order of Layout

****************
レイアウトの順序
****************

.. Layout contract elements in the following order:

コントラクトの要素を以下の順序でレイアウトします。

1. プラグマ文
2. インポート文
3. インターフェース
4. ライブラリ
5. コントラクト

.. Inside each contract, library or interface, use the following order:

各コントラクト、ライブラリ、インターフェースの内部では、以下の順序を使用します。

1. 型の宣言
2. 状態変数
3. イベント
4. エラー
5. モディファイア
6. 関数

.. .. note::

..     It might be clearer to declare types close to their use in events or state variables.

.. note::

    イベントや状態変数での使用に近い形で型を宣言した方がわかりやすいかもしれません。

Yes:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.4 <0.9.0;

    abstract contract Math {
        error DivideByZero();
        function divide(int256 numerator, int256 denominator) public virtual returns (uint256);
    }

No:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.4 <0.9.0;

    abstract contract Math {
        function divide(int256 numerator, int256 denominator) public virtual returns (uint256);
        error DivideByZero();
    }

.. Naming Conventions

********
命名規則
********

.. Naming conventions are powerful when adopted and used broadly.
.. The use of different conventions can convey significant *meta* information that would otherwise not be immediately available.

命名規則は、広く採用され使用されることで力を発揮します。
異なる規約を使用することで、他の方法ではすぐには得られない重要なメタ情報を伝えることができます。

.. The naming recommendations given here are intended to improve the readability, and thus they are not rules, but rather guidelines to try and help convey the most information through the names of things.

ここで述べられているネーミングの推奨事項は、読みやすさを向上させることを目的としているため、ルールではなく、物事の名前を通して最も多くの情報を伝えるためのガイドラインとなっています。

.. Lastly, consistency within a codebase should always supersede any conventions outlined in this document.

最後に、コードベース内の一貫性は、常にこのドキュメントで説明されている規約よりも優先されるべきです。

.. Naming Styles

命名スタイル
============

.. To avoid confusion, the following names will be used to refer to different naming styles.

混乱を避けるために、以下の名称は異なるネーミングスタイルを参照するために使用されます。

.. * ``b`` (single lowercase letter)

* ``b`` （半角英小文字）

.. * ``B`` (single uppercase letter)

* ``B`` （半角英大文字）

.. * ``lowercase``

* ``lowercase``

.. * ``UPPERCASE``

* ``UPPERCASE``

.. * ``UPPER_CASE_WITH_UNDERSCORES``

* ``UPPER_CASE_WITH_UNDERSCORES``

.. * ``CapitalizedWords`` (or CapWords)

* ``CapitalizedWords`` （またはCapWords）

.. * ``mixedCase`` (differs from CapitalizedWords by initial lowercase character!)

* ``mixedCase``  (CapitalizedWordsとの違いは、頭文字が小文字であること!)

.. .. note::
..  When using initialisms in CapWords, capitalize all the letters of the initialisms. Thus HTTPServerError is better than HttpServerError. When using initialisms in mixedCase, capitalize all the letters of the initialisms, except keep the first one lower case if it is the beginning of the name. Thus xmlHTTPRequest is better than XMLHTTPRequest.

.. note::

    CapWordsで頭文字を使用する場合は、頭文字のすべての文字を大文字にします。
    したがって、HttpServerErrorよりもHTTPServerErrorの方がよいです。
    頭文字をmixedCaseで使用する場合は、頭文字の文字をすべて大文字にします。
    ただし、名前の先頭の文字は小文字にします。
    したがって、xmlHTTPRequestの方がXMLHTTPRequestよりも優れています。

.. Names to Avoid

避けるべき名前
==============

.. * ``l`` - Lowercase letter el
.. * ``O`` - Uppercase letter oh
.. * ``I`` - Uppercase letter eye

* ``l``  - 小文字のエル
* ``O``  - 大文字のオー
* ``I``  - 大文字のアイ

.. Never use any of these for single letter variable names.
.. They are often indistinguishable from the numerals one and zero.

これらは一文字の変数名には絶対に使用しないでください。
これらは、数字のoneやzeroと区別がつかないことがあります。

.. Contract and Library Names

コントラクトとライブラリの名前
==============================

.. * Contracts and libraries should be named using the CapWords style. Examples: ``SimpleToken``, ``SmartBank``, ``CertificateHashRepository``, ``Player``, ``Congress``, ``Owned``.

* コントラクトやライブラリの名前は、CapWordsスタイルを使用してください。
  例: ``SimpleToken``, ``SmartBank``, ``CertificateHashRepository``, ``Player``, ``Congress``, ``Owned`` 。

.. * Contract and library names should also match their filenames.

* コントラクト名とライブラリ名は、ファイル名と一致している必要があります。

.. * If a contract file includes multiple contracts and/or libraries, then the filename should match the *core contract*. This is not recommended however if it can be avoided.

* コントラクトファイルに複数のコントラクトやライブラリが含まれている場合、ファイル名は *コアコントラクト* と一致させる必要があります。しかし、これは避けることができるならば、推奨されません。

.. As shown in the example below, if the contract name is ``Congress`` and the library name is ``Owned``, then their associated filenames should be ``Congress.sol`` and ``Owned.sol``.

以下の例のように、コントラクト名が ``Congress`` 、ライブラリ名が ``Owned`` の場合、関連するファイル名は ``Congress.sol`` と ``Owned.sol`` になります。

.. Yes:

OK:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;

    // Owned.sol
    contract Owned {
        address public owner;

        modifier onlyOwner {
            require(msg.sender == owner);
            _;
        }

        constructor() {
            owner = msg.sender;
        }

        function transferOwnership(address newOwner) public onlyOwner {
            owner = newOwner;
        }
    }

.. and in ``Congress.sol``:

そして、 ``Congress.sol`` で次のコードになっています。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    import "./Owned.sol";

    contract Congress is Owned, TokenRecipient {
        //...
    }

.. No:

NG:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;

    // owned.sol
    contract owned {
        address public owner;

        modifier onlyOwner {
            require(msg.sender == owner);
            _;
        }

        constructor() {
            owner = msg.sender;
        }

        function transferOwnership(address newOwner) public onlyOwner {
            owner = newOwner;
        }
    }

.. and in ``Congress.sol``:

そして、 ``Congress.sol`` で次のコードになっています。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.7.0;

    import "./owned.sol";

    contract Congress is owned, tokenRecipient {
        //...
    }

構造体名
========

構造体の名前は、CapWordsスタイルを使用してください。
例: ``MyCoin`` 、 ``Position`` 、 ``PositionXY`` 。

イベント名
==========

イベント名は、CapWordsスタイルを使用してください。
例: ``Deposit``, ``Transfer``, ``Approval``, ``BeforeTransfer``, ``AfterTransfer`` 。

関数名
======

関数はmixedCaseを使用してください。
例: ``getBalance``, ``transfer``, ``verifyOwner``, ``addMember``, ``changeOwner`` 。

関数の引数名
============

.. Function arguments should use mixedCase.

関数の引数には、mixedCaseを使用してください。
例: ``initialSupply``, ``account``, ``recipientAddress``, ``senderAddress``, ``newOwner`` 。

.. When writing library functions that operate on a custom struct, the struct should be the first argument and should always be named ``self``.

カスタム構造体を操作するライブラリ関数を書くときは、構造体を第1引数にして、常に ``self`` という名前にしてください。

.. Local and State Variable Names

ローカル変数名と状態変数名
==========================

mixedCaseを使用してください。
例: ``totalSupply``, ``remainingSupply``, ``balancesOf``, ``creatorAddress``, ``isPreSale``, ``tokenExchangeRate`` 。

定数
====

.. Constants should be named with all capital letters with underscores separating words.

定数の名前は、すべて大文字で、アンダースコアで単語を区切ってください。
例: ``MAX_BLOCKS``, ``TOKEN_NAME``, ``TOKEN_TICKER``, ``CONTRACT_VERSION`` 。

モディファイア名
================

mixedCaseを使用してください。
例: ``onlyBy`` 、 ``onlyAfter`` 、 ``onlyDuringThePreSale`` 。

.. Enums

列挙
====

.. Enums, in the style of simple type declarations, should be named using the CapWords style.

列挙（enum）は、単純な型宣言のスタイルで、CapWordsスタイルを使用してください。
例: ``TokenGroup``, ``Frame``, ``HashStyle``, ``CharacterLocation`` 。

.. Avoiding Naming Collisions

名前の衝突の回避
================

* ``singleTrailingUnderscore_``

.. This convention is suggested when the desired name collides with that of an existing state variable, function, built-in or otherwise reserved name.

この規約は、希望する名前が、既存の状態変数、関数、組み込み、またはその他の予約名と衝突する場合に提案されます。

.. Underscore Prefix for Non-external Functions and Variables

非外部関数および変数のためのアンダースコア接頭辞
================================================

* ``_singleLeadingUnderscore``

.. This convention is suggested for non-external functions and state variables (``private`` or ``internal``). State variables without a specified visibility are ``internal`` by default.

この規約は、外部関数と状態変数（ ``private`` または ``internal`` ）以外では推奨されています。
ビジビリティの指定がない状態変数は、デフォルトで ``internal`` となります。

.. When designing a smart contract, the public-facing API (functions that can be called by any account) is an important consideration.
.. Leading underscores allow you to immediately recognize the intent of such functions, but more importantly, if you change a function from non-external to external (including ``public``) and rename it accordingly, this forces you to review every call site while renaming.
.. This can be an important manual check against unintended external functions and a common source of security vulnerabilities (avoid find-replace-all tooling for this change).

スマートコントラクトを設計する際、public-facing API（どのアカウントからも呼び出せる関数）は重要な検討事項です。
アンダースコアを付けると、そのような関数の意図をすぐに認識できますが、より重要なのは、関数を非外部から外部（ ``public`` を含む）に変更し、それに応じて名前を変更すると、名前を変更する際にすべての呼び出しサイトを確認しなければならない点です。
これは、意図しない外部関数に対する重要な手動チェックであり、セキュリティ脆弱性の一般的な原因でもあります（この変更のためのfind-replace-allツールは避けてください）。

.. _style_guide_natspec:

*******
NatSpec
*******

.. Solidity contracts can also contain NatSpec comments.
.. They are written with a triple slash (``///``) or a double asterisk block (``/** ... */``) and they should be used directly above function declarations or statements.

Solidityのコントラクトには、NatSpecコメントを含めることができます。
コメントはトリプルスラッシュ（ ``///`` ）またはダブルアスタリスクブロック（ ``/** ... */`` ）で記述し、関数宣言や文の直上で使用する必要があります。

.. For example, the contract from :ref:`a simple smart contract <simple-smart-contract>` with the comments added looks like the one below:

例えば、 :ref:`シンプルなスマートコントラクト <simple-smart-contract>` のコントラクトにコメントを加えたものは、次のようになります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    /// @author The Solidity Team
    /// @title A simple storage example
    contract SimpleStorage {
        uint storedData;

        /// Store `x`.
        /// @param x the new value to store
        /// @dev stores the number in the state variable `storedData`
        function set(uint x) public {
            storedData = x;
        }

        /// Return the stored value.
        /// @dev retrieves the value of the state variable `storedData`
        /// @return the stored value
        function get() public view returns (uint) {
            return storedData;
        }
    }

.. It is recommended that Solidity contracts are fully annotated using :ref:`NatSpec <natspec>` for all public interfaces (everything in the ABI).

Solidityのコントラクトは、すべてのパブリックインターフェース（ABIのすべて）に対して :ref:`NatSpec <natspec>` を使って完全にアノテーションすることを推奨します。

.. Please see the section about :ref:`NatSpec <natspec>` for a detailed explanation.

詳しい説明は :ref:`NatSpec <natspec>` の項を参照してください。
