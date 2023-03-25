.. index:: auction;blind, auction;open, blind auction, open auction

**********************
ブラインドオークション
**********************

このセクションでは、Ethereum上で完全なブラインドオークションコントラクトをいかに簡単に作成できるかを紹介します。まず、誰もが入札を見ることができるオープンオークションから始めて、このコントラクトを、入札期間が終了するまで実際の入札を見ることができないブラインドオークションに拡張します。

.. _simple_auction:

シンプルなオープンオークション
==============================

以下のシンプルなオークションコントラクトの一般的な考え方は、入札期間中に誰もが入札を行うことができるというものです。
入札には、入札者を拘束するためにお金/Etherを送ることがすでに含まれています。
最高入札額が上がった場合、それまでの最高入札者はお金を返してもらいます。
入札期間の終了後、受益者がお金を受け取るためには、コントラクトを手動で呼び出さなければなりません。
コントラクトは自ら動作することはできません。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;
    contract SimpleAuction {
        // オークションのパラメータ。時刻は絶対的なunixタイムスタンプ（1970-01-01からの秒数）または秒単位の時間です。
        address payable public beneficiary;
        uint public auctionEndTime;

        // オークションの現状
        address public highestBidder;
        uint public highestBid;

        // 以前の入札のうち取り下げを許可したもの
        mapping(address => uint) pendingReturns;

        // 最後にtrueを設定すると、一切の変更が禁止されます。
        // デフォルトでは `false` に初期化されています。
        bool ended;

        // 変更時に発信されるイベント
        event HighestBidIncreased(address bidder, uint amount);
        event AuctionEnded(address winner, uint amount);

        // 失敗を表すエラー

        // トリプルスラッシュのコメントは、いわゆるnatspecコメントです。
        // これらは、ユーザーがトランザクションの確認を求められたときや、エラーが表示されたときに表示されます。

        /// オークションはすでに終了しています。
        error AuctionAlreadyEnded();
        /// すでに上位または同等の入札があります。
        error BidNotHighEnough(uint highestBid);
        /// オークションはまだ終了していません。
        error AuctionNotYetEnded();
        /// 関数 auctionEnd はすでに呼び出されています。
        error AuctionEndAlreadyCalled();

        /// 受益者アドレス `beneficiaryAddress` に代わって `biddingTime` 秒の入札時間を持つシンプルなオークションを作成します。
        constructor(
            uint biddingTime,
            address payable beneficiaryAddress
        ) {
            beneficiary = beneficiaryAddress;
            auctionEndTime = block.timestamp + biddingTime;
        }

        /// この取引と一緒に送られたvalueでオークションに入札します。
        /// 落札されなかった場合のみ、valueは返金されます。
        function bid() external payable {
            // 引数は必要なく、すべての情報はすでにトランザクションの一部となっています。
            // キーワード payable は、この関数が Ether を受け取ることができるようにするために必要です。

            // 入札期間が終了した場合、コールをリバートする。
            if (block.timestamp > auctionEndTime)
                revert AuctionAlreadyEnded();

            // 入札額が高くなければ、お金を送り返す（リバートステートメントは、それがお金を受け取ったことを含め、この関数の実行のすべての変更を元に戻します）。
            if (msg.value <= highestBid)
                revert BidNotHighEnough(highestBid);

            if (highestBid != 0) {
                // highestBidder.send(highestBid) を使って単純に送り返すと、信頼できないコントラクトを実行する可能性があり、セキュリティ上のリスクがあります。
                // 受取人が自分でお金を引き出せるようにするのが安全です。
                pendingReturns[highestBidder] += highestBid;
            }
            highestBidder = msg.sender;
            highestBid = msg.value;
            emit HighestBidIncreased(msg.sender, msg.value);
        }

        /// 最高入札額より低い入札を取り下げます。
        function withdraw() external returns (bool) {
            uint amount = pendingReturns[msg.sender];
            if (amount > 0) {
                // 受信者は `send` が戻る前に、受信コールの一部としてこの関数を再び呼び出すことができるので、これをゼロに設定することが重要です。
                pendingReturns[msg.sender] = 0;

                if (!payable(msg.sender).send(amount)) {
                    // ここでコールを投げる必要はなく、ただリセットすれば良いです。
                    pendingReturns[msg.sender] = amount;
                    return false;
                }
            }
            return true;
        }

        /// オークションを終了し、最高入札額を受益者に送付します。
        function auctionEnd() external {
            // 他のコントラクトと相互作用する関数（関数を呼び出したり、Etherを送ったりする）は、3つのフェーズに分けるのが良いガイドラインです。
            // 1. 条件をチェックする
            // 2. アクションを実行する（条件を変更する可能性がある）。
            // 3. 他のコントラクトと対話する
            // これらのフェーズが混在すると、他のコントラクトが現在のコントラクトにコールバックして状態を変更したり、エフェクト（エーテル払い出し）を複数回実行させたりする可能性があります。
            // 内部で呼び出される関数に外部コントラクトとの相互作用が含まれる場合は、外部コントラクトとの相互作用も考慮しなければなりません。

            // 1. 条件
            if (block.timestamp < auctionEndTime)
                revert AuctionNotYetEnded();
            if (ended)
                revert AuctionEndAlreadyCalled();

            // 2. エフェクト
            ended = true;
            emit AuctionEnded(highestBidder, highestBid);

            // 3. インタラクション
            beneficiary.transfer(highestBid);
        }
    }

ブラインドオークション
======================

前回のオープンオークションは、次のようにブラインドオークションに拡張されます。ブラインドオークションの利点は、入札期間の終わりに向けての時間的プレッシャーがないことです。透明なコンピューティングプラットフォーム上でブラインドオークションを行うというのは矛盾しているように聞こえるかもしれませんが、暗号技術がその助けとなります。

**入札期間** 中、入札者は自分の入札を実際には送信せず、ハッシュ化したものだけを送信します。現在のところ、ハッシュ値が等しい2つの（十分に長い）値を見つけることは実質的に不可能であると考えられているため、入札者はそれによって入札にコミットします。入札期間の終了後、入札者は自分の入札を明らかにしなければならない。入札者は自分の値を暗号化せずに送信し、コントラクトはそのハッシュ値が入札期間中に提供されたものと同じであるかどうかをチェックします。

もう一つの課題は、いかにしてオークションの **バインディングとブラインド** を同時に行うかということです。落札した後にお金を送らないだけで済むようにするには、入札と一緒に送らせるようにするしかありません。イーサリアムでは価値の移転はブラインドできないので、誰でも価値を見ることができます。

以下のコントラクトでは、最高額の入札よりも大きな値を受け入れることで、この問題を解決しています。もちろん、これは公開段階でしかチェックできないので、いくつかの入札は **無効** になるかもしれませんが、これは意図的なものです（高額な送金で無効な入札を行うための明示的なフラグも用意されています）。入札者は、高額または低額の無効な入札を複数回行うことで、競争を混乱させることができます。

.. code-block:: solidity
    :force:

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.4;
    contract BlindAuction {
        struct Bid {
            bytes32 blindedBid;
            uint deposit;
        }

        address payable public beneficiary;
        uint public biddingEnd;
        uint public revealEnd;
        bool public ended;

        mapping(address => Bid[]) public bids;

        address public highestBidder;
        uint public highestBid;

        // 以前の入札のうち取り下げを許可したもの
        mapping(address => uint) pendingReturns;

        event AuctionEnded(address winner, uint highestBid);

        // 失敗を表すエラー

        /// この関数は早く呼び出されすぎました。
        /// `time` 秒後にもう一度試してください。
        error TooEarly(uint time);
        /// この関数を呼び出すのが遅すぎました。
        /// `time` 秒後に呼び出すことはできません。
        error TooLate(uint time);
        /// 関数 auctionEnd はすでに呼び出されています。
        error AuctionEndAlreadyCalled();

        // 修飾子は、関数への入力を検証するための便利な方法です。
        // 以下の `onlyBefore` は `bid` に適用されます。
        // 新しい関数の本体は修飾子の本体で、 `_` が古い関数の本体に置き換わります。
        modifier onlyBefore(uint time) {
            if (block.timestamp >= time) revert TooLate(time);
            _;
        }
        modifier onlyAfter(uint time) {
            if (block.timestamp <= time) revert TooEarly(time);
            _;
        }

        constructor(
            uint biddingTime,
            uint revealTime,
            address payable beneficiaryAddress
        ) {
            beneficiary = beneficiaryAddress;
            biddingEnd = block.timestamp + biddingTime;
            revealEnd = biddingEnd + revealTime;
        }

        /// `blindedBid` = keccak256(abi.encodePacked(value, fake, secret)) でブラインド入札を行います。
        /// 送信されたEtherは、リビールフェーズで入札が正しくリビールされた場合にのみ払い戻されます。
        /// 入札と一緒に送られたEtherが少なくとも「value」であり、「fake」がtrueでない場合、入札は有効です。
        /// 「fake」をtrueに設定し、正確な金額を送らないことで、本当の入札を隠しつつ、必要なデポジットを行うことができます。
        /// 同じアドレスで複数の入札を行うことができます。
        function bid(bytes32 blindedBid)
            external
            payable
            onlyBefore(biddingEnd)
        {
            bids[msg.sender].push(Bid({
                blindedBid: blindedBid,
                deposit: msg.value
            }));
        }

        /// ブラインドした入札を公開します。
        /// 正しくブラインドされた無効な入札と、完全に高い入札を除くすべての入札の払い戻しを受けることができます。
        function reveal(
            uint[] calldata values,
            bool[] calldata fakes,
            bytes32[] calldata secrets
        )
            external
            onlyAfter(biddingEnd)
            onlyBefore(revealEnd)
        {
            uint length = bids[msg.sender].length;
            require(values.length == length);
            require(fakes.length == length);
            require(secrets.length == length);

            uint refund;
            for (uint i = 0; i < length; i++) {
                Bid storage bidToCheck = bids[msg.sender][i];
                (uint value, bool fake, bytes32 secret) =
                        (values[i], fakes[i], secrets[i]);
                if (bidToCheck.blindedBid != keccak256(abi.encodePacked(value, fake, secret))) {
                    // 入札は実際にリビールされていません。
                    // デポジットを返金しません。
                    continue;
                }
                refund += bidToCheck.deposit;
                if (!fake && bidToCheck.deposit >= value) {
                    if (placeBid(msg.sender, value))
                        refund -= value;
                }
                // 送信者が同じデポジットを再クレームできないようにします。
                bidToCheck.blindedBid = bytes32(0);
            }
            payable(msg.sender).transfer(refund);
        }

        /// オーバーな入札を引き出す。
        function withdraw() external {
            uint amount = pendingReturns[msg.sender];
            if (amount > 0) {
                // これをゼロに設定することが重要です。
                // なぜなら、受信者は `transfer` が戻る前にリシーブしているコールの一部としてこの関数を再び呼び出すことができるからです（前で述べた 条件 -> エフェクト -> インタラクション に関する記述を参照してください）。
                pendingReturns[msg.sender] = 0;

                payable(msg.sender).transfer(amount);
            }
        }

        /// オークションを終了し、最高入札額を受益者に送ります。
        function auctionEnd()
            external
            onlyAfter(revealEnd)
        {
            if (ended) revert AuctionEndAlreadyCalled();
            emit AuctionEnded(highestBidder, highestBid);
            ended = true;
            beneficiary.transfer(highestBid);
        }

        // これは「内部」関数であり、コントラクト自身（または派生コントラクト）からしか呼び出すことができないことを意味します。
        function placeBid(address bidder, uint value) internal
                returns (bool success)
        {
            if (value <= highestBid) {
                return false;
            }
            if (highestBidder != address(0)) {
                // 前回の最高額入札者に払い戻しを行います。
                pendingReturns[highestBidder] += highestBid;
            }
            highestBid = value;
            highestBidder = bidder;
            return true;
        }
    }

