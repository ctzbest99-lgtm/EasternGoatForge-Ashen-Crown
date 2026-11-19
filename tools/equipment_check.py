#!/usr/bin/env python3
"""Ashen Crown equipment progression checker.

Reads the real GML data (scr_item_data, scr_shop_data, scr_enemy_database,
scr_game_constants) and checks the eight-act equipment progression:

  1. Data integrity: duplicate item ids, duplicate display names, equipment missing
     rarity/act/acquisition/desc, unknown classes or weapon categories, recipes that
     reference missing items or try to craft a legendary, shop stock ids that do not exist,
     legendaries with no drop source.
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
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ITEM_FILE = ROOT / "game/scripts/scr_item_data.gml"
SHOP_FILE = ROOT / "game/scripts/scr_shop_data.gml"
ENEMY_FILE = ROOT / "game/scripts/scr_enemy_database.gml"
CONST_FILE = ROOT / "game/scripts/scr_game_constants.gml"
PARTY_FILE = ROOT / "game/scripts/scr_party.gml"

# Gear tiers, not story acts. The labels I-VIII are the item-table tiers. Story acts are
# coarser: Act I = 1-7 (tier I), Act II = 8-18 (tiers II-V), Act III = 18-20 (tier VI),
# Act IV = 21-23 (tier VII), Act V = 24-26 (tier VIII). The 2026-11-18 balance pass uses
# this mapping; do not read "Act V" in this table as story Act V.
ACT_BANDS = {1: (1, 7), 2: (8, 10), 3: (11, 14), 4: (15, 17),
             5: (17, 19), 6: (19, 21), 7: (21, 23), 8: (23, 24)}
CLASS_WEAPON = {"Vanguard": "longsword", "Rogue": "dagger", "Arcanist": "spellbook",
                "Warden": "holy_sword", "Rebel Captain": "heavy_sword"}
MEMBERS = {"kael": "Vanguard", "lyra": "Rogue", "caelan": "Arcanist",
           "sera": "Warden", "taren": "Rebel Captain"}
# Bows are intentionally deferred until an approved bow-proficient recruit exists. Their
# records stay valid, but they are not stocked and are not counted as missing content.
DEFERRED_BOWS = {"item_woodsman_bow", "item_swiftwind", "item_kings_longshot",
                 "item_aethari_longbow", "item_wyrmbane"}

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
STAT_KEYS = ("hp", "mp", "atk", "def", "mag", "mdef", "spd", "eva", "acc", "crit")
KIND_SLOT = {"weapon": "main_hand", "armor": "body", "helm": "head", "accessory": "accessory"}
WEAPON_TYPE = {
    "longsword": "sword", "holy_sword": "sword", "shortsword": "sword",
    "heavy_sword": "greatsword", "greatsword": "greatsword", "dagger": "dagger",
    "polearm": "spear", "axe": "axe", "mace": "hammer", "hammer": "hammer",
    "bow": "bow", "staff": "staff", "shield": "shield", "spellbook": "spellbook",
}
VALID_WEAPON_CATS = set(WEAPON_TYPE)
VALID_WEAPON_TYPES = set(WEAPON_TYPE.values())
VALID_CATEGORIES = {"weapon", "armor", "accessory", "consumable", "material", "key"}
VALID_RARITY = {"common", "uncommon", "rare", "legendary"}
VALID_SLOTS = {"main_hand", "off_hand", "head", "body", "legs", "accessory"}
VALID_ELEMENTS = {"fire", "ice", "lightning", "holy", "shadow", "ash"}
VALID_STATUSES = {"poison", "bleed", "sleep", "blind", "slow"}
EFFECT_SCHEMA = {
    "elemental_damage": ("element", "value"),
    "elemental_resistance": ("element", "value"),
    "status_resistance": ("status", "value"),
    "status_recovery": ("status",),
    "poison_chance": ("value",),
    "critical_bonus": ("value",),
    "hp_drain": ("value",),
    "mp_drain": ("value",),
    "healing": ("value",),
    "revival": ("value",),
    "stat_boost": ("stat", "value"),
    "armor_penetration": ("value",),
    "bonus_damage": ("value",),
    "evasion_bonus": ("value",),
    "mp_restore": ("value",),
}


def fnum(body, key, default=0.0):
    m = re.search(rf"\b{key}:\s*(-?\d+(?:\.\d+)?)", body)
    return float(m.group(1)) if m else default


def extract_block(src, key):
    """Return the inside of the first `key: {...}` / `key: [...]` block, brace-aware."""
    m = re.search(rf"\b{key}\s*:\s*([\[{{])", src)
    if not m:
        return ""
    opening = m.group(1)
    closing = "]" if opening == "[" else "}"
    depth = 0
    in_str = False
    esc = False
    start = m.end() - 1
    for i in range(start, len(src)):
        ch = src[i]
        if in_str:
            if esc:
                esc = False
            elif ch == "\\":
                esc = True
            elif ch == '"':
                in_str = False
            continue
        if ch == '"':
            in_str = True
        elif ch == opening:
            depth += 1
        elif ch == closing:
            depth -= 1
            if depth == 0:
                return src[start + 1:i]
    return ""


def extract_struct(src, start):
    """Return the inside of the brace block beginning at `start` (brace-aware)."""
    if start >= len(src) or src[start] != "{":
        return ""
    depth = 0
    in_str = esc = False
    for i in range(start, len(src)):
        ch = src[i]
        if in_str:
            if esc:
                esc = False
            elif ch == "\\":
                esc = True
            elif ch == '"':
                in_str = False
            continue
        if ch == '"':
            in_str = True
        elif ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return src[start + 1:i]
    return ""


def struct_values(block):
    out = {}
    for m in re.finditer(r'(\w+)\s*:\s*("(?:[^"\\]|\\.)*"|-?\d+(?:\.\d+)?|true|false)', block):
        raw = m.group(2)
        if raw.startswith('"'):
            out[m.group(1)] = raw[1:-1]
        elif raw == "true":
            out[m.group(1)] = True
        elif raw == "false":
            out[m.group(1)] = False
        else:
            out[m.group(1)] = float(raw)
    return out


def parse_res(body, key):
    block = extract_block(body, key)
    if not block:
        return {}
    return {k: v for k, v in struct_values(block).items() if isinstance(v, float)}


def parse_effects(body):
    block = extract_block(body, "effects")
    if not block:
        return []
    out = []
    i = 0
    while i < len(block):
        if block[i] != "{":
            i += 1
            continue
        depth = 0
        in_str = False
        esc = False
        for j in range(i, len(block)):
            ch = block[j]
            if in_str:
                if esc:
                    esc = False
                elif ch == "\\":
                    esc = True
                elif ch == '"':
                    in_str = False
                continue
            if ch == '"':
                in_str = True
            elif ch == "{":
                depth += 1
            elif ch == "}":
                depth -= 1
                if depth == 0:
                    out.append(struct_values(block[i + 1:j]))
                    i = j
                    break
        i += 1
    return out


def parse_items():
    src = read(ITEM_FILE)
    pat = re.compile(
        r'scr_item_make\(\s*"([a-z_0-9]+)"\s*,\s*"([^"]*)"\s*,\s*"(\w+)"\s*,\s*(\d+)\s*,'
        r'\s*\{(.*?)\}\s*\)\s*\)\s*;', re.S)
    for m in pat.finditer(src):
        body = m.group(5)
        kind = m.group(3)
        slot = text(body, "slot", "") or text(body, "equipment_slot", "")
        slot = KIND_SLOT.get(slot, slot)
        if not slot:
            slot = KIND_SLOT.get(kind, "")
        cats = id_list(body, "weapon_categories")
        category = text(body, "category", "")
        if not category:
            if kind == "weapon":
                category = "armor" if slot == "off_hand" and "shield" in cats else "weapon"
            elif kind in ("armor", "helm"):
                category = "armor"
            elif kind == "accessory":
                category = "accessory"
            elif kind == "consumable":
                category = "consumable"
            elif kind == "key":
                category = "key"
            else:
                category = "material"
        stats = {
            "hp": num(body, "hp_bonus"), "mp": num(body, "mp_bonus"),
            "atk": num(body, "atk_bonus"), "def": num(body, "def_bonus"),
            "mag": num(body, "mag_bonus"), "mdef": num(body, "mdef_bonus"),
            "spd": num(body, "spd_bonus"), "eva": num(body, "eva_bonus"),
            "acc": num(body, "acc_bonus"), "crit": fnum(body, "crit_bonus"),
        }
        stats_block = extract_block(body, "stats")
        if stats_block:
            for k, v in struct_values(stats_block).items():
                if k in STAT_KEYS and isinstance(v, float):
                    stats[k] = v
        price = int(m.group(4))
        if re.search(r"\bbuy_price:\s*", body):
            price = int(fnum(body, "buy_price", price))
        act = int(fnum(body, "unlock_act", num(body, "act", 0)))
        item = {
            "id": m.group(1), "name": m.group(2), "kind": kind, "price": price,
            "buy_price": price, "act": act,
            "atk": stats["atk"], "def": stats["def"], "mdef": stats["mdef"],
            "spd": stats["spd"], "mag": stats["mag"], "hp": stats["hp"],
            "acc": stats["acc"], "eva": stats["eva"], "crit": stats["crit"],
            "stats": stats,
            "rarity": text(body, "rarity", "common"),
            "classes": id_list(body, "classes"), "unique": flag(body, "unique"),
            "acquisition": text(body, "acquisition"),
            "desc": text(body, "desc", "") or text(body, "description", ""),
            "categories": cats,
            "slot": slot, "category": category,
            "weapon_type": text(body, "weapon_type", "") or (WEAPON_TYPE.get(cats[0], cats[0]) if cats else ""),
            "two_handed": flag(body, "two_handed"),
            "key_item": kind == "key" or flag(body, "key_item"),
            "sellable": not re.search(r"\bsellable:\s*false\b", body),
            "heal": num(body, "heal"), "mp_restore": num(body, "mp_restore"),
            "revive_pct": fnum(body, "revive_pct"), "cures_poison": flag(body, "cures_poison"),
            "elem_res": parse_res(body, "elem_res"), "status_res": parse_res(body, "status_res"),
            "declared_effects": parse_effects(body),
            "armor_class": text(body, "armor_class"),
            "body": body,
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
                item["buy_price"] = item["price"]
            if re.search(r"acquisition:", body):
                item["acquisition"] = text(body, "acquisition", item["acquisition"])
            if flag(body, "unique"):
                item["unique"] = True
            if re.search(r"sellable:\s*false\b", body):
                item["sellable"] = False
    # scr_item_finalize() forces these two states; mirror it before validating.
    for item in ITEMS.values():
        if item["key_item"] or item["unique"] or item["buy_price"] <= 0:
            item["sellable"] = False


def item_effects(item):
    """Mirror scr_item_finalize(): declared effects first, then the flat fields."""
    out = []
    seen = set()

    def add(effect):
        key = (effect.get("type"), effect.get("element"), effect.get("status"), effect.get("stat"))
        if key in seen:
            return
        seen.add(key)
        out.append(effect)

    for effect in item["declared_effects"]:
        add(effect)
    if item["heal"] > 0:
        add({"type": "healing", "value": float(item["heal"])})
    if item["mp_restore"] > 0:
        add({"type": "mp_restore", "value": float(item["mp_restore"])})
    if item["revive_pct"] > 0:
        add({"type": "revival", "value": round(item["revive_pct"] * 100)})
    if item["cures_poison"]:
        add({"type": "status_recovery", "status": "poison"})
    for element, value in item["elem_res"].items():
        add({"type": "elemental_resistance", "element": element, "value": value})
    for status, value in item["status_res"].items():
        add({"type": "status_resistance", "status": status, "value": value})
    return out


def item_subcategory(item):
    """Mirror of scr_item_subcategory_for()."""
    cat = item["category"]
    name = item["name"].lower()
    slot = item["slot"]
    if cat == "weapon":
        return item["weapon_type"] or "weapon"
    if cat == "armor":
        return {"head": "headgear", "body": "body_armor", "legs": "leg_armor",
                "off_hand": "shield"}.get(slot, "armor")
    if cat == "accessory":
        for kind in ("ring", "pendant", "charm", "talisman"):
            if kind in name:
                return kind
        return "other_accessory"
    if cat == "consumable":
        if item["revive_pct"] > 0:
            return "revival"
        if item["heal"] > 0:
            return "hp_restore"
        if item["mp_restore"] > 0:
            return "mp_restore"
        if item["cures_poison"]:
            return "status_recovery"
        return "other_consumable"
    if cat == "material":
        if name == "ore" or " ore" in f" {name}":
            return "ore"
        if name == "ingot" or " ingot" in f" {name}":
            return "ingot"
        if any(kind in name for kind in ("pelt", "hide", "fang", "claw", "scale")):
            return "monster_material"
        if item["rarity"] in ("rare", "legendary"):
            return "rare_component"
        return "magical_material"
    if cat == "key":
        if "key" in name:
            return "key"
        if any(kind in name for kind in ("notes", "parchment", "letter")):
            return "document"
        if any(kind in name for kind in ("relic", "crown", "fragment")):
            return "relic"
        if any(kind in name for kind in ("parcel", "quest")):
            return "quest_object"
        return "story_item"
    return ""


def validate_schema(c):
    """Mirror of scr_item_finalize()/scr_item_validate(): every record must be complete."""
    rate = c.get("SHOP_SELL_RATE", 0.5)
    bad = 0
    for item in ITEMS.values():
        # Resolve the two consumable macros, exactly as GML does at compile time.
        for field, macro in (("heal", "heal"), ("mp_restore", "mp_restore")):
            if item[field] == 0:
                m = re.search(rf"\b{macro}:\s*(\w+)", item["body"])
                if m and m.group(1) in c:
                    item[field] = int(c[m.group(1)])

        def bad_item(message):
            nonlocal bad
            bad += 1
            fail(f"schema {item['id']}: {message}")

        if not re.fullmatch(r"item_[a-z0-9_]+", item["id"]):
            bad_item("id must be lowercase item_* with underscores")
        if not item["name"]:
            bad_item("name is empty")
        if not item["desc"]:
            bad_item("description is empty")
        item["subcategory"] = item_subcategory(item)
        if not item["subcategory"]:
            bad_item("subcategory is empty")
        if item["category"] not in VALID_CATEGORIES:
            bad_item(f"invalid category '{item['category']}'")
        if item["rarity"] not in VALID_RARITY:
            bad_item(f"invalid rarity '{item['rarity']}'")
        if not isinstance(item["act"], int) or not 0 <= item["act"] <= 8:
            bad_item(f"unlock act {item['act']} outside 0-8")

        equipment = item["category"] in ("weapon", "armor", "accessory")
        if equipment and item["slot"] not in VALID_SLOTS:
            bad_item(f"invalid equipment slot '{item['slot']}'")
        if not equipment and item["slot"]:
            bad_item("non-equipment record has a slot")
        if item["weapon_type"] and item["weapon_type"] not in VALID_WEAPON_TYPES:
            bad_item(f"invalid weapon_type '{item['weapon_type']}'")
        if item["category"] == "weapon":
            if item["weapon_type"] not in VALID_WEAPON_TYPES or item["weapon_type"] == "shield":
                bad_item(f"weapon has invalid weapon_type '{item['weapon_type']}'")
            if item["slot"] not in ("main_hand", "off_hand"):
                bad_item("weapon is not in a hand slot")
            if not item["categories"]:
                bad_item("weapon has no weapon_categories")
        elif item["category"] == "armor" and item["slot"] == "off_hand":
            if item["weapon_type"] != "shield":
                bad_item("off-hand armor must be a shield")
        elif item["weapon_type"]:
            bad_item("non-weapon record has a weapon_type")
        if item["two_handed"] and not (item["category"] == "weapon" and item["slot"] == "main_hand"):
            bad_item("two-handed item is not a main-hand weapon")
        for cat in item["categories"]:
            if cat not in VALID_WEAPON_CATS:
                bad_item(f"unknown weapon category '{cat}'")
        for cls in item["classes"]:
            if cls not in CLASS_WEAPON:
                bad_item(f"unknown class '{cls}'")
        if item["armor_class"] and item["armor_class"] not in ("light", "medium", "heavy"):
            bad_item(f"invalid armor_class '{item['armor_class']}'")

        for stat in STAT_KEYS:
            value = item["stats"].get(stat)
            if not isinstance(value, (int, float)) or value != value or abs(value) > 100000:
                bad_item(f"stat '{stat}' is not a finite number")
            if stat == "crit" and not -1 <= value <= 1:
                bad_item("crit must be a fraction between -1 and 1")

        for effect in item_effects(item):
            etype = effect.get("type", "")
            if etype not in EFFECT_SCHEMA:
                bad_item(f"unknown effect type '{etype}'")
                continue
            for required in EFFECT_SCHEMA[etype]:
                if required not in effect:
                    bad_item(f"effect '{etype}' is missing '{required}'")
            value = effect.get("value")
            if "value" in EFFECT_SCHEMA[etype] and not isinstance(value, (int, float)):
                bad_item(f"effect '{etype}' has a non-numeric value")
            if "element" in effect and effect["element"] not in VALID_ELEMENTS:
                bad_item(f"effect '{etype}' has unknown element '{effect['element']}'")
            if "status" in effect and effect["status"] not in VALID_STATUSES:
                bad_item(f"effect '{etype}' has unknown status '{effect['status']}'")
            if etype == "stat_boost" and effect.get("stat") not in STAT_KEYS:
                bad_item(f"stat_boost has unknown stat '{effect.get('stat')}'")
            if etype in ("healing", "mp_restore") and isinstance(value, (int, float)) and value <= 0:
                bad_item(f"{etype} must be positive")
            if etype == "revival" and isinstance(value, (int, float)) and not 0 < value <= 100:
                bad_item("revival must be between 0 and 100")
            if etype == "poison_chance" and isinstance(value, (int, float)) and not 0 <= value <= 100:
                bad_item("poison_chance must be between 0 and 100")
            if etype == "critical_bonus" and isinstance(value, (int, float)) and not -1 <= value <= 1:
                bad_item("critical_bonus must be a fraction")
            if etype in ("elemental_resistance", "status_resistance") and isinstance(value, (int, float)) and not -100 <= value <= 100:
                bad_item(f"{etype} must be between -100 and 100")

        sellable = item["sellable"] and not item["key_item"] and not item["unique"] and item["buy_price"] > 0
        sell_price = max(1, int(item["buy_price"] * rate)) if sellable else 0
        if item["buy_price"] < 0:
            bad_item("buy_price is negative")
        if sellable and sell_price > item["buy_price"]:
            bad_item("sell_price is above buy_price")
        if (item["key_item"] or item["unique"]) and item["sellable"]:
            bad_item("key/unique record is sellable")

    counts = defaultdict(int)
    max_effects = 0
    for item in ITEMS.values():
        counts[item["category"]] += 1
        max_effects = max(max_effects, len(item_effects(item)))
    print(f"schema: {len(ITEMS)} records, {bad} invalid, max effects {max_effects}")
    print("schema categories: " + ", ".join(f"{k} {counts[k]}" for k in sorted(counts)))
    subs = Counter(item_subcategory(i) for i in ITEMS.values())
    print("schema subtypes: " + ", ".join(f"{k} {subs[k]}" for k in sorted(subs)))


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
    # Scaled template: mirrors scr_enemy_scaled (asserted below). Brace-aware because the
    # extra struct contains nested `drops: [{...}]` arrays, which a one-level regex misses.
    for m in re.finditer(
            r'scr_enemy_scaled\(\s*"(\w+)"\s*,\s*"([^"]*)"\s*,\s*"[^"]*"\s*,\s*"(\w+)"\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*',
            src, re.S):
        eid, name, role, level, party = m.group(1), m.group(2), m.group(3), int(m.group(4)), int(m.group(5))
        body = extract_struct(src, m.end())
        if not body:
            continue
        d = level - 9
        hp, atk, df = 44 + 9 * d, 13 + 3 * d, 11 + 2 * d
        if role == "elite":
            hp, atk, df = hp * 2, atk + 2, df + 2
        if role == "boss":
            hp, atk, df = round(hp * 1.2 * max(1, party)), atk + 3, df + 3
        if re.search(r"hp_mult:", body):
            hp = round(hp * fnum(body, "hp_mult", 1.0))
        atk += int(fnum(body, "atk_add", 0))
        df += int(fnum(body, "def_add", 0))
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
    # Acts V+ introduced greatswords, shields and secondary kits (staff / mace / shortsword).
    valid_cats = set(CLASS_WEAPON.values()) | {"bow", "greatsword", "shield", "staff", "mace", "shortsword", "polearm"}
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
        if item["atk"] + item["def"] + item["mdef"] + item["spd"] + item["mag"] + item["hp"] + item["acc"] + item["eva"] + item["crit"] == 0 and item["kind"] != "weapon":
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
    names = {}
    for item in ITEMS.values():
        key = item["name"].strip().lower()
        if key in names:
            warn(f"duplicate display name '{item['name']}': {names[key]} and {item['id']}")
        else:
            names[key] = item["id"]
    legacy_legendaries = {"item_blackguard_longsword"}  # resolved by scr_item_id_norm for old saves
    for item in ITEMS.values():
        if item["rarity"] != "legendary" or item["id"] in legacy_legendaries:
            continue
        if item["id"] in DEFERRED_BOWS:
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
validate_schema(c)
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
        verdict, flags = "TRIVIAL (static <5 rounds)", flags + 1
    elif rtw <= rtk:
        verdict, flags = "party wipes first (static)", flags + 1
    else:
        verdict = "ok"
    print(f"| {boss['name']} | {boss['level']} | {boss['hp']} | {party[0]['level']} | {rtk} | {rtw} | {verdict} |")

print("\nStatic table only: rounds-to-kill ignores skills, buffs, criticals and healing, and")
print("rounds-to-wipe assumes every boss hit lands. Use `python3 tools/balance_sim.py --summary`")
print("for the simulated band; the flags below are a data sanity check, not a playtest verdict.")

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


no_source = [i for i in equipment if i["act"] >= 1 and not i["unique"]
             and i["id"] not in DEFERRED_BOWS and not has_source(i)]
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
