# Changelog

## Unreleased — Battle upgrade (`feature/battle-upgrade`)

Multi-enemy battles, SPD / MP / MDEF, skills, enemy AI, and the Act II enemy roster, built on the saves-and-shops branch (PR #10).

- 1–3 enemies or a boss plus adds, target selection, SPD turn order, MP skills (Taren: Rallying Cry, Cleave, Unbowed), timed buffs, elemental weakness, weighted enemy AI, Reeve Calder's shout / stance / yield.
- Six Act II enemies with Design's suggested stats; Millhaven Road / Wrenfield encounter tables as data only.
- Save schema 2 (MP, SPD, MDEF, skills) with migration of schema 1 saves.
- All numbers are PLACEHOLDER (see `docs/DECISIONS_AND_OPEN_QUESTIONS.md`). Chapter 2 dialogue is not wired. Nothing has been compiled or playtested in GameMaker.

## Unreleased — Field menu art (`feature/save-and-shops`)

Design's shop, save/load, and inventory art from `/workspace/sprites/ui/menus/` is wired into the existing save/shop menus.

- Menus use the mockup layouts (dither backdrop, tab strips 12px above the window drawn after it, row select / disabled, coin / clock / key icons, party icons and frames, portrait and leader wells, quantity field, stat arrows). Coordinates and colours live in `scr_menu_layout.gml`. Missing sprites still fall back through `asset_get_index`.
- Save / load slots show the leader overworld sprite, party icons, playtime (`hh:mm`) and gold. Overwrite confirm defaults to No. A successful save plays `spr_ui_toast_saved` (origin (32, 0)) at (160, 8).
- `obj_save_point` uses `spr_save_point_idle_strip8` (origin (8, 23), 8 fps) and plays `spr_save_point_activate_strip8` (origin (16, 39), 12 fps) once before opening the save menu.
- Unaffordable or unsellable shop rows use `items_disabled/spr_item_<id>_disabled` and the disabled select bar. Key items show the key icon instead of a price.
- Inventory has Items / Equip / Key tabs. Equip lists Weapon, Armor, Helm, and Accessory (Iron Helm uses Helm). Other members use `spr_ui_party_icon_none` until their icons exist.
- Marda (`neutral`, `smirk`, `stern`) and Hob (`neutral`, `grim`, `wry`) portraits are available for dialogue; the shop header uses the keeper's neutral portrait.
- Nothing here has been compiled or playtested in GameMaker.

## Saves and shops (previous) (`feature/save-and-shops`)

Versioned JSON save / load and data-driven shops, built on the Chapter 1 art branch (PR #9).

- Save files `save1.sav`–`save3.sav` store schema version 1, the party roster (HP, levels, XP, gear), active and reserve slots, gold, inventory and key items, story flags, cleared encounters, room, position, facing, playtime, and related story state. Written and read through a buffer. Missing or corrupt files fail safely.
- Title Continue is enabled when any slot exists and opens a load panel (location, lead level, playtime, gold) using Design's `spr_menu_panel_saves_*` when imported. New Game resets `global.game`.
- Save access: a prompt after `CV_END`, `obj_save_point` in the Greyhaven chapel and tavern (temporary tiles — still open), and an optional F5 debug key (`DEBUG_SAVE_ANYWHERE`, off by default).
- `shop_greyhaven_store` (Marda): Minor Potion and Antidote after `GH_STORE_01`–`03`. `shop_greyhaven_forge` (Pell): Iron Sword, Leather Armor, Iron Helm after `GH_SMITH_01_B` (requires the pendant). Buy / Sell / Exit with icons, PLACEHOLDER prices, quantity, gold, owned count, and equipment preview. Sell is 50% (PLACEHOLDER). Key items cannot be sold.
- Inventory (I / Tab) can use Minor Potion (PLACEHOLDER 15 HP) and Antidote (clears an overworld poison flag; battle poison is not implemented), and can equip gear. Equipment bonuses apply to battle ATK / DEF.
- Menus use the existing nine-slice windows, bitmap font, cursor, and item icons. Sprite names for upcoming Design art in `/workspace/sprites/ui/menus/` are looked up first with fallbacks. Layout constants live in `scr_menu_layout.gml`.
- Nothing in this change has been compiled or playtested in GameMaker.
