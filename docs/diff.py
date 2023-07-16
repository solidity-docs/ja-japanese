import re

"""
ただ改行するだけの変更かどうかを判別
"""

a = """
"""

b = """
"""

a = a.split("\n")
for i in range(len(a)):
    if a[i].startswith("-"):
        a[i] = a[i][1:]

b = b.split("\n")
for i in range(len(b)):
    if b[i].startswith("+"):
        b[i] = b[i][1:]

a = " ".join(a).replace(".", ".\n").split("\n")
b = " ".join(b).replace(".", ".\n").split("\n")

for x, y in zip(a, b):
    x , y = x.strip(), y.strip()
    x = re.sub(r"\s+", " ", x)
    y = re.sub(r"\s+", " ", y)
    if x != y:
        print(x)
        print(y)
        print()