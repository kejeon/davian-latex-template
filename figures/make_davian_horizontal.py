"""
Create a horizontal DAVIAN logo for the header:
  [icon]  DAVIAN
          Data and Visual Analytics Lab

Uses the existing square avatar, crops icon and text portions,
then composites them side-by-side on a transparent background.
"""
from PIL import Image, ImageDraw
import urllib.request

# Fetch a larger version for better resolution
url = 'https://avatars.githubusercontent.com/u/60700119?s=800&v=4'
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
with urllib.request.urlopen(req, timeout=15) as r:
    data = r.read()

import io
src = Image.open(io.BytesIO(data)).convert('RGBA')
W, H = src.size   # 800 × 800

def trim(img):
    """Crop to content bounding box (removes transparent padding)."""
    bbox = img.getbbox()
    return img.crop(bbox) if bbox else img

# ── Split: icon (upper 48%) and text block (lower 52%) ──────────────────────
icon_region = trim(src.crop((0, 0, W, int(H * 0.48))))
text_region = trim(src.crop((0, int(H * 0.46), W, H)))

# Target height for the final horizontal image (300 px @ 300 DPI = 1 inch)
TARGET_H = 300

def scale_to_height(img, h):
    aspect = img.width / img.height
    return img.resize((int(h * aspect), h), Image.LANCZOS)

icon_scaled = scale_to_height(icon_region, TARGET_H)
text_scaled  = scale_to_height(text_region,  TARGET_H)

# Composite side-by-side with a small gap
GAP = int(TARGET_H * 0.10)
total_w = icon_scaled.width + GAP + text_scaled.width
canvas = Image.new('RGBA', (total_w, TARGET_H), (0, 0, 0, 0))
canvas.paste(icon_scaled, (0, 0))
canvas.paste(text_scaled, (icon_scaled.width + GAP, 0))

canvas.save('figures/davian-logo.png', dpi=(300, 300))
print(f"Saved figures/davian-logo.png  ({canvas.size[0]}×{canvas.size[1]} px)")
