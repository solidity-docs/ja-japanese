.. index:: ! using for, library, ! operator;user-defined, function;free

.. _using-for:

*********
using for
*********

``using A for B`` ディレクティブは、コントラクトの文脈において、関数（ ``A`` ）を演算子としてユーザー定義の値型にに、あるいはメンバー関数として任意の型（ ``B`` ）にアタッチするために使用できます。
そのメンバー関数は、呼び出されたオブジェクトを最初のパラメータとして受け取ります（Pythonの ``self`` 変数のようなものです）。
演算子関数は、オペランドをパラメータとして受け取ります。

.. It is valid either at file level or inside a contract, at contract level.

ファイルレベルでも、コントラクト内でも、コントラクトレベルで有効です。

.. The first part, ``A``, can be one of:

最初の部分である ``A`` には、以下のいずれかを指定できます:

.. - A list of functions, optionally with an operator name assigned (e.g. ``using {f, g as +, h, L.t} for uint``).
..   If no operator is specified, the function can be either a library function or a free function and is attached to the type as a member function.
..   Otherwise it must be a free function and it becomes the definition of that operator on the type.
.. - The name of a library (e.g. ``using L for uint``) - all non-private functions of the library are attached to the type as member functions

- 関数のリストで、オプションで演算子名を指定できます（例: ``using {f, g as +, h, L.t} for uint`` ）。
  演算子が指定されていない場合、関数はライブラリ関数かフリー関数のどちらかになり、メンバ関数として型にアタッチされます。
  それ以外の場合は、自由関数でなければならず、型に対するその演算子の定義となります。
- ライブラリの名前（例: ``using L for uint``） - ライブラリのプライベートでない関数はすべてメンバ関数として型にアタッチされます。

.. At file level, the second part, ``B``, has to be an explicit type (without data location specifier).
.. Inside contracts, you can also use ``*`` in place of the type (e.g. ``using L for *;``), which has the effect that all functions of the library ``L`` are attached to *all* types.

ファイルレベルでは、2番目の部分である ``B`` は明示的な型でなければなりません（データロケーションの指定はありません）。
コントラクトの中では、型の代わりに ``*`` を使用することもできます（例: ``using L for *;``）。

.. If you specify a library, *all* non-private functions in the library get attached, even those where the type of the first parameter does not match the type of the object.
.. The type is checked at the point the function is called and function overload resolution is performed.

ライブラリを指定した場合、そのライブラリに含まれる *すべての* 非プライベート関数は、最初のパラメータの型がオブジェクトの型と一致しないものであっても、アタッチされます。
型は関数が呼び出された時点でチェックされ、関数のオーバーロード解消が実行されます。

.. If you use a list of functions (e.g. ``using {f, g, h, L.t} for uint``), then the type (``uint``) has to be implicitly convertible to the first parameter of each of these functions.
.. This check is performed even if none of these functions are called.
.. Note that private library functions can only be specified when ``using for`` is inside a library.

関数のリストを使用する場合（例: ``using {f, g, h, L.t} for uint`` ）、型（ ``uint`` ）はこれらの関数のそれぞれの第1パラメータに暗黙的に変換可能である必要があります。
このチェックは、これらの関数のいずれもが呼び出されない場合でも行われます。
ライブラリのプライベート関数は、 ``using for`` がライブラリ内にある場合にのみ指定できることに注意してください。

.. If you define an operator (e.g. ``using {f as +} for T``), then the type (``T``) must be a :ref:`user-defined value type <user-defined-value-types>` and the definition must be a ``pure`` function.
.. Operator definitions must be global.
.. The following operators can be defined this way:

演算子を定義する場合（例: ``using {f as +} for T`` ）、型（ ``T`` ）は :ref:`ユーザー定義の値型 <user-defined-value-types>` で、定義は ``pure`` 関数である必要があります。
演算子の定義はグローバルでなければなりません。
この方法で定義できる演算子は以下の通りです。

+------------+----------+---------------------------------------------+
| カテゴリー | 演算子   | 可能なシグネチャ                            |
+============+==========+=============================================+
| Bitwise    | ``&``    | ``function (T, T) pure returns (T)``        |
|            +----------+---------------------------------------------+
|            | ``|``    | ``function (T, T) pure returns (T)``        |
|            +----------+---------------------------------------------+
|            | ``^``    | ``function (T, T) pure returns (T)``        |
|            +----------+---------------------------------------------+
|            | ``~``    | ``function (T) pure returns (T)``           |
+------------+----------+---------------------------------------------+
| Arithmetic | ``+``    | ``function (T, T) pure returns (T)``        |
|            +----------+---------------------------------------------+
|            | ``-``    | ``function (T, T) pure returns (T)``        |
|            +          +---------------------------------------------+
|            |          | ``function (T) pure returns (T)``           |
|            +----------+---------------------------------------------+
|            | ``*``    | ``function (T, T) pure returns (T)``        |
|            +----------+---------------------------------------------+
|            | ``/``    | ``function (T, T) pure returns (T)``        |
|            +----------+---------------------------------------------+
|            | ``%``    | ``function (T, T) pure returns (T)``        |
+------------+----------+---------------------------------------------+
| Comparison | ``==``   | ``function (T, T) pure returns (bool)``     |
|            +----------+---------------------------------------------+
|            | ``!=``   | ``function (T, T) pure returns (bool)``     |
|            +----------+---------------------------------------------+
|            | ``<``    | ``function (T, T) pure returns (bool)``     |
|            +----------+---------------------------------------------+
|            | ``<=``   | ``function (T, T) pure returns (bool)``     |
|            +----------+---------------------------------------------+
|            | ``>``    | ``function (T, T) pure returns (bool)``     |
|            +----------+---------------------------------------------+
|            | ``>=``   | ``function (T, T) pure returns (bool)``     |
+------------+----------+---------------------------------------------+

.. Note that unary and binary ``-`` need separate definitions.
.. The compiler will choose the right definition based on how the operator is invoked.

単項と二項の ``-`` は別々の定義が必要であることに注意してください。
コンパイラは演算子がどのように呼び出されるかに基づいて、正しい定義を選択します。

.. The ``using A for B;`` directive is active only within the current scope (either the contract or the current module/source unit), including within all of its functions, and has no effect outside of the contract or module in which it is used.

``using A for B;`` ディレクティブは、現在のスコープ（コントラクトまたは現在のモジュール/ソースユニット）内においてのみ有効で、そのすべての関数内を含み、それが使用されているコントラクトまたはモジュール外には影響を与えません。

.. When the directive is used at file level and applied to a user-defined type which was defined at file level in the same file, the word ``global`` can be added at the end.
.. This will have the effect that the functions and operators are attached to the type everywhere the type is available (including other files), not only in the scope of the using statement.

このディレクティブがファイルレベルで使用され、同じファイル内でファイルレベルで定義されたユーザー定義型に適用される場合、最後に ``global`` という単語を追加できます。
これにより、using文の範囲だけでなく、その型が利用可能な場所（他のファイルも含む）で、関数や演算子がその型に付加されるという効果があります。

.. Let us rewrite the set example from the :ref:`libraries` section in this way, using file-level functions instead of library functions.

:ref:`libraries` セクションにある集合の例を、ライブラリ関数の代わりにファイルレベルの関数を使って、このように書き換えてみましょう。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.13;

    struct Data { mapping(uint => bool) flags; }
    // Now we attach functions to the type.
    // The attached functions can be used throughout the rest of the module.
    // If you import the module, you have to repeat the using directive there, for example as
    //   import "flags.sol" as Flags;
    //   using {Flags.insert, Flags.remove, Flags.contains}
    //     for Flags.Data;
    using {insert, remove, contains} for Data;

    function insert(Data storage self, uint value)
        returns (bool)
    {
        if (self.flags[value])
            return false; // already there
        self.flags[value] = true;
        return true;
    }

    function remove(Data storage self, uint value)
        returns (bool)
    {
        if (!self.flags[value])
            return false; // not there
        self.flags[value] = false;
        return true;
    }

    function contains(Data storage self, uint value)
        view
        returns (bool)
    {
        return self.flags[value];
    }

    contract C {
        Data knownValues;

        function register(uint value) public {
            // ここでは、Data型のすべての変数に対応するメンバ関数があります。
            // 以下の関数呼び出しは、 `Set.insert(knownValues, value)` と同じです。
            require(knownValues.insert(value));
        }
    }

また、そのようにしてビルトイン型（値型）を拡張することも可能です。
この例では、ライブラリを使用します。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.13;

    library Search {
        function indexOf(uint[] storage self, uint value)
            public
            view
            returns (uint)
        {
            for (uint i = 0; i < self.length; i++)
                if (self[i] == value) return i;
            return type(uint).max;
        }
    }
    using Search for uint[];

    contract C {
        uint[] data;

        function append(uint value) public {
            data.push(value);
        }

        function replace(uint from, uint to) public {
            // これは、ライブラリ関数呼び出しを実行します
            uint index = data.indexOf(from);
            if (index == type(uint).max)
                data.push(to);
            else
                data[index] = to;
        }
    }

.. Note that all external library calls are actual EVM function calls. This means that
.. if you pass memory or value types, a copy will be performed, even in case of the
.. ``self`` variable. The only situation where no copy will be performed
.. is when storage reference variables are used or when internal library
.. functions are called.

すべての外部ライブラリ呼び出しは、実際のEVM関数呼び出しであることに注意してください。
つまり、メモリや値の型を渡す場合は、 ``self`` 変数であってもコピーが実行されます。
コピーが行われない唯一の状況は、ストレージ参照変数が使用されている場合や、内部ライブラリ関数が呼び出されている場合です。

.. Another example shows how to define a custom operator for a user-defined type:

ユーザー定義型にカスタム演算子を定義する方法を示す別の例:

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.19;

    type UFixed16x2 is uint16;

    using {
        add as +,
        div as /
    } for UFixed16x2 global;

    uint32 constant SCALE = 100;

    function add(UFixed16x2 a, UFixed16x2 b) pure returns (UFixed16x2) {
        return UFixed16x2.wrap(UFixed16x2.unwrap(a) + UFixed16x2.unwrap(b));
    }

    function div(UFixed16x2 a, UFixed16x2 b) pure returns (UFixed16x2) {
        uint32 a32 = UFixed16x2.unwrap(a);
        uint32 b32 = UFixed16x2.unwrap(b);
        uint32 result32 = a32 * SCALE / b32;
        require(result32 <= type(uint16).max, "Divide overflow");
        return UFixed16x2.wrap(uint16(a32 * SCALE / b32));
    }

    contract Math {
        function avg(UFixed16x2 a, UFixed16x2 b) public pure returns (UFixed16x2) {
            return (a + b) / UFixed16x2.wrap(200);
        }
    }
