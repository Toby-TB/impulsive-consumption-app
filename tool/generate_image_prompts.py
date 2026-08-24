# -*- coding: utf-8 -*-
"""为全部商品生成统一风格的 AI 绘图提示词（Midjourney / Stable Diffusion）。

输出 docs/ai-image-prompts.md，用于：
1. 图文不符时的重绘参考；
2. 未来扩充商品时的视觉风格基线。
"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

CATEGORY_STYLE = {
    1: ("sleek tech product photography", "cool grey backdrop, cyan rim light"),
    2: ("minimal office gear photography", "light desk scene, soft daylight"),
    3: ("clean home appliance photography", "bright kitchen counter, airy white"),
    4: ("premium audio product shot", "dark studio, warm accent light"),
    5: ("fashion lookbook still life", "pastel seamless backdrop, gentle shadow"),
    6: ("cosmetic product macro", "glossy podium, dewy highlights"),
    7: ("appetizing food photography", "rustic wooden table, natural window light"),
    8: ("cozy lifestyle product photo", "warm home interior blur, soft tones"),
    9: ("dynamic sports product shot", "energetic gradient backdrop, motion feel"),
    10: ("cute kiddy product photography", "playful pastel set, rounded props"),
    11: ("artistic flat-lay photography", "textured paper background, top-down"),
    12: ("warm pet product photography", "cozy living room, soft bokeh"),
}

MJ_TEMPLATE = (
    "commercial e-commerce product photo of {subject}, {style}, "
    "{lighting}, 45-degree hero angle, centered composition, "
    "high detail, realistic materials, 4k --ar 1:1 --style raw --v 6"
)

SD_TEMPLATE = (
    "(masterpiece, best quality), product photography, {subject}, "
    "{style}, {lighting}, studio lighting, sharp focus, "
    "no text, no watermark, square composition "
    "Negative prompt: blurry, lowres, text, watermark, deformed, extra limbs"
)


def subject_of(p):
    kw = p.get("imageKeyword", "product")
    brand = p["brand"]["en"]
    return f"{kw} ({brand} style generic)"


def main():
    data = json.loads((ROOT / "assets/data/products.json").read_text(encoding="utf-8"))
    lines = ["# AI 商品图提示词（Midjourney / SD）", ""]
    for cat in data["categories"]:
        lines.append(f"## {cat['name']['zhHans']} · {cat['name']['en']}")
        lines.append("")
        style, lighting = CATEGORY_STYLE[cat["id"]]
        for p in data["products"]:
            if p["categoryId"] != cat["id"]:
                continue
            subj = subject_of(p)
            lines.append(f"### p{p['id']:03d} · {p['name']['en']}")
            lines.append(f"- **MJ**: {MJ_TEMPLATE.format(subject=subj, style=style, lighting=lighting)}")
            lines.append(f"- **SD**: {SD_TEMPLATE.format(subject=subj, style=style, lighting=lighting)}")
            lines.append("")
    out = ROOT / "docs" / "ai-image-prompts.md"
    out.write_text("\n".join(lines), encoding="utf-8")
    print(f"wrote {out} ({len(data['products'])} products)")


if __name__ == "__main__":
    main()
