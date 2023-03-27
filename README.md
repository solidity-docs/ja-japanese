#  Japanese Translation of the Solidity Documentation

Solidityドキュメントの日本語翻訳プロジェクトです。進捗状況は https://github.com/solidity-docs/ja-japanese/issues/1 で確認できます。このissueにある「Core Pages」の項目の翻訳が完了次第、[公式ドキュメント](https://docs.soliditylang.org/en/latest/)のフライアウトメニューに日本語が追加され、このリポジトリの内容が閲覧できるようになります。ただし、それまでは一時的に https://solidity-ja.readthedocs.io/ で日本語翻訳を閲覧可能にします（ビルド元はこのリポジトリと同期している https://github.com/minaminao/ja-japanese です）。

Solidityドキュメントの翻訳者のチャットは https://forum.soliditylang.org/t/new-communication-channel-about-solidity-docs-community-translations/918 にあります。

同期PRの対処の仕方
- 基本的にGitHubのGUIだけでは難しい
- solidity本家のリポジトリで`git diff <old commit hash>..<new commit hash>`で差分を確認
- その結果を各ファイルごとに`/<file name>`コマンドで検索して変更点を見ながら修正
