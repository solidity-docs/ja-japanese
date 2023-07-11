############
式と制御構造
############

.. index:: ! parameter, parameter;input, parameter;output, function parameter, parameter;function, return variable, variable;return, return

.. index:: if, else, while, do/while, for, break, continue, return, switch, goto

制御構造
========

カーリーブレース言語で知られている制御構造のほとんどがSolidityで利用可能です。

``if`` 、 ``else`` 、 ``while`` 、 ``do`` 、 ``for`` 、 ``break`` 、 ``continue`` 、 ``return`` 、また、CやJavaScriptで知られている通常のセマンティクスがあります。

Solidityは、 ``try``/``catch`` 文の形での例外処理もサポートしていますが、 :ref:`外部関数呼び出し<external-function-calls>` とコントラクト作成の呼び出しにのみ対応しています。
エラーは :ref:`リバート文<revert-statement>` を使って作成できます。

条件式では括弧を省略できませんが、単一の文であれば中括弧を省略できます。

なお、CやJavaScriptのように、非ブール型からブール型への型変換はありませんので、 ``if (1) { ... }`` はSolidityとしては有効では *ありません*。

.. index:: ! function;call, function;internal, function;external

.. _function-calls:

関数呼び出し
============

.. _internal-function-calls:

内部関数呼び出し
----------------

コントラクトの関数はそのコントラクト内の関数を、直接（「内部的に」）、再帰的に呼び出すことができます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.22 <0.9.0;

    // これは警告を通知します。
    contract C {
        function g(uint a) public pure returns (uint ret) { return a + f(); }
        function f() internal pure returns (uint ret) { return g(7) + f(); }
    }

これらの関数呼び出しは、EVM内部で単純なジャンプに変換されます。
これは、現在のメモリがクリアされないという効果があります。
つまり、内部で呼び出された関数にメモリ参照を渡すことは非常に効率的です。
同じコントラクトインスタンスの関数のみが内部で呼び出されます。

すべての内部関数呼び出しは少なくとも1つのスタックスロットを使用し、利用可能なスロットは1024個しかないため、過度な再帰は避けるべきです。

.. _external-function-calls:

外部関数呼び出し
----------------

関数呼び出しには、 ``this.g(8);`` と ``c.g(2);`` の記法を使うこともできます。
``c`` はコントラクトのインスタンス、 ``g`` は ``c`` に属する関数です。
いずれかの方法で関数 ``g`` を呼び出すと、ジャンプを介して直接呼び出されるのではなく、メッセージコールを使用して「外部から」呼び出されることになります。
``this`` の関数呼び出しはコンストラクタでは使用できないことに注意してください。
実際のコントラクトはまだ作成されていないためです。

他のコントラクトの関数は、外部から呼び出す必要があります。
外部呼び出しの際には、すべての関数の引数をメモリにコピーする必要があります。

.. note::

    あるコントラクトから別のコントラクトへの関数呼び出しは、独自のトランザクションを作成するものではなく、全体のトランザクションの一部としてのメッセージ呼び出しです。

他のコントラクトの関数を呼び出す場合、特別なオプション ``{value: 10, gas: 10000}`` で呼び出しとともに送られるweiまたはガスの量を指定できます。
なお、ガスの値を明示的に指定することは推奨されません。
オペコードのガスコストは将来変更される可能性があるからです。
コントラクトに送ったWeiは、そのコントラクトの総残高に追加されます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.2 <0.9.0;

    contract InfoFeed {
        function info() public payable returns (uint ret) { return 42; }
    }

    contract Consumer {
        InfoFeed feed;
        function setFeed(InfoFeed addr) public { feed = addr; }
        function callFeed() public { feed.info{value: 10, gas: 800}(); }
    }

``info`` 関数にモディファイア ``payable`` を使用する必要があります。
そうしないと、 ``value`` オプションは使用できません。

.. .. warning::

..   Be careful that ``feed.info{value: 10, gas: 800}`` only locally sets the
..   ``value`` and amount of ``gas`` sent with the function call, and the
..   parentheses at the end perform the actual call. So
..   ``feed.info{value: 10, gas: 800}`` does not call the function and
..   the ``value`` and ``gas`` settings are lost, only
..   ``feed.info{value: 10, gas: 800}()`` performs the function call.

.. warning::

  注意すべきなのは、 ``feed.info{value: 10, gas: 800}`` は関数呼び出しで ``value`` と送信される ``gas`` の量をローカルに設定しているだけで、最後の括弧内は実際の呼び出しを実行しているということです。
  そのため、 ``feed.info{value: 10, gas: 800}`` は関数をコールして ``value`` と ``gas`` の設定が失われることはなく、 ``feed.info{value: 10, gas: 800}()`` のみが関数呼び出しを実行します。

.. Due to the fact that the EVM considers a call to a non-existing contract to
.. always succeed, Solidity uses the ``extcodesize`` opcode to check that
.. the contract that is about to be called actually exists (it contains code)
.. and causes an exception if it does not. This check is skipped if the return
.. data will be decoded after the call and thus the ABI decoder will catch the
.. case of a non-existing contract.

EVMでは、存在しないコントラクトへの呼び出しは常に成功すると考えられているため、Solidityは ``extcodesize`` オペコードを使用して、呼び出されようとしているコントラクトが実際に存在する（コードが含まれている）かどうかをチェックし、存在しない場合は例外を発生させます。
このチェックは、呼び出し後にリターンデータがデコードされる場合にはスキップされ、存在しないコントラクトのケースをABIデコーダがキャッチします。

なお、コントラクトインスタンスではなく、アドレスを操作する :ref:`低レベル呼び出し<address_related>` の場合は、このチェックは行われません。

.. .. note::

..     Be careful when using high-level calls to
..     :ref:`precompiled contracts <precompiledContracts>`,
..     since the compiler considers them non-existing according to the
..     above logic even though they execute code and can return data.

.. note::

    :ref:`プリコンパイル済みコントラクト<precompiledContracts>` のハイレベルな呼び出しを使用する際には、コードを実行してデータを返すことができるにもかかわらず、コンパイラは上記の論理に従ってそれらを存在しないものとみなすため、注意が必要です。

また、関数呼び出しは、呼び出されたコントラクト自身が例外を投げたり、ガス欠になったりした場合にも例外を発生させます。

.. .. warning::

..     Any interaction with another contract imposes a potential danger, especially
..     if the source code of the contract is not known in advance. The
..     current contract hands over control to the called contract and that may potentially
..     do just about anything. Even if the called contract inherits from a known parent contract,
..     the inheriting contract is only required to have a correct interface. The
..     implementation of the contract, however, can be completely arbitrary and thus,
..     pose a danger. In addition, be prepared in case it calls into other contracts of
..     your system or even back into the calling contract before the first
..     call returns. This means
..     that the called contract can change state variables of the calling contract
..     via its functions. Write your functions in a way that, for example, calls to
..     external functions happen after any changes to state variables in your contract
..     so your contract is not vulnerable to a reentrancy exploit.

.. warning::

    他のコントラクトとの相互作用は、特にコントラクトのソースコードが事前にわからない場合、潜在的な危険をもたらします。
    現在のコントラクトは呼び出されたコントラクトに制御を渡し、そのコントラクトはあらゆることを行う可能性があります。
    呼び出されたコントラクトが既知の親コントラクトを継承している場合でも、継承しているコントラクトは正しいインターフェースを持っていることだけが要求されます。
    しかし、コントラクトの実装は完全に恣意的なものになる可能性があり、危険を伴います。
    さらに、システムの他のコントラクトを呼び出したり、最初の呼び出しが戻る前に呼び出し元のコントラクトに戻ったりする場合にも備えてください。
    つまり、呼び出されたコントラクトは、その関数を介して呼び出したコントラクトの状態変数を変更できるということです。
    コントラクトがre-entrancyエクスプロイトに対して脆弱でないように、例えば外部関数への呼び出しがコントラクト内の状態変数の変更後に行われるように、関数を記述してください。

.. note::

    Solidity 0.6.2以前は、valueとgasを指定する方法として、 ``f.value(x).gas(g)()`` を使用することが推奨されていました。
    これはSolidity 0.6.2で非推奨となり、Solidity 0.7.0からはできなくなりました。

.. Function Calls with Named Parameters

名前付きパラメータを使った関数呼び出し
--------------------------------------

関数呼び出しの引数は、次の例のように ``{ }`` で囲まれていれば、任意の順序で名前を与えることができます。
引数リストは、関数宣言のパラメータリストと名前が一致していなければなりませんが、任意の順序にできます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract C {
        mapping(uint => uint) data;

        function f() public {
            set({value: 2, key: 3});
        }

        function set(uint key, uint value) public {
            data[key] = value;
        }
    }

.. Omitted Names in Function Definitions

関数定義での名前の省略
----------------------

.. The names of parameters and return values in the function declaration can be omitted.
.. Those items with omitted names will still be present on the stack, but they are inaccessible by name.
..  An omitted return value name can still return a value to the caller by use of the ``return`` statement.

関数宣言のパラメータや戻り値の名前は省略できます。
名前が省略された項目はスタック上に存在しますが、名前からアクセスすることはできません。
省略された戻り値名は、 ``return`` 文を使用することで、呼び出し元に値を返すことは可能です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.22 <0.9.0;

    contract C {
        // 省略されたパラメータ名
        function func(uint k, uint) public pure returns(uint) {
            return k;
        }
    }

.. index:: ! new, contracts;creating

.. _creating-contracts:

``new`` を使ったコントラクト作成
================================

コントラクトは、 ``new`` キーワードを使って他のコントラクトを作成できます。
作成されるコントラクトの完全なコードは、作成するコントラクトがコンパイルされるときに知られていなければならないので、再帰的な作成依存は不可能です。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    contract D {
        uint public x;
        constructor(uint a) payable {
            x = a;
        }
    }

    contract C {
        D d = new D(4); // C のコンストラクタの一部として実行されます。

        function createD(uint arg) public {
            D newD = new D(arg);
            newD.x();
        }

        function createAndEndowD(uint arg, uint amount) public payable {
            // 作成と一緒にEtherを送る
            D newD = new D{value: amount}(arg);
            newD.x();
        }
    }

例に見られるように、 ``value`` オプションを使用して ``D`` のインスタンスを作成中にEtherを送信することは可能ですが、ガスの量を制限できません。
作成に失敗した場合（スタック不足、残高不足、その他の問題）、例外が発生します。

ソルトされたコントラクト作成 / create2
--------------------------------------

コントラクトを作成する際、コントラクトのアドレスは、作成するコントラクトのアドレスと、コントラクトを作成するたびに増加するカウンタから計算されます。

オプションの ``salt`` （bytes32の値）を指定した場合、コントラクトの作成では、別のメカニズムで新しいコントラクトのアドレスを計算します。

作成したコントラクトのアドレス、与えられたソルト値、作成したコントラクトの（作成）バイトコード、コンストラクタの引数からアドレスを計算します。

特に、カウンター（"nonce"）は使用されません。
これにより、コントラクトをより柔軟に作成できます。
新しいコントラクトが作成される前に、そのアドレスを導き出すことができます。
さらに、コントラクトを作成している間に他のコントラクトを作成した場合にも、このアドレスに依存できます。

.. The main use-case here is contracts that act as judges for off-chain interactions,
.. which only need to be created if there is a dispute.

ここでの主なユースケースは、オフチェーンでのやりとりの判断材料となるコントラクトで、紛争が発生した場合にのみ作成する必要があります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    contract D {
        uint public x;
        constructor(uint a) {
            x = a;
        }
    }

    contract C {
        function createDSalted(bytes32 salt, uint arg) public {
            // この複雑な式は、アドレスがどのように事前計算されるかを示しているに過ぎません。
            // これは説明のために存在するだけです。
            // 実際には ``new D{salt: salt}(arg)`` だけが必要です。
            address predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(abi.encodePacked(
                    type(D).creationCode,
                    abi.encode(arg)
                ))
            )))));

            D d = new D{salt: salt}(arg);
            require(address(d) == predictedAddress);
        }
    }

.. .. warning::

..     There are some peculiarities in relation to salted creation. A contract can be
..     re-created at the same address after having been destroyed. Yet, it is possible
..     for that newly created contract to have a different deployed bytecode even
..     though the creation bytecode has been the same (which is a requirement because
..     otherwise the address would change). This is due to the fact that the constructor
..     can query external state that might have changed between the two creations
..     and incorporate that into the deployed bytecode before it is stored.

.. warning::

    ソルトされた作成に関しては、いくつかの特殊性があります。
    コントラクトは破壊された後、同じアドレスで再作成できます。
    しかし、新しく作成されたコントラクトは、作成時のバイトコードが同じであっても、デプロイ時のバイトコードが異なる可能性があります（そうしないとアドレスが変わってしまうため、これは必須条件です）。
    これは、コンストラクタが2つの作成の間に変更された可能性のある外部状態を照会し、それを格納する前にデプロイされたバイトコードに組み込むことができるという事実によるものです。

式の評価順序
============

.. The evaluation order of expressions is not specified (more formally, the order
.. in which the children of one node in the expression tree are evaluated is not
.. specified, but they are of course evaluated before the node itself). It is only
.. guaranteed that statements are executed in order and short-circuiting for
.. boolean expressions is done.

式の評価順序は指定されていません（より正式には、式ツリーのあるノードの子が評価される順序は指定されていませんが、もちろんそのノード自身よりも先に評価されます）。
文が順番に実行されることが保証されているだけであり、ブーリアン式の短絡は行われます。

.. index:: ! assignment

代入
====

.. index:: ! assignment;destructuring

.. Destructuring Assignments and Returning Multiple Values

代入のデストラクティングと複数の値のリターン
--------------------------------------------

Solidityは内部的にタプル型を許可しています。
つまり、潜在的に異なる型のオブジェクトのリストで、その数はコンパイル時に一定となります。
これらのタプルは、同時に複数の値を返すために使用できます。
これらの値は、新たに宣言された変数や既存の変数（または一般的なLValue）に代入できます。

タプルはSolidityでは適切な型ではなく、式の構文的なグループ化をするためにのみ使用されます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.5.0 <0.9.0;

    contract C {
        uint index;

        function f() public pure returns (uint, bool, uint) {
            return (7, true, 2);
        }

        function g() public {
            // 型付きで宣言され、返されたタプルから代入される変数は、すべての要素を指定する必要はありません（ただし、数は一致しなければなりません）。
            (uint x, , uint y) = f();
            // 値をスワップする一般的なトリック -- 値を持たないストレージ型では機能しません。
            (x, y) = (y, x);
            // コンポーネントは省略可能です（変数宣言の場合も同様）。
            (index, , ) = f(); // indexを7に設定
        }
    }

変数の宣言と非宣言の代入を混在させることはできません。
つまり、次のようなものは有効ではありません。
``(x, uint y) = (1, 2);``

.. .. note::

..     Prior to version 0.5.0 it was possible to assign to tuples of smaller size, either filling up on the left or on the right side (which ever was empty).
..     This is now disallowed, so both sides have to have the same number of components.

.. note::

    バージョン0.5.0以前では、より小さなサイズのタプルに、左側または右側（どちらかが空の場合）を埋めるように割り当てることができました。
    これは現在では禁止されており、両側とも同じ数のコンポーネントを持たなければなりません。

.. .. warning::

..     Be careful when assigning to multiple variables at the same time when
..     reference types are involved, because it could lead to unexpected
..     copying behaviour.

.. warning::
<<<<<<< HEAD
=======
    Be careful when assigning to multiple variables at the same time when
    reference types are involved, because it could lead to unexpected
    copying behavior.
>>>>>>> english/develop

    参照型が含まれる場合に複数の変数に同時に代入すると、予期しないコピー動作になることがあるので注意が必要です。

<<<<<<< HEAD
配列と構造体の複雑さ
--------------------
=======
The semantics of assignments are more complicated for non-value types like arrays and structs,
including ``bytes`` and ``string``, see :ref:`Data location and assignment behavior <data-location-assignment>` for details.
>>>>>>> english/develop

代入のセマンティクスは、 ``bytes`` や ``string`` などの配列や構造体などの非値型ではより複雑になりますが。
詳細は :ref:`データロケーションと代入の動作<data-location-assignment>` を参照してください。

以下の例では、 ``g(x)`` の呼び出しは、メモリ内にストレージの値の独立したコピーを作成するため、 ``x`` に影響を与えません。
しかし、 ``h(x)`` はコピーではなく参照のみが渡されるため、 ``x`` の変更に成功しています。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.22 <0.9.0;

    contract C {
        uint[20] x;

        function f() public {
            g(x);
            h(x);
        }

        function g(uint[20] memory y) internal pure {
            y[2] = 3;
        }

        function h(uint[20] storage y) internal {
            y[3] = 4;
        }
    }

.. index:: ! scoping, declarations, default value

.. _default-value:

スコーピングと宣言
==================

宣言された変数は、バイト表現がすべてゼロである初期のデフォルト値を持ちます。
変数の「デフォルト値」は、その型が何であれ、典型的な「ゼロ状態」です。
例えば、 ``bool`` のデフォルト値は ``false`` です。
``uint`` 型や ``int`` 型のデフォルト値は ``0`` です。
静的なサイズの配列や ``bytes1`` から ``bytes32`` では、個々の要素はその型に対応するデフォルト値に初期化されます。
動的なサイズの配列や ``bytes`` と ``string`` では、デフォルト値は空の配列または文字列です。
``enum`` 型では、初期値はその最初のメンバーです。

.. Scoping in Solidity follows the widespread scoping rules of C99
.. (and many other languages): Variables are visible from the point right after their declaration
.. until the end of the smallest ``{ }``-block that contains the declaration.
.. As an exception to this rule, variables declared in the
.. initialization part of a for-loop are only visible until the end of the for-loop.

Solidityのスコーピングは、C99（および他の多くの言語）で広く採用されているスコーピングルールに従っています。
変数は、その宣言の直後から、その宣言を含む最小の ``{ }`` ブロックの終わりまで見ることができます。
この規則の例外として、for-loopの初期化部分で宣言された変数は、for-loopの終わりまでしか見えません。

.. Variables that are parameter-like (function parameters, modifier parameters,
.. catch parameters, ...) are visible inside the code block that follows -
.. the body of the function/modifier for a function and modifier parameter and the catch block
.. for a catch parameter.

パラメータのような変数（関数パラメータ、モディファイアパラメータ、キャッチパラメータなど）は、次のコードブロックの中に表示されます。
関数パラメータとモディファイアパラメータの場合は関数/モディファイアのボディ、キャッチパラメータの場合はキャッチブロックです。

.. Variables and other items declared outside of a code block, for example functions, contracts,
.. user-defined types, etc., are visible even before they were declared. This means you can
.. use state variables before they are declared and call functions recursively.

コードブロックの外で宣言された変数やその他のアイテム（例えば、関数、コントラクト、ユーザー定義型など）は、宣言される前から見ることができます。
つまり、宣言される前の状態の変数を使用したり、関数を再帰的に呼び出したりできます。

その結果、以下の例では、2つの変数は同じ名前ですが、スコープが異なっているため、警告を出さずにコンパイルできます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.5.0 <0.9.0;
    contract C {
        function minimalScoping() pure public {
            {
                uint same;
                same = 1;
            }

            {
                uint same;
                same = 3;
            }
        }
    }

.. As a special example of the C99 scoping rules, note that in the following,
.. the first assignment to ``x`` will actually assign the outer and not the inner variable.
.. In any case, you will get a warning about the outer variable being shadowed.

C99のスコープルールの特別な例として、以下では、 ``x`` への最初の代入が実際には内側の変数ではなく外側の変数を代入することに注意してください。
いずれにしても、外側の変数がシャドーイングされているという警告が表示されます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.5.0 <0.9.0;
    // これは警告を報告します
    contract C {
        function f() pure public returns (uint) {
            uint x = 1;
            {
                x = 2; // これは外側の変数に代入されます
                uint x;
            }
            return x; // xは2になります
        }
    }

.. warning::

    バージョン0.5.0以前のSolidityは、JavaScriptと同じスコープルールに従っていました。
    つまり、関数内の任意の場所で宣言された変数は、どこで宣言されたかに関わらず、関数全体のスコープになります。
    次の例は、バージョン0.5.0以降、コンパイル時にエラーが発生するコードスニペットです。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.5.0 <0.9.0;
    // これはコンパイルできません
    contract C {
        function f() pure public returns (uint) {
            x = 2;
            uint x;
            return x;
        }
    }

.. index:: ! safe math, safemath, checked, unchecked
.. _unchecked:

算術演算のチェックをするかしないか
==================================

オーバーフローまたはアンダーフローとは、制限のない整数に対して算術演算を実行したときに、結果の値が結果の型の範囲外になってしまうことです。

.. Prior to Solidity 0.8.0, arithmetic operations would always wrap in case of
.. under- or overflow leading to widespread use of libraries that introduce
.. additional checks.

Solidity 0.8.0以前では、アンダーフローやオーバーフローが発生した場合、算術演算は常にラップするため、追加のチェックを導入するライブラリが広く使用されていました。

<<<<<<< HEAD
.. Since Solidity 0.8.0, all arithmetic operations revert on over- and underflow by default,
.. thus making the use of these libraries unnecessary.

Solidity 0.8.0以降、すべての算術演算はデフォルトでオーバーフローとアンダーフローでリバートするため、これらのライブラリを使用する必要はありません。

以前のような動作を得るためには、 ``unchecked`` ブロックを使用できます。
=======
To obtain the previous behavior, an ``unchecked`` block can be used:
>>>>>>> english/develop

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.0;
    contract C {
        function f(uint a, uint b) pure public returns (uint) {
            // この引き算はアンダーフローでラップされます
            unchecked { return a - b; }
        }
        function g(uint a, uint b) pure public returns (uint) {
            // この引き算はアンダーフローでリバートされます
            return a - b;
        }
    }

``f(2, 3)`` を呼び出すと ``2**256-1`` が返され、 ``g(2, 3)`` を呼び出すとアサーションに失敗することになります。

``unchecked`` ブロックは、ブロックの中であればどこでも使えますが、ブロックの代わりにはなりません。
また、入れ子にすることもできません。

.. The setting only affects the statements that are syntactically inside the block.
.. Functions called from within an ``unchecked`` block do not inherit the property.

この設定は、構文的にブロックの内部にある文にのみ影響します。
``unchecked`` ブロック内から呼び出された関数は、このプロパティを継承しません。

.. note::

    曖昧さを避けるため、 ``unchecked`` ブロック内で ``_;`` を使用できません。

.. The following operators will cause a failing assertion on overflow or underflow
.. and will wrap without an error if used inside an unchecked block:

以下の演算子は、オーバーフローまたはアンダーフロー時にアサーションの失敗を引き起こし、チェックされていないブロック内で使用された場合はエラーなしでラップされます。

``++``, ``--``, ``+``, 二項 ``-``, 単項 ``-``, ``*``, ``/``, ``%``, ``**``

``+=``, ``-=``, ``*=``, ``/=``, ``%=``

.. warning::

    ``unchecked`` ブロックを使ってもゼロ除算やゼロによる剰余のチェックは無効にできません。

.. .. note::

..    Bitwise operators do not perform overflow or underflow checks.
..    This is particularly visible when using bitwise shifts (``<<``, ``>>``, ``<<=``, ``>>=``) in
..    place of integer division and multiplication by a power of 2.
..    For example ``type(uint256).max << 3`` does not revert even though ``type(uint256).max * 8`` would.

.. note::

    ビット演算子はオーバーフローやアンダーフローのチェックを行いません。
    これは、整数の除算や2の累乗の代わりにビット単位のシフト（ ``<<`` 、 ``>>`` 、 ``<<=`` 、 ``>>=`` ）を使用する場合に特に顕著です。

.. note::

    ``int x = type(int).min; -x;`` の2つ目の文は、負の範囲が正の範囲よりも1つ多くの値を保持できるため、オーバーフローになります。

明示的な型変換は常に切り捨てられ、整数型からenum型への変換を除いて、アサーションの失敗は発生しません。

.. index:: ! exception, ! throw, ! assert, ! require, ! revert, ! errors

.. _assert-and-require:

.. Error handling: Assert, Require, Revert and Exceptions

エラーハンドリング: Assert, Require, Revert, Exception
======================================================

.. Solidity uses state-reverting exceptions to handle errors.
.. Such an exception undoes all changes made to the state in the current call (and all its sub-calls) and flags an error to the caller.

Solidityでは、エラーの処理にステートをリバートする例外を使用します。
このような例外は、現在の呼び出し（およびそのすべてのサブコール）で行われた状態への変更をすべてリバートし、呼び出し側にエラーを通知します。

.. When exceptions happen in a sub-call, they "bubble up" (i.e.,
.. exceptions are rethrown) automatically unless they are caught in
.. a ``try/catch`` statement. Exceptions to this rule are ``send``
.. and the low-level functions ``call``, ``delegatecall`` and
.. ``staticcall``: they return ``false`` as their first return value in case
.. of an exception instead of "bubbling up".

サブコールで例外が発生した場合、 ``try/catch`` 文で捕捉されない限り、自動的に「バブルアップ」（例外が再スローされる）します。
このルールの例外は、 ``send`` と低レベル関数の ``call`` 、 ``delegatecall`` 、 ``staticcall`` です。
これらの関数は、例外が発生した場合、「バブルアップ」するのではなく、 ``false`` を最初の戻り値として返します。

.. .. warning::

..     The low-level functions ``call``, ``delegatecall`` and
..     ``staticcall`` return ``true`` as their first return value
..     if the account called is non-existent, as part of the design
..     of the EVM. Account existence must be checked prior to calling if needed.

.. warning::

    低レベル関数の ``call`` 、 ``delegatecall`` 、 ``staticcall`` は、EVMの設計の一環として、呼び出されたアカウントが存在しない場合、最初の戻り値として ``true`` を返します。
    必要に応じて、呼び出す前にアカウントの存在を確認する必要があります。

.. Exceptions can contain error data that is passed back to the caller
.. in the form of :ref:`error instances <errors>`.
.. The built-in errors ``Error(string)`` and ``Panic(uint256)`` are
.. used by special functions, as explained below. ``Error`` is used for "regular" error conditions
.. while ``Panic`` is used for errors that should not be present in bug-free code.

例外にはエラーデータを含めることができ、 :ref:`error instances <errors>` の形で呼び出し側に戻されます。
組み込みエラーの ``Error(string)`` と ``Panic(uint256)`` は、以下に説明するように特別な関数で使用されます。
``Error`` は「通常の」エラー状態に使用され、 ``Panic`` はバグのないコードでは存在してはならないエラーに使用されます。

``assert`` を介したパニックと ``require`` を介したエラー
--------------------------------------------------------

コンビニエンス関数である ``assert`` と ``require`` は、条件をチェックし、条件を満たさない場合は例外を投げることができます。

``assert`` 関数では、 ``Panic(uint256)`` 型のエラーが発生します。
以下のような特定の状況では、コンパイラによって同じエラーが発生します。

.. Assert should only be used to test for internal
.. errors, and to check invariants. Properly functioning code should
.. never create a Panic, not even on invalid external input.
.. If this happens, then there
.. is a bug in your contract which you should fix. Language analysis
.. tools can evaluate your contract to identify the conditions and
.. function calls which will cause a Panic.

Assertは、内部エラーのテストや不変性のチェックにのみ使用します。
適切に機能しているコードは、外部からの不正な入力に対してもパニックを起こさないはずです。
もしそうなってしまったら、コントラクトにバグがあるので修正する必要があります。
言語解析ツールは コントラクトを評価し、パニックを引き起こす条件や関数呼び出しを特定します。

.. A Panic exception is generated in the following situations.
.. The error code supplied with the error data indicates the kind of panic.

パニック例外は次のような場合に発生します。
エラーデータとともに提供されるエラーコードは、パニックの種類を示します。

.. #. 0x00: Used for generic compiler inserted panics.
.. #. 0x01: If you call ``assert`` with an argument that evaluates to false.
.. #. 0x11: If an arithmetic operation results in underflow or overflow outside of an ``unchecked { ... }`` block.
.. #. 0x12; If you divide or modulo by zero (e.g. ``5 / 0`` or ``23 % 0``).
.. #. 0x21: If you convert a value that is too big or negative into an enum type.
.. #. 0x22: If you access a storage byte array that is incorrectly encoded.
.. #. 0x31: If you call ``.pop()`` on an empty array.
.. #. 0x32: If you access an array, ``bytesN`` or an array slice at an out-of-bounds or negative index (i.e. ``x[i]`` where ``i >= x.length`` or ``i < 0``).
.. #. 0x41: If you allocate too much memory or create an array that is too large.
.. #. 0x51: If you call a zero-initialized variable of internal function type.

#. 0x00: 一般的なコンパイラの挿入されたパニックに使用されます。

#. 0x01: falseと評価される引数で ``assert`` を呼び出した場合。

#. 0x11:  ``unchecked { ... }`` ブロックの外で、演算結果がアンダーフローまたはオーバーフローになった場合。

#. 0x12; 0で除算や剰余をした場合（例:  ``5 / 0`` や ``23 % 0`` ）。

#. 0x21: 大きすぎる値や負の値を列挙型に変換した場合。

#. 0x22: 正しくエンコードされていないストレージのバイト配列にアクセスした場合。

#. 0x31: 空の配列で ``.pop()`` を呼び出した場合。

#. 0x32: 境界外または負のインデックス（ ``x[i]`` 、 ``i >= x.length`` 、 ``i < 0`` など）で配列、 ``bytesN`` 、または配列スライスにアクセスした場合。

#. 0x41: メモリの割り当てが多すぎたり、大きすぎる配列を作成した場合。

#. 0x51: 内部関数型のゼロ初期化変数を呼び出した場合。

.. The ``require`` function either creates an error without any data or
.. an error of type ``Error(string)``. It
.. should be used to ensure valid conditions
.. that cannot be detected until execution time.
.. This includes conditions on inputs
.. or return values from calls to external contracts.

``require`` 関数は、データのないエラーを作成するか、 ``Error(string)`` 型のエラーを作成します。
``require`` 関数は、実行時まで検出できない有効な条件を保証するために使用する必要があります。
これには、入力に対する条件や、外部コントラクトへの呼び出しからの戻り値が含まれます。

.. note::

    現在、 ``require`` との組み合わせでカスタムエラーを使用できません。
    代わりに ``if (!condition) revert CustomError();`` を仕様してください。

``Error(string)`` 例外（またはデータのない例外）は、以下のような場合にコンパイラによって生成されます。

.. #. Calling ``require(x)`` where ``x`` evaluates to ``false``.
.. #. If you use ``revert()`` or ``revert("description")``.
.. #. If you perform an external function call targeting a contract that contains no code.
.. #. If your contract receives Ether via a public function without
..    ``payable`` modifier (including the constructor and the fallback function).
.. #. If your contract receives Ether via a public getter function.

<<<<<<< HEAD
#. ``x`` が ``false`` に評価されるとき ``require(x)`` を呼び出す。
=======
For the following cases, the error data from the external call
(if provided) is forwarded. This means that it can either cause
an ``Error`` or a ``Panic`` (or whatever else was given):
>>>>>>> english/develop

#. ``revert()`` や ``revert("description")`` を使う場合。

#. コードを含まないコントラクトを対象とした外部関数呼び出しを行った場合。

#. ``payable`` モディファイアのないパブリック関数（コンストラクタ、フォールバック関数を含む）を介してコントラクトがEtherを受け取る場合。

#. コントラクトがパブリックゲッター関数でEtherを受け取る場合。

.. For the following cases, the error data from the external call
.. (if provided) is forwarded. This means that it can either cause
.. an `Error` or a `Panic` (or whatever else was given):

以下のケースでは、外部の呼び出しからのエラーデータ（提供されている場合）が送金されます。
これは、 `Error` または `Panic` （またはその他の何かが与えられた場合）を引き起こす可能性があることを意味します。

.. #. If a ``.transfer()`` fails.
.. #. If you call a function via a message call but it does not finish
..    properly (i.e., it runs out of gas, has no matching function, or
..    throws an exception itself), except when a low level operation
..    ``call``, ``send``, ``delegatecall``, ``callcode`` or ``staticcall``
..    is used. The low level operations never throw exceptions but
..    indicate failures by returning ``false``.
.. #. If you create a contract using the ``new`` keyword but the contract
..    creation :ref:`does not finish properly<creating-contracts>`.

#. ``.transfer()`` が失敗した場合。

#. メッセージコールで関数を呼び出したが、正しく終了しなかった場合（ガス欠、一致する関数がない、自分自身で例外をスローするなど）。
   低レベルの操作 ``call`` 、 ``send`` 、 ``delegatecall`` 、 ``callcode`` 、 ``staticcall`` を使用した場合を除きます。
   低レベルの操作は、例外を投げることはありませんが、 ``false`` を返すことで失敗を示します。

#. ``new`` キーワードを使ってコントラクトを作成しても、コントラクトの作成が :ref:`正しく終了しない場合<creating-contracts>` 。

``require`` にはオプションでメッセージ文字列を指定できますが、 ``assert`` には指定できません。

.. note::

    ``require`` に文字列の引数を与えない場合、エラーセレクタを含めずに空のエラーデータでリバートします。

次の例では、 ``require`` で入力の状態を確認し、 ``assert`` で内部のエラーチェックを行うことができます。

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.5.0 <0.9.0;

    contract Sharer {
        function sendHalf(address payable addr) public payable returns (uint balance) {
            require(msg.value % 2 == 0, "Even value required.");
            uint balanceBeforeTransfer = address(this).balance;
            addr.transfer(msg.value / 2);
<<<<<<< HEAD
            // transferに失敗すると例外がスローされ、ここにコールバックすることはできないので、半分のお金を送金せず保持する方法はないはずです。
=======
            // Since transfer throws an exception on failure and
            // cannot call back here, there should be no way for us to
            // still have half of the Ether.
>>>>>>> english/develop
            assert(address(this).balance == balanceBeforeTransfer - msg.value / 2);
            return address(this).balance;
        }
    }

.. Internally, Solidity performs a revert operation (instruction ``0xfd``).
.. This causes the EVM to revert all changes made to the state.
.. The reason for reverting is that there is no safe way to continue execution, because an expected effect did not occur.
.. Because we want to keep the atomicity of transactions, the safest action is to revert all changes and make the whole transaction (or at least call) without effect.

内部的には、Solidityはリバートする操作（命令 ``0xfd`` ）を行います。
これにより、EVMは状態に加えられたすべての変更をリバートします。
リバートする理由は、期待した効果が発生しなかったために、実行を継続する安全な方法がない場合です。
トランザクションのアトミック性を維持したいので、最も安全なアクションはすべての変更をリバートし、トランザクション全体（または少なくともコール）を効果なしにすることです。

.. In both cases, the caller can react on such failures using ``try``/``catch``, but
.. the changes in the callee will always be reverted.

どちらの場合も、呼び出し側はそのような失敗に対して ``try`` / ``catch`` を使って反応できますが、呼び出された側の変更は必ずリバートされます。

.. note::

    パニック例外は、Solidity 0.8.0以前は ``invalid``  オペコードを使用していましたが、これは呼び出しに使用可能なすべてのガスを消費していました。
    ``require`` を使用する例外は、Metropolisリリースの前まではすべてのガスを消費していました。

.. _revert-statement:

``revert``
----------

リバートは、 ``revert`` 文と ``revert`` 関数を使って直接トリガーできます。

.. The ``revert`` statement takes a custom error as direct argument without parentheses:

..     revert CustomError(arg1, arg2);

``revert`` 文では、カスタムエラーを括弧なしの直接引数として受け取ります。

    revert CustomError(arg1, arg2);

<<<<<<< HEAD
.. For backwards-compatibility reasons, there is also the ``revert()`` function, which uses parentheses
.. and accepts a string:

後方互換性を考慮して、括弧を使用して文字列を受け取る ``revert()`` 関数もあります。
=======
For backward-compatibility reasons, there is also the ``revert()`` function, which uses parentheses
and accepts a string:
>>>>>>> english/develop

    revert();
    revert("description");

.. The error data will be passed back to the caller and can be caught there.
.. Using ``revert()`` causes a revert without any error data while ``revert("description")`` will create an ``Error(string)`` error.

エラーデータは呼び出し側に戻されるので、そこでキャッチできます。
``revert()`` を使うとエラーデータなしでリバートしますが、 ``revert("description")`` を使うと ``Error(string)`` エラーが発生します。

.. Using a custom error instance will usually be much cheaper than a string description,
.. because you can use the name of the error to describe it, which is encoded in only
.. four bytes. A longer description can be supplied via NatSpec which does not incur
.. any costs.

カスタムエラーのインスタンスを使用すると、通常、文字列による説明よりもはるかに安価になります。
これは、わずか4バイトでエンコードされるエラーの名前を使用して説明できるからです。
より長い記述はNatSpecを介して提供できますが、これには一切のコストがかかりません。

.. The following example shows how to use an error string and a custom error instance
.. together with ``revert`` and the equivalent ``require``:

次の例では、エラー文字列とカスタムエラーインスタンスを、 ``revert`` と同等の ``require`` と一緒に使用しています。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;

    contract VendingMachine {
        address owner;
        error Unauthorized();
        function buy(uint amount) public payable {
            if (amount > msg.value / 2 ether)
                revert("Not enough Ether provided.");
            // 別の方法:
            require(
                amount <= msg.value / 2 ether,
                "Not enough Ether provided."
            );
            // 購入を実行する
        }
        function withdraw() public {
            if (msg.sender != owner)
                revert Unauthorized();

            payable(msg.sender).transfer(address(this).balance);
        }
    }

``if (!condition) revert(...);`` と ``require(condition, ...);`` の2つの方法は、 ``revert`` と ``require`` への引数が副作用を持たない限り、例えば単なる文字列であれば、等価です。

.. note::

    ``require`` 関数は、他の関数と同様に評価されます。
    これは、関数自体が実行される前に、すべての引数が評価されることを意味します。
    特に ``require(condition, f())`` では、 ``condition`` が真であっても関数 ``f`` が実行されます。

.. The provided string is :ref:`abi-encoded <ABI>` as if it were a call to a function ``Error(string)``.
.. In the above example, ``revert("Not enough Ether provided.");`` returns the following hexadecimal as error return data:

提供された文字列は、あたかも関数 ``Error(string)`` の呼び出しであるかのように :ref:`ABIエンコード<ABI>` されます。
上記の例では、 ``revert("Not enough Ether provided.");`` はエラーの返り値として次の16進数を返します。

.. code::

    0x08c379a0                                                         // Error(string)の関数セレクタ
    0x0000000000000000000000000000000000000000000000000000000000000020 // データオフセット
    0x000000000000000000000000000000000000000000000000000000000000001a // 文字列の長さ
    0x4e6f7420656e6f7567682045746865722070726f76696465642e000000000000 // 文字列データ

与えたメッセージは、以下のように ``try`` / ``catch`` を使って呼び出し側が取り出すことができます。

.. note::

    かつて、 ``revert()`` と同じ意味を持つ ``throw`` というキーワードがありましたが、バージョン0.4.13で非推奨となり、バージョン0.5.0で削除されました。

.. _try-catch:

``try``/``catch``
-----------------

外部呼び出しの失敗は、以下のようにtry/catch文を使ってキャッチできます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.8.1;

    interface DataFeed { function getData(address token) external returns (uint value); }

    contract FeedConsumer {
        DataFeed feed;
        uint errorCount;
        function rate(address token) public returns (uint value, bool success) {
            // 10個以上のエラーが発生した場合、この機構を永久に無効にします。
            require(errorCount < 10);
            try feed.getData(token) returns (uint v) {
                return (v, true);
            } catch Error(string memory /*reason*/) {
                // これは、getDataの内部でrevertが呼び出され、文字列reasonが提供された場合に実行されます。
                errorCount++;
                return (0, false);
            } catch Panic(uint /*errorCode*/) {
                // これはパニック、すなわちゼロによる除算やオーバーフローのような重大なエラーが発生した場合に実行されます。
                // エラーコードからエラーの種類を判断できます。
                errorCount++;
                return (0, false);
            } catch (bytes memory /*lowLevelData*/) {
                // revert()が使用された場合に実行されます。
                errorCount++;
                return (0, false);
            }
        }
    }

.. The ``try`` keyword has to be followed by an expression representing an external function call or a contract creation (``new ContractName()``).
.. Errors inside the expression are not caught (for example if it is a complex expression that also involves internal function calls), only a revert happening inside the external call itself.
.. The ``returns`` part (which is optional) that follows declares return variables matching the types returned by the external call.
.. In case there was no error, these variables are assigned and the contract's execution continues inside the first success block.
.. If the end of the success block is reached, execution continues after the ``catch`` blocks.

``try`` キーワードの後には、外部関数呼び出しやコントラクトの作成（ ``new ContractName()`` ）を表す式が続く必要があります。
式の内部のエラーは捕捉されず（例えば、内部の関数呼び出しを含む複雑な式の場合）、外部呼び出し自体の内部で起こるリバートのみが捕捉されます。
続く ``returns`` 部（オプション）では、外部呼び出しが返す型に一致するリターン変数を宣言します。
エラーがなかった場合、これらの変数が代入され、コントラクトの実行は最初の成功ブロック内で継続されます。
成功ブロックの終わりに達した場合は、 ``catch`` ブロックの後に実行が続きます。

.. Solidity supports different kinds of catch blocks depending on the
.. type of error:
.. - ``catch Error(string memory reason) { ... }``: This catch clause is executed if the error was caused by ``revert("reasonString")`` or
..   ``require(false, "reasonString")`` (or an internal error that causes such an
..   exception).
.. - ``catch Panic(uint errorCode) { ... }``: If the error was caused by a panic, i.e. by a failing ``assert``, division by zero,
..   invalid array access, arithmetic overflow and others, this catch clause will be run.
.. - ``catch (bytes memory lowLevelData) { ... }``: This clause is executed if the error signature
..   does not match any other clause, if there was an error while decoding the error
..   message, or
..   if no error data was provided with the exception.
..   The declared variable provides access to the low-level error data in that case.
.. - ``catch { ... }``: If you are not interested in the error data, you can just use
..   ``catch { ... }`` (even as the only catch clause) instead of the previous clause.

Solidityでは、エラーの種類に応じて様々な種類のキャッチブロックをサポートしています。

- ``catch Error(string memory reason) { ... }``: このキャッチ句は、エラーの原因が ``revert("reasonString")`` または ``require(false, "reasonString")`` （またはこのような例外を引き起こす内部エラー）であった場合に実行されます。

- ``catch Panic(uint errorCode) { ... }``: エラーがパニックによって引き起こされた場合、つまり、 ``assert`` の失敗、ゼロによる除算、無効な配列アクセス、算術オーバーフローなどによって引き起こされた場合、このキャッチ句が実行されます。

- ``catch (bytes memory lowLevelData) { ... }``: この句は、エラーのシグネチャが他の句と一致しない場合、エラーメッセージのデコード中にエラーが発生した場合、または例外でエラーデータが提供されなかった場合に実行されます。
  宣言された変数は、その場合の低レベルのエラーデータへのアクセスを提供します。

- ``catch { ... }``: エラーデータに興味がないのであれば、前の句の代わりに ``catch { ... }`` を（唯一のcatch句としても）使用すればよいでしょう。

.. It is planned to support other types of error data in the future.
.. The strings ``Error`` and ``Panic`` are currently parsed as is and are not treated as identifiers.

将来は、他の型のエラーデータにも対応する予定です。
文字列 ``Error`` と ``Panic`` は、現在、そのまま解析され、識別子としては扱われません。

.. In order to catch all error cases, you have to have at least the clause
.. ``catch { ...}`` or the clause ``catch (bytes memory lowLevelData) { ... }``.

すべてのエラーケースをキャッチするためには、少なくとも ``catch { ...}`` 句または ``catch (bytes memory lowLevelData) { ... }`` 句が必要です。

.. The variables declared in the ``returns`` and the ``catch`` clause are only
.. in scope in the block that follows.

``returns`` 句と ``catch`` 句で宣言された変数は、それに続くブロックでのみスコープに入ります。

.. .. note::

..     If an error happens during the decoding of the return data
..     inside a try/catch-statement, this causes an exception in the currently
..     executing contract and because of that, it is not caught in the catch clause.
..     If there is an error during decoding of ``catch Error(string memory reason)``
..     and there is a low-level catch clause, this error is caught there.

.. note::

    try/catch文の中でリターンデータのデコード中にエラーが発生した場合、現在実行中のコントラクトで例外が発生し、そのためcatch句ではキャッチされません。
    ``catch Error(string memory reason)`` のデコード中にエラーが発生し、低レベルのcatch句がある場合は、このエラーはそこでキャッチされます。

.. .. note::

..     If execution reaches a catch-block, then the state-changing effects of the external call have been reverted.
..     If execution reaches the success block, the effects were not reverted.
..     If the effects have been reverted, then execution either continues in a catch block or the execution of the try/catch statement itself reverts (for example due to decoding failures as noted above or due to not providing a low-level catch clause).

.. note::

    実行がキャッチブロックに到達した場合、外部呼び出しの状態変化の影響はリバートされています。
    実行が成功ブロックに到達した場合、その効果はリバートされていません。
    効果がリバートした場合、実行はcatchブロック内で継続されるか、try/catch文の実行自体がリバートします（例えば、上述のようなデコードの失敗や、低レベルのcatch句を提供していないことが原因です）。

.. .. note::

..     The reason behind a failed call can be manifold. Do not assume that
..     the error message is coming directly from the called contract:
..     The error might have happened deeper down in the call chain and the
..     called contract just forwarded it. Also, it could be due to an
..     out-of-gas situation and not a deliberate error condition:
..     The caller always retains at least 1/64th of the gas in a call and thus even if the called contract goes out of gas, the caller still has some gas left.

.. note::

    失敗したコールの原因はさまざまです。
    エラーメッセージが呼び出されたコントラクトから直接来ていると思わないでください。
    エラーはコールチェーンのより深いところで発生し、呼び出されたコントラクトがそれをフォワードしただけかもしれません。
    また、意図的なエラー状態ではなく、ガス欠状態が原因である可能性もあります。
    コール側は常に1/64以上のガスを保持しているため、コールされたコントラクトがガス欠になっても、コール側にはガスが残っています。
