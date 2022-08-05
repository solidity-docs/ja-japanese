.. index:: ! inheritance, ! base class, ! contract;base, ! deriving

***********
継承
***********

Solidityは、ポリモーフィズムを含む多重継承をサポートしています。

.. Polymorphism means that a function call (internal and external)
.. always executes the function of the same name (and parameter types)
.. in the most derived contract in the inheritance hierarchy.
.. This has to be explicitly enabled on each function in the
.. hierarchy using the ``virtual`` and ``override`` keywords.
.. See :ref:`Function Overriding <function-overriding>` for more details.

ポリモーフィズムとは、関数の呼び出し（内部および外部）が、継承階層の中で最も派生したコントラクト内の同名の関数（およびパラメータ型）を常に実行することを意味します。
この機能は、 ``virtual`` キーワードと ``override`` キーワードを使って、階層内の各関数で明示的に有効にする必要があります。
詳細は :ref:`関数オーバーライド <function-overriding>` を参照してください。

.. It is possible to call functions further up in the inheritance
.. hierarchy internally by explicitly specifying the contract
.. using ``ContractName.functionName()`` or using ``super.functionName()``
.. if you want to call the function one level higher up in
.. the flattened inheritance hierarchy (see below).

``ContractName.functionName()`` を使ってコントラクトを明示的に指定したり、フラット化された継承階層の1つ上のレベルの関数を呼び出したい場合は ``super.functionName()`` を使うことで、継承階層のさらに上のレベルの関数を内部で呼び出すことができます（以下参照）。

.. When a contract inherits from other contracts, only a single
.. contract is created on the blockchain, and the code from all the base contracts
.. is compiled into the created contract. This means that all internal calls
.. to functions of base contracts also just use internal function calls
.. (``super.f(..)`` will use JUMP and not a message call).

コントラクトが他のコントラクトを継承する場合、ブロックチェーン上には1つのコントラクトのみが作成され、作成されたコントラクトにはすべてのベースコントラクトのコードがコンパイルされます。
つまり、ベースコントラクトの関数に対する内部呼び出しも、すべて内部関数呼び出しを使用するだけです（ ``super.f(..)`` はJUMPを使用し、メッセージ呼び出しではありません）。

.. State variable shadowing is considered as an error.  A derived contract can
.. only declare a state variable ``x``, if there is no visible state variable
.. with the same name in any of its bases.

状態変数のシャドーイングはエラーとみなされます。
派生コントラクトは、そのベースのいずれかに同名の可視ステート変数が存在しない場合にのみ、ステート変数 ``x`` を宣言できます。

.. The general inheritance system is very similar to
.. `Python's <https://docs.python.org/3/tutorial/classes.html#inheritance>`_,
.. especially concerning multiple inheritance, but there are also
.. some :ref:`differences <multi-inheritance>`.

一般的な継承システムは `Pythonのもの <https://docs.python.org/3/tutorial/classes.html#inheritance>`_ と非常に似ていますが、複数の継承に関しては、 :ref:`異なる点 <multi-inheritance>` もあります。

詳細は以下の例を参照してください。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;

    contract Owned {
        constructor() { owner = payable(msg.sender); }
        address payable owner;
    }

    // 他のコントラクトから派生させるには、`is`を使用します。
    // 派生したコントラクトは、内部関数や状態変数を含む、プライベートでないすべてのメンバにアクセスすることができます。
    // しかし、これらは `this` を介して外部からアクセスすることはできません。
    contract Destructible is Owned {
        // キーワード `virtual` は、その関数が派生クラスでその振る舞いを変更できる (「オーバーライド」) ことを意味します。
        function destroy() virtual public {
            if (msg.sender == owner) selfdestruct(owner);
        }
    }

    // これらの抽象コントラクトは、コンパイラにインターフェイスを知らせるためにのみ提供されています。
    // ボディを持たない関数に注意してください。
    // コントラクトがすべての関数を実装していない場合、インターフェースとしてのみ使用することができます。
    abstract contract Config {
        function lookup(uint id) public virtual returns (address adr);
    }

    abstract contract NameReg {
        function register(bytes32 name) public virtual;
        function unregister() public virtual;
    }

    // 多重継承が可能です。
    // `owned` は `Destructible` のベースクラスでもあるが、 `owned` のインスタンスは一つしかないことに注意（C++ の仮想継承と同じ）。
    contract Named is Owned, Destructible {
        constructor(bytes32 name) {
            Config config = Config(0xD5f9D8D94886E70b06E474c3fB14Fd43E2f23970);
            NameReg(config.lookup(1)).register(name);
        }

        // 関数は、同じ名前、同じ入力の数/型の別の関数によってオーバーライドできます。
        // オーバーライドされた関数が異なる型の出力パラメータを持っている場合、それはエラーの原因となります。
        // ローカル関数とメッセージベースの関数呼び出しの両方が、これらのオーバーライドを考慮に入れています。
        // 関数をオーバーライドしたい場合は、`override` キーワードを使用する必要があります。
        // また、この関数を再びオーバーライドしたい場合は、`virtual`キーワードを指定する必要があります。
        function destroy() public virtual override {
            if (msg.sender == owner) {
                Config config = Config(0xD5f9D8D94886E70b06E474c3fB14Fd43E2f23970);
                NameReg(config.lookup(1)).unregister();
                // 特定のオーバーライドされた関数を呼び出すことは可能です。
                Destructible.destroy();
            }
        }
    }

    // コンストラクタが引数を取る場合、派生コントラクトのコンストラクタでヘッダまたは修飾子を呼び出すスタイルで提供する必要があります(下記参照)。
    contract PriceFeed is Owned, Destructible, Named("GoldFeed") {
        function updateInfo(uint newInfo) public {
            if (msg.sender == owner) info = newInfo;
        }

        // ここでは、 `override` のみを指定し、 `virtual` は指定しない。
        // これは、 `PriceFeed` から派生したコントラクトは、もう `destroy` の挙動を変更できないことを意味します。
        function destroy() public override(Destructible, Named) { Named.destroy(); }
        function get() public view returns(uint r) { return info; }

        uint info;
    }

.. Note that above, we call ``Destructible.destroy()`` to "forward" the
.. destruction request. The way this is done is problematic, as
.. seen in the following example:

上記では、破壊要求を「送金」するために ``Destructible.destroy()`` を呼び出していることに注意してください。
この方法は、次の例に見られるように、問題があります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;

    contract owned {
        constructor() { owner = payable(msg.sender); }
        address payable owner;
    }

    contract Destructible is owned {
        function destroy() public virtual {
            if (msg.sender == owner) selfdestruct(owner);
        }
    }

    contract Base1 is Destructible {
        function destroy() public virtual override { /* cleanup 1 */ Destructible.destroy(); }
    }

    contract Base2 is Destructible {
        function destroy() public virtual override { /* cleanup 2 */ Destructible.destroy(); }
    }

    contract Final is Base1, Base2 {
        function destroy() public override(Base1, Base2) { Base2.destroy(); }
    }

.. A call to ``Final.destroy()`` will call ``Base2.destroy`` because we specify it
.. explicitly in the final override, but this function will bypass
.. ``Base1.destroy``. The way around this is to use ``super``:

``Final.destroy()`` への呼び出しは、最終的なオーバーライドで明示的に指定しているので ``Base2.destroy`` を呼び出しますが、この関数は ``Base1.destroy`` をバイパスします。
これを回避する方法は、 ``super`` を使うことです。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;

    contract owned {
        constructor() { owner = payable(msg.sender); }
        address payable owner;
    }

    contract Destructible is owned {
        function destroy() virtual public {
            if (msg.sender == owner) selfdestruct(owner);
        }
    }

    contract Base1 is Destructible {
        function destroy() public virtual override { /* cleanup 1 */ super.destroy(); }
    }

    contract Base2 is Destructible {
        function destroy() public virtual override { /* cleanup 2 */ super.destroy(); }
    }

    contract Final is Base1, Base2 {
        function destroy() public override(Base1, Base2) { super.destroy(); }
    }

.. If ``Base2`` calls a function of ``super``, it does not simply
.. call this function on one of its base contracts.  Rather, it
.. calls this function on the next base contract in the final
.. inheritance graph, so it will call ``Base1.destroy()`` (note that
.. the final inheritance sequence is -- starting with the most
.. derived contract: Final, Base2, Base1, Destructible, owned).
.. The actual function that is called when using super is
.. not known in the context of the class where it is used,
.. although its type is known. This is similar for ordinary
.. virtual method lookup.

``Base2`` が ``super`` の関数を呼び出す場合、単純にそのベースコントラクトの1つでこの関数を呼び出すのではない。
むしろ、最終的な継承グラフの次のベースコントラクトでこの関数を呼び出すので、 ``Base1.destroy()`` を呼び出すことになります（最終的な継承順序は--最も派生したコントラクトから始まることに注意してください: Final、Base2、Base1、Destructible、owned）。
superを使うときに呼び出される実際の関数は、型はわかっていても、使われるクラスのコンテキストではわかりません。
これは通常の仮想メソッドの検索でも同様です。

.. index:: ! overriding;function

.. _function-overriding:

関数オーバーライド
===================

.. The overriding function may only change the visibility of the overridden function from ``external`` to ``public``.
.. The mutability may be changed to a more strict one following the order:
.. ``nonpayable`` can be overridden by ``view`` and ``pure``. ``view`` can be overridden by ``pure``.
.. ``payable`` is an exception and cannot be changed to any other mutability.

ベース関数は、コントラクトを継承することでオーバーライドでき、 ``virtual`` としてマークされている場合は、その動作を変更できます。
オーバーライドされた関数は、関数ヘッダーで ``override`` キーワードを使用しなければなりません。
オーバーライドされた関数は、オーバーライドされた関数の可視性を ``external`` から ``public`` に変更するだけです。
ミュータビリティは、順序に従って、より厳密なものに変更できます。
``nonpayable`` は ``view`` と ``pure`` でオーバーライドでき、 ``view`` は ``pure`` でオーバーライドできます。
``payable`` は例外で、他のミュータビリティに変更できません。

次の例では、mutabilityとvisibilityの変更を行っています。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;

    contract Base
    {
        function foo() virtual external view {}
    }

    contract Middle is Base {}

    contract Inherited is Middle
    {
        function foo() override public pure {}
    }

.. For multiple inheritance, the most derived base contracts that define the same
.. function must be specified explicitly after the ``override`` keyword.
.. In other words, you have to specify all base contracts that define the same function
.. and have not yet been overridden by another base contract (on some path through the inheritance graph).
.. Additionally, if a contract inherits the same function from multiple (unrelated)
.. bases, it has to explicitly override it:

多重継承では、同じ関数を定義する最も派生したベースコントラクトを、 ``override`` キーワードの後に明示的に指定する必要があります。
言い換えれば、同じ関数を定義し、まだ別のベースコントラクトによってオーバーライドされていないすべてのベースコントラクトを指定しなければなりません（継承グラフのあるパス上で）。
さらに、コントラクトが複数の（関連性のない）ベースから同じ関数を継承する場合は、明示的にオーバーライドしなければなりません。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    contract Base1
    {
        function foo() virtual public {}
    }

    contract Base2
    {
        function foo() virtual public {}
    }

    contract Inherited is Base1, Base2
    {
        // foo()を定義している複数のベースから派生しているので、明示的にオーバーライドする必要があります。
        function foo() public override(Base1, Base2) {}
    }

.. An explicit override specifier is not required if
.. the function is defined in a common base contract
.. or if there is a unique function in a common base contract
.. that already overrides all other functions.

関数が共通のベースコントラクトで定義されている場合や、共通のベースコントラクトに他のすべての関数をすでにオーバーライドする固有の関数がある場合は、明示的なオーバーライド指定子は必要ありません。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    contract A { function f() public pure{} }
    contract B is A {}
    contract C is A {}
    // 明示的なオーバーライドは必要ありません
    contract D is B, C {}

.. More formally, it is not required to override a function (directly or
.. indirectly) inherited from multiple bases if there is a base contract
.. that is part of all override paths for the signature, and (1) that
.. base implements the function and no paths from the current contract
.. to the base mentions a function with that signature or (2) that base
.. does not implement the function and there is at most one mention of
.. the function in all paths from the current contract to that base.

より正式には、シグネチャのすべてのオーバーライドパスの一部であるベースコントラクトがあり、(1)そのベースが関数を実装しており、現在のコントラクトからベースへのパスでそのシグネチャを持つ関数に言及しているものがないか、(2)そのベースが関数を実装しておらず、現在のコントラクトからベースへのすべてのパスで関数に言及しているものが多くても1つである場合、複数のベースから継承された関数をオーバーライドする必要はありません。

.. In this sense, an override path for a signature is a path through
.. the inheritance graph that starts at the contract under consideration
.. and ends at a contract mentioning a function with that signature
.. that does not override.

この意味で、シグネチャのオーバーライドパスとは、対象となるコントラクトから始まり、オーバーライドしないそのシグネチャを持つ関数に言及しているコントラクトで終わる、継承グラフを通るパスのことです。

.. If you do not mark a function that overrides as ``virtual``, derived
.. contracts can no longer change the behaviour of that function.

オーバーライドする関数を ``virtual`` としてマークしていない場合、派生コントラクトはもはやその関数の動作を変更できません。

.. note::

  ``private`` の可視性を持つ関数は ``virtual`` にできません。

.. .. note::

..   Functions without implementation have to be marked ``virtual``
..   outside of interfaces. In interfaces, all functions are
..   automatically considered ``virtual``.

.. note::

    実装のない関数は、インターフェイスの外では ``virtual`` とマークされなければなりません。
    インターフェースでは、すべての関数は自動的に ``virtual`` とみなされます。

.. .. note::

..   Starting from Solidity 0.8.8, the ``override`` keyword is not
..   required when overriding an interface function, except for the
..   case where the function is defined in multiple bases.

.. note::

    Solidity 0.8.8からは、複数のベースで定義されている場合を除き、インターフェース関数をオーバーライドする際に ``override`` キーワードは必要ありません。

パブリックな状態変数は、関数のパラメータと戻り値の型が変数のゲッター関数と一致する場合、外部関数をオーバーライドできます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    contract A
    {
        function f() external view virtual returns(uint) { return 5; }
    }

    contract B is A
    {
        uint public override f;
    }

.. .. note::

..   While public state variables can override external functions, they themselves cannot
..   be overridden.

.. note::

    パブリックな状態変数は、外部関数をオーバーライドできますが、それ自体をオーバーライドできません。

.. index:: ! overriding;modifier

.. _modifier-overriding:

修飾子オーバーライド
=======================

.. Function modifiers can override each other. This works in the same way as
.. :ref:`function overriding <function-overriding>` (except that there is no overloading for modifiers). The
.. ``virtual`` keyword must be used on the overridden modifier
.. and the ``override`` keyword must be used in the overriding modifier:

関数の修飾子はお互いにオーバーライドできます。
これは、 :ref:`関数オーバーライド <function-overriding>` と同じように動作します（修飾子にオーバーロードがないことを除く）。
``virtual`` キーワードはオーバーライドする修飾子に使用し、 ``override`` キーワードはオーバーライドする修飾子に使用しなければなりません。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    contract Base
    {
        modifier foo() virtual {_;}
    }

    contract Inherited is Base
    {
        modifier foo() override {_;}
    }

.. In case of multiple inheritance, all direct base contracts must be specified
.. explicitly:

多重継承の場合は、すべての直接のベースコントラクトを明示的に指定する必要があります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.6.0 <0.9.0;

    contract Base1
    {
        modifier foo() virtual {_;}
    }

    contract Base2
    {
        modifier foo() virtual {_;}
    }

    contract Inherited is Base1, Base2
    {
        modifier foo() override(Base1, Base2) {_;}
    }

.. index:: ! constructor

.. _constructor:

コンストラクタ
=================

コンストラクタは、 ``constructor`` キーワードで宣言されたオプションの関数で、コントラクトの作成時に実行され、コントラクトの初期化コードを実行できます。

.. Before the constructor code is executed, state variables are initialised to
.. their specified value if you initialise them inline, or their :ref:`default value<default-value>` if you do not.

コンストラクタのコードが実行される前に、ステート変数は、インラインで初期化した場合は指定した値に、初期化しなかった場合は :ref:`デフォルト値 <default-value>` に初期化されます。

.. After the constructor has run, the final code of the contract is deployed
.. to the blockchain. The deployment of
.. the code costs additional gas linear to the length of the code.
.. This code includes all functions that are part of the public interface
.. and all functions that are reachable from there through function calls.
.. It does not include the constructor code or internal functions that are
.. only called from the constructor.

コンストラクタの実行後、コントラクトの最終コードがブロックチェーンにデプロイされます。
コードのデプロイには、コードの長さに応じた追加のガスがかかります。
このコードには、パブリックインターフェースの一部であるすべての関数と、そこから関数呼び出しによって到達可能なすべての関数が含まれます。
コンストラクタのコードや、コンストラクタからしか呼び出されない内部関数は含まれません。

.. If there is no
.. constructor, the contract will assume the default constructor, which is
.. equivalent to ``constructor() {}``. For example:

コンストラクタがない場合、コントラクトはデフォルトコンストラクタを想定しますが、これは ``constructor() {}`` と同等です。例えば、以下のようになります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;

    abstract contract A {
        uint public a;

        constructor(uint _a) {
            a = _a;
        }
    }

    contract B is A(1) {
        constructor() {}
    }

.. You can use internal parameters in a constructor (for example storage pointers). In this case,
.. the contract has to be marked :ref:`abstract <abstract-contract>`, because these parameters
.. cannot be assigned valid values from outside but only through the constructors of derived contracts.

コンストラクタで内部パラメータを使用できます（たとえば、ストレージポインタなど）。
この場合、コントラクトは :ref:`abstract <abstract-contract>` マークを付けなければなりません。
なぜなら、これらのパラメータは外部から有効な値を割り当てることができず、派生コントラクトのコンストラクタを通してのみ有効だからです。

.. warning ::
    バージョン0.4.22より前のバージョンでは、コンストラクタはコントラクトと同じ名前の関数として定義されていました。
    この構文は非推奨で、バージョン0.5.0ではもう認められていません。

.. warning ::
    バージョン0.7.0より前のバージョンでは、コンストラクタの可視性を ``internal`` または ``public`` のいずれかに指定する必要がありました。

.. index:: ! base;constructor

ベースコンストラクタの引数
===============================

.. The constructors of all the base contracts will be called following the
.. linearization rules explained below. If the base constructors have arguments,
.. derived contracts need to specify all of them. This can be done in two ways:

すべてのベースコントラクトのコンストラクタは、以下に説明する線形化規則に従って呼び出されます。
ベースコントラクトのコンストラクタに引数がある場合、派生コントラクトはそのすべてを指定する必要があります。
これは2つの方法で行うことができます。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;

    contract Base {
        uint x;
        constructor(uint _x) { x = _x; }
    }

    // 継承リストに直接指定するか...
    contract Derived1 is Base(7) {
        constructor() {}
    }

    // または派生コンストラクタの"修飾子"を介して行われます。
    contract Derived2 is Base {
        constructor(uint _y) Base(_y * _y) {}
    }

.. One way is directly in the inheritance list (``is Base(7)``).  The other is in
.. the way a modifier is invoked as part of
.. the derived constructor (``Base(_y * _y)``). The first way to
.. do it is more convenient if the constructor argument is a
.. constant and defines the behaviour of the contract or
.. describes it. The second way has to be used if the
.. constructor arguments of the base depend on those of the
.. derived contract. Arguments have to be given either in the
.. inheritance list or in modifier-style in the derived constructor.
.. Specifying arguments in both places is an error.

1つの方法は、継承リストに直接記載する方法です（ ``is Base(7)`` ）。
もう1つは、派生したコンストラクタの一部として修飾子を呼び出す方法です（ ``Base(_y * _y)`` ）。
コンストラクタの引数が定数で、コントラクトの動作を定義したり、記述したりする場合は、最初の方法が便利です。
ベースのコンストラクタの引数が派生コントラクトの引数に依存する場合は、2 番目の方法を使用する必要があります。
引数は、継承リストで指定するか、派生するコンストラクタの修飾子スタイルで指定する必要があります。両方の場所で引数を指定するとエラーになります。

.. If a derived contract does not specify the arguments to all of its base
.. contracts' constructors, it will be abstract.

派生コントラクトがそのベースコントラクトのコンストラクタのすべてに引数を指定していない場合、それは抽象的なものとなります。

.. index:: ! inheritance;multiple, ! linearization, ! C3 linearization

.. _multi-inheritance:

多重継承とリニアライゼーション
======================================

.. Languages that allow multiple inheritance have to deal with
.. several problems.  One is the `Diamond Problem <https://en.wikipedia.org/wiki/Multiple_inheritance#The_diamond_problem>`_.
.. Solidity is similar to Python in that it uses "`C3 Linearization <https://en.wikipedia.org/wiki/C3_linearization>`_"
.. to force a specific order in the directed acyclic graph (DAG) of base classes. This
.. results in the desirable property of monotonicity but
.. disallows some inheritance graphs. Especially, the order in
.. which the base classes are given in the ``is`` directive is
.. important: You have to list the direct base contracts
.. in the order from "most base-like" to "most derived".
.. Note that this order is the reverse of the one used in Python.

多重継承が可能な言語は、いくつかの問題を抱えています。
ひとつは「 `Diamond Problem <https://en.wikipedia.org/wiki/Multiple_inheritance#The_diamond_problem>`_ 」です。
SolidityはPythonに似ていますが、ベースクラスの有向非環状グラフ（DAG）に特定の順序を強制するために「 `C3 Linearization <https://en.wikipedia.org/wiki/C3_linearization>`_ 」を使用しています。
この結果、単調性という望ましい特性が得られますが、いくつかの継承グラフが使えなくなります。
特に、 ``is`` 指令でのベースクラスの順序は重要で、「最もベースに近いもの」から「最も派生したもの」の順に直接ベースコントラクトをリストアップする必要があります。
この順序は、Pythonで使われている順序とは逆であることに注意してください。

.. Another simplifying way to explain this is that when a function is called that
.. is defined multiple times in different contracts, the given bases
.. are searched from right to left (left to right in Python) in a depth-first manner,
.. stopping at the first match. If a base contract has already been searched, it is skipped.

これを別の方法で簡単に説明すると、異なるコントラクトで複数回定義された関数が呼び出された場合、与えられたベースは右から左（Pythonでは左から右）へと深さ優先で検索され、最初にマッチしたもので停止します。
もしベースコントラクトが既に検索されていたら、その部分はスキップされます。

.. In the following code, Solidity will give the
.. error "Linearization of inheritance graph impossible".

以下のコードでは、Solidityが "Linearization of inheritance graph impossible" というエラーを出します。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.0 <0.9.0;

    contract X {}
    contract A is X {}
    // これはコンパイルできません
    contract C is A, X {}

.. The reason for this is that ``C`` requests ``X`` to override ``A``
.. (by specifying ``A, X`` in this order), but ``A`` itself
.. requests to override ``X``, which is a contradiction that
.. cannot be resolved.

その理由は、 ``C`` は ``X`` に ``A`` のオーバーライドを要求している（ ``A, X`` をこの順番で指定することで）が、 ``A`` 自身は ``X`` のオーバーライドを要求しており、解決できない矛盾を抱えているからです。

.. Due to the fact that you have to explicitly override a function
.. that is inherited from multiple bases without a unique override,
.. C3 linearization is not too important in practice.

複数のベースから継承された関数を独自にオーバーライドせずに明示的にオーバーライドする必要があるため、C3線形化は実際にはあまり重要ではありません。

.. One area where inheritance linearization is especially important and perhaps not as clear is when there are multiple constructors in the inheritance hierarchy. The constructors will always be executed in the linearized order, regardless of the order in which their arguments are provided in the inheriting contract's constructor.  For example:

継承の直線化が特に重要でありながら、あまり明確ではないのが、継承階層に複数のコンストラクタが存在する場合です。
コンストラクタは、継承するコントラクトのコンストラクタで引数が提供された順番に関係なく、常に線形化された順番で実行されます。
例えば、以下のようになります。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;

    contract Base1 {
        constructor() {}
    }

    contract Base2 {
        constructor() {}
    }

    // コンストラクターは、以下の順序で実行されます。
    //  1 - Base1
    //  2 - Base2
    //  3 - Derived1
    contract Derived1 is Base1, Base2 {
        constructor() Base1() Base2() {}
    }

    // コンストラクターは、以下の順序で実行されます。
    //  1 - Base2
    //  2 - Base1
    //  3 - Derived2
    contract Derived2 is Base2, Base1 {
        constructor() Base2() Base1() {}
    }

    // コンストラクターは、変わらず以下の順序で実行されます。
    //  1 - Base2
    //  2 - Base1
    //  3 - Derived3
    contract Derived3 is Base2, Base1 {
        constructor() Base1() Base2() {}
    }

同じ名前の異なる種類のメンバーの継承
======================================================

コントラクト内の以下のペアが継承により同じ名前になっている場合はエラーとなります。
    - 関数と修飾子
    - 関数とイベント
    - イベントと修飾子

例外として、ステート変数のゲッターが外部関数をオーバーライドできます。
