import glob

term_list = [
    ("インターフェース", ("インターフェイス",)),
    ("状態変数", ("ステート変数",)),
    ("演算子", ("オペレータ",)),
    ("修飾子", ("モディファイア",)),
    ("代入", ("割り当て",)),
    (" ", ("　",)),
    (":", ("：",)),
    ("ストレージ", ("記憶",)),
    ("でき", ("することができ",)),
    ("ます。", ("る。",)),
    ("", ("・",)),
    ("型", ("タイプ",)),
    ("シグネチャ", ("シグネチャー",)),
    ("シャドーイング", ("シャドウイング",)),
    ("継承", ("相続",)),
]

for correct_term, wrong_terms in term_list:
    for wrong_term in wrong_terms:
        for file in glob.glob("./**/*.rst", recursive=True):
            lines = open(file).readlines()
            for i, line in enumerate(lines):
                if wrong_term in line:
                    print(f"{file}:{i} '{wrong_term}' => '{correct_term}'")