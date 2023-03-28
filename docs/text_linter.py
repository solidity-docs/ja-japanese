import glob

def check_terms():

    term_list = [
        ("インターフェース", ("インターフェイス",)),
        ("状態変数", ("ステート変数",)),
        ("演算子", ("オペレータ",)),
        ("修飾子", ("モディファイア",)),
        ("代入", ("割り当て",)),
        (" ", ("　",)),
        (":", ("：",)),
        (": ", (" : ",)),
        ("、", ("，",)),
        ("。", ("．",)),
        ("+", ("＋",)),
        ("ストレージ", ("記憶",)),
        ("でき", ("することができ",)),
        ("ます。", ("る。",)),
        ("です。", ("だ。",)),
        ("", ("・",)),
        ("型", ("タイプ",)),
        ("シグネチャ", ("シグネチャー",)),
        ("シャドーイング", ("シャドウイング",)),
        ("オプティマイザ", ("オプティマイザー",)),
        ("セレクタ", ("セレクター",)),
        ("動的", ("ダイナミック",)),
        ("静的", ("スタティック",)),
        ("継承", ("相続",)),
        # ("ため、", ("ので、",)),
        ("コントロールフロー", ("制御フロー",)),
        ("ハイレベル", ("高レベル",)),
        ("関数", ("ファンクション",)),
        ("リターン変数", ("戻り値変数", "戻り変数")),
        ("文", ("ステートメント",)),
        ("データロケーション", ("データ位置",)),
        ("リバート", ("復帰", "元に戻")),
        ("参照して", ("ご覧",)),
        ("作成者", ("オリジネーター",)),
        ("将来", ("将来的に",)),
    ]

    for correct_term, wrong_terms in term_list:
        for wrong_term in wrong_terms:
            for file in glob.glob("./**/*.rst", recursive=True):
                lines = open(file).readlines()
                for i, line in enumerate(lines):
                    if wrong_term in line:
                        print(f"{file}:{i + 1} '{wrong_term}' => '{correct_term}'")

def check_kuten():
    for file in glob.glob("./**/*.rst", recursive=True):
        lines = open(file).readlines()
        for i, line in enumerate(lines):
            if line.find("。") != -1 and line.find("。") != len(line) - 2:
                print(f"{file}:{i + 1} '。([^\\n])' -> '。\\n$1")

if __name__ == "__main__":
    check_terms()
    check_kuten()