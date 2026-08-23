# -*- coding: utf-8 -*-
"""从 Wikimedia Commons 按 imageKeyword 抓取真实商品图（JPEG 640px）。"""
import json
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "images" / "products"
UA = {"User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0"}
MIN_BYTES = 3000


def http_json(url):
    last = None
    for i in range(4):
        try:
            req = urllib.request.Request(url, headers=UA)
            with urllib.request.urlopen(req, timeout=25) as r:
                return json.loads(r.read().decode("utf-8"))
        except Exception as e:  # 限流/网络抖动 → 指数退避
            last = e
            time.sleep(1.5 * (i + 1))
    raise last


def http_get(url):
    last = None
    for i in range(2):
        try:
            req = urllib.request.Request(url, headers=UA)
            with urllib.request.urlopen(req, timeout=20) as r:
                return r.read()
        except Exception as e:
            last = e
            code = getattr(e, "code", None)
            time.sleep(6.0 if code in (403, 429) else 1.0)
    raise last


def is_jpeg(data: bytes) -> bool:
    return len(data) >= MIN_BYTES and data[:2] == b"\xff\xd8"


def candidates(keyword: str):
    q = urllib.parse.quote(f"{keyword} filetype:bitmap")
    url = (
        "https://commons.wikimedia.org/w/api.php?action=query&format=json"
        "&prop=imageinfo&iiprop=url%7Csize%7Cmime&iiurlwidth=500"
        "&generator=search&gsrnamespace=6&gsrlimit=10&gsrsearch=" + q
    )
    try:
        d = http_json(url)
    except Exception:
        return []
    time.sleep(0.25)
    pages = d.get("query", {}).get("pages", {})
    ranked = sorted(pages.values(), key=lambda p: p.get("index", 99))
    out = []
    for pg in ranked:
        for ii in pg.get("imageinfo", []):
            if ii.get("mime") != "image/jpeg":
                continue
            if ii.get("width", 0) < 640:
                continue
            w, h = ii.get("width"), ii.get("height")
            if h and not (0.35 <= (w / h) <= 3.5):
                continue
            thumb = ii.get("thumburl") or ii.get("url")
            if thumb:
                out.append(thumb)
        if out:
            break
    return out


def grab_url(pid: int, url: str):
    dest = OUT / f"p{pid:03d}.jpg"
    if dest.exists() and is_jpeg(dest.read_bytes()):
        return pid, "cached"
    for round_ in range(2):
        try:
            data = http_get(url)
            if is_jpeg(data):
                dest.write_bytes(data)
                return pid, "ok"
        except Exception:
            time.sleep(1.0)
    return pid, "FAILED"


def main():
    data = json.loads((ROOT / "assets" / "data" / "products.json").read_text(encoding="utf-8"))
    products = [p for p in data["products"]
                if not (OUT / f"p{p['id']:03d}.jpg").exists()]  # 只处理缺失项
    print(f"missing: {len(products)}")

    # 1) 按关键词去重搜索（大幅减少 API 调用）
    kw_cache = {}
    for p in products:
        kw = p["imageKeyword"]
        if kw not in kw_cache:
            kw_cache[kw] = candidates(kw)
            print(f"  search [{kw}] -> {len(kw_cache[kw])} cands")

    # 2) 同关键词商品轮换不同候选图，下载并行（upload 主机限流宽松）
    jobs = []
    kw_counter = {}
    for p in products:
        pid, kw = p["id"], p["imageKeyword"]
        cands = kw_cache.get(kw) or []
        if not cands:
            jobs.append((pid, None))
            continue
        idx = kw_counter.get(kw, 0)
        kw_counter[kw] = idx + 1
        jobs.append((pid, cands[idx % len(cands)]))

    results = {}
    consecutive_fail = 0
    for job in jobs:  # 严格串行 + 大间隔节流，避免触发 CDN 封禁
        pid_, status = work(job)
        results[pid_] = status
        if status == "FAILED":
            consecutive_fail += 1
            if consecutive_fail >= 4:
                print("  cooldown 75s ...")
                time.sleep(75)
                consecutive_fail = 0
        else:
            consecutive_fail = 0
            time.sleep(3.0)

    failed = sorted(pid for pid, s in results.items() if s == "FAILED")
    ok = sum(1 for s in results.values() if s != "FAILED")
    print(f"fetched/cached={ok} failed={len(failed)} {failed}")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
