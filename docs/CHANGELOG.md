# Changelog

## Unreleased — Saves and shops (`feature/save-and-shops`)

Versioned JSON save / load and data-driven shops, built on the Chapter 1 art branch (PR #9).

- Save files `save1.sav`–`save3.sav` store schema version 1, the party roster (HP, levels, XP, gear), active and reserve slots, gold, inventory and key items, story flags, cleared encounters, room, position, facing, playtime, and related story state. Written and read through a buffer. Missing or corrupt files fail safely.
- Title Continue is enabled when any slot exists and opens a load panel (location, lead level, playtime, gold) using Design's `spr_menu_panel_saves_*` when imported. New Game resets `global.game`.
- Save access: a prompt after `CV_END`, `obj_save_point` in the Greyhaven chapel and tavern (temporary tiles — still open), and an optional F5 debug key (`DEBUG_SAVE_ANYWHERE`, off by default).
- `shop_greyhaven_store` (Marda): Minor Potion and Antidote after `GH_STORE_01`–`03`. `shop_greyhaven_forge` (Pell): Iron Sword, Leather Armor, Iron Helm after `GH_SMITH_01_B` (requires the pendant). Buy / Sell / Exit with icons, PLACEHOLDER prices, quantity, gold, owned count, and equipment preview. Sell is 50% (PLACEHOLDER). Key items cannot be sold.
- Inventory (I / Tab) can use Minor Potion (PLACEHOLDER 15 HP) and Antidote (clears an overworld poison flag; battle poison is not implemented), and can equip gear. Equipment bonuses apply to battle ATK / DEF.
- Menus use the existing nine-slice windows, bitmap font, cursor, and item icons. Sprite names for upcoming Design art in `/workspace/sprites/ui/menus/` are looked up first with fallbacks. Layout constants live in `scr_menu_layout.gml`.
- Nothing in this change has been compiled or playtested in GameMaker.
