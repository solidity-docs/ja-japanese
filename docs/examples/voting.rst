.. index:: voting, ballot

.. _voting:

****
投票
****

次のコントラクトは非常に複雑ですが、Solidityの機能の多くを紹介しています。
これは、投票コントラクトを実装しています。
もちろん、電子投票の主な問題点は、いかにして正しい人に投票権を割り当てるか、いかにして操作を防ぐかです。
ここですべての問題を解決するわけではありませんが、少なくとも、投票数のカウントが **自動的** に行われ、同時に **完全に透明** であるように、委任投票を行う方法を紹介する予定です。

アイデアとしては、1つの投票用紙に対して1つのコントラクトを作成し、それぞれの選択肢に短い名前をつけます。
そして、議長を務めるコントラクトの作成者が、各アドレスに個別に投票権を与えます。

そして、そのアドレスを持つ人は、自分で投票するか、信頼できる人に投票を委任するかを選ぶことができます。

投票時間終了後、最も多くの票を獲得したプロポーザルを ``winningProposal()`` に返します。

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.7.0 <0.9.0;
    /// @title 委任による投票
    contract Ballot {
        // 新しい複合型を宣言し、後で変数に使用します。
        // 一人の投票者を表します。
        struct Voter {
            uint weight; // ウェイトは委任により蓄積される
            bool voted;  // trueならすでにその人は投票済み
            address delegate; // 委任先
            uint vote;   // 投票したプロポーザルのインデックス
        }

        // 1つのプロポーザルの型です。
        struct Proposal {
            bytes32 name;   // 短い名前（上限32バイト）
            uint voteCount; // 投票数
        }

        address public chairperson;

        // アドレスごとに `Voter` 構造体を格納する状態変数を宣言しています。
        mapping(address => Voter) public voters;

        // `Proposal` 構造体の動的サイズの配列
        Proposal[] public proposals;

        /// `proposalNames` のいずれかを選択するための新しい投票を作成します。
        constructor(bytes32[] memory proposalNames) {
            chairperson = msg.sender;
            voters[chairperson].weight = 1;

            // 指定されたプロポーザル名ごとに新しいプロポーザルオブジェクトを作成し、配列の末尾に追加します。
            for (uint i = 0; i < proposalNames.length; i++) {
                // `Proposal({...})` は一時的なプロポーザルオブジェクトを作成し、 `proposals.push(...)` はそれを `proposals` の末尾に追加します。
                proposals.push(Proposal({
                    name: proposalNames[i],
                    voteCount: 0
                }));
            }
        }

        // `voter` にこの投票用紙に投票する権利を与えます。
        // `chairperson` だけが呼び出すことができます。
        function giveRightToVote(address voter) external {
            // `require` の第一引数の評価が `false` の場合、実行は終了し、状態やEther残高のすべての変更が元に戻されます。
            // これは、古いEVMのバージョンでは全てのガスを消費していましたが、今はそうではありません。
            // 関数が正しく呼び出されているかどうかを確認するために、 `require` を使用するのは良いアイデアです。
            // 第二引数として、何が悪かったのかについての説明を記述することもできます。
            require(
                msg.sender == chairperson,
                "Only chairperson can give right to vote."
            );
            require(
                !voters[voter].voted,
                "The voter already voted."
            );
            require(voters[voter].weight == 0);
            voters[voter].weight = 1;
        }

        /// 投票者 `to` に投票を委任します。
        function delegate(address to) external {
            // 参照を代入
            Voter storage sender = voters[msg.sender];
            require(sender.weight != 0, "You have no right to vote");
            require(!sender.voted, "You already voted.");

            require(to != msg.sender, "Self-delegation is disallowed.");

            // `to` もデリゲートされている限り、デリゲートを転送します。
            // 一般的に、このようなループは非常に危険です。
            // なぜなら、ループが長くなりすぎると、ブロック内で利用できる量よりも多くのガスが必要になる可能性があるからです。
            // この場合、デリゲーションは実行されません。
            // しかし、他の状況では、このようなループによってコントラクトが完全に「スタック」してしまう可能性があります。
            while (voters[to].delegate != address(0)) {
                to = voters[to].delegate;

                // 委任でループを発見した場合、委任は許可されません。
                require(to != msg.sender, "Found loop in delegation.");
            }

            Voter storage delegate_ = voters[to];

            // 投票者は、投票できないアカウントに委任できません。
            require(delegate_.weight >= 1);

            // `sender` は参照なので、`voters[msg.sender]` を修正します。
            sender.voted = true;
            sender.delegate = to;

            if (delegate_.voted) {
                // 代表者が既に投票している場合は、直接投票数に加算する
                proposals[delegate_.vote].voteCount += sender.weight;
            } else {
                // 代表者がまだ投票していない場合は、その人の重みに加える
                delegate_.weight += sender.weight;
            }
        }

        /// あなたの投票権（あなたに委任された投票権を含む）をプロポーザル `proposals[proposal].name` に与えてください。
        function vote(uint proposal) external {
            Voter storage sender = voters[msg.sender];
            require(sender.weight != 0, "Has no right to vote");
            require(!sender.voted, "Already voted.");
            sender.voted = true;
            sender.vote = proposal;

            // もし `proposal` が配列の範囲外であれば、自動的にスローされ、すべての変更が取り消されます。
            proposals[proposal].voteCount += sender.weight;
        }

        /// @dev 以前の投票をすべて考慮した上で、当選案を計算します。
        function winningProposal() public view
                returns (uint winningProposal_)
        {
            uint winningVoteCount = 0;
            for (uint p = 0; p < proposals.length; p++) {
                if (proposals[p].voteCount > winningVoteCount) {
                    winningVoteCount = proposals[p].voteCount;
                    winningProposal_ = p;
                }
            }
        }

        // winningProposal()関数を呼び出して、プロポーザルの配列に含まれる当選案のインデックスを取得し、当選案の名前を返します。
        function winnerName() external view
                returns (bytes32 winnerName_)
        {
            winnerName_ = proposals[winningProposal()].name;
        }
    }

改良の可能性
============

Currently, many transactions are needed to assign the rights to vote to all participants.
Moreover, if two or more proposals have the same number of votes, ``winningProposal()`` is not able to register a tie.
Can you think of a way to fix these issues?
