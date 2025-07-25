#  Japanese Translation of the Solidity Documentation

Solidityドキュメントの日本語翻訳プロジェクトです。
進捗状況は https://github.com/solidity-docs/ja-japanese/issues/1 で確認できます。
このリポジトリは https://docs.soliditylang.org/ja/latest/ と連携しています。

Solidityドキュメントの翻訳者のチャットは https://forum.soliditylang.org/t/new-communication-channel-about-solidity-docs-community-translations/918 に記載されています。

なお以前は、 https://solidity-ja.readthedocs.io/ で日本語翻訳を閲覧可能でした（ビルド元はこのリポジトリと同期している https://github.com/minaminao/ja-japanese です）。
現在は https://docs.soliditylang.org/ja/ にリダイレクトされます。

## 翻訳に際して

### 同期PRの対処の仕方

基本的にGitHubのGUIだけでは難しい。

まず、同期PRの「Files changed」から変更されたドキュメントのファイル一覧を見る。

次に、前回の同期PRの最終コミットハッシュから、今回の同期PRの最新コミットハッシュ間の差分を、Solidity本体のリポジトリ（このリポジトリではない）で、`git diff <old commit hash>..<new commit hash>`を実行して表示する。
具体的なコミットハッシュは前回の同期PRの最後のコミットハッシュ（botによるコミットの直前）と、今回の同期PRの最後のコミットハッシュ（botによるコミットの直前）を使えば良い。

そして、変更された各ファイルごとに、`git diff`の結果画面で`/<file name>`コマンドで検索して変更点を調べる。
`git checkout <pr-commit-hash>` (`gh pr checkout sync-<version>-<commit hash>`, `gh pr checkout <ID>` 等) を用いて該当PRのブランチに切り替え、コンフリクトの対処や翻訳を行う。

### 環境構築の一例

```
pyenv shell 3.12.7
python -m venv venv
source venv/bin/activate.fish
pip install -r docs/requirements.txt
```

### ビルド

HTML:
```
cd docs
make html
```

PDF:
```
cd docs
make latexpdf
```

<!--
### その他注意点

- `.. NOTE: `はメモ。
-->

### 特定のバージョンの同期PRの作り方

https://github.com/solidity-docs/.github/blob/main/scripts/create-sync-branch-for-release.sh をこのリポジトリのルートで実行するとブランチが生成される。
それをpushしてPRを作成する。
