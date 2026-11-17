#!/usr/bin/env python3
"""Ashen Crown equipment progression checker.

Reads the real GML data (scr_item_data, scr_shop_data, scr_enemy_database,
scr_game_constants) and checks the eight-act equipment progression:

  1. Data integrity: duplicate item ids, equipment missing rarity/act/acquisition/desc,
     unknown classes or weapon categories, recipes that reference missing items or try to
     craft a legendary, shop stock ids that do not exist, legendaries with no drop source.
  2. Progression: best-in-slot party stats per act (base stats + level growth + gear),
     and how those numbers fare against every boss the game actually defines.
  3. Reachability: which gear is obtainable in the built content (shop / drop / craft) and
     which only exists as data for acts that are not built yet.

Mirrors battle math: damage = max(1, ATK - floor(DEF/2)); growth from scr_level_growth
(low growth to L7, high growth from L8). Run: python3 tools/equipment_check.py
Exit code 0 = checks pass (warnings allowed), 1 = a data error.
"""
import math
import re
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ITEM_FILE = ROOT / "game/scripts/scr_item_data.gml"
SHOP_FILE = ROOT / "game/scripts/scr_shop_data.gml"
ENEMY_FILE = ROOT / "game/scripts/scr_enemy_database.gml"
CONST_FILE = ROOT / "game/scripts/scr_game_constants.gml"
PARTY_FILE = ROOT / "game/scripts/scr_party.gml"

ACT_BANDS = {1: (1, 7), 2: (8, 10), 3: (11, 14), 4: (15, 17),
             5: (17, 19), 6: (19, 21), 7: (21, 23), 8: (23, 24)}
CLASS_WEAPON = {"Vanguard": "longsword", "Rogue": "dagger", "Arcanist": "spellbook",
                "Warden": "holy_sword", "Rebel Captain": "heavy_sword"}
MEMBERS = {"kael": "Vanguard", "lyra": "Rogue", "caelan": "Arcanist",
           "sera": "Warden", "taren": "Rebel Captain"}

errors = []
warnings = []


def fail(msg):
    errors.append(msg)


def warn(msg):
    warnings.append(msg)


def read(path):
    return path.read_text(encoding="utf-8")


def macros(path):
    out = {}
    for line in read(path).splitlines():
        m = re.match(r"\s*#macro\s+(\w+)\s+(-?\d+(?:\.\d+)?)\s*$", line)
        if m:
            out[m.group(1)] = float(m.group(2))
    return out


def num(body, key, default=0):
    m = re.search(rf"\b{key}:\s*(-?\d+)", body)
    return int(m.group(1)) if m else default


def flag(body, key):
    return re.search(rf"\b{key}:\s*true\b", body) is not None


def text(body, key, default=""):
    m = re.search(rf'\b{key}:\s*"([^"]*)"', body)
    return m.group(1) if m else default


def id_list(body, key):
    m = re.search(rf"\b{key}:\s*\[([^\]]*)\]", body)
    if not m:
        return []
    return re.findall(r'"([^"]+)"', m.group(1))


# ---- items ------------------------------------------------------------------------------------
ITEMS = {}


def parse_items():
    src = read(ITEM_FILE)
    pat = re.compile(
        r'scr_item_make\(\s*"([a-z_0-9]+)"\s*,\s*"([^"]*)"\s*,\s*"(\w+)"\s*,\s*(\d+)\s*,'
        r'\s*\{(.*?)\}\s*\)\s*\)\s*;', re.S)
    for m in pat.finditer(src):
        body = m.group(5)
        item = {
            "id": m.group(1), "name": m.group(2), "kind": m.group(3), "price": int(m.group(4)),
            "atk": num(body, "atk_bonus"), "def": num(body, "def_bonus"),
            "mdef": num(body, "mdef_bonus"), "spd": num(body, "spd_bonus"),
            "rarity": text(body, "rarity", "common"), "act": num(body, "act", 0),
            "classes": id_list(body, "classes"), "unique": flag(body, "unique"),
            "acquisition": text(body, "acquisition"), "desc": text(body, "desc"),
            "categories": id_list(body, "weapon_categories"),
        }
        if item["id"] in ITEMS:
            fail(f"duplicate item id: {item['id']}")
        ITEMS[item["id"]] = item

    # The metadata pass at the end of scr_item_database() gives old items act/rarity/source.
    meta = re.search(r"var _meta = \{(.*?)\n    \};", src, re.S)
    if meta:
        for m in re.finditer(r"(item_[a-z0-9_]+):\s*\{(.*?)\}", meta.group(1), re.S):
            item = ITEMS.get(m.group(1))
            if not item:
                continue
            body = m.group(2)
            if re.search(r"rarity:", body):
                item["rarity"] = text(body, "rarity", item["rarity"])
            if re.search(r"act:", body):
                item["act"] = num(body, "act", item["act"])
            if re.search(r"acquisition:", body):
                item["acquisition"] = text(body, "acquisition", item["acquisition"])
            if flag(body, "unique"):
                item["unique"] = True


def parse_craft():
    src = read(ITEM_FILE)
    block = re.search(r"function scr_craft_recipes\(\) \{\s*return \[(.*?)\n    \];", src, re.S)
    recipes = []
    if not block:
        fail("scr_craft_recipes() not found")
        return recipes
    for m in re.finditer(r"\{ result: \"(item_[a-z0-9_]+)\", act: (\d+), gold: (\d+), materials: \[(.*?)\] \}", block.group(1)):
        mats = [(i, int(q)) for i, q in re.findall(r'\{ item: "(item_[a-z0-9_]+)", qty: (\d+) \}', m.group(4))]
        recipes.append({"result": m.group(1), "act": int(m.group(2)),
                        "gold": int(m.group(3)), "materials": mats})
    return recipes


# ---- enemies ----------------------------------------------------------------------------------
ENEMIES = {}


def parse_enemies():
    src = read(ENEMY_FILE)
    for m in re.finditer(r'return \{ id: "(\w+)", level: (\d+), name: "([^"]*)"(.*?)\};', src, re.S):
        body = m.group(4)
        ENEMIES[m.group(1)] = {
            "id": m.group(1), "level": int(m.group(2)), "name": m.group(3),
            "hp": num(body, "max_hp"), "atk": num(body, "attack"), "def": num(body, "defense"),
            "boss": flag(body, "is_boss"),
        }
    # Scaled template: mirrors scr_enemy_scaled (asserted below).
    for m in re.finditer(
            r'scr_enemy_scaled\(\s*"(\w+)"\s*,\s*"([^"]*)"\s*,\s*"[^"]*"\s*,\s*"(\w+)"\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*\{(.*?)\}\s*\)\s*;',
            src, re.S):
        eid, name, role, level, party, body = m.group(1), m.group(2), m.group(3), int(m.group(4)), int(m.group(5)), m.group(6)
        d = level - 9
        hp, atk, df = 44 + 9 * d, 13 + 3 * d, 11 + 2 * d
        if role == "elite":
            hp, atk, df = hp * 2, atk + 2, df + 2
        if role == "boss":
            hp, atk, df = round(hp * 1.2 * max(1, party)), atk + 3, df + 3
        hp = round(hp * (float(text(body, "hp_mult", "1")) if re.search(r"hp_mult:", body) else 1))
        atk += num(body, "atk_add")
        df += num(body, "def_add")
        ENEMIES[eid] = {"id": eid, "level": level, "name": name, "hp": hp, "atk": atk,
                        "def": df, "boss": role == "boss"}


# ---- party ------------------------------------------------------------------------------------
def parse_constants():
    c = macros(CONST_FILE)
    for key in ("KAEL_BASE_HP", "KAEL_BASE_ATTACK", "KAEL_BASE_DEFENSE",
                "LYRA_BASE_HP", "LYRA_BASE_ATTACK", "LYRA_BASE_DEFENSE",
                "CAELAN_BASE_HP", "CAELAN_BASE_ATTACK", "CAELAN_BASE_DEFENSE",
                "SERA_BASE_HP", "SERA_BASE_ATTACK", "SERA_BASE_DEFENSE",
                "TAREN_BASE_HP", "TAREN_BASE_ATTACK", "TAREN_BASE_DEFENSE",
                "LEVEL_UP_TIER_LEVEL"):
        if key not in c:
            fail(f"constant {key} missing from scr_game_constants.gml")
    return c


def growth(c):
    low = {"hp": c.get("LEVEL_UP_HP_GROWTH", 4), "atk": c.get("LEVEL_UP_ATTACK_GROWTH", 1),
           "def": c.get("LEVEL_UP_DEFENSE_GROWTH", 1)}
    high = {"hp": c.get("LEVEL_UP_HP_GROWTH_HIGH", 10), "atk": c.get("LEVEL_UP_ATTACK_GROWTH_HIGH", 2),
            "def": c.get("LEVEL_UP_DEFENSE_GROWTH_HIGH", 2)}
    tier = int(c.get("LEVEL_UP_TIER_LEVEL", 8))
    return low, high, tier


def member_base(c, mid):
    up = mid.upper()
    return {"hp": c[f"{up}_BASE_HP"], "atk": c[f"{up}_BASE_ATTACK"],
            "def": c[f"{up}_BASE_DEFENSE"]}


def member_at(c, mid, level):
    base = member_base(c, mid)
    low, high, tier = growth(c)
    for lv in range(2, level + 1):
        g = high if lv >= tier else low
        for k in ("hp", "atk", "def"):
            base[k] += g[k]
    return base


def best_gear(act, cls):
    cat = CLASS_WEAPON[cls]
    weapon = None
    for item in ITEMS.values():
        if item["kind"] != "weapon" or item["act"] > act:
            continue
        if item["categories"] and cat not in item["categories"]:
            continue
        if weapon is None or item["atk"] > weapon["atk"]:
            weapon = item
    pieces = {}
    for slot in ("armor", "helm", "accessory"):
        best = None
        for item in ITEMS.values():
            if item["kind"] != slot or item["act"] > act:
                continue
            if item["classes"] and cls not in item["classes"]:
                continue
            score = (item["def"] + item["mdef"], item["spd"])
            if best is None or score > (best["def"] + best["mdef"], best["spd"]):
                best = item
        pieces[slot] = best
    return weapon, pieces


def party_for(act, c, level=0, size=4):
    level = level or ACT_BANDS[act][1]
    out = []
    for mid, cls in list(MEMBERS.items())[:size]:
        s = member_at(c, mid, level)
        weapon, pieces = best_gear(act, cls)
        atk = s["atk"] + (weapon["atk"] if weapon else 0)
        df = s["def"] + sum(p["def"] for p in pieces.values() if p)
        mdef = sum(p["mdef"] for p in pieces.values() if p)
        spd = sum(p["spd"] for p in pieces.values() if p)
        out.append({"id": mid, "class": cls, "level": level, "hp": s["hp"], "atk": atk,
                    "def": df, "mdef": mdef, "spd": spd,
                    "weapon": weapon["name"] if weapon else "-",
                    "armor": pieces["armor"]["name"] if pieces["armor"] else "-"})
    return out


# ---- checks -----------------------------------------------------------------------------------
def check_data(c, recipes):
    valid_classes = set(CLASS_WEAPON)
    # "bow" exists on the Ashen Longbow but no class can use it yet (documented gap).
    valid_cats = set(CLASS_WEAPON.values()) | {"bow"}
    valid_rarity = {"common", "uncommon", "rare", "legendary"}
    equipment = [i for i in ITEMS.values() if i["kind"] in ("weapon", "armor", "helm", "accessory")]
    for item in equipment:
        for field in ("desc", "acquisition"):
            if not item[field]:
                fail(f"{item['id']}: missing {field}")
        if item["rarity"] not in valid_rarity:
            fail(f"{item['id']}: unknown rarity '{item['rarity']}'")
        if item["act"] not in range(0, 9):
            fail(f"{item['id']}: act {item['act']} outside 1-8")
        for cls in item["classes"]:
            if cls not in valid_classes:
                fail(f"{item['id']}: unknown class '{cls}'")
        for cat in item["categories"]:
            if cat not in valid_cats:
                fail(f"{item['id']}: unknown weapon category '{cat}'")
        if item["kind"] == "weapon" and not item["categories"]:
            fail(f"{item['id']}: weapon with no weapon_categories")
        if item["atk"] + item["def"] + item["mdef"] + item["spd"] == 0 and item["kind"] != "weapon":
            warn(f"{item['id']}: equipment with no stat bonuses")
    for act in range(1, 9):
        act_gear = [i for i in equipment if i["act"] == act]
        if not any(i["kind"] == "armor" for i in act_gear):
            fail(f"act {act}: no armour tier")
        if not any(i["kind"] in ("helm", "accessory") for i in act_gear):
            fail(f"act {act}: no helm/accessory tier")
        # One weapon per class per act: no class may be left with only an older tier.
        # Legendaries do not count as the tier weapon: the act needs a buyable/craftable one.
        for cls, category in CLASS_WEAPON.items():
            covered = [i for i in act_gear if i["kind"] == "weapon" and category in i["categories"]
                       and i["rarity"] != "legendary"]
            if not covered:
                fail(f"act {act}: no {category} weapon tier (class {cls})")
    for rec in recipes:
        if rec["result"] not in ITEMS:
            fail(f"recipe result missing: {rec['result']}")
        elif ITEMS[rec["result"]]["rarity"] == "legendary":
            fail(f"recipe crafts a legendary: {rec['result']}")
        for mat, _qty in rec["materials"]:
            if mat not in ITEMS:
                fail(f"recipe {rec['result']}: missing material {mat}")
    shop_src = read(SHOP_FILE)
    for item_id in set(re.findall(r'"(item_[a-z0-9_]+)"', shop_src)):
        if item_id not in ITEMS:
            fail(f"shop stock references unknown item: {item_id}")
    enemy_src = read(ENEMY_FILE)
    dropped = set(re.findall(r'item:\s*"(item_[a-z0-9_]+)"', enemy_src))
    for item_id in dropped:
        if item_id not in ITEMS:
            fail(f"enemy drop references unknown item: {item_id}")
    legacy_legendaries = {"item_blackguard_longsword"}  # old-save alias of the Blackguard drop
    for item in ITEMS.values():
        if item["rarity"] != "legendary" or item["id"] in legacy_legendaries:
            continue
        if item["id"] not in dropped:
            warn(f"legendary {item['id']}: no enemy drop source "
                 f"(acquisition: {item['acquisition'] or 'none'})")
    if "44 + 9 * _d" not in enemy_src:
        warn("scr_enemy_scaled formula changed; the scaled-boss numbers here may be stale")
    return equipment, dropped


def rounds_to_kill(boss_hp, party):
    dmg = sum(max(1, m["atk"] - boss["def"] // 2) for m in party)
    return math.ceil(boss_hp / dmg) if dmg else 999


def rounds_to_wipe(boss, party):
    # Bosses hit one member per round: use the average DEF the boss has to chew through.
    avg_def = sum(m["def"] for m in party) // max(1, len(party))
    incoming = max(1, boss["atk"] - avg_def // 2)
    total_hp = sum(m["hp"] for m in party)
    return math.ceil(total_hp / incoming) if incoming else 999


print("=== equipment progression checker ===")
parse_items()
parse_enemies()
recipes = parse_craft()
c = parse_constants()
equipment, dropped = check_data(c, recipes)

print(f"items: {len(ITEMS)}   equipment: {len(equipment)}   recipes: {len(recipes)}   "
      f"enemies: {len(ENEMIES)}   bosses: {sum(1 for e in ENEMIES.values() if e['boss'])}")

print("\n--- weapon coverage (one per class per act) ---")
print("| Act | Kael longsword | Lyra dagger | Caelan spellbook | Sera holy sword | Taren heavy sword |")
print("|---|---|---|---|---|---|")
for act in range(1, 9):
    cells = []
    for cls, cat in CLASS_WEAPON.items():
        pick = [i for i in equipment if i["act"] == act and i["kind"] == "weapon"
                and cat in i["categories"] and i["rarity"] != "legendary"]
        pick.sort(key=lambda i: i["atk"], reverse=True)
        cells.append(f"{pick[0]['name']} (ATK +{pick[0]['atk']})" if pick else "MISSING")
    print(f"| {act} | " + " | ".join(cells) + " |")

print("\n--- gear per act (new tiers) ---")
print("| Act | Levels | New gear | Legendary |")
print("|---|---|---|---|")
legend = {i["act"]: i["name"] for i in equipment if i["rarity"] == "legendary"}
for act, (lo, hi) in ACT_BANDS.items():
    names = [i["name"] for i in equipment if i["act"] == act and i["rarity"] != "legendary"]
    print(f"| {act} | {lo}-{hi} | {', '.join(names) or '-'} | {legend.get(act, '-')} |")

print("\n--- best-in-slot party vs every boss ---")
print("| Boss | Lv | HP | Party lv | Rounds to kill | Rounds to wipe | Verdict |")
print("|---|---|---|---|---|---|---|")
flags = 0
for boss in sorted(ENEMIES.values(), key=lambda e: e["level"]):
    if not boss["boss"]:
        continue
    act = next((a for a, (lo, hi) in ACT_BANDS.items() if lo <= boss["level"] <= hi), 8)
    # At the encounter's own level, with the four active slots: "did the gear trivialise it?".
    party = party_for(act, c, level=boss["level"], size=4)
    rtk = rounds_to_kill(boss["hp"], party)
    rtw = rounds_to_wipe(boss, party)
    if rtk <= 4:
        verdict, flags = "TRIVIAL (<5 rounds)", flags + 1
    elif rtw <= rtk:
        verdict, flags = "party wipes first", flags + 1
    else:
        verdict = "ok"
    print(f"| {boss['name']} | {boss['level']} | {boss['hp']} | {party[0]['level']} | {rtk} | {rtw} | {verdict} |")

print("\n--- acquisition ---")
crafted = {r["result"] for r in recipes}


def shops():
    """shop_id -> (wired, item ids), from the case blocks in scr_shop_get."""
    src = read(SHOP_FILE)
    out = {}
    parts = re.split(r'case "(shop_[a-z_0-9]+)":', src)
    for i in range(1, len(parts) - 1, 2):
        sid, block = parts[i], parts[i + 1]
        out[sid] = ("wired: false" not in block,
                    set(re.findall(r'"(item_[a-z0-9_]+)"', block)))
    return out

shop_map = shops()
built_shop_items = set()
data_only_items = set()
for sid, (wired, ids) in shop_map.items():
    if wired:
        built_shop_items |= ids
    else:
        data_only_items |= ids
dropped_gear = {i["id"] for i in equipment if i["id"] in dropped}
crafted_gear = {i["id"] for i in equipment if i["id"] in crafted}
built_shop_gear = {i["id"] for i in equipment if i["id"] in built_shop_items}
data_shop_gear = {i["id"] for i in equipment if i["id"] in (data_only_items - built_shop_items)}
print(f"gear obtainable by boss drop: {len(dropped_gear)}")
print(f"gear obtainable by crafting: {len(crafted_gear)}")
print(f"gear sold by a wired merchant: {len(built_shop_gear)}")
print(f"gear defined only for unbuilt Act III-VIII shops: {len(data_shop_gear)}")
def has_source(item):
    if item["act"] == 0:  # starting / story gear
        return True
    if item["id"] in dropped_gear | crafted_gear | built_shop_gear | data_shop_gear:
        return True
    src = item["acquisition"].lower()
    return "chest" in src or "cache" in src


no_source = [i for i in equipment if i["act"] >= 1 and not i["unique"] and not has_source(i)]
if no_source:
    warn("gear with no acquisition path: " + ", ".join(i["id"] for i in no_source))

print("\n--- warnings ---")
for w in warnings:
    print(" -", w)
print("\n--- errors ---")
if errors:
    for e in errors:
        print(" -", e)
    sys.exit(1)
print("none. ALL CHECKS PASSED" + (f" ({flags} balance flag(s))" if flags else ""))
