#!/usr/bin/env python3
"""Generate a simple 'AI-style' clock icon and export various sizes.
Creates icons in fastlane/metadata/icons and app/flutter/assets.
"""
from PIL import Image, ImageDraw, ImageFilter
import os

OUT_ICONS = 'fastlane/metadata/icons'
APP_ASSETS = 'app/flutter/assets'

os.makedirs(OUT_ICONS, exist_ok=True)
os.makedirs(APP_ASSETS, exist_ok=True)

def make_clock(size, bg=(8,95,170), face=(255,255,255), rim=(230,230,230), hands=(15,15,40)):
    w,h = size,size
    img = Image.new('RGBA', (w,h), (0,0,0,0))
    draw = ImageDraw.Draw(img)

    # background circle
    draw.ellipse([(0,0),(w,h)], fill=bg)

    # inner face
    margin = int(w*0.12)
    draw.ellipse([(margin,margin),(w-margin,h-margin)], fill=face)

    # rim shadow
    rim_w = int(w*0.02)
    draw.ellipse([(margin-rim_w,margin-rim_w),(w-margin+rim_w,h-margin+rim_w)], outline=rim, width=rim_w)

    # center dot
    cx,cy = w//2, h//2
    draw.ellipse([(cx-6,cy-6),(cx+6,cy+6)], fill=hands)

    # hour hand (pointing roughly to 10)
    hx1,hy1 = cx, cy
    hx2,hy2 = cx - int(w*0.18), cy - int(h*0.12)
    draw.line([(hx1,hy1),(hx2,hy2)], fill=hands, width=int(w*0.06), joint='curve')

    # minute hand (pointing to 2)
    mx2,my2 = cx + int(w*0.22), cy - int(h*0.22)
    draw.line([(cx,cy),(mx2,my2)], fill=hands, width=int(w*0.04))

    # ticks
    for i in range(12):
        import math
        angle = math.radians(i*30 - 90)
        outer_x = cx + (w//2 - margin//2) * math.cos(angle)
        outer_y = cy + (h//2 - margin//2) * math.sin(angle)
        inner_x = cx + (w//2 - margin - int(w*0.03)) * math.cos(angle)
        inner_y = cy + (h//2 - margin - int(w*0.03)) * math.sin(angle)
        draw.line([(inner_x, inner_y), (outer_x, outer_y)], fill=(200,200,200), width=max(1,int(w*0.01)))

    # subtle glow
    glow = img.filter(ImageFilter.GaussianBlur(radius=max(1,int(w*0.02))))
    blended = Image.alpha_composite(Image.new('RGBA',(w,h),(0,0,0,0)), glow)
    final = Image.alpha_composite(blended, img)

    return final

sizes = [1024, 512, 180, 120, 96, 72, 48]
for s in sizes:
    img = make_clock(s)
    path = os.path.join(OUT_ICONS, f'icon_{s}.png')
    img.convert('RGBA').save(path)
    print('Wrote', path)

# write a large app asset
img = make_clock(1024)
asset_path = os.path.join(APP_ASSETS, 'icon_clock.png')
img.convert('RGBA').save(asset_path)
print('Wrote', asset_path)
