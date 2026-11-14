# obj_shop_menu

Shop overlay (Buy / Sell / Exit). Created at runtime by `scr_shop_open` after a shopkeeper's dialogue. Do not place in a room.

Uses the nine-slice windows, bitmap font, cursor, and item icons. Dedicated shop art (later, `/workspace/sprites/ui/menus/`) is looked up first via `scr_menu_sprite_window("shop")`.

Input is locked through `global.game.menu_open` while this exists.
