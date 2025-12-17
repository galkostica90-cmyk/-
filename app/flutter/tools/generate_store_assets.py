#!/usr/bin/env python3
"""Generate placeholder store screenshots for Android and iOS.

Usage: python tools/generate_store_assets.py
Requires pillow (pip install pillow)
"""
from PIL import Image, ImageDraw, ImageFont
import os

OUT_ANDROID = 'fastlane/metadata/android/en-US/images/phoneScreenshots'
OUT_IOS = 'fastlane/metadata/ios/en-US/itunes_connect_screenshots/iphone_x'
OUT_ICONS = 'fastlane/metadata/icons'

os.makedirs(OUT_ANDROID, exist_ok=True)
os.makedirs(OUT_IOS, exist_ok=True)
os.makedirs(OUT_ICONS, exist_ok=True)

def make_image(path, size, text, font_size=48):
    img = Image.new('RGB', size, color=(10, 90, 160))
    d = ImageDraw.Draw(img)
    try:
        f = ImageFont.truetype('DejaVuSans-Bold.ttf', font_size)
    except Exception:
        f = ImageFont.load_default()
    try:
        bbox = d.textbbox((0,0), text, font=f)
        text_w = bbox[2] - bbox[0]
        text_h = bbox[3] - bbox[1]
    except Exception:
        text_w, text_h = d.textsize(text, font=f)
    d.text(((size[0]-text_w)/2, (size[1]-text_h)/2), text, font=f, fill=(255,255,255))
    img.save(path, format='PNG', optimize=True)

print('Generating Android screenshots...')
make_image(os.path.join(OUT_ANDROID, '1.png'), (1080, 1920), 'Attendance — Android')
make_image(os.path.join(OUT_ANDROID, '2.png'), (1080, 1920), 'Check In / Check Out')

print('Generating iOS screenshots...')
make_image(os.path.join(OUT_IOS, '1.png'), (1125, 2436), 'Attendance — iPhone')
make_image(os.path.join(OUT_IOS, '2.png'), (1125, 2436), 'Reports')

print('Generating icon assets...')
# Create a 1024x1024 App Store icon and a 512x512 Play icon
make_image(os.path.join(OUT_ICONS, 'icon_1024.png'), (1024, 1024), 'Attendance', font_size=180)
make_image(os.path.join(OUT_ICONS, 'icon_512.png'), (512, 512), 'Attendance', font_size=96)

# Also copy a placeholder into app assets
icon_dest = 'app/flutter/assets/icon_large.png'
make_image(icon_dest, (1024, 1024), 'Attendance', font_size=180)

print('Done. Place final screenshots and icons in fastlane/metadata/... then run fastlane deliver / supply to upload.')
