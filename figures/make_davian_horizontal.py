"""
Create a horizontal DAVIAN logo for the header:
  [icon]  DAVIAN
          Data and Visual Analytics Lab

Finds the natural empty gap between icon and text (no hardcoded fractions),
then composites icon + text side-by-side, each vertically centered.
"""
from PIL import Image
import urllib.request, io
import numpy as np

# Fetch a large version for crispness
url = 'https://avatars.githubusercontent.com/u/60700119?s=800&v=4'
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
with urllib.request.urlopen(req, timeout=15) as r:
    src = Image.open(io.BytesIO(r.read())).convert('RGBA')

W, H = src.size          # 800 × 800
alpha = np.array(src)[:, :, 3]   # opaque-pixel count per row

# ── Find the natural blank gap between icon (top) and text (bottom) ──────────
# Scan rows in the middle 30-70% of the image; pick the emptiest row.
lo, hi = int(H * 0.30), int(H * 0.65)
row_mass = alpha[lo:hi, :].sum(axis=1)
gap_row = lo + int(row_mass.argmin())     # row with fewest opaque pixels

icon_arr = np.array(src)[: gap_row, :, :]
text_arr = np.array(src)[gap_row :, :, :]

def trim_arr(a):
    """Crop a numpy RGBA array to its content bounding box."""
    mask = a[:, :, 3] > 0
    rows = np.any(mask, axis=1)
    cols = np.any(mask, axis=0)
    r0, r1 = np.where(rows)[0][[0, -1]]
    c0, c1 = np.where(cols)[0][[0, -1]]
    return a[r0:r1+1, c0:c1+1]

icon_trim = Image.fromarray(trim_arr(icon_arr))
text_trim = Image.fromarray(trim_arr(text_arr))

# ── Scale both to TARGET_H, then vertically center on a shared canvas ────────
TARGET_H = 300

def scale_h(img, h):
    w = max(1, round(img.width * h / img.height))
    return img.resize((w, h), Image.LANCZOS)

icon_s = scale_h(icon_trim, TARGET_H)
text_s = scale_h(text_trim, TARGET_H)

GAP   = round(TARGET_H * 0.12)
total = icon_s.width + GAP + text_s.width

canvas = Image.new('RGBA', (total, TARGET_H), (0, 0, 0, 0))
# paste icon top-aligned (it already fills the height)
canvas.paste(icon_s, (0, 0), icon_s)
# paste text top-aligned alongside it
canvas.paste(text_s, (icon_s.width + GAP, 0), text_s)

canvas.save('figures/davian-logo.png', dpi=(300, 300))
print(f"Saved  {canvas.size[0]}×{canvas.size[1]}  (gap row={gap_row})")
