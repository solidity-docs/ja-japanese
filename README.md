#  Japanese Translation of the Solidity Documentation

Solidityドキュメントの日本語翻訳プロジェクトです。
進捗状況は https://github.com/solidity-docs/ja-japanese/issues/1 で確認できます。
このissueにある「Core Pages」の項目の翻訳が完了次第、[公式ドキュメント](https://docs.soliditylang.org/en/latest/)のフライアウトメニューに日本語が追加され、このリポジトリの内容が閲覧できるようになります。
ただし、それまでは一時的に https://solidity-ja.readthedocs.io/ で日本語翻訳を閲覧可能にします（ビルド元はこのリポジトリと同期している https://github.com/minaminao/ja-japanese です）。

Solidityドキュメントの翻訳者のチャットは https://forum.soliditylang.org/t/new-communication-channel-about-solidity-docs-community-translations/918 に記載されています。

## 翻訳に際して

### 同期PRの対処の仕方
基本的にGitHubのGUIだけでは難しい。

まず、同期PRの「Files changed」から変更されたドキュメントのファイル一覧を見る。

次に、前回の同期PRの最終コミットハッシュから、今回の同期PRの最新コミットハッシュ間の差分を、Solidity本体のリポジトリ（このリポジトリではない）で、`git diff <old commit hash>..<new commit hash>`を実行して表示する。
コミットハッシュは同期PRの始めに「This is an automatically-generated sync PR to bring this translation repository up to date with the state of the English documentation as of 2023-07-11 (commit b583e9e6).」などと書かれている。

そして、変更された各ファイルごとに、`gid diff`の結果画面で`/<file name>`コマンドで検索して変更点を調べる。`gh pr checkout sync-<version>-<commit hash>`や`gh pr checkout <ID>`を用いて該当PRのブランチ切り替え、コンフリクトの対処や翻訳を行う。

### 環境構築の一例

```
pyenv shell 3.11.1
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
