# obj_shop_menu

Shop overlay matching Design's field-menu mockups. Created at runtime by `scr_shop_open` after a shopkeeper's dialogue. Do not place in a room.

Tabs (Buy / Sell / Exit) are 40×15 strips drawn at `list_y - 12` after the list window. Left/right switches tabs. Unaffordable or unsellable rows use the greyed item icons and `spr_ui_row_select_disabled`. Key items on Sell show "--" and `spr_ui_icon_key`. Quantity (Buy, consumables only): up/down ±1, left/right ±10.

Layout constants and sprite fallbacks live in `scr_menu_layout.gml`.
