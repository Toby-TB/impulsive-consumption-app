# -*- coding: utf-8 -*-
"""生成 assets/data/products.json：三语商品种子数据。"""
import json
import random
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from products_data_a import BRANDS, CATEGORIES, PRODUCTS_A
from products_data_b import PRODUCTS_B


def loc(b_en_zh_zht):
    return {"en": b_en_zh_zht[0], "zhHans": b_en_zh_zht[1], "zhHant": b_en_zh_zht[2]}


def compose(p, cat_id):
    brand = BRANDS[p["b"]]
    t = p["t"]
    s = p["s"]

    def name(lang_key):
        idx = {"en": 0, "zhHans": 1, "zhHant": 2}[lang_key]
        parts = [brand[idx]]
        if p["m"]:
            parts.append(p["m"])
        parts.append(t[lang_key])
        if s:
            parts.append(s)
        return " ".join(parts)

    return {
        "name": {
            "en": name("en"),
            "zhHans": name("zhHans"),
            "zhHant": name("zhHant"),
        },
        "subtitle": dict(p["f"]),
        "description": {
            "en": f"{p['f']['en']} A favorite pick from our {t['en'].lower()} selection.",
            "zhHans": f"{p['f']['zhHans']}来自{BRANDS[p['b']][1]}的热销之选，品质与口碑双在线。",
            "zhHant": f"{p['f']['zhHant']}來自{BRANDS[p['b']][2]}的熱銷之選，品質與口碑雙在線。",
        },
    }


def main():
    rng = random.Random(20260823)
    # 品类7-12 使用语义合适的品牌池（数据文件里的 b 仅作占位）
    BRAND_POOL = {
        7: [28, 29, 30, 31],   # 食品生鲜
        8: [32, 33, 34],       # 家居日用
        9: [35, 36],           # 运动户外
        10: [37, 38],          # 母婴玩具
        11: [39, 40],          # 图书文娱
        12: [41, 40],          # 宠物生活
    }
    products_out = []
    pid = 0
    for cat in CATEGORIES:
        cid = cat["id"]
        for p in PRODUCTS_A.get(cid, []) + PRODUCTS_B.get(cid, []):
            pid += 1
            if cid in BRAND_POOL:
                p = dict(p)
                p["b"] = rng.choice(BRAND_POOL[cid])
            base = compose(p, cid)
            stock = p["stock"] or rng.randrange(60, 980)
            sales = p["sales"] or rng.randrange(800, 60000)
            rating = p["rating"] or round(rng.uniform(4.3, 4.95), 1)
            products_out.append({
                "id": pid,
                "categoryId": cid,
                "brand": {"en": BRANDS[p["b"]][0], "zhHans": BRANDS[p["b"]][1], "zhHant": BRANDS[p["b"]][2]},
                "model": p["m"],
                "name": base["name"],
                "subtitle": base["subtitle"],
                "description": base["description"],
                "priceCents": p["price"],
                "originalPriceCents": max(p["orig"], p["price"]),
                "stock": stock,
                "sales": sales,
                "rating": rating,
                "tags": p["tags"],
                "flashSale": p["flash"],
                "imageKeyword": p["img"],
                "lock": 100 + pid * 7,
            })

    data = {"categories": CATEGORIES, "products": products_out}
    out = Path(__file__).resolve().parent.parent / "assets" / "data" / "products.json"
    out.write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding="utf-8")

    # 校验
    assert len(products_out) >= 140, len(products_out)
    ids = [x["id"] for x in products_out]
    assert ids == sorted(ids) and len(set(ids)) == len(ids)
    flash = sum(1 for x in products_out if x["flashSale"])
    print(f"OK categories={len(CATEGORIES)} products={len(products_out)} flashSale={flash}")
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
