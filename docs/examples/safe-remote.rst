.. index:: purchase, remote purchase, escrow

******************
安全なリモート購入
******************

<<<<<<< HEAD
現在、遠隔地で商品を購入するには、複数の当事者がお互いに信頼し合う必要があります。
最もシンプルなのは、売り手と買い手の関係です。
買い手は売り手から商品を受け取り、売り手はその見返りとして金銭（またはそれに相当するもの）を得たいと考えます。
問題となるのは、ここでの発送です。
商品が買い手に届いたかどうかを確実に判断する方法がありません。

この問題を解決するには複数の方法がありますが、いずれも1つまたは他の方法で不足しています。
次の例では、両当事者がアイテムの2倍の価値をエスクローとして コントラクトに入れなければなりません。
これが起こるとすぐに、買い手がアイテムを受け取ったことを確認するまで、お金はコントラクトの中にロックされたままになります。
その後、買い手にはvalue（デポジットの半分）が返却され、売り手にはvalueの3倍（デポジット + value）が支払われます。
これは、双方が事態を解決しようとするインセンティブを持ち、そうしないとお金が永遠にロックされてしまうという考えに基づいています。
=======
Purchasing goods remotely currently requires multiple parties that need to trust each other.
The simplest configuration involves a seller and a buyer. The buyer would like to receive
an item from the seller and the seller would like to get some compensation, e.g. Ether,
in return. The problematic part is the shipment here: There is no way to determine for
sure that the item arrived at the buyer.

There are multiple ways to solve this problem, but all fall short in one or the other way.
In the following example, both parties have to put twice the value of the item into the
contract as escrow. As soon as this happened, the Ether will stay locked inside
the contract until the buyer confirms that they received the item. After that,
the buyer is returned the value (half of their deposit) and the seller gets three
times the value (their deposit plus the value). The idea behind
this is that both parties have an incentive to resolve the situation or otherwise
their Ether is locked forever.

This contract of course does not solve the problem, but gives an overview of how
you can use state machine-like constructs inside a contract.
>>>>>>> english/develop

このコントラクトはもちろん問題を解決するものではありませんが、コントラクトの中でステートマシンのような構造をどのように使用できるかの概要を示しています。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;
    contract Purchase {
        uint public value;
        address payable public seller;
        address payable public buyer;

        enum State { Created, Locked, Release, Inactive }
        // state変数のデフォルト値は、最初のメンバーである`State.created`です。
        State public state;

        modifier condition(bool condition_) {
            require(condition_);
            _;
        }

        /// 買い手だけがこの機能を呼び出すことができます。
        error OnlyBuyer();
        /// 売り手だけがこの機能を呼び出すことができます。
        error OnlySeller();
        /// 現在の状態では、この関数を呼び出すことはできません。
        error InvalidState();
        /// 提供される値は偶数でなければなりません。
        error ValueNotEven();

        modifier onlyBuyer() {
            if (msg.sender != buyer)
                revert OnlyBuyer();
            _;
        }

        modifier onlySeller() {
            if (msg.sender != seller)
                revert OnlySeller();
            _;
        }

        modifier inState(State state_) {
            if (state != state_)
                revert InvalidState();
            _;
        }

        event Aborted();
        event PurchaseConfirmed();
        event ItemReceived();
        event SellerRefunded();

        // `msg.value` が偶数であることを確認します。
        // 割り算は奇数だと切り捨てられます。
        // 奇数でなかったことを乗算で確認します。
        constructor() payable {
            seller = payable(msg.sender);
            value = msg.value / 2;
            if ((2 * value) != msg.value)
                revert ValueNotEven();
        }

        /// 購入を中止し、Etherを再クレームします。
        /// コントラクトがロックされる前に売り手によってのみ呼び出すことができます。
        function abort()
            external
            onlySeller
            inState(State.Created)
        {
            emit Aborted();
            state = State.Inactive;
            // ここではtransferを直接使っています。
            // この関数の最後の呼び出しであり、すでに状態を変更しているため、reentrancy-safeになっています。
            seller.transfer(address(this).balance);
        }

        /// 買い手として購入を確認します。
        /// 取引には `2 * value` のEtherが含まれていなければなりません。
        /// Etherは confirmReceived が呼ばれるまでロックされます。
        function confirmPurchase()
            external
            inState(State.Created)
            condition(msg.value == (2 * value))
            payable
        {
            emit PurchaseConfirmed();
            buyer = payable(msg.sender);
            state = State.Locked;
        }

        /// あなた（買い手）が商品を受け取ったことを確認します。
        /// これにより、ロックされていたEtherが解除されます。
        function confirmReceived()
            external
            onlyBuyer
            inState(State.Locked)
        {
            emit ItemReceived();
            // 最初に状態を変更することが重要です。
            // そうしないと、以下の `send` を使用して呼び出されたコントラクトが、ここで再び呼び出される可能性があるからです。
            state = State.Release;

            buyer.transfer(value);
        }

        /// この機能は、売り手に返金する、つまり売り手のロックされた資金を払い戻すものです。
        function refundSeller()
            external
            onlySeller
            inState(State.Release)
        {
            emit SellerRefunded();
            // otherwise, the contracts called using `send` below
            // can call in again here.
            // 最初に状態を変更することが重要です。
            // そうしないと、以下の `send` を使用して呼び出されたコントラクトが、ここで再び呼び出される可能性があるからです。
            state = State.Inactive;

            seller.transfer(3 * value);
        }
    }

