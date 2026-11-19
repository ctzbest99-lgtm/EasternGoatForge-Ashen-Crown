# Item Database

Status: implemented 2026-11-18 in `game/scripts/scr_item_data.gml` (mirrored byte-for-byte in
`gamemaker/`). 181 records. Nothing has been compiled or played in GameMaker.

## 1. What this is

One item database, one stable id per item, and one record shape for every category. A new weapon,
potion, material or quest item is added by writing a data record; the bag, equipment, shops,
chests, enemy drops, crafting and save/load already read that record.

The handoff proposed a standalone JSON-style record with `stats`, `effects` and `equipment_slot`.
The project already had a working item table, a six-category bag, seven equipment slots, an
id-based inventory, merchant/loot/crafting systems and versioned saves. The standard shape was
layered onto that table rather than replacing it. No second database, no duplicate ids, no save
schema change.

## 2. Architecture discovered

| Concern | Existing implementation | Kept? |
|---|---|---|
| Definitions | `scr_item_make(...)` builds a struct; `scr_item_database()` registers them in `global.item_db` | Yes |
| Lookup | `scr_item_get(id)` returns the record (or a safe placeholder) | Yes |
| Identity | `item_<lowercase_with_underscores>` ids, normalized by `scr_item_id_norm` | Yes |
| Bag categories | `scr_item_category()` → weapon / armor / accessory / consumable / material / key | Yes |
| Slots | `scr_item_slot()` + `scr_equipment_slots()`; legacy `weapon/armor/helm/accessory` storage keys | Yes |
| Inventory | `global.game.inventory` entries hold `{ item_id, name, qty, key_item }` | Yes |
| Equipment | actor ids in `actor.equipment` | Yes |
| Shops / chests / drops / crafting | all reference item ids already | Yes |
| Saves | `SAVE_SCHEMA_VERSION 4`, inventory ids + qty, equipped ids | Yes, no bump |

The old two-shape problem was that `scr_item_make` accepted flat convenience fields
(`atk_bonus`, `heal`, `elem_res`, …) while the handoff expected `stats` and `effects`. Both are now
accepted as authoring forms and are materialized into the same record.

## 3. Record shape

Every registered item has these fields after `scr_item_finalize()`:

| Field | Meaning |
|---|---|
| `item_id` / `id` | Stable unique id |
| `name` | Display name |
| `category` | `weapon`, `armor`, `accessory`, `consumable`, `material`, `key` |
| `kind` | Legacy authoring kind (`weapon`, `armor`, `helm`, `accessory`, `consumable`, `key`, `misc`); kept for old code |
| `weapon_type` | Standard subtype: `sword`, `greatsword`, `dagger`, `spear`, `axe`, `hammer`, `bow`, `staff`, `shield`, `spellbook` |
| `subcategory` | Derived display/query subtype: `ring`, `pendant`, `charm`, `ore`, `ingot`, `monster_material`, `rare_component`, `document`, `relic`, `quest_object`, `headgear`, `body_armor`, `leg_armor`, `shield`, … |
| `weapon_categories` | Proficiency categories used by `scr_item_can_equip` (authoritative for equipping) |
| `rarity` | `common`, `uncommon`, `rare`, `legendary` |
| `description` / `desc` | Player-facing description (same value) |
| `stats` | `{ hp, mp, atk, def, mag, mdef, spd, eva, acc, crit }` |
| `effects` | Array of effect structs (section 5) |
| `slot` / `equipment_slot` | `main_hand`, `off_hand`, `head`, `body`, `legs`, `accessory`; empty for non-equipment |
| `sellable` | Whether merchants buy it; key/unique items are always false |
| `stackable` | Consumables and materials stack; gear and key items do not |
| `price` / `buy_price` | Merchant purchase price (same value) |
| `sell_price` | Derived: `max(1, floor(buy_price * SHOP_SELL_RATE))` when sellable, else 0 |
| `act` / `unlock_act` | Story act 0–8 |
| `two_handed`, `armor_class`, `classes`, `unique`, `acquisition` | Equipment rules and documentation |
| `valid`, `validation_errors` | Result of the registration validation |

`eval` in the handoff is the project's `eva` (evasion). `crit` is a fraction (`0.06` = 6%), not a
percentage integer.

## 4. Authoring an item

Existing compact form, still valid:

```gml
_add(_db, scr_item_make("item_example_blade", "Example Blade", "weapon", 400, {
    atk_bonus: 12, spd_bonus: 2, weapon_categories: ["longsword"],
    rarity: "rare", act: 5, acquisition: "Example merchant (Act V).",
    desc: "A blade used as an example. ATK +12, SPD +2."
}));
```

Standard form, also accepted:

```gml
_add(_db, scr_item_make("item_example_relic", "Example Relic", "accessory", 900, {
    rarity: "rare", unlock_act: 6, equipment_slot: "accessory",
    description: "A relic used as an example.",
    stats: { hp: 0, mp: 0, atk: 0, def: 2, mag: 3, mdef: 4, spd: 0, eva: 0, acc: 0, crit: 0 },
    effects: [
        { type: "elemental_resistance", element: "shadow", value: 15 },
        { type: "status_resistance", status: "sleep", value: 50 }
    ]
}));
```

The two forms produce the same record. `stats` is folded into the flat bonus fields, then rebuilt
as `stats`; `effects` is applied to the flat fields (heal, MP, revive, cures, resistances, stat
boosts) and materialized as the effect array. Declared effects win over a conflicting flat field.

## 5. Effects

`scr_item_effect_schema()` is the extension point:

| Type | Required properties |
|---|---|
| `elemental_damage` | `element`, `value` |
| `elemental_resistance` | `element`, `value` |
| `status_resistance` | `status`, `value` |
| `status_recovery` | `status` |
| `poison_chance` | `value` |
| `critical_bonus` | `value` |
| `hp_drain`, `mp_drain` | `value` |
| `healing` | `value` |
| `revival` | `value` (percent, 1–100) |
| `stat_boost` | `stat`, `value` |
| `armor_penetration`, `bonus_damage`, `evasion_bonus` | `value` |
| `mp_restore` | `value` (project extension) |

Elements: `fire`, `ice`, `lightning`, `holy`, `shadow`, `ash`.
Statuses: `poison`, `bleed`, `sleep`, `blind`, `slow`.

Currently consumed by gameplay: healing, MP restore, revival, poison recovery, elemental/status
resistance, critical bonus, evasion bonus and stat boosts (through equipment). The remaining types
are stored and validated but have no combat consumer yet; they are listed here so a future battle
pass can use them without changing any item record.

Helpers:

- `scr_item_get(id)` — whole record
- `scr_item_exists(id)` — true only for a registered id
- `scr_item_description(id)`, `scr_item_stats(id)`, `scr_item_effects(id)`
- `scr_item_effect_total(id, type, key, value)` — sums matching effect values
- `scr_item_has_effect(id, type, key, value)` — presence check
- `scr_item_db_audit()` — count, invalid ids, duplicate ids, duplicate display names and per-record errors

## 6. Validation

`scr_item_validate(record)` runs once per record at database build, after the metadata pass that
gives the oldest items their rarity/act. It checks:

- id is non-empty, lowercase, underscore-only and starts with `item_`
- name, description and derived subcategory are non-empty
- category, rarity, equipment slot and weapon type are valid for the record
- a weapon has a hand slot and at least one proficiency category
- an off-hand armor record is a shield
- `two_handed` is only on a main-hand weapon
- all ten stats exist and are finite; crit is between -1 and 1
- every effect has a known type and its required properties; values and ranges are checked
- elements and statuses are known
- prices are non-negative, sellable implies a positive buy price, sell price never exceeds buy price
- `unlock_act` is a whole number 0–8
- `stackable` agrees with the category (derived, so this is a guard against future hand-edits)
- key/unique records are not sellable
- equipment classes and armor class are known

Invalid records are **reported, not silently accepted**: they stay queryable so a typo cannot crash
a menu or an old save, but they are marked `valid: false`, listed in `global.item_db_invalid`, and
logged with `[item_db] INVALID …`. `tools/equipment_check.py` mirrors the same rules and exits 1 on
any invalid record. Duplicate ids are refused by the registrar (first definition wins) and listed in
`global.item_db_duplicates`. Duplicate **display names** are reported separately in
`global.item_db_duplicate_names` and by the checker; they are a review warning, not an invalid record.

### Aliases

`scr_item_id_norm()` resolves the one legacy id that must never disappear:

| Input | Canonical |
|---|---|
| `item_blackguard_longsword` | `item_blackguards_longsword` |
| `blackguard_longsword` | `item_blackguards_longsword` |

The plural id is the only registered Blackguard record. The singular id was removed from the table
(182 → 181 records) but stays an alias, so old inventory rows, equipped weapons and story grants keep
resolving. Saves are sanitized through the same normalizer on load, so an old row merges into the
canonical stack instead of becoming an unknown item.

## 7. Inventory, equipment and content integration

- `scr_inventory_add` reads `stackable` from the record. Consumables/materials merge into one row;
  gear keeps one row per copy. Names come from the database, not the caller.
- `scr_inventory_count` sums every matching row; `scr_inventory_remove` walks every row and refuses
  key removal before mutating anything.
- Chest/loot entries may be an item id or a display name; both resolve through the same database.
- `scr_item_equip_bonuses` reads `stats`, so equipment totals use the standardized statistics.
- `scr_item_use_on`, the battle item list and the revive-target check read `effects`.
- Shops, recipes and enemy drops already store ids, so they need no changes.
- MAG is a real combat stat: `scr_battle_skill_damage` uses MAG vs MDEF for `dmg_type == "mag"`,
  and `scr_actor_create` seeds base MAG from ATK so enemies without a magic kit keep their old curve.
- Caelan's Spellbook (ATK +1, MAG +3, MDEF +1) and Sera's Holy Sword (ATK +4, MAG +1, MDEF +1) have
  provisional starting values. Sera's roster entry now starts with the Holy Sword, not an empty hand.
- Bows are future content: no class gained bow proficiency. Woodsman's Bow, Swiftwind, King's
  Longshot, Aethari Longbow and Wyrmbane are marked reserved and removed from merchant stock; the
  Ashen Longbow remains a cache curiosity. Ashen Arrow and Blackened Feather are materials with no
  use action, and their descriptions say so.
- Ether and Chain Mail have 16×16 enabled and disabled icons (`spr_item_ether*`,
  `spr_item_chain_mail*`), generated by `game/sprites/src/item_extra.py`.

## 8. Save and load

Save schema stays **4**. The inventory snapshot writes only `{ item_id, qty }`; equipment stores
ids only. Older saves that also contain `name` / `key_item` still load: those fields are ignored and
rebuilt from the database.

On load, `scr_save_sanitize_inventory`:

- drops unknown ids and logs a warning
- restores the display name and key/unique flag from the database
- merges stackable rows and splits non-stackable gear into single-copy rows
- clamps key/unique items to one copy

`scr_save_sanitize_equipment` then clears any equipped id that is unknown, in the wrong slot, or in
the off-hand while a two-handed weapon is equipped, and logs each change. After that,
`scr_actor_refresh_equipment` recalculates every derived stat. `global.save_load_warnings` holds the
human-readable list for the current load. Missing or corrupt save files are still refused before
any of this runs.

## 9. Differences from the handoff (deliberate)

1. **Ids keep the `item_` prefix.** `item_ashen_requiem` is already referenced by saves, shops,
   chests, quests and scripts. Renaming it to `weapon_sword_ashen_requiem` would break save
   compatibility and the "ids must remain stable" rule. `id` is exposed as an alias of the stable
   `item_id`; every id is lowercase with underscores.
2. **Ashen Requiem keeps its existing values.** The handoff's ATK 45 / `elemental_damage: ash` /
   sellable for 2500 was illustrative. The project record is ATK +19, CRIT +6%, greatsword,
   legendary, unique and unsellable, acquired from the Architect. That is unchanged.
3. **`description`/`desc`, `equipment_slot`/`slot`, `buy_price`/`price`, `unlock_act`/`act` are
   alias pairs.** The right-hand field is the storage field so the existing scripts keep working.
4. **`sell_price` and `stackable` are derived**, not authored per record. This prevents a merchant
   price or a bag rule from disagreeing with itself. `SHOP_SELL_RATE` remains the single sell rate.
5. **`eva`, not `eval`.** The handoff's `eval` is the project's evasion stat.
6. **Shields are in the Armor category** (as the handoff's category list requires) while keeping
   `kind: "weapon"` and the off-hand/shield-proficiency path. Their `weapon_type` is `shield`.
7. **Flat fields remain as the runtime projection.** `stats` and `effects` are materialized from
   them (or they are filled from declared `stats`/`effects`) at registration. Existing battle and UI
   code reads the flat fields; the new use path reads effects. Both come from one record and cannot
   drift because records are immutable after build.
8. **Unknown effect types are rejected.** The effect system is extensible by adding one row to
   `scr_item_effect_schema()`; that is an extension of the schema, not a rewrite of the database.

## 10. Adding an item

1. Pick a new lowercase `item_*` id. Never reuse or rename an existing id.
2. Add one `scr_item_make(...)` call in `scr_item_database()` (or a future data script) with the
   standard fields you need.
3. Give it a real description, rarity, act and acquisition text.
4. If it is equipment, set the slot, weapon type/categories, class/armor restrictions and totals.
5. If it has a new effect type, add it to `scr_item_effect_schema()` and to the consumer.
6. Register it in a shop/recipe/drop/chest by id if it should be obtainable.
7. Run `python3 tools/equipment_check.py` (schema + progression) and
   `python3 validate_gamemaker.py`; copy the edited script into `gamemaker/` byte-for-byte.

## 11. Item audit summary (2026-11-18)

All 181 records were read against the schema and the progression checker. None is invalid. No value
is runtime-verified, because there is no GameMaker IDE here; "implemented" below means the record,
consumer and source all exist in source.

| Category | Records | Status | Notes |
|---|---|---|---|
| Weapon | 75 | Implemented; runtime unverified | 6 bows are reserved (no proficient class), 5 starting weapons, the rest are the per-act class tiers, shields and legendaries |
| Armor | 48 | Implemented; runtime unverified | Body, leg, head and off-hand records; armour-class restrictions checked |
| Accessory | 13 | Implemented; runtime unverified | Rings, pendants, charms; one legendary per act where designed |
| Consumable | 9 | Implemented; runtime unverified | Healing, MP, poison cure and the two required revives |
| Material | 30 | Implemented; runtime unverified | Crafting inputs and monster parts; Ashen Arrow and Blackened Feather intentionally have no use action |
| Key | 6 | Implemented; runtime unverified | Unsellable, unique; story grants use ids |
| **Total** | **181** | **0 invalid** | 136 are equipment; 19 have dedicated icons |

Resolved in this pass:

| Finding | Resolution |
|---|---|
| Two Blackguard records with the same name | Canonical `item_blackguards_longsword`; singular id is an alias, not a record |
| Caelan's Spellbook had no combat stats | ATK +1 / MAG +3 / MDEF +1, provisional |
| Sera's Holy Sword had no combat stats and Sera started empty-handed | ATK +4 / MAG +1 / MDEF +1; roster starts with it |
| Bows had no proficient class and some were stocked | All six marked reserved; five removed from merchant stock; no class changed |
| Ashen Arrow / Blackened Feather implied a use action | Reclassified as materials; descriptions say there is no use action |
| Ether / Chain Mail had no icons | 16×16 enabled + disabled icons, wired through `scr_ch1_art` |
| 129 player-facing descriptions ended in `(PLACEHOLDER.)` | Removed; developer-only provisional status now lives in this document, not in item text |
| Weak starting weapons and basic gear | Kael/Taren ATK +3, Lyra ATK +2, Hunter's Knife ATK +2, Iron Sword ATK +3, Leather DEF +2, Iron Helm DEF +1, Chain Mail DEF +4, Minor Potion 15 HP / 15g, Ether 10 MP / 60g |

Still open and deliberately not faked:

- 162 records have no dedicated icon; the inventory/shop fall back to the category glyph. The handoff
  only named Ether and Chain Mail as concrete gaps, and those are done. A full 181-icon set is an art
  production task, not a data fix.
- Balance values are coherent tier fillers, not owner-approved final numbers. The checker's three
  remaining flags are boss-damage flags (Emberwake, Reeve Calder, The Debtman are trivial for their
  level), not item-schema failures; changing boss HP is an encounter-balance decision outside this pass.

## 12. Verification

- `python3 tools/equipment_check.py` → `schema: 181 records, 0 invalid` and
  `ALL CHECKS PASSED` (12 legendary no-source warnings, 3 pre-existing balance flags; deferred bows
  are excluded from the no-source warning by name).
- No player-facing item description contains `PLACEHOLDER`; the remaining occurrences in
  `scr_item_data.gml` are developer comments about provisional balance.
- `python3 validate_gamemaker.py` → `ALL CHECKS PASSED`.
- `git diff --check` clean; `game/` and `gamemaker/` scripts and the battle Step file are
  byte-identical.
- **Not verified:** no GameMaker IDE is available here, so this has not been compiled or played. The
  schema was checked statically, not executed by the GML runtime.
