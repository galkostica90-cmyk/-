#!/usr/bin/env python3
"""Generate placeholder store screenshots for Android and iOS.

Usage: python tools/generate_store_assets.py
Requires pillow (pip install pillow)
"""
from PIL import Image, ImageDraw, ImageFont
import os

OUT_ANDROID = 'fastlane/metadata/android/en-US/images/phoneScreenshots'
OUT_IOS = 'fastlane/metadata/ios/en-US/itunes_connect_screenshots/iphone_x'

os.makedirs(OUT_ANDROID, exist_ok=True)
os.makedirs(OUT_IOS, exist_ok=True)

def make_image(path, size, text):
    img = Image.new('RGB', size, color=(10, 90, 160))
    d = ImageDraw.Draw(img)
    try:
        f = ImageFont.truetype('DejaVuSans-Bold.ttf', 48)
    except Exception:
        f = ImageFont.load_default()
    text_w, text_h = d.textsize(text, font=f)
    d.text(((size[0]-text_w)/2, (size[1]-text_h)/2), text, font=f, fill=(255,255,255))
    img.save(path, format='PNG', optimize=True)

print('Generating Android screenshots...')
make_image(os.path.join(OUT_ANDROID, '1.png'), (1080, 1920), 'Attendance — Android')
make_image(os.path.join(OUT_ANDROID, '2.png'), (1080, 1920), 'Check In / Check Out')

print('Generating iOS screenshots...')
make_image(os.path.join(OUT_IOS, '1.png'), (1125, 2436), 'Attendance — iPhone')
make_image(os.path.join(OUT_IOS, '2.png'), (1125, 2436), 'Reports')

print('Done. Place final screenshots in fastlane/metadata/... then run fastlane deliver / supply to upload.')
