import glob
import unicodedata
import re

def check_terms():

    check_list = [
        ("インターフェース", ("インターフェイス",)),
        ("状態変数", ("ステート変数",)),
        ("演算子", ("オペレータ",)),
        ("モディファイア", ("修飾子",)),
        ("代入", ("割り当て",)),
        (" ", ("　",)),
        (":", ("：",)),
        ("、", ("，",)),
        ("。", ("．",)),
        ("+", ("＋",)),
        ("ストレージ", ("記憶",)),
        ("でき", ("することができ",)),
        ("ます。", ("る。",)), # だ・である調を使うときは、「。」を使わないようにしたい
        ("です。", ("だ。",)),
        ("?", ("ない。",)),
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
        ("``: ", ("`` : ",)),
        ("\n", (" \n",)),
        # ("$1コール", ("([^数部])呼び出し",)), # function call = 関数呼び出し, call = コール
        # (": ", (" : ",)),
    ]

    for correct_term, raw_patterns in check_list:
        for raw_pattern in raw_patterns:
            for file in glob.glob("./**/*.rst", recursive=True):
                lines = open(file).readlines()
                for i, line in enumerate(lines):
                    pattern = re.compile(raw_pattern)
                    if pattern.search(line):
                        print(f"{file}:{i + 1}  '{raw_pattern}' => '{correct_term}'")


def check_kuten():
    for file in glob.glob("./**/*.rst", recursive=True):
        lines = open(file).readlines()
        for i, line in enumerate(lines):
            lstripped_line = line.lstrip()
            if len(lstripped_line) > 0 and lstripped_line[0] in "-*#/|1234567890":
                continue
            if line.find("。") != -1 and line.find("。") != len(line) - 2:
                print(f"{file}:{i + 1}  '。([^\\n])' -> '。\\n$1")


def check_headers():
    def get_char_width(text):
        width = 0
        for c in text:
            if unicodedata.east_asian_width(c) in 'FWA':
                width += 2
            else:
                width += 1
        return width

    for file in glob.glob("./**/*.rst", recursive=True):
        lines = open(file).readlines()
        for i in range(len(lines) - 1):
            line = lines[i][:-1]
            next_line = lines[i + 1][:-1]

            if len(line) == 0 or len(next_line) == 0:
                continue

            if len(set(next_line)) != 1:
                continue

            if next_line[0] not in "=-^~*":
                continue

            line_length = get_char_width(line)
            next_line_length = len(next_line)

            if line_length != next_line_length:
                print(f"{file}:{i + 1}  Header length mismatch: {line_length} != {next_line_length}")

            # ご検知も多いため適宜ONにする
            # if line_length == len(line):
            #     print(f"{file}:{i}  Header might be not translated: {line}")

if __name__ == "__main__":
    check_terms()
    check_kuten()
    check_headers()