# obj_save_menu

In-game save / load slot panel (three slots: `save1.sav`–`save3.sav`). Created at runtime by `scr_save_menu_open`. Do not place in a room.

The title screen draws its own load panel in `obj_title` using the same slot helpers and (when present) `spr_menu_panel_saves_*`.

Layout constants and sprite fallbacks live in `scr_menu_layout.gml`.
