"""
Save just the text portion (DAVIAN wordmark + subtitle) from the GitHub avatar
as a standalone PNG, without the diamond-graph icon.

The avatar has icon on top and text on bottom; we detect the gap automatically
and discard the icon half.
"""
from PIL import Image
import urllib.request, io
import numpy as np

url = 'https://avatars.githubusercontent.com/u/60700119?s=800&v=4'
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
with urllib.request.urlopen(req, timeout=15) as r:
    src = Image.open(io.BytesIO(r.read())).convert('RGBA')

W, H = src.size
alpha = np.array(src)[:, :, 3]

# Detect the blank gap between icon (top) and text (bottom)
lo, hi = int(H * 0.30), int(H * 0.65)
row_mass = alpha[lo:hi, :].sum(axis=1)
gap_row = lo + int(row_mass.argmin())

text_arr = np.array(src)[gap_row:, :, :]

def trim_arr(a):
    mask = a[:, :, 3] > 0
    rows = np.any(mask, axis=1)
    cols = np.any(mask, axis=0)
    r0, r1 = np.where(rows)[0][[0, -1]]
    c0, c1 = np.where(cols)[0][[0, -1]]
    return a[r0:r1+1, c0:c1+1]

text_trim = Image.fromarray(trim_arr(text_arr))

TARGET_H = 400   # taller → more resolution for crisp text at small render size
w = max(1, round(text_trim.width * TARGET_H / text_trim.height))
out = text_trim.resize((w, TARGET_H), Image.LANCZOS)

out.save('figures/davian-logo.png', dpi=(300, 300))
print(f"Saved  {out.size[0]}×{out.size[1]}  (gap row={gap_row})")
