"""Render kaist-ai-logo.svg to PNG using matplotlib (no inkscape needed)."""
import xml.etree.ElementTree as ET
import re, numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.path import Path
from matplotlib.patches import PathPatch, Polygon

VBW, VBH = 188.2, 48.8
COLORS = {'st0': '#004C98', 'st1': '#111516'}

def flip(y): return VBH - y

def pts_from_str(s):
    nums = [float(x) for x in re.findall(r'[-+]?\d*\.?\d+', s)]
    return [(nums[i], flip(nums[i+1])) for i in range(0, len(nums)-1, 2)]

def parse_d(d):
    verts, codes = [], []
    tokens = re.findall(r'[MmHhVvCcSsLlZz]|[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?', d)
    idx = 0
    cx, cy, sx, sy, px2, py2 = 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

    def take(n):
        nonlocal idx
        vals = [float(tokens[idx+k]) for k in range(n)]
        idx += n
        return vals

    while idx < len(tokens):
        cmd = tokens[idx]; idx += 1
        if not re.match(r'[MmHhVvCcSsLlZz]', cmd):
            continue
        while idx < len(tokens):
            nxt = tokens[idx]
            if re.match(r'[MmHhVvCcSsLlZz]', nxt):
                break
            try:
                if cmd == 'M':
                    x,y = take(2); verts.append((x,flip(y))); codes.append(Path.MOVETO)
                    cx,cy,sx,sy = x,y,x,y; cmd='L'
                elif cmd == 'm':
                    dx,dy=take(2); cx+=dx; cy+=dy; verts.append((cx,flip(cy))); codes.append(Path.MOVETO)
                    sx,sy=cx,cy; cmd='l'
                elif cmd == 'H':
                    cx=take(1)[0]; verts.append((cx,flip(cy))); codes.append(Path.LINETO)
                elif cmd == 'h':
                    cx+=take(1)[0]; verts.append((cx,flip(cy))); codes.append(Path.LINETO)
                elif cmd == 'V':
                    cy=take(1)[0]; verts.append((cx,flip(cy))); codes.append(Path.LINETO)
                elif cmd == 'v':
                    cy+=take(1)[0]; verts.append((cx,flip(cy))); codes.append(Path.LINETO)
                elif cmd == 'L':
                    cx,cy=take(2); verts.append((cx,flip(cy))); codes.append(Path.LINETO)
                elif cmd == 'l':
                    dx,dy=take(2); cx+=dx; cy+=dy; verts.append((cx,flip(cy))); codes.append(Path.LINETO)
                elif cmd in ('C','c'):
                    x1,y1,x2,y2,x,y=take(6)
                    if cmd=='c': x1+=cx;y1+=cy;x2+=cx;y2+=cy;x+=cx;y+=cy
                    verts+=[(x1,flip(y1)),(x2,flip(y2)),(x,flip(y))]; codes+=[Path.CURVE4]*3
                    px2,py2,cx,cy=x2,y2,x,y
                elif cmd in ('S','s'):
                    x2,y2,x,y=take(4)
                    if cmd=='s': x2+=cx;y2+=cy;x+=cx;y+=cy
                    rx1,ry1=2*cx-px2,2*cy-py2
                    verts+=[(rx1,flip(ry1)),(x2,flip(y2)),(x,flip(y))]; codes+=[Path.CURVE4]*3
                    px2,py2,cx,cy=x2,y2,x,y
                elif cmd in ('Z','z'):
                    verts.append((sx,flip(sy))); codes.append(Path.CLOSEPOLY); cx,cy=sx,sy; break
            except (IndexError, ValueError):
                break
    return np.array(verts) if verts else np.zeros((1,2)), codes

def get_fill(el):
    cls = el.get('class','')
    return COLORS.get(cls)

fig, ax = plt.subplots(figsize=(VBW/48, VBH/48))
ax.set_xlim(0, VBW); ax.set_ylim(0, VBH)
ax.set_aspect('equal'); ax.axis('off')
fig.patch.set_alpha(0); ax.patch.set_alpha(0)
ax.set_position([0,0,1,1])

tree = ET.parse('figures/kaist-ai-logo.svg')
root = tree.getroot()

for el in root.iter():
    tag = el.tag.split('}')[-1] if '}' in el.tag else el.tag
    color = get_fill(el)
    if color is None:
        continue
    if tag == 'rect':
        x,y = float(el.get('x',0)), float(el.get('y',0))
        w,h = float(el.get('width',0)), float(el.get('height',0))
        ax.add_patch(mpatches.Rectangle((x, flip(y)-h), w, h, facecolor=color, linewidth=0))
    elif tag == 'polygon':
        pts = pts_from_str(el.get('points',''))
        if pts:
            ax.add_patch(Polygon(pts, closed=True, facecolor=color, linewidth=0))
    elif tag == 'path':
        d = el.get('d','')
        if d:
            try:
                verts, codes = parse_d(d)
                if len(verts) > 1:
                    ax.add_patch(PathPatch(Path(verts, codes), facecolor=color, linewidth=0))
            except Exception as e:
                print(f"path err: {e}")

plt.savefig('figures/kaist-ai-logo.png', dpi=300, bbox_inches='tight',
            pad_inches=0.02, transparent=True, facecolor='none')
print("Saved figures/kaist-ai-logo.png")
