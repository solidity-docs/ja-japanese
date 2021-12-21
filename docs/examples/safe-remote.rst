.. index:: purchase, remote purchase, escrow

********************
Safe Remote Purchase
********************

.. Purchasing goods remotely currently requires multiple parties that need to trust each other.
.. The simplest configuration involves a seller and a buyer. The buyer would like to receive
.. an item from the seller and the seller would like to get money (or an equivalent)
.. in return. The problematic part is the shipment here: There is no way to determine for
.. sure that the item arrived at the buyer.

現在、遠隔地で商品を購入するには、複数の当事者がお互いに信頼し合う必要があります。最もシンプルなのは、売り手と買い手の関係です。買い手は売り手から商品を受け取り、売り手はその見返りとして金銭（またはそれに相当するもの）を得たいと考えます。問題となるのは、ここでの発送です。商品が買い手に届いたかどうかを確実に判断する方法がありません。

.. There are multiple ways to solve this problem, but all fall short in one or the other way.
.. In the following example, both parties have to put twice the value of the item into the
.. contract as escrow. As soon as this happened, the money will stay locked inside
.. the contract until the buyer confirms that they received the item. After that,
.. the buyer is returned the value (half of their deposit) and the seller gets three
.. times the value (their deposit plus the value). The idea behind
.. this is that both parties have an incentive to resolve the situation or otherwise
.. their money is locked forever.

この問題を解決するには複数の方法がありますが、いずれも1つまたは他の方法で不足しています。次の例では、両当事者がアイテムの2倍の価値をエスクローとして コントラクトに入れなければなりません。これが起こるとすぐに、買い手がアイテムを受け取ったことを確認するまで、お金はコントラクトの中にロックされたままになります。その後、買い手には価値（保証金の半分）が返却され、売り手には価値の3倍（保証金＋価値）が支払われます。これは、双方が事態を解決しようとするインセンティブを持ち、そうしないとお金が永遠にロックされてしまうという考えに基づいています。

.. This contract of course does not solve the problem, but gives an overview of how
.. you can use state machine-like constructs inside a contract.

このコントラクトはもちろん問題を解決するものではありませんが、コントラクトの中でステートマシンのような構造をどのように使用できるかの概要を示しています。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;
    contract Purchase {
        uint public value;
        address payable public seller;
        address payable public buyer;

        enum State { Created, Locked, Release, Inactive }
        // The state variable has a default value of the first member, `State.created`
        State public state;

        modifier condition(bool condition_) {
            require(condition_);
            _;
        }

        /// Only the buyer can call this function.
        error OnlyBuyer();
        /// Only the seller can call this function.
        error OnlySeller();
        /// The function cannot be called at the current state.
        error InvalidState();
        /// The provided value has to be even.
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

        // Ensure that `msg.value` is an even number.
        // Division will truncate if it is an odd number.
        // Check via multiplication that it wasn't an odd number.
        constructor() payable {
            seller = payable(msg.sender);
            value = msg.value / 2;
            if ((2 * value) != msg.value)
                revert ValueNotEven();
        }

        /// Abort the purchase and reclaim the ether.
        /// Can only be called by the seller before
        /// the contract is locked.
        function abort()
            external
            onlySeller
            inState(State.Created)
        {
            emit Aborted();
            state = State.Inactive;
            // We use transfer here directly. It is
            // reentrancy-safe, because it is the
            // last call in this function and we
            // already changed the state.
            seller.transfer(address(this).balance);
        }

        /// Confirm the purchase as buyer.
        /// Transaction has to include `2 * value` ether.
        /// The ether will be locked until confirmReceived
        /// is called.
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

        /// Confirm that you (the buyer) received the item.
        /// This will release the locked ether.
        function confirmReceived()
            external
            onlyBuyer
            inState(State.Locked)
        {
            emit ItemReceived();
            // It is important to change the state first because
            // otherwise, the contracts called using `send` below
            // can call in again here.
            state = State.Release;

            buyer.transfer(value);
        }

        /// This function refunds the seller, i.e.
        /// pays back the locked funds of the seller.
        function refundSeller()
            external
            onlySeller
            inState(State.Release)
        {
            emit SellerRefunded();
            // It is important to change the state first because
            // otherwise, the contracts called using `send` below
            // can call in again here.
            state = State.Inactive;

            seller.transfer(3 * value);
        }
    }

