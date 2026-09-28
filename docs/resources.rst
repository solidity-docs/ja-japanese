####
資料
####

一般的な資料
============

* `Ethereum.org Developers page <https://ethereum.org/en/developers/>`_
* `Ethereum StackExchange <https://ethereum.stackexchange.com/>`_
* `Solidity website <https://soliditylang.org/>`_
* `Solidity changelog <https://github.com/argotorg/solidity/blob/develop/Changelog.md>`_
* `Solidity codebase on GitHub <https://github.com/argotorg/solidity/>`_
* `Solidity language users chat <https://matrix.to/#/#ethereum_solidity:gitter.im>`_
* `Solidity compiler developers chat <https://matrix.to/#/#ethereum_solidity-dev:gitter.im>`_
* `awesome-solidity <https://github.com/bkrem/awesome-solidity>`_
* `Solidity by Example <https://solidity-by-example.org/>`_
* `Solidity documentation community translations <https://github.com/solidity-docs>`_
* `Solidity and Smart Contract Glossary <https://www.cyfrin.io/glossary>`_

統合（Ethereum）開発環境
========================

..     * `Dapp <https://dapp.tools/>`_
..         Tool for building, testing and deploying smart contracts from the command-line.
..     * `Embark <https://framework.embarklabs.io/>`_
..         Developer platform for building and deploying decentralized applications.
..     * `Foundry <https://github.com/foundry-rs/foundry>`_
..         Fast, portable and modular toolkit for Ethereum application development written in Rust.
..     * `Hardhat <https://hardhat.org/>`_
..         Ethereum development environment with local Ethereum network, debugging features and plugin ecosystem.
..     * `Remix <https://remix.ethereum.org/>`_
..         Browser-based IDE with integrated compiler and Solidity runtime environment without server-side components.

* `Ape <https://docs.apeworx.io/ape>`_
    A Python-based web3 development tool for compiling, testing, and interacting with smart contracts.

* `Brownie <https://eth-brownie.readthedocs.io/en/stable/>`_
    A Python-based development and testing framework for smart contracts targeting the Ethereum Virtual Machine.
    💡 Note: As per the official docs, Brownie is no longer actively maintained.
    Future releases may come sporadically - or never at all.
    Check out Ape Framework (first in list) for all your python Ethereum development needs.

* `Dapp <https://dapp.tools/>`_
    コマンドラインからスマートコントラクトを構築、テスト、デプロイするためのツール。

* `Foundry <https://github.com/foundry-rs/foundry>`_
    Rustで書かれたEthereumアプリケーション開発のための高速、ポータブル、モジュラーなツールキット。

* `Hardhat <https://hardhat.org/>`_
    ローカルEthereumネットワーク、デバッグ機能、プラグインエコシステムを備えたEthereum開発環境。

* `Remix <https://remix.ethereum.org/>`_
    サーバーサイドのコンポーネントを使用せず、コンパイラとSolidity実行環境を統合したブラウザベースのIDE。

* `Truffle <https://trufflesuite.com/truffle/>`_
    Ethereum開発フレームワーク。
    💡 Note: Consensys announced the sunset of Truffle on September 21, 2023.
    Current users may check out the migration path and available product support `here.
    <https://consensys.io/blog/consensys-announces-the-sunset-of-truffle-and-ganache-and-new-hardhat>`_

.. Editor Integrations

エディターとの統合
==================

* Emacs

    ..         Plugin for the Emacs editor providing syntax highlighting and compilation error reporting.

    * `Emacs Solidity <https://github.com/ethereum/emacs-solidity/>`_
        シンタックスハイライトとコンパイルエラーレポートを提供するEmacsエディタ用のプラグイン。


* IntelliJ

    ..         Solidity plugin for IntelliJ IDEA (and all other JetBrains IDEs).

    * `IntelliJ IDEA plugin <https://plugins.jetbrains.com/plugin/9475-solidity/>`_
        IntelliJ IDEA（およびその他すべてのJetBrains IDEs）用のSolidityプラグイン。


* Sublime Text

    ..         Solidity syntax highlighting for SublimeText editor.

    * `Package for SublimeText - Solidity language syntax <https://packagecontrol.io/packages/Ethereum/>`_
        SublimeTextエディタ用のSolidityシンタックスハイライト。


* Vim

    ..         Plugin for the Vim editor providing compile checking.

    * `Vim Solidity by Thesis <https://github.com/thesis/vim-solidity/>`_
        Vim用のSolidityシンタックスハイライト。

    * `Vim Solidity by TovarishFin <https://github.com/TovarishFin/vim-solidity>`_
        Solidity用のVimシンタックスファイル。

    * `Vim Syntastic <https://github.com/vim-syntastic/syntastic>`_
        コンパイルチェックを行うVimエディタ用のプラグイン。

* Visual Studio Code (VS Code)

    * `Aderyn Visual Studio Code extension <https://marketplace.visualstudio.com/items?itemName=Cyfrin.aderyn>`_
        Solidity Smart contract analyzer designed to help find vulnerabilities. It supports projects built with Hardhat, Foundry, or any custom framework.

    * `Ethereum Remix Visual Studio Code extension <https://github.com/ethereum/remix-vscode>`_
        VS Code用のEthereum Remix拡張パック。
        💡 Note: As per the official repository, this extension has been removed from the VSCODE marketplace and will be replaced by a dedicated stand-alone desktop application.

    * `Solidity Visual Studio Code extension, by Juan Blanco <https://juan.blanco.ws/solidity-contracts-in-visual-studio-code/>`_
        シンタックスハイライトとSolidityコンパイラを含むMicrosoft Visual Studio Code用のSolidityプラグイン。

    * `Solidity Visual Studio Code extension, by Nomic Foundation <https://marketplace.visualstudio.com/items?itemName=NomicFoundation.hardhat-solidity>`_
        HardhatチームによるSolidityとHardhatのサポートで、次の機能を含む: シンタックスハイライト、定義へのジャンプ、リネーム、クイックフィックス、インラインsolcの警告とエラー。

    * `Solidity Visual Auditor extension <https://marketplace.visualstudio.com/items?itemName=tintinweb.solidity-visual-auditor>`_
        Visual Studio Codeにセキュリティのためのシンタックスとセマンティックハイライトを追加。

    * `Truffle for VS Code <https://marketplace.visualstudio.com/items?itemName=trufflesuite-csi.truffle-vscode>`_
        EthereumおよびEVM互換のブロックチェーン上でのスマートコントラクトの構築、デバッグ、デプロイ。
        💡 Note: This extension has built-in support for the Truffle Suite which is being sunset.
        For information on ongoing support, migration options and FAQs, visit the `Consensys blog.
        <https://consensys.io/blog/consensys-announces-the-sunset-of-truffle-and-ganache-and-new-hardhat>`_

Solidityのツール
================

.. * `ABI to Solidity interface converter <https://gist.github.com/chriseth/8f533d133fa0c15b0d6eaf3ec502c82b>`_
..     A script for generating contract interfaces from the ABI of a smart contract.

* `ABI to Solidity interface converter <https://gist.github.com/chriseth/8f533d133fa0c15b0d6eaf3ec502c82b>`_
    スマートコントラクトのABIからコントラクトインターフェースを生成するためのスクリプト。

.. * `abi-to-sol <https://github.com/gnidan/abi-to-sol>`_
..     Tool to generate Solidity interface source from a given ABI JSON.

* `abi-to-sol <https://github.com/gnidan/abi-to-sol>`_
    与えられたABI JSONからSolidityインターフェースソースを生成するツール。

* `Aderyn <https://github.com/Cyfrin/aderyn>`_
    Command Line Tool that helps find vulnerabilities in Solidity smart contracts. It supports projects built with Hardhat, Foundry, or any custom framework.

* `Doxity <https://github.com/DigixGlobal/doxity>`_
    Solidityのためのドキュメントジェネレーター。

.. * `Ethlint <https://github.com/duaraghav8/Ethlint>`_
..     Linter to identify and fix style and security issues in Solidity.

* `ethdebug <https://github.com/ethdebug/format>`_
    A standard debugging data format for smart contracts on Ethereum-compatible networks.

* `Ethlint <https://github.com/duaraghav8/Ethlint>`_
    Solidityのスタイルとセキュリティの問題を特定し、修正するためのリンター。

.. * `evmdis <https://github.com/Arachnid/evmdis>`_
..     EVM Disassembler that performs static analysis on the bytecode to provide a higher level of abstraction than raw EVM operations.

* `evmdis <https://github.com/Arachnid/evmdis>`_
    バイトコードに対して静的解析を行い、生のEVM操作よりも高い抽象度を提供するEVM逆アセンブラ。

* `EVM Lab <https://github.com/ethereum/evmlab/>`_
    A collection of tools to interact with the EVM. The package includes a VM, Etherchain API, and a trace-viewer with gas cost display.

.. * `hevm <https://github.com/dapphub/dapptools/tree/master/src/hevm#readme>`_
..     EVM debugger and symbolic execution engine.

* `hevm <https://github.com/dapphub/dapptools/tree/master/src/hevm#readme>`_
    EVMデバッガとシンボリック実行エンジン。

* `leafleth <https://github.com/clemlak/leafleth>`_
    Solidityスマートコントラクトのためのドキュメント生成ツール。

.. * `PIET <https://piet.slock.it/>`_
..     A tool to develop, audit and use Solidity smart contracts through a simple graphical interface.

* `PIET <https://piet.slock.it/>`_
    シンプルなグラフィカルインターフェースを介してSolidityスマートコントラクトを開発、監査、使用するためのツール。

* `Scaffold-ETH 2 <https://github.com/scaffold-eth/scaffold-eth-2>`_
    迅速なプロダクトイテレーションに焦点を当てたフォーク可能なEthereum開発スタック。

.. * `sol2uml <https://www.npmjs.com/package/sol2uml>`_
..     Unified Modeling Language (UML) class diagram generator for Solidity contracts.

* `Slippy <https://github.com/fvictorio/slippy>`_
    A simple and powerful linter for Solidity.

* `sol2uml <https://www.npmjs.com/package/sol2uml>`_
    Solidityコントラクト用のUnified Modeling Language (UML)クラスのダイアグラムジェネレーター。

.. * `solc-select <https://github.com/crytic/solc-select>`_
..     A script to quickly switch between Solidity compiler versions.

* `solc-select <https://github.com/crytic/solc-select>`_
    Solidityのコンパイラバージョンを素早く切り替えるスクリプト。

.. * `Solidity prettier plugin <https://github.com/prettier-solidity/prettier-plugin-solidity>`_
..     A Prettier Plugin for Solidity.

* `Solidity prettier plugin <https://github.com/prettier-solidity/prettier-plugin-solidity>`_
    SolidityのためのPrettierプラグイン。

.. * `Solidity REPL <https://github.com/raineorshine/solidity-repl>`_
..     Try Solidity instantly with a command-line Solidity console.

* `Solidity REPL <https://github.com/raineorshine/solidity-repl>`_
    コマンドラインのSolidityコンソールですぐにSolidityを試すことができます。

.. * `solgraph <https://github.com/raineorshine/solgraph>`_
..     Visualize Solidity control flow and highlight potential security vulnerabilities.

* `solgraph <https://github.com/raineorshine/solgraph>`_
    Solidityのコントロールフローを可視化し、潜在的なセキュリティの脆弱性を明らかにします。

.. * `Solhint <https://github.com/protofire/solhint>`_
..     Solidity linter that provides security, style guide and best practice rules for smart contract validation.

* `Solhint <https://github.com/protofire/solhint>`_
    スマートコントラクトの検証のためのセキュリティ、スタイルガイド、ベストプラクティスルールを提供するSolidityリンター。

* `Sourcify <https://sourcify.dev/>`_
    非中央集権型の自動コントラクト検証サービスとコントラクトメタデータのパブリックリポジトリ。

.. * `Sūrya <https://github.com/ConsenSys/surya/>`_
..     Utility tool for smart contract systems, offering a number of visual outputs and information about the contracts' structure. Also supports querying the function call graph.

* `Sūrya <https://github.com/ConsenSys/surya/>`_
    スマートコントラクトシステムのためのユーティリティーツールで、多数のビジュアル出力とコントラクトの構造に関する情報を提供します。
    また、関数呼び出しグラフのクエリもサポートしています。

.. * `Universal Mutator <https://github.com/agroce/universalmutator>`_
..     A tool for mutation generation, with configurable rules and support for Solidity and Vyper.

* `Universal Mutator <https://github.com/agroce/universalmutator>`_
    設定可能なルールを持ち、SolidityとVyperをサポートする、突然変異生成のためのツール。

* `Wake <https://github.com/Ackee-Blockchain/wake>`_
    A Python-based Solidity development and testing framework with built-in vulnerability detectors.

サードパーティのSolidityパーサーとグラマー
==========================================

.. * `Solidity Parser for JavaScript <https://github.com/solidity-parser/parser>`_
..     A Solidity parser for JS built on top of a robust ANTLR4 grammar.

Third-Party Solidity Parsers and Grammars
=========================================

* `Solidity Parser for JavaScript <https://github.com/solidity-parser/parser>`_
    堅牢なANTLR4文法の上に構築されたJS用のSolidityパーサー。
