#  Japanese Translation of the Solidity Documentation

Solidityドキュメントの日本語翻訳プロジェクトです。
進捗状況は https://github.com/solidity-docs/ja-japanese/issues/1 で確認できます。
このissueにある「Core Pages」の項目の翻訳が完了次第、[公式ドキュメント](https://docs.soliditylang.org/en/latest/)のフライアウトメニューに日本語が追加され、このリポジトリの内容が閲覧できるようになります。
ただし、それまでは一時的に https://solidity-ja.readthedocs.io/ で日本語翻訳を閲覧可能にします（ビルド元はこのリポジトリと同期している https://github.com/minaminao/ja-japanese です）。

Solidityドキュメントの翻訳者のチャットは https://forum.soliditylang.org/t/new-communication-channel-about-solidity-docs-community-translations/918 に記載されています。

## 翻訳に際して

### 同期PRの対処の仕方
基本的にGitHubのGUIだけでは難しい。
前回の同期PRの最終コミットハッシュから、今回の同期PRの最新コミットハッシュ間の差分を、Solidity本家のリポジトリで、`git diff <old commit hash>..<new commit hash>`のようにして確認し、その結果を各ファイルごとに`/<file name>`コマンドで検索して変更点を見ながら修正すると楽。
修正は、`gh pr checkout sync-<version>-<commit hash>`や`gh pr checkout <ID>`を用いるなどして行う。

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